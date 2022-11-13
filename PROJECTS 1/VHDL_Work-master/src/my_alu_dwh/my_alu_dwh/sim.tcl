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
vcom -2008 myalu.vhd

# Testbench
vcom -2008 tbmyalu.vhd

# Run the testbench
vsim -voptargs=+acc tbmyalu
add wave *
add wave sim:/tbmyalu/u1/*
run -a
