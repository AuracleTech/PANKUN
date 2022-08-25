mov ah, 0x0e
mov al, 65 ; Print A
int 0x10

inc al ; Increment A to B
int 0x10

inc al ; Increment B to C
int 0x10

inc al ; Increment C to D
int 0x10

inc al ; Increment D to E
int 0x10
jmp $

times 510-($-$$) db 0
db 0x55, 0xaa