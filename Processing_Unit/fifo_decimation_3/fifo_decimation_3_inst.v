	fifo_decimation_3 u0 (
		.clk_clk                             (<connected-to-clk_clk>),                             //                         clk.clk
		.reset_reset_n                       (<connected-to-reset_reset_n>),                       //                       reset.reset_n
		.fifo_decimation_3_clk_out_clk       (<connected-to-fifo_decimation_3_clk_out_clk>),       //   fifo_decimation_3_clk_out.clk
		.fifo_decimation_3_out_readdata      (<connected-to-fifo_decimation_3_out_readdata>),      //       fifo_decimation_3_out.readdata
		.fifo_decimation_3_out_read          (<connected-to-fifo_decimation_3_out_read>),          //                            .read
		.fifo_decimation_3_out_waitrequest   (<connected-to-fifo_decimation_3_out_waitrequest>),   //                            .waitrequest
		.fifo_decimation_3_in_writedata      (<connected-to-fifo_decimation_3_in_writedata>),      //        fifo_decimation_3_in.writedata
		.fifo_decimation_3_in_write          (<connected-to-fifo_decimation_3_in_write>),          //                            .write
		.fifo_decimation_3_in_waitrequest    (<connected-to-fifo_decimation_3_in_waitrequest>),    //                            .waitrequest
		.fifo_decimation_3_reset_out_reset_n (<connected-to-fifo_decimation_3_reset_out_reset_n>)  // fifo_decimation_3_reset_out.reset_n
	);

