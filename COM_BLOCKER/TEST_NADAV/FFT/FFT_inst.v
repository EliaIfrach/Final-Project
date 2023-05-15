	FFT u0 (
		.clk_clk                       (<connected-to-clk_clk>),                       //             clk.clk
		.reset_reset_n                 (<connected-to-reset_reset_n>),                 //           reset.reset_n
		.fft_comp_sink_valid           (<connected-to-fft_comp_sink_valid>),           //   fft_comp_sink.valid
		.fft_comp_sink_ready           (<connected-to-fft_comp_sink_ready>),           //                .ready
		.fft_comp_sink_error           (<connected-to-fft_comp_sink_error>),           //                .error
		.fft_comp_sink_startofpacket   (<connected-to-fft_comp_sink_startofpacket>),   //                .startofpacket
		.fft_comp_sink_endofpacket     (<connected-to-fft_comp_sink_endofpacket>),     //                .endofpacket
		.fft_comp_sink_data            (<connected-to-fft_comp_sink_data>),            //                .data
		.fft_comp_source_valid         (<connected-to-fft_comp_source_valid>),         // fft_comp_source.valid
		.fft_comp_source_ready         (<connected-to-fft_comp_source_ready>),         //                .ready
		.fft_comp_source_error         (<connected-to-fft_comp_source_error>),         //                .error
		.fft_comp_source_startofpacket (<connected-to-fft_comp_source_startofpacket>), //                .startofpacket
		.fft_comp_source_endofpacket   (<connected-to-fft_comp_source_endofpacket>),   //                .endofpacket
		.fft_comp_source_data          (<connected-to-fft_comp_source_data>)           //                .data
	);

