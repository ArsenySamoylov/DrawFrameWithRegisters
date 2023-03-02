%include "debug.asm"
%include "macroses.asm"

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
    push ax                                 ; al = x, ah - y coordinate

    add bx, 1h                              ; !!! after call BX POINTS TO THE END OF BUFFER !!!!!!!!!!!! 
; Get width and height
    call GET_HEX_VALUE_FROM_BUFFER_TO_AX
    push ax                                 ; push width coordinate

    add bx, 1h
; Get frame symbols or default style
    call Get_frame_style
    
    cmp ax, 0h
    je .style_error

    inc bx  ; bx - points to start of the line
    mov di, String_addres   ; Save string address
    mov [di], bx

; draw_frame:
    mov bp, sp
    
    mov bx, ax        ; frame style
    mov dx, [bp]      ; width and height
    mov ax, [bp + 2h] ; x and y coordinates

    call DRAW_FRAME_2

; print line
    mov bx, String_addres
    mov di, [bx]

    call PRINT_LINE
; @TODO make function, that calculates string position, not this sh*t ;)))
    
 
    __GETCH

    __EXIT 0
;////////////////////////////////////////////////////
.style_error:
    __EXIT 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Data segment
String_addres: resb 2

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

%include "set_frame_style_from_cml.asm"
%include "print_line.asm"