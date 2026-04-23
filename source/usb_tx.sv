`timescale 1ns / 10ps

module usb_tx (
    input logic clk, n_rst, 
    input logic [3:0] tx_packet,
    input logic [7:0] tx_packet_data,
    input logic [6:0] buffer_occupancy,
    output logic tx_error, get_tx_packet_data, tx_transfer_active, dp_out, dm_out, 
    output logic [4:0] count_out, state_c
);

//logic [4:0] count_out;
logic count_enable, shift_enable, load_enable, eop_signal, empty, serial_out, d_tx_packet;
logic [7:0] parallel_in;
// COUNTER SYSTEM

    flex_counter #(  
            .SIZE(5)
        ) OUTRATE (
            .clk(clk), 
            .n_rst(n_rst), 
            .count_enable(1'b1), 
            .rollover_val(5'd24), 
            .count_out(count_out), 
            /* verilator lint_off PINCONNECTEMPTY */
            .clear(), 
            .rollover_flag()
            /* verilator lint_on PINCONNECTEMPTY */
            );

// reset encoder to target rate.
logic count_reset;
assign count_reset = (count_out == 5'd7) ? 1'b1 : (count_out == 5'd15) ? 1'b1 : (count_out == 5'd24) ? 1'b1 : 1'b0;

//SHIFT REGISTER
    flex_sr #(
            .SIZE(8),
            .MSB_FIRST(1)
        ) SHIFT_REG (
            .clk(clk),
            .n_rst(n_rst),
            .shift_enable(shift_enable),
            .load_enable(load_enable),
            .parallel_in(parallel_in),
            .serial_out(serial_out),
            
            /* verilator lint_off PINCONNECTEMPTY */
            .serial_in(),
            .parallel_out()
            /* verilator lint_on PINCONNECTEMPTY */
            //.empty_flag(empty)
        );
    flex_counter #(  
            .SIZE(5)
    ) COUNTER_SR (
            .clk(clk), 
            .n_rst(n_rst), 
            .count_enable(count_enable), 
            .rollover_val(5'd8), 
            .rollover_flag(empty),
            /* verilator lint_off PINCONNECTEMPTY */
            .count_out(),
            .clear()
            /* verilator lint_on PINCONNECTEMPTY */
            );
    
// STATE CONTROL
// 10 states = b1010
typedef enum logic [4:0] { 
    IDLE,
    LOAD_SYNC,
    OUT_SYNC,
    LOAD_PID,
    OUT_PID,
    LOAD_DATA,
    OUT_DATA,
    LOAD_EOP,
    OUT_EOP,
    ERROR
} tx_states;


typedef enum logic [3:0] {
    DATA0 = 4'b0011,
    I_DATA0 = 4'b1100,
    DATA1 = 4'b1011,
    I_DATA1 = 4'b0100,
    ACK = 4'b0010,
    I_ACK = 4'b1101,
    NAK = 4'b1010,
    I_NAK = 4'b0101,
    STALL = 4'b1110,
    I_STALL = 4'b0001
} packets;

tx_states next_state, state;



logic tx_packet_valid;
// check correct tx packet
assign tx_packet_valid = (tx_packet == DATA0) ? 1'b1 : (tx_packet == DATA1) ? 1'b1 : (tx_packet == ACK) ? 1'b1 : (tx_packet == NAK) ? 1'b1 : (tx_packet == STALL) ? 1'b1 : 1'b0;

// STATE values to pass
always_comb begin
    tx_transfer_active = 1'b0;
    count_enable = 1'b0;
    shift_enable = 1'b0;
    tx_error = 1'b0;
    get_tx_packet_data = 1'b0;
    load_enable = 1'b0;
    parallel_in = '0;
    eop_signal = '0;
    
    case (state)
        IDLE: begin
            tx_transfer_active = 1'b0;
            count_enable = 1'b0;
            shift_enable = 1'b0;
            tx_error = 1'b0;
            get_tx_packet_data = 1'b0;
            load_enable = 1'b0;
            parallel_in = '0;
            eop_signal = 1'b0;
        end
        LOAD_SYNC: begin
            tx_transfer_active = 1'b1;
            count_enable = 1'b0;
            shift_enable = 1'b0;
            tx_error = 1'b0;
            get_tx_packet_data = 1'b0;
            load_enable = 1'b1;
            parallel_in = 8'b00000001;
            eop_signal = 1'b0;
        end
        OUT_SYNC: begin
            tx_transfer_active = 1'b1;
            count_enable = 1'b1;
            shift_enable = 1'b1;
            tx_error = 1'b0;
            get_tx_packet_data = 1'b0;
            load_enable = 1'b0;
            parallel_in = 8'b00000001;
            eop_signal = 1'b0;
        end
        LOAD_PID: begin
            tx_transfer_active = 1'b1;
            count_enable = 1'b0;
            shift_enable = 1'b0;
            tx_error = 1'b0;
            get_tx_packet_data = 1'b0;
            load_enable = 1'b1;
            parallel_in = {tx_packet, ~tx_packet};
            eop_signal = 1'b0;

        end
        OUT_PID: begin
            tx_transfer_active = 1'b1;
            count_enable = 1'b1;
            shift_enable = 1'b1;
            tx_error = 1'b0;
            get_tx_packet_data = 1'b0;
            load_enable = 1'b0;
            parallel_in = {tx_packet, ~tx_packet};
            eop_signal = 1'b0;

        end
        ERROR: begin
            tx_transfer_active = 1'b0;
            count_enable = 1'b0;
            shift_enable = 1'b0;
            tx_error = 1'b1;
            get_tx_packet_data = 1'b0;
            load_enable = 1'b0;
            parallel_in = '0;
            eop_signal = 1'b0;

        end
        LOAD_DATA: begin
            tx_transfer_active = 1'b1;
            count_enable = 1'b0;
            shift_enable = 1'b0;
            tx_error = 1'b0;
            get_tx_packet_data = 1'b1;
            load_enable = 1'b1;
            parallel_in = tx_packet_data;
            eop_signal = 1'b0;

        end
        OUT_DATA: begin
            tx_transfer_active = 1'b1;
            count_enable = 1'b1;
            shift_enable = 1'b1;
            tx_error = 1'b0;
            get_tx_packet_data = 1'b0;
            load_enable = 1'b0;
            parallel_in = '0;
            eop_signal = 1'b0;

        end

        LOAD_EOP: begin
            tx_transfer_active = 1'b1;
            count_enable = 1'b0;
            shift_enable = 1'b0;
            tx_error = 1'b0;
            get_tx_packet_data = 1'b0;
            load_enable = '0;
            parallel_in = '0;
            eop_signal = 1'b1;

        end
        OUT_EOP: begin
            tx_transfer_active = 1'b1;
            count_enable = 1'b0;
            shift_enable = 1'b0;
            tx_error = 1'b0;
            get_tx_packet_data = 1'b0;
            load_enable = 1'b0;
            parallel_in = '0;
            eop_signal = 1'b1;

        end
        default: begin
            tx_transfer_active = 1'b0;
            count_enable = 1'b0;
            shift_enable = 1'b0;
            tx_error = 1'b0;
            get_tx_packet_data = 1'b0;
            load_enable = 1'b0;
            parallel_in = '0;
            eop_signal = 1'b0;

        end
    endcase
end



// what we want here is to determine that the TX_PACKET produces a valid signal. ie make sure that is either Data0 or DATA1

assign d_tx_packet = (tx_packet == DATA0) ? 1'b1: (tx_packet == DATA1) ? 1'b1: 1'b0; 

// NEXT STATE MACHINE LOGIC
// Funny enough, since EOP needs both signals low for 2, we do not need a load_enable -- we have 2 states of EOP. Just make it so when flag is high, output is low for both.
assign state_c = state;
always_comb begin
    next_state = state;

    case(state)
        IDLE: begin
            if (tx_packet_valid) begin
                next_state = LOAD_SYNC;
            end else begin
                next_state = ERROR;
            end
        end
        LOAD_SYNC: begin
            next_state = OUT_SYNC;
        end
        OUT_SYNC: begin
            if (empty) begin
                next_state = LOAD_PID;
            end else begin
                next_state = OUT_SYNC;
            end
        end
        LOAD_PID: begin
            next_state = OUT_PID;
        end
        OUT_PID: begin 
            if (empty && (d_tx_packet == 1'b1) && (buffer_occupancy == '0)) begin
                next_state = ERROR;
            end else if (empty && d_tx_packet == 1'b1) begin
                next_state = LOAD_DATA;
            end else if (empty && d_tx_packet == 1'b0) begin
                next_state = LOAD_EOP; // from my state diagram, this is the only option. 1, 2, and 3 correspond to the ERROR DATA and EOP 
            end else begin
                next_state = OUT_PID;
            end
        end
        ERROR: begin
            next_state = IDLE;
        end
        LOAD_DATA: begin 
            next_state = OUT_DATA;
        end
        OUT_DATA: begin
            if (empty) begin
                if(buffer_occupancy > 0) begin
                    next_state = LOAD_DATA;
                end else if (buffer_occupancy == 0) begin
                    next_state = LOAD_EOP;
                end
            end else begin
                next_state = OUT_DATA;
            end
        end
        LOAD_EOP: begin
            next_state = OUT_EOP;
        end
        OUT_EOP: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// FF for next state 
/*
always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end
*/


// ENCODER

logic n_dp_out, n_dm_out;

// we need to decide how to handle EOP terms. 
// SOLUTION -- Create flag, if flag is present, make sure that n_dp_out and n_dm_out go low for 2 cycles 

always_comb begin
    n_dm_out = dm_out;
    n_dp_out = dp_out;
    
    if (eop_signal) begin
        n_dm_out = 1'b0; // epihpany. What if, we just assumed, yea hey these need to go back to normal. 
        n_dp_out = 1'b0;
    end else begin
        // we only need these assigned here. No reason to potentially confuse our encoder.
        if (shift_enable) begin
            if (serial_out) begin
                n_dp_out = dp_out;
                n_dm_out = dm_out;
            end else begin
                n_dp_out = ~dp_out;
                n_dm_out = ~dm_out;
            end
        end else begin
            n_dp_out = dp_out;
            n_dm_out = dm_out;
        end
    end
end

// FF for the encoder -- seperate from the state machine
always_ff @(posedge clk, negedge n_rst) begin
    if (!n_rst) begin
        dp_out <= 1'b1;
        dm_out <= 1'b0;
        state <= IDLE;
    end else if (count_reset) begin
        dp_out <= 1'b1;
        dm_out <= 1'b0;
        state <= next_state;
    end else begin
        dp_out <= n_dp_out;
        dm_out <= n_dm_out;
        state <= next_state;
    end
end


endmodule
