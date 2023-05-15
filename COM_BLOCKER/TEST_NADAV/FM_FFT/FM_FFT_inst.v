	FM_FFT u0 (
		.clk_clk                       (<connected-to-clk_clk>),                       //             clk.clk
		.fft_ii_0_sink_valid           (<connected-to-fft_ii_0_sink_valid>),           //   fft_ii_0_sink.valid
		.fft_ii_0_sink_ready           (<connected-to-fft_ii_0_sink_ready>),           //                .ready
		.fft_ii_0_sink_error           (<connected-to-fft_ii_0_sink_error>),           //                .error
		.fft_ii_0_sink_startofpacket   (<connected-to-fft_ii_0_sink_startofpacket>),   //                .startofpacket
		.fft_ii_0_sink_endofpacket     (<connected-to-fft_ii_0_sink_endofpacket>),     //                .endofpacket
		.fft_ii_0_sink_data            (<connected-to-fft_ii_0_sink_data>),            //                .data
		.fft_ii_0_source_valid         (<connected-to-fft_ii_0_source_valid>),         // fft_ii_0_source.valid
		.fft_ii_0_source_ready         (<connected-to-fft_ii_0_source_ready>),         //                .ready
		.fft_ii_0_source_error         (<connected-to-fft_ii_0_source_error>),         //                .error
		.fft_ii_0_source_startofpacket (<connected-to-fft_ii_0_source_startofpacket>), //                .startofpacket
		.fft_ii_0_source_endofpacket   (<connected-to-fft_ii_0_source_endofpacket>),   //                .endofpacket
		.fft_ii_0_source_data          (<connected-to-fft_ii_0_source_data>),          //                .data
		.reset_reset_n                 (<connected-to-reset_reset_n>)                  //           reset.reset_n
	);

