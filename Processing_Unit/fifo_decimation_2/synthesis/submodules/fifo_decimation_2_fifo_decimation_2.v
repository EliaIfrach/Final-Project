//Legal Notice: (C)2022 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module fifo_decimation_2_fifo_decimation_2_dual_clock_fifo (
                                                             // inputs:
                                                              aclr,
                                                              data,
                                                              rdclk,
                                                              rdreq,
                                                              wrclk,
                                                              wrreq,

                                                             // outputs:
                                                              q,
                                                              rdempty,
                                                              wrfull
                                                           )
  /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R101" */ ;

  output  [ 31: 0] q;
  output           rdempty;
  output           wrfull;
  input            aclr;
  input   [ 31: 0] data;
  input            rdclk;
  input            rdreq;
  input            wrclk;
  input            wrreq;


wire             int_wrfull;
wire    [ 31: 0] q;
wire             rdempty;
wire             wrfull;
wire    [  4: 0] wrusedw;
  assign wrfull = (wrusedw >= 32-3) | int_wrfull;
  dcfifo dual_clock_fifo
    (
      .aclr (aclr),
      .data (data),
      .q (q),
      .rdclk (rdclk),
      .rdempty (rdempty),
      .rdreq (rdreq),
      .wrclk (wrclk),
      .wrfull (int_wrfull),
      .wrreq (wrreq),
      .wrusedw (wrusedw)
    );

  defparam dual_clock_fifo.add_ram_output_register = "OFF",
           dual_clock_fifo.clocks_are_synchronized = "FALSE",
           dual_clock_fifo.intended_device_family = "CYCLONEV",
           dual_clock_fifo.lpm_hint = "DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT",
           dual_clock_fifo.lpm_numwords = 32,
           dual_clock_fifo.lpm_showahead = "OFF",
           dual_clock_fifo.lpm_type = "dcfifo",
           dual_clock_fifo.lpm_width = 32,
           dual_clock_fifo.lpm_widthu = 5,
           dual_clock_fifo.overflow_checking = "ON",
           dual_clock_fifo.underflow_checking = "ON",
           dual_clock_fifo.use_eab = "ON";


endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module fifo_decimation_2_fifo_decimation_2_dcfifo_with_controls (
                                                                  // inputs:
                                                                   data,
                                                                   rdclk,
                                                                   rdreq,
                                                                   rdreset_n,
                                                                   wrclk,
                                                                   wrreq,
                                                                   wrreset_n,

                                                                  // outputs:
                                                                   q,
                                                                   rdempty,
                                                                   wrfull
                                                                )
;

  output  [ 31: 0] q;
  output           rdempty;
  output           wrfull;
  input   [ 31: 0] data;
  input            rdclk;
  input            rdreq;
  input            rdreset_n;
  input            wrclk;
  input            wrreq;
  input            wrreset_n;


wire    [ 31: 0] q;
wire             rdempty;
wire             wrfull;
wire             wrreq_valid;
  //the_dcfifo, which is an e_instance
  fifo_decimation_2_fifo_decimation_2_dual_clock_fifo the_dcfifo
    (
      .aclr    (~(rdreset_n && wrreset_n)),
      .data    (data),
      .q       (q),
      .rdclk   (rdclk),
      .rdempty (rdempty),
      .rdreq   (rdreq),
      .wrclk   (wrclk),
      .wrfull  (wrfull),
      .wrreq   (wrreq_valid)
    );

  assign wrreq_valid = wrreq & ~wrfull;

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module fifo_decimation_2_fifo_decimation_2 (
                                             // inputs:
                                              avalonmm_read_slave_read,
                                              avalonmm_write_slave_write,
                                              avalonmm_write_slave_writedata,
                                              rdclock,
                                              rdreset_n,
                                              wrclock,
                                              wrreset_n,

                                             // outputs:
                                              avalonmm_read_slave_readdata,
                                              avalonmm_read_slave_waitrequest,
                                              avalonmm_write_slave_waitrequest
                                           )
;

  output  [ 31: 0] avalonmm_read_slave_readdata;
  output           avalonmm_read_slave_waitrequest;
  output           avalonmm_write_slave_waitrequest;
  input            avalonmm_read_slave_read;
  input            avalonmm_write_slave_write;
  input   [ 31: 0] avalonmm_write_slave_writedata;
  input            rdclock;
  input            rdreset_n;
  input            wrclock;
  input            wrreset_n;


wire    [ 31: 0] avalonmm_read_slave_readdata;
wire             avalonmm_read_slave_waitrequest;
wire             avalonmm_write_slave_waitrequest;
wire    [ 31: 0] data;
wire    [ 31: 0] q;
wire             rdclk;
wire             rdempty;
wire             rdreq;
wire             wrclk;
wire             wrfull;
wire             wrreq;
  //the_dcfifo_with_controls, which is an e_instance
  fifo_decimation_2_fifo_decimation_2_dcfifo_with_controls the_dcfifo_with_controls
    (
      .data      (data),
      .q         (q),
      .rdclk     (rdclk),
      .rdempty   (rdempty),
      .rdreq     (rdreq),
      .rdreset_n (rdreset_n),
      .wrclk     (wrclk),
      .wrfull    (wrfull),
      .wrreq     (wrreq),
      .wrreset_n (wrreset_n)
    );

  //in, which is an e_avalon_slave
  //out, which is an e_avalon_slave
  assign data = avalonmm_write_slave_writedata;
  assign wrreq = avalonmm_write_slave_write;
  assign avalonmm_read_slave_readdata = q;
  assign rdreq = avalonmm_read_slave_read;
  assign rdclk = rdclock;
  assign wrclk = wrclock;
  assign avalonmm_write_slave_waitrequest = wrfull;
  assign avalonmm_read_slave_waitrequest = rdempty;

endmodule

