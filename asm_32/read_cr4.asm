SECTION .text

global read_cr4_smep
read_cr4_smep:
	mov eax, cr4
	shr eax, 20
	and eax, 0x1
	ret

global read_cr4_smap
read_cr4_smap:
	mov eax, cr4
	shr eax, 21
	and eax, 0x1
	ret
