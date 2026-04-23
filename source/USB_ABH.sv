`timescale 1ns / 10ps

module USB_ABH #(
    // parameters
) (
    // left side of the top level diagram
    input logic clk, n_rst, hsel, hwrite,
    input logic [1:0] htrans, hsize,
    input logic [3:0] haddr,
    input logic [31:0] hwdata,
    output logic [31:0] hrdata,
    output logic hresp, hready,
    // TX signals
    input logic tx_error, tx_transfer_active,
    output logic [3:0] tx_packet,
    // Data Buffer signals
    input logic [6:0] buffer_occupancy,
    input logic [7:0] rx_data,
    output logic get_rx_data, store_tx_data,
    output logic [7:0] tx_data,
    output logic clear,
    // RX signals
    input logic rx_error,
    input logic [3:0] rx_packet,
    input logic rx_transfer_active,
    input logic rx_data_ready,
    // To top
    output logic d_mode
);
    /* verilator lint_off UNUSEDSIGNAL */
    /* verilator lint_off UNDRIVEN */
    enum logic [3:0] {DATA_BUFF = 0, STATUS = 4, ERROR = 6, BUFF_OCCUP = 8, 
        TX_PACK = 12, FLUSH = 14} regAddr;
    enum logic [15:0] {NO = 0, NEW_DATA = 1, IN = 2, OUT = 4, ACK = 8, DATA0 = 16, 
        DATA1 = 32, RECEIVING = 256, SENDING = 512} statusStates;
    enum logic [7:0] {NONE = 0, TX_DATA0 = 1, TX_DATA1 = 2, TX_ACK = 3, 
        TX_NAK = 4, TX_STALL = 5} TXStates;
    enum logic [1:0] {NOP = 0, BUSY = 1, NONSEQ = 2, SEQ = 3} transID;
    // 1 word = 4 bytes for this
    // This means that for 2 words, we need to 8 bytes or to fill the internal buffer twice
    enum logic [1:0] {ONE_BYTE = 0, TWO_BYTES = 1, ONE_WORD = 2, TWO_WORDS = 3} transSize;
    logic [31:0] data_buffer, nextDataBuff;
    logic [15:0] status_reg, error_reg, nextStatus, nextError;
    logic [7:0] buffer_occup_reg, tx_pack_reg, flush_reg;
    logic [7:0] nextBufferOccupReg, nextTXPackReg, nextFlushReg;

    // Byte_pusher variables
    logic[31:0] pushedBytes, poppedBytes;
    logic enableBytePusher, directOut;
    logic done;
    logic [1:0] size;

    USB_byte_pusher p0(.*);
    /* verilator lint_on UNUSEDSIGNAL */
    /* verilator lint_on UNDRIVEN */
    // Always FF used to update the regs
    always_ff @(posedge clk, negedge n_rst) begin: update_Regs 
        if(~n_rst) begin
            data_buffer <= '0;
            status_reg <= '0;
            error_reg <= '0;
            buffer_occup_reg <= '0;
            tx_pack_reg <= '0;
            flush_reg <= '0;
        end
        else begin
            data_buffer <= nextDataBuff;
            status_reg <= nextStatus;
            error_reg <= nextError;
            buffer_occup_reg <= nextBufferOccupReg;
            tx_pack_reg <= nextTXPackReg;
            flush_reg <= nextFlushReg;
        end
    end

    always_comb begin: assign_nextRegs
        /*  Initial values  */
        // nextStatus = status_reg;
        nextError[1:0] = {tx_error << 8, rx_error};
        nextBufferOccupReg[6:0] = buffer_occupancy;
        nextTXPackReg = 0;
        nextFlushReg = 0;
        hresp = 0;

        // hsel is used to determine if the AHB should 
        // change its current values
        if(hsel) begin
            // First, we check if HWData is being used to write 
            // to the regs.
            // Check if this is an write operation or not
            if(hwrite) begin
                case(haddr)
                    STATUS: begin
                        nextTXPackReg = 0;
                        nextFlushReg = 0;
                        hresp = 1;
                    end
                    ERROR: begin
                        nextTXPackReg = 0;
                        nextFlushReg = 0;
                        hresp = 1;
                    end
                    BUFF_OCCUP: begin
                        nextTXPackReg = 0;
                        nextFlushReg = 0;
                        hresp = 1;
                    end
                    TX_PACK: begin
                        nextTXPackReg = hwdata[7:0];
                        nextFlushReg = 0;
                        hresp = 0;
                    end
                    FLUSH: begin
                        nextTXPackReg = 0;
                        nextFlushReg[0] = |hwdata;
                        hresp = 0;
                    end
                    default: begin
                        nextTXPackReg = 0;
                        nextFlushReg = 0;
                        hresp = 0;
                    end
                endcase
            end
        end
    end

    always_comb begin: readRegs
        hrdata = 0;
        if(hsel) begin
            // Read operation
            if(~hwrite) begin
                case(haddr)
                    DATA_BUFF: begin
                        hrdata = data_buffer;
                    end 
                    STATUS: begin
                        hrdata[15:0] = status_reg;
                    end
                    ERROR: begin
                        hrdata[15:0] = error_reg;
                    end
                    BUFF_OCCUP: begin
                        hrdata[7:0] = buffer_occup_reg;
                    end
                    TX_PACK: begin
                        hrdata[7:0] = tx_pack_reg;
                    end
                    FLUSH: begin
                        hrdata[7:0] = flush_reg;
                    end
                    default: begin
                        hrdata = 0;
                    end
                endcase
            end
        end
    end

    always_comb begin: write_internalDB
        // Note, using RX_Data and TX_Data, 
        // the AHB can receive and send data to the buffer

        // Data going in -> controlled by RX packet
        // Data going out -> controlled by TX reg
        nextDataBuff = 0;
        pushedBytes = 0;
        enableBytePusher = 0;
        size = 0;
        directOut = 0;
        if(hsel) begin
            if(haddr == DATA_BUFF && done && hwrite) begin
                nextDataBuff = hwdata;
            end

            // If the status is NEW_DATA, it should read it
            else if(~hwrite && data_buffer == 32'b0 && status_reg == NEW_DATA) begin
                nextDataBuff = poppedBytes;
                enableBytePusher = 1;
                size = hsize;
            end 

            // OUT means the AHB needs to send data to the data_buffer
            else if(~hwrite && data_buffer > 32'b0 && rx_data_ready) begin
                directOut = 1;
                pushedBytes = data_buffer;
                enableBytePusher = 1;
                size = hsize;
            end
        end
    end

    // Update status according to the value of rx_packet
    always_comb begin: updateStatus 
        nextStatus = NO;
        if(rx_data_ready) begin
            nextStatus = NEW_DATA;
        end
        else if(rx_packet == 4'b0001) begin
            nextStatus = OUT;
        end
        else if(rx_packet == 4'b1001) begin
            nextStatus = IN;
        end
        else if(rx_packet == 4'b0011) begin
            nextStatus = DATA0;
        end
        else if(rx_packet == 4'b1011) begin
            nextStatus = DATA1;
        end
        else if(rx_transfer_active) begin
            nextStatus = RECEIVING;
        end
        else if(tx_transfer_active) begin
            nextStatus = SENDING;
        end
    end

    always_comb begin: boss_TXAround
        // Use htrans' value
        // Since hburst is unused, only values 0 and 2 are meaningful
        // htrans = 0 -> no action
        // htrans = 2 -> just one
        tx_packet = 0;
        if(htrans == NOP) begin
            tx_packet = 4'b0000;
        end
        else if(htrans == NONSEQ) begin
            case (tx_pack_reg)
                TX_DATA0: begin
                    tx_packet = 4'd3;
                end
                TX_DATA1: begin
                    tx_packet = 4'd11;
                end
                TX_ACK: begin
                    tx_packet = 4'd2;
                end
                TX_NAK: begin
                    tx_packet = 4'd10;
                end
                TX_STALL: begin
                    tx_packet = 4'd14;
                end
                default: begin
                    tx_packet = 4'hf;
                end
            endcase
        end
    end

    always_comb begin: assign_DMode
        // Zero is idle or we are receiving
        d_mode = 0;

        // We are in output mode
        if(tx_transfer_active) begin
            d_mode = 1;
        end
    end

    always_comb begin: assign_hready
        hready = 1;
        if(tx_transfer_active) begin
            hready = 0;
        end
        if(rx_data_ready) begin
            hready = 0;
        end
        if(status_reg != NO) begin
            hready = 0;
        end
    end

    always_comb begin: outputClear
        clear = |flush_reg;
    end
endmodule
