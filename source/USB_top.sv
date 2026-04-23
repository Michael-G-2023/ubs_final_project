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
    output logic hresp, hready, d_mode,
    // TX Module
    output logic dp_out, dm_out,
    // RX module
    input logic rx_data_ready, rx_transfer_active, rx_error, flush,
    input logic [3:0] rx_packet,
    input logic store_rx_packet_data,
    input logic [7:0] rx_packet_data
);
    // AHB internal signals
    logic clear, get_rx_data;
    logic [7:0] rx_data, tx_data;
    // Buffer signals
    logic [6:0] buffer_occupancy;
    logic [7:0] tx_packet_data;
    logic get_tx_packet_data;
    logic store_tx_data;
    logic buffer_full;
    // TX internal
    logic tx_error, tx_transfer_active;
    logic [3:0] tx_packet;
    logic [4:0] count_out, state_c;
    USB_ABH a0(.*);
    usb_buffer b0(.*);
    usb_tx t0 (.*);
endmodule
