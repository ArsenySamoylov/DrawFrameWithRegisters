;-----------------------------------------------------
; memset - function fills the first n bytes of the 
;          memory area pointed to by s with the 
;          constant byte c.
;-----------------------------------------------------
; Expects: memset ( *s, unsigned c, unsigned n)
; Exit: none
;
; Overwrites:
; Note: be accurate with ES
;-----------------------------------------------------
mem_set:
    push bp
    mov bp, sp

    push di ; save di

    mov di, [bp + 4h] ; *s
    mov al, [bp + 6h] ; c
    mov cx, [bp + 8h] ; n

rep stosb ; while(cx--) {(es:di) = al; di++}

    pop di
    pop bp

    ret

