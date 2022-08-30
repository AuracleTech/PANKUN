[org 0x7c00]

; create a stack
mov bp, 0x8000 ; set the stack base pointer to 0x8000 in memory
mov sp, bp ; set the stack top to the same location as stack base
mov bh, 'A' ; enter A into the stack
push bx ; push the high byte of the stack pointer onto the stack

mov bh, 'B' ; enter B into the stack
call print

pop bx ; pop the high byte of the stack pointer off the stack
call print

jmp end

print:
    mov ah, 0x0e
    mov al, bh
    int 0x10
	ret

end:
	jmp $
	times 510-($-$$) db 0
	db 0x55, 0xaa