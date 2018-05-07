# *******************************************************************************
# *                                                                             *
# * License Agreement                                                           *
# *                                                                             *
# * Copyright (c) 2003 Altera Corporation, San Jose, California, USA.           *
# * All rights reserved.                                                        *
# *                                                                             *
# * Permission is hereby granted, free of charge, to any person obtaining a     *
# * copy of this software and associated documentation files (the "Software"),  *
# * to deal in the Software without restriction, including without limitation   *
# * the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
# * and/or sell copies of the Software, and to permit persons to whom the       *
# * Software is furnished to do so, subject to the following conditions:        *
# *                                                                             *
# * The above copyright notice and this permission notice shall be included in  *
# * all copies or substantial portions of the Software.                         *
# *                                                                             *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
# * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
# * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
# * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
# * DEALINGS IN THE SOFTWARE.                                                   *
# *                                                                             *
# * This agreement shall be governed in all respects by the laws of the State   *
# * of California and by the laws of the United States of America.              *
# *                                                                             *
# * Altera does not recommend, suggest or require that this reference design    *
# * file be used in conjunction or combination with any other product.          *
# *******************************************************************************

# List all source files supplied by this component.

C_LIB_SRCS   += altera_ro_zipfs.c

ASM_LIB_SRCS +=

INCLUDE_PATH +=


CPPFLAGS += -DRO_ZIPFS

ifeq ($(PROJ_TYPE),system)

all: filesys.flash
        
filesys.flash: altera_ro_zip_file_ok 
	@echo Building flash file system
	bin2flash --flash=$(ALTERA_RO_ZIPFS_DESIGNATOR) \
    --input=$(SYSTEM_DIR)/$(ALTERA_RO_ZIPFS_ZIP_NAME) --base=$(ALTERA_RO_ZIPFS_BASE) \
    --location=$(ALTERA_RO_ZIPFS_OFFSET) --output=$@

altera_ro_zip_file_ok: $(ALTERA_RO_ZIPFS_ZIP_NAME) $(STF) $(MAKEFILE_LIST)
	@echo Checking that the Zip file $(notdir $<) is not compressed
	validate_zip $<
	@echo This is an auto-generated timestamp file. > $@

clean: remove_altera_ro_zip_file_ok remove_flash_file

remove_altera_ro_zip_file_ok:
	$(RM) altera_ro_zip_file_ok

remove_flash_file:
	$(RM) filesys.flash

else

programflash: programfilesystem

programfilesystem: $(SYSTEM_DIR)/$(SYS_CONFIG)/filesys.flash
	@echo Programming the filing system $(notdir $<) into flash 
	nios2-flash-programmer $(JTAG_CABLE) \
    $(if $(JTAG_DEVICE),--device=$(JTAG_DEVICE),) \
    --input=$< \
    --sof=$(FLASH_PROGRAMMER_SOF) \
    --base=$(ROZIPFS_DEVICE_BASE_IN_FLASH_PROGRAMMER_SYSTEM) 

endif

.PHONY: remove_altera_ro_zip_file_ok programfilesystem remove_flash_file


