//megafunction wizard: %Altera SOPC Builder%
//GENERATION: STANDARD
//VERSION: WM1.0


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

module DFA_before_console_in_arbitrator (
                                          // inputs:
                                           DFA_before_console_in_ready,
                                           clk,
                                           egress_fifo_out_data,
                                           egress_fifo_out_valid,
                                           reset_n,

                                          // outputs:
                                           DFA_before_console_in_data,
                                           DFA_before_console_in_ready_from_sa,
                                           DFA_before_console_in_reset_n,
                                           DFA_before_console_in_valid
                                        )
;

  output  [ 15: 0] DFA_before_console_in_data;
  output           DFA_before_console_in_ready_from_sa;
  output           DFA_before_console_in_reset_n;
  output           DFA_before_console_in_valid;
  input            DFA_before_console_in_ready;
  input            clk;
  input   [ 15: 0] egress_fifo_out_data;
  input            egress_fifo_out_valid;
  input            reset_n;

  wire    [ 15: 0] DFA_before_console_in_data;
  wire             DFA_before_console_in_ready_from_sa;
  wire             DFA_before_console_in_reset_n;
  wire             DFA_before_console_in_valid;
  //mux DFA_before_console_in_data, which is an e_mux
  assign DFA_before_console_in_data = egress_fifo_out_data;

  //assign DFA_before_console_in_ready_from_sa = DFA_before_console_in_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DFA_before_console_in_ready_from_sa = DFA_before_console_in_ready;

  //mux DFA_before_console_in_valid, which is an e_mux
  assign DFA_before_console_in_valid = egress_fifo_out_valid;

  //DFA_before_console_in_reset_n assignment, which is an e_assign
  assign DFA_before_console_in_reset_n = reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DFA_before_console_out_arbitrator (
                                           // inputs:
                                            DFA_before_console_out_data,
                                            DFA_before_console_out_valid,
                                            clk,
                                            console_stream_sink_ready_from_sa,
                                            reset_n,

                                           // outputs:
                                            DFA_before_console_out_ready
                                         )
;

  output           DFA_before_console_out_ready;
  input   [  7: 0] DFA_before_console_out_data;
  input            DFA_before_console_out_valid;
  input            clk;
  input            console_stream_sink_ready_from_sa;
  input            reset_n;

  wire             DFA_before_console_out_ready;
  //mux DFA_before_console_out_ready, which is an e_mux
  assign DFA_before_console_out_ready = console_stream_sink_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DFA_before_ingress_fifo_in_arbitrator (
                                               // inputs:
                                                DFA_before_ingress_fifo_in_ready,
                                                TA_before_ingress_fifo_out_data,
                                                TA_before_ingress_fifo_out_valid,
                                                clk,
                                                reset_n,

                                               // outputs:
                                                DFA_before_ingress_fifo_in_data,
                                                DFA_before_ingress_fifo_in_ready_from_sa,
                                                DFA_before_ingress_fifo_in_reset_n,
                                                DFA_before_ingress_fifo_in_valid
                                             )
;

  output  [  7: 0] DFA_before_ingress_fifo_in_data;
  output           DFA_before_ingress_fifo_in_ready_from_sa;
  output           DFA_before_ingress_fifo_in_reset_n;
  output           DFA_before_ingress_fifo_in_valid;
  input            DFA_before_ingress_fifo_in_ready;
  input   [  7: 0] TA_before_ingress_fifo_out_data;
  input            TA_before_ingress_fifo_out_valid;
  input            clk;
  input            reset_n;

  wire    [  7: 0] DFA_before_ingress_fifo_in_data;
  wire             DFA_before_ingress_fifo_in_ready_from_sa;
  wire             DFA_before_ingress_fifo_in_reset_n;
  wire             DFA_before_ingress_fifo_in_valid;
  //mux DFA_before_ingress_fifo_in_data, which is an e_mux
  assign DFA_before_ingress_fifo_in_data = TA_before_ingress_fifo_out_data;

  //assign DFA_before_ingress_fifo_in_ready_from_sa = DFA_before_ingress_fifo_in_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign DFA_before_ingress_fifo_in_ready_from_sa = DFA_before_ingress_fifo_in_ready;

  //mux DFA_before_ingress_fifo_in_valid, which is an e_mux
  assign DFA_before_ingress_fifo_in_valid = TA_before_ingress_fifo_out_valid;

  //DFA_before_ingress_fifo_in_reset_n assignment, which is an e_assign
  assign DFA_before_ingress_fifo_in_reset_n = reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module DFA_before_ingress_fifo_out_arbitrator (
                                                // inputs:
                                                 DFA_before_ingress_fifo_out_data,
                                                 DFA_before_ingress_fifo_out_valid,
                                                 clk,
                                                 ingress_fifo_in_ready_from_sa,
                                                 reset_n,

                                                // outputs:
                                                 DFA_before_ingress_fifo_out_ready
                                              )
;

  output           DFA_before_ingress_fifo_out_ready;
  input   [ 15: 0] DFA_before_ingress_fifo_out_data;
  input            DFA_before_ingress_fifo_out_valid;
  input            clk;
  input            ingress_fifo_in_ready_from_sa;
  input            reset_n;

  wire             DFA_before_ingress_fifo_out_ready;
  //mux DFA_before_ingress_fifo_out_ready, which is an e_mux
  assign DFA_before_ingress_fifo_out_ready = ingress_fifo_in_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module TA_before_dut_in_arbitrator (
                                     // inputs:
                                      clk,
                                      gate_ingress_src_data,
                                      gate_ingress_src_valid,
                                      reset_n,

                                     // outputs:
                                      TA_before_dut_in_data,
                                      TA_before_dut_in_reset_n,
                                      TA_before_dut_in_valid
                                   )
;

  output  [ 15: 0] TA_before_dut_in_data;
  output           TA_before_dut_in_reset_n;
  output           TA_before_dut_in_valid;
  input            clk;
  input   [ 15: 0] gate_ingress_src_data;
  input            gate_ingress_src_valid;
  input            reset_n;

  wire    [ 15: 0] TA_before_dut_in_data;
  wire             TA_before_dut_in_reset_n;
  wire             TA_before_dut_in_valid;
  //mux TA_before_dut_in_data, which is an e_mux
  assign TA_before_dut_in_data = gate_ingress_src_data;

  //mux TA_before_dut_in_valid, which is an e_mux
  assign TA_before_dut_in_valid = gate_ingress_src_valid;

  //TA_before_dut_in_reset_n assignment, which is an e_assign
  assign TA_before_dut_in_reset_n = reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module TA_before_dut_out_arbitrator (
                                      // inputs:
                                       TA_before_dut_out_data,
                                       clk,
                                       reset_n
                                    )
;

  input   [ 15: 0] TA_before_dut_out_data;
  input            clk;
  input            reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module TA_before_gate_in_arbitrator (
                                      // inputs:
                                       clk,
                                       dut_source_data,
                                       reset_n,

                                      // outputs:
                                       TA_before_gate_in_data,
                                       TA_before_gate_in_reset_n
                                    )
;

  output  [ 15: 0] TA_before_gate_in_data;
  output           TA_before_gate_in_reset_n;
  input            clk;
  input   [ 15: 0] dut_source_data;
  input            reset_n;

  wire    [ 15: 0] TA_before_gate_in_data;
  wire             TA_before_gate_in_reset_n;
  //mux TA_before_gate_in_data, which is an e_mux
  assign TA_before_gate_in_data = dut_source_data;

  //TA_before_gate_in_reset_n assignment, which is an e_assign
  assign TA_before_gate_in_reset_n = reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module TA_before_gate_out_arbitrator (
                                       // inputs:
                                        TA_before_gate_out_data,
                                        TA_before_gate_out_valid,
                                        clk,
                                        reset_n
                                     )
;

  input   [ 15: 0] TA_before_gate_out_data;
  input            TA_before_gate_out_valid;
  input            clk;
  input            reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module TA_before_ingress_fifo_in_arbitrator (
                                              // inputs:
                                               clk,
                                               console_stream_src_data,
                                               console_stream_src_valid,
                                               reset_n,

                                              // outputs:
                                               TA_before_ingress_fifo_in_data,
                                               TA_before_ingress_fifo_in_reset_n,
                                               TA_before_ingress_fifo_in_valid
                                            )
;

  output  [  7: 0] TA_before_ingress_fifo_in_data;
  output           TA_before_ingress_fifo_in_reset_n;
  output           TA_before_ingress_fifo_in_valid;
  input            clk;
  input   [  7: 0] console_stream_src_data;
  input            console_stream_src_valid;
  input            reset_n;

  wire    [  7: 0] TA_before_ingress_fifo_in_data;
  wire             TA_before_ingress_fifo_in_reset_n;
  wire             TA_before_ingress_fifo_in_valid;
  //mux TA_before_ingress_fifo_in_data, which is an e_mux
  assign TA_before_ingress_fifo_in_data = console_stream_src_data;

  //mux TA_before_ingress_fifo_in_valid, which is an e_mux
  assign TA_before_ingress_fifo_in_valid = console_stream_src_valid;

  //TA_before_ingress_fifo_in_reset_n assignment, which is an e_assign
  assign TA_before_ingress_fifo_in_reset_n = reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module TA_before_ingress_fifo_out_arbitrator (
                                               // inputs:
                                                DFA_before_ingress_fifo_in_ready_from_sa,
                                                TA_before_ingress_fifo_out_data,
                                                TA_before_ingress_fifo_out_valid,
                                                clk,
                                                reset_n,

                                               // outputs:
                                                TA_before_ingress_fifo_out_ready
                                             )
;

  output           TA_before_ingress_fifo_out_ready;
  input            DFA_before_ingress_fifo_in_ready_from_sa;
  input   [  7: 0] TA_before_ingress_fifo_out_data;
  input            TA_before_ingress_fifo_out_valid;
  input            clk;
  input            reset_n;

  wire             TA_before_ingress_fifo_out_ready;
  //mux TA_before_ingress_fifo_out_ready, which is an e_mux
  assign TA_before_ingress_fifo_out_ready = DFA_before_ingress_fifo_in_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module build_id_s0_arbitrator (
                                // inputs:
                                 build_id_s0_readdata,
                                 clk,
                                 console_master_latency_counter,
                                 console_master_master_address_to_slave,
                                 console_master_master_read,
                                 console_master_master_write,
                                 reset_n,

                                // outputs:
                                 build_id_s0_readdata_from_sa,
                                 build_id_s0_reset,
                                 console_master_granted_build_id_s0,
                                 console_master_qualified_request_build_id_s0,
                                 console_master_read_data_valid_build_id_s0,
                                 console_master_requests_build_id_s0,
                                 d1_build_id_s0_end_xfer
                              )
;

  output  [ 31: 0] build_id_s0_readdata_from_sa;
  output           build_id_s0_reset;
  output           console_master_granted_build_id_s0;
  output           console_master_qualified_request_build_id_s0;
  output           console_master_read_data_valid_build_id_s0;
  output           console_master_requests_build_id_s0;
  output           d1_build_id_s0_end_xfer;
  input   [ 31: 0] build_id_s0_readdata;
  input            clk;
  input            console_master_latency_counter;
  input   [ 31: 0] console_master_master_address_to_slave;
  input            console_master_master_read;
  input            console_master_master_write;
  input            reset_n;

  wire             build_id_s0_allgrants;
  wire             build_id_s0_allow_new_arb_cycle;
  wire             build_id_s0_any_bursting_master_saved_grant;
  wire             build_id_s0_any_continuerequest;
  wire             build_id_s0_arb_counter_enable;
  reg              build_id_s0_arb_share_counter;
  wire             build_id_s0_arb_share_counter_next_value;
  wire             build_id_s0_arb_share_set_values;
  wire             build_id_s0_beginbursttransfer_internal;
  wire             build_id_s0_begins_xfer;
  wire             build_id_s0_end_xfer;
  wire             build_id_s0_firsttransfer;
  wire             build_id_s0_grant_vector;
  wire             build_id_s0_in_a_read_cycle;
  wire             build_id_s0_in_a_write_cycle;
  wire             build_id_s0_master_qreq_vector;
  wire             build_id_s0_non_bursting_master_requests;
  wire    [ 31: 0] build_id_s0_readdata_from_sa;
  reg              build_id_s0_reg_firsttransfer;
  wire             build_id_s0_reset;
  reg              build_id_s0_slavearbiterlockenable;
  wire             build_id_s0_slavearbiterlockenable2;
  wire             build_id_s0_unreg_firsttransfer;
  wire             build_id_s0_waits_for_read;
  wire             build_id_s0_waits_for_write;
  wire             console_master_granted_build_id_s0;
  wire             console_master_master_arbiterlock;
  wire             console_master_master_arbiterlock2;
  wire             console_master_master_continuerequest;
  wire             console_master_qualified_request_build_id_s0;
  wire             console_master_read_data_valid_build_id_s0;
  wire             console_master_requests_build_id_s0;
  wire             console_master_saved_grant_build_id_s0;
  reg              d1_build_id_s0_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_build_id_s0;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 31: 0] shifted_address_to_build_id_s0_from_console_master_master;
  wire             wait_for_build_id_s0_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~build_id_s0_end_xfer;
    end


  assign build_id_s0_begins_xfer = ~d1_reasons_to_wait & ((console_master_qualified_request_build_id_s0));
  //assign build_id_s0_readdata_from_sa = build_id_s0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign build_id_s0_readdata_from_sa = build_id_s0_readdata;

  assign console_master_requests_build_id_s0 = (({console_master_master_address_to_slave[31 : 2] , 2'b0} == 32'h8) & (console_master_master_read | console_master_master_write)) & console_master_master_read;
  //build_id_s0_arb_share_counter set values, which is an e_mux
  assign build_id_s0_arb_share_set_values = 1;

  //build_id_s0_non_bursting_master_requests mux, which is an e_mux
  assign build_id_s0_non_bursting_master_requests = console_master_requests_build_id_s0;

  //build_id_s0_any_bursting_master_saved_grant mux, which is an e_mux
  assign build_id_s0_any_bursting_master_saved_grant = 0;

  //build_id_s0_arb_share_counter_next_value assignment, which is an e_assign
  assign build_id_s0_arb_share_counter_next_value = build_id_s0_firsttransfer ? (build_id_s0_arb_share_set_values - 1) : |build_id_s0_arb_share_counter ? (build_id_s0_arb_share_counter - 1) : 0;

  //build_id_s0_allgrants all slave grants, which is an e_mux
  assign build_id_s0_allgrants = |build_id_s0_grant_vector;

  //build_id_s0_end_xfer assignment, which is an e_assign
  assign build_id_s0_end_xfer = ~(build_id_s0_waits_for_read | build_id_s0_waits_for_write);

  //end_xfer_arb_share_counter_term_build_id_s0 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_build_id_s0 = build_id_s0_end_xfer & (~build_id_s0_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //build_id_s0_arb_share_counter arbitration counter enable, which is an e_assign
  assign build_id_s0_arb_counter_enable = (end_xfer_arb_share_counter_term_build_id_s0 & build_id_s0_allgrants) | (end_xfer_arb_share_counter_term_build_id_s0 & ~build_id_s0_non_bursting_master_requests);

  //build_id_s0_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          build_id_s0_arb_share_counter <= 0;
      else if (build_id_s0_arb_counter_enable)
          build_id_s0_arb_share_counter <= build_id_s0_arb_share_counter_next_value;
    end


  //build_id_s0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          build_id_s0_slavearbiterlockenable <= 0;
      else if ((|build_id_s0_master_qreq_vector & end_xfer_arb_share_counter_term_build_id_s0) | (end_xfer_arb_share_counter_term_build_id_s0 & ~build_id_s0_non_bursting_master_requests))
          build_id_s0_slavearbiterlockenable <= |build_id_s0_arb_share_counter_next_value;
    end


  //console_master/master build_id/s0 arbiterlock, which is an e_assign
  assign console_master_master_arbiterlock = build_id_s0_slavearbiterlockenable & console_master_master_continuerequest;

  //build_id_s0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign build_id_s0_slavearbiterlockenable2 = |build_id_s0_arb_share_counter_next_value;

  //console_master/master build_id/s0 arbiterlock2, which is an e_assign
  assign console_master_master_arbiterlock2 = build_id_s0_slavearbiterlockenable2 & console_master_master_continuerequest;

  //build_id_s0_any_continuerequest at least one master continues requesting, which is an e_assign
  assign build_id_s0_any_continuerequest = 1;

  //console_master_master_continuerequest continued request, which is an e_assign
  assign console_master_master_continuerequest = 1;

  assign console_master_qualified_request_build_id_s0 = console_master_requests_build_id_s0 & ~((console_master_master_read & ((console_master_latency_counter != 0))));
  //local readdatavalid console_master_read_data_valid_build_id_s0, which is an e_mux
  assign console_master_read_data_valid_build_id_s0 = console_master_granted_build_id_s0 & console_master_master_read & ~build_id_s0_waits_for_read;

  //master is always granted when requested
  assign console_master_granted_build_id_s0 = console_master_qualified_request_build_id_s0;

  //console_master/master saved-grant build_id/s0, which is an e_assign
  assign console_master_saved_grant_build_id_s0 = console_master_requests_build_id_s0;

  //allow new arb cycle for build_id/s0, which is an e_assign
  assign build_id_s0_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign build_id_s0_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign build_id_s0_master_qreq_vector = 1;

  //~build_id_s0_reset assignment, which is an e_assign
  assign build_id_s0_reset = ~reset_n;

  //build_id_s0_firsttransfer first transaction, which is an e_assign
  assign build_id_s0_firsttransfer = build_id_s0_begins_xfer ? build_id_s0_unreg_firsttransfer : build_id_s0_reg_firsttransfer;

  //build_id_s0_unreg_firsttransfer first transaction, which is an e_assign
  assign build_id_s0_unreg_firsttransfer = ~(build_id_s0_slavearbiterlockenable & build_id_s0_any_continuerequest);

  //build_id_s0_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          build_id_s0_reg_firsttransfer <= 1'b1;
      else if (build_id_s0_begins_xfer)
          build_id_s0_reg_firsttransfer <= build_id_s0_unreg_firsttransfer;
    end


  //build_id_s0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign build_id_s0_beginbursttransfer_internal = build_id_s0_begins_xfer;

  assign shifted_address_to_build_id_s0_from_console_master_master = console_master_master_address_to_slave;
  //d1_build_id_s0_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_build_id_s0_end_xfer <= 1;
      else if (1)
          d1_build_id_s0_end_xfer <= build_id_s0_end_xfer;
    end


  //build_id_s0_waits_for_read in a cycle, which is an e_mux
  assign build_id_s0_waits_for_read = build_id_s0_in_a_read_cycle & build_id_s0_begins_xfer;

  //build_id_s0_in_a_read_cycle assignment, which is an e_assign
  assign build_id_s0_in_a_read_cycle = console_master_granted_build_id_s0 & console_master_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = build_id_s0_in_a_read_cycle;

  //build_id_s0_waits_for_write in a cycle, which is an e_mux
  assign build_id_s0_waits_for_write = build_id_s0_in_a_write_cycle & 0;

  //build_id_s0_in_a_write_cycle assignment, which is an e_assign
  assign build_id_s0_in_a_write_cycle = console_master_granted_build_id_s0 & console_master_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = build_id_s0_in_a_write_cycle;

  assign wait_for_build_id_s0_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //build_id/s0 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else if (1)
          enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module console_master_master_arbitrator (
                                          // inputs:
                                           build_id_s0_readdata_from_sa,
                                           clk,
                                           console_master_granted_build_id_s0,
                                           console_master_granted_sysid_control_slave,
                                           console_master_granted_test_sys_sopc_clock_0_in,
                                           console_master_master_address,
                                           console_master_master_byteenable,
                                           console_master_master_read,
                                           console_master_master_write,
                                           console_master_master_writedata,
                                           console_master_qualified_request_build_id_s0,
                                           console_master_qualified_request_sysid_control_slave,
                                           console_master_qualified_request_test_sys_sopc_clock_0_in,
                                           console_master_read_data_valid_build_id_s0,
                                           console_master_read_data_valid_sysid_control_slave,
                                           console_master_read_data_valid_test_sys_sopc_clock_0_in,
                                           console_master_requests_build_id_s0,
                                           console_master_requests_sysid_control_slave,
                                           console_master_requests_test_sys_sopc_clock_0_in,
                                           d1_build_id_s0_end_xfer,
                                           d1_sysid_control_slave_end_xfer,
                                           d1_test_sys_sopc_clock_0_in_end_xfer,
                                           reset_n,
                                           sysid_control_slave_readdata_from_sa,
                                           test_sys_sopc_clock_0_in_readdata_from_sa,
                                           test_sys_sopc_clock_0_in_waitrequest_from_sa,

                                          // outputs:
                                           console_master_latency_counter,
                                           console_master_master_address_to_slave,
                                           console_master_master_readdata,
                                           console_master_master_readdatavalid,
                                           console_master_master_reset_n,
                                           console_master_master_waitrequest
                                        )
;

  output           console_master_latency_counter;
  output  [ 31: 0] console_master_master_address_to_slave;
  output  [ 31: 0] console_master_master_readdata;
  output           console_master_master_readdatavalid;
  output           console_master_master_reset_n;
  output           console_master_master_waitrequest;
  input   [ 31: 0] build_id_s0_readdata_from_sa;
  input            clk;
  input            console_master_granted_build_id_s0;
  input            console_master_granted_sysid_control_slave;
  input            console_master_granted_test_sys_sopc_clock_0_in;
  input   [ 31: 0] console_master_master_address;
  input   [  3: 0] console_master_master_byteenable;
  input            console_master_master_read;
  input            console_master_master_write;
  input   [ 31: 0] console_master_master_writedata;
  input            console_master_qualified_request_build_id_s0;
  input            console_master_qualified_request_sysid_control_slave;
  input            console_master_qualified_request_test_sys_sopc_clock_0_in;
  input            console_master_read_data_valid_build_id_s0;
  input            console_master_read_data_valid_sysid_control_slave;
  input            console_master_read_data_valid_test_sys_sopc_clock_0_in;
  input            console_master_requests_build_id_s0;
  input            console_master_requests_sysid_control_slave;
  input            console_master_requests_test_sys_sopc_clock_0_in;
  input            d1_build_id_s0_end_xfer;
  input            d1_sysid_control_slave_end_xfer;
  input            d1_test_sys_sopc_clock_0_in_end_xfer;
  input            reset_n;
  input   [ 31: 0] sysid_control_slave_readdata_from_sa;
  input   [ 31: 0] test_sys_sopc_clock_0_in_readdata_from_sa;
  input            test_sys_sopc_clock_0_in_waitrequest_from_sa;

  reg              active_and_waiting_last_time;
  reg              console_master_latency_counter;
  reg     [ 31: 0] console_master_master_address_last_time;
  wire    [ 31: 0] console_master_master_address_to_slave;
  reg     [  3: 0] console_master_master_byteenable_last_time;
  wire             console_master_master_is_granted_some_slave;
  reg              console_master_master_read_but_no_slave_selected;
  reg              console_master_master_read_last_time;
  wire    [ 31: 0] console_master_master_readdata;
  wire             console_master_master_readdatavalid;
  wire             console_master_master_reset_n;
  wire             console_master_master_run;
  wire             console_master_master_waitrequest;
  reg              console_master_master_write_last_time;
  reg     [ 31: 0] console_master_master_writedata_last_time;
  wire             latency_load_value;
  wire             p1_console_master_latency_counter;
  wire             pre_flush_console_master_master_readdatavalid;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (console_master_qualified_request_build_id_s0 | ~console_master_requests_build_id_s0) & ((~console_master_qualified_request_build_id_s0 | ~console_master_master_read | (1 & ~d1_build_id_s0_end_xfer & console_master_master_read))) & ((~console_master_qualified_request_build_id_s0 | ~console_master_master_write | (1 & console_master_master_write))) & 1 & (console_master_qualified_request_sysid_control_slave | ~console_master_requests_sysid_control_slave) & ((~console_master_qualified_request_sysid_control_slave | ~console_master_master_read | (1 & ~d1_sysid_control_slave_end_xfer & console_master_master_read))) & ((~console_master_qualified_request_sysid_control_slave | ~console_master_master_write | (1 & console_master_master_write))) & 1 & (console_master_qualified_request_test_sys_sopc_clock_0_in | ~console_master_requests_test_sys_sopc_clock_0_in) & ((~console_master_qualified_request_test_sys_sopc_clock_0_in | ~(console_master_master_read | console_master_master_write) | (1 & ~test_sys_sopc_clock_0_in_waitrequest_from_sa & (console_master_master_read | console_master_master_write)))) & ((~console_master_qualified_request_test_sys_sopc_clock_0_in | ~(console_master_master_read | console_master_master_write) | (1 & ~test_sys_sopc_clock_0_in_waitrequest_from_sa & (console_master_master_read | console_master_master_write))));

  //cascaded wait assignment, which is an e_assign
  assign console_master_master_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign console_master_master_address_to_slave = {28'b0,
    console_master_master_address[3 : 0]};

  //console_master_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          console_master_master_read_but_no_slave_selected <= 0;
      else if (1)
          console_master_master_read_but_no_slave_selected <= console_master_master_read & console_master_master_run & ~console_master_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign console_master_master_is_granted_some_slave = console_master_granted_build_id_s0 |
    console_master_granted_sysid_control_slave |
    console_master_granted_test_sys_sopc_clock_0_in;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_console_master_master_readdatavalid = 0;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign console_master_master_readdatavalid = console_master_master_read_but_no_slave_selected |
    pre_flush_console_master_master_readdatavalid |
    console_master_read_data_valid_build_id_s0 |
    console_master_master_read_but_no_slave_selected |
    pre_flush_console_master_master_readdatavalid |
    console_master_read_data_valid_sysid_control_slave |
    console_master_master_read_but_no_slave_selected |
    pre_flush_console_master_master_readdatavalid |
    console_master_read_data_valid_test_sys_sopc_clock_0_in;

  //console_master/master readdata mux, which is an e_mux
  assign console_master_master_readdata = ({32 {~(console_master_qualified_request_build_id_s0 & console_master_master_read)}} | build_id_s0_readdata_from_sa) &
    ({32 {~(console_master_qualified_request_sysid_control_slave & console_master_master_read)}} | sysid_control_slave_readdata_from_sa) &
    ({32 {~(console_master_qualified_request_test_sys_sopc_clock_0_in & console_master_master_read)}} | test_sys_sopc_clock_0_in_readdata_from_sa);

  //actual waitrequest port, which is an e_assign
  assign console_master_master_waitrequest = ~console_master_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          console_master_latency_counter <= 0;
      else if (1)
          console_master_latency_counter <= p1_console_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_console_master_latency_counter = ((console_master_master_run & console_master_master_read))? latency_load_value :
    (console_master_latency_counter)? console_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = 0;

  //console_master_master_reset_n assignment, which is an e_assign
  assign console_master_master_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //console_master_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          console_master_master_address_last_time <= 0;
      else if (1)
          console_master_master_address_last_time <= console_master_master_address;
    end


  //console_master/master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else if (1)
          active_and_waiting_last_time <= console_master_master_waitrequest & (console_master_master_read | console_master_master_write);
    end


  //console_master_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (console_master_master_address != console_master_master_address_last_time))
        begin
          $write("%0d ns: console_master_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //console_master_master_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          console_master_master_byteenable_last_time <= 0;
      else if (1)
          console_master_master_byteenable_last_time <= console_master_master_byteenable;
    end


  //console_master_master_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (console_master_master_byteenable != console_master_master_byteenable_last_time))
        begin
          $write("%0d ns: console_master_master_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //console_master_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          console_master_master_read_last_time <= 0;
      else if (1)
          console_master_master_read_last_time <= console_master_master_read;
    end


  //console_master_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (console_master_master_read != console_master_master_read_last_time))
        begin
          $write("%0d ns: console_master_master_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //console_master_master_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          console_master_master_write_last_time <= 0;
      else if (1)
          console_master_master_write_last_time <= console_master_master_write;
    end


  //console_master_master_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (console_master_master_write != console_master_master_write_last_time))
        begin
          $write("%0d ns: console_master_master_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //console_master_master_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          console_master_master_writedata_last_time <= 0;
      else if (1)
          console_master_master_writedata_last_time <= console_master_master_writedata;
    end


  //console_master_master_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (console_master_master_writedata != console_master_master_writedata_last_time) & console_master_master_write)
        begin
          $write("%0d ns: console_master_master_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module console_stream_sink_arbitrator (
                                        // inputs:
                                         DFA_before_console_out_data,
                                         DFA_before_console_out_valid,
                                         clk,
                                         console_stream_sink_ready,
                                         reset_n,

                                        // outputs:
                                         console_stream_sink_data,
                                         console_stream_sink_ready_from_sa,
                                         console_stream_sink_valid
                                      )
;

  output  [  7: 0] console_stream_sink_data;
  output           console_stream_sink_ready_from_sa;
  output           console_stream_sink_valid;
  input   [  7: 0] DFA_before_console_out_data;
  input            DFA_before_console_out_valid;
  input            clk;
  input            console_stream_sink_ready;
  input            reset_n;

  wire    [  7: 0] console_stream_sink_data;
  wire             console_stream_sink_ready_from_sa;
  wire             console_stream_sink_valid;
  //mux console_stream_sink_data, which is an e_mux
  assign console_stream_sink_data = DFA_before_console_out_data;

  //assign console_stream_sink_ready_from_sa = console_stream_sink_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign console_stream_sink_ready_from_sa = console_stream_sink_ready;

  //mux console_stream_sink_valid, which is an e_mux
  assign console_stream_sink_valid = DFA_before_console_out_valid;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module console_stream_src_arbitrator (
                                       // inputs:
                                        clk,
                                        console_stream_src_data,
                                        console_stream_src_valid,
                                        reset_n,

                                       // outputs:
                                        console_stream_src_reset_n
                                     )
;

  output           console_stream_src_reset_n;
  input            clk;
  input   [  7: 0] console_stream_src_data;
  input            console_stream_src_valid;
  input            reset_n;

  wire             console_stream_src_reset_n;
  //console_stream_src_reset_n assignment, which is an e_assign
  assign console_stream_src_reset_n = reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module dut_sink_arbitrator (
                             // inputs:
                              TA_before_dut_out_data,
                              clk,
                              reset_n,

                             // outputs:
                              dut_sink_data,
                              dut_sink_reset
                           )
;

  output  [ 15: 0] dut_sink_data;
  output           dut_sink_reset;
  input   [ 15: 0] TA_before_dut_out_data;
  input            clk;
  input            reset_n;

  wire    [ 15: 0] dut_sink_data;
  wire             dut_sink_reset;
  //mux dut_sink_data, which is an e_mux
  assign dut_sink_data = TA_before_dut_out_data;

  //~dut_sink_reset assignment, which is an e_assign
  assign dut_sink_reset = ~reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module dut_source_arbitrator (
                               // inputs:
                                clk,
                                dut_source_data,
                                reset_n
                             )
;

  input            clk;
  input   [ 15: 0] dut_source_data;
  input            reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module egress_fifo_in_arbitrator (
                                   // inputs:
                                    clk,
                                    egress_fifo_in_ready,
                                    egress_pipeline_fifo_out_data,
                                    egress_pipeline_fifo_out_valid,
                                    reset_n,

                                   // outputs:
                                    egress_fifo_in_data,
                                    egress_fifo_in_ready_from_sa,
                                    egress_fifo_in_reset_n,
                                    egress_fifo_in_valid
                                 )
;

  output  [ 15: 0] egress_fifo_in_data;
  output           egress_fifo_in_ready_from_sa;
  output           egress_fifo_in_reset_n;
  output           egress_fifo_in_valid;
  input            clk;
  input            egress_fifo_in_ready;
  input   [ 15: 0] egress_pipeline_fifo_out_data;
  input            egress_pipeline_fifo_out_valid;
  input            reset_n;

  wire    [ 15: 0] egress_fifo_in_data;
  wire             egress_fifo_in_ready_from_sa;
  wire             egress_fifo_in_reset_n;
  wire             egress_fifo_in_valid;
  //mux egress_fifo_in_data, which is an e_mux
  assign egress_fifo_in_data = egress_pipeline_fifo_out_data;

  //assign egress_fifo_in_ready_from_sa = egress_fifo_in_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign egress_fifo_in_ready_from_sa = egress_fifo_in_ready;

  //mux egress_fifo_in_valid, which is an e_mux
  assign egress_fifo_in_valid = egress_pipeline_fifo_out_valid;

  //egress_fifo_in_reset_n assignment, which is an e_assign
  assign egress_fifo_in_reset_n = reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module egress_fifo_out_arbitrator (
                                    // inputs:
                                     DFA_before_console_in_ready_from_sa,
                                     clk,
                                     egress_fifo_out_data,
                                     egress_fifo_out_valid,
                                     reset_n,

                                    // outputs:
                                     egress_fifo_out_ready,
                                     egress_fifo_out_reset_n
                                  )
;

  output           egress_fifo_out_ready;
  output           egress_fifo_out_reset_n;
  input            DFA_before_console_in_ready_from_sa;
  input            clk;
  input   [ 15: 0] egress_fifo_out_data;
  input            egress_fifo_out_valid;
  input            reset_n;

  wire             egress_fifo_out_ready;
  wire             egress_fifo_out_reset_n;
  //egress_fifo_out_reset_n assignment, which is an e_assign
  assign egress_fifo_out_reset_n = reset_n;

  //mux egress_fifo_out_ready, which is an e_mux
  assign egress_fifo_out_ready = DFA_before_console_in_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module egress_pipeline_fifo_in_arbitrator (
                                            // inputs:
                                             clk,
                                             egress_pipeline_fifo_in_ready,
                                             gate_egress_src_data,
                                             gate_egress_src_valid,
                                             reset_n,

                                            // outputs:
                                             egress_pipeline_fifo_in_data,
                                             egress_pipeline_fifo_in_ready_from_sa,
                                             egress_pipeline_fifo_in_reset_n,
                                             egress_pipeline_fifo_in_valid
                                          )
;

  output  [ 15: 0] egress_pipeline_fifo_in_data;
  output           egress_pipeline_fifo_in_ready_from_sa;
  output           egress_pipeline_fifo_in_reset_n;
  output           egress_pipeline_fifo_in_valid;
  input            clk;
  input            egress_pipeline_fifo_in_ready;
  input   [ 15: 0] gate_egress_src_data;
  input            gate_egress_src_valid;
  input            reset_n;

  wire    [ 15: 0] egress_pipeline_fifo_in_data;
  wire             egress_pipeline_fifo_in_ready_from_sa;
  wire             egress_pipeline_fifo_in_reset_n;
  wire             egress_pipeline_fifo_in_valid;
  //mux egress_pipeline_fifo_in_data, which is an e_mux
  assign egress_pipeline_fifo_in_data = gate_egress_src_data;

  //assign egress_pipeline_fifo_in_ready_from_sa = egress_pipeline_fifo_in_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign egress_pipeline_fifo_in_ready_from_sa = egress_pipeline_fifo_in_ready;

  //mux egress_pipeline_fifo_in_valid, which is an e_mux
  assign egress_pipeline_fifo_in_valid = gate_egress_src_valid;

  //egress_pipeline_fifo_in_reset_n assignment, which is an e_assign
  assign egress_pipeline_fifo_in_reset_n = reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module egress_pipeline_fifo_out_arbitrator (
                                             // inputs:
                                              clk,
                                              egress_fifo_in_ready_from_sa,
                                              egress_pipeline_fifo_out_data,
                                              egress_pipeline_fifo_out_valid,
                                              reset_n,

                                             // outputs:
                                              egress_pipeline_fifo_out_ready,
                                              egress_pipeline_fifo_out_reset_n
                                           )
;

  output           egress_pipeline_fifo_out_ready;
  output           egress_pipeline_fifo_out_reset_n;
  input            clk;
  input            egress_fifo_in_ready_from_sa;
  input   [ 15: 0] egress_pipeline_fifo_out_data;
  input            egress_pipeline_fifo_out_valid;
  input            reset_n;

  wire             egress_pipeline_fifo_out_ready;
  wire             egress_pipeline_fifo_out_reset_n;
  //egress_pipeline_fifo_out_reset_n assignment, which is an e_assign
  assign egress_pipeline_fifo_out_reset_n = reset_n;

  //mux egress_pipeline_fifo_out_ready, which is an e_mux
  assign egress_pipeline_fifo_out_ready = egress_fifo_in_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module gate_egress_snk_arbitrator (
                                    // inputs:
                                     TA_before_gate_out_data,
                                     TA_before_gate_out_valid,
                                     clk,
                                     reset_n,

                                    // outputs:
                                     gate_egress_snk_data,
                                     gate_egress_snk_valid
                                  )
;

  output  [ 15: 0] gate_egress_snk_data;
  output           gate_egress_snk_valid;
  input   [ 15: 0] TA_before_gate_out_data;
  input            TA_before_gate_out_valid;
  input            clk;
  input            reset_n;

  wire    [ 15: 0] gate_egress_snk_data;
  wire             gate_egress_snk_valid;
  //mux gate_egress_snk_data, which is an e_mux
  assign gate_egress_snk_data = TA_before_gate_out_data;

  //mux gate_egress_snk_valid, which is an e_mux
  assign gate_egress_snk_valid = TA_before_gate_out_valid;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module gate_ingress_snk_arbitrator (
                                     // inputs:
                                      clk,
                                      gate_ingress_snk_ready,
                                      ingress_fifo_out_data,
                                      ingress_fifo_out_valid,
                                      reset_n,

                                     // outputs:
                                      gate_ingress_snk_data,
                                      gate_ingress_snk_ready_from_sa,
                                      gate_ingress_snk_reset,
                                      gate_ingress_snk_valid
                                   )
;

  output  [ 15: 0] gate_ingress_snk_data;
  output           gate_ingress_snk_ready_from_sa;
  output           gate_ingress_snk_reset;
  output           gate_ingress_snk_valid;
  input            clk;
  input            gate_ingress_snk_ready;
  input   [ 15: 0] ingress_fifo_out_data;
  input            ingress_fifo_out_valid;
  input            reset_n;

  wire    [ 15: 0] gate_ingress_snk_data;
  wire             gate_ingress_snk_ready_from_sa;
  wire             gate_ingress_snk_reset;
  wire             gate_ingress_snk_valid;
  //mux gate_ingress_snk_data, which is an e_mux
  assign gate_ingress_snk_data = ingress_fifo_out_data;

  //assign gate_ingress_snk_ready_from_sa = gate_ingress_snk_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign gate_ingress_snk_ready_from_sa = gate_ingress_snk_ready;

  //mux gate_ingress_snk_valid, which is an e_mux
  assign gate_ingress_snk_valid = ingress_fifo_out_valid;

  //~gate_ingress_snk_reset assignment, which is an e_assign
  assign gate_ingress_snk_reset = ~reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module gate_s0_arbitrator (
                            // inputs:
                             clk,
                             gate_s0_readdata,
                             reset_n,
                             test_sys_sopc_clock_0_out_address_to_slave,
                             test_sys_sopc_clock_0_out_read,
                             test_sys_sopc_clock_0_out_write,
                             test_sys_sopc_clock_0_out_writedata,

                            // outputs:
                             d1_gate_s0_end_xfer,
                             gate_s0_readdata_from_sa,
                             gate_s0_write,
                             gate_s0_writedata,
                             test_sys_sopc_clock_0_out_granted_gate_s0,
                             test_sys_sopc_clock_0_out_qualified_request_gate_s0,
                             test_sys_sopc_clock_0_out_read_data_valid_gate_s0,
                             test_sys_sopc_clock_0_out_requests_gate_s0
                          )
;

  output           d1_gate_s0_end_xfer;
  output  [ 31: 0] gate_s0_readdata_from_sa;
  output           gate_s0_write;
  output  [ 31: 0] gate_s0_writedata;
  output           test_sys_sopc_clock_0_out_granted_gate_s0;
  output           test_sys_sopc_clock_0_out_qualified_request_gate_s0;
  output           test_sys_sopc_clock_0_out_read_data_valid_gate_s0;
  output           test_sys_sopc_clock_0_out_requests_gate_s0;
  input            clk;
  input   [ 31: 0] gate_s0_readdata;
  input            reset_n;
  input   [  1: 0] test_sys_sopc_clock_0_out_address_to_slave;
  input            test_sys_sopc_clock_0_out_read;
  input            test_sys_sopc_clock_0_out_write;
  input   [ 31: 0] test_sys_sopc_clock_0_out_writedata;

  reg              d1_gate_s0_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_gate_s0;
  wire             gate_s0_allgrants;
  wire             gate_s0_allow_new_arb_cycle;
  wire             gate_s0_any_bursting_master_saved_grant;
  wire             gate_s0_any_continuerequest;
  wire             gate_s0_arb_counter_enable;
  reg              gate_s0_arb_share_counter;
  wire             gate_s0_arb_share_counter_next_value;
  wire             gate_s0_arb_share_set_values;
  wire             gate_s0_beginbursttransfer_internal;
  wire             gate_s0_begins_xfer;
  wire             gate_s0_end_xfer;
  wire             gate_s0_firsttransfer;
  wire             gate_s0_grant_vector;
  wire             gate_s0_in_a_read_cycle;
  wire             gate_s0_in_a_write_cycle;
  wire             gate_s0_master_qreq_vector;
  wire             gate_s0_non_bursting_master_requests;
  wire    [ 31: 0] gate_s0_readdata_from_sa;
  reg              gate_s0_reg_firsttransfer;
  reg              gate_s0_slavearbiterlockenable;
  wire             gate_s0_slavearbiterlockenable2;
  wire             gate_s0_unreg_firsttransfer;
  wire             gate_s0_waits_for_read;
  wire             gate_s0_waits_for_write;
  wire             gate_s0_write;
  wire    [ 31: 0] gate_s0_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  1: 0] shifted_address_to_gate_s0_from_test_sys_sopc_clock_0_out;
  wire             test_sys_sopc_clock_0_out_arbiterlock;
  wire             test_sys_sopc_clock_0_out_arbiterlock2;
  wire             test_sys_sopc_clock_0_out_continuerequest;
  wire             test_sys_sopc_clock_0_out_granted_gate_s0;
  wire             test_sys_sopc_clock_0_out_qualified_request_gate_s0;
  wire             test_sys_sopc_clock_0_out_read_data_valid_gate_s0;
  wire             test_sys_sopc_clock_0_out_requests_gate_s0;
  wire             test_sys_sopc_clock_0_out_saved_grant_gate_s0;
  wire             wait_for_gate_s0_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~gate_s0_end_xfer;
    end


  assign gate_s0_begins_xfer = ~d1_reasons_to_wait & ((test_sys_sopc_clock_0_out_qualified_request_gate_s0));
  //assign gate_s0_readdata_from_sa = gate_s0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign gate_s0_readdata_from_sa = gate_s0_readdata;

  assign test_sys_sopc_clock_0_out_requests_gate_s0 = (1) & (test_sys_sopc_clock_0_out_read | test_sys_sopc_clock_0_out_write);
  //gate_s0_arb_share_counter set values, which is an e_mux
  assign gate_s0_arb_share_set_values = 1;

  //gate_s0_non_bursting_master_requests mux, which is an e_mux
  assign gate_s0_non_bursting_master_requests = test_sys_sopc_clock_0_out_requests_gate_s0;

  //gate_s0_any_bursting_master_saved_grant mux, which is an e_mux
  assign gate_s0_any_bursting_master_saved_grant = 0;

  //gate_s0_arb_share_counter_next_value assignment, which is an e_assign
  assign gate_s0_arb_share_counter_next_value = gate_s0_firsttransfer ? (gate_s0_arb_share_set_values - 1) : |gate_s0_arb_share_counter ? (gate_s0_arb_share_counter - 1) : 0;

  //gate_s0_allgrants all slave grants, which is an e_mux
  assign gate_s0_allgrants = |gate_s0_grant_vector;

  //gate_s0_end_xfer assignment, which is an e_assign
  assign gate_s0_end_xfer = ~(gate_s0_waits_for_read | gate_s0_waits_for_write);

  //end_xfer_arb_share_counter_term_gate_s0 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_gate_s0 = gate_s0_end_xfer & (~gate_s0_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //gate_s0_arb_share_counter arbitration counter enable, which is an e_assign
  assign gate_s0_arb_counter_enable = (end_xfer_arb_share_counter_term_gate_s0 & gate_s0_allgrants) | (end_xfer_arb_share_counter_term_gate_s0 & ~gate_s0_non_bursting_master_requests);

  //gate_s0_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          gate_s0_arb_share_counter <= 0;
      else if (gate_s0_arb_counter_enable)
          gate_s0_arb_share_counter <= gate_s0_arb_share_counter_next_value;
    end


  //gate_s0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          gate_s0_slavearbiterlockenable <= 0;
      else if ((|gate_s0_master_qreq_vector & end_xfer_arb_share_counter_term_gate_s0) | (end_xfer_arb_share_counter_term_gate_s0 & ~gate_s0_non_bursting_master_requests))
          gate_s0_slavearbiterlockenable <= |gate_s0_arb_share_counter_next_value;
    end


  //test_sys_sopc_clock_0/out gate/s0 arbiterlock, which is an e_assign
  assign test_sys_sopc_clock_0_out_arbiterlock = gate_s0_slavearbiterlockenable & test_sys_sopc_clock_0_out_continuerequest;

  //gate_s0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign gate_s0_slavearbiterlockenable2 = |gate_s0_arb_share_counter_next_value;

  //test_sys_sopc_clock_0/out gate/s0 arbiterlock2, which is an e_assign
  assign test_sys_sopc_clock_0_out_arbiterlock2 = gate_s0_slavearbiterlockenable2 & test_sys_sopc_clock_0_out_continuerequest;

  //gate_s0_any_continuerequest at least one master continues requesting, which is an e_assign
  assign gate_s0_any_continuerequest = 1;

  //test_sys_sopc_clock_0_out_continuerequest continued request, which is an e_assign
  assign test_sys_sopc_clock_0_out_continuerequest = 1;

  assign test_sys_sopc_clock_0_out_qualified_request_gate_s0 = test_sys_sopc_clock_0_out_requests_gate_s0;
  //gate_s0_writedata mux, which is an e_mux
  assign gate_s0_writedata = test_sys_sopc_clock_0_out_writedata;

  //master is always granted when requested
  assign test_sys_sopc_clock_0_out_granted_gate_s0 = test_sys_sopc_clock_0_out_qualified_request_gate_s0;

  //test_sys_sopc_clock_0/out saved-grant gate/s0, which is an e_assign
  assign test_sys_sopc_clock_0_out_saved_grant_gate_s0 = test_sys_sopc_clock_0_out_requests_gate_s0;

  //allow new arb cycle for gate/s0, which is an e_assign
  assign gate_s0_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign gate_s0_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign gate_s0_master_qreq_vector = 1;

  //gate_s0_firsttransfer first transaction, which is an e_assign
  assign gate_s0_firsttransfer = gate_s0_begins_xfer ? gate_s0_unreg_firsttransfer : gate_s0_reg_firsttransfer;

  //gate_s0_unreg_firsttransfer first transaction, which is an e_assign
  assign gate_s0_unreg_firsttransfer = ~(gate_s0_slavearbiterlockenable & gate_s0_any_continuerequest);

  //gate_s0_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          gate_s0_reg_firsttransfer <= 1'b1;
      else if (gate_s0_begins_xfer)
          gate_s0_reg_firsttransfer <= gate_s0_unreg_firsttransfer;
    end


  //gate_s0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign gate_s0_beginbursttransfer_internal = gate_s0_begins_xfer;

  //gate_s0_write assignment, which is an e_mux
  assign gate_s0_write = test_sys_sopc_clock_0_out_granted_gate_s0 & test_sys_sopc_clock_0_out_write;

  assign shifted_address_to_gate_s0_from_test_sys_sopc_clock_0_out = test_sys_sopc_clock_0_out_address_to_slave;
  //d1_gate_s0_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_gate_s0_end_xfer <= 1;
      else if (1)
          d1_gate_s0_end_xfer <= gate_s0_end_xfer;
    end


  //gate_s0_waits_for_read in a cycle, which is an e_mux
  assign gate_s0_waits_for_read = gate_s0_in_a_read_cycle & gate_s0_begins_xfer;

  //gate_s0_in_a_read_cycle assignment, which is an e_assign
  assign gate_s0_in_a_read_cycle = test_sys_sopc_clock_0_out_granted_gate_s0 & test_sys_sopc_clock_0_out_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = gate_s0_in_a_read_cycle;

  //gate_s0_waits_for_write in a cycle, which is an e_mux
  assign gate_s0_waits_for_write = gate_s0_in_a_write_cycle & 0;

  //gate_s0_in_a_write_cycle assignment, which is an e_assign
  assign gate_s0_in_a_write_cycle = test_sys_sopc_clock_0_out_granted_gate_s0 & test_sys_sopc_clock_0_out_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = gate_s0_in_a_write_cycle;

  assign wait_for_gate_s0_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //gate/s0 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else if (1)
          enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module gate_egress_src_arbitrator (
                                    // inputs:
                                     clk,
                                     egress_pipeline_fifo_in_ready_from_sa,
                                     gate_egress_src_data,
                                     gate_egress_src_valid,
                                     reset_n,

                                    // outputs:
                                     gate_egress_src_ready
                                  )
;

  output           gate_egress_src_ready;
  input            clk;
  input            egress_pipeline_fifo_in_ready_from_sa;
  input   [ 15: 0] gate_egress_src_data;
  input            gate_egress_src_valid;
  input            reset_n;

  wire             gate_egress_src_ready;
  //mux gate_egress_src_ready, which is an e_mux
  assign gate_egress_src_ready = egress_pipeline_fifo_in_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module gate_ingress_src_arbitrator (
                                     // inputs:
                                      clk,
                                      gate_ingress_src_data,
                                      gate_ingress_src_valid,
                                      reset_n
                                   )
;

  input            clk;
  input   [ 15: 0] gate_ingress_src_data;
  input            gate_ingress_src_valid;
  input            reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module gate_m0_arbitrator (
                            // inputs:
                             clk,
                             d1_ingress_fifo_out_csr_end_xfer,
                             gate_m0_address,
                             gate_m0_granted_ingress_fifo_out_csr,
                             gate_m0_qualified_request_ingress_fifo_out_csr,
                             gate_m0_read,
                             gate_m0_read_data_valid_ingress_fifo_out_csr,
                             gate_m0_requests_ingress_fifo_out_csr,
                             ingress_fifo_out_csr_readdata_from_sa,
                             reset_n,

                            // outputs:
                             gate_m0_address_to_slave,
                             gate_m0_latency_counter,
                             gate_m0_readdata,
                             gate_m0_readdatavalid,
                             gate_m0_waitrequest
                          )
;

  output  [  2: 0] gate_m0_address_to_slave;
  output           gate_m0_latency_counter;
  output  [ 31: 0] gate_m0_readdata;
  output           gate_m0_readdatavalid;
  output           gate_m0_waitrequest;
  input            clk;
  input            d1_ingress_fifo_out_csr_end_xfer;
  input   [  2: 0] gate_m0_address;
  input            gate_m0_granted_ingress_fifo_out_csr;
  input            gate_m0_qualified_request_ingress_fifo_out_csr;
  input            gate_m0_read;
  input            gate_m0_read_data_valid_ingress_fifo_out_csr;
  input            gate_m0_requests_ingress_fifo_out_csr;
  input   [ 31: 0] ingress_fifo_out_csr_readdata_from_sa;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg     [  2: 0] gate_m0_address_last_time;
  wire    [  2: 0] gate_m0_address_to_slave;
  wire             gate_m0_latency_counter;
  reg              gate_m0_read_last_time;
  wire    [ 31: 0] gate_m0_readdata;
  wire             gate_m0_readdatavalid;
  wire             gate_m0_run;
  wire             gate_m0_waitrequest;
  wire             pre_flush_gate_m0_readdatavalid;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (gate_m0_qualified_request_ingress_fifo_out_csr | ~gate_m0_requests_ingress_fifo_out_csr) & ((~gate_m0_qualified_request_ingress_fifo_out_csr | ~gate_m0_read | (1 & ~d1_ingress_fifo_out_csr_end_xfer & gate_m0_read)));

  //cascaded wait assignment, which is an e_assign
  assign gate_m0_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign gate_m0_address_to_slave = gate_m0_address[2 : 0];

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_gate_m0_readdatavalid = 0;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign gate_m0_readdatavalid = 0 |
    pre_flush_gate_m0_readdatavalid |
    gate_m0_read_data_valid_ingress_fifo_out_csr;

  //gate/m0 readdata mux, which is an e_mux
  assign gate_m0_readdata = ingress_fifo_out_csr_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign gate_m0_waitrequest = ~gate_m0_run;

  //latent max counter, which is an e_assign
  assign gate_m0_latency_counter = 0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //gate_m0_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          gate_m0_address_last_time <= 0;
      else if (1)
          gate_m0_address_last_time <= gate_m0_address;
    end


  //gate/m0 waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else if (1)
          active_and_waiting_last_time <= gate_m0_waitrequest & (gate_m0_read);
    end


  //gate_m0_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (gate_m0_address != gate_m0_address_last_time))
        begin
          $write("%0d ns: gate_m0_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //gate_m0_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          gate_m0_read_last_time <= 0;
      else if (1)
          gate_m0_read_last_time <= gate_m0_read;
    end


  //gate_m0_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (gate_m0_read != gate_m0_read_last_time))
        begin
          $write("%0d ns: gate_m0_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ingress_fifo_in_arbitrator (
                                    // inputs:
                                     DFA_before_ingress_fifo_out_data,
                                     DFA_before_ingress_fifo_out_valid,
                                     clk,
                                     ingress_fifo_in_ready,
                                     reset_n,

                                    // outputs:
                                     ingress_fifo_in_data,
                                     ingress_fifo_in_ready_from_sa,
                                     ingress_fifo_in_reset_n,
                                     ingress_fifo_in_valid
                                  )
;

  output  [ 15: 0] ingress_fifo_in_data;
  output           ingress_fifo_in_ready_from_sa;
  output           ingress_fifo_in_reset_n;
  output           ingress_fifo_in_valid;
  input   [ 15: 0] DFA_before_ingress_fifo_out_data;
  input            DFA_before_ingress_fifo_out_valid;
  input            clk;
  input            ingress_fifo_in_ready;
  input            reset_n;

  wire    [ 15: 0] ingress_fifo_in_data;
  wire             ingress_fifo_in_ready_from_sa;
  wire             ingress_fifo_in_reset_n;
  wire             ingress_fifo_in_valid;
  //mux ingress_fifo_in_data, which is an e_mux
  assign ingress_fifo_in_data = DFA_before_ingress_fifo_out_data;

  //assign ingress_fifo_in_ready_from_sa = ingress_fifo_in_ready so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ingress_fifo_in_ready_from_sa = ingress_fifo_in_ready;

  //mux ingress_fifo_in_valid, which is an e_mux
  assign ingress_fifo_in_valid = DFA_before_ingress_fifo_out_valid;

  //ingress_fifo_in_reset_n assignment, which is an e_assign
  assign ingress_fifo_in_reset_n = reset_n;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ingress_fifo_out_csr_arbitrator (
                                         // inputs:
                                          clk,
                                          gate_m0_address_to_slave,
                                          gate_m0_latency_counter,
                                          gate_m0_read,
                                          ingress_fifo_out_csr_readdata,
                                          reset_n,

                                         // outputs:
                                          d1_ingress_fifo_out_csr_end_xfer,
                                          gate_m0_granted_ingress_fifo_out_csr,
                                          gate_m0_qualified_request_ingress_fifo_out_csr,
                                          gate_m0_read_data_valid_ingress_fifo_out_csr,
                                          gate_m0_requests_ingress_fifo_out_csr,
                                          ingress_fifo_out_csr_address,
                                          ingress_fifo_out_csr_read,
                                          ingress_fifo_out_csr_readdata_from_sa,
                                          ingress_fifo_out_csr_reset_n,
                                          ingress_fifo_out_csr_write
                                       )
;

  output           d1_ingress_fifo_out_csr_end_xfer;
  output           gate_m0_granted_ingress_fifo_out_csr;
  output           gate_m0_qualified_request_ingress_fifo_out_csr;
  output           gate_m0_read_data_valid_ingress_fifo_out_csr;
  output           gate_m0_requests_ingress_fifo_out_csr;
  output           ingress_fifo_out_csr_address;
  output           ingress_fifo_out_csr_read;
  output  [ 31: 0] ingress_fifo_out_csr_readdata_from_sa;
  output           ingress_fifo_out_csr_reset_n;
  output           ingress_fifo_out_csr_write;
  input            clk;
  input   [  2: 0] gate_m0_address_to_slave;
  input            gate_m0_latency_counter;
  input            gate_m0_read;
  input   [ 31: 0] ingress_fifo_out_csr_readdata;
  input            reset_n;

  reg              d1_ingress_fifo_out_csr_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ingress_fifo_out_csr;
  wire             gate_m0_arbiterlock;
  wire             gate_m0_arbiterlock2;
  wire             gate_m0_continuerequest;
  wire             gate_m0_granted_ingress_fifo_out_csr;
  wire             gate_m0_qualified_request_ingress_fifo_out_csr;
  wire             gate_m0_read_data_valid_ingress_fifo_out_csr;
  wire             gate_m0_requests_ingress_fifo_out_csr;
  wire             gate_m0_saved_grant_ingress_fifo_out_csr;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             ingress_fifo_out_csr_address;
  wire             ingress_fifo_out_csr_allgrants;
  wire             ingress_fifo_out_csr_allow_new_arb_cycle;
  wire             ingress_fifo_out_csr_any_bursting_master_saved_grant;
  wire             ingress_fifo_out_csr_any_continuerequest;
  wire             ingress_fifo_out_csr_arb_counter_enable;
  reg              ingress_fifo_out_csr_arb_share_counter;
  wire             ingress_fifo_out_csr_arb_share_counter_next_value;
  wire             ingress_fifo_out_csr_arb_share_set_values;
  wire             ingress_fifo_out_csr_beginbursttransfer_internal;
  wire             ingress_fifo_out_csr_begins_xfer;
  wire             ingress_fifo_out_csr_end_xfer;
  wire             ingress_fifo_out_csr_firsttransfer;
  wire             ingress_fifo_out_csr_grant_vector;
  wire             ingress_fifo_out_csr_in_a_read_cycle;
  wire             ingress_fifo_out_csr_in_a_write_cycle;
  wire             ingress_fifo_out_csr_master_qreq_vector;
  wire             ingress_fifo_out_csr_non_bursting_master_requests;
  wire             ingress_fifo_out_csr_read;
  wire    [ 31: 0] ingress_fifo_out_csr_readdata_from_sa;
  reg              ingress_fifo_out_csr_reg_firsttransfer;
  wire             ingress_fifo_out_csr_reset_n;
  reg              ingress_fifo_out_csr_slavearbiterlockenable;
  wire             ingress_fifo_out_csr_slavearbiterlockenable2;
  wire             ingress_fifo_out_csr_unreg_firsttransfer;
  wire             ingress_fifo_out_csr_waits_for_read;
  wire             ingress_fifo_out_csr_waits_for_write;
  wire             ingress_fifo_out_csr_write;
  wire    [  2: 0] shifted_address_to_ingress_fifo_out_csr_from_gate_m0;
  wire             wait_for_ingress_fifo_out_csr_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~ingress_fifo_out_csr_end_xfer;
    end


  assign ingress_fifo_out_csr_begins_xfer = ~d1_reasons_to_wait & ((gate_m0_qualified_request_ingress_fifo_out_csr));
  //assign ingress_fifo_out_csr_readdata_from_sa = ingress_fifo_out_csr_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ingress_fifo_out_csr_readdata_from_sa = ingress_fifo_out_csr_readdata;

  assign gate_m0_requests_ingress_fifo_out_csr = ((1) & (gate_m0_read)) & gate_m0_read;
  //ingress_fifo_out_csr_arb_share_counter set values, which is an e_mux
  assign ingress_fifo_out_csr_arb_share_set_values = 1;

  //ingress_fifo_out_csr_non_bursting_master_requests mux, which is an e_mux
  assign ingress_fifo_out_csr_non_bursting_master_requests = gate_m0_requests_ingress_fifo_out_csr;

  //ingress_fifo_out_csr_any_bursting_master_saved_grant mux, which is an e_mux
  assign ingress_fifo_out_csr_any_bursting_master_saved_grant = 0;

  //ingress_fifo_out_csr_arb_share_counter_next_value assignment, which is an e_assign
  assign ingress_fifo_out_csr_arb_share_counter_next_value = ingress_fifo_out_csr_firsttransfer ? (ingress_fifo_out_csr_arb_share_set_values - 1) : |ingress_fifo_out_csr_arb_share_counter ? (ingress_fifo_out_csr_arb_share_counter - 1) : 0;

  //ingress_fifo_out_csr_allgrants all slave grants, which is an e_mux
  assign ingress_fifo_out_csr_allgrants = |ingress_fifo_out_csr_grant_vector;

  //ingress_fifo_out_csr_end_xfer assignment, which is an e_assign
  assign ingress_fifo_out_csr_end_xfer = ~(ingress_fifo_out_csr_waits_for_read | ingress_fifo_out_csr_waits_for_write);

  //end_xfer_arb_share_counter_term_ingress_fifo_out_csr arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ingress_fifo_out_csr = ingress_fifo_out_csr_end_xfer & (~ingress_fifo_out_csr_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ingress_fifo_out_csr_arb_share_counter arbitration counter enable, which is an e_assign
  assign ingress_fifo_out_csr_arb_counter_enable = (end_xfer_arb_share_counter_term_ingress_fifo_out_csr & ingress_fifo_out_csr_allgrants) | (end_xfer_arb_share_counter_term_ingress_fifo_out_csr & ~ingress_fifo_out_csr_non_bursting_master_requests);

  //ingress_fifo_out_csr_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ingress_fifo_out_csr_arb_share_counter <= 0;
      else if (ingress_fifo_out_csr_arb_counter_enable)
          ingress_fifo_out_csr_arb_share_counter <= ingress_fifo_out_csr_arb_share_counter_next_value;
    end


  //ingress_fifo_out_csr_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ingress_fifo_out_csr_slavearbiterlockenable <= 0;
      else if ((|ingress_fifo_out_csr_master_qreq_vector & end_xfer_arb_share_counter_term_ingress_fifo_out_csr) | (end_xfer_arb_share_counter_term_ingress_fifo_out_csr & ~ingress_fifo_out_csr_non_bursting_master_requests))
          ingress_fifo_out_csr_slavearbiterlockenable <= |ingress_fifo_out_csr_arb_share_counter_next_value;
    end


  //gate/m0 ingress_fifo/out_csr arbiterlock, which is an e_assign
  assign gate_m0_arbiterlock = ingress_fifo_out_csr_slavearbiterlockenable & gate_m0_continuerequest;

  //ingress_fifo_out_csr_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ingress_fifo_out_csr_slavearbiterlockenable2 = |ingress_fifo_out_csr_arb_share_counter_next_value;

  //gate/m0 ingress_fifo/out_csr arbiterlock2, which is an e_assign
  assign gate_m0_arbiterlock2 = ingress_fifo_out_csr_slavearbiterlockenable2 & gate_m0_continuerequest;

  //ingress_fifo_out_csr_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ingress_fifo_out_csr_any_continuerequest = 1;

  //gate_m0_continuerequest continued request, which is an e_assign
  assign gate_m0_continuerequest = 1;

  assign gate_m0_qualified_request_ingress_fifo_out_csr = gate_m0_requests_ingress_fifo_out_csr & ~((gate_m0_read & ((gate_m0_latency_counter != 0))));
  //local readdatavalid gate_m0_read_data_valid_ingress_fifo_out_csr, which is an e_mux
  assign gate_m0_read_data_valid_ingress_fifo_out_csr = gate_m0_granted_ingress_fifo_out_csr & gate_m0_read & ~ingress_fifo_out_csr_waits_for_read;

  //master is always granted when requested
  assign gate_m0_granted_ingress_fifo_out_csr = gate_m0_qualified_request_ingress_fifo_out_csr;

  //gate/m0 saved-grant ingress_fifo/out_csr, which is an e_assign
  assign gate_m0_saved_grant_ingress_fifo_out_csr = gate_m0_requests_ingress_fifo_out_csr;

  //allow new arb cycle for ingress_fifo/out_csr, which is an e_assign
  assign ingress_fifo_out_csr_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ingress_fifo_out_csr_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ingress_fifo_out_csr_master_qreq_vector = 1;

  //ingress_fifo_out_csr_reset_n assignment, which is an e_assign
  assign ingress_fifo_out_csr_reset_n = reset_n;

  //ingress_fifo_out_csr_firsttransfer first transaction, which is an e_assign
  assign ingress_fifo_out_csr_firsttransfer = ingress_fifo_out_csr_begins_xfer ? ingress_fifo_out_csr_unreg_firsttransfer : ingress_fifo_out_csr_reg_firsttransfer;

  //ingress_fifo_out_csr_unreg_firsttransfer first transaction, which is an e_assign
  assign ingress_fifo_out_csr_unreg_firsttransfer = ~(ingress_fifo_out_csr_slavearbiterlockenable & ingress_fifo_out_csr_any_continuerequest);

  //ingress_fifo_out_csr_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ingress_fifo_out_csr_reg_firsttransfer <= 1'b1;
      else if (ingress_fifo_out_csr_begins_xfer)
          ingress_fifo_out_csr_reg_firsttransfer <= ingress_fifo_out_csr_unreg_firsttransfer;
    end


  //ingress_fifo_out_csr_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ingress_fifo_out_csr_beginbursttransfer_internal = ingress_fifo_out_csr_begins_xfer;

  //ingress_fifo_out_csr_read assignment, which is an e_mux
  assign ingress_fifo_out_csr_read = gate_m0_granted_ingress_fifo_out_csr & gate_m0_read;

  //ingress_fifo_out_csr_write assignment, which is an e_mux
  assign ingress_fifo_out_csr_write = 0;

  assign shifted_address_to_ingress_fifo_out_csr_from_gate_m0 = gate_m0_address_to_slave;
  //ingress_fifo_out_csr_address mux, which is an e_mux
  assign ingress_fifo_out_csr_address = shifted_address_to_ingress_fifo_out_csr_from_gate_m0 >> 2;

  //d1_ingress_fifo_out_csr_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ingress_fifo_out_csr_end_xfer <= 1;
      else if (1)
          d1_ingress_fifo_out_csr_end_xfer <= ingress_fifo_out_csr_end_xfer;
    end


  //ingress_fifo_out_csr_waits_for_read in a cycle, which is an e_mux
  assign ingress_fifo_out_csr_waits_for_read = ingress_fifo_out_csr_in_a_read_cycle & ingress_fifo_out_csr_begins_xfer;

  //ingress_fifo_out_csr_in_a_read_cycle assignment, which is an e_assign
  assign ingress_fifo_out_csr_in_a_read_cycle = gate_m0_granted_ingress_fifo_out_csr & gate_m0_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ingress_fifo_out_csr_in_a_read_cycle;

  //ingress_fifo_out_csr_waits_for_write in a cycle, which is an e_mux
  assign ingress_fifo_out_csr_waits_for_write = ingress_fifo_out_csr_in_a_write_cycle & 0;

  //ingress_fifo_out_csr_in_a_write_cycle assignment, which is an e_assign
  assign ingress_fifo_out_csr_in_a_write_cycle = 0;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ingress_fifo_out_csr_in_a_write_cycle;

  assign wait_for_ingress_fifo_out_csr_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ingress_fifo/out_csr enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else if (1)
          enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ingress_fifo_out_arbitrator (
                                     // inputs:
                                      clk,
                                      gate_ingress_snk_ready_from_sa,
                                      ingress_fifo_out_data,
                                      ingress_fifo_out_valid,
                                      reset_n,

                                     // outputs:
                                      ingress_fifo_out_ready
                                   )
;

  output           ingress_fifo_out_ready;
  input            clk;
  input            gate_ingress_snk_ready_from_sa;
  input   [ 15: 0] ingress_fifo_out_data;
  input            ingress_fifo_out_valid;
  input            reset_n;

  wire             ingress_fifo_out_ready;
  //mux ingress_fifo_out_ready, which is an e_mux
  assign ingress_fifo_out_ready = gate_ingress_snk_ready_from_sa;


endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module pll_s1_arbitrator (
                           // inputs:
                            clk,
                            pll_master_m0_address_to_slave,
                            pll_master_m0_read,
                            pll_master_m0_write,
                            pll_master_m0_writedata,
                            pll_s1_readdata,
                            pll_s1_resetrequest,
                            reset_n,

                           // outputs:
                            d1_pll_s1_end_xfer,
                            pll_master_granted_pll_s1,
                            pll_master_qualified_request_pll_s1,
                            pll_master_read_data_valid_pll_s1,
                            pll_master_requests_pll_s1,
                            pll_s1_address,
                            pll_s1_chipselect,
                            pll_s1_read,
                            pll_s1_readdata_from_sa,
                            pll_s1_reset_n,
                            pll_s1_resetrequest_from_sa,
                            pll_s1_write,
                            pll_s1_writedata
                         )
;

  output           d1_pll_s1_end_xfer;
  output           pll_master_granted_pll_s1;
  output           pll_master_qualified_request_pll_s1;
  output           pll_master_read_data_valid_pll_s1;
  output           pll_master_requests_pll_s1;
  output  [  2: 0] pll_s1_address;
  output           pll_s1_chipselect;
  output           pll_s1_read;
  output  [ 15: 0] pll_s1_readdata_from_sa;
  output           pll_s1_reset_n;
  output           pll_s1_resetrequest_from_sa;
  output           pll_s1_write;
  output  [ 15: 0] pll_s1_writedata;
  input            clk;
  input   [  4: 0] pll_master_m0_address_to_slave;
  input            pll_master_m0_read;
  input            pll_master_m0_write;
  input   [ 31: 0] pll_master_m0_writedata;
  input   [ 15: 0] pll_s1_readdata;
  input            pll_s1_resetrequest;
  input            reset_n;

  reg              d1_pll_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pll_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pll_master_granted_pll_s1;
  wire             pll_master_m0_arbiterlock;
  wire             pll_master_m0_arbiterlock2;
  wire             pll_master_m0_continuerequest;
  wire             pll_master_qualified_request_pll_s1;
  wire             pll_master_read_data_valid_pll_s1;
  wire             pll_master_requests_pll_s1;
  wire             pll_master_saved_grant_pll_s1;
  wire    [  2: 0] pll_s1_address;
  wire             pll_s1_allgrants;
  wire             pll_s1_allow_new_arb_cycle;
  wire             pll_s1_any_bursting_master_saved_grant;
  wire             pll_s1_any_continuerequest;
  wire             pll_s1_arb_counter_enable;
  reg              pll_s1_arb_share_counter;
  wire             pll_s1_arb_share_counter_next_value;
  wire             pll_s1_arb_share_set_values;
  wire             pll_s1_beginbursttransfer_internal;
  wire             pll_s1_begins_xfer;
  wire             pll_s1_chipselect;
  wire             pll_s1_end_xfer;
  wire             pll_s1_firsttransfer;
  wire             pll_s1_grant_vector;
  wire             pll_s1_in_a_read_cycle;
  wire             pll_s1_in_a_write_cycle;
  wire             pll_s1_master_qreq_vector;
  wire             pll_s1_non_bursting_master_requests;
  wire             pll_s1_read;
  wire    [ 15: 0] pll_s1_readdata_from_sa;
  reg              pll_s1_reg_firsttransfer;
  wire             pll_s1_reset_n;
  wire             pll_s1_resetrequest_from_sa;
  reg              pll_s1_slavearbiterlockenable;
  wire             pll_s1_slavearbiterlockenable2;
  wire             pll_s1_unreg_firsttransfer;
  wire             pll_s1_waits_for_read;
  wire             pll_s1_waits_for_write;
  wire             pll_s1_write;
  wire    [ 15: 0] pll_s1_writedata;
  wire    [  4: 0] shifted_address_to_pll_s1_from_pll_master_m0;
  wire             wait_for_pll_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~pll_s1_end_xfer;
    end


  assign pll_s1_begins_xfer = ~d1_reasons_to_wait & ((pll_master_qualified_request_pll_s1));
  //assign pll_s1_readdata_from_sa = pll_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pll_s1_readdata_from_sa = pll_s1_readdata;

  assign pll_master_requests_pll_s1 = (1) & (pll_master_m0_read | pll_master_m0_write);
  //pll_s1_arb_share_counter set values, which is an e_mux
  assign pll_s1_arb_share_set_values = 1;

  //pll_s1_non_bursting_master_requests mux, which is an e_mux
  assign pll_s1_non_bursting_master_requests = pll_master_requests_pll_s1;

  //pll_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign pll_s1_any_bursting_master_saved_grant = 0;

  //pll_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign pll_s1_arb_share_counter_next_value = pll_s1_firsttransfer ? (pll_s1_arb_share_set_values - 1) : |pll_s1_arb_share_counter ? (pll_s1_arb_share_counter - 1) : 0;

  //pll_s1_allgrants all slave grants, which is an e_mux
  assign pll_s1_allgrants = |pll_s1_grant_vector;

  //pll_s1_end_xfer assignment, which is an e_assign
  assign pll_s1_end_xfer = ~(pll_s1_waits_for_read | pll_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_pll_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pll_s1 = pll_s1_end_xfer & (~pll_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pll_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign pll_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_pll_s1 & pll_s1_allgrants) | (end_xfer_arb_share_counter_term_pll_s1 & ~pll_s1_non_bursting_master_requests);

  //pll_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_s1_arb_share_counter <= 0;
      else if (pll_s1_arb_counter_enable)
          pll_s1_arb_share_counter <= pll_s1_arb_share_counter_next_value;
    end


  //pll_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_s1_slavearbiterlockenable <= 0;
      else if ((|pll_s1_master_qreq_vector & end_xfer_arb_share_counter_term_pll_s1) | (end_xfer_arb_share_counter_term_pll_s1 & ~pll_s1_non_bursting_master_requests))
          pll_s1_slavearbiterlockenable <= |pll_s1_arb_share_counter_next_value;
    end


  //pll_master/m0 pll/s1 arbiterlock, which is an e_assign
  assign pll_master_m0_arbiterlock = pll_s1_slavearbiterlockenable & pll_master_m0_continuerequest;

  //pll_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pll_s1_slavearbiterlockenable2 = |pll_s1_arb_share_counter_next_value;

  //pll_master/m0 pll/s1 arbiterlock2, which is an e_assign
  assign pll_master_m0_arbiterlock2 = pll_s1_slavearbiterlockenable2 & pll_master_m0_continuerequest;

  //pll_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign pll_s1_any_continuerequest = 1;

  //pll_master_m0_continuerequest continued request, which is an e_assign
  assign pll_master_m0_continuerequest = 1;

  assign pll_master_qualified_request_pll_s1 = pll_master_requests_pll_s1;
  //pll_s1_writedata mux, which is an e_mux
  assign pll_s1_writedata = pll_master_m0_writedata;

  //master is always granted when requested
  assign pll_master_granted_pll_s1 = pll_master_qualified_request_pll_s1;

  //pll_master/m0 saved-grant pll/s1, which is an e_assign
  assign pll_master_saved_grant_pll_s1 = pll_master_requests_pll_s1;

  //allow new arb cycle for pll/s1, which is an e_assign
  assign pll_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign pll_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign pll_s1_master_qreq_vector = 1;

  //pll_s1_reset_n assignment, which is an e_assign
  assign pll_s1_reset_n = reset_n;

  //assign pll_s1_resetrequest_from_sa = pll_s1_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pll_s1_resetrequest_from_sa = pll_s1_resetrequest;

  assign pll_s1_chipselect = pll_master_granted_pll_s1;
  //pll_s1_firsttransfer first transaction, which is an e_assign
  assign pll_s1_firsttransfer = pll_s1_begins_xfer ? pll_s1_unreg_firsttransfer : pll_s1_reg_firsttransfer;

  //pll_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign pll_s1_unreg_firsttransfer = ~(pll_s1_slavearbiterlockenable & pll_s1_any_continuerequest);

  //pll_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_s1_reg_firsttransfer <= 1'b1;
      else if (pll_s1_begins_xfer)
          pll_s1_reg_firsttransfer <= pll_s1_unreg_firsttransfer;
    end


  //pll_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pll_s1_beginbursttransfer_internal = pll_s1_begins_xfer;

  //pll_s1_read assignment, which is an e_mux
  assign pll_s1_read = pll_master_granted_pll_s1 & pll_master_m0_read;

  //pll_s1_write assignment, which is an e_mux
  assign pll_s1_write = pll_master_granted_pll_s1 & pll_master_m0_write;

  assign shifted_address_to_pll_s1_from_pll_master_m0 = pll_master_m0_address_to_slave;
  //pll_s1_address mux, which is an e_mux
  assign pll_s1_address = shifted_address_to_pll_s1_from_pll_master_m0 >> 2;

  //d1_pll_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pll_s1_end_xfer <= 1;
      else if (1)
          d1_pll_s1_end_xfer <= pll_s1_end_xfer;
    end


  //pll_s1_waits_for_read in a cycle, which is an e_mux
  assign pll_s1_waits_for_read = pll_s1_in_a_read_cycle & pll_s1_begins_xfer;

  //pll_s1_in_a_read_cycle assignment, which is an e_assign
  assign pll_s1_in_a_read_cycle = pll_master_granted_pll_s1 & pll_master_m0_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pll_s1_in_a_read_cycle;

  //pll_s1_waits_for_write in a cycle, which is an e_mux
  assign pll_s1_waits_for_write = pll_s1_in_a_write_cycle & 0;

  //pll_s1_in_a_write_cycle assignment, which is an e_assign
  assign pll_s1_in_a_write_cycle = pll_master_granted_pll_s1 & pll_master_m0_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pll_s1_in_a_write_cycle;

  assign wait_for_pll_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pll/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else if (1)
          enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module pll_master_m0_arbitrator (
                                  // inputs:
                                   clk,
                                   d1_pll_s1_end_xfer,
                                   pll_master_granted_pll_s1,
                                   pll_master_m0_address,
                                   pll_master_m0_byteenable,
                                   pll_master_m0_read,
                                   pll_master_m0_write,
                                   pll_master_m0_writedata,
                                   pll_master_qualified_request_pll_s1,
                                   pll_master_read_data_valid_pll_s1,
                                   pll_master_requests_pll_s1,
                                   pll_s1_readdata_from_sa,
                                   reset_n,

                                  // outputs:
                                   pll_master_m0_address_to_slave,
                                   pll_master_m0_readdata,
                                   pll_master_m0_reset,
                                   pll_master_m0_waitrequest
                                )
;

  output  [  4: 0] pll_master_m0_address_to_slave;
  output  [ 31: 0] pll_master_m0_readdata;
  output           pll_master_m0_reset;
  output           pll_master_m0_waitrequest;
  input            clk;
  input            d1_pll_s1_end_xfer;
  input            pll_master_granted_pll_s1;
  input   [  4: 0] pll_master_m0_address;
  input   [  3: 0] pll_master_m0_byteenable;
  input            pll_master_m0_read;
  input            pll_master_m0_write;
  input   [ 31: 0] pll_master_m0_writedata;
  input            pll_master_qualified_request_pll_s1;
  input            pll_master_read_data_valid_pll_s1;
  input            pll_master_requests_pll_s1;
  input   [ 15: 0] pll_s1_readdata_from_sa;
  input            reset_n;

  reg              active_and_waiting_last_time;
  reg     [  4: 0] pll_master_m0_address_last_time;
  wire    [  4: 0] pll_master_m0_address_to_slave;
  reg     [  3: 0] pll_master_m0_byteenable_last_time;
  reg              pll_master_m0_read_last_time;
  wire    [ 31: 0] pll_master_m0_readdata;
  wire             pll_master_m0_reset;
  wire             pll_master_m0_run;
  wire             pll_master_m0_waitrequest;
  reg              pll_master_m0_write_last_time;
  reg     [ 31: 0] pll_master_m0_writedata_last_time;
  wire             r_0;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~pll_master_qualified_request_pll_s1 | ~pll_master_m0_read | (1 & ~d1_pll_s1_end_xfer & pll_master_m0_read))) & ((~pll_master_qualified_request_pll_s1 | ~pll_master_m0_write | (1 & pll_master_m0_write)));

  //cascaded wait assignment, which is an e_assign
  assign pll_master_m0_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign pll_master_m0_address_to_slave = pll_master_m0_address[4 : 0];

  //pll_master/m0 readdata mux, which is an e_mux
  assign pll_master_m0_readdata = pll_s1_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign pll_master_m0_waitrequest = ~pll_master_m0_run;

  //~pll_master_m0_reset assignment, which is an e_assign
  assign pll_master_m0_reset = ~reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pll_master_m0_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_master_m0_address_last_time <= 0;
      else if (1)
          pll_master_m0_address_last_time <= pll_master_m0_address;
    end


  //pll_master/m0 waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else if (1)
          active_and_waiting_last_time <= pll_master_m0_waitrequest & (pll_master_m0_read | pll_master_m0_write);
    end


  //pll_master_m0_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pll_master_m0_address != pll_master_m0_address_last_time))
        begin
          $write("%0d ns: pll_master_m0_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pll_master_m0_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_master_m0_byteenable_last_time <= 0;
      else if (1)
          pll_master_m0_byteenable_last_time <= pll_master_m0_byteenable;
    end


  //pll_master_m0_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pll_master_m0_byteenable != pll_master_m0_byteenable_last_time))
        begin
          $write("%0d ns: pll_master_m0_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pll_master_m0_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_master_m0_read_last_time <= 0;
      else if (1)
          pll_master_m0_read_last_time <= pll_master_m0_read;
    end


  //pll_master_m0_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pll_master_m0_read != pll_master_m0_read_last_time))
        begin
          $write("%0d ns: pll_master_m0_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pll_master_m0_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_master_m0_write_last_time <= 0;
      else if (1)
          pll_master_m0_write_last_time <= pll_master_m0_write;
    end


  //pll_master_m0_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pll_master_m0_write != pll_master_m0_write_last_time))
        begin
          $write("%0d ns: pll_master_m0_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pll_master_m0_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pll_master_m0_writedata_last_time <= 0;
      else if (1)
          pll_master_m0_writedata_last_time <= pll_master_m0_writedata;
    end


  //pll_master_m0_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pll_master_m0_writedata != pll_master_m0_writedata_last_time) & pll_master_m0_write)
        begin
          $write("%0d ns: pll_master_m0_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sysid_control_slave_arbitrator (
                                        // inputs:
                                         clk,
                                         console_master_latency_counter,
                                         console_master_master_address_to_slave,
                                         console_master_master_read,
                                         console_master_master_write,
                                         reset_n,
                                         sysid_control_slave_readdata,

                                        // outputs:
                                         console_master_granted_sysid_control_slave,
                                         console_master_qualified_request_sysid_control_slave,
                                         console_master_read_data_valid_sysid_control_slave,
                                         console_master_requests_sysid_control_slave,
                                         d1_sysid_control_slave_end_xfer,
                                         sysid_control_slave_address,
                                         sysid_control_slave_readdata_from_sa
                                      )
;

  output           console_master_granted_sysid_control_slave;
  output           console_master_qualified_request_sysid_control_slave;
  output           console_master_read_data_valid_sysid_control_slave;
  output           console_master_requests_sysid_control_slave;
  output           d1_sysid_control_slave_end_xfer;
  output           sysid_control_slave_address;
  output  [ 31: 0] sysid_control_slave_readdata_from_sa;
  input            clk;
  input            console_master_latency_counter;
  input   [ 31: 0] console_master_master_address_to_slave;
  input            console_master_master_read;
  input            console_master_master_write;
  input            reset_n;
  input   [ 31: 0] sysid_control_slave_readdata;

  wire             console_master_granted_sysid_control_slave;
  wire             console_master_master_arbiterlock;
  wire             console_master_master_arbiterlock2;
  wire             console_master_master_continuerequest;
  wire             console_master_qualified_request_sysid_control_slave;
  wire             console_master_read_data_valid_sysid_control_slave;
  wire             console_master_requests_sysid_control_slave;
  wire             console_master_saved_grant_sysid_control_slave;
  reg              d1_reasons_to_wait;
  reg              d1_sysid_control_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sysid_control_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [ 31: 0] shifted_address_to_sysid_control_slave_from_console_master_master;
  wire             sysid_control_slave_address;
  wire             sysid_control_slave_allgrants;
  wire             sysid_control_slave_allow_new_arb_cycle;
  wire             sysid_control_slave_any_bursting_master_saved_grant;
  wire             sysid_control_slave_any_continuerequest;
  wire             sysid_control_slave_arb_counter_enable;
  reg              sysid_control_slave_arb_share_counter;
  wire             sysid_control_slave_arb_share_counter_next_value;
  wire             sysid_control_slave_arb_share_set_values;
  wire             sysid_control_slave_beginbursttransfer_internal;
  wire             sysid_control_slave_begins_xfer;
  wire             sysid_control_slave_end_xfer;
  wire             sysid_control_slave_firsttransfer;
  wire             sysid_control_slave_grant_vector;
  wire             sysid_control_slave_in_a_read_cycle;
  wire             sysid_control_slave_in_a_write_cycle;
  wire             sysid_control_slave_master_qreq_vector;
  wire             sysid_control_slave_non_bursting_master_requests;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  reg              sysid_control_slave_reg_firsttransfer;
  reg              sysid_control_slave_slavearbiterlockenable;
  wire             sysid_control_slave_slavearbiterlockenable2;
  wire             sysid_control_slave_unreg_firsttransfer;
  wire             sysid_control_slave_waits_for_read;
  wire             sysid_control_slave_waits_for_write;
  wire             wait_for_sysid_control_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~sysid_control_slave_end_xfer;
    end


  assign sysid_control_slave_begins_xfer = ~d1_reasons_to_wait & ((console_master_qualified_request_sysid_control_slave));
  //assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata;

  assign console_master_requests_sysid_control_slave = (({console_master_master_address_to_slave[31 : 3] , 3'b0} == 32'h0) & (console_master_master_read | console_master_master_write)) & console_master_master_read;
  //sysid_control_slave_arb_share_counter set values, which is an e_mux
  assign sysid_control_slave_arb_share_set_values = 1;

  //sysid_control_slave_non_bursting_master_requests mux, which is an e_mux
  assign sysid_control_slave_non_bursting_master_requests = console_master_requests_sysid_control_slave;

  //sysid_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign sysid_control_slave_any_bursting_master_saved_grant = 0;

  //sysid_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign sysid_control_slave_arb_share_counter_next_value = sysid_control_slave_firsttransfer ? (sysid_control_slave_arb_share_set_values - 1) : |sysid_control_slave_arb_share_counter ? (sysid_control_slave_arb_share_counter - 1) : 0;

  //sysid_control_slave_allgrants all slave grants, which is an e_mux
  assign sysid_control_slave_allgrants = |sysid_control_slave_grant_vector;

  //sysid_control_slave_end_xfer assignment, which is an e_assign
  assign sysid_control_slave_end_xfer = ~(sysid_control_slave_waits_for_read | sysid_control_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_sysid_control_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sysid_control_slave = sysid_control_slave_end_xfer & (~sysid_control_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sysid_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign sysid_control_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_sysid_control_slave & sysid_control_slave_allgrants) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests);

  //sysid_control_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_arb_share_counter <= 0;
      else if (sysid_control_slave_arb_counter_enable)
          sysid_control_slave_arb_share_counter <= sysid_control_slave_arb_share_counter_next_value;
    end


  //sysid_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_slavearbiterlockenable <= 0;
      else if ((|sysid_control_slave_master_qreq_vector & end_xfer_arb_share_counter_term_sysid_control_slave) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests))
          sysid_control_slave_slavearbiterlockenable <= |sysid_control_slave_arb_share_counter_next_value;
    end


  //console_master/master sysid/control_slave arbiterlock, which is an e_assign
  assign console_master_master_arbiterlock = sysid_control_slave_slavearbiterlockenable & console_master_master_continuerequest;

  //sysid_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sysid_control_slave_slavearbiterlockenable2 = |sysid_control_slave_arb_share_counter_next_value;

  //console_master/master sysid/control_slave arbiterlock2, which is an e_assign
  assign console_master_master_arbiterlock2 = sysid_control_slave_slavearbiterlockenable2 & console_master_master_continuerequest;

  //sysid_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sysid_control_slave_any_continuerequest = 1;

  //console_master_master_continuerequest continued request, which is an e_assign
  assign console_master_master_continuerequest = 1;

  assign console_master_qualified_request_sysid_control_slave = console_master_requests_sysid_control_slave & ~((console_master_master_read & ((console_master_latency_counter != 0))));
  //local readdatavalid console_master_read_data_valid_sysid_control_slave, which is an e_mux
  assign console_master_read_data_valid_sysid_control_slave = console_master_granted_sysid_control_slave & console_master_master_read & ~sysid_control_slave_waits_for_read;

  //master is always granted when requested
  assign console_master_granted_sysid_control_slave = console_master_qualified_request_sysid_control_slave;

  //console_master/master saved-grant sysid/control_slave, which is an e_assign
  assign console_master_saved_grant_sysid_control_slave = console_master_requests_sysid_control_slave;

  //allow new arb cycle for sysid/control_slave, which is an e_assign
  assign sysid_control_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sysid_control_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sysid_control_slave_master_qreq_vector = 1;

  //sysid_control_slave_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_firsttransfer = sysid_control_slave_begins_xfer ? sysid_control_slave_unreg_firsttransfer : sysid_control_slave_reg_firsttransfer;

  //sysid_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_unreg_firsttransfer = ~(sysid_control_slave_slavearbiterlockenable & sysid_control_slave_any_continuerequest);

  //sysid_control_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_reg_firsttransfer <= 1'b1;
      else if (sysid_control_slave_begins_xfer)
          sysid_control_slave_reg_firsttransfer <= sysid_control_slave_unreg_firsttransfer;
    end


  //sysid_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sysid_control_slave_beginbursttransfer_internal = sysid_control_slave_begins_xfer;

  assign shifted_address_to_sysid_control_slave_from_console_master_master = console_master_master_address_to_slave;
  //sysid_control_slave_address mux, which is an e_mux
  assign sysid_control_slave_address = shifted_address_to_sysid_control_slave_from_console_master_master >> 2;

  //d1_sysid_control_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sysid_control_slave_end_xfer <= 1;
      else if (1)
          d1_sysid_control_slave_end_xfer <= sysid_control_slave_end_xfer;
    end


  //sysid_control_slave_waits_for_read in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_read = sysid_control_slave_in_a_read_cycle & sysid_control_slave_begins_xfer;

  //sysid_control_slave_in_a_read_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_read_cycle = console_master_granted_sysid_control_slave & console_master_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sysid_control_slave_in_a_read_cycle;

  //sysid_control_slave_waits_for_write in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_write = sysid_control_slave_in_a_write_cycle & 0;

  //sysid_control_slave_in_a_write_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_write_cycle = console_master_granted_sysid_control_slave & console_master_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sysid_control_slave_in_a_write_cycle;

  assign wait_for_sysid_control_slave_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sysid/control_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else if (1)
          enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module test_sys_sopc_clock_0_in_arbitrator (
                                             // inputs:
                                              clk,
                                              console_master_latency_counter,
                                              console_master_master_address_to_slave,
                                              console_master_master_byteenable,
                                              console_master_master_read,
                                              console_master_master_write,
                                              console_master_master_writedata,
                                              reset_n,
                                              test_sys_sopc_clock_0_in_endofpacket,
                                              test_sys_sopc_clock_0_in_readdata,
                                              test_sys_sopc_clock_0_in_waitrequest,

                                             // outputs:
                                              console_master_granted_test_sys_sopc_clock_0_in,
                                              console_master_qualified_request_test_sys_sopc_clock_0_in,
                                              console_master_read_data_valid_test_sys_sopc_clock_0_in,
                                              console_master_requests_test_sys_sopc_clock_0_in,
                                              d1_test_sys_sopc_clock_0_in_end_xfer,
                                              test_sys_sopc_clock_0_in_address,
                                              test_sys_sopc_clock_0_in_byteenable,
                                              test_sys_sopc_clock_0_in_endofpacket_from_sa,
                                              test_sys_sopc_clock_0_in_nativeaddress,
                                              test_sys_sopc_clock_0_in_read,
                                              test_sys_sopc_clock_0_in_readdata_from_sa,
                                              test_sys_sopc_clock_0_in_reset_n,
                                              test_sys_sopc_clock_0_in_waitrequest_from_sa,
                                              test_sys_sopc_clock_0_in_write,
                                              test_sys_sopc_clock_0_in_writedata
                                           )
;

  output           console_master_granted_test_sys_sopc_clock_0_in;
  output           console_master_qualified_request_test_sys_sopc_clock_0_in;
  output           console_master_read_data_valid_test_sys_sopc_clock_0_in;
  output           console_master_requests_test_sys_sopc_clock_0_in;
  output           d1_test_sys_sopc_clock_0_in_end_xfer;
  output  [  1: 0] test_sys_sopc_clock_0_in_address;
  output  [  3: 0] test_sys_sopc_clock_0_in_byteenable;
  output           test_sys_sopc_clock_0_in_endofpacket_from_sa;
  output           test_sys_sopc_clock_0_in_nativeaddress;
  output           test_sys_sopc_clock_0_in_read;
  output  [ 31: 0] test_sys_sopc_clock_0_in_readdata_from_sa;
  output           test_sys_sopc_clock_0_in_reset_n;
  output           test_sys_sopc_clock_0_in_waitrequest_from_sa;
  output           test_sys_sopc_clock_0_in_write;
  output  [ 31: 0] test_sys_sopc_clock_0_in_writedata;
  input            clk;
  input            console_master_latency_counter;
  input   [ 31: 0] console_master_master_address_to_slave;
  input   [  3: 0] console_master_master_byteenable;
  input            console_master_master_read;
  input            console_master_master_write;
  input   [ 31: 0] console_master_master_writedata;
  input            reset_n;
  input            test_sys_sopc_clock_0_in_endofpacket;
  input   [ 31: 0] test_sys_sopc_clock_0_in_readdata;
  input            test_sys_sopc_clock_0_in_waitrequest;

  wire             console_master_granted_test_sys_sopc_clock_0_in;
  wire             console_master_master_arbiterlock;
  wire             console_master_master_arbiterlock2;
  wire             console_master_master_continuerequest;
  wire             console_master_qualified_request_test_sys_sopc_clock_0_in;
  wire             console_master_read_data_valid_test_sys_sopc_clock_0_in;
  wire             console_master_requests_test_sys_sopc_clock_0_in;
  wire             console_master_saved_grant_test_sys_sopc_clock_0_in;
  reg              d1_reasons_to_wait;
  reg              d1_test_sys_sopc_clock_0_in_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_test_sys_sopc_clock_0_in;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire    [  1: 0] test_sys_sopc_clock_0_in_address;
  wire             test_sys_sopc_clock_0_in_allgrants;
  wire             test_sys_sopc_clock_0_in_allow_new_arb_cycle;
  wire             test_sys_sopc_clock_0_in_any_bursting_master_saved_grant;
  wire             test_sys_sopc_clock_0_in_any_continuerequest;
  wire             test_sys_sopc_clock_0_in_arb_counter_enable;
  reg              test_sys_sopc_clock_0_in_arb_share_counter;
  wire             test_sys_sopc_clock_0_in_arb_share_counter_next_value;
  wire             test_sys_sopc_clock_0_in_arb_share_set_values;
  wire             test_sys_sopc_clock_0_in_beginbursttransfer_internal;
  wire             test_sys_sopc_clock_0_in_begins_xfer;
  wire    [  3: 0] test_sys_sopc_clock_0_in_byteenable;
  wire             test_sys_sopc_clock_0_in_end_xfer;
  wire             test_sys_sopc_clock_0_in_endofpacket_from_sa;
  wire             test_sys_sopc_clock_0_in_firsttransfer;
  wire             test_sys_sopc_clock_0_in_grant_vector;
  wire             test_sys_sopc_clock_0_in_in_a_read_cycle;
  wire             test_sys_sopc_clock_0_in_in_a_write_cycle;
  wire             test_sys_sopc_clock_0_in_master_qreq_vector;
  wire             test_sys_sopc_clock_0_in_nativeaddress;
  wire             test_sys_sopc_clock_0_in_non_bursting_master_requests;
  wire             test_sys_sopc_clock_0_in_read;
  wire    [ 31: 0] test_sys_sopc_clock_0_in_readdata_from_sa;
  reg              test_sys_sopc_clock_0_in_reg_firsttransfer;
  wire             test_sys_sopc_clock_0_in_reset_n;
  reg              test_sys_sopc_clock_0_in_slavearbiterlockenable;
  wire             test_sys_sopc_clock_0_in_slavearbiterlockenable2;
  wire             test_sys_sopc_clock_0_in_unreg_firsttransfer;
  wire             test_sys_sopc_clock_0_in_waitrequest_from_sa;
  wire             test_sys_sopc_clock_0_in_waits_for_read;
  wire             test_sys_sopc_clock_0_in_waits_for_write;
  wire             test_sys_sopc_clock_0_in_write;
  wire    [ 31: 0] test_sys_sopc_clock_0_in_writedata;
  wire             wait_for_test_sys_sopc_clock_0_in_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else if (1)
          d1_reasons_to_wait <= ~test_sys_sopc_clock_0_in_end_xfer;
    end


  assign test_sys_sopc_clock_0_in_begins_xfer = ~d1_reasons_to_wait & ((console_master_qualified_request_test_sys_sopc_clock_0_in));
  //assign test_sys_sopc_clock_0_in_readdata_from_sa = test_sys_sopc_clock_0_in_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign test_sys_sopc_clock_0_in_readdata_from_sa = test_sys_sopc_clock_0_in_readdata;

  assign console_master_requests_test_sys_sopc_clock_0_in = ({console_master_master_address_to_slave[31 : 2] , 2'b0} == 32'hc) & (console_master_master_read | console_master_master_write);
  //assign test_sys_sopc_clock_0_in_waitrequest_from_sa = test_sys_sopc_clock_0_in_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign test_sys_sopc_clock_0_in_waitrequest_from_sa = test_sys_sopc_clock_0_in_waitrequest;

  //test_sys_sopc_clock_0_in_arb_share_counter set values, which is an e_mux
  assign test_sys_sopc_clock_0_in_arb_share_set_values = 1;

  //test_sys_sopc_clock_0_in_non_bursting_master_requests mux, which is an e_mux
  assign test_sys_sopc_clock_0_in_non_bursting_master_requests = console_master_requests_test_sys_sopc_clock_0_in;

  //test_sys_sopc_clock_0_in_any_bursting_master_saved_grant mux, which is an e_mux
  assign test_sys_sopc_clock_0_in_any_bursting_master_saved_grant = 0;

  //test_sys_sopc_clock_0_in_arb_share_counter_next_value assignment, which is an e_assign
  assign test_sys_sopc_clock_0_in_arb_share_counter_next_value = test_sys_sopc_clock_0_in_firsttransfer ? (test_sys_sopc_clock_0_in_arb_share_set_values - 1) : |test_sys_sopc_clock_0_in_arb_share_counter ? (test_sys_sopc_clock_0_in_arb_share_counter - 1) : 0;

  //test_sys_sopc_clock_0_in_allgrants all slave grants, which is an e_mux
  assign test_sys_sopc_clock_0_in_allgrants = |test_sys_sopc_clock_0_in_grant_vector;

  //test_sys_sopc_clock_0_in_end_xfer assignment, which is an e_assign
  assign test_sys_sopc_clock_0_in_end_xfer = ~(test_sys_sopc_clock_0_in_waits_for_read | test_sys_sopc_clock_0_in_waits_for_write);

  //end_xfer_arb_share_counter_term_test_sys_sopc_clock_0_in arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_test_sys_sopc_clock_0_in = test_sys_sopc_clock_0_in_end_xfer & (~test_sys_sopc_clock_0_in_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //test_sys_sopc_clock_0_in_arb_share_counter arbitration counter enable, which is an e_assign
  assign test_sys_sopc_clock_0_in_arb_counter_enable = (end_xfer_arb_share_counter_term_test_sys_sopc_clock_0_in & test_sys_sopc_clock_0_in_allgrants) | (end_xfer_arb_share_counter_term_test_sys_sopc_clock_0_in & ~test_sys_sopc_clock_0_in_non_bursting_master_requests);

  //test_sys_sopc_clock_0_in_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          test_sys_sopc_clock_0_in_arb_share_counter <= 0;
      else if (test_sys_sopc_clock_0_in_arb_counter_enable)
          test_sys_sopc_clock_0_in_arb_share_counter <= test_sys_sopc_clock_0_in_arb_share_counter_next_value;
    end


  //test_sys_sopc_clock_0_in_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          test_sys_sopc_clock_0_in_slavearbiterlockenable <= 0;
      else if ((|test_sys_sopc_clock_0_in_master_qreq_vector & end_xfer_arb_share_counter_term_test_sys_sopc_clock_0_in) | (end_xfer_arb_share_counter_term_test_sys_sopc_clock_0_in & ~test_sys_sopc_clock_0_in_non_bursting_master_requests))
          test_sys_sopc_clock_0_in_slavearbiterlockenable <= |test_sys_sopc_clock_0_in_arb_share_counter_next_value;
    end


  //console_master/master test_sys_sopc_clock_0/in arbiterlock, which is an e_assign
  assign console_master_master_arbiterlock = test_sys_sopc_clock_0_in_slavearbiterlockenable & console_master_master_continuerequest;

  //test_sys_sopc_clock_0_in_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign test_sys_sopc_clock_0_in_slavearbiterlockenable2 = |test_sys_sopc_clock_0_in_arb_share_counter_next_value;

  //console_master/master test_sys_sopc_clock_0/in arbiterlock2, which is an e_assign
  assign console_master_master_arbiterlock2 = test_sys_sopc_clock_0_in_slavearbiterlockenable2 & console_master_master_continuerequest;

  //test_sys_sopc_clock_0_in_any_continuerequest at least one master continues requesting, which is an e_assign
  assign test_sys_sopc_clock_0_in_any_continuerequest = 1;

  //console_master_master_continuerequest continued request, which is an e_assign
  assign console_master_master_continuerequest = 1;

  assign console_master_qualified_request_test_sys_sopc_clock_0_in = console_master_requests_test_sys_sopc_clock_0_in & ~((console_master_master_read & ((console_master_latency_counter != 0))));
  //local readdatavalid console_master_read_data_valid_test_sys_sopc_clock_0_in, which is an e_mux
  assign console_master_read_data_valid_test_sys_sopc_clock_0_in = console_master_granted_test_sys_sopc_clock_0_in & console_master_master_read & ~test_sys_sopc_clock_0_in_waits_for_read;

  //test_sys_sopc_clock_0_in_writedata mux, which is an e_mux
  assign test_sys_sopc_clock_0_in_writedata = console_master_master_writedata;

  //assign test_sys_sopc_clock_0_in_endofpacket_from_sa = test_sys_sopc_clock_0_in_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign test_sys_sopc_clock_0_in_endofpacket_from_sa = test_sys_sopc_clock_0_in_endofpacket;

  //master is always granted when requested
  assign console_master_granted_test_sys_sopc_clock_0_in = console_master_qualified_request_test_sys_sopc_clock_0_in;

  //console_master/master saved-grant test_sys_sopc_clock_0/in, which is an e_assign
  assign console_master_saved_grant_test_sys_sopc_clock_0_in = console_master_requests_test_sys_sopc_clock_0_in;

  //allow new arb cycle for test_sys_sopc_clock_0/in, which is an e_assign
  assign test_sys_sopc_clock_0_in_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign test_sys_sopc_clock_0_in_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign test_sys_sopc_clock_0_in_master_qreq_vector = 1;

  //test_sys_sopc_clock_0_in_reset_n assignment, which is an e_assign
  assign test_sys_sopc_clock_0_in_reset_n = reset_n;

  //test_sys_sopc_clock_0_in_firsttransfer first transaction, which is an e_assign
  assign test_sys_sopc_clock_0_in_firsttransfer = test_sys_sopc_clock_0_in_begins_xfer ? test_sys_sopc_clock_0_in_unreg_firsttransfer : test_sys_sopc_clock_0_in_reg_firsttransfer;

  //test_sys_sopc_clock_0_in_unreg_firsttransfer first transaction, which is an e_assign
  assign test_sys_sopc_clock_0_in_unreg_firsttransfer = ~(test_sys_sopc_clock_0_in_slavearbiterlockenable & test_sys_sopc_clock_0_in_any_continuerequest);

  //test_sys_sopc_clock_0_in_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          test_sys_sopc_clock_0_in_reg_firsttransfer <= 1'b1;
      else if (test_sys_sopc_clock_0_in_begins_xfer)
          test_sys_sopc_clock_0_in_reg_firsttransfer <= test_sys_sopc_clock_0_in_unreg_firsttransfer;
    end


  //test_sys_sopc_clock_0_in_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign test_sys_sopc_clock_0_in_beginbursttransfer_internal = test_sys_sopc_clock_0_in_begins_xfer;

  //test_sys_sopc_clock_0_in_read assignment, which is an e_mux
  assign test_sys_sopc_clock_0_in_read = console_master_granted_test_sys_sopc_clock_0_in & console_master_master_read;

  //test_sys_sopc_clock_0_in_write assignment, which is an e_mux
  assign test_sys_sopc_clock_0_in_write = console_master_granted_test_sys_sopc_clock_0_in & console_master_master_write;

  //test_sys_sopc_clock_0_in_address mux, which is an e_mux
  assign test_sys_sopc_clock_0_in_address = console_master_master_address_to_slave;

  //slaveid test_sys_sopc_clock_0_in_nativeaddress nativeaddress mux, which is an e_mux
  assign test_sys_sopc_clock_0_in_nativeaddress = console_master_master_address_to_slave >> 2;

  //d1_test_sys_sopc_clock_0_in_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_test_sys_sopc_clock_0_in_end_xfer <= 1;
      else if (1)
          d1_test_sys_sopc_clock_0_in_end_xfer <= test_sys_sopc_clock_0_in_end_xfer;
    end


  //test_sys_sopc_clock_0_in_waits_for_read in a cycle, which is an e_mux
  assign test_sys_sopc_clock_0_in_waits_for_read = test_sys_sopc_clock_0_in_in_a_read_cycle & test_sys_sopc_clock_0_in_waitrequest_from_sa;

  //test_sys_sopc_clock_0_in_in_a_read_cycle assignment, which is an e_assign
  assign test_sys_sopc_clock_0_in_in_a_read_cycle = console_master_granted_test_sys_sopc_clock_0_in & console_master_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = test_sys_sopc_clock_0_in_in_a_read_cycle;

  //test_sys_sopc_clock_0_in_waits_for_write in a cycle, which is an e_mux
  assign test_sys_sopc_clock_0_in_waits_for_write = test_sys_sopc_clock_0_in_in_a_write_cycle & test_sys_sopc_clock_0_in_waitrequest_from_sa;

  //test_sys_sopc_clock_0_in_in_a_write_cycle assignment, which is an e_assign
  assign test_sys_sopc_clock_0_in_in_a_write_cycle = console_master_granted_test_sys_sopc_clock_0_in & console_master_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = test_sys_sopc_clock_0_in_in_a_write_cycle;

  assign wait_for_test_sys_sopc_clock_0_in_counter = 0;
  //test_sys_sopc_clock_0_in_byteenable byte enable port mux, which is an e_mux
  assign test_sys_sopc_clock_0_in_byteenable = (console_master_granted_test_sys_sopc_clock_0_in)? console_master_master_byteenable :
    -1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //test_sys_sopc_clock_0/in enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else if (1)
          enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module test_sys_sopc_clock_0_out_arbitrator (
                                              // inputs:
                                               clk,
                                               d1_gate_s0_end_xfer,
                                               gate_s0_readdata_from_sa,
                                               reset_n,
                                               test_sys_sopc_clock_0_out_address,
                                               test_sys_sopc_clock_0_out_byteenable,
                                               test_sys_sopc_clock_0_out_granted_gate_s0,
                                               test_sys_sopc_clock_0_out_qualified_request_gate_s0,
                                               test_sys_sopc_clock_0_out_read,
                                               test_sys_sopc_clock_0_out_read_data_valid_gate_s0,
                                               test_sys_sopc_clock_0_out_requests_gate_s0,
                                               test_sys_sopc_clock_0_out_write,
                                               test_sys_sopc_clock_0_out_writedata,

                                              // outputs:
                                               test_sys_sopc_clock_0_out_address_to_slave,
                                               test_sys_sopc_clock_0_out_readdata,
                                               test_sys_sopc_clock_0_out_reset_n,
                                               test_sys_sopc_clock_0_out_waitrequest
                                            )
;

  output  [  1: 0] test_sys_sopc_clock_0_out_address_to_slave;
  output  [ 31: 0] test_sys_sopc_clock_0_out_readdata;
  output           test_sys_sopc_clock_0_out_reset_n;
  output           test_sys_sopc_clock_0_out_waitrequest;
  input            clk;
  input            d1_gate_s0_end_xfer;
  input   [ 31: 0] gate_s0_readdata_from_sa;
  input            reset_n;
  input   [  1: 0] test_sys_sopc_clock_0_out_address;
  input   [  3: 0] test_sys_sopc_clock_0_out_byteenable;
  input            test_sys_sopc_clock_0_out_granted_gate_s0;
  input            test_sys_sopc_clock_0_out_qualified_request_gate_s0;
  input            test_sys_sopc_clock_0_out_read;
  input            test_sys_sopc_clock_0_out_read_data_valid_gate_s0;
  input            test_sys_sopc_clock_0_out_requests_gate_s0;
  input            test_sys_sopc_clock_0_out_write;
  input   [ 31: 0] test_sys_sopc_clock_0_out_writedata;

  reg              active_and_waiting_last_time;
  wire             r_0;
  reg     [  1: 0] test_sys_sopc_clock_0_out_address_last_time;
  wire    [  1: 0] test_sys_sopc_clock_0_out_address_to_slave;
  reg     [  3: 0] test_sys_sopc_clock_0_out_byteenable_last_time;
  reg              test_sys_sopc_clock_0_out_read_last_time;
  wire    [ 31: 0] test_sys_sopc_clock_0_out_readdata;
  wire             test_sys_sopc_clock_0_out_reset_n;
  wire             test_sys_sopc_clock_0_out_run;
  wire             test_sys_sopc_clock_0_out_waitrequest;
  reg              test_sys_sopc_clock_0_out_write_last_time;
  reg     [ 31: 0] test_sys_sopc_clock_0_out_writedata_last_time;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & ((~test_sys_sopc_clock_0_out_qualified_request_gate_s0 | ~test_sys_sopc_clock_0_out_read | (1 & ~d1_gate_s0_end_xfer & test_sys_sopc_clock_0_out_read))) & ((~test_sys_sopc_clock_0_out_qualified_request_gate_s0 | ~test_sys_sopc_clock_0_out_write | (1 & test_sys_sopc_clock_0_out_write)));

  //cascaded wait assignment, which is an e_assign
  assign test_sys_sopc_clock_0_out_run = r_0;

  //optimize select-logic by passing only those address bits which matter.
  assign test_sys_sopc_clock_0_out_address_to_slave = test_sys_sopc_clock_0_out_address;

  //test_sys_sopc_clock_0/out readdata mux, which is an e_mux
  assign test_sys_sopc_clock_0_out_readdata = gate_s0_readdata_from_sa;

  //actual waitrequest port, which is an e_assign
  assign test_sys_sopc_clock_0_out_waitrequest = ~test_sys_sopc_clock_0_out_run;

  //test_sys_sopc_clock_0_out_reset_n assignment, which is an e_assign
  assign test_sys_sopc_clock_0_out_reset_n = reset_n;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //test_sys_sopc_clock_0_out_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          test_sys_sopc_clock_0_out_address_last_time <= 0;
      else if (1)
          test_sys_sopc_clock_0_out_address_last_time <= test_sys_sopc_clock_0_out_address;
    end


  //test_sys_sopc_clock_0/out waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else if (1)
          active_and_waiting_last_time <= test_sys_sopc_clock_0_out_waitrequest & (test_sys_sopc_clock_0_out_read | test_sys_sopc_clock_0_out_write);
    end


  //test_sys_sopc_clock_0_out_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (test_sys_sopc_clock_0_out_address != test_sys_sopc_clock_0_out_address_last_time))
        begin
          $write("%0d ns: test_sys_sopc_clock_0_out_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //test_sys_sopc_clock_0_out_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          test_sys_sopc_clock_0_out_byteenable_last_time <= 0;
      else if (1)
          test_sys_sopc_clock_0_out_byteenable_last_time <= test_sys_sopc_clock_0_out_byteenable;
    end


  //test_sys_sopc_clock_0_out_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (test_sys_sopc_clock_0_out_byteenable != test_sys_sopc_clock_0_out_byteenable_last_time))
        begin
          $write("%0d ns: test_sys_sopc_clock_0_out_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //test_sys_sopc_clock_0_out_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          test_sys_sopc_clock_0_out_read_last_time <= 0;
      else if (1)
          test_sys_sopc_clock_0_out_read_last_time <= test_sys_sopc_clock_0_out_read;
    end


  //test_sys_sopc_clock_0_out_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (test_sys_sopc_clock_0_out_read != test_sys_sopc_clock_0_out_read_last_time))
        begin
          $write("%0d ns: test_sys_sopc_clock_0_out_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //test_sys_sopc_clock_0_out_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          test_sys_sopc_clock_0_out_write_last_time <= 0;
      else if (1)
          test_sys_sopc_clock_0_out_write_last_time <= test_sys_sopc_clock_0_out_write;
    end


  //test_sys_sopc_clock_0_out_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (test_sys_sopc_clock_0_out_write != test_sys_sopc_clock_0_out_write_last_time))
        begin
          $write("%0d ns: test_sys_sopc_clock_0_out_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //test_sys_sopc_clock_0_out_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          test_sys_sopc_clock_0_out_writedata_last_time <= 0;
      else if (1)
          test_sys_sopc_clock_0_out_writedata_last_time <= test_sys_sopc_clock_0_out_writedata;
    end


  //test_sys_sopc_clock_0_out_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (test_sys_sopc_clock_0_out_writedata != test_sys_sopc_clock_0_out_writedata_last_time) & test_sys_sopc_clock_0_out_write)
        begin
          $write("%0d ns: test_sys_sopc_clock_0_out_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module test_sys_sopc_reset_slow_clk_domain_synch_module (
                                                          // inputs:
                                                           clk,
                                                           data_in,
                                                           reset_n,

                                                          // outputs:
                                                           data_out
                                                        )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else if (1)
          data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else if (1)
          data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module test_sys_sopc_reset_fast_clk_domain_synch_module (
                                                          // inputs:
                                                           clk,
                                                           data_in,
                                                           reset_n,

                                                          // outputs:
                                                           data_out
                                                        )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else if (1)
          data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else if (1)
          data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module test_sys_sopc_reset_clk_domain_synch_module (
                                                     // inputs:
                                                      clk,
                                                      data_in,
                                                      reset_n,

                                                     // outputs:
                                                      data_out
                                                   )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else if (1)
          data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else if (1)
          data_out <= data_in_d1;
    end



endmodule



// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module test_sys_sopc (
                       // 1) global signals:
                        clk,
                        fast_clk,
                        reset_n,
                        slow_clk,

                       // the_console_stream
                        resetrequest_from_the_console_stream
                     )
;

  output           fast_clk;
  output           resetrequest_from_the_console_stream;
  output           slow_clk;
  input            clk;
  input            reset_n;

  wire    [ 15: 0] DFA_before_console_in_data;
  wire             DFA_before_console_in_ready;
  wire             DFA_before_console_in_ready_from_sa;
  wire             DFA_before_console_in_reset_n;
  wire             DFA_before_console_in_valid;
  wire    [  7: 0] DFA_before_console_out_data;
  wire             DFA_before_console_out_ready;
  wire             DFA_before_console_out_valid;
  wire    [  7: 0] DFA_before_ingress_fifo_in_data;
  wire             DFA_before_ingress_fifo_in_ready;
  wire             DFA_before_ingress_fifo_in_ready_from_sa;
  wire             DFA_before_ingress_fifo_in_reset_n;
  wire             DFA_before_ingress_fifo_in_valid;
  wire    [ 15: 0] DFA_before_ingress_fifo_out_data;
  wire             DFA_before_ingress_fifo_out_ready;
  wire             DFA_before_ingress_fifo_out_valid;
  wire    [ 15: 0] TA_before_dut_in_data;
  wire             TA_before_dut_in_reset_n;
  wire             TA_before_dut_in_valid;
  wire    [ 15: 0] TA_before_dut_out_data;
  wire    [ 15: 0] TA_before_gate_in_data;
  wire             TA_before_gate_in_reset_n;
  wire    [ 15: 0] TA_before_gate_out_data;
  wire             TA_before_gate_out_valid;
  wire    [  7: 0] TA_before_ingress_fifo_in_data;
  wire             TA_before_ingress_fifo_in_reset_n;
  wire             TA_before_ingress_fifo_in_valid;
  wire    [  7: 0] TA_before_ingress_fifo_out_data;
  wire             TA_before_ingress_fifo_out_ready;
  wire             TA_before_ingress_fifo_out_valid;
  wire    [ 31: 0] build_id_s0_readdata;
  wire    [ 31: 0] build_id_s0_readdata_from_sa;
  wire             build_id_s0_reset;
  wire             clk_reset_n;
  wire             console_master_granted_build_id_s0;
  wire             console_master_granted_sysid_control_slave;
  wire             console_master_granted_test_sys_sopc_clock_0_in;
  wire             console_master_latency_counter;
  wire    [ 31: 0] console_master_master_address;
  wire    [ 31: 0] console_master_master_address_to_slave;
  wire    [  3: 0] console_master_master_byteenable;
  wire             console_master_master_read;
  wire    [ 31: 0] console_master_master_readdata;
  wire             console_master_master_readdatavalid;
  wire             console_master_master_reset_n;
  wire             console_master_master_resetrequest;
  wire             console_master_master_waitrequest;
  wire             console_master_master_write;
  wire    [ 31: 0] console_master_master_writedata;
  wire             console_master_qualified_request_build_id_s0;
  wire             console_master_qualified_request_sysid_control_slave;
  wire             console_master_qualified_request_test_sys_sopc_clock_0_in;
  wire             console_master_read_data_valid_build_id_s0;
  wire             console_master_read_data_valid_sysid_control_slave;
  wire             console_master_read_data_valid_test_sys_sopc_clock_0_in;
  wire             console_master_requests_build_id_s0;
  wire             console_master_requests_sysid_control_slave;
  wire             console_master_requests_test_sys_sopc_clock_0_in;
  wire    [  7: 0] console_stream_sink_data;
  wire             console_stream_sink_ready;
  wire             console_stream_sink_ready_from_sa;
  wire             console_stream_sink_valid;
  wire    [  7: 0] console_stream_src_data;
  wire             console_stream_src_reset_n;
  wire             console_stream_src_valid;
  wire             d1_build_id_s0_end_xfer;
  wire             d1_gate_s0_end_xfer;
  wire             d1_ingress_fifo_out_csr_end_xfer;
  wire             d1_pll_s1_end_xfer;
  wire             d1_sysid_control_slave_end_xfer;
  wire             d1_test_sys_sopc_clock_0_in_end_xfer;
  wire    [ 15: 0] dut_sink_data;
  wire             dut_sink_reset;
  wire    [ 15: 0] dut_source_data;
  wire    [ 15: 0] egress_fifo_in_data;
  wire             egress_fifo_in_ready;
  wire             egress_fifo_in_ready_from_sa;
  wire             egress_fifo_in_reset_n;
  wire             egress_fifo_in_valid;
  wire    [ 15: 0] egress_fifo_out_data;
  wire             egress_fifo_out_ready;
  wire             egress_fifo_out_reset_n;
  wire             egress_fifo_out_valid;
  wire    [ 15: 0] egress_pipeline_fifo_in_data;
  wire             egress_pipeline_fifo_in_ready;
  wire             egress_pipeline_fifo_in_ready_from_sa;
  wire             egress_pipeline_fifo_in_reset_n;
  wire             egress_pipeline_fifo_in_valid;
  wire    [ 15: 0] egress_pipeline_fifo_out_data;
  wire             egress_pipeline_fifo_out_ready;
  wire             egress_pipeline_fifo_out_reset_n;
  wire             egress_pipeline_fifo_out_valid;
  wire             fast_clk;
  wire             fast_clk_reset_n;
  wire    [ 15: 0] gate_egress_snk_data;
  wire             gate_egress_snk_valid;
  wire    [ 15: 0] gate_egress_src_data;
  wire             gate_egress_src_ready;
  wire             gate_egress_src_valid;
  wire    [ 15: 0] gate_ingress_snk_data;
  wire             gate_ingress_snk_ready;
  wire             gate_ingress_snk_ready_from_sa;
  wire             gate_ingress_snk_reset;
  wire             gate_ingress_snk_valid;
  wire    [ 15: 0] gate_ingress_src_data;
  wire             gate_ingress_src_valid;
  wire    [  2: 0] gate_m0_address;
  wire    [  2: 0] gate_m0_address_to_slave;
  wire             gate_m0_granted_ingress_fifo_out_csr;
  wire             gate_m0_latency_counter;
  wire             gate_m0_qualified_request_ingress_fifo_out_csr;
  wire             gate_m0_read;
  wire             gate_m0_read_data_valid_ingress_fifo_out_csr;
  wire    [ 31: 0] gate_m0_readdata;
  wire             gate_m0_readdatavalid;
  wire             gate_m0_requests_ingress_fifo_out_csr;
  wire             gate_m0_waitrequest;
  wire    [ 31: 0] gate_s0_readdata;
  wire    [ 31: 0] gate_s0_readdata_from_sa;
  wire             gate_s0_write;
  wire    [ 31: 0] gate_s0_writedata;
  wire    [ 15: 0] ingress_fifo_in_data;
  wire             ingress_fifo_in_ready;
  wire             ingress_fifo_in_ready_from_sa;
  wire             ingress_fifo_in_reset_n;
  wire             ingress_fifo_in_valid;
  wire             ingress_fifo_out_csr_address;
  wire             ingress_fifo_out_csr_read;
  wire    [ 31: 0] ingress_fifo_out_csr_readdata;
  wire    [ 31: 0] ingress_fifo_out_csr_readdata_from_sa;
  wire             ingress_fifo_out_csr_reset_n;
  wire             ingress_fifo_out_csr_write;
  wire    [ 31: 0] ingress_fifo_out_csr_writedata;
  wire    [ 15: 0] ingress_fifo_out_data;
  wire             ingress_fifo_out_ready;
  wire             ingress_fifo_out_valid;
  wire             out_clk_pll_c0;
  wire             out_clk_pll_c1;
  wire             pll_master_granted_pll_s1;
  wire    [  4: 0] pll_master_m0_address;
  wire    [  4: 0] pll_master_m0_address_to_slave;
  wire    [  3: 0] pll_master_m0_byteenable;
  wire             pll_master_m0_read;
  wire    [ 31: 0] pll_master_m0_readdata;
  wire             pll_master_m0_reset;
  wire             pll_master_m0_waitrequest;
  wire             pll_master_m0_write;
  wire    [ 31: 0] pll_master_m0_writedata;
  wire             pll_master_qualified_request_pll_s1;
  wire             pll_master_read_data_valid_pll_s1;
  wire             pll_master_requests_pll_s1;
  wire    [  2: 0] pll_s1_address;
  wire             pll_s1_chipselect;
  wire             pll_s1_read;
  wire    [ 15: 0] pll_s1_readdata;
  wire    [ 15: 0] pll_s1_readdata_from_sa;
  wire             pll_s1_reset_n;
  wire             pll_s1_resetrequest;
  wire             pll_s1_resetrequest_from_sa;
  wire             pll_s1_write;
  wire    [ 15: 0] pll_s1_writedata;
  wire             reset_n_sources;
  wire             resetrequest_from_the_console_stream;
  wire             slow_clk;
  wire             slow_clk_reset_n;
  wire             sysid_control_slave_address;
  wire    [ 31: 0] sysid_control_slave_readdata;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  wire    [  1: 0] test_sys_sopc_clock_0_in_address;
  wire    [  3: 0] test_sys_sopc_clock_0_in_byteenable;
  wire             test_sys_sopc_clock_0_in_endofpacket;
  wire             test_sys_sopc_clock_0_in_endofpacket_from_sa;
  wire             test_sys_sopc_clock_0_in_nativeaddress;
  wire             test_sys_sopc_clock_0_in_read;
  wire    [ 31: 0] test_sys_sopc_clock_0_in_readdata;
  wire    [ 31: 0] test_sys_sopc_clock_0_in_readdata_from_sa;
  wire             test_sys_sopc_clock_0_in_reset_n;
  wire             test_sys_sopc_clock_0_in_waitrequest;
  wire             test_sys_sopc_clock_0_in_waitrequest_from_sa;
  wire             test_sys_sopc_clock_0_in_write;
  wire    [ 31: 0] test_sys_sopc_clock_0_in_writedata;
  wire    [  1: 0] test_sys_sopc_clock_0_out_address;
  wire    [  1: 0] test_sys_sopc_clock_0_out_address_to_slave;
  wire    [  3: 0] test_sys_sopc_clock_0_out_byteenable;
  wire             test_sys_sopc_clock_0_out_endofpacket;
  wire             test_sys_sopc_clock_0_out_granted_gate_s0;
  wire             test_sys_sopc_clock_0_out_nativeaddress;
  wire             test_sys_sopc_clock_0_out_qualified_request_gate_s0;
  wire             test_sys_sopc_clock_0_out_read;
  wire             test_sys_sopc_clock_0_out_read_data_valid_gate_s0;
  wire    [ 31: 0] test_sys_sopc_clock_0_out_readdata;
  wire             test_sys_sopc_clock_0_out_requests_gate_s0;
  wire             test_sys_sopc_clock_0_out_reset_n;
  wire             test_sys_sopc_clock_0_out_waitrequest;
  wire             test_sys_sopc_clock_0_out_write;
  wire    [ 31: 0] test_sys_sopc_clock_0_out_writedata;
  DFA_before_console_in_arbitrator the_DFA_before_console_in
    (
      .DFA_before_console_in_data          (DFA_before_console_in_data),
      .DFA_before_console_in_ready         (DFA_before_console_in_ready),
      .DFA_before_console_in_ready_from_sa (DFA_before_console_in_ready_from_sa),
      .DFA_before_console_in_reset_n       (DFA_before_console_in_reset_n),
      .DFA_before_console_in_valid         (DFA_before_console_in_valid),
      .clk                                 (slow_clk),
      .egress_fifo_out_data                (egress_fifo_out_data),
      .egress_fifo_out_valid               (egress_fifo_out_valid),
      .reset_n                             (slow_clk_reset_n)
    );

  DFA_before_console_out_arbitrator the_DFA_before_console_out
    (
      .DFA_before_console_out_data       (DFA_before_console_out_data),
      .DFA_before_console_out_ready      (DFA_before_console_out_ready),
      .DFA_before_console_out_valid      (DFA_before_console_out_valid),
      .clk                               (slow_clk),
      .console_stream_sink_ready_from_sa (console_stream_sink_ready_from_sa),
      .reset_n                           (slow_clk_reset_n)
    );

  DFA_before_console the_DFA_before_console
    (
      .clk       (slow_clk),
      .in_data   (DFA_before_console_in_data),
      .in_ready  (DFA_before_console_in_ready),
      .in_valid  (DFA_before_console_in_valid),
      .out_data  (DFA_before_console_out_data),
      .out_ready (DFA_before_console_out_ready),
      .out_valid (DFA_before_console_out_valid),
      .reset_n   (DFA_before_console_in_reset_n)
    );

  DFA_before_ingress_fifo_in_arbitrator the_DFA_before_ingress_fifo_in
    (
      .DFA_before_ingress_fifo_in_data          (DFA_before_ingress_fifo_in_data),
      .DFA_before_ingress_fifo_in_ready         (DFA_before_ingress_fifo_in_ready),
      .DFA_before_ingress_fifo_in_ready_from_sa (DFA_before_ingress_fifo_in_ready_from_sa),
      .DFA_before_ingress_fifo_in_reset_n       (DFA_before_ingress_fifo_in_reset_n),
      .DFA_before_ingress_fifo_in_valid         (DFA_before_ingress_fifo_in_valid),
      .TA_before_ingress_fifo_out_data          (TA_before_ingress_fifo_out_data),
      .TA_before_ingress_fifo_out_valid         (TA_before_ingress_fifo_out_valid),
      .clk                                      (slow_clk),
      .reset_n                                  (slow_clk_reset_n)
    );

  DFA_before_ingress_fifo_out_arbitrator the_DFA_before_ingress_fifo_out
    (
      .DFA_before_ingress_fifo_out_data  (DFA_before_ingress_fifo_out_data),
      .DFA_before_ingress_fifo_out_ready (DFA_before_ingress_fifo_out_ready),
      .DFA_before_ingress_fifo_out_valid (DFA_before_ingress_fifo_out_valid),
      .clk                               (slow_clk),
      .ingress_fifo_in_ready_from_sa     (ingress_fifo_in_ready_from_sa),
      .reset_n                           (slow_clk_reset_n)
    );

  DFA_before_ingress_fifo the_DFA_before_ingress_fifo
    (
      .clk       (slow_clk),
      .in_data   (DFA_before_ingress_fifo_in_data),
      .in_ready  (DFA_before_ingress_fifo_in_ready),
      .in_valid  (DFA_before_ingress_fifo_in_valid),
      .out_data  (DFA_before_ingress_fifo_out_data),
      .out_ready (DFA_before_ingress_fifo_out_ready),
      .out_valid (DFA_before_ingress_fifo_out_valid),
      .reset_n   (DFA_before_ingress_fifo_in_reset_n)
    );

  TA_before_dut_in_arbitrator the_TA_before_dut_in
    (
      .TA_before_dut_in_data    (TA_before_dut_in_data),
      .TA_before_dut_in_reset_n (TA_before_dut_in_reset_n),
      .TA_before_dut_in_valid   (TA_before_dut_in_valid),
      .clk                      (fast_clk),
      .gate_ingress_src_data    (gate_ingress_src_data),
      .gate_ingress_src_valid   (gate_ingress_src_valid),
      .reset_n                  (fast_clk_reset_n)
    );

  TA_before_dut_out_arbitrator the_TA_before_dut_out
    (
      .TA_before_dut_out_data (TA_before_dut_out_data),
      .clk                    (fast_clk),
      .reset_n                (fast_clk_reset_n)
    );

  TA_before_dut the_TA_before_dut
    (
      .clk      (fast_clk),
      .in_data  (TA_before_dut_in_data),
      .in_valid (TA_before_dut_in_valid),
      .out_data (TA_before_dut_out_data),
      .reset_n  (TA_before_dut_in_reset_n)
    );

  TA_before_gate_in_arbitrator the_TA_before_gate_in
    (
      .TA_before_gate_in_data    (TA_before_gate_in_data),
      .TA_before_gate_in_reset_n (TA_before_gate_in_reset_n),
      .clk                       (fast_clk),
      .dut_source_data           (dut_source_data),
      .reset_n                   (fast_clk_reset_n)
    );

  TA_before_gate_out_arbitrator the_TA_before_gate_out
    (
      .TA_before_gate_out_data  (TA_before_gate_out_data),
      .TA_before_gate_out_valid (TA_before_gate_out_valid),
      .clk                      (fast_clk),
      .reset_n                  (fast_clk_reset_n)
    );

  TA_before_gate the_TA_before_gate
    (
      .clk       (fast_clk),
      .in_data   (TA_before_gate_in_data),
      .out_data  (TA_before_gate_out_data),
      .out_valid (TA_before_gate_out_valid),
      .reset_n   (TA_before_gate_in_reset_n)
    );

  TA_before_ingress_fifo_in_arbitrator the_TA_before_ingress_fifo_in
    (
      .TA_before_ingress_fifo_in_data    (TA_before_ingress_fifo_in_data),
      .TA_before_ingress_fifo_in_reset_n (TA_before_ingress_fifo_in_reset_n),
      .TA_before_ingress_fifo_in_valid   (TA_before_ingress_fifo_in_valid),
      .clk                               (slow_clk),
      .console_stream_src_data           (console_stream_src_data),
      .console_stream_src_valid          (console_stream_src_valid),
      .reset_n                           (slow_clk_reset_n)
    );

  TA_before_ingress_fifo_out_arbitrator the_TA_before_ingress_fifo_out
    (
      .DFA_before_ingress_fifo_in_ready_from_sa (DFA_before_ingress_fifo_in_ready_from_sa),
      .TA_before_ingress_fifo_out_data          (TA_before_ingress_fifo_out_data),
      .TA_before_ingress_fifo_out_ready         (TA_before_ingress_fifo_out_ready),
      .TA_before_ingress_fifo_out_valid         (TA_before_ingress_fifo_out_valid),
      .clk                                      (slow_clk),
      .reset_n                                  (slow_clk_reset_n)
    );

  TA_before_ingress_fifo the_TA_before_ingress_fifo
    (
      .clk       (slow_clk),
      .in_data   (TA_before_ingress_fifo_in_data),
      .in_valid  (TA_before_ingress_fifo_in_valid),
      .out_data  (TA_before_ingress_fifo_out_data),
      .out_ready (TA_before_ingress_fifo_out_ready),
      .out_valid (TA_before_ingress_fifo_out_valid),
      .reset_n   (TA_before_ingress_fifo_in_reset_n)
    );

  build_id_s0_arbitrator the_build_id_s0
    (
      .build_id_s0_readdata                         (build_id_s0_readdata),
      .build_id_s0_readdata_from_sa                 (build_id_s0_readdata_from_sa),
      .build_id_s0_reset                            (build_id_s0_reset),
      .clk                                          (slow_clk),
      .console_master_granted_build_id_s0           (console_master_granted_build_id_s0),
      .console_master_latency_counter               (console_master_latency_counter),
      .console_master_master_address_to_slave       (console_master_master_address_to_slave),
      .console_master_master_read                   (console_master_master_read),
      .console_master_master_write                  (console_master_master_write),
      .console_master_qualified_request_build_id_s0 (console_master_qualified_request_build_id_s0),
      .console_master_read_data_valid_build_id_s0   (console_master_read_data_valid_build_id_s0),
      .console_master_requests_build_id_s0          (console_master_requests_build_id_s0),
      .d1_build_id_s0_end_xfer                      (d1_build_id_s0_end_xfer),
      .reset_n                                      (slow_clk_reset_n)
    );

  build_id the_build_id
    (
      .avs_s0_readdata (build_id_s0_readdata),
      .csi_clock_clk   (slow_clk),
      .csi_clock_reset (build_id_s0_reset)
    );

  console_master_master_arbitrator the_console_master_master
    (
      .build_id_s0_readdata_from_sa                              (build_id_s0_readdata_from_sa),
      .clk                                                       (slow_clk),
      .console_master_granted_build_id_s0                        (console_master_granted_build_id_s0),
      .console_master_granted_sysid_control_slave                (console_master_granted_sysid_control_slave),
      .console_master_granted_test_sys_sopc_clock_0_in           (console_master_granted_test_sys_sopc_clock_0_in),
      .console_master_latency_counter                            (console_master_latency_counter),
      .console_master_master_address                             (console_master_master_address),
      .console_master_master_address_to_slave                    (console_master_master_address_to_slave),
      .console_master_master_byteenable                          (console_master_master_byteenable),
      .console_master_master_read                                (console_master_master_read),
      .console_master_master_readdata                            (console_master_master_readdata),
      .console_master_master_readdatavalid                       (console_master_master_readdatavalid),
      .console_master_master_reset_n                             (console_master_master_reset_n),
      .console_master_master_waitrequest                         (console_master_master_waitrequest),
      .console_master_master_write                               (console_master_master_write),
      .console_master_master_writedata                           (console_master_master_writedata),
      .console_master_qualified_request_build_id_s0              (console_master_qualified_request_build_id_s0),
      .console_master_qualified_request_sysid_control_slave      (console_master_qualified_request_sysid_control_slave),
      .console_master_qualified_request_test_sys_sopc_clock_0_in (console_master_qualified_request_test_sys_sopc_clock_0_in),
      .console_master_read_data_valid_build_id_s0                (console_master_read_data_valid_build_id_s0),
      .console_master_read_data_valid_sysid_control_slave        (console_master_read_data_valid_sysid_control_slave),
      .console_master_read_data_valid_test_sys_sopc_clock_0_in   (console_master_read_data_valid_test_sys_sopc_clock_0_in),
      .console_master_requests_build_id_s0                       (console_master_requests_build_id_s0),
      .console_master_requests_sysid_control_slave               (console_master_requests_sysid_control_slave),
      .console_master_requests_test_sys_sopc_clock_0_in          (console_master_requests_test_sys_sopc_clock_0_in),
      .d1_build_id_s0_end_xfer                                   (d1_build_id_s0_end_xfer),
      .d1_sysid_control_slave_end_xfer                           (d1_sysid_control_slave_end_xfer),
      .d1_test_sys_sopc_clock_0_in_end_xfer                      (d1_test_sys_sopc_clock_0_in_end_xfer),
      .reset_n                                                   (slow_clk_reset_n),
      .sysid_control_slave_readdata_from_sa                      (sysid_control_slave_readdata_from_sa),
      .test_sys_sopc_clock_0_in_readdata_from_sa                 (test_sys_sopc_clock_0_in_readdata_from_sa),
      .test_sys_sopc_clock_0_in_waitrequest_from_sa              (test_sys_sopc_clock_0_in_waitrequest_from_sa)
    );

  console_master the_console_master
    (
      .address_from_the_altera_jtag_avalon_master_packets_to_transactions_converter     (console_master_master_address),
      .byteenable_from_the_altera_jtag_avalon_master_packets_to_transactions_converter  (console_master_master_byteenable),
      .clk                                                                              (slow_clk),
      .read_from_the_altera_jtag_avalon_master_packets_to_transactions_converter        (console_master_master_read),
      .readdata_to_the_altera_jtag_avalon_master_packets_to_transactions_converter      (console_master_master_readdata),
      .readdatavalid_to_the_altera_jtag_avalon_master_packets_to_transactions_converter (console_master_master_readdatavalid),
      .reset_n                                                                          (console_master_master_reset_n),
      .resetrequest_from_the_altera_jtag_avalon_master_jtag_interface                   (console_master_master_resetrequest),
      .waitrequest_to_the_altera_jtag_avalon_master_packets_to_transactions_converter   (console_master_master_waitrequest),
      .write_from_the_altera_jtag_avalon_master_packets_to_transactions_converter       (console_master_master_write),
      .writedata_from_the_altera_jtag_avalon_master_packets_to_transactions_converter   (console_master_master_writedata)
    );

  console_stream_sink_arbitrator the_console_stream_sink
    (
      .DFA_before_console_out_data       (DFA_before_console_out_data),
      .DFA_before_console_out_valid      (DFA_before_console_out_valid),
      .clk                               (slow_clk),
      .console_stream_sink_data          (console_stream_sink_data),
      .console_stream_sink_ready         (console_stream_sink_ready),
      .console_stream_sink_ready_from_sa (console_stream_sink_ready_from_sa),
      .console_stream_sink_valid         (console_stream_sink_valid),
      .reset_n                           (slow_clk_reset_n)
    );

  console_stream_src_arbitrator the_console_stream_src
    (
      .clk                        (slow_clk),
      .console_stream_src_data    (console_stream_src_data),
      .console_stream_src_reset_n (console_stream_src_reset_n),
      .console_stream_src_valid   (console_stream_src_valid),
      .reset_n                    (slow_clk_reset_n)
    );

  console_stream the_console_stream
    (
      .clk          (slow_clk),
      .reset_n      (console_stream_src_reset_n),
      .resetrequest (resetrequest_from_the_console_stream),
      .sink_data    (console_stream_sink_data),
      .sink_ready   (console_stream_sink_ready),
      .sink_valid   (console_stream_sink_valid),
      .source_data  (console_stream_src_data),
      .source_valid (console_stream_src_valid)
    );

  dut_sink_arbitrator the_dut_sink
    (
      .TA_before_dut_out_data (TA_before_dut_out_data),
      .clk                    (fast_clk),
      .dut_sink_data          (dut_sink_data),
      .dut_sink_reset         (dut_sink_reset),
      .reset_n                (fast_clk_reset_n)
    );

  dut_source_arbitrator the_dut_source
    (
      .clk             (fast_clk),
      .dut_source_data (dut_source_data),
      .reset_n         (fast_clk_reset_n)
    );

  dut the_dut
    (
      .asi_sink_data   (dut_sink_data),
      .aso_source_data (dut_source_data),
      .csi_clock_clk   (fast_clk),
      .csi_clock_reset (dut_sink_reset)
    );

  egress_fifo_in_arbitrator the_egress_fifo_in
    (
      .clk                            (fast_clk),
      .egress_fifo_in_data            (egress_fifo_in_data),
      .egress_fifo_in_ready           (egress_fifo_in_ready),
      .egress_fifo_in_ready_from_sa   (egress_fifo_in_ready_from_sa),
      .egress_fifo_in_reset_n         (egress_fifo_in_reset_n),
      .egress_fifo_in_valid           (egress_fifo_in_valid),
      .egress_pipeline_fifo_out_data  (egress_pipeline_fifo_out_data),
      .egress_pipeline_fifo_out_valid (egress_pipeline_fifo_out_valid),
      .reset_n                        (fast_clk_reset_n)
    );

  egress_fifo_out_arbitrator the_egress_fifo_out
    (
      .DFA_before_console_in_ready_from_sa (DFA_before_console_in_ready_from_sa),
      .clk                                 (slow_clk),
      .egress_fifo_out_data                (egress_fifo_out_data),
      .egress_fifo_out_ready               (egress_fifo_out_ready),
      .egress_fifo_out_reset_n             (egress_fifo_out_reset_n),
      .egress_fifo_out_valid               (egress_fifo_out_valid),
      .reset_n                             (slow_clk_reset_n)
    );

  egress_fifo the_egress_fifo
    (
      .in_clk      (fast_clk),
      .in_data     (egress_fifo_in_data),
      .in_ready    (egress_fifo_in_ready),
      .in_reset_n  (egress_fifo_in_reset_n),
      .in_valid    (egress_fifo_in_valid),
      .out_clk     (slow_clk),
      .out_data    (egress_fifo_out_data),
      .out_ready   (egress_fifo_out_ready),
      .out_reset_n (egress_fifo_out_reset_n),
      .out_valid   (egress_fifo_out_valid)
    );

  egress_pipeline_fifo_in_arbitrator the_egress_pipeline_fifo_in
    (
      .clk                                   (fast_clk),
      .egress_pipeline_fifo_in_data          (egress_pipeline_fifo_in_data),
      .egress_pipeline_fifo_in_ready         (egress_pipeline_fifo_in_ready),
      .egress_pipeline_fifo_in_ready_from_sa (egress_pipeline_fifo_in_ready_from_sa),
      .egress_pipeline_fifo_in_reset_n       (egress_pipeline_fifo_in_reset_n),
      .egress_pipeline_fifo_in_valid         (egress_pipeline_fifo_in_valid),
      .gate_egress_src_data                  (gate_egress_src_data),
      .gate_egress_src_valid                 (gate_egress_src_valid),
      .reset_n                               (fast_clk_reset_n)
    );

  egress_pipeline_fifo_out_arbitrator the_egress_pipeline_fifo_out
    (
      .clk                              (fast_clk),
      .egress_fifo_in_ready_from_sa     (egress_fifo_in_ready_from_sa),
      .egress_pipeline_fifo_out_data    (egress_pipeline_fifo_out_data),
      .egress_pipeline_fifo_out_ready   (egress_pipeline_fifo_out_ready),
      .egress_pipeline_fifo_out_reset_n (egress_pipeline_fifo_out_reset_n),
      .egress_pipeline_fifo_out_valid   (egress_pipeline_fifo_out_valid),
      .reset_n                          (fast_clk_reset_n)
    );

  egress_pipeline_fifo the_egress_pipeline_fifo
    (
      .in_clk      (fast_clk),
      .in_data     (egress_pipeline_fifo_in_data),
      .in_ready    (egress_pipeline_fifo_in_ready),
      .in_reset_n  (egress_pipeline_fifo_in_reset_n),
      .in_valid    (egress_pipeline_fifo_in_valid),
      .out_clk     (fast_clk),
      .out_data    (egress_pipeline_fifo_out_data),
      .out_ready   (egress_pipeline_fifo_out_ready),
      .out_reset_n (egress_pipeline_fifo_out_reset_n),
      .out_valid   (egress_pipeline_fifo_out_valid)
    );

  gate_egress_snk_arbitrator the_gate_egress_snk
    (
      .TA_before_gate_out_data  (TA_before_gate_out_data),
      .TA_before_gate_out_valid (TA_before_gate_out_valid),
      .clk                      (fast_clk),
      .gate_egress_snk_data     (gate_egress_snk_data),
      .gate_egress_snk_valid    (gate_egress_snk_valid),
      .reset_n                  (fast_clk_reset_n)
    );

  gate_ingress_snk_arbitrator the_gate_ingress_snk
    (
      .clk                            (fast_clk),
      .gate_ingress_snk_data          (gate_ingress_snk_data),
      .gate_ingress_snk_ready         (gate_ingress_snk_ready),
      .gate_ingress_snk_ready_from_sa (gate_ingress_snk_ready_from_sa),
      .gate_ingress_snk_reset         (gate_ingress_snk_reset),
      .gate_ingress_snk_valid         (gate_ingress_snk_valid),
      .ingress_fifo_out_data          (ingress_fifo_out_data),
      .ingress_fifo_out_valid         (ingress_fifo_out_valid),
      .reset_n                        (fast_clk_reset_n)
    );

  gate_s0_arbitrator the_gate_s0
    (
      .clk                                                 (fast_clk),
      .d1_gate_s0_end_xfer                                 (d1_gate_s0_end_xfer),
      .gate_s0_readdata                                    (gate_s0_readdata),
      .gate_s0_readdata_from_sa                            (gate_s0_readdata_from_sa),
      .gate_s0_write                                       (gate_s0_write),
      .gate_s0_writedata                                   (gate_s0_writedata),
      .reset_n                                             (fast_clk_reset_n),
      .test_sys_sopc_clock_0_out_address_to_slave          (test_sys_sopc_clock_0_out_address_to_slave),
      .test_sys_sopc_clock_0_out_granted_gate_s0           (test_sys_sopc_clock_0_out_granted_gate_s0),
      .test_sys_sopc_clock_0_out_qualified_request_gate_s0 (test_sys_sopc_clock_0_out_qualified_request_gate_s0),
      .test_sys_sopc_clock_0_out_read                      (test_sys_sopc_clock_0_out_read),
      .test_sys_sopc_clock_0_out_read_data_valid_gate_s0   (test_sys_sopc_clock_0_out_read_data_valid_gate_s0),
      .test_sys_sopc_clock_0_out_requests_gate_s0          (test_sys_sopc_clock_0_out_requests_gate_s0),
      .test_sys_sopc_clock_0_out_write                     (test_sys_sopc_clock_0_out_write),
      .test_sys_sopc_clock_0_out_writedata                 (test_sys_sopc_clock_0_out_writedata)
    );

  gate_egress_src_arbitrator the_gate_egress_src
    (
      .clk                                   (fast_clk),
      .egress_pipeline_fifo_in_ready_from_sa (egress_pipeline_fifo_in_ready_from_sa),
      .gate_egress_src_data                  (gate_egress_src_data),
      .gate_egress_src_ready                 (gate_egress_src_ready),
      .gate_egress_src_valid                 (gate_egress_src_valid),
      .reset_n                               (fast_clk_reset_n)
    );

  gate_ingress_src_arbitrator the_gate_ingress_src
    (
      .clk                    (fast_clk),
      .gate_ingress_src_data  (gate_ingress_src_data),
      .gate_ingress_src_valid (gate_ingress_src_valid),
      .reset_n                (fast_clk_reset_n)
    );

  gate_m0_arbitrator the_gate_m0
    (
      .clk                                            (fast_clk),
      .d1_ingress_fifo_out_csr_end_xfer               (d1_ingress_fifo_out_csr_end_xfer),
      .gate_m0_address                                (gate_m0_address),
      .gate_m0_address_to_slave                       (gate_m0_address_to_slave),
      .gate_m0_granted_ingress_fifo_out_csr           (gate_m0_granted_ingress_fifo_out_csr),
      .gate_m0_latency_counter                        (gate_m0_latency_counter),
      .gate_m0_qualified_request_ingress_fifo_out_csr (gate_m0_qualified_request_ingress_fifo_out_csr),
      .gate_m0_read                                   (gate_m0_read),
      .gate_m0_read_data_valid_ingress_fifo_out_csr   (gate_m0_read_data_valid_ingress_fifo_out_csr),
      .gate_m0_readdata                               (gate_m0_readdata),
      .gate_m0_readdatavalid                          (gate_m0_readdatavalid),
      .gate_m0_requests_ingress_fifo_out_csr          (gate_m0_requests_ingress_fifo_out_csr),
      .gate_m0_waitrequest                            (gate_m0_waitrequest),
      .ingress_fifo_out_csr_readdata_from_sa          (ingress_fifo_out_csr_readdata_from_sa),
      .reset_n                                        (fast_clk_reset_n)
    );

  gate the_gate
    (
      .asi_egress_snk_data   (gate_egress_snk_data),
      .asi_egress_snk_valid  (gate_egress_snk_valid),
      .asi_ingress_snk_data  (gate_ingress_snk_data),
      .asi_ingress_snk_ready (gate_ingress_snk_ready),
      .asi_ingress_snk_valid (gate_ingress_snk_valid),
      .aso_egress_src_data   (gate_egress_src_data),
      .aso_egress_src_ready  (gate_egress_src_ready),
      .aso_egress_src_valid  (gate_egress_src_valid),
      .aso_ingress_src_data  (gate_ingress_src_data),
      .aso_ingress_src_valid (gate_ingress_src_valid),
      .avm_m0_address        (gate_m0_address),
      .avm_m0_read           (gate_m0_read),
      .avm_m0_readdata       (gate_m0_readdata),
      .avm_m0_readdatavalid  (gate_m0_readdatavalid),
      .avm_m0_waitrequest    (gate_m0_waitrequest),
      .avs_s0_readdata       (gate_s0_readdata),
      .avs_s0_write          (gate_s0_write),
      .avs_s0_writedata      (gate_s0_writedata),
      .csi_clock_clk         (fast_clk),
      .csi_clock_reset       (gate_ingress_snk_reset)
    );

  ingress_fifo_in_arbitrator the_ingress_fifo_in
    (
      .DFA_before_ingress_fifo_out_data  (DFA_before_ingress_fifo_out_data),
      .DFA_before_ingress_fifo_out_valid (DFA_before_ingress_fifo_out_valid),
      .clk                               (slow_clk),
      .ingress_fifo_in_data              (ingress_fifo_in_data),
      .ingress_fifo_in_ready             (ingress_fifo_in_ready),
      .ingress_fifo_in_ready_from_sa     (ingress_fifo_in_ready_from_sa),
      .ingress_fifo_in_reset_n           (ingress_fifo_in_reset_n),
      .ingress_fifo_in_valid             (ingress_fifo_in_valid),
      .reset_n                           (slow_clk_reset_n)
    );

  ingress_fifo_out_csr_arbitrator the_ingress_fifo_out_csr
    (
      .clk                                            (fast_clk),
      .d1_ingress_fifo_out_csr_end_xfer               (d1_ingress_fifo_out_csr_end_xfer),
      .gate_m0_address_to_slave                       (gate_m0_address_to_slave),
      .gate_m0_granted_ingress_fifo_out_csr           (gate_m0_granted_ingress_fifo_out_csr),
      .gate_m0_latency_counter                        (gate_m0_latency_counter),
      .gate_m0_qualified_request_ingress_fifo_out_csr (gate_m0_qualified_request_ingress_fifo_out_csr),
      .gate_m0_read                                   (gate_m0_read),
      .gate_m0_read_data_valid_ingress_fifo_out_csr   (gate_m0_read_data_valid_ingress_fifo_out_csr),
      .gate_m0_requests_ingress_fifo_out_csr          (gate_m0_requests_ingress_fifo_out_csr),
      .ingress_fifo_out_csr_address                   (ingress_fifo_out_csr_address),
      .ingress_fifo_out_csr_read                      (ingress_fifo_out_csr_read),
      .ingress_fifo_out_csr_readdata                  (ingress_fifo_out_csr_readdata),
      .ingress_fifo_out_csr_readdata_from_sa          (ingress_fifo_out_csr_readdata_from_sa),
      .ingress_fifo_out_csr_reset_n                   (ingress_fifo_out_csr_reset_n),
      .ingress_fifo_out_csr_write                     (ingress_fifo_out_csr_write),
      .reset_n                                        (fast_clk_reset_n)
    );

  ingress_fifo_out_arbitrator the_ingress_fifo_out
    (
      .clk                            (fast_clk),
      .gate_ingress_snk_ready_from_sa (gate_ingress_snk_ready_from_sa),
      .ingress_fifo_out_data          (ingress_fifo_out_data),
      .ingress_fifo_out_ready         (ingress_fifo_out_ready),
      .ingress_fifo_out_valid         (ingress_fifo_out_valid),
      .reset_n                        (fast_clk_reset_n)
    );

  ingress_fifo the_ingress_fifo
    (
      .in_clk            (slow_clk),
      .in_data           (ingress_fifo_in_data),
      .in_ready          (ingress_fifo_in_ready),
      .in_reset_n        (ingress_fifo_in_reset_n),
      .in_valid          (ingress_fifo_in_valid),
      .out_clk           (fast_clk),
      .out_csr_address   (ingress_fifo_out_csr_address),
      .out_csr_read      (ingress_fifo_out_csr_read),
      .out_csr_readdata  (ingress_fifo_out_csr_readdata),
      .out_csr_write     (ingress_fifo_out_csr_write),
      .out_csr_writedata (ingress_fifo_out_csr_writedata),
      .out_data          (ingress_fifo_out_data),
      .out_ready         (ingress_fifo_out_ready),
      .out_reset_n       (ingress_fifo_out_csr_reset_n),
      .out_valid         (ingress_fifo_out_valid)
    );

  pll_s1_arbitrator the_pll_s1
    (
      .clk                                 (clk),
      .d1_pll_s1_end_xfer                  (d1_pll_s1_end_xfer),
      .pll_master_granted_pll_s1           (pll_master_granted_pll_s1),
      .pll_master_m0_address_to_slave      (pll_master_m0_address_to_slave),
      .pll_master_m0_read                  (pll_master_m0_read),
      .pll_master_m0_write                 (pll_master_m0_write),
      .pll_master_m0_writedata             (pll_master_m0_writedata),
      .pll_master_qualified_request_pll_s1 (pll_master_qualified_request_pll_s1),
      .pll_master_read_data_valid_pll_s1   (pll_master_read_data_valid_pll_s1),
      .pll_master_requests_pll_s1          (pll_master_requests_pll_s1),
      .pll_s1_address                      (pll_s1_address),
      .pll_s1_chipselect                   (pll_s1_chipselect),
      .pll_s1_read                         (pll_s1_read),
      .pll_s1_readdata                     (pll_s1_readdata),
      .pll_s1_readdata_from_sa             (pll_s1_readdata_from_sa),
      .pll_s1_reset_n                      (pll_s1_reset_n),
      .pll_s1_resetrequest                 (pll_s1_resetrequest),
      .pll_s1_resetrequest_from_sa         (pll_s1_resetrequest_from_sa),
      .pll_s1_write                        (pll_s1_write),
      .pll_s1_writedata                    (pll_s1_writedata),
      .reset_n                             (clk_reset_n)
    );

  //slow_clk out_clk assignment, which is an e_assign
  assign slow_clk = out_clk_pll_c0;

  //fast_clk out_clk assignment, which is an e_assign
  assign fast_clk = out_clk_pll_c1;

  pll the_pll
    (
      .address      (pll_s1_address),
      .c0           (out_clk_pll_c0),
      .c1           (out_clk_pll_c1),
      .chipselect   (pll_s1_chipselect),
      .clk          (clk),
      .read         (pll_s1_read),
      .readdata     (pll_s1_readdata),
      .reset_n      (pll_s1_reset_n),
      .resetrequest (pll_s1_resetrequest),
      .write        (pll_s1_write),
      .writedata    (pll_s1_writedata)
    );

  pll_master_m0_arbitrator the_pll_master_m0
    (
      .clk                                 (clk),
      .d1_pll_s1_end_xfer                  (d1_pll_s1_end_xfer),
      .pll_master_granted_pll_s1           (pll_master_granted_pll_s1),
      .pll_master_m0_address               (pll_master_m0_address),
      .pll_master_m0_address_to_slave      (pll_master_m0_address_to_slave),
      .pll_master_m0_byteenable            (pll_master_m0_byteenable),
      .pll_master_m0_read                  (pll_master_m0_read),
      .pll_master_m0_readdata              (pll_master_m0_readdata),
      .pll_master_m0_reset                 (pll_master_m0_reset),
      .pll_master_m0_waitrequest           (pll_master_m0_waitrequest),
      .pll_master_m0_write                 (pll_master_m0_write),
      .pll_master_m0_writedata             (pll_master_m0_writedata),
      .pll_master_qualified_request_pll_s1 (pll_master_qualified_request_pll_s1),
      .pll_master_read_data_valid_pll_s1   (pll_master_read_data_valid_pll_s1),
      .pll_master_requests_pll_s1          (pll_master_requests_pll_s1),
      .pll_s1_readdata_from_sa             (pll_s1_readdata_from_sa),
      .reset_n                             (clk_reset_n)
    );

  pll_master the_pll_master
    (
      .avm_m0_address       (pll_master_m0_address),
      .avm_m0_byteenable    (pll_master_m0_byteenable),
      .avm_m0_read          (pll_master_m0_read),
      .avm_m0_readdata      (pll_master_m0_readdata),
      .avm_m0_waitrequest   (pll_master_m0_waitrequest),
      .avm_m0_write         (pll_master_m0_write),
      .avm_m0_writedata     (pll_master_m0_writedata),
      .csi_master_clk_clk   (clk),
      .csi_master_clk_reset (pll_master_m0_reset)
    );

  sysid_control_slave_arbitrator the_sysid_control_slave
    (
      .clk                                                  (slow_clk),
      .console_master_granted_sysid_control_slave           (console_master_granted_sysid_control_slave),
      .console_master_latency_counter                       (console_master_latency_counter),
      .console_master_master_address_to_slave               (console_master_master_address_to_slave),
      .console_master_master_read                           (console_master_master_read),
      .console_master_master_write                          (console_master_master_write),
      .console_master_qualified_request_sysid_control_slave (console_master_qualified_request_sysid_control_slave),
      .console_master_read_data_valid_sysid_control_slave   (console_master_read_data_valid_sysid_control_slave),
      .console_master_requests_sysid_control_slave          (console_master_requests_sysid_control_slave),
      .d1_sysid_control_slave_end_xfer                      (d1_sysid_control_slave_end_xfer),
      .reset_n                                              (slow_clk_reset_n),
      .sysid_control_slave_address                          (sysid_control_slave_address),
      .sysid_control_slave_readdata                         (sysid_control_slave_readdata),
      .sysid_control_slave_readdata_from_sa                 (sysid_control_slave_readdata_from_sa)
    );

  sysid the_sysid
    (
      .address  (sysid_control_slave_address),
      .readdata (sysid_control_slave_readdata)
    );

  test_sys_sopc_clock_0_in_arbitrator the_test_sys_sopc_clock_0_in
    (
      .clk                                                       (slow_clk),
      .console_master_granted_test_sys_sopc_clock_0_in           (console_master_granted_test_sys_sopc_clock_0_in),
      .console_master_latency_counter                            (console_master_latency_counter),
      .console_master_master_address_to_slave                    (console_master_master_address_to_slave),
      .console_master_master_byteenable                          (console_master_master_byteenable),
      .console_master_master_read                                (console_master_master_read),
      .console_master_master_write                               (console_master_master_write),
      .console_master_master_writedata                           (console_master_master_writedata),
      .console_master_qualified_request_test_sys_sopc_clock_0_in (console_master_qualified_request_test_sys_sopc_clock_0_in),
      .console_master_read_data_valid_test_sys_sopc_clock_0_in   (console_master_read_data_valid_test_sys_sopc_clock_0_in),
      .console_master_requests_test_sys_sopc_clock_0_in          (console_master_requests_test_sys_sopc_clock_0_in),
      .d1_test_sys_sopc_clock_0_in_end_xfer                      (d1_test_sys_sopc_clock_0_in_end_xfer),
      .reset_n                                                   (slow_clk_reset_n),
      .test_sys_sopc_clock_0_in_address                          (test_sys_sopc_clock_0_in_address),
      .test_sys_sopc_clock_0_in_byteenable                       (test_sys_sopc_clock_0_in_byteenable),
      .test_sys_sopc_clock_0_in_endofpacket                      (test_sys_sopc_clock_0_in_endofpacket),
      .test_sys_sopc_clock_0_in_endofpacket_from_sa              (test_sys_sopc_clock_0_in_endofpacket_from_sa),
      .test_sys_sopc_clock_0_in_nativeaddress                    (test_sys_sopc_clock_0_in_nativeaddress),
      .test_sys_sopc_clock_0_in_read                             (test_sys_sopc_clock_0_in_read),
      .test_sys_sopc_clock_0_in_readdata                         (test_sys_sopc_clock_0_in_readdata),
      .test_sys_sopc_clock_0_in_readdata_from_sa                 (test_sys_sopc_clock_0_in_readdata_from_sa),
      .test_sys_sopc_clock_0_in_reset_n                          (test_sys_sopc_clock_0_in_reset_n),
      .test_sys_sopc_clock_0_in_waitrequest                      (test_sys_sopc_clock_0_in_waitrequest),
      .test_sys_sopc_clock_0_in_waitrequest_from_sa              (test_sys_sopc_clock_0_in_waitrequest_from_sa),
      .test_sys_sopc_clock_0_in_write                            (test_sys_sopc_clock_0_in_write),
      .test_sys_sopc_clock_0_in_writedata                        (test_sys_sopc_clock_0_in_writedata)
    );

  test_sys_sopc_clock_0_out_arbitrator the_test_sys_sopc_clock_0_out
    (
      .clk                                                 (fast_clk),
      .d1_gate_s0_end_xfer                                 (d1_gate_s0_end_xfer),
      .gate_s0_readdata_from_sa                            (gate_s0_readdata_from_sa),
      .reset_n                                             (fast_clk_reset_n),
      .test_sys_sopc_clock_0_out_address                   (test_sys_sopc_clock_0_out_address),
      .test_sys_sopc_clock_0_out_address_to_slave          (test_sys_sopc_clock_0_out_address_to_slave),
      .test_sys_sopc_clock_0_out_byteenable                (test_sys_sopc_clock_0_out_byteenable),
      .test_sys_sopc_clock_0_out_granted_gate_s0           (test_sys_sopc_clock_0_out_granted_gate_s0),
      .test_sys_sopc_clock_0_out_qualified_request_gate_s0 (test_sys_sopc_clock_0_out_qualified_request_gate_s0),
      .test_sys_sopc_clock_0_out_read                      (test_sys_sopc_clock_0_out_read),
      .test_sys_sopc_clock_0_out_read_data_valid_gate_s0   (test_sys_sopc_clock_0_out_read_data_valid_gate_s0),
      .test_sys_sopc_clock_0_out_readdata                  (test_sys_sopc_clock_0_out_readdata),
      .test_sys_sopc_clock_0_out_requests_gate_s0          (test_sys_sopc_clock_0_out_requests_gate_s0),
      .test_sys_sopc_clock_0_out_reset_n                   (test_sys_sopc_clock_0_out_reset_n),
      .test_sys_sopc_clock_0_out_waitrequest               (test_sys_sopc_clock_0_out_waitrequest),
      .test_sys_sopc_clock_0_out_write                     (test_sys_sopc_clock_0_out_write),
      .test_sys_sopc_clock_0_out_writedata                 (test_sys_sopc_clock_0_out_writedata)
    );

  test_sys_sopc_clock_0 the_test_sys_sopc_clock_0
    (
      .master_address       (test_sys_sopc_clock_0_out_address),
      .master_byteenable    (test_sys_sopc_clock_0_out_byteenable),
      .master_clk           (fast_clk),
      .master_endofpacket   (test_sys_sopc_clock_0_out_endofpacket),
      .master_nativeaddress (test_sys_sopc_clock_0_out_nativeaddress),
      .master_read          (test_sys_sopc_clock_0_out_read),
      .master_readdata      (test_sys_sopc_clock_0_out_readdata),
      .master_reset_n       (test_sys_sopc_clock_0_out_reset_n),
      .master_waitrequest   (test_sys_sopc_clock_0_out_waitrequest),
      .master_write         (test_sys_sopc_clock_0_out_write),
      .master_writedata     (test_sys_sopc_clock_0_out_writedata),
      .slave_address        (test_sys_sopc_clock_0_in_address),
      .slave_byteenable     (test_sys_sopc_clock_0_in_byteenable),
      .slave_clk            (slow_clk),
      .slave_endofpacket    (test_sys_sopc_clock_0_in_endofpacket),
      .slave_nativeaddress  (test_sys_sopc_clock_0_in_nativeaddress),
      .slave_read           (test_sys_sopc_clock_0_in_read),
      .slave_readdata       (test_sys_sopc_clock_0_in_readdata),
      .slave_reset_n        (test_sys_sopc_clock_0_in_reset_n),
      .slave_waitrequest    (test_sys_sopc_clock_0_in_waitrequest),
      .slave_write          (test_sys_sopc_clock_0_in_write),
      .slave_writedata      (test_sys_sopc_clock_0_in_writedata)
    );

  //reset is asserted asynchronously and deasserted synchronously
  test_sys_sopc_reset_slow_clk_domain_synch_module test_sys_sopc_reset_slow_clk_domain_synch
    (
      .clk      (slow_clk),
      .data_in  (1'b1),
      .data_out (slow_clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0 |
    0 |
    console_master_master_resetrequest |
    0 |
    pll_s1_resetrequest_from_sa |
    pll_s1_resetrequest_from_sa |
    console_master_master_resetrequest |
    console_master_master_resetrequest);

  //reset is asserted asynchronously and deasserted synchronously
  test_sys_sopc_reset_fast_clk_domain_synch_module test_sys_sopc_reset_fast_clk_domain_synch
    (
      .clk      (fast_clk),
      .data_in  (1'b1),
      .data_out (fast_clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset is asserted asynchronously and deasserted synchronously
  test_sys_sopc_reset_clk_domain_synch_module test_sys_sopc_reset_clk_domain_synch
    (
      .clk      (clk),
      .data_in  (1'b1),
      .data_out (clk_reset_n),
      .reset_n  (reset_n_sources)
    );

  //ingress_fifo_out_csr_writedata of type writedata does not connect to anything so wire it to default (0)
  assign ingress_fifo_out_csr_writedata = 0;

  //test_sys_sopc_clock_0_out_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign test_sys_sopc_clock_0_out_endofpacket = 0;


endmodule


//synthesis translate_off



// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE

// AND HERE WILL BE PRESERVED </ALTERA_NOTE>


// If user logic components use Altsync_Ram with convert_hex2ver.dll,
// set USE_convert_hex2ver in the user comments section above

// `ifdef USE_convert_hex2ver
// `else
// `define NO_PLI 1
// `endif

`include "c:/altera/80/quartus/eda/sim_lib/altera_mf.v"
`include "c:/altera/80/quartus/eda/sim_lib/220model.v"
`include "c:/altera/80/quartus/eda/sim_lib/sgate.v"
`include "egress_pipeline_fifo.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_dc_fifo/altera_avalon_dc_fifo.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_dc_fifo/altera_synchronizer.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_dc_fifo/altera_synchronizer_bundle.v"
`include "egress_fifo.v"
`include "gate.v"
`include "ip/stream_back_pressure_gate/stream_back_pressure_gate.v"
`include "pll_master.v"
`include "ip/dummy_master/dummy_master.v"
`include "build_id.v"
`include "ip/my_build_id/my_build_id.v"
`include "dut.v"
`include "ip/my_dut/my_dut.v"
`include "console_master.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_jtag_avalon_master/altera_jtag_avalon_master.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_jtag_avalon_master/altera_jtag_avalon_master_packets_to_bytes.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_jtag_avalon_master/altera_jtag_avalon_master_jtag_interface.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_jtag_avalon_master/altera_jtag_avalon_master_sc_fifo.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_jtag_avalon_master/altera_jtag_avalon_master_packets_to_transactions_converter.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_jtag_avalon_master/altera_jtag_avalon_master_bytes_to_packets.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_jtag_avalon_master/altera_jtag_avalon_master_channel_adapter_0.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_jtag_avalon_master/altera_jtag_avalon_master_channel_adapter_1.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_jtag_avalon_master/altera_jtag_avalon_master_timing_adapter.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_st_packets_to_bytes/altera_avalon_st_packets_to_bytes.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_jtag_phy/altera_jtag_dc_streaming.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_jtag_phy/altera_jtag_phy.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_jtag_phy/altera_jtag_streaming.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_st_idle_remover/altera_avalon_st_idle_remover.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_st_idle_inserter/altera_avalon_st_idle_inserter.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_sc_fifo/altera_avalon_sc_fifo.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_packets_to_master/altera_avalon_packets_to_master.v"
`include "C:/altera/80/ip/sopc_builder_ip/altera_avalon_st_bytes_to_packets/altera_avalon_st_bytes_to_packets.v"
`include "ingress_fifo.v"
`include "console_stream.v"
`include "pll.v"
`include "altpllpll.v"
`include "sysid.v"
`include "TA_before_ingress_fifo.v"
`include "TA_before_gate.v"
`include "DFA_before_ingress_fifo.v"
`include "DFA_before_ingress_fifo_state_ram.v"
`include "DFA_before_ingress_fifo_data_ram.v"
`include "test_sys_sopc_clock_0.v"
`include "DFA_before_console.v"
`include "DFA_before_console_state_ram.v"
`include "DFA_before_console_data_ram.v"
`include "TA_before_dut.v"

`timescale 1ns / 1ps

module test_bench 
;


  reg              clk;
  wire             fast_clk;
  wire    [ 31: 0] ingress_fifo_out_csr_writedata;
  reg              reset_n;
  wire             resetrequest_from_the_console_stream;
  wire             slow_clk;
  wire             test_sys_sopc_clock_0_in_endofpacket_from_sa;
  wire             test_sys_sopc_clock_0_out_endofpacket;
  wire             test_sys_sopc_clock_0_out_nativeaddress;


// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
//  add your signals and additional architecture here
// AND HERE WILL BE PRESERVED </ALTERA_NOTE>

  //Set us up the Dut
  test_sys_sopc DUT
    (
      .clk                                  (clk),
      .fast_clk                             (fast_clk),
      .reset_n                              (reset_n),
      .resetrequest_from_the_console_stream (resetrequest_from_the_console_stream),
      .slow_clk                             (slow_clk)
    );

  initial
    clk = 1'b0;
  always
    #10 clk <= ~clk;
  
  initial 
    begin
      reset_n <= 0;
      #200 reset_n <= 1;
    end

endmodule


//synthesis translate_on