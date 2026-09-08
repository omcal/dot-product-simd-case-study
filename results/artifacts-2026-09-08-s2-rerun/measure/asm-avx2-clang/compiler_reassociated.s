	.file	"dot_product_reassociated.cpp"
	.text
	.globl	_Z33dot_product_compiler_reassociatedPKfS0_m # -- Begin function _Z33dot_product_compiler_reassociatedPKfS0_m
	.p2align	4
	.type	_Z33dot_product_compiler_reassociatedPKfS0_m,@function
_Z33dot_product_compiler_reassociatedPKfS0_m: # @_Z33dot_product_compiler_reassociatedPKfS0_m
	.cfi_startproc
# %bb.0:
	testq	%rdx, %rdx
	je	.LBB0_1
# %bb.2:
	cmpq	$3, %rdx
	ja	.LBB0_5
# %bb.3:
	vxorps	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	jmp	.LBB0_4
.LBB0_1:
	vxorps	%xmm0, %xmm0, %xmm0
	retq
.LBB0_5:
	cmpq	$32, %rdx
	jae	.LBB0_7
# %bb.6:
	vxorps	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	jmp	.LBB0_11
.LBB0_7:
	movq	%rdx, %rax
	andq	$-32, %rax
	vxorps	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	vxorps	%xmm1, %xmm1, %xmm1
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	.p2align	4
.LBB0_8:                                # =>This Inner Loop Header: Depth=1
	vmovups	(%rsi,%rcx,4), %ymm4
	vmovups	32(%rsi,%rcx,4), %ymm5
	vmovups	64(%rsi,%rcx,4), %ymm6
	vmovups	96(%rsi,%rcx,4), %ymm7
	vmulps	(%rdi,%rcx,4), %ymm4, %ymm4
	vaddps	%ymm0, %ymm4, %ymm0
	vmulps	32(%rdi,%rcx,4), %ymm5, %ymm4
	vaddps	%ymm1, %ymm4, %ymm1
	vmulps	64(%rdi,%rcx,4), %ymm6, %ymm4
	vmulps	96(%rdi,%rcx,4), %ymm7, %ymm5
	vaddps	%ymm2, %ymm4, %ymm2
	vaddps	%ymm3, %ymm5, %ymm3
	addq	$32, %rcx
	cmpq	%rcx, %rax
	jne	.LBB0_8
# %bb.9:
	vaddps	%ymm0, %ymm1, %ymm0
	vaddps	%ymm0, %ymm2, %ymm0
	vaddps	%ymm0, %ymm3, %ymm0
	vextractf128	$1, %ymm0, %xmm1
	vaddps	%xmm1, %xmm0, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rax, %rdx
	je	.LBB0_15
# %bb.10:
	testb	$28, %dl
	je	.LBB0_4
.LBB0_11:
	movq	%rax, %rcx
	movq	%rdx, %rax
	andq	$-4, %rax
	vxorps	%xmm1, %xmm1, %xmm1
	vblendps	$1, %xmm0, %xmm1, %xmm0         # xmm0 = xmm0[0],xmm1[1,2,3]
	.p2align	4
.LBB0_12:                               # =>This Inner Loop Header: Depth=1
	vmovups	(%rsi,%rcx,4), %xmm1
	vmulps	(%rdi,%rcx,4), %xmm1, %xmm1
	vaddps	%xmm0, %xmm1, %xmm0
	addq	$4, %rcx
	cmpq	%rcx, %rax
	jne	.LBB0_12
# %bb.13:
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddss	%xmm1, %xmm0, %xmm0
	jmp	.LBB0_14
.LBB0_4:
	vmovss	(%rsi,%rax,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vmulss	(%rdi,%rax,4), %xmm1, %xmm1
	vaddss	%xmm0, %xmm1, %xmm0
	incq	%rax
.LBB0_14:
	cmpq	%rax, %rdx
	jne	.LBB0_4
.LBB0_15:
	vzeroupper
	retq
.Lfunc_end0:
	.size	_Z33dot_product_compiler_reassociatedPKfS0_m, .Lfunc_end0-_Z33dot_product_compiler_reassociatedPKfS0_m
	.cfi_endproc
                                        # -- End function
	.ident	"Ubuntu clang version 21.1.8 (6ubuntu1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
