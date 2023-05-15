
module fifo_decimation_4 (
	clk_clk,
	reset_reset_n,
	fifo_0_clk_out_clk,
	fifo_0_reset_out_reset_n,
	fifo_0_in_writedata,
	fifo_0_in_write,
	fifo_0_in_waitrequest,
	fifo_0_out_readdata,
	fifo_0_out_read,
	fifo_0_out_waitrequest);	

	input		clk_clk;
	input		reset_reset_n;
	input		fifo_0_clk_out_clk;
	input		fifo_0_reset_out_reset_n;
	input	[31:0]	fifo_0_in_writedata;
	input		fifo_0_in_write;
	output		fifo_0_in_waitrequest;
	output	[31:0]	fifo_0_out_readdata;
	input		fifo_0_out_read;
	output		fifo_0_out_waitrequest;
endmodule
