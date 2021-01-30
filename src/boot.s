	.file	"boot.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	boot
	.type	boot, @function
boot:
	lui	a4,%hi(threads)
	lw	a5,%lo(threads)(a4)
	addi	a3,a5,1
	sw	a3,%lo(threads)(a4)
	andi	a5,a5,1
	beq	a5,zero,.L7
	lui	a5,%hi(io)
	li	a2,999424
	lui	a3,%hi(utimers)
	addi	a5,a5,%lo(io)
	addi	a2,a2,575
	li	a1,-128
.L2:
	lw	a4,%lo(utimers)(a3)
	addi	a0,a4,-1
	sw	a0,%lo(utimers)(a3)
	bne	a4,zero,.L4
	lhu	a4,8(a5)
	addi	a4,a4,1
	slli	a4,a4,16
	srli	a4,a4,16
	sh	a4,8(a5)
	sw	a2,%lo(utimers)(a3)
.L4:
	sb	a1,3(a5)
	j	.L2
.L7:
	addi	sp,sp,-16
	sw	ra,12(sp)
.L3:
	call	banner
	call	main
	j	.L3
	.size	boot, .-boot
	.ident	"GCC: (GNU) 10.2.0"
