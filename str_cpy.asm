; Exprects: es, ds

str_cpy:
    push bp
    mov bp, sp

    push cx ; ^ save registers
    push si ; |
    push di ; |

    mov cl, [bp + 8h] ; terminating symbol
    mov si, [bp + 6h] ; source      (2)
    mov di, [bp + 4h] ; destination (1)

.loop:
    lodsb
    mov [di], al
    inc di

    cmp al, cl
    je .ret

    jmp .loop

.ret:
    pop di ; |
    pop si ; |
    pop cx ; ^ restore registers

    pop bp

    ret
