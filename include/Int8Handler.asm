; Note: This file uses global variables
; from Int9Handler.asm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
New08IntHandler:
    pusha      ; 
    mov bp, sp ; save sp in bp, to addres saved values later
    
    push ds    ; save sd     

    db 0B8h         ; | (dupricated, you can use cs)
.selector: dw 0h    ; | mov ax, selector value
    mov ds, ax      ; > set ds for addresing

    mov al, ds:[draw_frame_flag]
    cmp al, 1h
    je .draw_frame

.@:
    pop ds
    popa

    db 0eah,        ; | jmp to previous handler
.old080Fs  dw 0h    ; |
.old080Seg dw 0h    ; >

    iret



.var: db 0h, 0h ; for debug

.draw_frame:
    push si ; |
    push es ; > save the sh*t

    mov bx, 0b800h  ; | 
    mov es, bx      ; > es = b800h

    ; mov bl, ds:[.var]             ; |
    ; mov byte ds:[ .var ], 1h      ; |
    ; cmp bl, 1h                    ; | debug
    ; jne .avoid_update_save_screen ; |
; .avoid_update_save_screen:        ; > 

    call UPDATE_SAVE_SCREEN_BUF

    mov bl, x_cord     ; x position
    mov bh, y_cord     ; y posistion
    mov dl, width
    mov dh, height
    call DRAW_FRAME

    mov bl, x_cord + 2h
    mov bh, y_cord + 1h
    call DRAW_REGS

    mov byte ds:[update_frame_buf], 'a'
    call UPDATE_UPDATE_FRAME_BUF ; after call es - dead

    pop es
    pop si
    jmp .@

%include "DRAW_FRAME.asm" ; why not draw frame 3 ???? (becasu this one works well :) )
%include "draw_regs.asm"