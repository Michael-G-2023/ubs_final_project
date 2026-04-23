`timescale 1ns / 10ps

module flex_sr #(
    parameter SIZE = 8,
    parameter MSB_FIRST = 0
)(
    input logic clk, n_rst, shift_enable, load_enable, serial_in,
    input logic [SIZE - 1 : 0] parallel_in,

    output logic serial_out,
    output logic [SIZE - 1 : 0] parallel_out
    //output logic empty_flag
);
//logic [SIZE - 1 : 0] count;
/*
logic [SIZE - 1 : 0] n_parallel_out;
logic [SIZE - 1 : 0] n_count;

    always_comb begin
        empty_flag = (count >= SIZE - 1'b1) ? 1'b1 : 1'b0;
        serial_out = (MSB_FIRST == 1'b0) ? parallel_out[0] : parallel_out[SIZE - 1];

        if (load_enable) begin
            n_parallel_out = parallel_in;
            n_count = 0;
        end else if (shift_enable) begin
            n_parallel_out = (MSB_FIRST == 1'b0) ? {serial_in, parallel_out[SIZE - 1 : 1]} : {parallel_out[SIZE - 2 : 0], serial_in};
            n_count = count + 1;
        end else begin
            n_parallel_out = parallel_out;
            n_count = count;
        end
    end

    always_ff @(posedge clk, negedge n_rst) begin
        if (n_rst == 0) begin
            parallel_out <= 'b0;
            count <= '0;
        end else begin
            parallel_out <= n_parallel_out;
            count <= n_count;
        end
    end
*/
    always_ff @(posedge clk, negedge n_rst) begin
        if (n_rst == 0) begin
            parallel_out <= 'b0;
        end else if (load_enable == 1'b1) begin
            parallel_out <= parallel_in;
        end else if (shift_enable == 1'b1) begin
            // do MSB here... 
            // if LSB is SIZE-1:1, shifting to the right one, would make SIZE-2:0
            if (MSB_FIRST == 1'b0) begin
                parallel_out <= {serial_in, parallel_out[SIZE - 1 : 1]};
            end else begin
                parallel_out <= {parallel_out[SIZE - 2 : 0], serial_in};
            end
        end

        
    end
    assign serial_out = (MSB_FIRST == 1'b0) ? parallel_out[0] : parallel_out[SIZE - 1];

endmodule

