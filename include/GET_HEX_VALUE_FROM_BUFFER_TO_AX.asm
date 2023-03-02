;------------------------------------------------
; Get hex value from buffer
; Note buffer MUST contain 4 symbols - hex value
;------------------------------------------------
; Entry: bx - buffer addres
; Overwrites: cx, bx, dx, ax
; Exit: ax- resulting hex value
;------------------------------------------------
GET_HEX_VALUE_FROM_BUFFER_TO_AX:
    mov cx, 04h

.loop:
    movsx dx, [bx]
    sub dx, '0'

    cmp dx, 09h + 1h
    jb .digit

    sub dx, 'A' - '0' - 0Ah
    cmp dx,  0Fh + 1h
    jb .caps_lit

    sub dx, 'a' - 'A'
    cmp dx, 0Fh + 1h
    jb .lit

    jmp .REPORT_ERROR

    .digit:
    .caps_lit:
    .lit:

    shl ax, 4
    add ax, dx
    add bx, 1h
    loop .loop

    ret

.REPORT_ERROR:

    mov dx, .ERROR_MESSAGE
    mov ah, 9h

    int 21h

    ret

.ERROR_MESSAGE: db "Umcnown symbol in buffer, GET_HEX_VALUE_FROM_BUFFER", 0xd, 0xa, "$"

