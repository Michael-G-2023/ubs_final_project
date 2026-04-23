`timescale 1ns / 10ps

module USB_top #(
    // parameters
) (
    // AHB Sub
    input logic clk, n_rst, hsel,
    input logic [3:0] haddr,
    input logic [1:0] htrans, hsize,
    input logic hwrite,
    input logic [31:0] hwdata,
    output logic [31:0] hrdata,
    output logic hresp, hready, d_mode
    // TX Module
    output logic dp_out, dm_out
);
    // AHB internal signals
    logic clear, store_tx_packet, get_rx_data;
    logic [7:0] rx_data, tx_data;
    // Buffer signals
    logic [6:0] buffer_occupancy;
    logic [7:0] rx_packet_data, tx_packet_data;
    logic get_tx_packet_data, store_rx_packet_data;
    // TX internal
    
    USB_ABH(.*);
    usb_
endmodule
