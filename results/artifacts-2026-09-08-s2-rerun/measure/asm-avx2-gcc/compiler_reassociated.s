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
	je	.L9
	leaq	-1(%rdx), %rax
	cmpq	$6, %rax
	jbe	.L10
	shrq	$3, %rdx
	xorl	%eax, %eax
	vxorps	%xmm1, %xmm1, %xmm1
	salq	$5, %rdx
	.p2align 5
	.p2align 4
	.p2align 3
.L4:
	vmovups	(%rsi,%rax), %ymm0
	vmulps	(%rdi,%rax), %ymm0, %ymm0
	addq	$32, %rax
	vaddps	%ymm0, %ymm1, %ymm1
	cmpq	%rax, %rdx
	jne	.L4
	vextractf128	$0x1, %ymm1, %xmm0
	vaddps	%xmm1, %xmm0, %xmm1
	vmovhlps	%xmm1, %xmm1, %xmm2
	vaddps	%xmm1, %xmm2, %xmm2
	vshufps	$85, %xmm2, %xmm2, %xmm0
	vaddps	%xmm2, %xmm0, %xmm0
	testb	$7, %cl
	je	.L18
	movq	%rcx, %rax
	andq	$-8, %rax
	vzeroupper
.L3:
	movq	%rcx, %rdx
	subq	%rax, %rdx
	leaq	-1(%rdx), %r8
	cmpq	$2, %r8
	jbe	.L7
	vmovups	(%rsi,%rax,4), %xmm0
	vmulps	(%rdi,%rax,4), %xmm0, %xmm0
	vaddps	%xmm1, %xmm0, %xmm0
	vmovhlps	%xmm0, %xmm0, %xmm1
	vaddps	%xmm0, %xmm1, %xmm1
	vshufps	$85, %xmm1, %xmm1, %xmm0
	vaddps	%xmm1, %xmm0, %xmm0
	testb	$3, %dl
	je	.L1
	andq	$-4, %rdx
	addq	%rdx, %rax
.L7:
	vmovss	(%rdi,%rax,4), %xmm1
	vmulss	(%rsi,%rax,4), %xmm1, %xmm1
	leaq	1(%rax), %rdx
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rcx, %rdx
	jnb	.L1
	vmovss	4(%rsi,%rax,4), %xmm1
	vmulss	4(%rdi,%rax,4), %xmm1, %xmm1
	leaq	2(%rax), %rdx
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rcx, %rdx
	jnb	.L1
	vmovss	8(%rdi,%rax,4), %xmm1
	vmulss	8(%rsi,%rax,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	ret
	.p2align 4,,10
	.p2align 3
.L18:
	vzeroupper
.L1:
	ret
	.p2align 4,,10
	.p2align 3
.L9:
	vxorps	%xmm0, %xmm0, %xmm0
	ret
.L10:
	vxorps	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
	vxorps	%xmm0, %xmm0, %xmm0
	jmp	.L3
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
