	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"Sat, 30 Jan 2021 17:06:15 +0100"
	.align	2
.LC1:
	.string	"Firmware build version %s\n"
	.align	2
.LC2:
	.string	"Welcome to DarkRISCV!"
	.align	2
.LC3:
	.string	"RV32I"
	.align	2
.LC4:
	.string	"Starting tests for %s\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	lui	a1,%hi(.LC0)
	lui	a0,%hi(.LC1)
	addi	sp,sp,-16
	addi	a1,a1,%lo(.LC0)
	addi	a0,a0,%lo(.LC1)
	sw	ra,12(sp)
	call	printf
	lui	a5,%hi(threads)
	li	a0,10
	sw	zero,%lo(threads)(a5)
	call	putchar
	lui	a0,%hi(.LC2)
	addi	a0,a0,%lo(.LC2)
	call	puts
	li	a0,10
	call	putchar
	lui	a1,%hi(.LC3)
	lui	a0,%hi(.LC4)
	addi	a1,a1,%lo(.LC3)
	addi	a0,a0,%lo(.LC4)
	call	printf
	li	a0,10
	call	putchar
 #APP
# 46 "main.c" 1
	j start;
# 0 "" 2
 #NO_APP
	lw	ra,12(sp)
	li	a0,0
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.section	.rodata.str1.4
	.align	2
.LC5:
	.string	"All tests passed \n$"
	.text
	.align	2
	.globl	success
	.type	success, @function
success:
	addi	sp,sp,-16
	li	a0,10
	sw	ra,12(sp)
	call	putchar
	lw	ra,12(sp)
	lui	a0,%hi(.LC5)
	addi	a0,a0,%lo(.LC5)
	addi	sp,sp,16
	tail	putstr
	.size	success, .-success
	.section	.rodata.str1.4
	.align	2
.LC6:
	.string	"..Failure \n$"
	.text
	.align	2
	.globl	failure
	.type	failure, @function
failure:
	lui	a0,%hi(.LC6)
	addi	a0,a0,%lo(.LC6)
	tail	putstr
	.size	failure, .-failure
	.section	.rodata.str1.4
	.align	2
.LC7:
	.string	"..OK\n"
	.text
	.align	2
	.globl	OK
	.type	OK, @function
OK:
	lui	a0,%hi(.LC7)
	addi	a0,a0,%lo(.LC7)
	tail	putstr
	.size	OK, .-OK
	.ident	"GCC: (GNU) 10.2.0"
