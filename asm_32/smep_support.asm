SECTION .text

extern has_smep

global _start
_start:
	call has_smep
	mov ebx, eax
	mov eax, 1
	int 0x80
