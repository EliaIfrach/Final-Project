
module FM_FFT (
	clk_clk,
	fft_ii_0_sink_valid,
	fft_ii_0_sink_ready,
	fft_ii_0_sink_error,
	fft_ii_0_sink_startofpacket,
	fft_ii_0_sink_endofpacket,
	fft_ii_0_sink_data,
	fft_ii_0_source_valid,
	fft_ii_0_source_ready,
	fft_ii_0_source_error,
	fft_ii_0_source_startofpacket,
	fft_ii_0_source_endofpacket,
	fft_ii_0_source_data,
	reset_reset_n);	

	input		clk_clk;
	input		fft_ii_0_sink_valid;
	output		fft_ii_0_sink_ready;
	input	[1:0]	fft_ii_0_sink_error;
	input		fft_ii_0_sink_startofpacket;
	input		fft_ii_0_sink_endofpacket;
	input	[42:0]	fft_ii_0_sink_data;
	output		fft_ii_0_source_valid;
	input		fft_ii_0_source_ready;
	output	[1:0]	fft_ii_0_source_error;
	output		fft_ii_0_source_startofpacket;
	output		fft_ii_0_source_endofpacket;
	output	[65:0]	fft_ii_0_source_data;
	input		reset_reset_n;
endmodule
