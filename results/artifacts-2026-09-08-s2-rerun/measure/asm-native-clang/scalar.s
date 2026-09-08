	.file	"dot_product.cpp"
	.text
	.globl	_Z18dot_product_scalarPKfS0_m   # -- Begin function _Z18dot_product_scalarPKfS0_m
	.p2align	4
	.type	_Z18dot_product_scalarPKfS0_m,@function
_Z18dot_product_scalarPKfS0_m:          # @_Z18dot_product_scalarPKfS0_m
	.cfi_startproc
# %bb.0:
	testq	%rdx, %rdx
	je	.LBB0_1
# %bb.2:
	movl	%edx, %eax
	andl	$7, %eax
	cmpq	$8, %rdx
	jae	.LBB0_8
# %bb.3:
	vxorps	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	jmp	.LBB0_4
.LBB0_1:
	vxorps	%xmm0, %xmm0, %xmm0
	retq
.LBB0_8:
	andq	$-8, %rdx
	vxorps	%xmm0, %xmm0, %xmm0
	xorl	%ecx, %ecx
	.p2align	4
.LBB0_9:                                # =>This Inner Loop Header: Depth=1
	vmovss	(%rdi,%rcx,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vmovss	4(%rdi,%rcx,4), %xmm2           # xmm2 = mem[0],zero,zero,zero
	vmulss	(%rsi,%rcx,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmulss	4(%rsi,%rcx,4), %xmm2, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	8(%rdi,%rcx,4), %xmm1           # xmm1 = mem[0],zero,zero,zero
	vmulss	8(%rsi,%rcx,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	12(%rdi,%rcx,4), %xmm1          # xmm1 = mem[0],zero,zero,zero
	vmulss	12(%rsi,%rcx,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	16(%rdi,%rcx,4), %xmm1          # xmm1 = mem[0],zero,zero,zero
	vmulss	16(%rsi,%rcx,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	20(%rdi,%rcx,4), %xmm1          # xmm1 = mem[0],zero,zero,zero
	vmulss	20(%rsi,%rcx,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	24(%rdi,%rcx,4), %xmm1          # xmm1 = mem[0],zero,zero,zero
	vmulss	24(%rsi,%rcx,4), %xmm1, %xmm1
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	28(%rdi,%rcx,4), %xmm1          # xmm1 = mem[0],zero,zero,zero
	vmulss	28(%rsi,%rcx,4), %xmm1, %xmm1
	addq	$8, %rcx
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rcx, %rdx
	jne	.LBB0_9
.LBB0_4:
	testq	%rax, %rax
	je	.LBB0_7
# %bb.5:
	leaq	(%rsi,%rcx,4), %rdx
	leaq	(%rdi,%rcx,4), %rcx
	xorl	%esi, %esi
	.p2align	4
.LBB0_6:                                # =>This Inner Loop Header: Depth=1
	vmovss	(%rcx,%rsi,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vmulss	(%rdx,%rsi,4), %xmm1, %xmm1
	incq	%rsi
	vaddss	%xmm1, %xmm0, %xmm0
	cmpq	%rsi, %rax
	jne	.LBB0_6
.LBB0_7:
	retq
.Lfunc_end0:
	.size	_Z18dot_product_scalarPKfS0_m, .Lfunc_end0-_Z18dot_product_scalarPKfS0_m
	.cfi_endproc
                                        # -- End function
	.ident	"Ubuntu clang version 21.1.8 (6ubuntu1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
