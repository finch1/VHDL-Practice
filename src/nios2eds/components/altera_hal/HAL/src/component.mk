#******************************************************************************
#                                                                             *
# License Agreement                                                           *
#                                                                             *
# Copyright (c) 2004 Altera Corporation, San Jose, California, USA.           *
# All rights reserved.                                                        *
#                                                                             *
# Permission is hereby granted, free of charge, to any person obtaining a     *
# copy of this software and associated documentation files (the "Software"),  *
# to deal in the Software without restriction, including without limitation   *
# the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
# and/or sell copies of the Software, and to permit persons to whom the       *
# Software is furnished to do so, subject to the following conditions:        *
#                                                                             *
# The above copyright notice and this permission notice shall be included in  *
# all copies or substantial portions of the Software.                         *
#                                                                             *
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
# DEALINGS IN THE SOFTWARE.                                                   *
#                                                                             *
# This agreement shall be governed in all respects by the laws of the State   *
# of California and by the laws of the United States of America.              *
#                                                                             *
# Altera does not recommend, suggest or require that this reference design    *
# file be used in conjunction or combination with any other product.          *
#******************************************************************************

#******************************************************************************
#                                                                             *
# THIS IS A LIBRARY READ-ONLY SOURCE FILE. DO NOT EDIT.                       *
#                                                                             *
#******************************************************************************

# List all source files supplied by this component.

C_LIB_SRCS   += alt_tick.c \
                alt_alarm_start.c \
                alt_flash_dev.c \
                alt_irq_handler.c \
                alt_irq_register.c \
                alt_dma_rxchan_open.c \
                alt_dma_txchan_open.c \
                alt_main.c \
                alt_errno.c \
                alt_environ.c \
                alt_execve.c \
                alt_exit.c \
                alt_fcntl.c \
                alt_fork.c \
                alt_getpid.c \
                alt_gettod.c \
                alt_settod.c \
                alt_kill.c \
                alt_link.c \
                alt_rename.c \
                alt_sbrk.c \
                alt_stat.c \
                alt_times.c \
                alt_unlink.c \
                alt_wait.c \
                alt_malloc_lock.c \
                alt_env_lock.c \
                alt_load.c \
                alt_log_printf.c \
                alt_read.c \
                alt_write.c \
                alt_fstat.c \
                alt_ioctl.c \
                alt_isatty.c \
                alt_printf.c \
                alt_getchar.c \
                alt_putchar.c \
                alt_putstr.c \
                alt_dev.c \
                alt_dev_llist_insert.c \
                alt_fd_lock.c \
                alt_fd_unlock.c \
                alt_find_dev.c \
                alt_find_file.c \
                alt_fs_reg.c \
                alt_get_fd.c \
                alt_io_redirect.c \
                alt_lseek.c \
                alt_release_fd.c \
                alt_open.c \
                alt_close.c \
                alt_instruction_exception_register.c \

ASM_LIB_SRCS +=

INCLUDE_PATH +=
