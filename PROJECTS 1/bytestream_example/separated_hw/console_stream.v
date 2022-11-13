//Legal Notice: (C)2008 Altera Corporation. All rights reserved.  Your
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

module console_stream (
                        // inputs:
                         clk,
                         reset_n,
                         sink_data,
                         sink_valid,

                        // outputs:
                         resetrequest,
                         sink_ready,
                         source_data,
                         source_valid
                      )
;

  output           resetrequest;
  output           sink_ready;
  output  [  7: 0] source_data;
  output           source_valid;
  input            clk;
  input            reset_n;
  input   [  7: 0] sink_data;
  input            sink_valid;

  wire             resetrequest;
  wire             sink_ready;
  wire    [  7: 0] source_data;
  wire             source_valid;
  altera_jtag_dc_streaming the_altera_jtag_dc_streaming
    (
      .clk          (clk),
      .reset_n      (reset_n),
      .resetrequest (resetrequest),
      .sink_data    (sink_data),
      .sink_ready   (sink_ready),
      .sink_valid   (sink_valid),
      .source_data  (source_data),
      .source_valid (source_valid)
    );
  defparam the_altera_jtag_dc_streaming.PURPOSE = 0;


endmodule

