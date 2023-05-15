onbreak resume
onerror resume
vsim -voptargs=+acc work.CIC1_V5_tb
add wave sim:/CIC1_V5_tb/u_CIC1_V5/clk
add wave sim:/CIC1_V5_tb/u_CIC1_V5/clk_enable
add wave sim:/CIC1_V5_tb/u_CIC1_V5/reset
add wave sim:/CIC1_V5_tb/u_CIC1_V5/filter_in
add wave sim:/CIC1_V5_tb/u_CIC1_V5/filter_out
add wave sim:/CIC1_V5_tb/filter_out_ref
add wave sim:/CIC1_V5_tb/u_CIC1_V5/ce_out
run -all
