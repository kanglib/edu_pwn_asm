; vim: sw=8 sts=8 et
;
; MulMat, 32-bit version
; 소백산 맑은물과 함께 맛있는 음식을 만들어보세요! (추천: SonMat)
;
; $ nasm -f elf32 mulmat32.asm
; $ gcc -o mulmat mulmat32.o
; $ ./mulmat n

global  main

extern  atoi
extern  printf

section .text
main:
        mov     ecx, [esp+4]    ; argc
        mov     edx, [esp+8]    ; argv

        cmp     ecx, 2
        jz      .nousage

        push    dword [edx]
        push    usage
        call    printf
        add     esp, 8
        mov     eax, -1
        ret

.nousage:
        push    edi
        sub     esp, 16

        xor     eax, eax
        mov     [esp+12], eax
        inc     eax
        mov     edi, esp
        mov     ecx, 3
        repz    stosd
        mov     edi, esp

        mov     eax, [edx+4]
        push    eax
        call    atoi

        test    eax, eax
        jge     .nat

        push    sibal
        call    printf
        mov     eax, -1
        add     esp, 24
        pop     edi
        ret

.nat:
        jnz     .pos
        mov     [edi+4], eax
        push    eax
        jmp     .out

.pos:
        push    eax
        push    eax
        push    edi
        call    powmat
        add     esp, 8

.out:
        pop     eax
        push    dword [edi+4]
        push    eax
        push    hi
        call    printf
        xor     eax, eax

        add     esp, 32
        pop     edi
        ret

; powmat pmat2, int
; 파맛 첵스
powmat:
        push    edi

        mov     edi, [esp+8]    ; base
        mov     ecx, [esp+12]   ; exponent

        test    ecx, ecx
        jnz     .ind

        mov     dword [edi], 1
        mov     dword [edi+4], 0
        mov     dword [edi+8], 0
        mov     dword [edi+12], 1
        jmp     .end

.ind:
        test    ecx, 1
        jnz     .odd

        sar     ecx, 1
        push    ecx
        push    edi
        call    powmat

        ; SSE2-ism :trollface:
        sub     esp, 8
        movdqu  xmm0, [edi]
        movdqu  [esp], xmm0
        push    esp
        push    edi
        call    mulmat
        add     esp, 24
        jmp     .end

.odd:
        sub     esp, 16
        movdqu  xmm0, [edi]
        movdqu  [esp], xmm0
        dec     ecx
        push    ecx
        lea     ecx, [esp+4]
        push    ecx
        call    powmat
        add     esp, 8

        push    esp
        push    edi
        call    mulmat
        add     esp, 24

.end:
        pop     edi
        ret

; mulmat pmat2, pmat2
; 물맛 피맛
mulmat:
        push    edi
        push    esi
        sub     esp, 16

        mov     edi, [esp+28]   ; dest
        mov     esi, [esp+32]   ; src

        ; 이물
        mov     eax, [edi]
        imul    eax, [esi]
        mov     edx, [edi+4]
        imul    edx, [esi+8]
        add     eax, edx
        mov     [esp], eax

        ; 저물
        mov     eax, [edi]
        imul    eax, [esi+4]
        mov     edx, [edi+4]
        imul    edx, [esi+12]
        add     eax, edx
        mov     [esp+4], eax

        mov     eax, [edi+8]
        imul    eax, [esi]
        mov     edx, [edi+12]
        imul    edx, [esi+8]
        add     eax, edx
        mov     [esp+8], eax

        mov     eax, [edi+8]
        imul    eax, [esi+4]
        mov     edx, [edi+12]
        imul    edx, [esi+12]
        add     eax, edx
        mov     [esp+12], eax

        movdqu  xmm0, [esp]
        movdqu  [edi], xmm0

        add     esp, 16
        pop     esi
        pop     edi
        ret

section .data
usage   db      "Usage: %s n", 10, 0
sibal   db      "sibal", 10, 0
hi      db      "#%d:", 9, "%d", 10, 0
