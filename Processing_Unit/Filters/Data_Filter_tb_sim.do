onbreak resume
onerror resume
vsim -voptargs=+acc work.Data_Filter_tb
add wave sim:/Data_Filter_tb/u_Data_Filter/clk
add wave sim:/Data_Filter_tb/u_Data_Filter/clk_enable
add wave sim:/Data_Filter_tb/u_Data_Filter/reset
add wave sim:/Data_Filter_tb/u_Data_Filter/filter_in
add wave sim:/Data_Filter_tb/u_Data_Filter/filter_out
add wave sim:/Data_Filter_tb/filter_out_ref
run -all
