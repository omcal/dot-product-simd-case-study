	.file	"dot_product_avx2.cpp"
	.text
	.p2align 4
	.globl	_Z16dot_product_avx2PKfS0_m
	.type	_Z16dot_product_avx2PKfS0_m, @function
_Z16dot_product_avx2PKfS0_m:
.LFB6454:
	.cfi_startproc
	endbr64
	movq	%rsi, %rcx
	movq	%rdx, %r8
	cmpq	$31, %rdx
	jbe	.L13
	leaq	-32(%r8), %r9
	movq	%rsi, %rax
	vxorps	%xmm2, %xmm2, %xmm2
	movq	%rdi, %rdx
	vmovaps	%ymm2, %ymm4
	vmovaps	%ymm2, %ymm3
	vmovaps	%ymm2, %ymm0
	movq	%r9, %rsi
	shrq	$5, %rsi
	salq	$7, %rsi
	leaq	128(%rcx,%rsi), %rsi
	.p2align 4,,10
	.p2align 3
.L3:
	vmovups	(%rax), %ymm5
	vmulps	(%rdx), %ymm5, %ymm1
	subq	$-128, %rax
	subq	$-128, %rdx
	vmovups	-96(%rax), %ymm6
	vmovups	-64(%rdx), %ymm7
	vmovups	-32(%rdx), %ymm5
	vaddps	%ymm1, %ymm0, %ymm0
	vmulps	-96(%rdx), %ymm6, %ymm1
	vaddps	%ymm1, %ymm3, %ymm3
	vmulps	-64(%rax), %ymm7, %ymm1
	vaddps	%ymm1, %ymm4, %ymm4
	vmulps	-32(%rax), %ymm5, %ymm1
	vaddps	%ymm1, %ymm2, %ymm2
	cmpq	%rsi, %rax
	jne	.L3
	vaddps	%ymm4, %ymm2, %ymm2
	movq	%r8, %rdx
	andq	$-32, %r9
	andl	$31, %edx
	leaq	32(%r9), %rax
.L2:
	cmpq	$7, %rdx
	jbe	.L4
	leaq	-8(%r8), %r9
	leaq	8(%rax), %rdx
	subq	%rax, %r9
	movq	%rdx, %r10
	movq	%r9, %rsi
	andq	$-8, %rsi
	addq	%rdx, %rsi
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L26:
	addq	$8, %rdx
.L5:
	vmovups	(%rcx,%rax,4), %ymm4
	vmulps	(%rdi,%rax,4), %ymm4, %ymm1
	movq	%rdx, %rax
	vaddps	%ymm1, %ymm0, %ymm0
	cmpq	%rdx, %rsi
	jne	.L26
	andq	$-8, %r9
	leaq	(%r9,%r10), %rax
.L4:
	vaddps	%ymm3, %ymm0, %ymm1
	vxorps	%xmm3, %xmm3, %xmm3
	vaddps	%ymm2, %ymm1, %ymm1
	vaddss	%xmm3, %xmm1, %xmm2
	vshufps	$85, %xmm1, %xmm1, %xmm3
	vshufps	$255, %xmm1, %xmm1, %xmm0
	vaddss	%xmm2, %xmm3, %xmm3
	vunpckhps	%xmm1, %xmm1, %xmm2
	vextractf128	$0x1, %ymm1, %xmm1
	vaddss	%xmm3, %xmm2, %xmm2
	vaddss	%xmm2, %xmm0, %xmm0
	vshufps	$85, %xmm1, %xmm1, %xmm2
	vaddss	%xmm0, %xmm1, %xmm0
	vaddss	%xmm0, %xmm2, %xmm2
	vunpckhps	%xmm1, %xmm1, %xmm0
	vshufps	$255, %xmm1, %xmm1, %xmm1
	vaddss	%xmm2, %xmm0, %xmm0
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%r8, %rax
	jnb	.L1
	movq	%r8, %rsi
	subq	%rax, %rsi
	leaq	-1(%rsi), %rdx
	cmpq	$6, %rdx
	jbe	.L14
	movq	%rsi, %r10
	leaq	0(,%rax,4), %r9
	xorl	%edx, %edx
	shrq	$3, %r10
	leaq	(%rdi,%r9), %r11
	addq	%rcx, %r9
	salq	$5, %r10
	.p2align 4,,10
	.p2align 3
.L8:
	vmovups	(%r9,%rdx), %ymm6
	vmulps	(%r11,%rdx), %ymm6, %ymm1
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
	cmpq	%rdx, %r10
	jne	.L8
	movq	%rsi, %r9
	andq	$-8, %r9
	leaq	(%rax,%r9), %rdx
	testb	$7, %sil
	je	.L1
.L7:
	subq	%r9, %rsi
	leaq	-1(%rsi), %r10
	cmpq	$2, %r10
	jbe	.L11
	addq	%r9, %rax
	vmovups	(%rcx,%rax,4), %xmm7
	vmulps	(%rdi,%rax,4), %xmm7, %xmm1
	movq	%rsi, %rax
	andq	$-4, %rax
	addq	%rax, %rdx
	andl	$3, %esi
	vaddss	%xmm0, %xmm1, %xmm0
	vshufps	$85, %xmm1, %xmm1, %xmm2
	vaddss	%xmm0, %xmm2, %xmm2
	vunpckhps	%xmm1, %xmm1, %xmm0
	vshufps	$255, %xmm1, %xmm1, %xmm1
	vaddss	%xmm2, %xmm0, %xmm0
	vaddss	%xmm1, %xmm0, %xmm0
	je	.L1
.L11:
	vmovss	(%rcx,%rdx,4), %xmm1
	vmulss	(%rdi,%rdx,4), %xmm1, %xmm1
	leaq	1(%rdx), %rsi
	leaq	0(,%rdx,4), %rax
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%r8, %rsi
	jnb	.L1
	vmovss	4(%rcx,%rax), %xmm1
	vmulss	4(%rdi,%rax), %xmm1, %xmm1
	addq	$2, %rdx
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%r8, %rdx
	jnb	.L1
	vmovss	8(%rcx,%rax), %xmm1
	vmulss	8(%rdi,%rax), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
.L1:
	vzeroupper
	ret
	.p2align 4,,10
	.p2align 3
.L13:
	vxorps	%xmm2, %xmm2, %xmm2
	xorl	%eax, %eax
	vmovaps	%ymm2, %ymm3
	vmovaps	%ymm2, %ymm0
	jmp	.L2
.L14:
	movq	%rax, %rdx
	xorl	%r9d, %r9d
	jmp	.L7
	.cfi_endproc
.LFE6454:
	.size	_Z16dot_product_avx2PKfS0_m, .-_Z16dot_product_avx2PKfS0_m
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
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
