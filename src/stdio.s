	.file	"stdio.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	getchar
	.type	getchar, @function
getchar:
	lui	a5,%hi(io)
	addi	a5,a5,%lo(io)
.L2:
	lbu	a4,4(a5)
	andi	a4,a4,2
	beq	a4,zero,.L2
	lbu	a0,5(a5)
	andi	a0,a0,0xff
	ret
	.size	getchar, .-getchar
	.align	2
	.globl	putchar
	.type	putchar, @function
putchar:
	lui	a5,%hi(io)
	li	a4,10
	addi	a5,a5,%lo(io)
	bne	a0,a4,.L8
.L7:
	lbu	a4,4(a5)
	andi	a4,a4,1
	bne	a4,zero,.L7
	li	a4,13
	sb	a4,5(a5)
.L8:
	lbu	a4,4(a5)
	andi	a4,a4,1
	bne	a4,zero,.L8
	andi	a4,a0,0xff
	sb	a4,5(a5)
	mv	a0,a4
	ret
	.size	putchar, .-putchar
	.align	2
	.globl	gets
	.type	gets, @function
gets:
	addi	sp,sp,-48
	sw	s0,40(sp)
	sw	s1,36(sp)
	sw	s3,28(sp)
	sw	s5,20(sp)
	sw	s6,16(sp)
	sw	s7,12(sp)
	sw	ra,44(sp)
	sw	s2,32(sp)
	sw	s4,24(sp)
	mv	s1,a0
	mv	s3,a1
	mv	s0,a0
	li	s5,10
	li	s6,13
	li	s7,8
.L12:
	addi	s4,s3,-1
	beq	s4,zero,.L16
	call	getchar
	mv	s2,a0
	bne	a0,s5,.L13
.L16:
	li	a0,10
	call	putchar
	sb	zero,0(s0)
	bne	s0,s1,.L14
	li	s1,0
.L14:
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	lw	s4,24(sp)
	lw	s5,20(sp)
	lw	s6,16(sp)
	lw	s7,12(sp)
	mv	a0,s1
	lw	s1,36(sp)
	addi	sp,sp,48
	jr	ra
.L13:
	beq	a0,s6,.L16
	call	putchar
	bne	s2,s7,.L17
	beq	s0,s1,.L18
	sb	zero,-1(s0)
	mv	s4,s3
	addi	s0,s0,-1
.L18:
	mv	s3,s4
	j	.L12
.L17:
	sb	s2,0(s0)
	addi	s0,s0,1
	j	.L18
	.size	gets, .-gets
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC2:
	.string	"(NULL)"
	.text
	.align	2
	.globl	putstr
	.type	putstr, @function
putstr:
	addi	sp,sp,-16
	sw	s0,8(sp)
	sw	ra,12(sp)
	mv	s0,a0
	bne	a0,zero,.L24
	lui	s0,%hi(.LC2)
	addi	s0,s0,%lo(.LC2)
.L24:
	lbu	a0,0(s0)
	bne	a0,zero,.L26
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
.L26:
	addi	s0,s0,1
	call	putchar
	j	.L24
	.size	putstr, .-putstr
	.align	2
	.globl	puts
	.type	puts, @function
puts:
	addi	sp,sp,-16
	sw	ra,12(sp)
	call	putstr
	lw	ra,12(sp)
	li	a0,10
	addi	sp,sp,16
	tail	putchar
	.size	puts, .-puts
	.section	.rodata.str1.4
	.align	2
.LC3:
	.string	"0123456789abcdef"
	.globl	__udivsi3
	.globl	__umodsi3
	.text
	.align	2
	.globl	putdx
	.type	putdx, @function
putdx:
	addi	sp,sp,-96
	sw	s4,72(sp)
	mv	s4,a1
	lui	a1,%hi(.LANCHOR0)
	sw	s0,88(sp)
	sw	s1,84(sp)
	addi	s0,a1,%lo(.LANCHOR0)
	li	a2,44
	addi	a1,a1,%lo(.LANCHOR0)
	mv	s1,a0
	addi	a0,sp,20
	sw	ra,92(sp)
	sw	s2,80(sp)
	sw	s3,76(sp)
	sw	s5,68(sp)
	call	memcpy
	addi	a1,s0,44
	li	a2,20
	mv	a0,sp
	call	memcpy
	mv	s0,sp
	beq	s4,zero,.L32
	addi	s0,sp,20
.L32:
	lui	s2,%hi(.LC3)
	li	s3,24
	li	s5,1
	addi	s2,s2,%lo(.LC3)
.L33:
	lw	a1,0(s0)
	bne	a1,zero,.L37
	lw	ra,92(sp)
	lw	s0,88(sp)
	lw	s1,84(sp)
	lw	s2,80(sp)
	lw	s3,76(sp)
	lw	s4,72(sp)
	lw	s5,68(sp)
	addi	sp,sp,96
	jr	ra
.L37:
	beq	a1,s5,.L34
	bgtu	a1,s1,.L35
.L34:
	beq	s4,zero,.L36
	mv	a0,s1
	call	__udivsi3
	li	a1,10
	call	__umodsi3
	add	a0,s2,a0
	lbu	a0,0(a0)
.L41:
	call	putchar
.L35:
	addi	s3,s3,-8
	addi	s0,s0,4
	j	.L33
.L36:
	addi	a5,s3,4
	srl	a5,s1,a5
	andi	a5,a5,15
	add	a5,s2,a5
	lbu	a0,0(a5)
	call	putchar
	srl	a5,s1,s3
	andi	a5,a5,15
	add	a5,s2,a5
	lbu	a0,0(a5)
	j	.L41
	.size	putdx, .-putdx
	.align	2
	.globl	putx
	.type	putx, @function
putx:
	li	a1,0
	tail	putdx
	.size	putx, .-putx
	.align	2
	.globl	putd
	.type	putd, @function
putd:
	li	a1,1
	tail	putdx
	.size	putd, .-putd
	.align	2
	.globl	printf
	.type	printf, @function
printf:
	addi	sp,sp,-80
	sw	a5,68(sp)
	addi	a5,sp,52
	sw	s0,40(sp)
	sw	s2,32(sp)
	sw	s3,28(sp)
	sw	s4,24(sp)
	sw	s5,20(sp)
	sw	ra,44(sp)
	sw	s1,36(sp)
	mv	s0,a0
	sw	a1,52(sp)
	sw	a2,56(sp)
	sw	a3,60(sp)
	sw	a4,64(sp)
	sw	a6,72(sp)
	sw	a7,76(sp)
	sw	a5,12(sp)
	li	s2,37
	li	s3,115
	li	s4,120
	li	s5,100
.L45:
	lbu	a0,0(s0)
	bne	a0,zero,.L51
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	lw	s2,32(sp)
	lw	s3,28(sp)
	lw	s4,24(sp)
	lw	s5,20(sp)
	addi	sp,sp,80
	jr	ra
.L51:
	addi	s1,s0,1
	bne	a0,s2,.L46
	lbu	a0,1(s0)
	bne	a0,s3,.L47
	lw	a5,12(sp)
	lw	a0,0(a5)
	addi	a4,a5,4
	sw	a4,12(sp)
	call	putstr
.L48:
	addi	s0,s1,1
	j	.L45
.L47:
	bne	a0,s4,.L49
	lw	a5,12(sp)
	lw	a0,0(a5)
	addi	a4,a5,4
	sw	a4,12(sp)
	call	putx
	j	.L48
.L49:
	bne	a0,s5,.L50
	lw	a5,12(sp)
	lw	a0,0(a5)
	addi	a4,a5,4
	sw	a4,12(sp)
	call	putd
	j	.L48
.L50:
	call	putchar
	j	.L48
.L46:
	call	putchar
	mv	s1,s0
	j	.L48
	.size	printf, .-printf
	.align	2
	.globl	strncmp
	.type	strncmp, @function
strncmp:
	addi	a2,a2,-1
	li	a5,0
.L55:
	add	a4,a0,a5
	lbu	a3,0(a4)
	add	a4,a1,a5
	lbu	a4,0(a4)
	beq	a5,a2,.L54
	beq	a3,zero,.L54
	beq	a4,zero,.L54
	addi	a5,a5,1
	beq	a3,a4,.L55
.L54:
	sub	a0,a3,a4
	ret
	.size	strncmp, .-strncmp
	.align	2
	.globl	strcmp
	.type	strcmp, @function
strcmp:
	li	a2,-1
	tail	strncmp
	.size	strcmp, .-strcmp
	.align	2
	.globl	strlen
	.type	strlen, @function
strlen:
	mv	a5,a0
	li	a0,0
.L65:
	add	a4,a5,a0
	lbu	a4,0(a4)
	bne	a4,zero,.L66
	ret
.L66:
	addi	a0,a0,1
	j	.L65
	.size	strlen, .-strlen
	.align	2
	.globl	memcpy
	.type	memcpy, @function
memcpy:
	li	a5,0
.L68:
	bne	a5,a2,.L69
	ret
.L69:
	add	a4,a1,a5
	lbu	a3,0(a4)
	add	a4,a0,a5
	addi	a5,a5,1
	sb	a3,0(a4)
	j	.L68
	.size	memcpy, .-memcpy
	.align	2
	.globl	memset
	.type	memset, @function
memset:
	add	a2,a0,a2
	mv	a5,a0
.L71:
	bne	a5,a2,.L72
	ret
.L72:
	addi	a5,a5,1
	sb	a1,-1(a5)
	j	.L71
	.size	memset, .-memset
	.align	2
	.globl	strtok
	.type	strtok, @function
strtok:
	addi	sp,sp,-32
	sw	s0,24(sp)
	mv	s0,a0
	mv	a0,a1
	sw	s2,16(sp)
	sw	s3,12(sp)
	sw	ra,28(sp)
	sw	s1,20(sp)
	mv	s2,a1
	call	strlen
	mv	s3,a0
	bne	s0,zero,.L74
	lui	a5,%hi(nxt.0)
	lw	s0,%lo(nxt.0)(a5)
	beq	s0,zero,.L75
.L74:
	mv	s1,s0
.L76:
	lbu	a5,0(s1)
	bne	a5,zero,.L77
	lui	a5,%hi(nxt.0)
	sw	zero,%lo(nxt.0)(a5)
	j	.L75
.L77:
	mv	a2,s3
	mv	a1,s2
	mv	a0,s1
	call	strncmp
	addi	a5,s1,1
	bne	a0,zero,.L78
	lui	a4,%hi(nxt.0)
	sb	zero,0(s1)
	sw	a5,%lo(nxt.0)(a4)
.L75:
	lw	ra,28(sp)
	mv	a0,s0
	lw	s0,24(sp)
	lw	s1,20(sp)
	lw	s2,16(sp)
	lw	s3,12(sp)
	addi	sp,sp,32
	jr	ra
.L78:
	mv	s1,a5
	j	.L76
	.size	strtok, .-strtok
	.align	2
	.globl	atoi
	.type	atoi, @function
atoi:
	mv	a4,a0
	li	a3,0
	li	a0,0
	li	a2,45
.L84:
	bne	a4,zero,.L86
.L90:
	bne	a3,zero,.L87
	ret
.L91:
	li	a3,1
	j	.L85
.L86:
	lbu	a5,0(a4)
	beq	a5,zero,.L90
	beq	a5,a2,.L91
	slli	a1,a0,3
	addi	a5,a5,-48
	add	a5,a5,a1
	slli	a0,a0,1
	add	a0,a5,a0
.L85:
	addi	a4,a4,1
	j	.L84
.L87:
	neg	a0,a0
	ret
	.size	atoi, .-atoi
	.align	2
	.globl	xtoi
	.type	xtoi, @function
xtoi:
	mv	a4,a0
	li	a3,57
	li	a0,0
.L93:
	beq	a4,zero,.L92
	lbu	a5,0(a4)
	bne	a5,zero,.L97
.L92:
	ret
.L97:
	slli	a0,a0,4
	bgtu	a5,a3,.L94
	addi	a5,a5,-48
.L101:
	add	a0,a5,a0
	addi	a4,a4,1
	j	.L93
.L94:
	andi	a5,a5,95
	addi	a5,a5,-55
	j	.L101
	.size	xtoi, .-xtoi
	.align	2
	.globl	mac
	.type	mac, @function
mac:
 #APP
# 271 "stdio.c" 1
	.word 0x00c5857F
# 0 "" 2
 #NO_APP
	ret
	.size	mac, .-mac
	.align	2
	.globl	__umulsi3
	.type	__umulsi3, @function
__umulsi3:
	mv	a5,a0
	bgeu	a0,a1,.L104
	mv	a5,a1
	mv	a1,a0
.L104:
	li	a0,0
.L105:
	bne	a1,zero,.L107
	ret
.L107:
	andi	a4,a1,1
	beq	a4,zero,.L106
	add	a0,a0,a5
.L106:
	slli	a5,a5,1
	srli	a1,a1,1
	j	.L105
	.size	__umulsi3, .-__umulsi3
	.align	2
	.globl	__mulsi3
	.type	__mulsi3, @function
__mulsi3:
	addi	sp,sp,-16
	sw	s1,4(sp)
	sw	ra,12(sp)
	sw	s0,8(sp)
	li	s1,0
	bge	a0,zero,.L112
	neg	a0,a0
	li	s1,1
.L112:
	li	s0,0
	bge	a1,zero,.L113
	neg	a1,a1
	li	s0,1
.L113:
	call	__umulsi3
	beq	s1,s0,.L111
	neg	a0,a0
.L111:
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	addi	sp,sp,16
	jr	ra
	.size	__mulsi3, .-__mulsi3
	.align	2
	.globl	__udiv_umod_si3
	.type	__udiv_umod_si3, @function
__udiv_umod_si3:
	mv	a5,a0
	li	a4,1
	mv	a0,a1
	bne	a1,zero,.L122
.L121:
	ret
.L123:
	slli	a4,a4,1
	slli	a0,a0,1
.L122:
	bgtu	a5,a0,.L123
	mv	a3,a0
	li	a0,0
.L124:
	beq	a5,zero,.L126
	bne	a4,zero,.L127
.L126:
	bne	a2,zero,.L121
	mv	a0,a5
	j	.L121
.L127:
	bltu	a5,a3,.L125
	sub	a5,a5,a3
	add	a0,a0,a4
.L125:
	srli	a4,a4,1
	srli	a3,a3,1
	j	.L124
	.size	__udiv_umod_si3, .-__udiv_umod_si3
	.align	2
	.globl	__udivsi3
	.type	__udivsi3, @function
__udivsi3:
	li	a2,1
	tail	__udiv_umod_si3
	.size	__udivsi3, .-__udivsi3
	.align	2
	.globl	__umodsi3
	.type	__umodsi3, @function
__umodsi3:
	li	a2,0
	tail	__udiv_umod_si3
	.size	__umodsi3, .-__umodsi3
	.align	2
	.globl	__div_mod_si3
	.type	__div_mod_si3, @function
__div_mod_si3:
	beq	a1,zero,.L150
	addi	sp,sp,-16
	sw	s0,8(sp)
	sw	s1,4(sp)
	sw	ra,12(sp)
	sw	s2,0(sp)
	mv	s0,a2
	li	s1,0
	bge	a0,zero,.L138
	neg	a0,a0
	li	s1,1
.L138:
	li	s2,0
	bge	a1,zero,.L139
	neg	a1,a1
	li	s2,1
.L139:
	mv	a2,s0
	call	__udiv_umod_si3
	mv	a1,a0
	beq	s0,zero,.L140
	beq	s1,s2,.L137
	neg	a1,a0
.L137:
	lw	ra,12(sp)
	lw	s0,8(sp)
	lw	s1,4(sp)
	lw	s2,0(sp)
	mv	a0,a1
	addi	sp,sp,16
	jr	ra
.L140:
	beq	s1,zero,.L137
	neg	a1,a0
	j	.L137
.L150:
	mv	a0,a1
	ret
	.size	__div_mod_si3, .-__div_mod_si3
	.align	2
	.globl	__divsi3
	.type	__divsi3, @function
__divsi3:
	li	a2,1
	tail	__div_mod_si3
	.size	__divsi3, .-__divsi3
	.align	2
	.globl	__modsi3
	.type	__modsi3, @function
__modsi3:
	li	a2,0
	tail	__div_mod_si3
	.size	__modsi3, .-__modsi3
	.align	2
	.globl	usleep
	.type	usleep, @function
usleep:
	lui	a5,%hi(threads)
	lw	a4,%lo(threads)(a5)
	li	a5,1
	ble	a4,a5,.L167
	li	a4,-1
	lui	a5,%hi(utimers)
.L156:
	addi	a0,a0,-1
	bne	a0,a4,.L159
	ret
.L167:
	lui	a5,%hi(io)
	li	a3,-1
	addi	a5,a5,%lo(io)
	li	a2,-128
.L157:
	addi	a0,a0,-1
	bne	a0,a3,.L161
	ret
.L159:
	lw	a3,%lo(utimers)(a5)
.L158:
	lw	a2,%lo(utimers)(a5)
	beq	a2,a3,.L158
	j	.L156
.L161:
	sb	a2,3(a5)
.L160:
	lbu	a4,3(a5)
	andi	a4,a4,0xff
	beq	a4,zero,.L160
	j	.L157
	.size	usleep, .-usleep
	.section	.rodata
	.align	2
	.set	.LANCHOR0,. + 0
.LC0:
	.word	1000000000
	.word	100000000
	.word	10000000
	.word	1000000
	.word	100000
	.word	10000
	.word	1000
	.word	100
	.word	10
	.word	1
	.word	0
.LC1:
	.word	16777216
	.word	65536
	.word	256
	.word	1
	.word	0
	.section	.sbss,"aw",@nobits
	.align	2
	.type	nxt.0, @object
	.size	nxt.0, 4
nxt.0:
	.zero	4
	.ident	"GCC: (GNU) 10.2.0"
