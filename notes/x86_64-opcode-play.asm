# Trying to figure out some basics of how my computer works without googling anything,
# cuz I'm bored and I don't have internet access at the moment.

# file="reverse-engineering-x86_64"
# nasm -f elf64 ${file}.asm
# ld -m elf_x86_64 ${file}.o -o ${file}
# objdump -d ${file}

global _start

_start:
    ; Holding eax constant
    mov     eax, eax
    mov     eax, ecx
    mov     eax, edx
    mov     eax, ebx
    mov     eax, esp
    mov     eax, ebp
    mov     eax, esi
    mov     eax, edi

    mov     eax, eax
    mov     ecx, eax
    mov     edx, eax
    mov     ebx, eax
    mov     esp, eax
    mov     ebp, eax
    mov     esi, eax
    mov     edi, eax

    ; Holding ebx constant
    mov     ebx, eax
    mov     ebx, ecx
    mov     ebx, edx
    mov     ebx, ebx
    mov     ebx, esp
    mov     ebx, ebp
    mov     ebx, esi
    mov     ebx, edi

    mov     eax, ebx
    mov     ecx, ebx
    mov     edx, ebx
    mov     ebx, ebx
    mov     esp, ebx
    mov     ebp, ebx
    mov     esi, ebx
    mov     edi, ebx


    ; Holding rbx constant
    mov     rbx, rax
    mov     rbx, rcx
    mov     rbx, rdx
    mov     rbx, rbx
    mov     rbx, rsp
    mov     rbx, rbp
    mov     rbx, rsi
    mov     rbx, rdi

    mov     rax, rbx
    mov     rcx, rbx
    mov     rdx, rbx
    mov     rbx, rbx
    mov     rsp, rbx
    mov     rbp, rbx
    mov     rsi, rbx
    mov     rdi, rbx

    ; Holding bx constant
    mov     bx, ax
    mov     bx, cx
    mov     bx, dx
    mov     bx, bx
    mov     bx, sp
    mov     bx, bp
    mov     bx, si
    mov     bx, di

    mov     ax, bx
    mov     cx, bx
    mov     dx, bx
    mov     bx, bx
    mov     sp, bx
    mov     bp, bx
    mov     si, bx
    mov     di, bx

    ; Holding bl constant
    mov     bl, al
    mov     bl, cl
    mov     bl, dl
    mov     bl, bl

    mov     al, bl
    mov     cl, bl
    mov     dl, bl
    mov     bl, bl

    ; Holding bh constant
    mov     bh, ah
    mov     bh, ch
    mov     bh, dh
    mov     bh, bh

    mov     ah, bh
    mov     ch, bh
    mov     dh, bh
    mov     bh, bh

    ; Moving a fixed number into various registers
    mov     eax, 0x00
    mov     ecx, 0x00
    mov     edx, 0x00
    mov     ebx, 0x00
    mov     esp, 0x00
    mov     ebp, 0x00
    mov     esi, 0x00
    mov     edi, 0x00

    ; Arithmetic operations
    add     eax, eax
    add     ecx, eax
    add     edx, eax
    add     ebx, eax
    sub     eax, eax
    sub     ecx, eax
    sub     edx, eax
    sub     ebx, eax

    ; 0x48 seems to be a general suffix for 64 bit operations
    add     rax, rax
    add     rcx, rax
    add     rdx, rax
    add     rbx, rax
    sub     rax, rax
    sub     rcx, rax
    sub     rdx, rax
    sub     rbx, rax

    ; 0x66 seems to be a general suffix for 16 bit operations
    add     ax, ax
    add     cx, ax
    add     dx, ax
    add     bx, ax
    sub     ax, ax
    sub     cx, ax
    sub     dx, ax
    sub     bx, ax

    ; Many opcodes seem to be one lower for the single-byte operations
    add     al, al
    add     cl, al
    add     dl, al
    add     bl, al
    sub     al, al
    sub     cl, al
    sub     dl, al
    sub     bl, al

    add     ah, ah
    add     ch, ah
    add     dh, ah
    add     bh, ah
    sub     ah, ah
    sub     ch, ah
    sub     dh, ah
    sub     bh, ah

    ; More arithmetic operations
    imul     eax, eax
    imul     ecx, eax
    imul     edx, eax
    imul     ebx, eax

    imul     rax, rax
    imul     rcx, rax
    imul     rdx, rax
    imul     rbx, rax

    imul     ax, ax
    imul     cx, ax
    imul     dx, ax
    imul     bx, ax

