`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_USB_top ();

    localparam CLK_PERIOD = 10ns;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars;
    end

    // AHB Sub
    logic clk, n_rst, hsel;
    logic [3:0] haddr;
    logic [1:0] htrans, hsize;
    logic hwrite;
    logic [31:0] hwdata;
    logic [31:0] hrdata;
    logic hresp, hready, d_mode;
    // TX Module
    logic dp_out, dm_out;
    // RX module
    logic rx_data_ready, rx_transfer_active, rx_error, flush;
    logic store_rx_packet_data;
    logic [7:0] rx_packet_data;
    logic [3:0] rx_packet;
    
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

    USB_top #() DUT (.*);

    initial begin
        n_rst = 1;
        hsel = 0;
        haddr = 0;
        htrans = 0;
        hsize = 0;
        hwrite = 0;
        hwdata = 0;
        rx_data_ready = 0;
        rx_transfer_active = 0;
        flush = 0;
        rx_packet = 0;
        rx_error = 0;
        store_rx_packet_data = 0;
        rx_packet_data = 0;
        reset_dut;

        @(negedge clk);
        
        $finish;
    end
endmodule

/* verilator coverage_on */

