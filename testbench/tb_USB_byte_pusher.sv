`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_USB_byte_pusher ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    logic clk, n_rst;
    logic [31:0] pushedBytes;
    logic [31:0] poppedBytes;
    logic enableBytePusher, directOut;
    logic done;
    logic [1:0] size;
    logic [7:0] rx_packet;
    logic [7:0] tx_packet;
    logic store_tx_packet, get_rx_data;

    // clockgen
    always begin
        clk = 0;
        #(CLK_PERIOD / 2.0);
        clk = 1;
        #(CLK_PERIOD / 2.0);
    end

    task reset_dut;
    begin
        n_rst = 0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        n_rst = 1;
        @(posedge clk);
        @(posedge clk);
    end
    endtask

    USB_byte_pusher #() DUT (.*);

    initial begin
        n_rst = 1;

        reset_dut;

        $finish;
    end
endmodule

/* verilator coverage_on */

