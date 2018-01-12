	.file	"chars.c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	movb	$65, -1(%rbp)
	movb	$66, -2(%rbp)
	movb	$-125, -3(%rbp)
	popq	%rbp
	ret
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.8.2 20140206 (prerelease)"
	.section	.note.GNU-stack,"",@progbits
