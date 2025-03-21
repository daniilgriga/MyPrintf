%macro pushs 1-*
    %rep %0
        push %1
        %rotate 1
    %endrep
%endmacro

%macro pops 1-*
    %rep %0
        pop %1
        %rotate 1
    %endrep
%endmacro

%macro CharCopy 0
        cmp r11, BUFFER_SIZE
        jne .skip
        mov qword [buf_position], r11
        call FlushBuffer

.skip:
        mov r11, [buf_position]
        mov [buffer + r11], al
        inc r11
        mov [buf_position], r11
%endmacro
