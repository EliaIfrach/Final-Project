
module FFT (
	clk_clk,
	reset_reset_n,
	fft_comp_sink_valid,
	fft_comp_sink_ready,
	fft_comp_sink_error,
	fft_comp_sink_startofpacket,
	fft_comp_sink_endofpacket,
	fft_comp_sink_data,
	fft_comp_source_valid,
	fft_comp_source_ready,
	fft_comp_source_error,
	fft_comp_source_startofpacket,
	fft_comp_source_endofpacket,
	fft_comp_source_data);	

	input		clk_clk;
	input		reset_reset_n;
	input		fft_comp_sink_valid;
	output		fft_comp_sink_ready;
	input	[1:0]	fft_comp_sink_error;
	input		fft_comp_sink_startofpacket;
	input		fft_comp_sink_endofpacket;
	input	[41:0]	fft_comp_sink_data;
	output		fft_comp_source_valid;
	input		fft_comp_source_ready;
	output	[1:0]	fft_comp_source_error;
	output		fft_comp_source_startofpacket;
	output		fft_comp_source_endofpacket;
	output	[58:0]	fft_comp_source_data;
endmodule
