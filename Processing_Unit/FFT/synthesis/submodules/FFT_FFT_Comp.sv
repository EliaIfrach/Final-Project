// (C) 2001-2017 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



module FFT_FFT_Comp (
   input clk, 
   input reset_n,
	input [8 : 0] fftpts_in,
	input	[0 : 0] inverse,
	input	sink_valid,
	input	sink_sop,
	input	sink_eop,
	input	logic [15 : 0] sink_real,
	input	logic [15 : 0] sink_imag,
	input	logic [1 : 0] sink_error,
	input	source_ready,
   output [8 : 0] fftpts_out,
	output sink_ready,
	output [1 : 0] source_error,
	output source_sop,
	output source_eop,
	output source_valid,
	output [24 : 0] source_real,
	output [24 : 0] source_imag
	);

	auk_dspip_r22sdf_top #(
		.DEVICE_FAMILY_g("Cyclone V"),
		.MAX_FFTPTS_g(256),
		.NUM_STAGES_g(4),
		.DATAWIDTH_g(16),
		.TWIDWIDTH_g(16),
		.MAX_GROW_g (9),
		.TWIDROM_BASE_g("FFT_FFT_Comp_"),
		.DSP_ROUNDING_g(0),
		.INPUT_FORMAT_g("NATURAL_ORDER"),
		.OUTPUT_FORMAT_g("BIT_REVERSED"),
		.REPRESENTATION_g("FIXEDPT"),
		.DSP_ARCH_g(2),
        .PRUNE_g("0,0,0,0") 
	)
	auk_dspip_r22sdf_top_inst (
		.clk(clk),
		.clk_ena(1'b1),
		.reset_n(reset_n),
		.fftpts_in(fftpts_in),
		.fftpts_out(fftpts_out),
		.inverse(inverse[0]),
		.sink_valid(sink_valid),
		.sink_sop(sink_sop),
		.sink_eop(sink_eop),
		.sink_real(sink_real),
		.sink_imag(sink_imag),
		.sink_ready(sink_ready),
		.sink_error(sink_error),
		.source_error(source_error),
		.source_ready(source_ready),
		.source_sop(source_sop),
		.source_eop(source_eop),
		.source_valid(source_valid),
		.source_real(source_real),
		.source_imag(source_imag)
	);
endmodule

