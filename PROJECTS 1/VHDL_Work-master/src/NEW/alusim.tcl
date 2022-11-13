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
vcom -2008 alu.vhd

# Testbench
vcom -2008 tbalu.vhd

# Run the testbench
vsim -voptargs=+acc tbalu

add wave *
add wave sim:/tbalu/cut/*

restart -f
force -freeze sim:/tbalu/opcode 000000000000 0
force -freeze sim:/tbalu/a      0000000000000000 0
force -freeze sim:/tbalu/b      0000000000000000 0

noforce sim:/tbalu/opcode 
noforce sim:/tbalu/a      
noforce sim:/tbalu/b   

set NumericStdNoWarnings 1
set NumericStdNoWarnings 1 


run -a
