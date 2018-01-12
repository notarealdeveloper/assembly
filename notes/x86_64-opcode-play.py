#!/usr/bin/python3

# Trying to figure out some basics of how my computer works without googling anything,
# cuz I'm bored and I don't have internet access at the moment.

# x86_64 counts like this:
# (0) eax
# (1) ecx
# (2) edx
# (3) ebx
# (4) esp
# (5) ebp
# (6) esi
# (7) edi

# file="reverse-engineering-x86_64"
# nasm -f elf64 ${file}.asm
# ld -m elf_x86_64 ${file}.o -o ${file}
# objdump -d ${file}

# Holding eax (the first one) constant, and looking at the opcodes
#    mov     eax, eax
#    mov     eax, ecx
#    mov     eax, edx
#    mov     eax, ebx
#    mov     eax, esp
#    mov     eax, ebp
#    mov     eax, esi
#    mov     eax, edi
#
#    mov     eax, eax
#    mov     ecx, eax
#    mov     edx, eax
#    mov     ebx, eax
#    mov     esp, eax
#    mov     ebp, eax
#    mov     esi, eax
#    mov     edi, eax

eaxDst = [0xc0,0xc1,0xc2,0xc3,0xc4,0xc5,0xc6,0xc7]
eaxSrc = [0xc0,0xc8,0xd0,0xd8,0xe0,0xe8,0xf0,0xf8]

for a in eaxDst + eaxSrc: print(bin(a))


# Holding ebx (the fourth one) constant, and looking at the opcodes
#    mov     ebx, eax
#    mov     ebx, ecx
#    mov     ebx, edx
#    mov     ebx, ebx
#    mov     ebx, esp
#    mov     ebx, ebp
#    mov     ebx, esi
#    mov     ebx, edi
#
#    mov     eax, ebx
#    mov     ecx, ebx
#    mov     edx, ebx
#    mov     ebx, ebx
#    mov     esp, ebx
#    mov     ebp, ebx
#    mov     esi, ebx
#    mov     edi, ebx

ebxDst = [0xc3,0xcb,0xd3,0xdb,0xe3,0xeb,0xf3,0xfb]
ebxSrc = [0xd8,0xd9,0xda,0xdb,0xdc,0xdd,0xde,0xdf]

for b in ebxDst + ebxSrc: print(bin(b))

# The upper and lower bytes of the ax, bx, cx, dx registers
blDst = [0xc3,0xcb,0xd3,0xdb]
blSrc = [0xd8,0xd9,0xda,0xdb]

bhDst = [0xe7,0xef,0xf7,0xff]
bhSrc = [0xfc,0xfd,0xfe,0xff]

for b in blDst + blSrc: print(bin(b))
for b in bhDst + bhSrc: print(bin(b))
