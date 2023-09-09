bits 16
org 0x7c00

mov [BOOT_DISK], dl ; at boot time drive number is in dl register



; initializing registers
mov eax, 0
mov es, ax
mov ds, ax
mov ebx, eax
mov ecx, eax
mov edx, eax
mov bp, 0x8000 ; initializing stack
mov sp, bp



; cylinder number starts at 0
; head number starts at 0
; sector starts at 1!!


mov bx, 0x7e00 ; address to load data
mov ah, 2
mov al, 10 ; number of sectors
mov ch, 0 ;  low eight bits of cylinder number
mov dh, 0 ;  head number
mov cl, 2 ;  bits 0-5 sector. bits 6-7 high two bits of cylinder (hard disk only)
mov dl, [BOOT_DISK] ; drive number
int 0x13


jmp 0x7e00 ; jump to code we just loaded






BOOT_DISK: db 0


; padding boot sector with nop
times 510-($-$$) nop
dw 0xaa55

;
; New Sector
;


mov ah, 0
mov al, 0x13

int 0x10


mov ebx, 0xa0000
mov ah, 200
row_loop:
mov al, 0
column_loop:
mov [ebx], al
inc ebx
inc al
cmp al, 0
jne column_loop
add ebx, 64
dec ah
cmp ah, 0
jne row_loop


; Switching to protected mode


cli ; disable bios interrupts
lgdt [GDT_descriptor] ; load gdt

mov eax, cr0 ; set last bit of cr0 to 1 to switch to protected mode
or eax, 1
mov cr0, eax

jmp (code_descriptor - GDT_start):protected_code_start

; GDT (Global Descriptor Table)
GDT_start:
null_descriptor:
dd 0
dd 0
code_descriptor:
dw 0xffff
dw 0
db 0
db 0b10011010
db 0b11001111
db 0
data_descriptor:
dw 0xffff
dw 0
db 0
db 0b10010010
db 0b11001111
db 0
GDT_end:

GDT_descriptor:
dw GDT_end - GDT_start - 1
dd GDT_start


bits 32
protected_code_start:

jmp $