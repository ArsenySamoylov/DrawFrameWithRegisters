;------------------------------------------------
; Count str length until terminatin character 
;                                   (not counted)
;------------------------------------------------
; STDCALL convection
; Enter: 
; Exit: ax - length
;------------------------------------------------
%assign MAX_STR_LENGTH 0FFFFh
str_len:
    push bp
    mov bp, sp
    
    push di
    push es

    cld 
    mov ax, ds
    mov es, ax

    mov al, [bp + 6h]
    mov cx, MAX_STR_LENGTH
    mov di, [bp + 4h]

    repne scasb
    je .found

.not_found:
    mov dx, .ERROR_MESSAGE
    mov ah, 9h

    int 21h

    jmp .ret

.ERROR_MESSAGE: db "Error occurred in strlen", 0xd, 0xa, "$"


.found:

    mov ax, di
    mov di, [bp + 4h]
    sub ax, di
    dec ax
    
.ret:

    pop di
    mov es, di
    pop di
    pop bp

    ret