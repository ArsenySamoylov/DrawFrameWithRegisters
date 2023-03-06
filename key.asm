%include "debug.asm"
%include "macroses.asm"

org 100h

%assign x_cord 40h
%assign y_cord 01h
%assign width  0Bh
%assign height 0Ah
%assign total_position (y_cord * 50h + x_cord) * 2h 

Start: 

    ; Save selector for proper work
    mov [New09IntHandler.selector], ds ; |
    mov [New08IntHandler.selector], ds ; > dupricated, you can use cs
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
    
    ; int 9h
    ; ; mov byte [draw_frame_flag], 1h
    ; int 8h
    
    ;Stay residdent
    mov ax, 3100h
    mov dx, EOP
    shr dx, 4
    inc dx
    int 21h

    __EXIT 0


%include "Int9Handler.asm"
%include "Int8Handler.asm"

EOP: