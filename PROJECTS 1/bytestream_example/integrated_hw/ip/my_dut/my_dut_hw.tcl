# +-----------------------------------
# | module my_dut
# | 
set_module_property DESCRIPTION "This is a simple streaming component that inverts the input sink data and outputs it on the source interface."
set_module_property NAME my_dut
set_module_property VERSION 1.0
set_module_property GROUP ""
set_module_property AUTHOR RSF
set_module_property DISPLAY_NAME my_dut
set_module_property TOP_LEVEL_HDL_FILE my_dut.v
set_module_property TOP_LEVEL_HDL_MODULE my_dut
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property SIMULATION_MODEL_IN_VERILOG false
set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property SIMULATION_MODEL_HAS_TULIPS false
set_module_property SIMULATION_MODEL_IS_OBFUSCATED false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file my_dut.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock
# | 
add_interface clock clock end
set_interface_property clock ptfSchematicName ""

add_interface_port clock csi_clock_clk clk Input 1
add_interface_port clock csi_clock_reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point sink
# | 
add_interface sink avalon_streaming end
set_interface_property sink maxChannel 0
set_interface_property sink errorDescriptor ""
set_interface_property sink readyLatency 0
set_interface_property sink dataBitsPerSymbol 8
set_interface_property sink symbolsPerBeat 2

set_interface_property sink ASSOCIATED_CLOCK clock

add_interface_port sink asi_sink_data data Input 16
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point source
# | 
add_interface source avalon_streaming start
set_interface_property source maxChannel 0
set_interface_property source errorDescriptor ""
set_interface_property source readyLatency 0
set_interface_property source dataBitsPerSymbol 8
set_interface_property source symbolsPerBeat 2

set_interface_property source ASSOCIATED_CLOCK clock

add_interface_port source aso_source_data data Output 16
# | 
# +-----------------------------------
