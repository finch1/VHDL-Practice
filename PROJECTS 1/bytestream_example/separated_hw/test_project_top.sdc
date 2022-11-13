# the clocks
create_clock -period 50MHz -name clk50in [ get_ports clk ]
set_clock_groups -exclusive -group [ get_clocks clk50in ]

derive_pll_clocks

# the reset
set_false_path -from [ get_ports {reset_n} ] -to *

# JTAG constraints
create_clock -name {altera_reserved_tck} -period 10MHz  [ get_ports {altera_reserved_tck} ]
set_clock_groups -exclusive -group [ get_clocks {altera_reserved_tck} ]

set_input_delay		-clock altera_reserved_tck	20	[ get_ports {altera_reserved_tdi} ]
set_input_delay		-clock altera_reserved_tck	20	[ get_ports {altera_reserved_tms} ]
set_output_delay	-clock altera_reserved_tck	20	[ get_ports {altera_reserved_tdo} ]

# false paths missing in the auto clock adapter
set_false_path -from [ get_registers {*|test_sys_sopc_clock_0:the_test_sys_sopc_clock_0|*|master_read_done} ]		-to [ get_registers {*|test_sys_sopc_clock_0:the_test_sys_sopc_clock_0|unxmaster_read_donexx0} ]
set_false_path -from [ get_registers {*|test_sys_sopc_clock_0:the_test_sys_sopc_clock_0|*|slave_write_request} ]	-to [ get_registers {*|test_sys_sopc_clock_0:the_test_sys_sopc_clock_0|unxslave_write_requestxx3} ]
set_false_path -from [ get_registers {*|test_sys_sopc_clock_0:the_test_sys_sopc_clock_0|*|slave_read_request} ]		-to [ get_registers {*|test_sys_sopc_clock_0:the_test_sys_sopc_clock_0|unxslave_read_requestxx2} ]
set_false_path -from [ get_registers {*|test_sys_sopc_clock_0:the_test_sys_sopc_clock_0|*|master_write_done} ]		-to [ get_registers {*|test_sys_sopc_clock_0:the_test_sys_sopc_clock_0|unxmaster_write_donexx1} ]
