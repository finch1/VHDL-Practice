project_open -current_revision cycloneIII_embedded_evaluation_kit_standard.qpf
# copyright (c) 1991-2007 altera corporation
# your use of altera corporation's design tools, logic functions 
# and other software and tools, and its ampp partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the altera program license 
# subscription agreement, altera megacore function license 
# agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by altera and sold by 
# altera or its authorized distributors.  please refer to the 
# applicable agreement for further details.


# the default values for assignments are stored in the file
#		cycloneiii_3c25_starter_board_standard_top_assignment_defaults.qdf
# if this file doesn't exist, and for assignments not listed, see file
#		assignment_defaults.qdf

# altera recommends that you do not modify this file. this
# file is updated automatically by the quartus ii software
# and any changes you make may be lost or overwritten.


set_global_assignment -name DEVICE EP3C25F324C8
set_global_assignment -name FAMILY "Cyclone III"
set_global_assignment -name top_level_entity cycloneIII_embedded_evaluation_kit_standard
set_global_assignment -name ORIGINAL_QUARTUS_VERSION 7.1
set_global_assignment -name PROJECT_CREATION_TIME_DATE "13:37:31  MARCH 30, 2007"
set_global_assignment -name LAST_QUARTUS_VERSION 7.1
set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
set_global_assignment -name DEVICE_FILTER_PIN_COUNT 324
set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 8

set_instance_assignment -name OUTPUT_ENABLE_GROUP 1191024410 -to led[0]
set_instance_assignment -name OUTPUT_ENABLE_GROUP 1191024410 -to led[1]
set_instance_assignment -name OUTPUT_ENABLE_GROUP 1191024410 -to led[2]
set_instance_assignment -name OUTPUT_ENABLE_GROUP 1191024410 -to led[3]

set_instance_assignment -name CURRENT_STRENGTH_NEW 12mA -to ssram_adsc_n
set_instance_assignment -name CURRENT_STRENGTH_NEW 12mA -to ssram_bw_n
set_instance_assignment -name CURRENT_STRENGTH_NEW 12mA -to ssram_ce_n
set_instance_assignment -name CURRENT_STRENGTH_NEW 12mA -to ssram_oe_n
set_instance_assignment -name CURRENT_STRENGTH_NEW 12mA -to ssram_bwe_n
set_instance_assignment -name CURRENT_STRENGTH_NEW 12mA -to ssram_clk
set_instance_assignment -name TCO_REQUIREMENT "3.3 ns" -from * -to ssram_adsc_n
set_instance_assignment -name TCO_REQUIREMENT "3.3 ns" -from * -to ssram_bw_n
set_instance_assignment -name TCO_REQUIREMENT "3.3 ns" -from * -to ssram_bwe_n
set_instance_assignment -name TCO_REQUIREMENT "3.3 ns" -from * -to ssram_ce_n
set_instance_assignment -name TCO_REQUIREMENT "3.3 ns" -from * -to ssram_oe_n
set_instance_assignment -name TCO_REQUIREMENT "3.3 ns" -from * -to flash_ssram_a
set_instance_assignment -name TSU_REQUIREMENT "6 ns" -from * -to flash_ssram_d

set_global_assignment -name CYCLONEIII_CONFIGURATION_SCHEME "ACTIVE PARALLEL"
set_global_assignment -name STRATIXIII_UPDATE_MODE REMOTE
set_global_assignment -name USE_CONFIGURATION_DEVICE OFF
set_global_assignment -name GENERATE_TTF_FILE ON
set_global_assignment -name ON_CHIP_BITSTREAM_DECOMPRESSION OFF
set_global_assignment -name RESERVE_DATA0_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA1_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA7_THROUGH_DATA2_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_FLASH_NCE_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_OTHER_AP_PINS_AFTER_CONFIGURATION "USE AS REGULAR IO"

set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
set_global_assignment -name OPTIMIZE_FAST_CORNER_TIMING ON
set_global_assignment -name FITTER_EFFORT "STANDARD FIT"
set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC ON
set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON
set_global_assignment -name PHYSICAL_SYNTHESIS_ASYNCHRONOUS_SIGNAL_PIPELINING ON
set_global_assignment -name PHYSICAL_SYNTHESIS_REGISTER_RETIMING ON
set_global_assignment -name PHYSICAL_SYNTHESIS_EFFORT FAST
set_global_assignment -name PHYSICAL_SYNTHESIS_COMBO_LOGIC_FOR_AREA ON
set_global_assignment -name PHYSICAL_SYNTHESIS_MAP_LOGIC_TO_MEMORY_FOR_AREA ON
set_global_assignment -name ADV_NETLIST_OPT_SYNTH_WYSIWYG_REMAP ON
set_global_assignment -name ADV_NETLIST_OPT_SYNTH_GATE_RETIME ON
set_global_assignment -name CYCLONEII_OPTIMIZATION_TECHNIQUE SPEED
set_global_assignment -name SDC_FILE ddr_sdram_phy_ddr_timing.sdc
set_global_assignment -name SDC_FILE cycloneIII_embedded_evaluation_kit_standard.sdc
#set_global_assignment -name SDC_FILE tse_mac_constraints.sdc
set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS"
set_global_assignment -name RESERVE_ALL_UNUSED_PINS_NO_OUTPUT_GND "AS INPUT TRI-STATED"

#Temporary until HdLComponent (the java model) get's fixed.
#set_global_assignment -name VERILOG_FILE /data/sbalan/overlays/altera_7_1_with_new_components/ip/sopc_builder_ip/altera_avalon_sdcard_controller_spi/altera_avalon_sdcard_controller_spi.v
#set_global_assignment -name VERILOG_FILE /data/sbalan/overlays/altera_7_1_with_new_components/ip/sopc_builder_ip/altera_avalon_sdcard_controller_spi/altera_avalon_sdcard_controller_spi_data_ram.v
#set_global_assignment -name VERILOG_FILE /data/sbalan/overlays/altera_7_1_with_new_components/ip/sopc_builder_ip/altera_avalon_pixel_converter/altera_avalon_pixel_converter.v
#set_global_assignment -name VERILOG_FILE /data/sbalan/overlays/altera_7_1_with_new_components/ip/sopc_builder_ip/altera_avalon_video_sequencer/altera_avalon_video_sequencer.v
#set_global_assignment -name VERILOG_FILE /data/sbalan/overlays/altera_7_1_with_new_components/ip/sopc_builder_ip/altera_avalon_remote_update_cycloneiii/altera_avalon_remote_update_cycloneiii.v

set_location_assignment PLL_4 -to "*|ddr_sdram:the_ddr_sdram|*|pll1"
project_close
