SECTION .text

global test_write
test_write:
	mov eax, [esp + 4]
	xbegin error
	mov byte [eax], 0x31
	xend
error:
	ret
