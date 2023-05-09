
module NCO_IQ (
	clk_clk,
	nco_iq_in_valid,
	nco_iq_in_data,
	nco_iq_out_data,
	nco_iq_out_valid,
	reset_reset_n);	

	input		clk_clk;
	input		nco_iq_in_valid;
	input	[14:0]	nco_iq_in_data;
	output	[27:0]	nco_iq_out_data;
	output		nco_iq_out_valid;
	input		reset_reset_n;
endmodule
