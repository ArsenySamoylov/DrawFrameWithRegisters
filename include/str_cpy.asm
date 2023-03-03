;-----------------------------------------------------
; Str_cpy - function copies the string pointed 
;           to by src, including the terminating null 
;           byte ('\0'), to the buffer pointed to by 
;           dest.
;-----------------------------------------------------
; Enter: str_cpy ( *dest, *src, int terminating symbol
; Exprects: es, ds
; NOTE: be accurate with ES, DS, here I don't work with 
;       them
;-----------------------------------------------------
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
