ALU Testbench
-------------

1. Start Modelsim

2. Change directory to the source folder

3. Run the simulation script, i.e.,

Modelsim> source sim.tcl

Example script output

# QuestaSim vcom 10.5a Compiler 2016.04 Apr  5 2016
# Start time: 15:17:51 on Apr 16,2017
# vcom -reportprogress 300 -2008 log_pkg.vhd
# -- Loading package STANDARD
# -- Loading package TEXTIO
# -- Loading package std_logic_1164
# -- Loading package NUMERIC_STD
# -- Compiling package log_pkg
# -- Compiling package body log_pkg
# -- Loading package log_pkg
# End time: 15:17:51 on Apr 16,2017, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
# QuestaSim vcom 10.5a Compiler 2016.04 Apr  5 2016
# Start time: 15:17:51 on Apr 16,2017
# vcom -reportprogress 300 -2008 myalu.vhd
# -- Loading package STANDARD
# -- Loading package TEXTIO
# -- Loading package std_logic_1164
# -- Loading package NUMERIC_STD
# -- Compiling entity myalu
# -- Compiling architecture beh of myalu
# End time: 15:17:51 on Apr 16,2017, Elapsed time: 0:00:00
# Errors: 0, Warnings: 0
# QuestaSim vcom 10.5a Compiler 2016.04 Apr  5 2016
# Start time: 15:17:51 on Apr 16,2017
# vcom -reportprogress 300 -2008 tbmyalu.vhd
# -- Loading package STANDARD
# -- Loading package TEXTIO
# -- Loading package std_logic_1164
# -- Loading package NUMERIC_STD
# -- Loading package ENV
# -- Loading package log_pkg
# -- Compiling entity tbmyalu
# -- Compiling architecture tbmyalu_arch of tbmyalu
# End time: 15:17:52 on Apr 16,2017, Elapsed time: 0:00:01
# Errors: 0, Warnings: 0
# vsim -voptargs="+acc" tbmyalu
# Start time: 15:17:52 on Apr 16,2017
# ** Note: (vsim-3812) Design is being optimized...
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading std.env(body)
# Loading work.log_pkg(body)
# Loading work.tbmyalu(tbmyalu_arch)#1
# Loading work.myalu(beh)#1
#
# ==============================================================================
# ALU testbench
# ==============================================================================
#        100 ns:  Open stimulus file 'aluinout.txt'
#        100 ns:  Apply stimulus
#      16200 ns:  All stimulus checks passed!
#
# ==============================================================================
# Simulation complete
# ==============================================================================
# ** Note: stop
#    Time: 16200 ns  Iteration: 0  Instance: /tbmyalu
# Break in Process line__100 at tbmyalu.vhd line 239


