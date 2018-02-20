SECTION .text

global main
main:
	push rbx
	mov rax, 7
	xor rcx, rcx
	cpuid
	shr rbx, 20
	and rbx, 0x1
	mov rax, rbx
	pop rbx
	ret
