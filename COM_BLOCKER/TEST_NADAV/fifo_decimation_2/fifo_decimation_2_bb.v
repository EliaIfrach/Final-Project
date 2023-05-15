
module fifo_decimation_2 (
	clk_clk,
	fifo_decimation_2_clk_out_clk,
	fifo_decimation_2_in_writedata,
	fifo_decimation_2_in_write,
	fifo_decimation_2_in_waitrequest,
	fifo_decimation_2_out_readdata,
	fifo_decimation_2_out_read,
	fifo_decimation_2_out_waitrequest,
	fifo_decimation_2_reset_out_reset_n,
	reset_reset_n);	

	input		clk_clk;
	input		fifo_decimation_2_clk_out_clk;
	input	[31:0]	fifo_decimation_2_in_writedata;
	input		fifo_decimation_2_in_write;
	output		fifo_decimation_2_in_waitrequest;
	output	[31:0]	fifo_decimation_2_out_readdata;
	input		fifo_decimation_2_out_read;
	output		fifo_decimation_2_out_waitrequest;
	input		fifo_decimation_2_reset_out_reset_n;
	input		reset_reset_n;
endmodule
