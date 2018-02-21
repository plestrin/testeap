SECTION .text

extern has_smap

global _start
_start:
	call has_smap
	mov rdi, rax
	mov rax, 60
	syscall
