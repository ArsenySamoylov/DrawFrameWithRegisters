%macro to_string 1
%defstr __string %1
%endmacro

; %1 - reg name, %2 - relative offset
; %3 - addres
%macro __PUT_REG 2
    nop
    push bx ; save bx

    mov dx, ss:[bp + %2] ; value from stack 
    mov si, value_buf
    call PUT_HEX_DX_IN_BUFFER

    pop bx ; restore bx

    to_string %1
    mov ax, __string

    mov es:[bx], al
    mov es:[bx + 2h], ah
    mov byte es:[bx + 4h], ':'

    mov byte es:[bx+1h], %2 +1h; |
    mov byte es:[bx+3h], %2 +1h; |
    mov byte es:[bx+5h], %2 +1h; > color

    add bx, 6h
    mov di, value_buf

%rep 4
    mov cl, [di]
    mov es:[bx], cl
    add bx, 2h
    inc di
%endrep
    nop
%endmacro

value_buf: db "----*"

;-----------------------------------------------------
; Draw regs
;-----------------------------------------------------
DRAW_REGS:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Calculate effective address for bx from x and y coordinates
    xor ax, ax ; clear ax

    mov al, bh ; move y to al to then multiply 
    mov bh, 0h

    mov cl, 50h
    mul cl

    add bx, ax ; total pos
    
    shl bx, 1 ; x2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    __PUT_REG ax, 7h * 2h
    add bx, (50h - 7h)*2h ; to point on next line

    __PUT_REG cx, 6h* 2h
    add bx, (50h - 7h)*2h ; to point on next line

    __PUT_REG dx, 5h* 2h
    add bx, (50h - 7h)*2h ; to point on next line

    __PUT_REG bx, 4h* 2h
    add bx, (50h - 7h)*2h ; to point on next line

    __PUT_REG sp, 3h* 2h
    add bx, (50h - 7h)*2h ; to point on next line
    
    __PUT_REG bp, 2h* 2h
    add bx, (50h - 7h)*2h ; to point on next line
    
    __PUT_REG si, 1h* 2h
    add bx, (50h - 7h)*2h ; to point on next line
    
    __PUT_REG di, 0h* 2h
    add bx, (50h - 7h)*2h ; to point on next line
    
    ret

%include "PUT_HEX_DX_IN_BUFFER.asm"