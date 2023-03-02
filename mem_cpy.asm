mem_cpy:
    push bp
    mov bp, sp

    push si
    push di

    mov cx, [bp + 8h]
    mov si, [bp + 6h] ; source
    mov di, [bp + 4h] ; destination

    cld
    rep movsb

    pop di
    pop si
    pop bp

    ret