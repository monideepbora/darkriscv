	.file	"boot.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"boot0: text@%d data@%d stack@%d\n"
	.text
	.align	2
	.globl	boot
	.type	boot, @function
boot:
	lui	a4,%hi(threads)
	lw	a5,%lo(threads)(a4)
	addi	sp,sp,-32
	sw	s0,24(sp)
	addi	a3,a5,1
	andi	a5,a5,1
	sw	ra,28(sp)
	sw	s1,20(sp)
	sw	s2,16(sp)
	sw	a3,%lo(threads)(a4)
	sw	a5,12(sp)
	lui	s0,%hi(utimers)
	beq	a5,zero,.L6
	lui	a5,%hi(io)
	li	a3,999424
	addi	a5,a5,%lo(io)
	addi	a3,a3,575
	li	a2,-128
.L2:
	lw	a4,%lo(utimers)(s0)
	addi	a1,a4,-1
	sw	a1,%lo(utimers)(s0)
	bne	a4,zero,.L4
	lhu	a4,8(a5)
	addi	a4,a4,1
	slli	a4,a4,16
	srli	a4,a4,16
	sh	a4,8(a5)
	sw	a3,%lo(utimers)(s0)
.L4:
	sb	a2,3(a5)
	j	.L2
.L6:
	lui	s2,%hi(boot)
	lui	s1,%hi(.LC0)
.L3:
	call	banner
	addi	a3,sp,28
	addi	a2,s0,%lo(utimers)
	addi	a1,s2,%lo(boot)
	addi	a0,s1,%lo(.LC0)
	call	printf
	call	main
	j	.L3
	.size	boot, .-boot
	.ident	"GCC: (GNU) 10.2.0"
