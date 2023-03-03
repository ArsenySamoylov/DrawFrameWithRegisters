;------------------------------------------------
; Put AX value in decimal on the screen
; BUFFER MUST BE NOT LESS THAN 16 bytes
; ('$' not included)
;------------------------------------------------
; Entry: AX - value
;        DS:BX - address
; Overwrites: AX
;------------------------------------------------
PUT_DECIMAL_IN_BUFFER:

    push cx ; save cx
    push dx ; save dx

    mov cx, 0Ah ; 10 - делитель

%rep 5
    xor dx, dx 
    div cx ; AX = DX:AX div CX; DX = DX:AX mod CX

    add dl, '0' ; after div dx hold remainder, so dl + '0' - is proper symbol
    push dx         
%endrep
 

%rep 5
    ; PUT SYMBOL IN PROPER ORDER IN THE BUFFER
    pop dx 
    mov byte ds:[bx], dl 
    
    inc bx
%endrep
    
    lea bx, byte ds:[bx - 5h] ; restore bx (suka)
    pop cx                 ; restore cx
    pop dx                 ; restore dx
    
    ret