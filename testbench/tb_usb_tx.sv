`timescale 1ns / 10ps
/* verilator coverage_off */

module tb_usb_tx ();
    localparam CLK_PERIOD = 10ns;
    
    //INPUTS
    logic clk, n_rst;
    logic [3:0] tx_packet;
    logic [7:0] tx_packet_data;
    logic [6:0] buffer_occupancy;
    //OUTPUTS
    logic tx_error, get_tx_packet_data, tx_transfer_active, dp_out, dm_out;
    logic [4:0] state_c, count_out;
    usb_tx DUT(.*);

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
        n_rst = 1;
        
        tx_packet = '0;
        tx_packet_data = '0;
        buffer_occupancy = '0;
        
        reset_dut();


        // First task, go through normal operation. No Data. Straight to EOP.
        // IDLE
        // Okay, signals are properly set for sure. Let's go ahead an provide it with signal for tx_packet.
        // TX packet data is not needed here! Let's see if it will go through the signal properly.
        tx_packet = 4'b0010; // ACK signal
        #CLK_PERIOD; // We are now in load sync
        #CLK_PERIOD; //SYNC_OUT
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD; // FINISHED 
        // We should be finished with OUT_SYNC
        #CLK_PERIOD; // LOAD PID
        #CLK_PERIOD; // OUT_PID
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD; // FINISHED 
        #CLK_PERIOD; // LOAD_EOP
        tx_packet = 4'b0;
        #CLK_PERIOD; // OUT_EOP
        #CLK_PERIOD; // IDLE
        #CLK_PERIOD; // ERROR
        
        
        
        #CLK_PERIOD; // IDLE
        #CLK_PERIOD; // ERROR
        #CLK_PERIOD; // IDLE
        #CLK_PERIOD; // ERROR
        //tx_packet = 
        #CLK_PERIOD; // IDLE
        #CLK_PERIOD;
        reset_dut();

        // Now it is time to go ahead and go through correct operation of Data
        #CLK_PERIOD;
        tx_packet = 4'b0011;
        tx_packet_data = 8'b10011111;
        buffer_occupancy = '1;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        #CLK_PERIOD;
        $finish;
    end
endmodule

/* verilator coverage_on */



