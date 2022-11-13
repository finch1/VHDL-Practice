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

module console_master (
                        // inputs:
                         clk,
                         readdata_to_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                         readdatavalid_to_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                         reset_n,
                         waitrequest_to_the_altera_jtag_avalon_master_packets_to_transactions_converter,

                        // outputs:
                         address_from_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                         byteenable_from_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                         read_from_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                         resetrequest_from_the_altera_jtag_avalon_master_jtag_interface,
                         write_from_the_altera_jtag_avalon_master_packets_to_transactions_converter,
                         writedata_from_the_altera_jtag_avalon_master_packets_to_transactions_converter
                      )
;

  output  [ 31: 0] address_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  output  [  3: 0] byteenable_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  output           read_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  output           resetrequest_from_the_altera_jtag_avalon_master_jtag_interface;
  output           write_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  output  [ 31: 0] writedata_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  input            clk;
  input   [ 31: 0] readdata_to_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  input            readdatavalid_to_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  input            reset_n;
  input            waitrequest_to_the_altera_jtag_avalon_master_packets_to_transactions_converter;

  wire    [ 31: 0] address_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  wire    [  3: 0] byteenable_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  wire             read_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  wire             resetrequest_from_the_altera_jtag_avalon_master_jtag_interface;
  wire             write_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  wire    [ 31: 0] writedata_from_the_altera_jtag_avalon_master_packets_to_transactions_converter;
  altera_jtag_avalon_master the_altera_jtag_avalon_master
    (
      .address_from_the_altera_jtag_avalon_master_packets_to_transactions_converter     (address_from_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .byteenable_from_the_altera_jtag_avalon_master_packets_to_transactions_converter  (byteenable_from_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .clk                                                                              (clk),
      .read_from_the_altera_jtag_avalon_master_packets_to_transactions_converter        (read_from_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .readdata_to_the_altera_jtag_avalon_master_packets_to_transactions_converter      (readdata_to_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .readdatavalid_to_the_altera_jtag_avalon_master_packets_to_transactions_converter (readdatavalid_to_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .reset_n                                                                          (reset_n),
      .resetrequest_from_the_altera_jtag_avalon_master_jtag_interface                   (resetrequest_from_the_altera_jtag_avalon_master_jtag_interface),
      .waitrequest_to_the_altera_jtag_avalon_master_packets_to_transactions_converter   (waitrequest_to_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .write_from_the_altera_jtag_avalon_master_packets_to_transactions_converter       (write_from_the_altera_jtag_avalon_master_packets_to_transactions_converter),
      .writedata_from_the_altera_jtag_avalon_master_packets_to_transactions_converter   (writedata_from_the_altera_jtag_avalon_master_packets_to_transactions_converter)
    );


endmodule

