;------------------------------------------------
; Draw frame  on the screen
; You can specify frame symbols and their attributes
;       by using corresponding labels bellow
;------------------------------------------------
; Entry:    BL - x position
;           BH - y position
;           DH - height
;           DL - width
; Expects: ES = 0B800h, DS = data segment
; Overwrites: AX, BX, SI, CX
;------------------------------------------------
DRAW_FRAME:
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
; LEFT UPPER CORNER
    mov word si, UPPER_LEFT_CORNER
    mov ax, ds:[si]

    mov word es:[bx], ax ; set UPPER LEFT CORNER
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PUT UPPER SIDE
    add bx, 2h
    add si, 2h ; now cx is UPPER_SIDE ptr
    mov ax, ds:[si]; ax - UPPER_SIDE 

    movzx cx, dl ; cx for counter
    sub cx, 2h   ; width - 2 corners

    jz .right_upper_corner

    cld
.upper_side: 
    mov word es:[bx], ax
    add bx, 2h
    loop .upper_side

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UPPER RIGHT CORNER
.right_upper_corner:
    add si, 2h   ; UPPER RIGHT CORNER ptr
    mov ax, ds:[si] ;

    mov es:[bx], ax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; RIGHT SIDE
    add bx, 50h * 2h ; to point on the first right upper side place 
    
    add si, 2h   ; RIGHT SIDE ptr
    mov ax, ds:[si] ; ax now id RIGHT side

    movzx cx, dh ; cx for counter !!!!!! check that CX > 0 !!!!!
    sub cx, 2h   ; width - 2 corners

    jz .lower_right_corner
    
.right_side:
    mov word es:[bx], ax
    add bx, 50h * 2h
    loop .right_side

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LOWER RIGHT CORNER
.lower_right_corner:
    add si, 2h  ; LOWER RIGHT CORNER ptr
    mov ax, ds:[si]

    mov es:[bx], ax

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LOWER SIDE

    sub bx, 2h ; now bx points to lower side (2 bytes from right corner)

    add si, 2h ; LOWER SIDE PTR
    mov word ax, ds:[si] ; ax now is lower side

    movzx cx, dl
    sub cx, 2h

    jz .lower_left_corner

    cld
.lower_side: 
    mov word es:[bx], ax
    sub bx, 2h
    loop .lower_side

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LOWER LEFT CORNER
.lower_left_corner:

    add si, 2h   ; LOWER RIGHT CORNER ptr
    mov ax, ds:[si] ; set corner symbol
    mov es:[bx], ax ; put him in place

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LEFT SIDE
    sub bx, 50h * 2h ; now it points to almost lowes left part

    add si, 2h   ; LEFT SIDE ptr
    mov ax, ds:[si] ; ax now id RIGHT side

    movzx cx, dh ; cx for counter !!!!!! check that CX > 0 !!!!!
    sub cx, 2h   ; width - 2 corners

    jz .ret

.left_side:
    mov word es:[bx], ax
    sub bx, 50h * 2h
    loop .left_side

.ret:    ret

UPPER_LEFT_CORNER:  db 0dah, 0b11001010
UPPER_SIDE:         db 0c4h, 0b11001010
UPPER_RIGHT_CORNER: db 0bfh, 0b11001010

RIGHT_SIDE:         db 0b3h, 0b11001010

LOWER_RIGHT_CORNER: db 0d9h, 0b11001010
LOWER_SIDE:         db 0c4h, 0b11001010

LOWER_LEFT_CORNER:  db 0c0h, 0b11001010
LEFT_SIDE:          db 0b3h, 0b11001010