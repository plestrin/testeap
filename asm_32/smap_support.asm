SECTION .text

extern has_smap

global _start
_start:
	call has_smap
	mov ebx, eax
	mov eax, 1
	int 0x80
