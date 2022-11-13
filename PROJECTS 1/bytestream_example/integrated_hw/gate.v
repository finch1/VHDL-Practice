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

module gate (
              // inputs:
               asi_egress_snk_data,
               asi_egress_snk_valid,
               asi_ingress_snk_data,
               asi_ingress_snk_valid,
               aso_egress_src_ready,
               avm_m0_readdata,
               avm_m0_readdatavalid,
               avm_m0_waitrequest,
               avs_s0_write,
               avs_s0_writedata,
               csi_clock_clk,
               csi_clock_reset,

              // outputs:
               asi_ingress_snk_ready,
               aso_egress_src_data,
               aso_egress_src_valid,
               aso_ingress_src_data,
               aso_ingress_src_valid,
               avm_m0_address,
               avm_m0_read,
               avs_s0_readdata
            )
;

  output           asi_ingress_snk_ready;
  output  [ 15: 0] aso_egress_src_data;
  output           aso_egress_src_valid;
  output  [ 15: 0] aso_ingress_src_data;
  output           aso_ingress_src_valid;
  output  [  2: 0] avm_m0_address;
  output           avm_m0_read;
  output  [ 31: 0] avs_s0_readdata;
  input   [ 15: 0] asi_egress_snk_data;
  input            asi_egress_snk_valid;
  input   [ 15: 0] asi_ingress_snk_data;
  input            asi_ingress_snk_valid;
  input            aso_egress_src_ready;
  input   [ 31: 0] avm_m0_readdata;
  input            avm_m0_readdatavalid;
  input            avm_m0_waitrequest;
  input            avs_s0_write;
  input   [ 31: 0] avs_s0_writedata;
  input            csi_clock_clk;
  input            csi_clock_reset;

  wire             asi_ingress_snk_ready;
  wire    [ 15: 0] aso_egress_src_data;
  wire             aso_egress_src_valid;
  wire    [ 15: 0] aso_ingress_src_data;
  wire             aso_ingress_src_valid;
  wire    [  2: 0] avm_m0_address;
  wire             avm_m0_read;
  wire    [ 31: 0] avs_s0_readdata;
  stream_back_pressure_gate the_stream_back_pressure_gate
    (
      .asi_egress_snk_data   (asi_egress_snk_data),
      .asi_egress_snk_valid  (asi_egress_snk_valid),
      .asi_ingress_snk_data  (asi_ingress_snk_data),
      .asi_ingress_snk_ready (asi_ingress_snk_ready),
      .asi_ingress_snk_valid (asi_ingress_snk_valid),
      .aso_egress_src_data   (aso_egress_src_data),
      .aso_egress_src_ready  (aso_egress_src_ready),
      .aso_egress_src_valid  (aso_egress_src_valid),
      .aso_ingress_src_data  (aso_ingress_src_data),
      .aso_ingress_src_valid (aso_ingress_src_valid),
      .avm_m0_address        (avm_m0_address),
      .avm_m0_read           (avm_m0_read),
      .avm_m0_readdata       (avm_m0_readdata),
      .avm_m0_readdatavalid  (avm_m0_readdatavalid),
      .avm_m0_waitrequest    (avm_m0_waitrequest),
      .avs_s0_readdata       (avs_s0_readdata),
      .avs_s0_write          (avs_s0_write),
      .avs_s0_writedata      (avs_s0_writedata),
      .csi_clock_clk         (csi_clock_clk),
      .csi_clock_reset       (csi_clock_reset)
    );
  defparam the_stream_back_pressure_gate.DATA_WIDTH = 16,
           the_stream_back_pressure_gate.TRIGGER_DEPTH = 1024;


endmodule

