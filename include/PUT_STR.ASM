;------------------------------------------------
; Put string using its addreaa on screen,
;       via x, y position
;------------------------------------------------
; Entry: SI - string address  
;        BH - y position
;        BL - x position
;        CH - color 
; Exit: none
; Expects: ES = 0B800h
; Overwrites: AX, CL, BX, SI
;------------------------------------------------
PUT_STR: 
        
        xor ax, ax ; clear ax

        mov al, bh ; move y to al to then multiply 
        mov bh, 0h

        mov cl, 50h
        mul cl

        add bx, ax ; total pos
        
        shl bx, 1 ; x2

??AGAIN:	
        mov cl, [si]

        cmp cl, '$'
        je ??RETURN

        mov es:[bx], cx

        add bx, 2h
	    inc si

	    jmp ??AGAIN

??RETURN:
        ret

;------------------------------------------------
; Put string using its addreaa on screen,
;       via x, y position
;------------------------------------------------
; Entry: SI - string address  
;        BH - y position
;        BL - x position
;        CH - color 
;        Dl - terminatinc symbol
; Exit: none
; Expects: ES = 0B800h
; Overwrites: AX, CL, BX, SI
;------------------------------------------------
PUT_STR_WITH_SPECIFIED_TERMINATING_CHAR: 
        
        xor ax, ax ; clear ax

        mov al, bh ; move y to al to then multiply 
        mov bh, 0h

        mov cl, 50h
        mul cl

        add bx, ax ; total pos
        
        shl bx, 1 ; x2

.AGAIN:	
        mov cl, [si]

        cmp cl, dl
        je .RETURN

        mov es:[bx], cx

        add bx, 2h
	    inc si

	    jmp .AGAIN

.RETURN:
        ret