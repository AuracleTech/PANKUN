[org 0x7c00]

char:
	cmp bx, 10 ; Compare the amount of character printed to 10
	je exit ; If amount of chars printed is equal to 10, exit
	mov ah, 0 ; Initialize ah to 0
	int 0x16 ; BIOS interrupt keyboard input function
	mov ah, 0x0e ; call BIOS interrupt
	int 0x10 ; BIOS interrupt print char
	inc bx ; Increase the amount of chars printed
	jmp char ; Recursive call

exit:
	jmp $
times 510-($-$$) db 0
db 0x55, 0xaa