;------------------------------------------------
; GET DECIMAL FROM STD IPNPUT to di
;------------------------------------------------
; Entry: DS:DX - buffer address
; Expects: 
; Return: DI - hex value
; Owerwrites: dx in case if error occures
;------------------------------------------------

GET_DECIMAL_FROM_STDIN:

    call GET_DECIMAL_FROM_STDIN_TO_BUFFER
    xor ax, ax
    xor di, di

    ;;;;
    mov bx, dx ; bx - string address
    add bx, 1h ; string beggining

    mov si, [bx] ; si - counter
    and si, 0Fh
    ; add bx, si  ; bx - ptr to string end

   
    cmp si, 0h
    jz .READING_ERROR

    mov cx, 1h ; start base
.@:
    xor ax, ax
    mov al, [bx + si]
    sub al, '0'

    mul cx ; DS:AX = AX * CX
    add di, ax ; DI - result

    mov dx, cx ; cx *= 10
    shl cx, 3  ; cx  * 10 = cx * 8 + dx * 2
    shl dx, 1 
    add cx, dx

    sub si, 1h
    jnz .@

    ret

.READING_ERROR:

    mov dx, .ERROR_MESSAGE
    mov ah, 9h

    int 21h

    ret

.ERROR_MESSAGE: db "Error occurres in GET_DECIMAL_FROM_CONSOLE", 0xd, 0xa, "$"


%include "GET_DECIMAL_FROM_STDIN_TO_BUFFER.asm"