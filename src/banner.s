	.file	"banner.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.ascii	" \016v \n\001 \022v\034\n\001"
	.string	"r\r \007v\032\n\001r\020 \006v\030\n\001r\022 \004v\030\n\001r\022 \004v\030\n\001r\022 \004v\030\n\001r\020 \006v\026 \002\n\001r\r \007v\026 \004\n\001r\002 \020v\026 \006\n\001r\002 \fv\030 \006r\002\n\001r\004 \006v\032 \006r\004\n\001r\006 \006v\026 \006r\006\n\001r\b \006v\022 \006r\b\n\001r\n \006v\016 \006r\n\n\001r\f \006v\n \006r\f\n\001r\016 \006v\006 \006r\016\n\001r\020 \006v\002 \006r\020\n\001r\022 \nr\022\n\001r\024 \006r\024\n\001r\026 \002r\026\n\002 \007I\001N\001S\001T\001R\001U\001C\001T\001I\001O\001N\001 \001S\001E\001T\001S\001 \001W\001A\001N\001T\001 \001T\001O\001 \001B\001E\001 \001F\001R\001E\002\n\002"
	.text
	.align	2
	.globl	banner
	.type	banner, @function
banner:
	addi	sp,sp,-288
	lui	a1,%hi(.LC0)
	li	a2,269
	addi	a1,a1,%lo(.LC0)
	mv	a0,sp
	sw	ra,284(sp)
	sw	s0,280(sp)
	sw	s1,276(sp)
	sw	s2,272(sp)
	call	memcpy
	li	a0,10
	call	putchar
	mv	s0,sp
.L2:
	lbu	s2,0(s0)
	bne	s2,zero,.L5
	lw	ra,284(sp)
	lw	s0,280(sp)
	lw	s1,276(sp)
	lw	s2,272(sp)
	addi	sp,sp,288
	jr	ra
.L5:
	lbu	s1,1(s0)
	addi	s0,s0,2
.L3:
	beq	s1,zero,.L2
	mv	a0,s2
	call	putchar
	addi	s1,s1,-1
	j	.L3
	.size	banner, .-banner
	.ident	"GCC: (GNU) 10.2.0"
