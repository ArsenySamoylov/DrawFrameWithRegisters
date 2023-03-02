;------------------------------------------------
; Put AX value in HEX form in buffer
; BUFFER MUST BE NOT LESS THAN 4 bytes
; ('$' not included)
;------------------------------------------------
; Entry: AX - value to be displayed
;        BX - buffer address
; Exit: none
; Overwrite: AX, BX, CX
;------------------------------------------------
PUT_BINARY_AX_IN_BUFFER:

    xor cx, cx

..@:

    shl ax, 1h
    adc cl, '0'

    mov [bx], cl

    xor cl, cl
    
    add bx, 1h
    add ch, 1h

    cmp ch, 10h 
    jb ..@

    ret
