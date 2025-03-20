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
