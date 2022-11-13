#
# sc_env - this help message describes the sc_env structure that the rest of 
#          the programmable master procs expect to interact with
#
add_help "sc_env" \
"\n\
This structure contains a TCL list of the following arguments:\n\
\n\
<structure signature>\n\
-   All procs currently validate this as the string \"sc_env_00\" to ensure\n\
-   they understand the format of the current structure.  If you decide to\n\
-   change the stucture, then you should change this version string as well.\n\
-   If you just want to append this structure, then you should not need to\n\
-   change this string.\n\
\n\
<master service path>\n\
-   This is the service path to the master service that commands should be\n\
-   issued to.   This is the service path that would have been passed into the\n\
-   \"open_service master <service path>\" command.  This is the service path\n\
-   that would have been returned by \"get_service_paths master\".\n\
\n\
<sysid_base>\n\
-   This is the base address of the sysid peripheral\n\
\n\
<sysid_id>\n\
-   This is the ID value that we expect to see in the sysid peripheral\n\
\n\
<sysid_timestamp>\n\
-   This is the TIMESTAMP value that we expect to see in the sysid peripheral\n\
\n\
"

#
# sc_validate_sysid
#
puts "Installing proc \"sc_validate_sysid\""
puts "USAGE: sc_validate_sysid \$sc_env"
add_help "sc_validate_sysid" \
"\n\
sc_validate_sysid attempts to validate that the sysid peripheral in the SOPC\n\
system matches the expected values that are extracted from the SOPCINFO file.\n\
\n\
The sc_env argument passed into this function is expected to contain all the\n\
required system information to perform this operation.  Try \"help sc_env\" for\n\
more information on the sc_env structure.\n\
\n\
USAGE: sc_validate_sysid \$sc_env\n\
\n\
"
proc sc_validate_sysid env {
    #
    # validate the input argument is a sc_env structure as best we can
    #
    set the_first_element [ lindex $env 0 ]
    if { "$the_first_element" != "sc_env_00" } {
        return -code error \
            "Input argument must be \"sc_env\" structure"
    }
    
    #
    # extract the required elements from the sc_env structure
    #
    set the_console_master  [ lindex $env 1 ]
    set the_console_stream  [ lindex $env 2 ]
    set the_sysid_base      [ lindex $env 3 ]
    set the_sysid_id        [ lindex $env 4 ]
    set the_sysid_timestamp [ lindex $env 5 ]
    
    #
    # close the stream service and open the master service
    #
    close_service bytestream $the_console_stream
    open_service master $the_console_master

    #
    # read the sysid registers from the hardware
    #
    set the_current_sysid [ master_read_32 $the_console_master $the_sysid_base 2 ]
    
    #
    # close the master service and reopen the stream service
    #
    close_service master $the_console_master
    open_service bytestream $the_console_stream

    #
    # extract each register value
    #
    set the_hw_sysid_id         [ lindex $the_current_sysid 0 ]
    set the_hw_sysid_timestamp  [ lindex $the_current_sysid 1 ]
    
    puts [ format "HW_ID = 0x%08X - %uu" $the_hw_sysid_id $the_hw_sysid_id ]
    puts [ format "HW_TS = 0x%08X - %uu" $the_hw_sysid_timestamp $the_hw_sysid_timestamp ]
    
    if { $the_hw_sysid_id != $the_sysid_id } {
        return -code error \
            "The HW sysid ID value does not match the expected ID."
    }
        
    if { $the_hw_sysid_timestamp != $the_sysid_timestamp } {
        return -code error \
            "The HW sysid TIMESTAMP value does not match the expected TIMESTAMP."
    }
    
    return -code ok \
        "The HW sysid validation was successful..."
}

#
# sc_build_id_display
#
puts "Installing proc \"sc_build_id_display\""
puts "USAGE: sc_build_id_display \$sc_env"
add_help "sc_build_id_display" \
"\n\
sc_build_id_display attempts to display the build id PIO value.\n\
\n\
The sc_env argument passed into this function is expected to contain all the\n\
required system information to perform this operation.  Try \"help sc_env\" for\n\
more information on the sc_env structure.\n\
\n\
USAGE: sc_build_id_display \$sc_env\n\
\n\
"
proc sc_build_id_display env {
    #
    # validate the input argument is a sc_env structure as best we can
    #
    set the_first_element [ lindex $env 0 ]
    if { "$the_first_element" != "sc_env_00" } {
        return -code error \
            "Input argument must be \"sc_env\" structure"
    }
    
    #
    # extract the required elements from the sc_env structure
    #
    set the_console_master  [ lindex $env 1 ]
    set the_console_stream  [ lindex $env 2 ]
    set the_build_id_base   [ lindex $env 6 ]

    #
    # close the stream service and open the master service
    #
    close_service bytestream $the_console_stream
    open_service master $the_console_master

    #
    # read the build id pio from the hardware
    #
    set the_current_build_id [ master_read_32 $the_console_master $the_build_id_base 1 ]
    
    #
    # close the master service and reopen the stream service
    #
    close_service master $the_console_master
    open_service bytestream $the_console_stream

    puts [ format "BUILD_ID = 0x%08X - %uu" $the_current_build_id $the_current_build_id ]
    
    puts "sc_build_id_display complete..."
}

#
# sc_read_gate_trigger_level
#
puts "Installing proc \"sc_read_gate_trigger_level\""
puts "USAGE: sc_read_gate_trigger_level \$sc_env"
add_help "sc_read_gate_trigger_level" \
"\n\
sc_read_gate_trigger_level attempts to read the current trigger level value\n\
from the gate peripheral.\n\
\n\
The sc_env argument passed into this function is expected to contain all the\n\
required system information to perform this operation.  Try \"help sc_env\" for\n\
more information on the sc_env structure.\n\
\n\
USAGE: sc_read_gate_trigger_level \$sc_env\n\
\n\
"
proc sc_read_gate_trigger_level env {
    #
    # validate the input argument is a sc_env structure as best we can
    #
    set the_first_element [ lindex $env 0 ]
    if { "$the_first_element" != "sc_env_00" } {
        return -code error \
            "Input argument must be \"sc_env\" structure"
    }
    
    #
    # extract the required elements from the sc_env structure
    #
    set the_console_master  [ lindex $env 1 ]
    set the_console_stream  [ lindex $env 2 ]
    set the_gate_base   	[ lindex $env 7 ]

    #
    # close the stream service and open the master service
    #
    close_service bytestream $the_console_stream
    open_service master $the_console_master

    #
    # read the current trigger level from the hardware
    #
    set the_current_trigger_level [ master_read_32 $the_console_master $the_gate_base 1 ]
    
    #
    # close the master service and reopen the stream service
    #
    close_service master $the_console_master
    open_service bytestream $the_console_stream

    puts [ format "Current trigger level = 0x%08X - %uu" $the_current_trigger_level $the_current_trigger_level ]
    
    puts "sc_read_gate_trigger_level complete..."
}

#
# sc_write_gate_trigger_level
#
puts "Installing proc \"sc_write_gate_trigger_level\""
puts "USAGE: sc_write_gate_trigger_level \$sc_env <new_trigger_level>"
add_help "sc_write_gate_trigger_level" \
"\n\
sc_write_gate_trigger_level attempts to write a new trigger level into the\n\
gate peripheral.\n\
\n\
The sc_env argument passed into this function is expected to contain all the\n\
required system information to perform this operation.  Try \"help sc_env\" for\n\
more information on the sc_env structure.\n\
\n\
USAGE: sc_write_gate_trigger_level \$sc_env  <new_trigger_level>\n\
\n\
"
proc sc_write_gate_trigger_level { env new_trigger_level } {
    #
    # validate the input argument is a sc_env structure as best we can
    #
    set the_first_element [ lindex $env 0 ]
    if { "$the_first_element" != "sc_env_00" } {
        return -code error \
            "Input argument must be \"sc_env\" structure"
    }
    
    #
    # extract the required elements from the sc_env structure
    #
    set the_console_master  [ lindex $env 1 ]
    set the_console_stream  [ lindex $env 2 ]
    set the_gate_base   	[ lindex $env 7 ]

    #
    # close the stream service and open the master service
    #
    close_service bytestream $the_console_stream
    open_service master $the_console_master

    #
    # write the new trigger level and then read it back for display
    #
    master_write_32 $the_console_master $the_gate_base $new_trigger_level
    set the_current_trigger_level [ master_read_32 $the_console_master $the_gate_base 1 ]
    
    #
    # close the master service and reopen the stream service
    #
    close_service master $the_console_master
    open_service bytestream $the_console_stream

    puts [ format "Current trigger level = 0x%08X - %uu" $the_current_trigger_level $the_current_trigger_level ]
    
    puts "sc_write_gate_trigger_level complete..."
}
