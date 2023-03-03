;-----------------------------------------------------
; Get default or custom style for frame from cml
; if first 
;-----------------------------------------------------
; Entry: bx - addres of buffer with cml arguments
; Return: ax - addres of buffer with style (symbols and attributes)
;         bx - points to end of symbolic arguments
;
; Overwrites:
;-----------------------------------------------------
%assign number_of_default_styles  4h

Get_frame_style:
    mov ch, [bx]
    inc bx
    cmp ch, '#'   ; symbol for default style
    je .set_default_style

    cmp ch, '$'   ; symbol for custom style
    je .set_custom_style

; Wrong style argument
    __SYS_PUT_STRING .argument_error
    xor ax, ax
    ret     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.set_default_style:
    movzx cx, [bx] ; get 
    add bx, 2h     ; now bx points to the end of style argument addres

    sub cx, '0'
    cmp cx, number_of_default_styles
    ja .report_default_style_error
    
    dec cx

    mov ax, cx  ; |
    shl cx, 4   ; |
    shl ax, 2   ; |
    add ax, cx  ; > ax = (ax-1)*18

    add ax, .default_style_table
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.set_custom_style:
    push bx 
    call GET_HEX_VALUE_FROM_BUFFER_TO_AX

    pop bx
    add bx, 5h

    mov di, .custom_style

    add ch, ah; ch - for frame color

%rep 4
    mov cl, [bx]
    inc bx

    mov [di], cx
    add di, 2h
%endrep

    mov ch, al ; - backround color
    mov cl, [bx]
    inc bx

    mov [di], cx
    add di, 2h

    mov ch, ah ; frame color
%rep 4
    mov cl, [bx]
    inc bx

    mov [di], cx
    add di, 2h
%endrep

    mov ax, .custom_style
    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.report_default_style_error:
    __SYS_PUT_STRING .default_style_error_message
    xor ax, ax
    ret

;-----------------------------------------------------
; Data
.custom_style:
    resw 9h

.default_style_table:   db 0dah, 0b11001010, 0c4h, 0b11001010, 0bfh, 0b11001010
    .midle:    db 0b3h, 0b11001010, 0c3h, 0b10100010, 0b3h, 0b11001010
    .downside: db 0c0h, 0b11001010, 0c4h, 0b11001010, 0d9h, 0b11001010


.error_message:   db "Wrong default style", 0xd, 0xa, "$"
.argument_error: db "Wrong arguments for frame style", 0xd, 0xa, "$"
.default_style_error_message: db "Wrong default style number", 0xd, 0xa, "$"