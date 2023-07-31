[org 0x7c00] 

mov [BOOT_DISK], dl

mov eax, 0
mov es, ax
mov ds, ax
mov ebx, eax
mov ecx, eax
mov edx, eax
mov bp, 0x8000
mov sp, bp



mov bx, 0x7e00 ; address to load data
mov ah, 2
mov al, 10 ; number of sectors
mov ch, 0
mov dh, 0
mov cl, 2 ; sector
mov dl, [BOOT_DISK]
int 0x13


jmp 0x7e00






BOOT_DISK: db 0


times 510-($-$$) db 0
dw 0xaa55

;
; New Sector
;


; a character at b8000 looks like this: aaaabbbb cccccccc so 2 bytes
; the first one is for colour a is for background colour b for foreground colour and c is a ascii code
; keep in mind registers are weird xD


mov ah, 0
mov al, 0x13

int 0x10


mov ebx, 0xa0022
mov ax, 0x0004
mov [ebx], ax
jmp $