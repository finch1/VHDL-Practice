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

module ingress_fifo (
                      // inputs:
                       in_clk,
                       in_data,
                       in_reset_n,
                       in_valid,
                       out_clk,
                       out_csr_address,
                       out_csr_read,
                       out_csr_write,
                       out_csr_writedata,
                       out_ready,
                       out_reset_n,

                      // outputs:
                       in_ready,
                       out_csr_readdata,
                       out_data,
                       out_valid
                    )
;

  output           in_ready;
  output  [ 31: 0] out_csr_readdata;
  output  [ 15: 0] out_data;
  output           out_valid;
  input            in_clk;
  input   [ 15: 0] in_data;
  input            in_reset_n;
  input            in_valid;
  input            out_clk;
  input            out_csr_address;
  input            out_csr_read;
  input            out_csr_write;
  input   [ 31: 0] out_csr_writedata;
  input            out_ready;
  input            out_reset_n;

  wire             in_ready;
  wire    [ 31: 0] out_csr_readdata;
  wire    [ 15: 0] out_data;
  wire             out_valid;
  altera_avalon_dc_fifo the_altera_avalon_dc_fifo
    (
      .in_clk            (in_clk),
      .in_data           (in_data),
      .in_ready          (in_ready),
      .in_reset_n        (in_reset_n),
      .in_valid          (in_valid),
      .out_clk           (out_clk),
      .out_csr_address   (out_csr_address),
      .out_csr_read      (out_csr_read),
      .out_csr_readdata  (out_csr_readdata),
      .out_csr_write     (out_csr_write),
      .out_csr_writedata (out_csr_writedata),
      .out_data          (out_data),
      .out_ready         (out_ready),
      .out_reset_n       (out_reset_n),
      .out_valid         (out_valid)
    );
  defparam the_altera_avalon_dc_fifo.ADDR_WIDTH = 10,
           the_altera_avalon_dc_fifo.BITS_PER_SYMBOL = 8,
           the_altera_avalon_dc_fifo.CHANNEL_WIDTH = 0,
           the_altera_avalon_dc_fifo.ERROR_WIDTH = 0,
           the_altera_avalon_dc_fifo.FIFO_DEPTH = 1024,
           the_altera_avalon_dc_fifo.SYMBOLS_PER_BEAT = 2,
           the_altera_avalon_dc_fifo.USE_IN_FILL_LEVEL = 0,
           the_altera_avalon_dc_fifo.USE_OUT_FILL_LEVEL = 1,
           the_altera_avalon_dc_fifo.USE_PACKETS = 0;


endmodule

