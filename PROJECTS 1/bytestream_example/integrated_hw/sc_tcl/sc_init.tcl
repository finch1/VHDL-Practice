#
# Make sure that you've started system-console with the --jdi file option so
# that this script can successfully discover the master service path and other
# resources within the system.
#
# If you don't have access to the sopcinfo file or the jdi file for your design
# then you will have to manually overide various sections of this script with
# the specific system information that it would otherwise attempt to discover.
# See the "NO SOPCINFO FILE" and "NO JDI FILE" comments below for guidance on
# this.
#
# If you do have the sopcinfo file and jdi file, then this script should be able
# to automatically discover the system parameters that it requires to properly
# interact with the programmable master component.
#
# The following variables should be setup by the user prior to sourcing this
# script:
#
#   sopcinfo_file_path
#       This is the path to the sopcinfo file that was created by SOPC Builder.
#
#   console_master_name
#       This is the component name of the master service path in the SOPC
#       Builder system.
#
#   console_stream_name
#       This is the component name of the bytestream service path in the SOPC
#       Builder system.
#
#   hw_or_sim
#       This variable should be set to "hw" if you are connecting to a master
#       service path located in hardware, or "sim" if you are connecting to a
#       master service path located in a simulation model.
#
#   pli_setup_path
#       If you are simulating, this needs to be the path to the system console
#       PLI setup script.
#
#   pli_port_number
#       If you are simulating, this needs to be the port number that the PLI
#       should connect to the model with.
#
set sopcinfo_file_path          "../test_sys_sopc.sopcinfo"
set console_master_name         "console_master"
set console_stream_name         "console_stream"
set hw_or_sim                   "hw"
set pli_setup_path              "../preview_setup_pli_systemconsole.tcl"
set pli_port_number             "50000"

#
# make sure this script is sourced from it's own directory
#
set the_pwd [ pwd ]

if { ![ file exists "sc_init.tcl" ] } {
    return -code error \
"\
You need to source this file from the directory it exists in and it must be\n\
called \"sc_init.tcl\".  You sourced from \"$the_pwd\"\
"
}

#
# source the support scripts
#
if { [ file exists "sc_discovery_procs.tcl" ] } {
    source sc_discovery_procs.tcl
} else {
    return -code error \
        "File \"sc_discovery_procs.tcl\" does not exist in \"$the_pwd\", so it cannot be sourced."
}

if { [ file exists "sc_init_procs.tcl" ] } {
    source sc_init_procs.tcl
} else {
    return -code error \
        "File \"sc_init_procs.tcl\" does not exist in \"$the_pwd\", so it cannot be sourced."
}

if { [ file exists "sc_test_procs.tcl" ] } {
    source sc_test_procs.tcl
} else {
    return -code error \
        "File \"sc_test_procs.tcl\" does not exist in \"$the_pwd\", so it cannot be sourced."
}

#
# NO SOPCINFO FILE AVAILABLE?
#
# if you don't have an sopcinfo file for your system, then manually configure
# the variables below and comment out the auto discovery section that follows
#
set sysid_base              "unknown"
set sysid_id                "unknown"
set sysid_timestamp         "unknown"
set build_id_base           "unknown"
set gate_base               "unknown"

#
# discover the system parameters that we need to run
#
if { [ catch { sc_discover_system_info $sopcinfo_file_path $console_master_name } result ] } {
    return -code error \
        "System discovery failed with the following error:\n$result"
} else {
    set sysid_base              [ lindex $result 0 ]
    set sysid_id                [ lindex $result 1 ]
    set sysid_timestamp         [ lindex $result 2 ]
    set build_id_base           [ lindex $result 3 ]
    set gate_base               [ lindex $result 4 ]
}

#
# NO JDI FILE AVAILABLE?
#
# if you don't have a jdi file for your fpga, then you should open the master
# service prior to sourcing this script.  Manually configure the following
# variable to the path that you opened for your master service and comment out
# the master service opening code that follows.
#
# Another option would be to run the following command prior to sourcing this
# script, but after you opened your master service:
#   set the_console_master_path [ lindex [get_service_paths master] <your_master_index> ]
#
set the_console_master_path "unknown"
set the_console_stream_path "unknown"


#
# open the service paths
#
if { $hw_or_sim == "hw" } {
    if { [ catch { sc_open_hw_service $console_master_name $console_stream_name } result ] } {
        return -code error \
            "Failed to open service paths with the following error:\n$result"
    } else {
        set the_console_master_path [ lindex $result 0 ]
        set the_console_stream_path [ lindex $result 1 ]
    }
} else {
    puts "This script does not currently open services for simulation..."
}

#
# create some short variable names for the service paths
#
set cm $the_console_master_path
set cs $the_console_stream_path

#
# inform the user of our defined variable names
#
puts ""
puts "The following variables are established..."
puts [ format "    sysid_base      = 0x%08X" $sysid_base ]
puts [ format "    sysid_id        = 0x%08X - %uu" $sysid_id $sysid_id ]
puts [ format "    sysid_timestamp = 0x%08X - %uu" $sysid_timestamp $sysid_timestamp ]
puts [ format "    build_id_base   = 0x%08X" $build_id_base ]
puts [ format "    gate_base       = 0x%08X" $gate_base ]

puts ""
puts "The following service path variables are established..."
puts "stream path - cs = $cs"
puts "master path - cm = $cm"

#
# create the sc_env structure of our variables to pass into procs
#
puts ""
puts "Setting up the \"sc_env\" list for use with procs..."
set sc_env [ list \
    "sc_env_00" \
    "$the_console_master_path" \
    "$the_console_stream_path" \
    "$sysid_base" \
    "$sysid_id" \
    "$sysid_timestamp" \
    "$build_id_base" \
    "$gate_base" \
]

puts ""
