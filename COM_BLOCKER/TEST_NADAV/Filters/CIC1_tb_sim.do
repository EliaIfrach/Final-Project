onbreak resume
onerror resume
vsim -voptargs=+acc work.CIC1_tb
add wave sim:/CIC1_tb/u_CIC1/clk
add wave sim:/CIC1_tb/u_CIC1/clk_enable
add wave sim:/CIC1_tb/u_CIC1/reset
add wave sim:/CIC1_tb/u_CIC1/filter_in
add wave sim:/CIC1_tb/u_CIC1/filter_out
add wave sim:/CIC1_tb/filter_out_ref
add wave sim:/CIC1_tb/u_CIC1/ce_out
run -all
