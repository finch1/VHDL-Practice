#
# altera_hostfs_driver.tcl
#

# Create a new driver and associate it with a software package known
# as "altera_hostfs"
create_sw_package altera_hostfs

# The version of this software
set_sw_property version 13.0

# Initialize the driver in alt_sys_init()
set_sw_property auto_initialize true

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory drivers 

#
# Source file listings...
#

# C/C++ source files
add_sw_property c_source HAL/src/altera_hostfs.c

# Include files
add_sw_property include_source HAL/inc/altera_hostfs.h

# This driver supports HAL & UCOSII BSP (OS) types
add_sw_property supported_bsp_type HAL
add_sw_property supported_bsp_type UCOSII

# Add File-system mount point setting to the BSP:
add_sw_setting quoted_string system_h_define hostfs_name ALTERA_HOSTFS_NAME /mnt/host "Mount point"

# End of file
