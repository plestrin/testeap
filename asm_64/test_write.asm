SECTION .text

global test_write
test_write:
	xbegin error
	mov byte [rdi], 0x31
	xend
error:
	ret
