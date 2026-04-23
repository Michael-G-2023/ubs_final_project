`timescale 1ns / 10ps

module USB_byte_pusher #(
    // parameters
) (
    input logic clk, n_rst,
    input logic [31:0] pushedBytes,
    output logic [31:0] poppedBytes,
    input logic enableBytePusher, directOut,
    output logic done,
    input logic [1:0] size,
    input logic [7:0] rx_data,
    output logic [7:0] tx_data,
    output logic store_tx_data, get_rx_data
);
    logic [31:0] regPushedBytes, regPoppedBytes;
    logic [31:0] nextPushedBytes, nextPoppedBytes;
    logic [1:0] count, nextCount;
    logic nextDone, nextStoreTX, nextGetRX;
    logic [7:0] nextTXPack;
    logic [31:0] shifted;
    always_ff @(posedge clk, negedge n_rst) begin: update
        if(~n_rst) begin
            done <= 1;
            regPoppedBytes <= 0;
            regPushedBytes <= pushedBytes;
            count <= 0;
            tx_data <= 0;
            store_tx_data <= 0;
            get_rx_data <= 0;
        end
        else begin
            regPoppedBytes <= nextPoppedBytes;
            regPushedBytes <= nextPushedBytes;
            count <= nextCount;
            done <= nextDone;
            tx_data <= nextTXPack;
            get_rx_data <= nextGetRX;
            store_tx_data <= nextStoreTX;
        end
    end

    always_comb begin: checkEnable
        nextStoreTX = 0;
        nextGetRX = 0;
        nextTXPack = 8'b0;
        nextDone = done;
        nextCount = count;
        nextPushedBytes = regPushedBytes;
        nextPoppedBytes = regPoppedBytes;
        poppedBytes = 0;
        shifted = 0;

        if(enableBytePusher) begin
            if(directOut && count < size) begin
                nextStoreTX = 1;
                nextTXPack = regPushedBytes[7:0];
                nextPushedBytes = regPushedBytes >> 8;
                nextCount = count + 1;
                nextDone = 0;
            end
            else if(directOut && count >= size) begin
                nextStoreTX = 0;
                nextTXPack =  8'b0;
                nextPushedBytes = 0;
                nextCount = 0;
                nextDone = 1;
            end
            else if(~directOut && count < size) begin
                nextGetRX = 1;
                shifted = {regPoppedBytes[23:0] << 8, rx_data};
                nextPoppedBytes = shifted;
                nextDone = 0;
                nextCount = count + 1;
            end
            else if(~directOut && count >= size) begin
                nextDone = 1;
                nextPoppedBytes = 0;
                poppedBytes = regPoppedBytes;
            end
        end
    end
endmodule
