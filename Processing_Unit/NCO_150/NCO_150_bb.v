
module NCO_150 (
	clk_clk,
	nco_150_in_valid,
	nco_150_in_data,
	nco_150_out_data,
	nco_150_out_valid,
	reset_reset_n);	

	input		clk_clk;
	input		nco_150_in_valid;
	input	[12:0]	nco_150_in_data;
	output	[9:0]	nco_150_out_data;
	output		nco_150_out_valid;
	input		reset_reset_n;
endmodule
