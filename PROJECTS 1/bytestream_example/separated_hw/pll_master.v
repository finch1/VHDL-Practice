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

module pll_master (
                    // inputs:
                     avm_m0_readdata,
                     avm_m0_waitrequest,
                     csi_master_clk_clk,
                     csi_master_clk_reset,

                    // outputs:
                     avm_m0_address,
                     avm_m0_byteenable,
                     avm_m0_read,
                     avm_m0_write,
                     avm_m0_writedata
                  )
;

  output  [  4: 0] avm_m0_address;
  output  [  3: 0] avm_m0_byteenable;
  output           avm_m0_read;
  output           avm_m0_write;
  output  [ 31: 0] avm_m0_writedata;
  input   [ 31: 0] avm_m0_readdata;
  input            avm_m0_waitrequest;
  input            csi_master_clk_clk;
  input            csi_master_clk_reset;

  wire    [  4: 0] avm_m0_address;
  wire    [  3: 0] avm_m0_byteenable;
  wire             avm_m0_read;
  wire             avm_m0_write;
  wire    [ 31: 0] avm_m0_writedata;
  dummy_master the_dummy_master
    (
      .avm_m0_address       (avm_m0_address),
      .avm_m0_byteenable    (avm_m0_byteenable),
      .avm_m0_read          (avm_m0_read),
      .avm_m0_readdata      (avm_m0_readdata),
      .avm_m0_waitrequest   (avm_m0_waitrequest),
      .avm_m0_write         (avm_m0_write),
      .avm_m0_writedata     (avm_m0_writedata),
      .csi_master_clk_clk   (csi_master_clk_clk),
      .csi_master_clk_reset (csi_master_clk_reset)
    );
  defparam the_dummy_master.MASTER_ADDRESS_WIDTH = 5;


endmodule

