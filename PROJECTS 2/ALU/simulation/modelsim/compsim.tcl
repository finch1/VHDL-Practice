# sim.tcl
#
# Modelsim simulation script

# Create the work library
if {![file exists work]} {
	vlib work
	vmap work ./work
}

# Logging package
vcom -2008 log_pkg.vhd

# Source
vcom -2008 mycomp.vhd

# Testbench
vcom -2008 tbmycomp.vhd

# Run the testbench
vsim -voptargs=+acc tbmycomp
add wave *
run -a
