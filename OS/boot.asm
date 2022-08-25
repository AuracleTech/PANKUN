[org 0x7c00] ; The BIOS sets the origin of the bootloader to 0x7c00
mov ah, 0x0e
; variable name is a pointer to the beginning of the variable
; so in order to get the first character we need to dereference the pointer
; this can be done using square brackets
mov bx, motivational_text

print_string:
    mov al, [bx]
    cmp al, 0
    je exit
    int 0x10
    inc bx
    jmp print_string

exit:
    jmp $

motivational_text:
    db "Please do not crash", 0

times 510-($-$$) db 0
db 0x55, 0xaa