mov ah, 0x0e ; switch to Teletype mode
mov al, 'H' ; print H
int 0x10 ; BIOS interrupt
jmp $

times 510-($-$$) db 0
db 0x55, 0xaa