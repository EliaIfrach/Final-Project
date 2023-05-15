onbreak resume
onerror resume
vsim -voptargs=+acc work.TEST_1_CIC2_tb
add wave sim:/TEST_1_CIC2_tb/u_TEST_1_CIC2/clk
add wave sim:/TEST_1_CIC2_tb/u_TEST_1_CIC2/clk_enable
add wave sim:/TEST_1_CIC2_tb/u_TEST_1_CIC2/reset
add wave sim:/TEST_1_CIC2_tb/u_TEST_1_CIC2/filter_in
add wave sim:/TEST_1_CIC2_tb/u_TEST_1_CIC2/filter_out
add wave sim:/TEST_1_CIC2_tb/filter_out_ref
add wave sim:/TEST_1_CIC2_tb/u_TEST_1_CIC2/ce_out
run -all
