[org 0x7c00]
mov [BOOT_DISK], dl ; get and set the boot disk value

; setting up the stack

xor ax, ax                          
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp

mov bx, 0x7e00 ; Where to read the data

; reading the disk

mov ah, 2 ; set the ah register to match with the 02 function code (write to STDOUT)
mov al, 1 ; Number of sectors to read
mov ch, 0 ; Cylinder (starts at 0)
mov cl, 2 ; Sector number (starts at 1)
mov dh, 0 ; Head number (starts at 0)
mov dl, [BOOT_DISK] ; Drive number (starts at 0)
int 0x13 ; BIOS read disk

; printing what is in the next sector

mov ah, 0x0e
mov al, [0x7e00] ; Located data is at 0x7c00 + 0x200 = 0x7e00
int 0x10
jmp $
BOOT_DISK: db 0

; magic padding

times 510-($-$$) db 0 ; file size padding to 510 bytes
dw 0xaa55 ; signature to make sure the file is valid

; register A at 0x7e00 (at 512 bytes, right after the boot sector)

times 512 db 'A'