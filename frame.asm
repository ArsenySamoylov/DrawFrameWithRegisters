%include "debug.asm"
%include "macroses.asm"

%assign number_of_default_styles  4h

org 100h

; NOTE: when custom frame style specified: no space
Start:

    mov di, 0b800h
    mov es, di
;................................................
; Get parametrs for frame from cml
; 080h - number of symbols (it counts only 1 first space)
; 081h - space symbol
; 082h - first symbol
; Get left corner coordinates to ax
    mov bx, 082h
    call GET_HEX_VALUE_FROM_BUFFER_TO_AX    ; NOTE: changes in this function can effect bx usage below!!!!
    push ax                                 ; push x coordinate

    add bx, 1h                              ; !!! after call BX POINTS TO THE END OF BUFFER !!!!!!!!!!!! 
    call GET_HEX_VALUE_FROM_BUFFER_TO_AX
    pop dx
    shl dx, 8

    add ax, dx  ; ah - x coordinate, al - y coordinate 
    push ax

; Get width and height
    add bx, 1h                              ; !!! after call BX POINTS TO THE END OF BUFFER !!!!!!!!!!!!
    call GET_HEX_VALUE_FROM_BUFFER_TO_AX
    push ax                                 ; push width coordinate

    add bx, 1h                              ; !!! after call BX POINTS TO THE END OF BUFFER !!!!!!!!!!!!
    call GET_HEX_VALUE_FROM_BUFFER_TO_AX    ; ax - height
    pop cx                                  ; cx - width
    shl cx, 8
    add ax, cx                              ; ah - width, al - height
    push ax

; Get frame symbols or default style
    add bx, 1h
    mov ch, [bx+1h]
    cmp ch, '#'                             ; symbol for default style
    jne .set_custom_style

    movzx cx, [bx]
    add bx, 3h

    sub cx, '0'

    cmp cx, number_of_default_styles
    ja Report_default_style_error
    
    dec cx

    mov ax, cx
    shl cx, 4
    shl ax, 2
    add cx, ax              ; cx = (cx-1)*18

    add cx, default_style_table
    push cx

    mov di, String_addres   ; Save string address
    mov [di], bx

    jmp .draw_frame

.set_custom_style:
    push bx
    add bx, 2d * 9d

    mov di, String_addres   ; Save string address
    mov [di], bx

.draw_frame:

    pop bx
    mov bp, sp
    
    mov dx, [bp]
    mov ax, [bp + 2h]

    call DRAW_FRAME_2


; @TODO make function, that calculates string position, not this sh*t ;)))
    mov bx, String_addres
    mov di, [bx]

    push '$'
    push di

    call str_len

    movzx cx, [bp + 1h] ; cx = width
    sub ax, cx
    neg ax              ; ax = - (length - width)

    shr ax, 1 

    movzx cx, [bp + 3h] ; cx - frame x coordinate
    add ax, cx          ; ax - x coordinate for middle

    push ax             ; x coorfinate for string

    movzx cx, [bp + 2h] ; cx = y coordinate
    movzx ax, [bp + 0h] ; ax = height
    
    shr ax, 1
    add ax, cx          ; calculated row for string 


    mov si, di          ; I hope di is still alive! (BE CAREFULL!!!)
    shl ax, 8
    pop cx

    add ax, cx
    mov bx, ax

    mov ch, 2h      ; color
    call PUT_STR

    __GETCH

    __EXIT 0
;////////////////////////////////////////////////////
Report_default_style_error:
    mov dx, ERROR_MESSAGE
    mov ah, 9h

    int 21h

    __GETCH

    __EXIT 1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Data segment
String_addres: resb 2

default_style_table:   db 0dah, 0b11001010, 0c4h, 0b11001010, 0bfh, 0b11001010
midle:    db 0b3h, 0b11001010, 0c3h, 0b10100010, 0b3h, 0b11001010
downside: db 0c0h, 0b11001010, 0c4h, 0b11001010, 0d9h, 0b11001010

ERROR_MESSAGE: db "Wrong default style", 0xd, 0xa, "$"

;/////////////////////////////////////////////////////
; INCLUDE
%include "DRAW_FRAME_2.asm"
%include "GET_HEX_VALUE_FROM_BUFFER_TO_AX.asm"

%include "PUT_STR.ASM"
%include "PUT_IN_BINARY_AX.asm"
%include "PUT_HEX_DX_IN_BUFFER.asm"
%include "PUT_DECIMAL_IN_BUFFER.asm"

%include "strlen.asm"
%include "str_chr.asm"