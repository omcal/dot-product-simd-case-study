	.file	"dot_product.cpp"
	.text
	.p2align 4
	.globl	_Z18dot_product_scalarPKfS0_m
	.type	_Z18dot_product_scalarPKfS0_m, @function
_Z18dot_product_scalarPKfS0_m:
.LFB1233:
	.cfi_startproc
	endbr64
	testq	%rdx, %rdx
	je	.L4
	xorl	%eax, %eax
	vxorps	%xmm1, %xmm1, %xmm1
	.p2align 5
	.p2align 4
	.p2align 3
.L3:
	vmovss	(%rdi,%rax,4), %xmm0
	vmulss	(%rsi,%rax,4), %xmm0, %xmm0
	incq	%rax
	vaddss	%xmm0, %xmm1, %xmm1
	cmpq	%rax, %rdx
	jne	.L3
	vmovaps	%xmm1, %xmm0
	ret
	.p2align 4
	.p2align 3
.L4:
	vxorps	%xmm1, %xmm1, %xmm1
	vmovaps	%xmm1, %xmm0
	ret
	.cfi_endproc
.LFE1233:
	.size	_Z18dot_product_scalarPKfS0_m, .-_Z18dot_product_scalarPKfS0_m
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
