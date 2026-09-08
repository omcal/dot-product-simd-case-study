	.file	"dot_product_reassociated.cpp"
	.text
	.p2align 4
	.globl	_Z33dot_product_compiler_reassociatedPKfS0_m
	.type	_Z33dot_product_compiler_reassociatedPKfS0_m, @function
_Z33dot_product_compiler_reassociatedPKfS0_m:
.LFB1233:
	.cfi_startproc
	endbr64
	movq	%rdx, %rcx
	testq	%rdx, %rdx
	je	.L12
	leaq	-1(%rdx), %rax
	cmpq	$14, %rax
	jbe	.L13
	shrq	$4, %rdx
	vxorps	%xmm1, %xmm1, %xmm1
	salq	$6, %rdx
	xorl	%eax, %eax
	.p2align 5
	.p2align 4
	.p2align 3
.L4:
	vmovups	(%rsi,%rax), %zmm0
	vmulps	(%rdi,%rax), %zmm0, %zmm0
	addq	$64, %rax
	vaddps	%zmm0, %zmm1, %zmm1
	cmpq	%rdx, %rax
	jne	.L4
	vextractf32x8	$0x1, %zmm1, %ymm0
	vaddps	%ymm1, %ymm0, %ymm1
	vextractf32x4	$0x1, %ymm1, %xmm0
	vaddps	%xmm1, %xmm0, %xmm0
	vmovhlps	%xmm0, %xmm0, %xmm2
	vaddps	%xmm0, %xmm2, %xmm2
	vshufps	$85, %xmm2, %xmm2, %xmm0
	vaddps	%xmm2, %xmm0, %xmm0
	testb	$15, %cl
	je	.L28
	movq	%rcx, %rdx
	andq	$-16, %rdx
.L3:
	movq	%rcx, %rax
	subq	%rdx, %rax
	leaq	-1(%rax), %r8
	cmpq	$6, %r8
	jbe	.L30
	vmovups	(%rdi,%rdx,4), %ymm0
	vmulps	(%rsi,%rdx,4), %ymm0, %ymm0
	vaddps	%ymm1, %ymm0, %ymm0
	vextractf32x4	$0x1, %ymm0, %xmm1
	vaddps	%xmm0, %xmm1, %xmm1
	vmovhlps	%xmm1, %xmm1, %xmm2
	vaddps	%xmm1, %xmm2, %xmm2
	vshufps	$85, %xmm2, %xmm2, %xmm0
	vaddps	%xmm2, %xmm0, %xmm0
	testb	$7, %al
	je	.L28
	movq	%rax, %r9
	andq	$-8, %r9
	leaq	(%rdx,%r9), %r8
.L8:
	subq	%r9, %rax
	leaq	-1(%rax), %r10
	cmpq	$2, %r10
	jbe	.L10
	addq	%r9, %rdx
	vmovups	(%rdi,%rdx,4), %xmm0
	vmulps	(%rsi,%rdx,4), %xmm0, %xmm0
	vaddps	%xmm1, %xmm0, %xmm0
	vmovhlps	%xmm0, %xmm0, %xmm1
	vaddps	%xmm0, %xmm1, %xmm1
	vshufps	$85, %xmm1, %xmm1, %xmm0
	vaddps	%xmm1, %xmm0, %xmm0
	testb	$3, %al
	je	.L28
	andq	$-4, %rax
	addq	%rax, %r8
.L10:
	vmovss	(%rdi,%r8,4), %xmm1
	vmulss	(%rsi,%r8,4), %xmm1, %xmm1
	leaq	1(%r8), %rax
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rcx, %rax
	jnb	.L28
	vmovss	4(%rsi,%r8,4), %xmm1
	vmulss	4(%rdi,%r8,4), %xmm1, %xmm1
	leaq	2(%r8), %rax
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rcx, %rax
	jnb	.L28
	vmovss	8(%rdi,%r8,4), %xmm1
	vmulss	8(%rsi,%r8,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vzeroupper
	ret
	.p2align 4
	.p2align 3
.L28:
	vzeroupper
	ret
	.p2align 4
	.p2align 3
.L12:
	vxorps	%xmm0, %xmm0, %xmm0
	ret
.L13:
	vxorps	%xmm1, %xmm1, %xmm1
	xorl	%edx, %edx
	vxorps	%xmm0, %xmm0, %xmm0
	jmp	.L3
.L30:
	movq	%rdx, %r8
	xorl	%r9d, %r9d
	vinsertps	$0xe, %xmm0, %xmm0, %xmm1
	jmp	.L8
	.cfi_endproc
.LFE1233:
	.size	_Z33dot_product_compiler_reassociatedPKfS0_m, .-_Z33dot_product_compiler_reassociatedPKfS0_m
	.ident	"GCC: (Ubuntu 15.2.0-16ubuntu1) 15.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
