	.file	"dot_product_avx2.cpp"
	.text
	.globl	_Z16dot_product_avx2PKfS0_m     # -- Begin function _Z16dot_product_avx2PKfS0_m
	.p2align	4
	.type	_Z16dot_product_avx2PKfS0_m,@function
_Z16dot_product_avx2PKfS0_m:            # @_Z16dot_product_avx2PKfS0_m
	.cfi_startproc
# %bb.0:
	cmpq	$32, %rdx
	jb	.LBB0_1
# %bb.2:
	leaq	-32(%rdx), %rax
	movq	%rax, %r8
	shrq	$5, %r8
	incq	%r8
	movl	%r8d, %ecx
	andl	$3, %ecx
	cmpq	$96, %rax
	jae	.LBB0_14
# %bb.3:
	vxorps	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm1, %xmm1, %xmm1
	jmp	.LBB0_4
.LBB0_1:
	vxorps	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm0, %xmm0, %xmm0
	jmp	.LBB0_6
.LBB0_14:
	andq	$-4, %r8
	vxorps	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm1, %xmm1, %xmm1
	.p2align	4
.LBB0_15:                               # =>This Inner Loop Header: Depth=1
	vmovups	(%rdi,%rax,4), %ymm4
	vmovups	32(%rdi,%rax,4), %ymm5
	vmovups	64(%rdi,%rax,4), %ymm6
	vmovups	96(%rdi,%rax,4), %ymm7
	vmulps	(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm0, %ymm0
	vmulps	32(%rsi,%rax,4), %ymm5, %ymm4
	vaddps	%ymm4, %ymm2, %ymm2
	vmulps	64(%rsi,%rax,4), %ymm6, %ymm4
	vaddps	%ymm4, %ymm3, %ymm3
	vmulps	96(%rsi,%rax,4), %ymm7, %ymm4
	vaddps	%ymm4, %ymm1, %ymm1
	vmovups	128(%rdi,%rax,4), %ymm4
	vmulps	128(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm0, %ymm0
	vmovups	160(%rdi,%rax,4), %ymm4
	vmulps	160(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm2, %ymm2
	vmovups	192(%rdi,%rax,4), %ymm4
	vmulps	192(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm3, %ymm3
	vmovups	224(%rdi,%rax,4), %ymm4
	vmulps	224(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm1, %ymm1
	vmovups	256(%rdi,%rax,4), %ymm4
	vmulps	256(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm0, %ymm0
	vmovups	288(%rdi,%rax,4), %ymm4
	vmulps	288(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm2, %ymm2
	vmovups	320(%rdi,%rax,4), %ymm4
	vmulps	320(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm3, %ymm3
	vmovups	352(%rdi,%rax,4), %ymm4
	vmulps	352(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm1, %ymm1
	vmovups	384(%rdi,%rax,4), %ymm4
	vmulps	384(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm0, %ymm0
	vmovups	416(%rdi,%rax,4), %ymm4
	vmulps	416(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm2, %ymm2
	vmovups	448(%rdi,%rax,4), %ymm4
	vmulps	448(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm3, %ymm3
	vmovups	480(%rdi,%rax,4), %ymm4
	vmulps	480(%rsi,%rax,4), %ymm4, %ymm4
	subq	$-128, %rax
	addq	$-4, %r8
	vaddps	%ymm4, %ymm1, %ymm1
	jne	.LBB0_15
.LBB0_4:
	testq	%rcx, %rcx
	je	.LBB0_6
	.p2align	4
.LBB0_5:                                # =>This Inner Loop Header: Depth=1
	vmovups	(%rdi,%rax,4), %ymm4
	vmovups	64(%rdi,%rax,4), %ymm6
	vmovups	32(%rdi,%rax,4), %ymm5
	vmovups	96(%rdi,%rax,4), %ymm7
	vmulps	32(%rsi,%rax,4), %ymm5, %ymm8
	vmulps	(%rsi,%rax,4), %ymm4, %ymm4
	vmulps	64(%rsi,%rax,4), %ymm6, %ymm6
	vmulps	96(%rsi,%rax,4), %ymm7, %ymm5
	addq	$32, %rax
	decq	%rcx
	vaddps	%ymm4, %ymm0, %ymm0
	vaddps	%ymm2, %ymm8, %ymm2
	vaddps	%ymm6, %ymm3, %ymm3
	vaddps	%ymm5, %ymm1, %ymm1
	jne	.LBB0_5
.LBB0_6:
	movq	%rdx, %rcx
	subq	%rax, %rcx
	cmpq	$8, %rcx
	jb	.LBB0_8
	.p2align	4
.LBB0_7:                                # =>This Inner Loop Header: Depth=1
	vmovups	(%rdi,%rax,4), %ymm4
	addq	$-8, %rcx
	vmulps	(%rsi,%rax,4), %ymm4, %ymm4
	addq	$8, %rax
	vaddps	%ymm4, %ymm0, %ymm0
	cmpq	$7, %rcx
	ja	.LBB0_7
.LBB0_8:
	vaddps	%ymm0, %ymm2, %ymm0
	vaddps	%ymm3, %ymm1, %ymm1
	movq	%rax, %rcx
	subq	%rdx, %rcx
	vaddps	%ymm0, %ymm1, %ymm0
	vxorps	%xmm1, %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm1
	vmovshdup	%xmm0, %xmm2            # xmm2 = xmm0[1,1,3,3]
	vaddss	%xmm2, %xmm1, %xmm1
	vshufpd	$1, %xmm0, %xmm0, %xmm2         # xmm2 = xmm0[1,0]
	vaddss	%xmm2, %xmm1, %xmm1
	vshufps	$255, %xmm0, %xmm0, %xmm2       # xmm2 = xmm0[3,3,3,3]
	vextractf128	$1, %ymm0, %xmm0
	vaddss	%xmm2, %xmm1, %xmm1
	vmovshdup	%xmm0, %xmm2            # xmm2 = xmm0[1,1,3,3]
	vaddss	%xmm0, %xmm1, %xmm1
	vaddss	%xmm2, %xmm1, %xmm1
	vshufpd	$1, %xmm0, %xmm0, %xmm2         # xmm2 = xmm0[1,0]
	vshufps	$255, %xmm0, %xmm0, %xmm0       # xmm0 = xmm0[3,3,3,3]
	vaddss	%xmm2, %xmm1, %xmm1
	vaddss	%xmm0, %xmm1, %xmm0
	jae	.LBB0_13
# %bb.9:
	movl	%edx, %r8d
	subl	%eax, %r8d
	andl	$7, %r8d
	je	.LBB0_11
	.p2align	4
.LBB0_10:                               # =>This Inner Loop Header: Depth=1
	vmovss	(%rdi,%rax,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vmulss	(%rsi,%rax,4), %xmm1, %xmm1
	incq	%rax
	decq	%r8
	vaddss	%xmm1, %xmm0, %xmm0
	jne	.LBB0_10
.LBB0_11:
	cmpq	$-8, %rcx
	ja	.LBB0_13
	.p2align	4
.LBB0_12:                               # =>This Inner Loop Header: Depth=1
	vmovss	(%rdi,%rax,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vmovss	4(%rdi,%rax,4), %xmm2           # xmm2 = mem[0],zero,zero,zero
	vmulss	(%rsi,%rax,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmulss	4(%rsi,%rax,4), %xmm2, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	8(%rdi,%rax,4), %xmm1           # xmm1 = mem[0],zero,zero,zero
	vmulss	8(%rsi,%rax,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	12(%rdi,%rax,4), %xmm1          # xmm1 = mem[0],zero,zero,zero
	vmulss	12(%rsi,%rax,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	16(%rdi,%rax,4), %xmm1          # xmm1 = mem[0],zero,zero,zero
	vmulss	16(%rsi,%rax,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	20(%rdi,%rax,4), %xmm1          # xmm1 = mem[0],zero,zero,zero
	vmulss	20(%rsi,%rax,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	24(%rdi,%rax,4), %xmm1          # xmm1 = mem[0],zero,zero,zero
	vmulss	24(%rsi,%rax,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	28(%rdi,%rax,4), %xmm1          # xmm1 = mem[0],zero,zero,zero
	vmulss	28(%rsi,%rax,4), %xmm1, %xmm1
	addq	$8, %rax
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rax, %rdx
	jne	.LBB0_12
.LBB0_13:
	vzeroupper
	retq
.Lfunc_end0:
	.size	_Z16dot_product_avx2PKfS0_m, .Lfunc_end0-_Z16dot_product_avx2PKfS0_m
	.cfi_endproc
                                        # -- End function
	.ident	"Ubuntu clang version 21.1.8 (++20251221032922+2078da43e25a-1~exp1~20251221153059.70)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
