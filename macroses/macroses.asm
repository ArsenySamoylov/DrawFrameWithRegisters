%ifndef MACROSES
%define MACROSES
;------------------------------------------------
; WRAPPER FOR CLR_SCR function
; 
;Overwrite: AX, BX, CH, SI, DX, ES
; color - red
;------------------------------------------------
%macro __CLEAR_SCREEN 0
    nop
    mov ax, 0b800h
    mov es, ax

    mov ah, 00000100b
    mov al, ' '

    call CLR_SCR
    nop
%endmacro

;------------------------------------------------
; Overwrites: ax
; Expects: return value (can be half-register)
; NOTE add to imm argument suffix ('h' for example)
%macro __EXIT 1
    nop
    mov ah, 4ch
    mov al, %1
    
    int 21h
    nop
%endmacro

;------------------------------------------------
; Put String using DosSytem service
; using DS:DX
;------------------------------------------------
; Overwrites: AH, DX
;------------------------------------------------
%macro __SYS_PUT_STRING 1
    nop
    mov dx, %1
    mov ah, 9h

    int 21h
    nop
%endmacro

;------------------------------------------------
; Overwrites: AX
; Exit: AL - input char
;------------------------------------------------
%macro __GETCH 0
    nop

    mov ah, 07h
    int 21h

    nop
%endmacro

;------------------------------------------------
; Wrapper for PUT_STR funtion
;
; Note: green color
;------------------------------------------------
%macro __PUT_STRING 3
    nop 

    mov si, %1 ; string address
    mov bh, %2  ; row
    mov bl, %3  ; colomn
    mov ch, 2h ; std color

    call PUT_STR

    nop
%endmacro

%macro __SET_CURSOR 2
    nop

    mov ah, 2h
    mov bh, 0h
    mov dh, %1 ; row     (x)
    mov dl, %2 ; column  (y)

    int 10h

    nop
%endmacro

%macro __PUTCH 1
    nop

    mov dl, %1
    mov ax, 2h
    int 21h

    nop
%endmacro


%macro __CLEAR_REGS 0
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si, si
    xor di, di
%endmacro

%endif