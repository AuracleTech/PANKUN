mov ah, 0x0e
mov al, 'H' ; ascii
int 0x10

mov ah, 0x0e
mov al, 0b01001000 ; binary
int 0x10

mov ah, 0x0e
mov al, 0x48 ; hexadecimal
int 0x10

mov ah, 0x0e
mov al, 72 ; decimal
int 0x10

mov ah, 0x0e
mov al, 0o110 ; octal
int 0x10
jmp $

times 510-($-$$) db 0
db 0x55, 0xaa