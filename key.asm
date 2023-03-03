%include "debug.asm"
%include "macroses.asm"

org 100h

Start: 

    ; Save selector for proper work
    mov [New09IntHandler.selector], ds
    mov [New08IntHandler.selector], ds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Set keyboard handler
    cli ; stop interupts
    
    xor bx, bx
    mov es, bx
    mov bx, 4h * 9h ; handler addres

    mov cx, es:[bx]                      ; |
    mov [New09IntHandler.old090Fs], cx   ; |
                                         ; |
    mov cx, es:[bx+2h]                   ; |
    mov [New09IntHandler.old090Seg], cx  ; > save previous handler addres

    mov ax, cs                           ; | current segment
    mov word es:[bx], New09IntHandler    ; |
    mov es:[bx + 2h], ax                 ; > set new handler address

    sti ; resume interupts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   Set timer handler
    cli
    
    xor bx, bx
    mov es, bx
    mov bx, 4h * 8h ; handler addres
    mov ax, cs      ; current segment

    mov cx, es:[bx]      
    mov [New08IntHandler.old080Fs ], cx   ; save previous handler
    
    mov cx, es:[bx+2h]   ;
    mov [New08IntHandler.old080Seg], cx 

    mov ax, cs
    mov word es:[bx], New08IntHandler
    mov es:[bx + 2h], ax

    sti ; resume interupts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov ax, 9999h
    mov di, ax
    mov byte [draw_frame_flag], 1h
    int 8h

    __GETCH

    ;Stay residdent
    mov ax, 3100h
    mov dx, EOP
    shr dx, 4
    inc dx
    int 21h

    __EXIT 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Global variables
alt_flag:        db 0Ah
draw_frame_flag: db 0Ah
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
New09IntHandler:
    pusha   ; 
    push es ; save the sh*t
    push ds 
    
    db 0B8h         ; mov ax, selector value
.selector: dw 0h

    mov ds, ax

    in al, 60h      ; get scan code
    
    cmp al, 38h ; if (al = 'alt') { alt_flag = 1; }
    je .pressed_alt

    cmp al, 1Eh
    je .pressed_a ; if (al = 'a') { if (alt_flag) -> enable_drawing_frame }

    mov bx, alt_flag     ; |
    mov byte ds:[bx], 0h ; > alt_flag = 0

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
    je .@
    
    mov al, ds:[alt_flag]        ; |
    mov ds:[draw_frame_flag], al ; > draw_frame_flag = alt_flag   

    mov byte ds:[alt_flag], 0h   ; alt_flag = 0 

    jmp .@
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
New08IntHandler:
    pusha   ; 
    mov bp, sp ; save sp in bp, to addres saved values later
    push ds 

    db 0B8h         ; mov ax, selector value
.selector: dw 0h
    mov ds, ax      ; set ds for addresing

    mov al, ds:[draw_frame_flag]
    cmp al, 1h
    je .draw_frame

.@:
    pop ds
    popa

    db 0eah, ; jmp to previous handler
.old080Fs  dw 0h
.old080Seg dw 0h

    iret

%assign x_cord 30h
%assign y_cord 0h
%assign width  1fh
%assign height 10h

.draw_frame:
    
    push si
    push es ; save the sh*t

    mov bx, 0b800h  ; | 
    mov es, bx      ; > es = b800h

    mov bl, x_cord     ; x position
    mov bh, y_cord     ; y posistion
    mov dl, width
    mov dh, height
    call DRAW_FRAME

    mov bl, x_cord + 2h
    mov bh, y_cord + 1h
    call DRAW_REGS
    
    pop es
    pop si
    jmp .@


%include "DRAW_FRAME.asm" ; why not draw frame 3 ????
%include "draw_regs.asm"
EOP:

