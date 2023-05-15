onbreak resume
onerror resume
vsim -voptargs=+acc work.TESTCIC2_tb
add wave sim:/TESTCIC2_tb/u_TESTCIC2/clk
add wave sim:/TESTCIC2_tb/u_TESTCIC2/clk_enable
add wave sim:/TESTCIC2_tb/u_TESTCIC2/reset
add wave sim:/TESTCIC2_tb/u_TESTCIC2/filter_in
add wave sim:/TESTCIC2_tb/u_TESTCIC2/filter_out
add wave sim:/TESTCIC2_tb/filter_out_ref
add wave sim:/TESTCIC2_tb/u_TESTCIC2/ce_out
run -all
