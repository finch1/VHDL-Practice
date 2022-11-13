#
# sc_test_random $random_next_value
#
puts "Installing proc \"sc_test_random\""
puts "USAGE: sc_test_random <random_next_value>"
add_help "sc_test_random" \
"\n\
sc_test_random takes an input value and applies a randomization algorithm to\n\
it and returns the randomized result.  The intended usage is to keep pushing\n\
the returned results back into this function to get the next randomized\n\
pattern.  A good initial seed value is 0x33557799.\n\
\n\
USAGE: sc_test_random <random_next_value>\n\
\n\
"
proc sc_test_random random_next_value {
    set random_next_value [ expr ((($random_next_value<<5)|(($random_next_value>>27)&0x01F))+0x33557799) ] 
    return $random_next_value
}

#
# sc_create_incrementing_test_file
#
puts "Installing proc \"sc_create_incrementing_test_file\""
puts "USAGE: sc_create_incrementing_test_file <count> <output filename>"
add_help "sc_create_incrementing_test_file" \
"\n\
sc_create_incrementing_test_file creates a binary data file with incrementing\n\
16-bit word values in big endian format.  It creates <count> values and stores\n\
them in <output filename>\n\
\n\
USAGE: sc_create_incrementing_test_file <count> <output filename>\n\
\n\
"
proc sc_create_incrementing_test_file { count outfilename } {

    set data_list [ list ]
    for { set i 0 } { $i < $count } { incr i } {
        set hi_byte [ expr ( ( $i >> 8 ) & 0xFF ) ]
        set lo_byte [ expr ( $i & 0xFF ) ]
        lappend data_list $hi_byte $lo_byte
    }

    set outfile [ open "$outfilename" "w" ]
    fconfigure $outfile -translation binary
    puts -nonewline $outfile [ binary format c* $data_list ]
    close $outfile
}

#
# sc_test_stream
#
puts "Installing proc \"sc_test_stream\""
puts "USAGE: sc_test_stream \$sc_env <input filename> <output filename> <ingress_trigger_bytes> <egress_fifo_bytes>"
add_help "sc_test_stream" \
"\n\
sc_test_stream opens the <input filename> and sends the data contained within\n\
it out the bytestream service.  It then captures the bytestream input and\n\
writes it into <output filename>.\n\
The amount of data read from the input file is specified by the\n\
ingress_trigger_bytes argument that is passed into this script.  This should be\n\
set to the number of bytes required to fill the ingress fifo to the trigger\n\
level programmed into the gate peripheral.  This is something like:\n\
    (trigger_level * bytes_per_entry)\n\
The amount of data written to the output file is specified by the\n\
egress_fifo_bytes argument that is passed into this script.  This should be set\n\
to the number of bytes of the entire egress fifo capacity.  This is something\n\
like this:\n\
    (fifo_depth * bytes_per_entry)\n\
\n\
USAGE: sc_test_stream \$sc_env <input filename> <output filename> <ingress_trigger_bytes> <egress_fifo_bytes>\n\
\n\
"
proc sc_test_stream { env infilename outfilename ingress_trigger_bytes egress_fifo_bytes } {

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
    set the_console_stream  [ lindex $env 2 ]

    #
    # check that the input file exists and contains at least ingress_trigger_bytes bytes of data
    #
    if { [ file exists "$infilename" ] } {
        if { [ file size "$infilename" ] < $ingress_trigger_bytes } {
            return -code error \
"\
INPUT FILE = \"$infilename\"\n\
\n\
The input file you specified exists, but does not contain at least $ingress_trigger_bytes bytes\n\
of data...\n\
"
        }
    } else {
            return -code error \
"\
INPUT FILE = \"$infilename\"\n\
\n\
The input file you specified does not exist...\n\
"
    }

    #
    # open the input file and read the data
    #
    set infile [ open "$infilename" "r" ]
    fconfigure $infile -translation binary
    set in_data [ read $infile $ingress_trigger_bytes ]
    close $infile
    
    binary scan $in_data c$ingress_trigger_bytes the_data

    #
    # purge any stale data from the input stream
    #
    bytestream_receive $the_console_stream $egress_fifo_bytes
    
    #
    # send the data into the stream
    #
    bytestream_send $the_console_stream $the_data
    
    #
    # read the returning stream data
    #
    set return_data [ list ]
    while { [llength $return_data] < $egress_fifo_bytes } {
        set next_bytes [ bytestream_receive $the_console_stream $egress_fifo_bytes ]
        if { [llength $next_bytes] > 0 } {
            set return_data [ concat $return_data $next_bytes ]
        }
    }
    
    #
    # write the returned data to the output file
    #
    set outfile [ open "$outfilename" "w" ]
    fconfigure $outfile -translation binary
    puts -nonewline $outfile [ binary format c* $return_data ]
    close $outfile
}
