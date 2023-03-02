%include "debug.asm"
%include "macroses.asm"

%defstr ENTER_NUMBER_STR Enter number: _____ $
%strlen ENTER_NUMBER_STR_LEN ENTER_NUMBER_STR

org 100h

%assign line        4h
%assign colomnum   12h
Start:

    __CLEAR_SCREEN

    mov cl, 0h

    mov ax, 0b800h
    mov es, ax

    ;;;
    mov bl, colomnum
    %assign colomnum colomnum + 1
    mov bh, line
    %assign line line + 1

    mov dh, 10h
    mov dl, 2Dh

    call DRAW_FRAME

%rep 2
    __PUT_STRING  ENTER_NUMBER_STRING, line, colomnum
    
    %assign line line + 1

    __SET_CURSOR line - 1, ENTER_NUMBER_STR_LEN  + colomnum - 7h 


    mov dx, BUFFER_FOR_DECIMAL
    call GET_DECIMAL_FROM_STDIN

    push di ; Push VALUE
    
%endrep
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; SUM
    mov di, sp

    mov ax, [di]
    mov bx, [di + 2h]

    add ax, bx
    push ax                 ; stack has 3 elements

    mov bx, SUM_DEC_BUF
    call PUT_DECIMAL_IN_BUFFER

    mov dx, [di - 2h] ; di - 2h - stack top
    mov si, SUM_HEC_BUF
    call PUT_HEX_DX_IN_BUFFER

    mov ax, [di - 2h]
    mov bx, SUM_BIT_BUF
    call PUT_BINARY_AX_IN_BUFFER

    __PUT_STRING  SUM_MES, line, colomnum
    %assign line line + 1
    add sp, 2h ;now sum in stack is invalid
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; SUB
    ; mov di, sp

    mov bx, [di]
    mov ax, [di + 2h]

    sub ax, bx
    push ax                 ; stack has sub on top

    mov bx, SUB_DEC_BUF
    call PUT_DECIMAL_IN_BUFFER

    mov dx, [di - 2h] ; di - 2h - stack top
    mov si, SUB_HEC_BUF
    call PUT_HEX_DX_IN_BUFFER

    mov ax, [di - 2h]
    mov bx, SUB_BIT_BUF
    call PUT_BINARY_AX_IN_BUFFER

    __PUT_STRING  SUB_MES, line, colomnum
    %assign line line + 1

    add sp, 2h ;now sub in stack is invalid
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;COMPOSITION
    ; mov di, sp

    mov dx, 0h
    mov ax, [di + 2h]
    mov bx, [di]

    mul bx

    push ax ; composition on top

    mov bx, COM_DEC_BUF
    call PUT_DECIMAL_IN_BUFFER

    mov dx, [di - 2h] ; di - 2h - stack top
    mov si, COM_HEC_BUF
    call PUT_HEX_DX_IN_BUFFER

    mov ax, [di - 2h]
    mov bx, COM_BIT_BUF
    call PUT_BINARY_AX_IN_BUFFER

    __PUT_STRING  COM_MES, line, colomnum
    %assign line line + 1
    add sp, 2h ;now sub in stack is invalid

    __GETCH

    __REG cx

    __EXIT 1

%include "CLS.ASM"
%include "PUT_STR.ASM"
%include "PUT_IN_BINARY_AX.asm"
%include "PUT_HEX_DX_IN_BUFFER.asm"
%include "PUT_DECIMAL_IN_BUFFER.asm"
%include "DRAW_FRAME.asm"
%include "GET_DECIMAL_FROM_STDIN.asm"


ENTER_NUMBER_STRING: db ENTER_NUMBER_STR,
BUFFER_FOR_DECIMAL: db 6h, "%****^$" ; 5h - max input size, * -for chars, ^ - for CR, % - for input length

SUM_MES: db     "Their sum: "
SUM_DEC_BUF: db "_____d, "
SUM_HEC_BUF: db "____h, "
SUM_BIT_BUF: db "________________b$"

SUB_MES: db     "Their dif: "
SUB_DEC_BUF: db "_____d, "
SUB_HEC_BUF: db "____h, "
SUB_BIT_BUF: db "________________b$"

COM_MES: db     "Their com: "
COM_DEC_BUF: db "_____d, "
COM_HEC_BUF: db "____h, "
COM_BIT_BUF: db "________________b$"