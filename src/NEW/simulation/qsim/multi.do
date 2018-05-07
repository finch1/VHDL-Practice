onerror {exit -code 1}
vlib work
vlog -work work multi.vo
vlog -work work CPU_Wform.vwf.vt
vsim -novopt -c -t 1ps -L cycloneiii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.cpu_vlg_vec_tst -voptargs="+acc"
vcd file -direction multi.msim.vcd
vcd add -internal cpu_vlg_vec_tst/*
vcd add -internal cpu_vlg_vec_tst/i1/*
run -all
quit -f