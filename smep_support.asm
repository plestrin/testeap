SECTION .text

extern has_smep

global _start
_start:
	call has_smep
	mov rdi, rax
	mov rax, 60
	syscall
