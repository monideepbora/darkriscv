	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 4
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
	.string	"Thu, 21 Jan 2021 18:30:30 +0100"
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
	.string	"Welcome to DarkRISCV!"
	.align	2
.LC11:
	.string	"> "
	.align	2
.LC12:
	.string	" "
	.align	2
.LC13:
	.string	"clear"
	.align	2
.LC14:
	.string	"\033[H\033[2J"
	.align	2
.LC15:
	.string	"reboot"
	.align	2
.LC16:
	.string	"core0: reboot in 3 seconds"
	.align	2
.LC17:
	.string	"done."
	.align	2
.LC18:
	.string	"dump"
	.align	2
.LC19:
	.string	"%x: "
	.align	2
.LC20:
	.string	"%x "
	.align	2
.LC21:
	.string	"led"
	.align	2
.LC22:
	.string	"led = %x\n"
	.align	2
.LC23:
	.string	"timer"
	.align	2
.LC24:
	.string	"timer = %d\n"
	.align	2
.LC25:
	.string	"gpio"
	.align	2
.LC26:
	.string	"gpio = %x\n"
	.align	2
.LC27:
	.string	"mul"
	.align	2
.LC28:
	.string	"mul = %d\n"
	.align	2
.LC29:
	.string	"div"
	.globl	__modsi3
	.globl	__divsi3
	.align	2
.LC30:
	.string	"div = %d, mod = %d\n"
	.align	2
.LC31:
	.string	"mac"
	.align	2
.LC32:
	.string	"mac = %d\n"
	.align	2
.LC33:
	.string	"srai"
	.align	2
.LC34:
	.string	"srai %x >> 1 = %x\n"
	.align	2
.LC35:
	.string	"command: [%s] not found.\nvalid commands: clear, dump <hex>, led <hex>, timer <dec>, gpio <hex>\n                mul <dec> <dec>, div <dec> <dec>, mac <dec> <dec> <dec>\n                rd[m][bwl] <hex> [<hex> when m], wr[m][bwl] <hex> <hex> [<hex> when m]\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-120
	sw	s0,112(sp)
	lui	s0,%hi(io)
	sw	ra,116(sp)
	sw	s1,108(sp)
	addi	s1,s0,%lo(io)
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
	lbu	a6,1(s1)
	lbu	a7,2(s1)
	lui	s1,%hi(threads)
	lw	a4,%lo(threads)(s1)
	li	a5,1
	andi	a6,a6,0xff
	andi	a7,a7,0xff
	bgt	a4,a5,.L29
	lui	a4,%hi(.LC1)
	addi	a4,a4,%lo(.LC1)
.L2:
	li	a2,16
	li	a1,16
	li	a0,1000
	sw	a4,8(sp)
	sw	a7,4(sp)
	sw	a6,0(sp)
	call	mac
	li	a5,1256
	lw	a6,0(sp)
	lw	a7,4(sp)
	lw	a4,8(sp)
	beq	a0,a5,.L30
	lui	a5,%hi(.LC1)
	addi	a5,a5,%lo(.LC1)
.L3:
	lui	a3,%hi(.LC6)
	lui	a0,%hi(.LC7)
	mv	a2,a7
	mv	a1,a6
	addi	a3,a3,%lo(.LC6)
	addi	a0,a0,%lo(.LC7)
	call	printf
	sw	zero,%lo(threads)(s1)
	lhu	a1,6(s0)
	lui	a0,%hi(.LC8)
	addi	a0,a0,%lo(.LC8)
	slli	a1,a1,16
	srli	a1,a1,16
	call	printf
	lbu	a0,1(s0)
	lbu	a5,2(s0)
	lw	a4,12(s0)
	lw	a2,12(s0)
	li	a1,999424
	andi	a5,a5,0xff
	addi	a1,a1,576
	andi	a0,a0,0xff
	sw	a2,0(sp)
	sw	a4,4(sp)
	sw	a5,8(sp)
	call	__mulsi3
	lw	a5,8(sp)
	li	a1,8192
	mv	s1,a0
	addi	a1,a1,1808
	mv	a0,a5
	call	__mulsi3
	lw	a4,4(sp)
	add	a0,s1,a0
	addi	a1,a4,1
	call	__udivsi3
	lw	a2,0(sp)
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
.L28:
	lui	a5,%hi(.LC11)
	addi	a0,a5,%lo(.LC11)
	call	printf
	li	a2,64
	li	a1,0
	addi	a0,sp,44
	call	memset
	li	a1,64
	addi	a0,sp,44
	call	gets
	li	s1,0
	addi	a0,sp,44
	lui	a4,%hi(.LC12)
.L4:
	addi	a1,a4,%lo(.LC12)
	call	strtok
	addi	a4,sp,108
	slli	a5,s1,2
	add	a5,a4,a5
	sw	a0,-96(a5)
	lui	a4,%hi(.LC12)
	beq	a0,zero,.L5
	addi	s1,s1,1
	li	a5,8
	li	a0,0
	bne	s1,a5,.L4
.L5:
	lw	s1,12(sp)
	beq	s1,zero,.L28
	lui	a1,%hi(.LC13)
	addi	a1,a1,%lo(.LC13)
	mv	a0,s1
	call	strcmp
	bne	a0,zero,.L9
	lui	a0,%hi(.LC14)
	addi	a0,a0,%lo(.LC14)
	call	printf
	j	.L28
.L29:
	lui	a4,%hi(.LC0)
	addi	a4,a4,%lo(.LC0)
	j	.L2
.L30:
	lui	a5,%hi(.LC2)
	addi	a5,a5,%lo(.LC2)
	j	.L3
.L9:
	lui	a1,%hi(.LC15)
	addi	a1,a1,%lo(.LC15)
	mv	a0,s1
	call	strcmp
	beq	a0,zero,.L51
	lui	a1,%hi(.LC18)
	addi	a1,a1,%lo(.LC18)
	mv	a0,s1
	call	strcmp
	bne	a0,zero,.L11
	lw	s1,16(sp)
	beq	s1,zero,.L12
	mv	a0,s1
	call	xtoi
	mv	s1,a0
.L12:
	addi	a5,s1,256
	sw	a5,0(sp)
.L16:
	lui	a5,%hi(.LC19)
	mv	a1,s1
	addi	a0,a5,%lo(.LC19)
	call	printf
	li	a4,0
	lui	a2,%hi(.LC20)
.L13:
	add	a3,s1,a4
	lbu	a1,0(a3)
	addi	a0,a2,%lo(.LC20)
	sw	a4,4(sp)
	call	printf
	lw	a4,4(sp)
	li	a3,16
	lui	a2,%hi(.LC20)
	addi	a4,a4,1
	bne	a4,a3,.L13
	li	a4,0
.L15:
	add	a3,s1,a4
	lbu	a0,0(a3)
	li	a2,94
	addi	a3,a0,-32
	andi	a3,a3,0xff
	bleu	a3,a2,.L14
	li	a0,46
.L14:
	sw	a4,4(sp)
	call	putchar
	lw	a4,4(sp)
	li	a3,16
	addi	a4,a4,1
	bne	a4,a3,.L15
	li	a0,10
	call	putchar
	lw	a5,0(sp)
	addi	s1,s1,16
	bne	s1,a5,.L16
	j	.L28
.L11:
	lui	a1,%hi(.LC21)
	addi	a1,a1,%lo(.LC21)
	mv	a0,s1
	call	strcmp
	bne	a0,zero,.L18
	lw	a0,16(sp)
	beq	a0,zero,.L19
	call	xtoi
	slli	a0,a0,16
	srli	a0,a0,16
	sh	a0,8(s0)
.L19:
	lhu	a1,8(s0)
	lui	a0,%hi(.LC22)
	addi	a0,a0,%lo(.LC22)
	slli	a1,a1,16
	srli	a1,a1,16
.L53:
	call	printf
	j	.L28
.L18:
	lui	a1,%hi(.LC23)
	addi	a1,a1,%lo(.LC23)
	mv	a0,s1
	call	strcmp
	bne	a0,zero,.L20
	lw	a0,16(sp)
	beq	a0,zero,.L21
	call	atoi
	sw	a0,12(s0)
.L21:
	lui	a0,%hi(.LC24)
	lw	a1,12(s0)
	addi	a0,a0,%lo(.LC24)
	j	.L53
.L20:
	lui	a1,%hi(.LC25)
	addi	a1,a1,%lo(.LC25)
	mv	a0,s1
	call	strcmp
	bne	a0,zero,.L22
	lw	a0,16(sp)
	beq	a0,zero,.L23
	call	xtoi
	slli	a0,a0,16
	srli	a0,a0,16
	sh	a0,10(s0)
.L23:
	lhu	a1,10(s0)
	lui	a0,%hi(.LC26)
	addi	a0,a0,%lo(.LC26)
	slli	a1,a1,16
	srli	a1,a1,16
	j	.L53
.L22:
	lui	a1,%hi(.LC27)
	addi	a1,a1,%lo(.LC27)
	mv	a0,s1
	call	strcmp
	bne	a0,zero,.L24
	lw	a0,16(sp)
	call	atoi
	sw	a0,0(sp)
	lw	a0,20(sp)
	call	atoi
	lw	a1,0(sp)
	call	__mulsi3
	mv	a1,a0
	lui	a0,%hi(.LC28)
	addi	a0,a0,%lo(.LC28)
	j	.L53
.L24:
	lui	a1,%hi(.LC29)
	addi	a1,a1,%lo(.LC29)
	mv	a0,s1
	call	strcmp
	bne	a0,zero,.L25
	lw	a0,16(sp)
	call	atoi
	mv	s1,a0
	lw	a0,20(sp)
	call	atoi
	mv	a1,a0
	sw	a0,4(sp)
	mv	a0,s1
	call	__modsi3
	lw	a1,4(sp)
	sw	a0,0(sp)
	mv	a0,s1
	call	__divsi3
	lw	a2,0(sp)
	mv	a1,a0
	lui	a0,%hi(.LC30)
	addi	a0,a0,%lo(.LC30)
.L54:
	call	printf
	j	.L28
.L25:
	lui	a1,%hi(.LC31)
	addi	a1,a1,%lo(.LC31)
	mv	a0,s1
	call	strcmp
	bne	a0,zero,.L26
	lw	a0,16(sp)
	call	atoi
	mv	s1,a0
	lw	a0,20(sp)
	call	atoi
	sw	a0,0(sp)
	lw	a0,24(sp)
	call	atoi
	lw	a1,0(sp)
	slli	a2,a0,16
	srai	a2,a2,16
	slli	a1,a1,16
	srai	a1,a1,16
	mv	a0,s1
	call	mac
	mv	a1,a0
	lui	a0,%hi(.LC32)
	addi	a0,a0,%lo(.LC32)
	j	.L53
.L26:
	lui	a1,%hi(.LC33)
	addi	a1,a1,%lo(.LC33)
	mv	a0,s1
	call	strcmp
	bne	a0,zero,.L27
	lw	a0,16(sp)
	call	xtoi
	mv	a1,a0
	srai	a2,a0,1
	lui	a0,%hi(.LC34)
	addi	a0,a0,%lo(.LC34)
	j	.L54
.L27:
	lbu	a5,0(s1)
	beq	a5,zero,.L28
	lui	a0,%hi(.LC35)
	mv	a1,s1
	addi	a0,a0,%lo(.LC35)
	j	.L53
.L51:
	lui	a0,%hi(.LC16)
	addi	a0,a0,%lo(.LC16)
	call	printf
	li	s0,999424
	addi	a0,s0,576
	call	usleep
	li	a0,46
	call	putchar
	addi	a0,s0,576
	call	usleep
	li	a0,46
	call	putchar
	addi	a0,s0,576
	call	usleep
	li	a0,46
	call	putchar
	lui	a0,%hi(.LC17)
	addi	a0,a0,%lo(.LC17)
	call	puts
	lw	ra,116(sp)
	lw	s0,112(sp)
	lw	s1,108(sp)
	li	a0,0
	addi	sp,sp,120
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 10.2.0"
