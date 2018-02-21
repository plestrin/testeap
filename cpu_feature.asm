SECTION .text

global has_smap
has_smap:
	push rbx
	mov rax, 7
	xor rcx, rcx
	cpuid
	shr rbx, 20
	and rbx, 0x1
	mov rax, rbx
	pop rbx
	ret

global has_tsx
has_tsx:
	push rbx
	mov rax, 7
	xor rcx, rcx
	cpuid
	shr rbx, 11
	and rbx, 0x1
	mov rax, rbx
	pop rbx
	ret