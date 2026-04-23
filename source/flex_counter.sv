`timescale 1ns / 10ps

module flex_counter #(
    parameter SIZE = 8
) (
    input logic clk, n_rst, clear, count_enable,
    input logic [SIZE - 1 : 0] rollover_val,
    output logic [SIZE - 1 : 0] count_out,
    output logic rollover_flag
);
    
    
    
    
    logic [SIZE - 1: 0] next_count;
    logic next_flag;

    // Next State and Next Flag comb logic
    always_comb begin
        
        next_count = count_out;
        next_flag = (next_count == rollover_val) ? 1'b1 : 1'b0;
        
        if (clear) begin
            next_count = '0;
            next_flag = 1'b0;
        end else if (count_enable) begin 
            if (next_count >= rollover_val) begin
                next_count = 'd0;
                next_flag = (next_count == rollover_val) ? 1'b1 : 1'b0;
            end else begin
                next_count = count_out + 1'b1;
                next_flag = (next_count == rollover_val) ? 1'b1 : 1'b0;
            end
        end
    end

    // FF

    always_ff @(posedge clk, negedge n_rst) begin
        if(!n_rst) begin
            count_out <= '0;
            rollover_flag <= 1'b0;
        end else begin
            count_out <= next_count;
            rollover_flag <= next_flag;
        end
    end

endmodule

