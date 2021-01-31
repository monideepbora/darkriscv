# Copyright (c) 2018, Marcelo Samsoniuk
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# 
# * Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 


ifndef ARCH
ARCH = RV32I
endif

RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /usr/local/riscv-unknown-elf
TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)/bin/riscv-unknown-elf-
#RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv32
#TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)/bin/riscv32-unknown-elf-

# default test vars for RV32I
ifeq ($(ARCH),RV32I)
TEST_OBJS_DEFAULT = $(addsuffix .o,$(basename $(wildcard tests/$(ARCH)/*.S)))
TEST_DIR_TARGET = tests/$(ARCH)/
GCC_FLAGS = -UMUL
MABI = ilp32
MARCH = rv32i
endif

# default test vars for RV32E
ifeq ($(ARCH),RV32E)
TEST_OBJS_DEFAULT = $(addsuffix .o,$(basename $(wildcard tests/$(ARCH)/*.S)))
TEST_DIR_TARGET = tests/$(ARCH)/
GCC_FLAGS = -UMUL -DABI_ILP32E
MABI = ilp32e
MARCH = rv32e
endif

BUILD = $(shell date -R)


    CC = $(TOOLCHAIN_PREFIX)gcc
    AS = $(TOOLCHAIN_PREFIX)as
    LD = $(TOOLCHAIN_PREFIX)ld
    OC = $(TOOLCHAIN_PREFIX)objcopy
    OD = $(TOOLCHAIN_PREFIX)objdump
  
CCFLAGS = -Wall -fcommon -I./include -Os -march=$(MARCH) -mabi=$(MABI) -D__RISCV__ -DBUILD="\"$(BUILD)\"" -DARCH="\"$(ARCH)\"" -DRTL=$(RTL)
ASFLAGS = -march=$(MARCH) -mabi=$(MABI)
LDFLAGS = -march=$(MARCH) -mabi=$(MABI) -T$(PROJ).ld -Map=$(PROJ).map -m elf32lriscv
OCFLAGS = -O binary
ODFLAGS = -d

PROJ = darksocv
OBJS = boot.o stdio.o main.o io.o banner.o tests/start.o $(TEST_OBJS_DEFAULT)
ASMS = boot.s stdio.s main.s io.s banner.s 
SRCS = boot.c stdio.c main.c io.c banner.c


DEPS = $(SRCS) $(ASMS) $(OBJS) $(PROJ).ld 

.PHONY: all

all: $(PROJ).mem $(DEPS)
	@echo sources ok.

clean:
	-rm *.o *.s $(PROJ).mem $(PROJ).o $(PROJ).map $(PROJ).lst
	-rm -r tests/RV32I/*.o tests/RV32E/*.o
	-rm tests/start.o

%.o: %.s
	$(AS) $(ASFLAGS) -c $< -o $@

%.s: %.c
	$(CC) $(CCFLAGS) -S $< -o $@

tests/start.o: tests/start.S
	$(TOOLCHAIN_PREFIX)gcc -c -march=${MARCH} -mabi=${MABI} -o $@ $(GCC_FLAGS) $<


$(addsuffix %.o,$(basename $(TEST_DIR_TARGET))): $(addsuffix %.S,$(basename $(TEST_DIR_TARGET))) tests/$(ARCH)/riscv_test.h tests/$(ARCH)/test_macros.h
	$(TOOLCHAIN_PREFIX)gcc -fcommon -c -march=${MARCH} -mabi=${MABI} -o $@ -DTEST_FUNC_NAME=$(notdir $(basename $<)) \
		-DTEST_FUNC_TXT='"$(notdir $(basename $<))"' -DTEST_FUNC_RET=$(notdir $(basename $<))_ret $<


$(PROJ).o: $(OBJS) $(PROJ).ld
	$(LD) $(LDFLAGS) -Os $(OBJS) -o $@
	$(OD) $(ODFLAGS) $@ > $(PROJ).lst


$(PROJ).mem: $(PROJ).o
	$(OC) $(OCFLAGS) $< $(PROJ).bin
	hexdump -ve '1/4 "%08x\n"' $(PROJ).bin > $@
	#xxd -p -c 4 -g 4 $< > $@
	rm $(PROJ).bin
	wc -l $@
	@echo mem ok.
	
