[org 0x7c00]
KERNEL_LOCATION  equ 0x1000


mov [BOOT_DISK], dl

; setting up the stack

xor ax, ax
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp

mov bx, KERNEL_LOCATION ; Where to read the data
mov dh, 2 ; Read 2 sectors

; reading the disk

mov ah, 0x02 ; set the ah register to match with the 02 function code (write to STDOUT)
mov al, dh ; Number of sectors to read
mov ch, 0x00 ; Cylinder (starts at 0)
mov dh, 0x00 ; Head number (starts at 0)
mov cl, 0x02 ; Sector number (starts at 1)
mov dl, [BOOT_DISK] ; Drive number (starts at 0)
int 0x13 ; BIOS read disk

; clearing the screen

mov ah, 0x0 ; set the ah register to match with the 00 function code (clear screen)
mov al, 0x3 ; Number of lines to clear
int 0x10 ; BIOS clear screen

; GDT for protected mode

CODE_SEG equ GDT_code - GDT_start
DATA_SEG equ GDT_data - GDT_start

cli ; clear interrupts flags and disable interrupts
lgdt [GDT_descriptor] ; load GDT
mov eax, cr0 ;
or eax, 1    ; enable paging by setting bit 0 of CR0 to 1
mov cr0, eax ;
jmp CODE_SEG:start_protected_mode
jmp $

BOOT_DISK: db 0

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

[bits 32]
start_protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    mov ebp, 0x90000 ; 32 bit stack base pointer
    mov esp, ebp
    
    jmp KERNEL_LOCATION ; jump to the kernel

; magic padding

times 510-($-$$) db 0
dw 0xaa55