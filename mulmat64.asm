; vim: sw=8 sts=8 et
;
; MulMat, 64-bit version
; ¸À¾ø´Â ¹°
;
; $ nasm -f elf64 mulmat64.asm
; $ gcc -o mulmat mulmat64.o
; $ ./mulmat n

global  main

extern  atoi
extern  printf

section .text
main:
        cmp     rdi, 2
        jz      .nousage

        mov     rdi, usage
        mov     rsi, [rsi]
        xor     rax, rax
        call    printf
        mov     rax, -1
        ret

.nousage:
        mov     rdi, [rsi+8]
        call    atoi
        test    rax, rax
        jge     .nat

        mov     rdi, sibal
        xor     rax, rax
        call    printf
        mov     rax, -1
        ret

.nat:
        mov     rsi, rax
        cmp     rax, 2
        jge     .ind
        mov     rdx, rax
        jmp     .out

.ind:
        dec     rax
        dec     rax
        mov     rcx, rax
        mov     rax, 1
        mov     rdx, rax
.L1:    jrcxz   .out
        xchg    rdx, rax
        add     rdx, rax
        dec     rcx
        jmp     .L1

.out:
        mov     rdi, hi
        xor     rax, rax
        push    rax
        call    printf
        pop     rax
        ret

section .data
usage   db      "Usage: %s n", 10, 0
sibal   db      "sibal", 10, 0
hi      db      "#%d:", 9, "%d", 10, 0
