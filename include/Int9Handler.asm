;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Global variables
alt_flag:        db 0Ah
draw_frame_flag: db 0Ah
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
New09IntHandler:
    pusha   ; 
    push es ; save the sh*t
    push ds 
    
    db 0B8h         ;| mov ax, selector value 
.selector: dw 0h    ;| deprecated, you can use cs
                    ;|
    mov ds, ax      ;>

    mov ax, screen_frame_buf ; |
    mov ax, update_frame_buf ; > for debug


    in al, 60h      ; get scan code
    
    cmp al, 38h ; if (al = 'alt') { alt_flag = 1; }
    je .pressed_alt

    cmp al, 1Eh
    je .pressed_a ; if (al = 'a') { if (alt_flag) -> enable_drawing_frame }

    cmp al, 2dh; 'x'
    je .pressed_x

.clear_alt_flag:
    mov byte ds:[alt_flag], 0h ; > alt_flag = 0

.@: 
    pop ds
    pop es
    popa

    db 0eah, ; jmp to previous handler
.old090Fs  dw 0h
.old090Seg dw 0h

    iret

.pressed_alt:
    mov byte ds:[alt_flag], 1h
    jmp .@

.pressed_a:
    mov al, ds:[draw_frame_flag]    
    cmp al, 1h
    je .clear_alt_flag ; clear alt flag
    
    mov al, ds:[alt_flag]        ; if (alt_falg) 
    cmp al, 1h                   ; {draw_frame_falg = 1;
    je .enable_drawing_frame     ;  SaveScreen(); }

    jmp .clear_alt_flag

    .enable_drawing_frame:
        call SAVE_FRAME_SCREEN

        ; mov cx, width * height ; width and height
        ; rep mov word ds:[update_frame_buf], 0h ; 

        mov byte ds:[draw_frame_flag], 1h
        jmp .@

.pressed_x:
    mov al, ds:[alt_flag]
    cmp al, 1h
    jne .@

    mov al, ds:[draw_frame_flag]
    cmp al, 1h
    jne .clear_alt_flag

    mov byte ds:[draw_frame_flag], 0h

    call RESTORE_SCREEN_FROM_FRAME_BUF
    
    mov cx, width * height                 ; |
    rep mov word ds:[update_frame_buf], 0h ; |
                                           ; |
    mov cx, width * height                 ; |
    rep mov word ds:[screen_frame_buf], 0h ; > clear buffers

    jmp .clear_alt_flag
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;