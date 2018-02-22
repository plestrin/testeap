SECTION .text

global has_smap
has_smap:
	push ebx
	mov eax, 7
	xor ecx, ecx
	cpuid
	shr ebx, 20
	and ebx, 0x1
	mov eax, ebx
	pop ebx
	ret

global has_smep
has_smep
	push ebx
	mov eax, 7
	xor ecx, ecx
	cpuid
	shr ebx, 7
	and ebx, 0x1
	mov eax, ebx
	pop ebx
	ret

global has_tsx
has_tsx:
	push ebx
	mov eax, 7
	xor ecx, ecx
	cpuid
	shr ebx, 11
	and ebx, 0x1
	mov eax, ebx
	pop ebx
	ret
