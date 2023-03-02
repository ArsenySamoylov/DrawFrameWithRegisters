%include "debug.asm"
%include "macroses.asm"

org 100h

Start:

    push 26d
    push  STRING
    push DESTINATION

    call mem_cpy

    __GETCH

    __EXIT 0

STRING: db "Hello world, my dear !$"
DESTINATION: resb 10h
%include "GET_HEX_VALUE_FROM_BUFFER_TO_AX.asm"

%include "PUT_STR.ASM"
%include "PUT_IN_BINARY_AX.asm"
%include "PUT_HEX_DX_IN_BUFFER.asm"
%include "PUT_DECIMAL_IN_BUFFER.asm"

%include "strlen.asm"
%include "str_chr.asm"
%include "str_cpy.asm"
%include "mem_cpy.asm"