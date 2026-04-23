onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {AHB Inputs} -radix unsigned /tb_USB_top/DUT/clk
add wave -noupdate -expand -group {AHB Inputs} -radix unsigned /tb_USB_top/DUT/n_rst
add wave -noupdate -expand -group {AHB Inputs} -radix unsigned /tb_USB_top/DUT/hsel
add wave -noupdate -expand -group {AHB Inputs} -radix unsigned /tb_USB_top/DUT/haddr
add wave -noupdate -expand -group {AHB Inputs} -radix unsigned /tb_USB_top/DUT/htrans
add wave -noupdate -expand -group {AHB Inputs} -radix unsigned /tb_USB_top/DUT/hsize
add wave -noupdate -expand -group {AHB Inputs} -radix unsigned /tb_USB_top/DUT/hwrite
add wave -noupdate -expand -group {AHB Inputs} -radix unsigned /tb_USB_top/DUT/hwdata
add wave -noupdate -expand -group Outputs -radix unsigned /tb_USB_top/DUT/hrdata
add wave -noupdate -expand -group Outputs -radix unsigned /tb_USB_top/DUT/hresp
add wave -noupdate -expand -group Outputs -radix unsigned /tb_USB_top/DUT/hready
add wave -noupdate -expand -group Outputs -radix unsigned /tb_USB_top/DUT/d_mode
add wave -noupdate -expand -group Outputs -radix unsigned /tb_USB_top/DUT/dp_out
add wave -noupdate -expand -group Outputs -radix unsigned /tb_USB_top/DUT/dm_out
add wave -noupdate -expand -group {RX Inputs} -radix unsigned /tb_USB_top/DUT/rx_data_ready
add wave -noupdate -expand -group {RX Inputs} -radix unsigned /tb_USB_top/DUT/rx_transfer_active
add wave -noupdate -expand -group {RX Inputs} -radix unsigned /tb_USB_top/DUT/rx_error
add wave -noupdate -expand -group {RX Inputs} -radix unsigned /tb_USB_top/DUT/flush
add wave -noupdate -expand -group {RX Inputs} -radix unsigned /tb_USB_top/DUT/rx_packet
add wave -noupdate -expand -group Internals -radix unsigned /tb_USB_top/DUT/clear
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/get_rx_data
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/rx_data
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/tx_data
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/buffer_occupancy
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/tx_packet_data
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/get_tx_packet_data
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/store_tx_data
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/buffer_full
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/tx_error
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/tx_transfer_active
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/tx_packet
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/count_out
add wave -noupdate -expand -group Internals /tb_USB_top/DUT/state_c
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {42 ns}
