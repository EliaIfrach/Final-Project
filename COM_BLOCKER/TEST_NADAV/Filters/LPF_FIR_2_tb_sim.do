onbreak resume
onerror resume
vsim -voptargs=+acc work.LPF_FIR_2_tb
add wave sim:/LPF_FIR_2_tb/u_LPF_FIR_2/clk
add wave sim:/LPF_FIR_2_tb/u_LPF_FIR_2/clk_enable
add wave sim:/LPF_FIR_2_tb/u_LPF_FIR_2/reset
add wave sim:/LPF_FIR_2_tb/u_LPF_FIR_2/filter_in
add wave sim:/LPF_FIR_2_tb/u_LPF_FIR_2/filter_out
add wave sim:/LPF_FIR_2_tb/filter_out_ref
run -all
