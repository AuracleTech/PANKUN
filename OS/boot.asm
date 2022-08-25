mov ah, 0x0e
mov al, 65 ; set al as 65 which is A

loop:
    int 0x10
    inc al ; Increment al by 1
    cmp al, 'Z' + 1 ; If al is greater than Z then exit the loop
    je exit
    jmp loop

exit:
    jmp $

times 510-($-$$) db 0
db 0x55, 0xaa