#
# altera_hal_sw.tcl -- A description of Altera HAL for Altera Nios II BSP tools
#

# Create a new operating system called "hal"
create_os HAL

# Set UI display name
set_sw_property display_name "Altera HAL"

# This OS "extends" HAL BSP type
set_sw_property extends_bsp_type HAL

set_sw_property version 13.0

# Location in generated BSP that above sources will be copied into
set_sw_property bsp_subdirectory HAL

#
# Source file listings...
#
add_sw_property c_source HAL/src/alt_alarm_start.c
add_sw_property c_source HAL/src/alt_close.c
add_sw_property c_source HAL/src/alt_dev.c
add_sw_property c_source HAL/src/alt_dev_llist_insert.c
add_sw_property c_source HAL/src/alt_dma_rxchan_open.c
add_sw_property c_source HAL/src/alt_dma_txchan_open.c
add_sw_property c_source HAL/src/alt_environ.c
add_sw_property c_source HAL/src/alt_env_lock.c
add_sw_property c_source HAL/src/alt_errno.c
add_sw_property c_source HAL/src/alt_execve.c
add_sw_property c_source HAL/src/alt_exit.c
add_sw_property c_source HAL/src/alt_fcntl.c
add_sw_property c_source HAL/src/alt_fd_lock.c
add_sw_property c_source HAL/src/alt_fd_unlock.c
add_sw_property c_source HAL/src/alt_find_dev.c
add_sw_property c_source HAL/src/alt_find_file.c
add_sw_property c_source HAL/src/alt_flash_dev.c
add_sw_property c_source HAL/src/alt_fork.c
add_sw_property c_source HAL/src/alt_fs_reg.c
add_sw_property c_source HAL/src/alt_fstat.c
add_sw_property c_source HAL/src/alt_get_fd.c
add_sw_property c_source HAL/src/alt_getchar.c
add_sw_property c_source HAL/src/alt_getpid.c
add_sw_property c_source HAL/src/alt_gettod.c
add_sw_property c_source HAL/src/alt_iic_isr_register.c
add_sw_property c_source HAL/src/alt_instruction_exception_register.c
add_sw_property c_source HAL/src/alt_ioctl.c
add_sw_property c_source HAL/src/alt_io_redirect.c
add_sw_property c_source HAL/src/alt_irq_handler.c
add_sw_property c_source HAL/src/alt_isatty.c
add_sw_property c_source HAL/src/alt_kill.c
add_sw_property c_source HAL/src/alt_link.c
add_sw_property c_source HAL/src/alt_load.c
add_sw_property c_source HAL/src/alt_log_printf.c
add_sw_property c_source HAL/src/alt_lseek.c
add_sw_property c_source HAL/src/alt_main.c
add_sw_property c_source HAL/src/alt_malloc_lock.c
add_sw_property c_source HAL/src/alt_open.c
add_sw_property c_source HAL/src/alt_printf.c
add_sw_property c_source HAL/src/alt_putchar.c
add_sw_property c_source HAL/src/alt_putstr.c
add_sw_property c_source HAL/src/alt_read.c
add_sw_property c_source HAL/src/alt_release_fd.c
add_sw_property c_source HAL/src/alt_rename.c
add_sw_property c_source HAL/src/alt_sbrk.c
add_sw_property c_source HAL/src/alt_settod.c
add_sw_property c_source HAL/src/alt_stat.c
add_sw_property c_source HAL/src/alt_tick.c
add_sw_property c_source HAL/src/alt_times.c
add_sw_property c_source HAL/src/alt_unlink.c
add_sw_property c_source HAL/src/alt_wait.c
add_sw_property c_source HAL/src/alt_write.c


# Include files
add_sw_property include_source HAL/inc/os/alt_flag.h
add_sw_property include_source HAL/inc/os/alt_hooks.h
add_sw_property include_source HAL/inc/os/alt_sem.h
add_sw_property include_source HAL/inc/os/alt_syscall.h

add_sw_property include_source HAL/inc/priv/alt_alarm.h
add_sw_property include_source HAL/inc/priv/alt_dev_llist.h
add_sw_property include_source HAL/inc/priv/alt_exception_handler_registry.h
add_sw_property include_source HAL/inc/priv/alt_file.h
add_sw_property include_source HAL/inc/priv/alt_iic_isr_register.h
add_sw_property include_source HAL/inc/priv/alt_irq_table.h
add_sw_property include_source HAL/inc/priv/alt_no_error.h

add_sw_property include_source HAL/inc/sys/alt_alarm.h
add_sw_property include_source HAL/inc/sys/alt_cache.h
add_sw_property include_source HAL/inc/sys/alt_dev.h
add_sw_property include_source HAL/inc/sys/alt_dma.h
add_sw_property include_source HAL/inc/sys/alt_dma_dev.h
add_sw_property include_source HAL/inc/sys/alt_driver.h
add_sw_property include_source HAL/inc/sys/alt_errno.h
add_sw_property include_source HAL/inc/sys/alt_flash.h
add_sw_property include_source HAL/inc/sys/alt_flash_dev.h
add_sw_property include_source HAL/inc/sys/alt_flash_types.h
add_sw_property include_source HAL/inc/sys/alt_license_reminder_ucosii.h
add_sw_property include_source HAL/inc/sys/alt_llist.h
add_sw_property include_source HAL/inc/sys/alt_load.h
add_sw_property include_source HAL/inc/sys/alt_log_printf.h
add_sw_property include_source HAL/inc/sys/alt_set_args.h
add_sw_property include_source HAL/inc/sys/alt_stdio.h
add_sw_property include_source HAL/inc/sys/alt_sys_init.h
add_sw_property include_source HAL/inc/sys/alt_sys_wrappers.h
add_sw_property include_source HAL/inc/sys/alt_timestamp.h
add_sw_property include_source HAL/inc/sys/ioctl.h
add_sw_property include_source HAL/inc/sys/termios.h


# Include paths
add_sw_property include_directory HAL/inc

# Single threaded
add_sw_property alt_cppflags_addition -DALT_SINGLE_THREADED


#
# HAL General Settings
#

add_sw_setting2 sys_clk_timer unquoted_string
set_sw_setting_property sys_clk_timer default_value none
set_sw_setting_property sys_clk_timer identifier ALT_SYS_CLK
set_sw_setting_property sys_clk_timer description "Slave descriptor of the system clock timer device. This device provides a periodic interrupt (\"tick\") and is typically required for RTOS use. This setting defines the value of ALT_SYS_CLK in system.h."
set_sw_setting_property sys_clk_timer destination system_h_define
set_sw_setting_property sys_clk_timer group common

add_sw_setting2 timestamp_timer unquoted_string
set_sw_setting_property timestamp_timer default_value none
set_sw_setting_property timestamp_timer identifier ALT_TIMESTAMP_CLK
set_sw_setting_property timestamp_timer description "Slave descriptor of timestamp timer device. This device is used by Altera HAL timestamp drivers for high-resolution time measurement. This setting defines the value of ALT_TIMESTAMP_CLK in system.h."
set_sw_setting_property timestamp_timer destination system_h_define
set_sw_setting_property timestamp_timer group common

add_sw_setting2 max_file_descriptors decimal_number
set_sw_setting_property max_file_descriptors default_value 32
set_sw_setting_property max_file_descriptors identifier ALT_MAX_FD
set_sw_setting_property max_file_descriptors description "Determines the number of file descriptors statically allocated. This setting defines the value of ALT_MAX_FD in system.h."
set_sw_setting_property max_file_descriptors restrictions "If hal.enable_lightweight_device_driver_api is true, there are no file descriptors so this setting is ignored. If hal.enable_lightweight_device_driver_api is false, this setting must be at least 4 because HAL needs a file descriptor for /dev/null, /dev/stdin, /dev/stdout, and /dev/stderr."
set_sw_setting_property max_file_descriptors destination system_h_define

add_sw_setting2 enable_instruction_related_exceptions_api boolean_define_only 
set_sw_setting_property enable_instruction_related_exceptions_api default_value false
set_sw_setting_property enable_instruction_related_exceptions_api identifier ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
set_sw_setting_property enable_instruction_related_exceptions_api description "Enables API for registering handlers to service instruction-related exceptions. Enabling this setting increases the size of the exception entry code."
set_sw_setting_property enable_instruction_related_exceptions_api restrictions "These exception types can be generated if various processor options are enabled, such as the MMU, MPU, or other advanced exception types."
set_sw_setting_property enable_instruction_related_exceptions_api destination system_h_define

#
# HAL Linker Settings
#
add_sw_setting2 linker.allow_code_at_reset boolean
set_sw_setting_property linker.allow_code_at_reset default_value false 
set_sw_setting_property linker.allow_code_at_reset identifier ALT_ALLOW_CODE_AT_RESET
set_sw_setting_property linker.allow_code_at_reset description "Indicates if initialization code is allowed at the reset address. If true, defines the macro ALT_ALLOW_CODE_AT_RESET in linker.h."
set_sw_setting_property linker.allow_code_at_reset restrictions "If true, defines the macro ALT_ALLOW_CODE_AT_RESET in linker.h. This setting is typically false if an external bootloader (e.g. flash bootloader) is present."
set_sw_setting_property linker.allow_code_at_reset destination none

add_sw_setting2 linker.enable_alt_load boolean
set_sw_setting_property linker.enable_alt_load default_value false 
set_sw_setting_property linker.enable_alt_load identifier none
set_sw_setting_property linker.enable_alt_load description "Enables the alt_load() facility. The alt_load() facility copies sections from the .text memory into RAM. If true, this setting sets up the VMA/LMA of sections in linker.x to allow them to be loaded into the .text memory."
set_sw_setting_property linker.enable_alt_load restrictions "This setting is typically false if an external bootloader (e.g. flash bootloader) is present."
set_sw_setting_property linker.enable_alt_load destination none

add_sw_setting2 linker.enable_alt_load_copy_rodata boolean
set_sw_setting_property linker.enable_alt_load_copy_rodata default_value false 
set_sw_setting_property linker.enable_alt_load_copy_rodata identifier none
set_sw_setting_property linker.enable_alt_load_copy_rodata description "Causes the alt_load() facility to copy the .rodata section. If true, this setting defines the macro ALT_LOAD_COPY_RODATA in linker.h."
set_sw_setting_property linker.enable_alt_load_copy_rodata destination none

add_sw_setting2 linker.enable_alt_load_copy_rwdata boolean
set_sw_setting_property linker.enable_alt_load_copy_rwdata default_value false 
set_sw_setting_property linker.enable_alt_load_copy_rwdata identifier none
set_sw_setting_property linker.enable_alt_load_copy_rwdata description "Causes the alt_load() facility to copy the .rwdata section. If true, this setting defines the macro ALT_LOAD_COPY_RWDATA in linker.h." 

add_sw_setting2 linker.enable_alt_load_copy_exceptions boolean
set_sw_setting_property linker.enable_alt_load_copy_exceptions default_value false 
set_sw_setting_property linker.enable_alt_load_copy_exceptions identifier none
set_sw_setting_property linker.enable_alt_load_copy_exceptions description "Causes the alt_load() facility to copy the .exceptions section. If true, this setting defines the macro ALT_LOAD_COPY_EXCEPTIONS in linker.h."
set_sw_setting_property linker.enable_alt_load_copy_exceptions destination none

add_sw_setting2 linker.enable_exception_stack boolean
set_sw_setting_property linker.enable_exception_stack default_value false 
set_sw_setting_property linker.enable_exception_stack identifier none
set_sw_setting_property linker.enable_exception_stack description "Enables use of a separate exception stack. If true, defines the macro ALT_EXCEPTION_STACK in linker.h, adds a memory region called exception_stack to linker.x, and provides the symbols __alt_exception_stack_pointer and __alt_exception_stack_limit in linker.x."
set_sw_setting_property linker.enable_exception_stack restrictions "The hal.linker.exception_stack_size and hal.linker.exception_stack_memory_region_name settings must also be valid. This setting must be false for MicroC/OS-II BSPs. The exception stack can be used to improve interrupt and other exception performance if the EIC is *not* used."
set_sw_setting_property linker.enable_exception_stack destination none
set_sw_setting_property linker.enable_exception_stack group common

add_sw_setting2 linker.exception_stack_size decimal_number
set_sw_setting_property linker.exception_stack_size default_value 1024 
set_sw_setting_property linker.exception_stack_size identifier none
set_sw_setting_property linker.exception_stack_size description "Size of the exception stack in bytes."
set_sw_setting_property linker.exception_stack_size restrictions "Only used if hal.linker.enable_exception_stack is true."
set_sw_setting_property linker.exception_stack_size destination none
set_sw_setting_property linker.exception_stack_size group common

add_sw_setting2 linker.exception_stack_memory_region_name unquoted_string
set_sw_setting_property linker.exception_stack_memory_region_name default_value none
set_sw_setting_property linker.exception_stack_memory_region_name identifier none
set_sw_setting_property linker.exception_stack_memory_region_name description "Name of the existing memory region that will be divided up to create the 'exception_stack' memory region. The selected region name will be adjusted automatically when the BSP is generated to create the 'exception_stack' memory region."
set_sw_setting_property linker.exception_stack_memory_region_name restrictions "Only used if hal.linker.enable_exception_stack is true."
set_sw_setting_property linker.exception_stack_memory_region_name destination none
set_sw_setting_property linker.exception_stack_memory_region_name group common

add_sw_setting2 linker.enable_interrupt_stack boolean
set_sw_setting_property linker.enable_interrupt_stack default_value false
set_sw_setting_property linker.enable_interrupt_stack identifier none
set_sw_setting_property linker.enable_interrupt_stack description "Enables use of a separate interrupt stack. If true, defines the macro ALT_INTERRUPT_STACK in linker.h, adds a memory region called interrupt_stack to linker.x, and provides the symbols __alt_interrupt_stack_pointer and __alt_interrupt_stack_limit in linker.x."
set_sw_setting_property linker.enable_interrupt_stack restrictions "The hal.linker.interrupt_stack_size and hal.linker.interrupt_stack_memory_region_name settings must also be valid. This setting must be false for MicroC/OS-II BSPs. Only enable if the EIC is used exclusively. The exception stack can be used to improve interrupt and other exception performance if the EIC is *not* used."
set_sw_setting_property linker.enable_interrupt_stack destination none
set_sw_setting_property linker.enable_interrupt_stack group common

add_sw_setting2 linker.interrupt_stack_size decimal_number
set_sw_setting_property linker.interrupt_stack_size default_value 1024
set_sw_setting_property linker.interrupt_stack_size identifier none
set_sw_setting_property linker.interrupt_stack_size description "Size of the interrupt stack in bytes."
set_sw_setting_property linker.interrupt_stack_size restrictions "Only used if hal.linker.enable_interrupt_stack is true."
set_sw_setting_property linker.interrupt_stack_size destination none
set_sw_setting_property linker.interrupt_stack_size group common

add_sw_setting2 linker.interrupt_stack_memory_region_name unquoted_string
set_sw_setting_property linker.interrupt_stack_memory_region_name default_value none
set_sw_setting_property linker.interrupt_stack_memory_region_name identifier none
set_sw_setting_property linker.interrupt_stack_memory_region_name description "Name of the existing memory region that will be divided up to create the 'interrupt_stack' memory region. The selected region name will be adjusted automatically when the BSP is generated to create the 'interrupt_stack' memory region."
set_sw_setting_property linker.interrupt_stack_memory_region_name restrictions "Only used if hal.linker.enable_interrupt_stack is true."
set_sw_setting_property linker.interrupt_stack_memory_region_name destination none
set_sw_setting_property linker.interrupt_stack_memory_region_name group common

#
# HAL system.h Settings
#

add_sw_setting2 stdin unquoted_string
set_sw_setting_property stdin default_value none
set_sw_setting_property stdin identifier none
set_sw_setting_property stdin description "Slave descriptor of STDIN character-mode device. This setting is used by the ALT_STDIN family of defines in system.h."
set_sw_setting_property stdin restrictions none
set_sw_setting_property stdin destination system_h_define
set_sw_setting_property stdin group common

add_sw_setting2 stdout unquoted_string
set_sw_setting_property stdout default_value none
set_sw_setting_property stdout identifier none
set_sw_setting_property stdout description "Slave descriptor of STDOUT character-mode device. This setting is used by the ALT_STDOUT family of defines in system.h."
set_sw_setting_property stdout restrictions none
set_sw_setting_property stdout destination system_h_define
set_sw_setting_property stdout group common

add_sw_setting2 stderr unquoted_string
set_sw_setting_property stderr default_value none
set_sw_setting_property stderr identifier none
set_sw_setting_property stderr description "Slave descriptor of STDERR character-mode device. This setting is used by the ALT_STDERR family of defines in system.h."
set_sw_setting_property stderr restrictions none
set_sw_setting_property stderr destination system_h_define
set_sw_setting_property stderr group common

add_sw_setting2 log_port unquoted_string
set_sw_setting_property log_port default_value none
set_sw_setting_property log_port identifier none
set_sw_setting_property log_port description "Slave descriptor of debug logging character-mode device. If defined, it enables extra debug messages in the HAL source. This setting is used by the ALT_LOG_PORT family of defines in system.h."
set_sw_setting_property log_port restrictions none
set_sw_setting_property log_port destination public_mk_define
set_sw_setting_property log_port group none

#
# HAL Private Makefile Settings
#

add_sw_setting2 make.build_pre_process unquoted_string
set_sw_setting_property make.build_pre_process default_value none
set_sw_setting_property make.build_pre_process identifier BUILD_PRE_PROCESS
set_sw_setting_property make.build_pre_process description "Command executed before BSP built."
set_sw_setting_property make.build_pre_process restrictions none
set_sw_setting_property make.build_pre_process destination makefile_variable
set_sw_setting_property make.build_pre_process group none

add_sw_setting2 make.ar_pre_process unquoted_string
set_sw_setting_property make.ar_pre_process default_value none
set_sw_setting_property make.ar_pre_process identifier AR_PRE_PROCESS
set_sw_setting_property make.ar_pre_process description "Command executed before archiver execution."
set_sw_setting_property make.ar_pre_process restrictions none
set_sw_setting_property make.ar_pre_process destination makefile_variable
set_sw_setting_property make.ar_pre_process group none

add_sw_setting2 make.bsp_cflags_defined_symbols unquoted_string
set_sw_setting_property make.bsp_cflags_defined_symbols default_value none
set_sw_setting_property make.bsp_cflags_defined_symbols identifier BSP_CFLAGS_DEFINED_SYMBOLS
set_sw_setting_property make.bsp_cflags_defined_symbols description "Preprocessor macros to define. A macro definition in this setting has the same effect as a \"#define\" in source code. Adding \"-DALT_DEBUG\" to this setting has the same effect as \"#define ALT_DEBUG\" in a souce file. Adding \"-DFOO=1\" to this setting is equivalent to the macro \"#define FOO 1\" in a source file. Macros defined with this setting are applied to all .S, .c, and C++ files in the BSP. This setting defines the value of BSP_CFLAGS_DEFINED_SYMBOLS in the BSP Makefile."
set_sw_setting_property make.bsp_cflags_defined_symbols restrictions none
set_sw_setting_property make.bsp_cflags_defined_symbols destination makefile_variable
set_sw_setting_property make.bsp_cflags_defined_symbols group none

add_sw_setting2 make.ar_post_process unquoted_string
set_sw_setting_property make.ar_post_process default_value none
set_sw_setting_property make.ar_post_process identifier AR_POST_PROCESS
set_sw_setting_property make.ar_post_process description "Command executed after archiver execution."
set_sw_setting_property make.ar_post_process restrictions none
set_sw_setting_property make.ar_post_process destination makefile_variable
set_sw_setting_property make.ar_post_process group none

add_sw_setting2 make.as unquoted_string
set_sw_setting_property make.as default_value nios2-elf-gcc
set_sw_setting_property make.as identifier AS
set_sw_setting_property make.as description "Assembler command. Note that CC is used for .S files."
set_sw_setting_property make.as restrictions none
set_sw_setting_property make.as destination makefile_variable
set_sw_setting_property make.as group none

add_sw_setting2 make.build_post_process unquoted_string
set_sw_setting_property make.build_post_process default_value none
set_sw_setting_property make.build_post_process identifier BUILD_POST_PROCESS
set_sw_setting_property make.build_post_process description "Command executed after BSP built."
set_sw_setting_property make.build_post_process restrictions none
set_sw_setting_property make.build_post_process destination makefile_variable
set_sw_setting_property make.build_post_process group none

add_sw_setting2 make.bsp_cflags_debug unquoted_string
set_sw_setting_property make.bsp_cflags_debug default_value -g
set_sw_setting_property make.bsp_cflags_debug identifier BSP_CFLAGS_DEBUG
set_sw_setting_property make.bsp_cflags_debug description "C/C++ compiler debug level. '-g' provides the default set of debug symbols typically required to debug a typical application. Omitting '-g' removes debug symbols from the ELF. This setting defines the value of BSP_CFLAGS_DEBUG in Makefile."
set_sw_setting_property make.bsp_cflags_debug restrictions none
set_sw_setting_property make.bsp_cflags_debug destination makefile_variable
set_sw_setting_property make.bsp_cflags_debug group common

add_sw_setting2 make.ar unquoted_string
set_sw_setting_property make.ar default_value nios2-elf-ar
set_sw_setting_property make.ar identifier AR
set_sw_setting_property make.ar description "Archiver command. Creates library files."
set_sw_setting_property make.ar restrictions none
set_sw_setting_property make.ar destination makefile_variable
set_sw_setting_property make.ar group none

add_sw_setting2 make.rm unquoted_string
set_sw_setting_property make.rm default_value "rm -f"
set_sw_setting_property make.rm identifier RM
set_sw_setting_property make.rm description "Command used to remove files during 'clean' target."
set_sw_setting_property make.rm restrictions none
set_sw_setting_property make.rm destination makefile_variable
set_sw_setting_property make.rm group none

add_sw_setting2 make.cxx_pre_process unquoted_string
set_sw_setting_property make.cxx_pre_process default_value none
set_sw_setting_property make.cxx_pre_process identifier CXX_PRE_PROCESS
set_sw_setting_property make.cxx_pre_process description "Command executed before each C++ file is compiled."
set_sw_setting_property make.cxx_pre_process restrictions none
set_sw_setting_property make.cxx_pre_process destination makefile_variable
set_sw_setting_property make.cxx_pre_process group none

add_sw_setting2 make.bsp_cflags_warnings unquoted_string
set_sw_setting_property make.bsp_cflags_warnings default_value -Wall
set_sw_setting_property make.bsp_cflags_warnings identifier BSP_CFLAGS_WARNINGS
set_sw_setting_property make.bsp_cflags_warnings description "C/C++ compiler warning level. \"-Wall\" is commonly used.This setting defines the value of BSP_CFLAGS_WARNINGS in Makefile."
set_sw_setting_property make.bsp_cflags_warnings restrictions none
set_sw_setting_property make.bsp_cflags_warnings destination makefile_variable
set_sw_setting_property make.bsp_cflags_warnings group none   

add_sw_setting2 make.bsp_arflags unquoted_string
set_sw_setting_property make.bsp_arflags default_value -src
set_sw_setting_property make.bsp_arflags identifier BSP_ARFLAGS
set_sw_setting_property make.bsp_arflags description "Custom flags only passed to the archiver. This content of this variable is directly passed to the archiver rather than the more standard \"ARFLAGS\". The reason for this is that GNU Make assumes some default content in ARFLAGS. This setting defines the value of BSP_ARFLAGS in Makefile."
set_sw_setting_property make.bsp_arflags restrictions none
set_sw_setting_property make.bsp_arflags destination makefile_variable
set_sw_setting_property make.bsp_arflags group none    

add_sw_setting2 make.bsp_cflags_optimization unquoted_string
set_sw_setting_property make.bsp_cflags_optimization default_value -O0
set_sw_setting_property make.bsp_cflags_optimization identifier BSP_CFLAGS_OPTIMIZATION
set_sw_setting_property make.bsp_cflags_optimization description "C/C++ compiler optimization level. \"-O0\" = no optimization,\"-O2\" = \"normal\" optimization, etc. \"-O0\" is recommended for code that you want to debug since compiler optimization can remove variables and produce non-sequential execution of code while debugging. This setting defines the value of BSP_CFLAGS_OPTIMIZATION in Makefile."
set_sw_setting_property make.bsp_cflags_optimization restrictions none
set_sw_setting_property make.bsp_cflags_optimization destination makefile_variable
set_sw_setting_property make.bsp_cflags_optimization group common

add_sw_setting2 make.as_post_process unquoted_string
set_sw_setting_property make.as_post_process default_value none
set_sw_setting_property make.as_post_process identifier AS_POST_PROCESS
set_sw_setting_property make.as_post_process description "Command executed after each assembly file is compiled."
set_sw_setting_property make.as_post_process restrictions none
set_sw_setting_property make.as_post_process destination makefile_variable
set_sw_setting_property make.as_post_process group none

add_sw_setting2 make.cc_pre_process unquoted_string
set_sw_setting_property make.cc_pre_process default_value none
set_sw_setting_property make.cc_pre_process identifier CC_PRE_PROCESS
set_sw_setting_property make.cc_pre_process description "Command executed before each .c/.S file is compiled."
set_sw_setting_property make.cc_pre_process restrictions none
set_sw_setting_property make.cc_pre_process destination makefile_variable
set_sw_setting_property make.cc_pre_process group none
      
add_sw_setting2 make.bsp_asflags unquoted_string
set_sw_setting_property make.bsp_asflags default_value -Wa,-gdwarf2
set_sw_setting_property make.bsp_asflags identifier BSP_ASFLAGS
set_sw_setting_property make.bsp_asflags description "Custom flags only passed to the assembler. This setting defines the value of BSP_ASFLAGS in Makefile."
set_sw_setting_property make.bsp_asflags restrictions none
set_sw_setting_property make.bsp_asflags destination makefile_variable
set_sw_setting_property make.bsp_asflags group none
  
add_sw_setting2 make.as_pre_process unquoted_string
set_sw_setting_property make.as_pre_process default_value none
set_sw_setting_property make.as_pre_process identifier AS_PRE_PROCESS
set_sw_setting_property make.as_pre_process description "Command executed before each assembly file is compiled."
set_sw_setting_property make.as_pre_process restrictions none
set_sw_setting_property make.as_pre_process destination makefile_variable
set_sw_setting_property make.as_pre_process group none
  
add_sw_setting2 make.bsp_cflags_undefined_symbols unquoted_string
set_sw_setting_property make.bsp_cflags_undefined_symbols default_value none
set_sw_setting_property make.bsp_cflags_undefined_symbols identifier BSP_CFLAGS_UNDEFINED_SYMBOLS
set_sw_setting_property make.bsp_cflags_undefined_symbols description "Preprocessor macros to undefine. Undefined macros are similar to defined macros, but replicate the \"#undef\" directive in source code. To undefine the macro FOO use the syntax \"-u FOO\" in this setting. This is equivalent to \"#undef FOO\" in a source file. Note: the syntax differs from macro definition (there is a space, i.e. \"-u FOO\" versus \"-DFOO\"). Macros defined with this setting are applied to all .S, .c, and C++ files in the BSP. This setting defines the value of BSP_CFLAGS_UNDEFINED_SYMBOLS in the BSP Makefile."
set_sw_setting_property make.bsp_cflags_undefined_symbols restrictions none
set_sw_setting_property make.bsp_cflags_undefined_symbols destination makefile_variable
set_sw_setting_property make.bsp_cflags_undefined_symbols group none        

add_sw_setting2 make.cc_post_process unquoted_string
set_sw_setting_property make.cc_post_process default_value none
set_sw_setting_property make.cc_post_process identifier CC_POST_PROCESS
set_sw_setting_property make.cc_post_process description "Command executed after each .c/.S file is compiled."
set_sw_setting_property make.cc_post_process restrictions none
set_sw_setting_property make.cc_post_process destination makefile_variable
set_sw_setting_property make.cc_post_process group none

add_sw_setting2 make.cxx_post_process unquoted_string
set_sw_setting_property make.cxx_post_process default_value none
set_sw_setting_property make.cxx_post_process identifier CXX_POST_PROCESS
set_sw_setting_property make.cxx_post_process description "Command executed before each C++ file is compiled."
set_sw_setting_property make.cxx_post_process restrictions none
set_sw_setting_property make.cxx_post_process destination makefile_variable
set_sw_setting_property make.cxx_post_process group none

add_sw_setting2 make.cc unquoted_string
set_sw_setting_property make.cc default_value "nios2-elf-gcc -xc"
set_sw_setting_property make.cc identifier CC
set_sw_setting_property make.cc description "C compiler command."
set_sw_setting_property make.cc restrictions none
set_sw_setting_property make.cc destination makefile_variable
set_sw_setting_property make.cc group none

add_sw_setting2 make.bsp_cxx_flags unquoted_string
set_sw_setting_property make.bsp_cxx_flags default_value none
set_sw_setting_property make.bsp_cxx_flags identifier BSP_CXXFLAGS
set_sw_setting_property make.bsp_cxx_flags description "Custom flags only passed to the C++ compiler. This setting defines the value of BSP_CXXFLAGS in Makefile."
set_sw_setting_property make.bsp_cxx_flags restrictions none
set_sw_setting_property make.bsp_cxx_flags destination makefile_variable
set_sw_setting_property make.bsp_cxx_flags group none

add_sw_setting2 make.bsp_inc_dirs unquoted_string
set_sw_setting_property make.bsp_inc_dirs default_value none
set_sw_setting_property make.bsp_inc_dirs identifier BSP_INC_DIRS
set_sw_setting_property make.bsp_inc_dirs description "Space separated list of extra include directories to scan for header files. Directories are relative to the top-level BSP directory. The -I prefix's added by the makefile so don't add it here. This setting defines the value of BSP_INC_DIRS in Makefile."
set_sw_setting_property make.bsp_inc_dirs restrictions none
set_sw_setting_property make.bsp_inc_dirs destination makefile_variable
set_sw_setting_property make.bsp_inc_dirs group none

add_sw_setting2 make.cxx unquoted_string
set_sw_setting_property make.cxx default_value "nios2-elf-gcc -xc++"
set_sw_setting_property make.cxx identifier CXX
set_sw_setting_property make.cxx description "C++ compiler command."
set_sw_setting_property make.cxx restrictions none
set_sw_setting_property make.cxx destination makefile_variable
set_sw_setting_property make.cxx group none

add_sw_setting2 make.bsp_cflags_user_flags unquoted_string
set_sw_setting_property make.bsp_cflags_user_flags default_value none
set_sw_setting_property make.bsp_cflags_user_flags identifier BSP_CFLAGS_USER_FLAGS
set_sw_setting_property make.bsp_cflags_user_flags description "Custom flags passed to the compiler when compiling C, C++, and .S files. This setting defines the value of BSP_CFLAGS_USER_FLAGS in Makefile."
set_sw_setting_property make.bsp_cflags_user_flags restrictions none
set_sw_setting_property make.bsp_cflags_user_flags destination makefile_variable
set_sw_setting_property make.bsp_cflags_user_flags group none

#
# HAL Public Makefile Settings
#

add_sw_setting2 make.ignore_system_derived.sopc_system_id boolean
set_sw_setting_property make.ignore_system_derived.sopc_system_id default_value false
set_sw_setting_property make.ignore_system_derived.sopc_system_id identifier none
set_sw_setting_property make.ignore_system_derived.sopc_system_id description "Enable BSP generation to query SOPC system for system ID. If true ignores export of 'SOPC_SYSID_FLAG += --id=<sysid>' and 'ELF_PATCH_FLAG  += --id=<sysid>' to public.mk."
set_sw_setting_property make.ignore_system_derived.sopc_system_id restrictions none
set_sw_setting_property make.ignore_system_derived.sopc_system_id destination public_mk_define
set_sw_setting_property make.ignore_system_derived.sopc_system_id group none

add_sw_setting2 make.ignore_system_derived.sopc_system_timestamp boolean
set_sw_setting_property make.ignore_system_derived.sopc_system_timestamp default_value false
set_sw_setting_property make.ignore_system_derived.sopc_system_timestamp identifier none
set_sw_setting_property make.ignore_system_derived.sopc_system_timestamp description "Enable BSP generation to query SOPC system for system timestamp. If true ignores export of 'SOPC_SYSID_FLAG += --timestamp=<timestamp>' and 'ELF_PATCH_FLAG  += --timestamp=<timestamp>' to public.mk."
set_sw_setting_property make.ignore_system_derived.sopc_system_timestamp restrictions none
set_sw_setting_property make.ignore_system_derived.sopc_system_timestamp destination public_mk_define
set_sw_setting_property make.ignore_system_derived.sopc_system_timestamp group none

add_sw_setting2 make.ignore_system_derived.sopc_system_base_address boolean
set_sw_setting_property make.ignore_system_derived.sopc_system_base_address default_value false
set_sw_setting_property make.ignore_system_derived.sopc_system_base_address identifier none
set_sw_setting_property make.ignore_system_derived.sopc_system_base_address description "Enable BSP generation to query SOPC system for system ID base address. If true ignores export of 'SOPC_SYSID_FLAG += --sidp=<address>' and 'ELF_PATCH_FLAG  += --sidp=<address>' to public.mk."
set_sw_setting_property make.ignore_system_derived.sopc_system_base_address restrictions none
set_sw_setting_property make.ignore_system_derived.sopc_system_base_address destination public_mk_define
set_sw_setting_property make.ignore_system_derived.sopc_system_base_address group none

add_sw_setting2 make.ignore_system_derived.sopc_simulation_enabled boolean
set_sw_setting_property make.ignore_system_derived.sopc_simulation_enabled default_value false
set_sw_setting_property make.ignore_system_derived.sopc_simulation_enabled identifier none
set_sw_setting_property make.ignore_system_derived.sopc_simulation_enabled description "Enable BSP generation to query if SOPC system has simulation enabled. If true ignores export of 'ELF_PATCH_FLAG  += --simulation_enabled' to public.mk."
set_sw_setting_property make.ignore_system_derived.sopc_simulation_enabled restrictions none
set_sw_setting_property make.ignore_system_derived.sopc_simulation_enabled destination public_mk_define
set_sw_setting_property make.ignore_system_derived.sopc_simulation_enabled group none

add_sw_setting2 make.ignore_system_derived.fpu_present boolean
set_sw_setting_property make.ignore_system_derived.fpu_present default_value false
set_sw_setting_property make.ignore_system_derived.fpu_present identifier none
set_sw_setting_property make.ignore_system_derived.fpu_present description "Enable BSP generation to query if SOPC system has FPU present. If true ignores export of 'ALT_CFLAGS += -mhard-float' to public.mk if FPU is found in the system. If true ignores export of 'ALT_CFLAGS += -mhard-soft' if FPU is not found in the system."
set_sw_setting_property make.ignore_system_derived.fpu_present restrictions none
set_sw_setting_property make.ignore_system_derived.fpu_present destination public_mk_define
set_sw_setting_property make.ignore_system_derived.fpu_present group none

add_sw_setting2 make.ignore_system_derived.hardware_multiplier_present boolean
set_sw_setting_property make.ignore_system_derived.hardware_multiplier_present default_value false
set_sw_setting_property make.ignore_system_derived.hardware_multiplier_present identifier none
set_sw_setting_property make.ignore_system_derived.hardware_multiplier_present description "Enable BSP generation to query if SOPC system has multiplier present. If true ignores export of 'ALT_CFLAGS += -mno-hw-mul' to public.mk if no multiplier is found in the system. If true ignores export of 'ALT_CFLAGS += -mhw-mul' if multiplier is found in the system."
set_sw_setting_property make.ignore_system_derived.hardware_multiplier_present restrictions none
set_sw_setting_property make.ignore_system_derived.hardware_multiplier_present destination public_mk_define
set_sw_setting_property make.ignore_system_derived.hardware_multiplier_present group none

add_sw_setting2 make.ignore_system_derived.hardware_mulx_present boolean
set_sw_setting_property make.ignore_system_derived.hardware_mulx_present default_value false
set_sw_setting_property make.ignore_system_derived.hardware_mulx_present identifier none
set_sw_setting_property make.ignore_system_derived.hardware_mulx_present description "Enable BSP generation to query if SOPC system has hardware mulx present. If true ignores export of 'ALT_CFLAGS += -mno-hw-mulx' to public.mk if no mulx is found in the system. If true ignores export of 'ALT_CFLAGS += -mhw-mulx' if mulx is found in the system."
set_sw_setting_property make.ignore_system_derived.hardware_mulx_present restrictions none
set_sw_setting_property make.ignore_system_derived.hardware_mulx_present destination public_mk_define
set_sw_setting_property make.ignore_system_derived.hardware_mulx_present group none

add_sw_setting2 make.ignore_system_derived.hardware_divide_present boolean
set_sw_setting_property make.ignore_system_derived.hardware_divide_present default_value false
set_sw_setting_property make.ignore_system_derived.hardware_divide_present identifier none
set_sw_setting_property make.ignore_system_derived.hardware_divide_present description "Enable BSP generation to query if SOPC system has hardware divide present. If true ignores export of 'ALT_CFLAGS += -mno-hw-div' to public.mk if no division is found in system. If true ignores export of 'ALT_CFLAGS += -mhw-div' if division is found in the system."
set_sw_setting_property make.ignore_system_derived.hardware_divide_present restrictions none
set_sw_setting_property make.ignore_system_derived.hardware_divide_present destination public_mk_define
set_sw_setting_property make.ignore_system_derived.hardware_divide_present group none

add_sw_setting2 make.ignore_system_derived.debug_core_present boolean
set_sw_setting_property make.ignore_system_derived.debug_core_present default_value false
set_sw_setting_property make.ignore_system_derived.debug_core_present identifier none
set_sw_setting_property make.ignore_system_derived.debug_core_present description "Enable BSP generation to query if SOPC system has a debug core present. If true ignores export of 'CPU_HAS_DEBUG_CORE = 1' to public.mk if a debug core is found in the system. If true ignores export of 'CPU_HAS_DEBUG_CORE = 0' if no debug core is found in the system."
set_sw_setting_property make.ignore_system_derived.debug_core_present restrictions none
set_sw_setting_property make.ignore_system_derived.debug_core_present destination public_mk_define
set_sw_setting_property make.ignore_system_derived.debug_core_present group none

add_sw_setting2 make.ignore_system_derived.big_endian boolean
set_sw_setting_property make.ignore_system_derived.big_endian default_value false
set_sw_setting_property make.ignore_system_derived.big_endian identifier none
set_sw_setting_property make.ignore_system_derived.big_endian description "Enable BSP generation to query if SOPC system is big endian. If true ignores export of 'ALT_CFLAGS += -EB' to public.mk if big endian system. If true ignores export of 'ALT_CFLAGS += -EL' if little endian system."
set_sw_setting_property make.ignore_system_derived.big_endian restrictions none
set_sw_setting_property make.ignore_system_derived.big_endian destination public_mk_define
set_sw_setting_property make.ignore_system_derived.big_endian group none

add_sw_setting2 make.ignore_system_derived.hardware_fp_cust_inst_divider_present boolean
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_divider_present default_value false
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_divider_present identifier none
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_divider_present description "Enable BSP generation to query if SOPC system floating point custom instruction with a divider is present. If true ignores export of 'ALT_CFLAGS += -mcustom-fpu-cfg=60-2' and 'ALT_LDFLAGS += -mcustom-fpu-cfg=60-2' to public.mk if the custom instruction is found in the system."
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_divider_present restrictions none
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_divider_present destination public_mk_define
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_divider_present group none

add_sw_setting2 make.ignore_system_derived.hardware_fp_cust_inst_no_divider_present boolean
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_no_divider_present default_value false
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_no_divider_present identifier none
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_no_divider_present description "Enable BSP generation to query if SOPC system floating point custom instruction without a divider is present. If true ignores export of 'ALT_CFLAGS += -mcustom-fpu-cfg=60-1' and 'ALT_LDFLAGS += -mcustom-fpu-cfg=60-1' to public.mk if the custom instruction is found in the system."
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_no_divider_present restrictions none
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_no_divider_present destination public_mk_define
set_sw_setting_property make.ignore_system_derived.hardware_fp_cust_inst_no_divider_present group none

add_sw_setting2 enable_exit boolean
set_sw_setting_property enable_exit default_value true
set_sw_setting_property enable_exit identifier ALT_NO_EXIT
set_sw_setting_property enable_exit description "Add exit() support. This option increases code footprint if your \"main()\" routine does \"return\" or call \"exit()\". If false, adds -DALT_NO_EXIT to ALT_CPPFLAGS in public.mk, and reduces footprint"
set_sw_setting_property enable_exit restrictions none
set_sw_setting_property enable_exit destination public_mk_define
set_sw_setting_property enable_exit group none

add_sw_setting2 enable_small_c_library boolean
set_sw_setting_property enable_small_c_library default_value false
set_sw_setting_property enable_small_c_library identifier none
set_sw_setting_property enable_small_c_library description "Causes the small newlib (C library) to be used. This reduces code and data footprint at the expense of reduced functionality. Several newlib features are removed such as floating-point support in printf(), stdin input routines, and buffered I/O. The small C library is not compatible with Micrium MicroC/OS-II. If true, adds -msmallc to ALT_LDFLAGS in public.mk."
set_sw_setting_property enable_small_c_library restrictions none
set_sw_setting_property enable_small_c_library destination public_mk_define
set_sw_setting_property enable_small_c_library group common

add_sw_setting2 enable_clean_exit boolean
set_sw_setting_property enable_clean_exit default_value true
set_sw_setting_property enable_clean_exit identifier ALT_NO_CLEAN_EXIT
set_sw_setting_property enable_clean_exit description "When your application exits, close file descriptors, call C++ destructors, etc. Code footprint can be reduced by disabling clean exit. If disabled, adds -DALT_NO_CLEAN_EXIT to ALT_CPPFLAGS and -Wl,--defsym, exit=_exit to ALT_LDFLAGS in public.mk."
set_sw_setting_property enable_clean_exit restrictions none
set_sw_setting_property enable_clean_exit destination public_mk_define
set_sw_setting_property enable_clean_exit group none

add_sw_setting2 enable_runtime_stack_checking boolean
set_sw_setting_property enable_runtime_stack_checking default_value false
set_sw_setting_property enable_runtime_stack_checking identifier ALT_STACK_CHECK
set_sw_setting_property enable_runtime_stack_checking description "Turns on HAL runtime stack checking feature. Enabling this setting causes additional code to be placed into each subroutine call to generate an exception if a stack collision occurs with the heap or statically allocated data. If true, adds -DALT_STACK_CHECK and -mstack-check to ALT_CPPFLAGS in public.mk."
set_sw_setting_property enable_runtime_stack_checking restrictions none
set_sw_setting_property enable_runtime_stack_checking destination public_mk_define
set_sw_setting_property enable_runtime_stack_checking group none

add_sw_setting2 enable_gprof boolean
set_sw_setting_property enable_gprof default_value false
set_sw_setting_property enable_gprof identifier ALT_PROVIDE_GMON
set_sw_setting_property enable_gprof description "Causes code to be compiled with gprof profiling enabled and the application ELF to be linked with the GPROF library. If true, adds -DALT_PROVIDE_GMON to ALT_CPPFLAGS and -pg to ALT_CFLAGS in public.mk."
set_sw_setting_property enable_gprof restrictions none
set_sw_setting_property enable_gprof destination public_mk_define
set_sw_setting_property enable_gprof group common

add_sw_setting2 enable_c_plus_plus boolean
set_sw_setting_property enable_c_plus_plus default_value true
set_sw_setting_property enable_c_plus_plus identifier ALT_NO_C_PLUS_PLUS
set_sw_setting_property enable_c_plus_plus description "Enable support for a subset of the C++ language. This option increases code footprint by adding support for C++ constructors. Certain features, such as multiple inheritance and exceptions are not supported. If false, adds -DALT_NO_C_PLUS_PLUS to ALT_CPPFLAGS in public.mk, and reduces code footprint."
set_sw_setting_property enable_c_plus_plus restrictions none
set_sw_setting_property enable_c_plus_plus destination public_mk_define
set_sw_setting_property enable_c_plus_plus group none

add_sw_setting2 enable_reduced_device_drivers boolean
set_sw_setting_property enable_reduced_device_drivers default_value false
set_sw_setting_property enable_reduced_device_drivers identifier ALT_USE_SMALL_DRIVERS
set_sw_setting_property enable_reduced_device_drivers description "Certain drivers are compiled with reduced functionality to reduce code footprint. Not all drivers observe this setting. The altera_avalon_uart and altera_avalon_jtag_uart drivers switch from interrupt-driven to polled operation. CAUTION: Several device drivers are disabled entirely. These include the altera_avalon_cfi_flash, altera_avalon_epcs_flash_controller, and altera_avalon_lcd_16207 drivers. This can result in certain API (HAL flash access routines) to fail. You can define a symbol provided by each driver to prevent it from being removed. If true, adds -DALT_USE_SMALL_DRIVERS to ALT_CPPFLAGS in public.mk."
set_sw_setting_property enable_reduced_device_drivers restrictions none
set_sw_setting_property enable_reduced_device_drivers destination public_mk_define
set_sw_setting_property enable_reduced_device_drivers group common

add_sw_setting2 enable_lightweight_device_driver_api boolean
set_sw_setting_property enable_lightweight_device_driver_api default_value false
set_sw_setting_property enable_lightweight_device_driver_api identifier ALT_USE_DIRECT_DRIVERS
set_sw_setting_property enable_lightweight_device_driver_api description "Enables lightweight device driver API. This reduces code and data footprint by removing the HAL layer that maps device names (e.g. /dev/uart0) to file descriptors. Instead, driver routines are called directly. The open(), close(), and lseek() routines will always fail if called. The read(), write(), fstat(), ioctl(), and isatty() routines only work for the stdio devices. If true, adds -DALT_USE_DIRECT_DRIVERS to ALT_CPPFLAGS in public.mk."
set_sw_setting_property enable_lightweight_device_driver_api restrictions "The Altera Host and read-only ZIP file systems can't be used if hal.enable_lightweight_device_driver_api is true."
set_sw_setting_property enable_lightweight_device_driver_api destination public_mk_define
set_sw_setting_property enable_lightweight_device_driver_api group none

add_sw_setting2 enable_mul_div_emulation boolean
set_sw_setting_property enable_mul_div_emulation default_value false
set_sw_setting_property enable_mul_div_emulation identifier ALT_NO_INSTRUCTION_EMULATION
set_sw_setting_property enable_mul_div_emulation description "Adds code to emulate multiply and divide instructions in case they are executed but aren't present in the CPU. Normally this isn't required because the compiler won't use multiply and divide instructions that aren't present in the CPU. If false, adds -DALT_NO_INSTRUCTION_EMULATION to ALT_CPPFLAGS in public.mk."
set_sw_setting_property enable_mul_div_emulation restrictions none
set_sw_setting_property enable_mul_div_emulation destination public_mk_define
set_sw_setting_property enable_mul_div_emulation group none

add_sw_setting2 enable_sim_optimize boolean
set_sw_setting_property enable_sim_optimize default_value false
set_sw_setting_property enable_sim_optimize identifier ALT_SIM_OPTIMIZE
set_sw_setting_property enable_sim_optimize description "The BSP is compiled with optimizations to speedup HDL simulation such as initializing the cache, clearing the .bss section, and skipping long delay loops. If true, adds -DALT_SIM_OPTIMIZE to ALT_CPPFLAGS in public.mk."
set_sw_setting_property enable_sim_optimize restrictions "When this setting is true, the BSP shouldn't be used to build applications that are expected to run real hardware."
set_sw_setting_property enable_sim_optimize destination public_mk_define
set_sw_setting_property enable_sim_optimize group common

add_sw_setting2 enable_sopc_sysid_check boolean
set_sw_setting_property enable_sopc_sysid_check default_value true
set_sw_setting_property enable_sopc_sysid_check identifier none
set_sw_setting_property enable_sopc_sysid_check description "Enable SOPC Builder System ID. If a System ID SOPC Builder component is connected to the CPU associated with this BSP, it will be enabled in the creation of command-line arguments to download an ELF to the target. Otherwise, system ID and timestamp values are left out of public.mk for application Makefile \"download-elf\" target definition. With the system ID check disabled, the Nios II EDS tools will not automatically ensure that the application .elf file (and BSP it is linked against) corresponds to the hardware design on the target. If false, adds --accept-bad-sysid to SOPC_SYSID_FLAG in public.mk."
set_sw_setting_property enable_sopc_sysid_check restrictions none
set_sw_setting_property enable_sopc_sysid_check destination public_mk_define
set_sw_setting_property enable_sopc_sysid_check group none

add_sw_setting2 custom_newlib_flags unquoted_string
set_sw_setting_property custom_newlib_flags default_value none
set_sw_setting_property custom_newlib_flags identifier CUSTOM_NEWLIB_FLAGS
set_sw_setting_property custom_newlib_flags description "Build a custom version of newlib with the specified space-separated compiler flags."
set_sw_setting_property custom_newlib_flags restrictions "The custom newlib build will be placed in the &lt;bsp root>/newlib directory, and will be used only for applications that utilize this BSP."
set_sw_setting_property custom_newlib_flags destination public_mk_define
set_sw_setting_property custom_newlib_flags group none

add_sw_setting2 log_flags decimal_number
set_sw_setting_property log_flags default_value 0
set_sw_setting_property log_flags identifier ALT_LOG_FLAGS
set_sw_setting_property log_flags description "The value is assigned to ALT_LOG_FLAGS in the generated public.mk. See hal.log_port setting description. Values can be -1 through 3."
set_sw_setting_property log_flags restrictions "hal.log_port must be set for this to be used."
set_sw_setting_property log_flags destination public_mk_define
set_sw_setting_property log_flags group none

# End of file
