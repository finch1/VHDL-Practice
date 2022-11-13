#
# audio_codec_WM8731_sw.tcl
#

# Create a new driver
create_driver audio_codec_WM8731_driver

# Associate it with some hardware known as "audio_codec_WM8731"
set_sw_property hw_class_name audio_codec_WM8731

# The version of this driver is "7.2"
set_sw_property version 7.2

# This driver may be incompatible with versions of hardware less
# than specified below. Updates to hardware and device drivers
# rendering the driver incompatible with older versions of
# hardware are noted with this property assignment.
#
# Multiple-Version compatibility was introduced in version 7.1;
# prior versions are therefore excluded.
set_sw_property min_compatible_hw_version 7.2

# Initialize the driver in alt_sys_init()
set_sw_property auto_initialize true

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory drivers

# This driver supports the HAL & uC/OS-II (OS) types
add_sw_property supported_bsp_type HAL
add_sw_property supported_bsp_type UCOSII

#
# Source file listings...
#

# C/C++ source files
add_sw_property c_source HAL/src/audio_codec_WM8731.c
#add_sw_property c_source HAL/src/fat.c
#add_sw_property c_source HAL/src/fat_file.c

# Include files
add_sw_property include_source HAL/inc/audio_codec_WM8731.h
#add_sw_property include_source HAL/inc/fat.h
#add_sw_property include_source HAL/inc/fat_file.h

# End of file
