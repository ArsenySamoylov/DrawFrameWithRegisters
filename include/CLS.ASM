;------------------------------------------------
; Clear screen
;------------------------------------------------
; Entry: ah - color atr
;        al - symbol 
; Expects:    ES = b800H
; Overwrites: BX, CX
; Exit:       none
;------------------------------------------------
CLR_SCR:
		
		xor bx, bx
		mov cx, 80d * 25d

Next: mov es:[bx], ax
        add bx, 2h

        loop Next
        
        ret