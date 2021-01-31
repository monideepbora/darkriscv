#
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
#
# ===8<--------------------------------------------------------- cut here!
#
# This the root makefile and the function of this file is call other
# makefiles. Of course, you need first set the GCC compiler path/name, the
# simulator path/name and the board model:
#

# default input arguments

ARCH ?= RV32I

ifeq ($(ARCH),RV32I)
NETLIST=darkriscv-post-synth-rv32i
endif

ifeq ($(ARCH),RV32E)
NETLIST=darkriscv-post-synth-rv32e
endif

PIPELINE_STAGE ?= 2
THREADING ?= 0
WAITSTATES ?= 0

default: test_gate

test_rtl:
	make -C src all ARCH=$(ARCH) RTL=1   
	make -C rtl compute_config PIPELINE_STAGE=$(PIPELINE_STAGE) THREADING=$(THREADING) WAITSTATES=$(WAITSTATES)           
	make -C sim test_rtl ARCH=$(ARCH)  

test_gate:
	make -C src all  ARCH=$(ARCH) RTL=0   
	make -C rtl compute_config PIPELINE_STAGE=$(PIPELINE_STAGE) THREADING=$(THREADING) WAITSTATES=$(WAITSTATES)           
	make -C rtl synth ARCH=$(ARCH) NETLIST=$(NETLIST) PIPELINE_STAGE=$(PIPELINE_STAGE) THREADING=$(THREADING) WAITSTATES=$(WAITSTATES)
	make -C sim test_gate ARCH=$(ARCH) NETLIST=$(NETLIST)    

synth:
	make -C rtl synth ARCH=$(ARCH) NETLIST=$(NETLIST) PIPELINE_STAGE=$(PIPELINE_STAGE) THREADING=$(THREADING) WAITSTATES=$(WAITSTATES)
	
clean:
	make -C src clean
	make -C sim clean
	make -C rtl clean
	