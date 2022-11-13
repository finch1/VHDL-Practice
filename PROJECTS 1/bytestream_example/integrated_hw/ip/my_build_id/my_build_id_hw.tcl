# +-----------------------------------
# | module my_build_id
# | 
set_module_property DESCRIPTION "This component is a simple 32 bit constant that can be read as a build ID value."
set_module_property NAME my_build_id
set_module_property VERSION 1.0
set_module_property GROUP ""
set_module_property AUTHOR RSF
set_module_property DISPLAY_NAME my_build_id
set_module_property TOP_LEVEL_HDL_FILE my_build_id.v
set_module_property TOP_LEVEL_HDL_MODULE my_build_id
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
add_file my_build_id.v {SYNTHESIS SIMULATION}
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
# | connection point s0
# | 
add_interface s0 avalon end
set_interface_property s0 holdTime 0
set_interface_property s0 linewrapBursts false
set_interface_property s0 minimumUninterruptedRunLength 1
set_interface_property s0 bridgesToMaster ""
set_interface_property s0 isMemoryDevice false
set_interface_property s0 burstOnBurstBoundariesOnly false
set_interface_property s0 addressSpan 4
set_interface_property s0 timingUnits Cycles
set_interface_property s0 setupTime 0
set_interface_property s0 writeWaitTime 0
set_interface_property s0 isNonVolatileStorage false
set_interface_property s0 addressAlignment DYNAMIC
set_interface_property s0 maximumPendingReadTransactions 0
set_interface_property s0 readWaitTime 1
set_interface_property s0 readLatency 0
set_interface_property s0 printableDevice false

set_interface_property s0 ASSOCIATED_CLOCK clock

add_interface_port s0 avs_s0_readdata readdata Output 32
# | 
# +-----------------------------------
