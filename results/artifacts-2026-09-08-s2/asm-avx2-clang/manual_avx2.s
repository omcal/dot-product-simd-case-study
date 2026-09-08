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
# %bb.10:
	vxorps	%xmm1, %xmm1, %xmm1
	xorl	%eax, %eax
	movq	%rdx, %rcx
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm0, %xmm0, %xmm0
	.p2align	4
.LBB0_11:                               # =>This Inner Loop Header: Depth=1
	vmovups	(%rdi,%rax,4), %ymm4
	vmovups	32(%rdi,%rax,4), %ymm5
	vmovups	64(%rdi,%rax,4), %ymm6
	vmovups	96(%rdi,%rax,4), %ymm7
	vmulps	(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm1, %ymm1
	vmulps	32(%rsi,%rax,4), %ymm5, %ymm4
	vmulps	64(%rsi,%rax,4), %ymm6, %ymm5
	vaddps	%ymm4, %ymm3, %ymm3
	vaddps	%ymm5, %ymm2, %ymm2
	vmulps	96(%rsi,%rax,4), %ymm7, %ymm4
	vaddps	%ymm4, %ymm0, %ymm0
	addq	$32, %rax
	addq	$-32, %rcx
	cmpq	$31, %rcx
	ja	.LBB0_11
# %bb.2:
	movq	%rdx, %rcx
	subq	%rax, %rcx
	cmpq	$8, %rcx
	jb	.LBB0_4
	.p2align	4
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	vmovups	(%rdi,%rax,4), %ymm4
	vmulps	(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	%ymm4, %ymm1, %ymm1
	addq	$8, %rax
	addq	$-8, %rcx
	cmpq	$7, %rcx
	ja	.LBB0_3
.LBB0_4:
	vaddps	%ymm1, %ymm3, %ymm1
	vaddps	%ymm2, %ymm0, %ymm0
	vaddps	%ymm1, %ymm0, %ymm0
	vxorps	%xmm1, %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm1
	vmovshdup	%xmm0, %xmm2            # xmm2 = xmm0[1,1,3,3]
	vaddss	%xmm2, %xmm1, %xmm1
	vshufpd	$1, %xmm0, %xmm0, %xmm2         # xmm2 = xmm0[1,0]
	vaddss	%xmm2, %xmm1, %xmm1
	vshufps	$255, %xmm0, %xmm0, %xmm2       # xmm2 = xmm0[3,3,3,3]
	vaddss	%xmm2, %xmm1, %xmm1
	vextractf128	$1, %ymm0, %xmm0
	vaddss	%xmm0, %xmm1, %xmm1
	vmovshdup	%xmm0, %xmm2            # xmm2 = xmm0[1,1,3,3]
	vaddss	%xmm2, %xmm1, %xmm1
	vshufpd	$1, %xmm0, %xmm0, %xmm2         # xmm2 = xmm0[1,0]
	vaddss	%xmm2, %xmm1, %xmm1
	vshufps	$255, %xmm0, %xmm0, %xmm0       # xmm0 = xmm0[3,3,3,3]
	vaddss	%xmm0, %xmm1, %xmm0
	movq	%rax, %rcx
	subq	%rdx, %rcx
	jae	.LBB0_9
# %bb.5:
	movl	%edx, %r8d
	subl	%eax, %r8d
	andl	$3, %r8d
	je	.LBB0_7
	.p2align	4
.LBB0_6:                                # =>This Inner Loop Header: Depth=1
	vmovss	(%rdi,%rax,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vmulss	(%rsi,%rax,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	incq	%rax
	decq	%r8
	jne	.LBB0_6
.LBB0_7:
	cmpq	$-4, %rcx
	ja	.LBB0_9
	.p2align	4
.LBB0_8:                                # =>This Inner Loop Header: Depth=1
	vmovss	(%rdi,%rax,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vmovss	4(%rdi,%rax,4), %xmm2           # xmm2 = mem[0],zero,zero,zero
	vmulss	(%rsi,%rax,4), %xmm1, %xmm1
	vmulss	4(%rsi,%rax,4), %xmm2, %xmm2
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	8(%rdi,%rax,4), %xmm1           # xmm1 = mem[0],zero,zero,zero
	vmulss	8(%rsi,%rax,4), %xmm1, %xmm1
	vaddss	%xmm2, %xmm0, %xmm0
	vmovss	12(%rdi,%rax,4), %xmm2          # xmm2 = mem[0],zero,zero,zero
	vmulss	12(%rsi,%rax,4), %xmm2, %xmm2
	vaddss	%xmm1, %xmm0, %xmm0
	vaddss	%xmm2, %xmm0, %xmm0
	addq	$4, %rax
	cmpq	%rax, %rdx
	jne	.LBB0_8
.LBB0_9:
	vzeroupper
	retq
.LBB0_1:
	vxorps	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm1, %xmm1, %xmm1
	movq	%rdx, %rcx
	subq	%rax, %rcx
	cmpq	$8, %rcx
	jae	.LBB0_3
	jmp	.LBB0_4
.Lfunc_end0:
	.size	_Z16dot_product_avx2PKfS0_m, .Lfunc_end0-_Z16dot_product_avx2PKfS0_m
	.cfi_endproc
                                        # -- End function
	.ident	"Ubuntu clang version 21.1.8 (6ubuntu1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
