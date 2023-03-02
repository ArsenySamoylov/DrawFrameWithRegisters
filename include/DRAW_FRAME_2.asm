;------------------------------------------------
; Draw frame on the screen
; (new to this version: you can set background)
;------------------------------------------------
; Entry: bx - addres of symbols and attributes
;        ah - x cordinate
;        al - y cordinate                               
;        dh - width
;        dl - height
; Expects: ES = 0B800h   
;                                                                                                            
; Overwrites: AX, CX, BX, DX, DI, SI
; Calls: DRAW_LINE
;
; Note: this function uses fact, that after 
;       DRAW_LINE call di points to end of line
;------------------------------------------------
DRAW_FRAME_2:

    mov ch, 50h
    sub ch, dh
    movsx si, ch 
    shl si, 1 ; from now si+di will be used to point on new line (look in Note)
    
    movsx di, ah
    mov cl, 50h
    mul cl
    add di, ax
    shl di, 1 ; di - starting position
;................................................
    movsx cx, dh ; ch - width, argument for DRAW_LINE
    call DRAW_LINE ; draw upside

    add bx, 6h ; bx - points to next set of symbols
    sub dl, 2h ; dl - cnt for drawing body frame loop
    
    cmp dl, 0h ; if (dl == 0) -> {skip drawing body}
    je .draw_lower_side
;................................................
; Draw midle of frame
    .iteration:
        add di, si ; set di to new line
        movsx cx, dh ; cx - width, argument for DRAW_LINE
        call DRAW_LINE

        sub dl, 1h
        jnz .iteration
;................................................
.draw_lower_side:
    add bx, 6h
    add di, si
    movsx cx, dh

    call DRAW_LINE ; draw downside
    
    ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Entry: di - addres of video mem
;        bx - addres of symbols and attributes
;        cx - width
; Expect: es - -b800h
; Overwrites: AX, CX, DI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_LINE:
    cld ; set for stosw

    mov ax, [bx] ; ax - left symbol + attributes
    stosw ; es:[di] = ax, di += 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    mov ax, [bx + 2h] ; ax - midle symbol + attributes 

    sub cx, 2h ; cx - counter for putting midle of line loop
    je .avoid_loop ; if (cx == 0) -> {skip loop}

.loop:
    stosw      ; es:[di] = ax, di += 2
    loop .loop ; cx--

.avoid_loop:
    mov ax, [bx + 4h] ; ax - left symbol

    stosw ; es:[di] = ax, di += 2

    ret
