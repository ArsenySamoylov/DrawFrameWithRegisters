;-----------------------------------------------------
; mem_cpy - function copies n bytes from memory area 
;           src to memory area dest.  
;           The memory areas must not overlap.
;-----------------------------------------------------
; Enter: mem_cpy( *dest, *src, unsigned n)
; Exit: none
; 
; Overwrites: cx
; NOTE: be accurate with ES, DS, here I don't work with 
;       them
;-----------------------------------------------------
mem_cpy:
    push bp
    mov bp, sp

    push si ; save di
    push di ; save si

    mov cx, [bp + 8h] ; n
    mov si, [bp + 6h] ; source
    mov di, [bp + 4h] ; destination

    cld
    rep movsb

    pop di
    pop si
    pop bp

    ret