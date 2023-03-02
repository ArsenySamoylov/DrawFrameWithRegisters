; di - string address
; 
PRINT_LINE:
    push bp
    mov bp, sp

    push '$'
    push di

    call str_len ; ax = length

    add sp, 4h

    movzx cx, [bp + 5h] ; cx = width
    sub ax, cx
    neg ax              ; ax = - (length - width)

    shr ax, 1 

    movzx cx, [bp + 7h] ; cx - frame x coordinate
    add ax, cx          ; ax - x coordinate for middle

    push ax             ; x coorfinate for string

    movzx cx, [bp + 6h] ; cx = y coordinate
    movzx ax, [bp + 4h] ; ax = height
    
    shr ax, 1
    add ax, cx          ; calculated row for string 


    ; mov si, di          ; I hope di is still alive! (BE CAREFULL!!!)
    mov si, di
    shl ax, 8
    pop cx

    add ax, cx
    mov bx, ax

    mov ch, 2h      ; color
    call PUT_STR

    pop bp
    ret 
