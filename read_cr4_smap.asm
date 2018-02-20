SECTION .text

global read_cr4_smap
read_cr4_smap:
	mov rax, cr4
	shr rax, 21
	and rax, 0x1
	ret
