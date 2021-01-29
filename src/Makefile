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

ifndef HOST_CC
    HOST_CC = gcc
    HOST_CFLAGS = -Wall -Wno-incompatible-library-redeclaration -I./include -Os
endif

ifndef CROSS

    #ARCH = rv32e
    ARCH = rv32i
    
    #TODO: better way to switch little/big-endian:
    #ENDIAN = _le # gcc for little-endian
    #ENDIAN = _be # gcc for big-endian

    #CROSS = riscv32-embedded$(ENDIAN)-elf
    #CROSS = riscv-elf
    CROSS = riscv32-unknown-elf
    #CROSS = riscv32-embedded-elf
    
    CCPATH = /opt/riscv32/bin
    #CCPATH = /usr/local/share/toolchain-$(CROSS)/bin
    #HARVARD = 
	
	ARCHI = RV32I
	TEST_DIR_TARGET = tests/$(ARCHI)/
	MARCH=rv32i
	MABI=ilp32

	RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv32

	GCC_FLAGS = -UMUL
	INTEGER_INST = 1

	TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)/bin/riscv32-unknown-elf-

endif

ifndef BUILD
    BUILD = $(shell date -R)
endif

    CC = $(CCPATH)/$(CROSS)-gcc
    AS = $(CCPATH)/$(CROSS)-as
    LD = $(CCPATH)/$(CROSS)-ld
    OC = $(CCPATH)/$(CROSS)-objcopy
    OD = $(CCPATH)/$(CROSS)-objdump
   CPP = $(CCPATH)/$(CROSS)-cpp

CCFLAGS = -Wall -fcommon -I./include -Os -march=$(ARCH) -mabi=ilp32 -D__RISCV__ -DBUILD="\"$(BUILD)\"" -DARCH="\"$(ARCH)\""
ASFLAGS = -march=$(ARCH)
LDFLAGS = -T$(PROJ).ld -Map=$(PROJ).map -m elf32lriscv # -Ttext=0
CPFLAGS = -P 

#CCFLAGS += -mcmodel=medany -mexplicit-relocs # relocable clode

ifdef HARVARD
	CPFLAGS +=  -DHARVARD=1
endif

OCFLAGS = -O binary # --reverse-bytes=4 # workaround for darkriscv big-endian blockrams
ODFLAGS = -d

PROJ = darksocv
OBJS = boot.o stdio.o main.o io.o banner.o tests/start.o  tests/RV32I/lui.o #$(addsuffix .o,$(basename $(wildcard tests/$(ARCHI)/*.S)))
ASMS = boot.s stdio.s main.s io.s banner.s #tests/start.S #$(basename $(wildcard tests/$(ARCHI)/*.S))
SRCS = boot.c stdio.c main.c io.c banner.c

#include app/Makefile.in

DEPS = $(SRCS) $(ASMS) $(OBJS) $(PROJ).ld $(PROJ).ld.src

ifdef HARVARD
	TARGETS = $(PROJ).rom.mem $(PROJ).ram.mem
else
	TARGETS = $(PROJ).mem
endif

.PHONY: all

all: $(TARGETS) $(DEPS)
	echo sources ok.

clean:
	-rm *.o main.s boot.s banner.s io.s stdio.s darksocv.mem $(PROJ).{bin,lst,map,ram,rom,x86,text,data,bin,ld}
	rm -r tests/RV32I/*.o
	rm tests/start.o

%.o: %.s
	$(AS) $(ASFLAGS) -c $< -o $@

tests/start.o: tests/start.S
	$(TOOLCHAIN_PREFIX)gcc -c -march=${MARCH} -mabi=${MABI} -o $@ $(GCC_FLAGS) $<


$(addsuffix %.o,$(basename $(TEST_DIR_TARGET))): $(addsuffix %.S,$(basename $(TEST_DIR_TARGET))) tests/$(ARCHI)/riscv_test.h tests/$(ARCHI)/test_macros.h
	$(TOOLCHAIN_PREFIX)gcc -fcommon -c -march=${MARCH} -mabi=${MABI} -o $@ -DTEST_FUNC_NAME=$(notdir $(basename $<)) \
		-DTEST_FUNC_TXT='"$(notdir $(basename $<))"' -DTEST_FUNC_RET=$(notdir $(basename $<))_ret $<






%.s: %.c
	$(CC) $(CCFLAGS) -S $< -o $@

$(PROJ).ld: $(PROJ).ld.src
	$(CPP) $(CPFLAGS) $(PROJ).ld.src $(PROJ).ld
	
$(PROJ).o: $(OBJS) $(PROJ).ld
	$(LD) $(LDFLAGS) -Os $(OBJS) -o $@
	$(OD) $(ODFLAGS) $@ > $(PROJ).lst



$(PROJ).rom.mem: $(PROJ).o
	$(OC) $(OCFLAGS) $< $(PROJ).text --only-section .text* 
	hexdump -ve '1/4 "%08x\n"' $(PROJ).text > $@
	#xxd -p -c 4 -g 4 $< > $@
	rm $(PROJ).text
	wc -l $@
	echo rom ok.

$(PROJ).ram.mem: $(PROJ).o
	$(OC) $(OCFLAGS) $< $(PROJ).data --only-section .*data*
	hexdump -ve '1/4 "%08x\n"' $(PROJ).data > $@
	#xxd -p -c 4 -g 4 $< > $@
	rm $(PROJ).data
	wc -l $@
	echo ram ok.

$(PROJ).mem: $(PROJ).o
	$(OC) $(OCFLAGS) $< $(PROJ).bin
	hexdump -ve '1/4 "%08x\n"' $(PROJ).bin > $@
	#xxd -p -c 4 -g 4 $< > $@
	rm $(PROJ).bin
	wc -l $@
	echo mem ok.
	
$(PROJ).x86: $(SRCS)
	$(HOST_CC) $(HOST_CFLAGS) $(SRCS) -o $(PROJ).x86 -DBUILD="\"$(BUILD)\"" -DARCH="\"x86\""
	echo x86 ok.
