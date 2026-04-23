`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_usb_buffer ();
    localparam CLK_PERIOD = 10ns;
    //INPUTS
    logic clk, n_rst, flush, get_rx_data, store_tx_data, clear, get_tx_packet_data, store_rx_packet_data;
    logic [7:0] tx_data, rx_packet_data;

    //OUTPUTS
    logic buffer_full;
    logic [6:0] buffer_occupancy;
    logic [7:0] rx_data, tx_packet_data;
    

    usb_buffer DUT (.*);
    
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
        @(negedge clk);
        @(negedge clk);
    end
    endtask


    initial begin
        n_rst = '1;
        flush = '0;
        get_rx_data = '0;
        store_tx_data = '0;
        clear = '0;
        get_tx_packet_data = '0;
        store_rx_packet_data = '0;
        tx_data = '0;
        rx_packet_data = '0;
        reset_dut();

        // Let's go ahead an run some clk cycles. 

        #CLK_PERIOD;
        #CLK_PERIOD;

        
        // This proves that inputting through tx_data is valid
        tx_data = 8'd1;
        store_tx_data = '1;
        #CLK_PERIOD;

        // This proves that inputting through rx_packet_data is valid
        store_tx_data = '0; // turn ts off
        rx_packet_data = 8'd11;
        store_rx_packet_data = '1;
        #CLK_PERIOD;

        // wait a little.
        // Currently, we should be at 2 in buffer occupancy
        store_rx_packet_data = '0;
        #CLK_PERIOD;

        // plan is to now add tx_data till full.
        store_tx_data = '1;
        #CLK_PERIOD; // 3
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD; // 10
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD; // 20
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD; // 30
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD; // 40
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD; // 50
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD; // 60
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        // We should be full now...
        #CLK_PERIOD;
        // test overwrite. does this write?
        store_tx_data = '0;
        #CLK_PERIOD;
        get_tx_packet_data = 1'b1;
        #CLK_PERIOD; // should output '1
        #CLK_PERIOD; // should output 'd11
        get_tx_packet_data = '0;
        get_rx_data = '1;
        #CLK_PERIOD; // should output 'd1
        get_rx_data = '0;
        #CLK_PERIOD; // FINISH. We should have a buffer occupancy of 61.
        // Currently, w_reg is at 0, r_reg is at 3. 64 - 3 = 61. Correct.
        // What we need to see is if the flag goes back high by writing to it 3 more times. 
        // Let's use tx bc why not. 
        tx_data = 8'd66;
        store_tx_data = '1;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD; // we should be back to 64.
        #CLK_PERIOD;
        #CLK_PERIOD; // we tried to overwrite.
        store_tx_data = '0;
        #CLK_PERIOD;
        #CLK_PERIOD; 
        // FINISHED WE ARE ALL GOOD :D
        $finish;
    end
endmodule

/* verilator coverage_on */

