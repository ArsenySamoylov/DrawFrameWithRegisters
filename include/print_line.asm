; di - string address
; 
PRINT_LINE:
    
;;;;;;;;;;;;;;;;;;;;;;;;
    push bp
    mov bp, sp

    push '@'
    push '$'
    push di
        call str_number_chr
    add sp, 6h
    mov dx, ax 
    ; inc dx ; dx - number of lines
    
    movzx ax, [bp + 4h] ; ax = height
    sub ax, dx
    mov [bp + 4h], al ; now first line will be centered depending on number of lines

.print_line:
        push '$'
        push '@'
        push di

        call str_chr
        add sp, 6h

        cmp ax, 0h
        je .@

        sub ax, di
        jmp .@@

.@:         push '$'
            push di
            call str_len
            add sp, 4h

.@@:
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

        inc cl
        mov [bp + 6h], cl ; for next line to be printed bellow

        shl ax, 8       ; |
        pop cx          ; |
        add ax, cx      ; |
        mov bx, ax      ; > bx - position
        push bx ; save bx

        push '$'
        push '@'
        push di

        call str_chr
        add sp, 6h

        mov si, di      ; string addres
        mov ch, 2h      ; color
        pop bx          ; position

        cmp ax, 0h
        je .print_last_line

        mov di, ax ; address of newline
        inc di

        mov dl, '@'
        call PUT_STR_WITH_SPECIFIED_TERMINATING_CHAR
        jmp .print_line

.print_last_line:
        call PUT_STR

    pop bp
    ret 



;/////////////////////////////////////////////////////
str_number_chr:
    push bp
    mov bp, sp
    
    push dx ; save dx
    push si ; save si
    push es ; save es

    xor dx, dx

    mov ax, ds ; es = ds
    mov es, ax ; 

    mov bl, [bp + 8h] ; target char         (3 param)
    mov bh, [bp + 6h] ; tertminating symbol (2 param)
    mov si, [bp + 4h] ; string addres       (1 param)
    mov cx, MAX_STR_LENGTH

    cld 
.loop:
    lodsb
    cmp al, bl
    sete dh
    add dl, dh ; dl - accumulator

    cmp al, bh
    je .ret

    loop .loop

.ret:

    movzx ax, dl ; number of occurence

    pop si      ; |
    mov es, si  ; ^ restrore es
    pop si      ; restore si
    pop dx
    pop bp      ; restore bp

    ret