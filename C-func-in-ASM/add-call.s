
section .text

extern add_func
extern printf

global _start

_start:

        mov rdi, 5
        mov rsi, 13

        call add_func

        mov rdi, OutputMessage
        mov rsi, rax
        mov rdx, '!'
        call printf WRT ..plt

; ===========================================================================================
;    'call printf WRT ..plt' is a special syntax in NASM for calling functions through
;    the PLT (Procedure Linkage Table).
;    The PLT is used for dynamic linking. When you call 'printf',
;    which resides in 'libc' (a dynamic library), the address of the 'printf'
;    function is not known at compile time. Instead, a stub in the PLT is called,
;    which, on its first invocation,resolves the address of 'printf'
;    through the dynamic loader ('ld.so') and then transfers control to the actual function.
;    'WRT ..plt' (With Respect To ..plt)
;    tells NASM to use the PLT for calling 'printf'.
; ===========================================================================================

        mov rax, 60       ; sys_exit
        xor rdi, rdi
        syscall

section .data

OutputMessage     db      "Sup, program was started", 0xA, "Output: %d%c", 0xA, "Exit...", 0xA
