;-----------------------------------------------------
; The memcmp() function compares the first n bytes 
;       (each interpreted as unsigned char) 
;       of the memory areas s1 and s2
;-----------------------------------------------------
; Entry: memcpm( *s1, *s2, unsigned n)
; Exit: ax - 0 if equal, 1 if not equal
;       di, si - points to first umatched symbols if ax = 1
; Overwrites: di, si
; Note: ES !!!!! DS!!! be carefull!!!!
;-----------------------------------------------------
mem_cpm:
    push bp
    mov bp, sp

    mov di, [bp + 4h]
    mov si, [bp + 6h]
    mov cx, [bp + 8h]

repe cmpsb
    jne .mismatch

    pop bp
    xor ax, ax ; 0 -> equal

    ret

.mismatch:

    mov ax, 1h
    dec si
    dec di
    
    pop bp

    ret
