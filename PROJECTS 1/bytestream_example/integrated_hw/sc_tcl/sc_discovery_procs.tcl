#
# sc_discover_system_info
#
puts "Installing proc \"sc_discover_system_info\""
puts "USAGE: sc_discover_system_info <sopcinfo_file_path> <console_master_name>"
add_help "sc_discover_system_info" \
"\n\
sc_discover_system_info will attempt to discover the base address information\n\
for the sysid peripheral and build id PIO.  This proc uses the sopcinfo\n\
file that is output from SOPC Builder and it translates it into an swinfo file\n\
and finally a system header file.  It then parses the system header file for\n\
the requisite #defines that describe the information that it needs.\n\
"
proc sc_discover_system_info { sopcinfo_file_path console_master_name } {
    #
    # derive the file names for the system info files
    #
    set sopc_system_name [ file rootname [ file tail $sopcinfo_file_path ] ]
    set sc_system_info_dir      "sc_sys_info"
    set swinfo_file_path        "$sc_system_info_dir/$sopc_system_name.swinfo"
    set system_header_file_path "$sc_system_info_dir/$sopc_system_name.h"

    puts ""
    puts "Discovery will use these files for system information:"
    puts "     SOPCINFO - \"$sopcinfo_file_path\""
    puts "       SWINFO - \"$swinfo_file_path\""
    puts "System Header - \"$system_header_file_path\""

    #
    # ensure that the sc_sys_info directory exists
    #
    file mkdir $sc_system_info_dir

    #
    # verify that the system header file exists and is up to date
    #
    puts ""
    puts "Verifying that \"$system_header_file_path\" exists and is up to date..."

    #
    # verify that sopcinfo_file_path exists
    #
    if { [ file exists $sopcinfo_file_path ] } {
    } else {
        return -code error \
            "File \"$sopcinfo_file_path\" does not exist.  You can change this name in this script if you like."
    }

    #
    # verify that system_header_file_path exists
    #
    if { [ file exists $system_header_file_path ] } {
        #
        #if system_header_file_path does exist but is older than sopcinfo_file_path, then re-create it
        #
        if { [ file mtime $sopcinfo_file_path ] > [ file mtime $system_header_file_path ] } { 
            puts ""
            puts "\"$sopcinfo_file_path\" is older than \"$system_header_file_path\", recreating it..."
            
            set the_command "sopcinfo2swinfo.exe --input=$sopcinfo_file_path --output=$swinfo_file_path"
            if { [ catch "exec $the_command" ] } {
                return -code error \
                    "An error occured while running:\n----$the_command"
            }
            set the_command "swinfo2header.exe --swinfo $swinfo_file_path --output-dir $sc_system_info_dir"
            if { [ catch "exec $the_command" ] } {
                return -code error \
                    "An error occured while running:\n----$the_command"
            }
        }
    } else {
        #
        #if system_header_file_path does not exist, then create it
        #
        puts ""
        puts "\"$system_header_file_path\" does not exist, creating it..."
        
        set the_command "sopcinfo2swinfo.exe --input=$sopcinfo_file_path --output=$swinfo_file_path"
        if { [ catch "exec $the_command" ] } {
            return -code error \
                "An error occured while running:\n----$the_command"
        }
        set the_command "swinfo2header.exe --swinfo $swinfo_file_path --output-dir $sc_system_info_dir"
        if { [ catch "exec $the_command" ] } {
            return -code error \
                "An error occured while running:\n----$the_command"
        }
    }

    #
    # search the header for the base addresses of my slaves and other interesting properties
    #
    puts ""
    puts "Searching \"$system_header_file_path\" for various system information..."

    set C_M_N   [ string toupper $console_master_name ]

    set sysid_base_re       "^\[ \t\]*#define\[ \t\]+$C_M_N\_SYSID_BASE\[ \t\]+(0x\[0-9a-fA-F\]+)"
    set sysid_id_re         "^\[ \t\]*#define\[ \t\]+$C_M_N\_SYSID_ID\[ \t\]+(\[0-9a-fA-F\]+)u"
    set sysid_timestamp_re  "^\[ \t\]*#define\[ \t\]+$C_M_N\_SYSID_TIMESTAMP\[ \t\]+(\[0-9a-fA-F\]+)u"
    set build_id_base_re    "^\[ \t\]*#define\[ \t\]+$C_M_N\_BUILD_ID_BASE\[ \t\]+(0x\[0-9a-fA-F\]+)"
    set gate_base_re        "^\[ \t\]*#define\[ \t\]+$C_M_N\_GATE_BASE\[ \t\]+(0x\[0-9a-fA-F\]+)"
    set define_re           "^\[ \t\]*#define\[ \t\]+.*"

    set sysid_base              "unknown"
    set sysid_id                "unknown"
    set sysid_timestamp         "unknown"
    set build_id_base           "unknown"
    set gate_base               "unknown"

    set header_file [ open $system_header_file_path r ]
    while { [ gets $header_file next_line ] >= 0 } {
        if { [ regexp $define_re $next_line ] } {
            if { [ regexp $sysid_base_re $next_line -> value ] } {
                set sysid_base              $value
            } elseif { [ regexp $sysid_id_re $next_line -> value ] } {
                set sysid_id                $value
            } elseif { [ regexp $sysid_timestamp_re $next_line -> value ] } {
                set sysid_timestamp         $value
            } elseif { [ regexp $build_id_base_re $next_line -> value ] } {
                set build_id_base           $value
            } elseif { [ regexp $gate_base_re $next_line -> value ] } {
                set gate_base           $value
            }
        }
    }
    close $header_file

    #
    # make sure we found everything we were looking for
    #
    if  { $sysid_base == "unknown" } {
        return -code error \
            "Could not find \"sysid_base\" in header file.  Exiting..."
    }
    if  { $sysid_id == "unknown" } {
        return -code error \
            "Could not find \"sysid_id\" in header file.  Exiting..."
    }
    if  { $sysid_timestamp == "unknown" } {
        return -code error \
            "Could not find \"sysid_timestamp\" in header file.  Exiting..."
    }
    if  { $build_id_base == "unknown" } {
        return -code error \
            "Could not find \"build_id_base\" in header file.  Exiting..."
    }
    if  { $gate_base == "unknown" } {
        return -code error \
            "Could not find \"gate_base\" in header file.  Exiting..."
    }
    
    return -code ok \
        [ list \
            $sysid_base \
            $sysid_id \
            $sysid_timestamp \
            $build_id_base \
            $gate_base \
        ]
}

#
# sc_open_hw_service
#
puts "Installing proc \"sc_open_hw_service\""
puts "USAGE: sc_open_hw_service <console_master_name> <console_stream_name>"
add_help "sc_open_hw_service" \
"\n\
sc_open_hw_service will attempt to open the master service for the named\n\
peripheral in a hardware system, as well as the bytestream service peripheral.\n\
It's required that you start system console with the --jdi option so that we\n\
have proper peripheral names to associate with out of the SOPC Builder system.\n\
\n\
"
proc sc_open_hw_service { console_master_name console_stream_name } {
    #
    # open the master service
    #
    set the_console_master_path "unknown"
    set master_service_paths [ get_service_paths master ]
    set console_master_re "^.*$console_master_name\$"
    foreach path $master_service_paths {
        if { [ regexp $console_master_re $path ] } {
            puts ""
            puts "Discovered master service for service path:\n$path"
            #
            # open the path and then close it because we want the sream path open by default
            #
            open_service master $path
            close_service master $path
            set the_console_master_path $path
        }
    }

    if { $the_console_master_path == "unknown" } {
        puts ""
        return -code error \
"\
Could not locate a master service for \"$console_master_name\".\n\
Are you certain that you are connected to the proper hardware system in your\n\
FPGA?  Are you sure that you started the system-console properly?  You need to\n\
make sure that you've used the --jdi option so that the JDI file can be used to\n\
derive the name of the service path if you are connecting to hardware.\n\
"
    }
    
    #
    # open the bytestream service
    #
    set the_console_stream_path "unknown"
    set stream_service_paths [ get_service_paths bytestream ]
    set console_stream_re "^.*$console_stream_name\$"
    foreach path $stream_service_paths {
        if { [ regexp $console_stream_re $path ] } {
            puts ""
            puts "Discovered and opening stream service for service path:\n$path"
            open_service bytestream $path
            set the_console_stream_path $path
        }
    }

    if { $the_console_stream_path == "unknown" } {
        puts ""
        return -code error \
"\
Could not locate a bytestream service for \"$console_stream_name\".\n\
Are you certain that you are connected to the proper hardware system in your\n\
FPGA?  Are you sure that you started the system-console properly?  You need to\n\
make sure that you've used the --jdi option so that the JDI file can be used to\n\
derive the name of the service path if you are connecting to hardware.\n\
"
    }

    return -code ok [ list "$the_console_master_path" "$the_console_stream_path" ]
}
