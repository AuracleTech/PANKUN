[org 0x7c00]
mov [BOOT_DISK], dl

cli ; clear interrupts flags and disable interrupts
lgdt [GDT_descriptor] ; load GDT
mov eax, cr0 ;
or eax, 1    ; enable paging by setting bit 0 of CR0 to 1
mov cr0, eax ;
jmp CODE_SEG:start_protected_mode

GDT_start: ; must be at the end of real mode code
    GDT_null: ; at the beginning of GDT there must be a null descriptor
        dd 0x0 ; the size of the descriptor must be 00000000
        dd 0x0 ; the descriptor is null so ends with 00000000

    GDT_code: ; descriptor for code segment
        dw 0xffff ; limit
        dw 0x0 ; base address
        db 0x0 ; base present
        db 0b10011010 ; present, privilege, type = 1001 type flags = 1010
        db 0b11001111 ; other flags = 1100, granularity = 1111
        db 0x0 ; the last 8 bits are reserved and must be zero

    GDT_data: ; descriptor for data segment
        dw 0xffff ; limit
		dw 0x0 ; base address
		db 0x0 ; base present
		db 0b10010010 ; present, privilege, type = 0001 type flags
		db 0b11001111 ; other flags = 1100, granularity = 1111
		db 0x0 ; the last 8 bits are reserved and must be zero

GDT_end:
	; placeholder

GDT_descriptor:
    dw GDT_end - GDT_start - 1 ; size of GDT
    dd GDT_start ; address of GDT's start

CODE_SEG equ GDT_code - GDT_start
DATA_SEG equ GDT_data - GDT_start

[bits 32]
start_protected_mode:
    mov al, 'A' ; print A
    mov ah, 0xe0 ; black foreground light yellow background
    mov [0xb8000], ax ; set to video memory location
    jmp $

BOOT_DISK: db 0

times 510-($-$$) db 0
dw 0xaa55