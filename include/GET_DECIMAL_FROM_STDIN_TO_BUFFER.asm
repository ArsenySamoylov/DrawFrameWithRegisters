;------------------------------------------------
; GET DECIMAL FROM STDIN TO BUFFER
;------------------------------------------------
; Entry: DS:DX - buffer addres, where 1-st byte - max input lenght
;                                  2-nd byte - will hold number of read chars
; Owerwrites: AH
;------------------------------------------------
%ifndef D
%define D
GET_DECIMAL_FROM_STDIN_TO_BUFFER:
   
   mov ah, 0ah

   int 21h 

   ret

; BUFFER EXAMPLE for 5 digit decimal
;DEC_INPUT_BUF: db 6h, "%****^$" ; 5h - max input size, * -for chars, ^ - for CR, % - for input length
%endif