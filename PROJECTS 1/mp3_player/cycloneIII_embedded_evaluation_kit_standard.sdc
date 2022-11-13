# Create generated clocks based on PLLs.

# Usually the next two steps are required but in this case, we're sourcing the ddr sdram constraint file before sourcing this file, so it's been done for us.

## Defining the external clock frequency from the oscillator
#create_clock -period 20.000 -name Oscillator_Clock [get_ports {osc_clk}]

## Deriving pll clocks
#derive_pll_clocks

## Creating and setting variables for clock paths to make code look cleaner
set System_Clock_int *|the_pll|the_pll|altpll_component|auto_generated|pll1|clk[0]
set SSRAM_Clock_ext *|the_pll|the_pll|altpll_component|auto_generated|pll1|clk[1]
set Slow_Clock_int *|the_pll|the_pll|altpll_component|auto_generated|pll1|clk[2]
set Remote_Update_Clock *|the_pll|the_pll|altpll_component|auto_generated|pll1|clk[3]
set DDR_Local_Clock *|the_ddr_sdram|ddr_sdram_controller_phy_inst|alt_mem_phy_inst|ddr_sdram_phy_alt_mem_phy_ciii_inst|clk|pll|altpll_component|auto_generated|pll1|clk[1]
set DDR_Controller_Clock *|the_ddr_sdram|ddr_sdram_controller_phy_inst|alt_mem_phy_inst|ddr_sdram_phy_alt_mem_phy_ciii_inst|clk|pll|altpll_component|auto_generated|pll1|clk[0]

## Cutting the paths between the system clock and ddr controller clock since there is a clock crossing bridge between them (FIFOs)
set_false_path -from [get_clocks {osc_clk}] -to [get_clocks $Slow_Clock_int]
set_false_path -from [get_clocks $Slow_Clock_int] -to [get_clocks {osc_clk}]

## Cutting the paths between the system clock and ddr controller clock since there is a clock crossing bridge between them (FIFOs)
set_false_path -from [get_clocks $Slow_Clock_int] -to [get_clocks $System_Clock_int]
set_false_path -from [get_clocks $System_Clock_int] -to [get_clocks $Slow_Clock_int]

## Cutting the paths between the system clock and ddr controller clock since there is a clock crossing bridge between them (FIFOs)
set_false_path -from [get_clocks $Slow_Clock_int] -to [get_clocks $DDR_Controller_Clock]
set_false_path -from [get_clocks $DDR_Controller_Clock] -to [get_clocks $Slow_Clock_int]

## Cutting the paths between the system clock and ddr controller clock since there is a clock crossing bridge between them (FIFOs)
set_false_path -from [get_clocks {osc_clk}] -to [get_clocks $DDR_Controller_Clock]
set_false_path -from [get_clocks $DDR_Controller_Clock] -to [get_clocks {osc_clk}]

## Cutting the paths between the system clock and ddr controller clock since there is a clock crossing bridge between them (FIFOs)
set_false_path -from [get_clocks $System_Clock_int] -to [get_clocks $DDR_Controller_Clock]
set_false_path -from [get_clocks $DDR_Controller_Clock] -to [get_clocks $System_Clock_int]

## Cutting the paths between the system clock and ddr local clock since there is a clock crossing bridge between them (FIFOs)
set_false_path -from [get_clocks $System_Clock_int] -to [get_clocks $DDR_Local_Clock]
set_false_path -from [get_clocks $DDR_Local_Clock] -to [get_clocks $System_Clock_int]

## Cutting the paths between the external oscillator clock and the system clock since there is an asyncronous clock crosser between them
set_false_path -from [get_clocks {osc_clk}] -to [get_clocks $System_Clock_int]
set_false_path -from [get_clocks $System_Clock_int] -to [get_clocks {osc_clk}]

## Cutting the paths between the external oscillator clock and the system clock since there is an asyncronous clock crosser between them
set_false_path -from [get_clocks {osc_clk}] -to [get_clocks $DDR_Local_Clock]
set_false_path -from [get_clocks $DDR_Local_Clock] -to [get_clocks {osc_clk}]

## Cutting the paths between the external oscillator clock and the remote update clock since there is an asyncronous clock crosser between them
set_false_path -from [get_clocks {osc_clk}] -to [get_clocks $Remote_Update_Clock]
set_false_path -from [get_clocks $Remote_Update_Clock] -to [get_clocks {osc_clk}]

##SSRAM Constraints

set_output_delay -clock [get_clocks $SSRAM_Clock_ext] -reference_pin [get_ports {ssram_clk}] 2.4 [get_ports {ssram_adsc_n ssram_bw_n* ssram_bwe_n ssram_ce_n ssram_oe_n flash_ssram_a* flash_ssram_d*}]
set_input_delay -clock [get_clocks $SSRAM_Clock_ext]  -reference_pin [get_ports {ssram_clk}] 4.1 [get_ports {flash_ssram_d*}]
set_multicycle_path -from [get_ports {flash_ssram_d*} ] -setup -end 2

#TSE constraints

#Constrain MAC network-side interface clocks
create_clock -period "125 MHz" -name tx_clk_to_the_tse_mac [ get_keepers HC_TX_CLK]
create_clock -period "125 MHz" -name rx_clk_to_the_tse_mac [ get_keepers HC_RX_CLK]

#Cut the timing path betweeen unrelated clock domains
set_clock_groups -exclusive -group {rx_clk_to_the_tse_mac} -group {tx_clk_to_the_tse_mac}
set_clock_groups -exclusive -group {tx_clk_to_the_tse_mac} -group {rx_clk_to_the_tse_mac}

set_false_path -from [get_clocks tx_clk_to_the_tse_mac] -to [get_clocks $System_Clock_int]
set_false_path -from [get_clocks $System_Clock_int] -to [get_clocks tx_clk_to_the_tse_mac]

set_false_path -from [get_clocks rx_clk_to_the_tse_mac] -to [get_clocks $System_Clock_int]
set_false_path -from [get_clocks $System_Clock_int] -to [get_clocks rx_clk_to_the_tse_mac]

set_false_path -from [get_clocks tx_clk_to_the_tse_mac] -to [get_clocks $Slow_Clock_int]
set_false_path -from [get_clocks $Slow_Clock_int] -to [get_clocks tx_clk_to_the_tse_mac]

set_false_path -from [get_clocks rx_clk_to_the_tse_mac] -to [get_clocks $Slow_Clock_int]
set_false_path -from [get_clocks $Slow_Clock_int] -to [get_clocks rx_clk_to_the_tse_mac]

#Constrain timing for half duplex logic
set_multicycle_path -setup 4 -from [ get_keepers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*] -to [ get_keepers *]
set_multicycle_path -setup 4 -from [ get_keepers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*] -to [ get_keepers *]
set_multicycle_path -setup 4 -from [ get_keepers *] -to [ get_keepers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*]
set_multicycle_path -setup 4 -from [ get_keepers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|half_duplex_ena_reg2] -to [ get_keepers *]
set_multicycle_path -hold 4 -from [ get_keepers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_altsyncram_dpm_fifo:U_RTSM|altsyncram*] -to [ get_keepers *]
set_multicycle_path -hold 4 -from [ get_keepers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*] -to [ get_keepers *]
set_multicycle_path -hold 4 -from [ get_keepers *] -to [ get_keepers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|altera_tse_retransmit_cntl:U_RETR|*]
set_multicycle_path -hold 4 -from [ get_keepers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|half_duplex_ena_reg2] -to [ get_keepers *]
set_max_delay 7 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|dout_reg_sft*] -to [get_keepers *|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*]
set_max_delay 7 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|eop_sft*] -to [get_keepers *|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*]
set_max_delay 7 -from [get_registers *|altera_tse_top_w_fifo:U_MAC|altera_tse_tx_min_ff:U_TXFF|sop_reg*] -to [get_keepers *|altera_tse_top_w_fifo:U_MAC|altera_tse_top_1geth:U_GETH|altera_tse_mac_tx:U_TX|*]


