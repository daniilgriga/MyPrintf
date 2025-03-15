
; |=================================================|
; |                                                 |
; |                MyPrintf FUNCTION                |
; |                                                 |
; |=================================================|

section .text

global MyPrintf

MyPrintf:

        push rbp
        mov rbp, rsp
        sub rsp, 8                                      ; stack alignment on 16-byte boundary

        push rbx                                        ; save
        push r11                                        ; save

        mov rbx, rdi                                    ; save string address

        mov rsi, rbx
        call StrLen

        ;call StringParcing

        push r11
        push rbx

        mov rsp, rbp
        pop rbp

        ret

;=============================================================================
;
; Entry:
; Exit:
; Destr:                                                                   !!!
;=============================================================================
;StringParcing:

;        mov r11, [buf_position]

;        mov rax, r11
;        add rax, rcx
;        cmp rax, BUFFER_SIZE


;=============================================================================
; Count length of string
; Entry:        rsi = string offset
; Exit:         rcx = length of string
; Destr: AL                                                                !!!
;=============================================================================
StrLen:

        push rbx
        mov rbx, rsi
        xor rcx, rcx
.cycle:
        mov al, [rbx]
        cmp al, 0
        je .match

        inc cl
        inc rbx
        jmp .cycle

.match:
        pop rbx

        ret

section .data

        BUFFER_SIZE  equ  4096                          ; Linux page memory size

buffer:
        times BUFFER_SIZE  db  0                        ; BUFFER_SIZE times 0 byte

buf_position:
        dq  0                                           ; 8 byte (to match the size of the registers)

