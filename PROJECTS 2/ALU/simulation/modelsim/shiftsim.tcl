# sim.tcl
#
# Modelsim simulation script

# Create the work library
if {![file exists work]} {
	vdel -all
	vlib work
	vmap work ./work
}

# Logging package
vcom -2008 log_pkg.vhd

# Source
#vcom -2008 mycomp.vhd

# Testbench
vcom -2008 tbmyclshift.vhd

# Run the testbench
vsim -voptargs=+acc tbmyclshift
add wave *
run -a
