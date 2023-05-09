
module fifo_decimation_3 (
	clk_clk,
	reset_reset_n,
	fifo_decimation_3_clk_out_clk,
	fifo_decimation_3_out_readdata,
	fifo_decimation_3_out_read,
	fifo_decimation_3_out_waitrequest,
	fifo_decimation_3_in_writedata,
	fifo_decimation_3_in_write,
	fifo_decimation_3_in_waitrequest,
	fifo_decimation_3_reset_out_reset_n);	

	input		clk_clk;
	input		reset_reset_n;
	input		fifo_decimation_3_clk_out_clk;
	output	[31:0]	fifo_decimation_3_out_readdata;
	input		fifo_decimation_3_out_read;
	output		fifo_decimation_3_out_waitrequest;
	input	[31:0]	fifo_decimation_3_in_writedata;
	input		fifo_decimation_3_in_write;
	output		fifo_decimation_3_in_waitrequest;
	input		fifo_decimation_3_reset_out_reset_n;
endmodule
