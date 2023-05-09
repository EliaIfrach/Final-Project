onbreak resume
onerror resume
vsim -voptargs=+acc work.CIC2_tb
add wave sim:/CIC2_tb/u_CIC2/clk
add wave sim:/CIC2_tb/u_CIC2/clk_enable
add wave sim:/CIC2_tb/u_CIC2/reset
add wave sim:/CIC2_tb/u_CIC2/filter_in
add wave sim:/CIC2_tb/u_CIC2/filter_out
add wave sim:/CIC2_tb/filter_out_ref
add wave sim:/CIC2_tb/u_CIC2/ce_out
run -all
