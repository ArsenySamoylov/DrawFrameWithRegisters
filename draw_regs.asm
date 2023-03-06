%macro to_string 1
%defstr __string %1
%endmacro

; %1 - reg name, %2 - relative offset (will be used)
; %3 - addres
; Expects: ES = b800h, SS - point to stack segment               
; Overwrites: AX, DI, 
; Exit: BX points to the end of string 
%macro __PUT_REG 2
    nop
    push bx ; save bx

    mov dx, ss:[bp + %2] ; value from stack 
    mov si, value_buf    
    call PUT_HEX_DX_IN_BUFFER

    pop bx ; restore bx

    to_string %1
    mov ax, __string

    mov es:[bx], al
    mov es:[bx + 2h], ah
    mov byte es:[bx + 4h], ':'

    mov byte es:[bx+1h], %2 +1h; | (because of the color, there is trouble 
    mov byte es:[bx+3h], %2 +1h; |  with restoring colorsa attributes for sp
    mov byte es:[bx+5h], %2 +10h; > color

    add bx, 6h
    mov di, value_buf

    mov ch, %2 + 1h ; color for number
%rep 4
    mov cl, [di]       ; put  value on screen
    mov es:[bx], cx    ; 
    add bx, 2h         ;
    inc di             ; 
%endrep
    nop
%endmacro

value_buf: db "----*"

;-----------------------------------------------------
; Draw regs
;-----------------------------------------------------
DRAW_REGS:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Calculate effective address for bx from x and y coordinates
    xor ax, ax ; clear ax

    mov al, bh ; move y to al to then multiply 
    mov bh, 0h

    mov cl, 50h
    mul cl

    add bx, ax ; total pos
    
    shl bx, 1 ; x2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; NOTE: __PUT_REG uses bx, be carefool! 
    __PUT_REG ax, 7h * 2h
    add bx, (50h - 7h)*2h ; to point on next line

    __PUT_REG cx, 6h* 2h
    add bx, (50h - 7h)*2h ; to point on next line

    __PUT_REG dx, 5h* 2h
    add bx, (50h - 7h)*2h ; to point on next line

    __PUT_REG bx, 4h* 2h
    add bx, (50h - 7h)*2h ; to point on next line

    __PUT_REG sp, 3h* 2h
    add bx, (50h - 7h)*2h ; to point on next line
    
    __PUT_REG bp, 2h* 2h
    add bx, (50h - 7h)*2h ; to point on next line
    
    __PUT_REG si, 1h* 2h
    add bx, (50h - 7h)*2h ; to point on next line
    
    __PUT_REG di, 0h* 2h
    add bx, (50h - 7h)*2h ; to point on next line
    
    ret

%include "PUT_HEX_DX_IN_BUFFER.asm"
%include "mem_cpy.asm"

;-----------------------------------------------------
; be carefull !!! look in .mismatch case !!! (dupricated)
screen_frame_buf:
resw width * height

canary:
    resb 100h
update_frame_buf:
resw width * height

;-----------------------------------------------------

;-----------------------------------------------------
; MOVS ->  (ES:DI) = (DS:SI)
SAVE_FRAME_SCREEN:
    push es
    
    mov di, ds      ; |
    mov es, di      ; > di = ds    

    mov di, 0b800h  ; | 
    mov ds, di      ; > ds = b800h

    mov si, total_position
    mov di, screen_frame_buf

    mov cx, width

    cld

%rep height
    rep movsw                   ; save line from screen to buffer
    add si, (50h - width) * 2h  ; di - point on next line
    mov cx, width               ; set cx for next movs
%endrep

    ;!!!! copy screen frame buf to update buf
    mov di, es ; |
    mov ds, di ; > restore ds

    push width * height * 2 
    push screen_frame_buf 
    push update_frame_buf
    call mem_cpy ;(ds = ds, es = ds)
    add sp, 6h

    pop es     ; restore es

    ret

; ;-----------------------------------------------------
; ; Expecrs: es = b800h
; ; CMPSW (DS:SI), (ES:DI)
; ; Overwrites: ax, ...
; UPDATE_SAVE_SCREEN_BUF:
;     mov di, total_position
;     mov si, update_frame_buf
    
;     ; mov bx, screen_frame_buf

;     mov dx, height
;     cld
; .compare_line:
;     mov cx, width

;     .continue:   
;         rep cmpsb
;         jne .mismatch
    
;     sub di, 2h
;     add di, (50h - width) * 2h
;     sub dx, 1h
;     cmp dx, 1h
;     jne .compare_line 

;     ret

; .mismatch:
;     mov ax, es:[di - 2h] ; save in ax new word from videomem
;     ; ;mov ds:[si - 2h - (update_frame_buf - screen_frame_buf)], ax ; put this symbol in save screen buf in proper position
;     ;                 ; be careful !!!
;     mov ds:[si - 2h - width * height * 2], ax
;     xor ax, ax ; set ZF = 1
;     jmp .continue


;-----------------------------------------------------
; Expecrs: es = b800h
; CMPSW (DS:SI), (ES:DI)
; Overwrites: ax, ...
UPDATE_SAVE_SCREEN_BUF:
    mov si, screen_frame_buf;debug

    mov di, total_position
    mov si, update_frame_buf
    
    ; mov bx, screen_frame_buf

    mov dx, height + 1h
    
.compare_line:
    mov ax, 0h

    .@:
        mov bl, ds:[si]
        mov cl, es:[di]

        cmp  cl, bl
        jne .mismatch
        
        .continue:
        add di, 1h
        add si, 1h

        inc ax
        cmp ax, width * 2h
        jne .@

    add di, (50h - width) * 2h

    sub dx, 1h
    cmp dx, 1h
    jne .compare_line 

    ret

.mismatch:
    mov bx, screen_frame_buf

    push dx

    mov dx, update_frame_buf
    sub dx, si
    neg dx

    add bx, dx

    pop dx

    mov ds:[bx], cl

    mov es:[0h], cl
    jmp .continue


;-----------------------------------------------------
; Overwrites: es
; Copy from screen to buffer
; MOVS : (ES:DI) = (DS:SI)
UPDATE_UPDATE_FRAME_BUF:
    mov di, ds      ; |
    mov es, di      ; > es = ds    

    mov di, 0b800h  ; | 
    mov ds, di      ; > ds = b800h

    mov si, total_position
    mov di, update_frame_buf

    mov cx, width

    cld

%rep height
    rep movsw                  ; save line from screen to buffer
    add si, (50h - width) * 2h ; si - point on next line
    mov cx, width              ; set cx for next movs
%endrep

    mov di, es ; |
    mov ds, di ; > restore ds

    ret

;-----------------------------------------------------
; Overwrites: es
; MOVSW - (ES:DI) = (DS:SI)
RESTORE_SCREEN_FROM_FRAME_BUF:
    push es

    mov di, 0b800h  ; |
    mov es, di      ; > es = b800h    

    mov si, screen_frame_buf
    mov di, total_position

    mov cx, width

    cld

%rep height
    rep movsw                     ; copy line from screen to buffer
    add di, (50h - width) * 2h    ; di - point on next line
    mov cx, width                 ; set cx for next movs
%endrep

    pop es

    ret