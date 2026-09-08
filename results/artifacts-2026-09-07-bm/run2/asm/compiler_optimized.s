	.file	"dot_product_optimized.cpp"
	.text
	.p2align 4
	.globl	_Z30dot_product_compiler_optimizedPKfS0_m
	.type	_Z30dot_product_compiler_optimizedPKfS0_m, @function
_Z30dot_product_compiler_optimizedPKfS0_m:
.LFB1254:
	.cfi_startproc
	endbr64
	movq	%rsi, %rcx
	testq	%rdx, %rdx
	je	.L9
	leaq	-1(%rdx), %rax
	cmpq	$14, %rax
	jbe	.L10
	movq	%rdx, %rsi
	xorl	%eax, %eax
	vxorps	%xmm0, %xmm0, %xmm0
	shrq	$4, %rsi
	salq	$6, %rsi
	.p2align 4
	.p2align 3
.L4:
	vmovups	(%rdi,%rax), %zmm5
	vmulps	(%rcx,%rax), %zmm5, %zmm1
	addq	$64, %rax
	vshufps	$85, %xmm1, %xmm1, %xmm4
	vshufps	$255, %xmm1, %xmm1, %xmm3
	vaddss	%xmm1, %xmm0, %xmm0
	valignd	$7, %ymm1, %ymm1, %ymm2
	vaddss	%xmm4, %xmm0, %xmm0
	vunpckhps	%xmm1, %xmm1, %xmm4
	vaddss	%xmm4, %xmm0, %xmm0
	vaddss	%xmm3, %xmm0, %xmm0
	vextractf32x4	$1, %ymm1, %xmm3
	vaddss	%xmm3, %xmm0, %xmm0
	valignd	$5, %ymm1, %ymm1, %ymm3
	vaddss	%xmm3, %xmm0, %xmm0
	valignd	$6, %ymm1, %ymm1, %ymm3
	vextractf32x8	$0x1, %zmm1, %ymm1
	vaddss	%xmm3, %xmm0, %xmm0
	vshufps	$85, %xmm1, %xmm1, %xmm3
	vaddss	%xmm2, %xmm0, %xmm0
	vshufps	$255, %xmm1, %xmm1, %xmm2
	vaddss	%xmm1, %xmm0, %xmm0
	vaddss	%xmm3, %xmm0, %xmm0
	vunpckhps	%xmm1, %xmm1, %xmm3
	vaddss	%xmm3, %xmm0, %xmm0
	vaddss	%xmm2, %xmm0, %xmm0
	vextractf32x4	$1, %ymm1, %xmm2
	vaddss	%xmm2, %xmm0, %xmm0
	valignd	$5, %ymm1, %ymm1, %ymm2
	vaddss	%xmm2, %xmm0, %xmm0
	valignd	$6, %ymm1, %ymm1, %ymm2
	valignd	$7, %ymm1, %ymm1, %ymm1
	vaddss	%xmm2, %xmm0, %xmm0
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rax, %rsi
	jne	.L4
	movq	%rdx, %rax
	andq	$-16, %rax
	testb	$15, %dl
	je	.L24
.L3:
	movq	%rdx, %rsi
	subq	%rax, %rsi
	leaq	-1(%rsi), %r8
	cmpq	$6, %r8
	jbe	.L7
	vmovups	(%rdi,%rax,4), %ymm6
	vmulps	(%rcx,%rax,4), %ymm6, %ymm1
	movq	%rsi, %r8
	andq	$-8, %r8
	addq	%r8, %rax
	andl	$7, %esi
	vshufps	$85, %xmm1, %xmm1, %xmm3
	vshufps	$255, %xmm1, %xmm1, %xmm2
	vaddss	%xmm1, %xmm0, %xmm0
	vaddss	%xmm3, %xmm0, %xmm0
	vunpckhps	%xmm1, %xmm1, %xmm3
	vaddss	%xmm3, %xmm0, %xmm0
	vaddss	%xmm2, %xmm0, %xmm0
	vextractf32x4	$1, %ymm1, %xmm2
	vaddss	%xmm2, %xmm0, %xmm0
	valignd	$5, %ymm1, %ymm1, %ymm2
	vaddss	%xmm2, %xmm0, %xmm0
	valignd	$6, %ymm1, %ymm1, %ymm2
	valignd	$7, %ymm1, %ymm1, %ymm1
	vaddss	%xmm2, %xmm0, %xmm0
	vaddss	%xmm1, %xmm0, %xmm0
	je	.L24
.L7:
	leaq	0(,%rax,4), %rsi
	leaq	1(%rax), %r8
	vmovss	(%rdi,%rsi), %xmm1
	vmulss	(%rcx,%rsi), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rdx, %r8
	jnb	.L24
	vmovss	4(%rdi,%rsi), %xmm1
	vmulss	4(%rcx,%rsi), %xmm1, %xmm1
	leaq	2(%rax), %r8
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rdx, %r8
	jnb	.L24
	vmovss	8(%rdi,%rsi), %xmm1
	vmulss	8(%rcx,%rsi), %xmm1, %xmm1
	leaq	3(%rax), %r8
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rdx, %r8
	jnb	.L24
	vmovss	12(%rdi,%rsi), %xmm1
	vmulss	12(%rcx,%rsi), %xmm1, %xmm1
	leaq	4(%rax), %r8
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rdx, %r8
	jnb	.L24
	vmovss	16(%rdi,%rsi), %xmm1
	vmulss	16(%rcx,%rsi), %xmm1, %xmm1
	leaq	5(%rax), %r8
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rdx, %r8
	jnb	.L24
	vmovss	20(%rdi,%rsi), %xmm1
	vmulss	20(%rcx,%rsi), %xmm1, %xmm1
	addq	$6, %rax
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rdx, %rax
	jnb	.L24
	vmovss	24(%rdi,%rsi), %xmm1
	vmulss	24(%rcx,%rsi), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vzeroupper
	ret
	.p2align 4
	.p2align 3
.L24:
	vzeroupper
	ret
	.p2align 4
	.p2align 3
.L9:
	vxorps	%xmm0, %xmm0, %xmm0
	ret
.L10:
	xorl	%eax, %eax
	vxorps	%xmm0, %xmm0, %xmm0
	jmp	.L3
	.cfi_endproc
.LFE1254:
	.size	_Z30dot_product_compiler_optimizedPKfS0_m, .-_Z30dot_product_compiler_optimizedPKfS0_m
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
