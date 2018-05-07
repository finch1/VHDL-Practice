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
vcom -2008 mymult.vhd

# Testbench
vcom -2008 tbmymult.vhd

# Run the testbench
vsim -voptargs=+acc tbmymult
add wave *
run -a
