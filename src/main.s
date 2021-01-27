	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"+MT"
	.align	2
.LC1:
	.string	""
	.align	2
.LC2:
	.string	"+MAC"
	.align	2
.LC3:
	.string	"board: %s (id=%d)\n"
	.align	2
.LC4:
	.string	"Wed, 27 Jan 2021 11:44:40 +0100"
	.align	2
.LC5:
	.string	"build: darkriscv fw build %s\n"
	.align	2
.LC6:
	.string	"rv32i"
	.align	2
.LC7:
	.string	"core0: darkriscv@%d.%dMHz with %s%s%s\n"
	.align	2
.LC8:
	.string	"uart0: 115200 bps (div=%d)\n"
	.globl	__mulsi3
	.globl	__udivsi3
	.align	2
.LC9:
	.string	"timr0: periodic timer=%dHz (io.timer=%d)\n"
	.align	2
.LC10:
	.string	"Welcome to DarkertergRISCV!"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	s0,40(sp)
	lui	s0,%hi(io)
	sw	ra,44(sp)
	sw	s1,36(sp)
	sw	s2,32(sp)
	addi	s1,s0,%lo(io)
	sw	s3,28(sp)
	lbu	a0,0(s1)
	addi	s0,s0,%lo(io)
	andi	a0,a0,0xff
	call	board_name
	lbu	a2,0(s1)
	mv	a1,a0
	lui	a0,%hi(.LC3)
	andi	a2,a2,0xff
	addi	a0,a0,%lo(.LC3)
	call	printf
	lui	a1,%hi(.LC4)
	lui	a0,%hi(.LC5)
	addi	a1,a1,%lo(.LC4)
	addi	a0,a0,%lo(.LC5)
	call	printf
	lui	a5,%hi(threads)
	lbu	s2,1(s1)
	lbu	s1,2(s1)
	lw	a3,%lo(threads)(a5)
	li	a4,1
	andi	s2,s2,0xff
	andi	s1,s1,0xff
	mv	s3,a5
	bgt	a3,a4,.L4
	lui	a4,%hi(.LC1)
	addi	a4,a4,%lo(.LC1)
.L2:
	li	a2,16
	li	a1,16
	li	a0,1000
	sw	a4,12(sp)
	call	mac
	li	a5,1256
	lw	a4,12(sp)
	beq	a0,a5,.L5
	lui	a5,%hi(.LC1)
	addi	a5,a5,%lo(.LC1)
.L3:
	lui	a3,%hi(.LC6)
	lui	a0,%hi(.LC7)
	addi	a3,a3,%lo(.LC6)
	mv	a2,s1
	mv	a1,s2
	addi	a0,a0,%lo(.LC7)
	call	printf
	sw	zero,%lo(threads)(s3)
	lhu	a1,6(s0)
	lui	a0,%hi(.LC8)
	addi	a0,a0,%lo(.LC8)
	slli	a1,a1,16
	srli	a1,a1,16
	call	printf
	lbu	a0,1(s0)
	lbu	s1,2(s0)
	lw	s2,12(s0)
	lw	a2,12(s0)
	li	a1,999424
	addi	a1,a1,576
	andi	a0,a0,0xff
	sw	a2,12(sp)
	call	__mulsi3
	andi	s1,s1,0xff
	li	a1,8192
	mv	s0,a0
	addi	a1,a1,1808
	mv	a0,s1
	call	__mulsi3
	addi	a1,s2,1
	add	a0,s0,a0
	call	__udivsi3
	lw	a2,12(sp)
	mv	a1,a0
	lui	a0,%hi(.LC9)
	addi	a0,a0,%lo(.LC9)
	call	printf
	li	a0,10
	call	putchar
	lui	a0,%hi(.LC10)
	addi	a0,a0,%lo(.LC10)
	call	puts
	li	a0,10
	call	usleep
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	li	a0,0
	addi	sp,sp,48
	jr	ra
.L4:
	lui	a4,%hi(.LC0)
	addi	a4,a4,%lo(.LC0)
	j	.L2
.L5:
	lui	a5,%hi(.LC2)
	addi	a5,a5,%lo(.LC2)
	j	.L3
	.size	main, .-main
	.section	.rodata.str1.4
	.align	2
.LC11:
	.string	"Success"
	.text
	.align	2
	.globl	success
	.type	success, @function
success:
	lui	a0,%hi(.LC11)
	addi	a0,a0,%lo(.LC11)
	tail	printf
	.size	success, .-success
	.ident	"GCC: (GNU) 10.2.0"
