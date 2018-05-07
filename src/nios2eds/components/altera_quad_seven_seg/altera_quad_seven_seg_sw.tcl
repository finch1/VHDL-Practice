#
# altera_quad_seven_seg_sw.tcl
#

# Create a new software package and name it "altera_ro_zipfs"
create_sw_package altera_quad_seven_seg

# The version of this software
set_sw_property version 13.0

# Initialize the driver in alt_sys_init()
set_sw_property auto_initialize false

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory drivers

#
# Source file listings...
#

# C/C++ source files
add_sw_property c_source HAL/src/alt_quad_seven_seg.c

# Include files
add_sw_property include_source HAL/inc/alt_quad_seven_seg.h


# This driver supports HAL & UCOSII BSP (OS) types
add_sw_property supported_bsp_type HAL
add_sw_property supported_bsp_type UCOSII

# End of file
