# +-----------------------------------
# | module stream_back_pressure_gate
# | 
set_module_property DESCRIPTION "This component applies a back pressure gate for streams that do not support valid or ready."
set_module_property NAME stream_back_pressure_gate
set_module_property VERSION 1.0
set_module_property GROUP ""
set_module_property AUTHOR RSF
set_module_property DISPLAY_NAME stream_back_pressure_gate
set_module_property TOP_LEVEL_HDL_FILE stream_back_pressure_gate.v
set_module_property TOP_LEVEL_HDL_MODULE stream_back_pressure_gate
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property SIMULATION_MODEL_IN_VERILOG false
set_module_property SIMULATION_MODEL_IN_VHDL true
set_module_property SIMULATION_MODEL_HAS_TULIPS false
set_module_property SIMULATION_MODEL_IS_OBFUSCATED false

set_module_property ELABORATION_CALLBACK    elaborate_me
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file stream_back_pressure_gate.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter TRIGGER_DEPTH int 1500 "This is the default reset value for the trigger depth of the gate."
set_parameter_property TRIGGER_DEPTH DISPLAY_NAME "Gate Trigger Depth"
set_parameter_property TRIGGER_DEPTH GROUP "Stream Back Pressure Parameters"
set_parameter_property TRIGGER_DEPTH UNITS None
set_parameter_property TRIGGER_DEPTH AFFECTS_PORT_WIDTHS true
set_parameter_property TRIGGER_DEPTH ALLOWED_RANGES {0:65535}

add_parameter DATA_WIDTH int 16 "This is the width of the data port for the stream sources and sinks."
set_parameter_property DATA_WIDTH DISPLAY_NAME "Data Width"
set_parameter_property DATA_WIDTH GROUP "Stream Back Pressure Parameters"
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH AFFECTS_PORT_WIDTHS true
set_parameter_property DATA_WIDTH ALLOWED_RANGES { \
  "8:  8  -  1 Byte" \
 "16: 16  -  2 Bytes" \
 "24: 24  -  3 Bytes" \
 "32: 32  -  4 Bytes" \
 "40: 40  -  5 Bytes" \
 "48: 48  -  6 Bytes" \
 "56: 56  -  7 Bytes" \
 "64: 64  -  8 Bytes" \
 "72: 72  -  9 Byte" \
 "80: 80  -  10 Bytes" \
 "88: 88  -  11 Bytes" \
 "96: 96  -  12 Bytes" \
"104:104  -  13 Bytes" \
"112:112  -  14 Bytes" \
"120:120  -  15 Bytes" \
"128:128  -  16 Bytes" \
}

add_parameter USE_CSR_PORT int 0 "This paremeter enables the CSR slave on this peripheral."
set_parameter_property USE_CSR_PORT DISPLAY_NAME "Use CSR port?"
set_parameter_property USE_CSR_PORT GROUP "Stream Back Pressure Parameters"
set_parameter_property USE_CSR_PORT UNITS None
set_parameter_property USE_CSR_PORT AFFECTS_PORT_WIDTHS true
set_parameter_property USE_CSR_PORT ALLOWED_RANGES { \
 "0:FALSE" \
 "1:TRUE" \
}
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
# | connection point ingress_snk
# | 
add_interface ingress_snk avalon_streaming end
set_interface_property ingress_snk maxChannel 0
set_interface_property ingress_snk errorDescriptor ""
set_interface_property ingress_snk readyLatency 0
set_interface_property ingress_snk dataBitsPerSymbol 8
set_interface_property ingress_snk symbolsPerBeat 1

set_interface_property ingress_snk ASSOCIATED_CLOCK clock

add_interface_port ingress_snk asi_ingress_snk_ready ready Output 1
add_interface_port ingress_snk asi_ingress_snk_valid valid Input 1
add_interface_port ingress_snk asi_ingress_snk_data data Input -1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point ingress_src
# | 
add_interface ingress_src avalon_streaming start
set_interface_property ingress_src maxChannel 0
set_interface_property ingress_src errorDescriptor ""
set_interface_property ingress_src readyLatency 0
set_interface_property ingress_src dataBitsPerSymbol 8
set_interface_property ingress_src symbolsPerBeat 1

set_interface_property ingress_src ASSOCIATED_CLOCK clock

add_interface_port ingress_src aso_ingress_src_valid valid Output 1
add_interface_port ingress_src aso_ingress_src_data data Output -1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point egress_snk
# | 
add_interface egress_snk avalon_streaming end
set_interface_property egress_snk maxChannel 0
set_interface_property egress_snk errorDescriptor ""
set_interface_property egress_snk readyLatency 0
set_interface_property egress_snk dataBitsPerSymbol 8
set_interface_property egress_snk symbolsPerBeat 1

set_interface_property egress_snk ASSOCIATED_CLOCK clock

add_interface_port egress_snk asi_egress_snk_valid valid Input 1
add_interface_port egress_snk asi_egress_snk_data data Input -1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point egress_src
# | 
add_interface egress_src avalon_streaming start
set_interface_property egress_src maxChannel 0
set_interface_property egress_src errorDescriptor ""
set_interface_property egress_src readyLatency 0
set_interface_property egress_src dataBitsPerSymbol 8
set_interface_property egress_src symbolsPerBeat 1

set_interface_property egress_src ASSOCIATED_CLOCK clock

add_interface_port egress_src aso_egress_src_ready ready Input 1
add_interface_port egress_src aso_egress_src_valid valid Output 1
add_interface_port egress_src aso_egress_src_data data Output -1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point m0
# | 
add_interface m0 avalon start
set_interface_property m0 linewrapBursts false
set_interface_property m0 adaptsTo ""
set_interface_property m0 doStreamReads false
set_interface_property m0 doStreamWrites false
set_interface_property m0 burstOnBurstBoundariesOnly false

set_interface_property m0 ASSOCIATED_CLOCK clock

add_interface_port m0 avm_m0_address address Output 3
add_interface_port m0 avm_m0_read read Output 1
add_interface_port m0 avm_m0_waitrequest waitrequest Input 1
add_interface_port m0 avm_m0_readdata readdata Input 32
add_interface_port m0 avm_m0_readdatavalid readdatavalid Input 1
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

add_interface_port s0 avs_s0_write write Input 1
add_interface_port s0 avs_s0_writedata writedata Input 32
add_interface_port s0 avs_s0_readdata readdata Output 32
# | 
# +-----------------------------------

proc elaborate_me { } {

	#
	# setup the properties which depend on the data width parameter
	#
	set the_data_width [ get_parameter_value DATA_WIDTH ]
	set the_symbols_per_beat [ expr ($the_data_width / 8) ]
	
	set_port_property asi_ingress_snk_data	WIDTH $the_data_width
	set_port_property aso_ingress_src_data	WIDTH $the_data_width
	set_port_property asi_egress_snk_data	WIDTH $the_data_width
	set_port_property aso_egress_src_data	WIDTH $the_data_width

	set_interface_property ingress_snk	symbolsPerBeat $the_symbols_per_beat
	set_interface_property ingress_src	symbolsPerBeat $the_symbols_per_beat
	set_interface_property egress_snk	symbolsPerBeat $the_symbols_per_beat
	set_interface_property egress_src	symbolsPerBeat $the_symbols_per_beat
	
	#
	# enable the CSR port based on the USE_CSR_PORT parameter
	#
	set the_use_csr_port [ get_parameter_value USE_CSR_PORT ]
	if { $the_use_csr_port == 0 } {

		set_port_property avs_s0_write		TERMINATION true
		set_port_property avs_s0_write		TERMINATION_VALUE 0
		set_port_property avs_s0_writedata	TERMINATION true
		set_port_property avs_s0_writedata	TERMINATION_VALUE 0
		set_port_property avs_s0_readdata	TERMINATION true
		
	} else {

		set_port_property avs_s0_write		TERMINATION false
		set_port_property avs_s0_writedata	TERMINATION false
		set_port_property avs_s0_readdata	TERMINATION false
	}

}
