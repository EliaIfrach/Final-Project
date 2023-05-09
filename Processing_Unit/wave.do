onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /data_mux_component/i_clk
add wave -noupdate /data_mux_component/i_rst
add wave -noupdate /data_mux_component/i_TX_Active
add wave -noupdate /data_mux_component/i_Data
add wave -noupdate /data_mux_component/i_RX_Data
add wave -noupdate /data_mux_component/o_Uart_Data
add wave -noupdate /data_mux_component/o_Ram_Index
add wave -noupdate /data_mux_component/o_TX_DV
add wave -noupdate /data_mux_component/o_save_data
add wave -noupdate /data_mux_component/state
add wave -noupdate /data_mux_component/r_Ram_index
add wave -noupdate /data_mux_component/r_Ram_Data
add wave -noupdate /data_mux_component/r_Data_index
add wave -noupdate /data_mux_component/r_flag_data
add wave -noupdate /data_mux_component/r_Data_Divider
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10347660 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 251
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {10340455 ps} {10347660 ps}
