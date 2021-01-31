## Software

This directory provides support for DarkRISCV software.

The software is 100% written in C language and ASM, is compiled by the GCC and lots
of support files (elf, assembler, maps, etc) are produced in order to help
debug and/or study the RISCV architecture.

The stdio console output functions output to the uart.

The riscv-tests reside sequenctially after the C-firmware. It is done by the linker (.ld) script
