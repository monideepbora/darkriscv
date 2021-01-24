RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX = /opt/riscv32

TOOLCHAIN_PREFIX = $(RISCV_GNU_TOOLCHAIN_INSTALL_PREFIX)/bin/riscv32-unknown-elf-

IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave
YOSYS = yosys

ifndef ARCH
ARCH = RV32I
endif

# default test vars for RV32I
ifeq ($(ARCH),RV32I)
TEST_OBJS_DEFAULT = $(addsuffix .o,$(basename $(wildcard tests/$(ARCH)/*.S)))
TEST_DIR_TARGET = tests/$(ARCH)/
GCC_FLAGS = -UMUL
INTEGER_INST = 1
POST_SYNTH_NETLIST = picorv32-post-synth-rv32i
MABI = ilp32
MARCH = rv32i
endif

# define firmware file to link test object files
# same firmware file used to
FIRMWARE_OBJS = tests/start.o

all: tests/firmware.hex

testbench/testbench_rtl.vvp: testbench/testbench.v source/picorv32.v source/picorv32_peripherals.v source/picorv32_wrapper.v source/axi4_memory.v
	$(IVERILOG) -o $@ $(subst 1,-DCOMPRESSED_ISA,$(COMPRESSED_ISA)) $^
	chmod -x $@


tests/firmware.hex: tests/firmware.bin
	hexdump -ve '1/4 "%08x\n"' $< > $@

tests/firmware.bin: tests/firmware.elf
	$(TOOLCHAIN_PREFIX)objcopy -O binary $< $@
	chmod -x $@

tests/firmware.elf: $(FIRMWARE_OBJS) $(TEST_OBJS_DEFAULT) tests/sections.lds
	$(TOOLCHAIN_PREFIX)gcc -march=${MARCH} -mabi=${MABI} -Os -ffreestanding -nostdlib -o $@ \
		-Wl,-Bstatic,--strip-debug \
		$(FIRMWARE_OBJS) $(TEST_OBJS_DEFAULT) -lgcc
	chmod -x $@

tests/start.o: tests/start.S
	$(TOOLCHAIN_PREFIX)gcc -c -march=${MARCH} -mabi=${MABI} -o $@ $(GCC_FLAGS) $<

$(addsuffix %.o,$(basename $(TEST_DIR_TARGET))): $(addsuffix %.S,$(basename $(TEST_DIR_TARGET))) tests/$(ARCH)/riscv_test.h tests/$(ARCH)/test_macros.h
	$(TOOLCHAIN_PREFIX)gcc -c -march=${MARCH} -mabi=${MABI} -o $@ -DTEST_FUNC_NAME=$(notdir $(basename $<)) \
		-DTEST_FUNC_TXT='"$(notdir $(basename $<))"' -DTEST_FUNC_RET=$(notdir $(basename $<))_ret $<

clean:
	rm -vrf $(FIRMWARE_OBJS) tests/RV32I/*.o tests/RV32IM/*.o tests/RV32IC/*.o tests/RV32IMC/*.o tests/RV32E/*.o  \
		tests/firmware.elf tests/firmware.bin tests/firmware.hex tests/firmware.map \
		testbench/testbench_gate.vvp testbench/testbench_rtl.vvp wave.vcd