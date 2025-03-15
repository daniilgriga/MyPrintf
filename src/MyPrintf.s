
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

        ;push r9                                        ; 6th argument
        ;push r8                                        ; 5th
        ;push rcx                                       ; 4th
        ;push rdx                                       ; 3th
        push rsi                                        ; 2th
        push rdi                                        ; 1th

        ;mov rbx, rdi                                    ; save string address
        ;mov rsi, rbx


        call Parcing
        call FlushBuffer


        pop rdi
        pop rsi
        ;pop rdx
        ;pop rcx
        ;pop r8
        ;pop r9

        pop r11
        pop rbx

        mov rsp, rbp
        pop rbp

        ret


;=============================================================================
; Parcing string func
; Entry:
; Exit:
; Destr:                                                                   !!!
;=============================================================================
Parcing:

        push rbp
        mov rbp, rsp
        mov rsi, [rbp + 16]

        call StrLen

        mov r11, [buf_position]

        mov rax, r11
        add rax, rcx
        cmp rax, BUFFER_SIZE
        jle .continue

        call FlushBuffer
        mov r11, 0

.continue:

        xor r10, r10
        xor r12, r12

.next:
        mov al, [rsi]

        cmp al, 0
        je exit_parcing

        cmp al, '%'
        je PercentHandler

        call CharCopy
        inc rsi
        jmp .next

exit_parcing:
        mov rsp, rbp
        pop rbp

        ret

PercentHandler:

        inc r12
        inc rsi
        xor rax, rax

        mov al, [rsi]
        cmp al, 'd'
        je Decimal

Decimal:
        mov r11, [buf_position]
        mov dl, [rbp + 16 + r12*8]
        mov [buffer + r11], dl
        inc si
        inc r11
        mov [buf_position], r11
        jmp exit_parcing


;=============================================================================
; Copy one symbol to buffer
; Entry:        al - symbol
; Exit:
; Destr:                                                                   !!!
;=============================================================================
CharCopy:

        mov r11, [buf_position]
        mov [buffer + r11], al
        inc r11
        mov [buf_position], r11

        ret

;=============================================================================
;
; Entry:
; Exit:
; Destr:                                                                   !!!
;=============================================================================
FlushBuffer:

        cmp qword [buf_position], 0
        je .exit

        mov rax, 1
        mov rdi, 1
        mov rsi, buffer
        mov rdx, [buf_position]
        syscall

        mov qword [buf_position], 0

.exit:
        ret

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

