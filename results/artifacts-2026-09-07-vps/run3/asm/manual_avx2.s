	.file	"dot_product_avx2.cpp"
	.text
	.p2align 4
	.globl	_Z16dot_product_avx2PKfS0_m
	.type	_Z16dot_product_avx2PKfS0_m, @function
_Z16dot_product_avx2PKfS0_m:
.LFB7311:
	.cfi_startproc
	endbr64
	movq	%rdx, %r9
	cmpq	$31, %rdx
	jbe	.L13
	leaq	-32(%r9), %r8
	vxorps	%xmm4, %xmm4, %xmm4
	movq	%rsi, %rax
	movq	%rdi, %rdx
	vmovaps	%ymm4, %ymm2
	vmovaps	%ymm4, %ymm3
	vmovaps	%ymm4, %ymm0
	movq	%r8, %rcx
	shrq	$5, %rcx
	salq	$7, %rcx
	leaq	128(%rsi,%rcx), %rcx
	.p2align 4
	.p2align 3
.L3:
	vmovups	(%rdx), %ymm1
	vmulps	(%rax), %ymm1, %ymm1
	subq	$-128, %rax
	subq	$-128, %rdx
	vaddps	%ymm1, %ymm0, %ymm0
	vmovups	-96(%rdx), %ymm1
	vmulps	-96(%rax), %ymm1, %ymm1
	vaddps	%ymm1, %ymm3, %ymm3
	vmovups	-64(%rax), %ymm1
	vmulps	-64(%rdx), %ymm1, %ymm1
	vaddps	%ymm1, %ymm2, %ymm2
	vmovups	-32(%rax), %ymm1
	vmulps	-32(%rdx), %ymm1, %ymm1
	vaddps	%ymm1, %ymm4, %ymm4
	cmpq	%rcx, %rax
	jne	.L3
	andq	$-32, %r8
	movq	%r9, %rdx
	leaq	32(%r8), %rax
	andl	$31, %edx
.L2:
	cmpq	$7, %rdx
	jbe	.L4
	leaq	-8(%r9), %r8
	leaq	8(%rax), %rdx
	subq	%rax, %r8
	movq	%rdx, %r10
	movq	%r8, %rcx
	andq	$-8, %rcx
	addq	%rdx, %rcx
	jmp	.L5
	.p2align 5
	.p2align 4,,10
	.p2align 3
.L26:
	addq	$8, %rdx
.L5:
	vmovups	(%rdi,%rax,4), %ymm1
	vmulps	(%rsi,%rax,4), %ymm1, %ymm1
	movq	%rdx, %rax
	vaddps	%ymm1, %ymm0, %ymm0
	cmpq	%rcx, %rdx
	jne	.L26
	andq	$-8, %r8
	leaq	(%r8,%r10), %rax
.L4:
	vaddps	%ymm3, %ymm0, %ymm0
	vaddps	%ymm4, %ymm2, %ymm2
	vxorps	%xmm3, %xmm3, %xmm3
	vaddps	%ymm0, %ymm2, %ymm2
	vaddss	%xmm3, %xmm2, %xmm0
	vshufps	$85, %xmm2, %xmm2, %xmm3
	vshufps	$255, %xmm2, %xmm2, %xmm1
	vaddss	%xmm3, %xmm0, %xmm0
	vunpckhps	%xmm2, %xmm2, %xmm3
	vextractf128	$0x1, %ymm2, %xmm2
	vaddss	%xmm3, %xmm0, %xmm0
	vaddss	%xmm1, %xmm0, %xmm0
	vshufps	$85, %xmm2, %xmm2, %xmm1
	vaddss	%xmm2, %xmm0, %xmm0
	vaddss	%xmm1, %xmm0, %xmm0
	vunpckhps	%xmm2, %xmm2, %xmm1
	vshufps	$255, %xmm2, %xmm2, %xmm2
	vaddss	%xmm1, %xmm0, %xmm0
	vaddss	%xmm2, %xmm0, %xmm0
	cmpq	%r9, %rax
	jnb	.L1
	movq	%r9, %r10
	subq	%rax, %r10
	leaq	-1(%r10), %rdx
	cmpq	$6, %rdx
	jbe	.L14
	movq	%r10, %r8
	leaq	0(,%rax,4), %rcx
	xorl	%edx, %edx
	shrq	$3, %r8
	leaq	(%rdi,%rcx), %r11
	addq	%rsi, %rcx
	salq	$5, %r8
	.p2align 4
	.p2align 3
.L8:
	vmovups	(%r11,%rdx), %ymm1
	vmulps	(%rcx,%rdx), %ymm1, %ymm1
	addq	$32, %rdx
	vaddss	%xmm1, %xmm0, %xmm0
	vshufps	$85, %xmm1, %xmm1, %xmm3
	vshufps	$255, %xmm1, %xmm1, %xmm2
	vaddss	%xmm0, %xmm3, %xmm3
	vunpckhps	%xmm1, %xmm1, %xmm0
	vextractf128	$0x1, %ymm1, %xmm1
	vaddss	%xmm3, %xmm0, %xmm0
	vaddss	%xmm0, %xmm2, %xmm2
	vaddss	%xmm2, %xmm1, %xmm0
	vshufps	$85, %xmm1, %xmm1, %xmm2
	vaddss	%xmm0, %xmm2, %xmm2
	vunpckhps	%xmm1, %xmm1, %xmm0
	vshufps	$255, %xmm1, %xmm1, %xmm1
	vaddss	%xmm2, %xmm0, %xmm0
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rdx, %r8
	jne	.L8
	testb	$7, %r10b
	je	.L1
	movq	%r10, %rcx
	andq	$-8, %rcx
	leaq	(%rax,%rcx), %rdx
.L7:
	subq	%rcx, %r10
	leaq	-1(%r10), %r8
	cmpq	$2, %r8
	jbe	.L11
	addq	%rcx, %rax
	vmovups	(%rdi,%rax,4), %xmm1
	vmulps	(%rsi,%rax,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vshufps	$85, %xmm1, %xmm1, %xmm2
	vaddss	%xmm2, %xmm0, %xmm0
	vunpckhps	%xmm1, %xmm1, %xmm2
	vshufps	$255, %xmm1, %xmm1, %xmm1
	vaddss	%xmm2, %xmm0, %xmm0
	vaddss	%xmm1, %xmm0, %xmm0
	testb	$3, %r10b
	je	.L1
	andq	$-4, %r10
	addq	%r10, %rdx
.L11:
	vmovss	(%rsi,%rdx,4), %xmm1
	vmulss	(%rdi,%rdx,4), %xmm1, %xmm1
	leaq	1(%rdx), %rax
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%r9, %rax
	jnb	.L1
	vmovss	4(%rsi,%rdx,4), %xmm1
	vmulss	4(%rdi,%rdx,4), %xmm1, %xmm1
	leaq	2(%rdx), %rax
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%r9, %rax
	jnb	.L1
	vmovss	8(%rsi,%rdx,4), %xmm1
	vmulss	8(%rdi,%rdx,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
.L1:
	vzeroupper
	ret
	.p2align 4,,10
	.p2align 3
.L13:
	vxorps	%xmm4, %xmm4, %xmm4
	xorl	%eax, %eax
	vmovaps	%ymm4, %ymm2
	vmovaps	%ymm4, %ymm3
	vmovaps	%ymm4, %ymm0
	jmp	.L2
.L14:
	movq	%rax, %rdx
	xorl	%ecx, %ecx
	jmp	.L7
	.cfi_endproc
.LFE7311:
	.size	_Z16dot_product_avx2PKfS0_m, .-_Z16dot_product_avx2PKfS0_m
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
