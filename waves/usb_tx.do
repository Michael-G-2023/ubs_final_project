onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider INPUTS
add wave -noupdate /tb_usb_tx/clk
add wave -noupdate /tb_usb_tx/n_rst
add wave -noupdate /tb_usb_tx/tx_packet
add wave -noupdate /tb_usb_tx/tx_packet_data
add wave -noupdate /tb_usb_tx/buffer_occupancy
add wave -noupdate -divider {OUT SIGNALS}
add wave -noupdate /tb_usb_tx/tx_error
add wave -noupdate /tb_usb_tx/get_tx_packet_data
add wave -noupdate /tb_usb_tx/tx_transfer_active
add wave -noupdate -divider {ENCODED SIGNAL}
add wave -noupdate /tb_usb_tx/dp_out
add wave -noupdate /tb_usb_tx/dm_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{PROPER RUN NO DATA} {44694 ps} 1} {{CORRECT OPERATION DATA} {365000 ps} 1} {{END NO DATA} {265000 ps} 1} {{END 1 DATA} {706469 ps} 1} {{START DATA + 0} {815722 ps} 1} {{END DATA ERROR} {1027361 ps} 1} {{MANY MANY DATA} {1131221 ps} 1} {{MANY MANY DATA END} {1961410 ps} 1}
quietly wave cursor active 5
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
WaveRestoreZoom {0 ps} {2079 ns}
