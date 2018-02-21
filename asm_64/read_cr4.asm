SECTION .text

global read_cr4_smep
read_cr4_smep:
	mov rax, cr4
	shr rax, 20
	and rax, 0x1
	ret

global read_cr4_smap
read_cr4_smap:
	mov rax, cr4
	shr rax, 21
	and rax, 0x1
	ret
