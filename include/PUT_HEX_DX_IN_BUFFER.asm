;------------------------------------------------
; Put AX value in binary form in buffer
; BUFFER MUST BE NOT LESS THAN 16 bytes
; ('$' not included)
;------------------------------------------------
; Entry: DX - value to be displayed
;        DS:SI - buffer address
; Exit: none
; Overwrite: AX, BX, CH, SI, DX 
;------------------------------------------------
PUT_HEX_DX_IN_BUFFER:  

    xor ch, ch ; will use as counter, 
    mov bx, HEX_TABLE

%rep 4

    mov al, dh
    
    ; and al, 11110000b
    shr al, 4
    xlat    

    mov ds:[si], al

    add si, 1h
    shl dx, 4h

    add ch, 1h

%endrep

    ret

HEX_TABLE: db "0123456789ABCDEF"