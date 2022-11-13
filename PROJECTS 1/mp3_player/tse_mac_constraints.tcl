#####################################################################################
# Copyright (C) 1991-2007 Altera Corporation
# Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
# support information,  device programming or simulation file,  and any other
# associated  documentation or information  provided by  Altera  or a partner
# under  Altera's   Megafunction   Partnership   Program  may  be  used  only
# to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
# other  use  of such  megafunction  design,  netlist,  support  information,
# device programming or simulation file,  or any other  related documentation
# or information  is prohibited  for  any  other purpose,  including, but not
# limited to  modification,  reverse engineering,  de-compiling, or use  with
# any other  silicon devices,  unless such use is  explicitly  licensed under
# a separate agreement with  Altera  or a megafunction partner.  Title to the
# intellectual property,  including patents,  copyrights,  trademarks,  trade
# secrets,  or maskworks,  embodied in any such megafunction design, netlist,
# support  information,  device programming or simulation file,  or any other
# related documentation or information provided by  Altera  or a megafunction
# partner, remains with Altera, the megafunction partner, or their respective
# licensors. No other licenses, including any licenses needed under any third
# party's intellectual property, are provided herein.
#####################################################################################

#####################################################################################
# Altera Triple-Speed Ethernet Megacore TCL timing constraint file
# for use with the Quartus II Classic Timing Analyzer
#
# Generated on Wed Sep 17 10:07:46 PDT 2008
#
#####################################################################################


#Optimize hold time on all paths
set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS"

#Optimize I/O timing for MII interface
set_instance_assignment -name FAST_INPUT_REGISTER ON -to m_rx_col_to_the_tse_mac
set_instance_assignment -name FAST_INPUT_REGISTER ON -to m_rx_crs_to_the_tse_mac
set_instance_assignment -name FAST_INPUT_REGISTER ON -to m_rx_d_to_the_tse_mac
set_instance_assignment -name FAST_INPUT_REGISTER ON -to m_rx_en_to_the_tse_mac
set_instance_assignment -name FAST_INPUT_REGISTER ON -to m_rx_err_to_the_tse_mac
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to m_tx_d_from_the_tse_mac
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to m_tx_en_from_the_tse_mac
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to m_tx_err_from_the_tse_mac


#Optimize I/O timing for GMII interface
set_instance_assignment -name FAST_INPUT_REGISTER ON -to gm_rx_d_to_the_tse_mac
set_instance_assignment -name FAST_INPUT_REGISTER ON -to gm_rx_dv_to_the_tse_mac
set_instance_assignment -name FAST_INPUT_REGISTER ON -to gm_rx_err_to_the_tse_mac
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to gm_tx_d_from_the_tse_mac
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to gm_tx_en_from_the_tse_mac
set_instance_assignment -name FAST_OUTPUT_REGISTER ON -to gm_tx_err_from_the_tse_mac


#Constrain MAC network-side interface clocks
set_instance_assignment -name CLOCK_SETTINGS rx_clk_to_the_tse_mac -to rx_clk_to_the_tse_mac
set_global_assignment -name FMAX_REQUIREMENT "125.0 MHz" -section_id rx_clk_to_the_tse_mac
set_global_assignment -name INCLUDE_EXTERNAL_PIN_DELAYS_IN_FMAX_CALCULATIONS OFF -section_id rx_clk_to_the_tse_mac

set_instance_assignment -name CLOCK_SETTINGS tx_clk_to_the_tse_mac -to tx_clk_to_the_tse_mac
set_global_assignment -name FMAX_REQUIREMENT "125.0 MHz" -section_id tx_clk_to_the_tse_mac
set_global_assignment -name INCLUDE_EXTERNAL_PIN_DELAYS_IN_FMAX_CALCULATIONS OFF -section_id tx_clk_to_the_tse_mac


#Constrain timing for half duplex logic
set_instance_assignment -name MULTICYCLE 5 -from "*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*" -to *
set_instance_assignment -name MULTICYCLE 5 -from "*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*" -to *
set_instance_assignment -name MULTICYCLE 5 -from * -to "*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*"
set_instance_assignment -name MULTICYCLE 5 -from "*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|half_duplex_ena_reg2" -to *
set_instance_assignment -name TPD_REQUIREMENT "7.0 ns" -from "*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|dout_reg_sft" -to "*|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*"
set_instance_assignment -name TPD_REQUIREMENT "7.0 ns" -from "*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|eop_sft" -to "*|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*"
set_instance_assignment -name TPD_REQUIREMENT "7.0 ns" -from "*|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|sop_reg" -to "*|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*"


export_assignments

