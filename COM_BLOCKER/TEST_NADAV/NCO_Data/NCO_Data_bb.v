
module NCO_Data (
	clk_clk,
	nco_data_in_valid,
	nco_data_in_data,
	nco_data_out_data,
	nco_data_out_valid,
	reset_reset_n);	

	input		clk_clk;
	input		nco_data_in_valid;
	input	[14:0]	nco_data_in_data;
	output	[9:0]	nco_data_out_data;
	output		nco_data_out_valid;
	input		reset_reset_n;
endmodule
