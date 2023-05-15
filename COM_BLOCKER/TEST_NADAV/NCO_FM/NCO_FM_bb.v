
module NCO_FM (
	clk_clk,
	nco_fm_in_valid,
	nco_fm_in_data,
	nco_fm_out_data,
	nco_fm_out_valid,
	reset_reset_n);	

	input		clk_clk;
	input		nco_fm_in_valid;
	input	[30:0]	nco_fm_in_data;
	output	[13:0]	nco_fm_out_data;
	output		nco_fm_out_valid;
	input		reset_reset_n;
endmodule
