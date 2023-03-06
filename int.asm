org 100h

    ; mov bx, 0b800h
    ; mov es, bx

    ; ; mov ah, 4eh
    ; ; mov al, '#'
    ; ; call CLR_SCR


    ; int 8h
    ; int 9h
 

    ; mov ax, 0b800h
    ; mov es, ax

    mov ax, 1211h
    mov bx, 2222h
    mov cx, 3333h
    mov dx, 4444h
    mov di, 5555h
    
.loop:
   in al, 60h
   mov es:[0h], ax
   cmp al, 1h
   jne .loop

    mov ah, 4ch
    mov al, 0h
    
    int 21h

%include "CLS.ASM"