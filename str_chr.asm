; @TODO
; memchr (basicly strchr, but cx is parametr)
; strcpy 
; memcpy (*destination, *source, number of symbols)
; memcmp
; memset
; strcmp

;------------------------------------------------
; Strchr - return addres of first symbol from 
;          buffer if symbol doesn't found until 
;          specified terminatig symbol, than 
;          return value set to NULL  
;------------------------------------------------
; STDCALL convection
; Enter: str_chr (buf addres, symbol, end_of_string)
; Exit: ax - addres
;
; Overwrites: bx, cx
;------------------------------------------------
%assign MAX_STR_LENGTH 0FFFFh
str_chr:
    push bp
    mov bp, sp
    
    push si ; save si
    push es ; save es

    mov ax, ds ; es = ds
    mov es, ax ; 

    mov bl, [bp + 6h] ; target char         (3 param)
    mov bh, [bp + 8h] ; tertminating symbol (2 param)
    mov si, [bp + 4h] ; string addres       (1 param)
    mov cx, MAX_STR_LENGTH

    cld 
.loop:
    lodsb
    cmp al, bl
    je .found

    cmp al, bh
    je .not_found

    loop .loop

.not_found:
    xor ax, ax

    jmp .ret

.found:

    mov ax, si
    dec ax
    
.ret:

    pop si      ; |
    mov es, si  ; ^ restrore es
    pop si      ; restore si
    pop bp      ; restore bp

    ret