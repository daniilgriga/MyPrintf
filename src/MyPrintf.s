
; |=================================================|
; | <---------------------------------------------> |
; | <------------> MyPrintf FUNCTION <------------> |
; | <---------------------------------------------> |
; |=================================================|

%include "macros.inc"
section .text

global MyPrintf

MyPrintf:

        pop   r10                                       ; return address
        pushs r9, r8, rcx, rdx, rsi, rdi
        push  r11

        jmp Parsing

return:
        pop  r11
        pops rdi, rsi, rdx, rcx, r8, r9
        push r10

        ret

;=============================================================================
; Parsing string func
; Entry:        all arguments in stack
; Exit:
; Destr: all                                                               !!!
;=============================================================================
Parsing:

        push rbp
        mov rbp, rsp
        mov rsi, [rbp + 16]

        xor r12, r12

next_parsing:
        mov al, [rsi]

        cmp al, 0
        je exit_parsing

        cmp al, '%'
        je PercentHandler

        CharCopy
        inc rsi
        jmp next_parsing

exit_parsing:
        cmp rax, 666                                    ; if error code
        je .skip_flush
        call FlushBuffer

.skip_flush:
        mov rsp, rbp
        pop rbp
        jmp return

PercentHandler:
        inc r12
        inc rsi
        xor rax, rax

        mov al, [rsi]

        cmp al, '%'
        jne .skip_percent

        CharCopy
        inc rsi
        dec r12
        jmp next_parsing

.skip_percent:
        cmp al, 'b'
        jb Error

        cmp al, 'x'
        ja Error

        mov rax, [jump_table + (rax - 'b')*8]
        jmp rax

Error:
        mov rax, 0x01
        mov rdi, 1
        mov rsi, ErrorMessage
        mov rdx, ErrorMessageLen
        syscall

        mov byte [buf_position], 0

        mov rax, 666                                    ; error code
        jmp exit_parsing

Binary:
        mov r11, [buf_position]
        movsxd rbx, [rbp + 16 + r12*8]
        mov rdi, 2

        call Converter

        inc rsi
        mov [buf_position], r11
        jmp next_parsing

Char:
        movsxd rax, [rbp + 16 + r12*8]

        CharCopy

        inc rsi
        jmp next_parsing

Decimal:
        mov r11, [buf_position]
        movsxd rdx, dword [rbp + 16 + r12*8]            ; save my life... (int 32 bites)

        call ConvertDec

        inc rsi
        mov [buf_position], r11
        jmp next_parsing

Octal:
        mov r11, [buf_position]
        mov ebx, [rbp + 16 + r12*8]
        mov rdi, 8

        call Converter

        inc rsi
        mov [buf_position], r11
        jmp next_parsing

Hexademical:
        mov r11, [buf_position]
        mov ebx, [rbp + 16 + r12*8]
        mov rdi, 16

        call Converter

        inc rsi
        mov [buf_position], r11
        jmp next_parsing

String:
        mov rdi, rsi
        mov rsi, [rbp + 16 + r12*8]
        mov al, [rsi]
        cmp al, 0
        je Error

        call StringCopy
        jmp next_parsing

;=============================================================================
; Copy string to buffer
; Entry:        rsi = address
;               r11 = buf_position
; Exit:
; Destr: R11                                                               !!!
;=============================================================================
StringCopy:

.copy:
        cmp r11, BUFFER_SIZE
        jne .skip
        mov qword [buf_position], r11
        call FlushBuffer
        xor r11, r11

.skip:
        mov al, [rsi]
        mov [buffer + r11], al

        inc r11
        dec rcx
        inc rsi
        cmp al, 0
        jne .copy

        mov rsi, rdi
        inc rsi
        mov [buf_position], r11
        ret

;=============================================================================
; Func to Flush the Buffer
; Entry:
; Exit:
; Destr: RAX, RDI, RSI, RDX                                                !!!
;=============================================================================
FlushBuffer:

        cmp qword [buf_position], 0
        je .exit

        pushs r11, rcx, rax, rdi, rsi, rdx

        mov rax, 1
        mov rdi, 1
        mov rsi, buffer
        mov rdx, [buf_position]
        syscall

        mov qword [buf_position], 0

        pops rdx, rsi, rdi, rax, rcx, r11

.exit:
        ret

;=============================================================================          ;|-------|---------------------------------------------|
; Converter to Binary, Octal and Hexidemical                                            ;|  rax  |                 bit mask                    |
; Enter:        rbx = 32 bit number                                                     ;|-------|---------------------------------------------|
;               rdi = base                                                              ;|  r15  |        number of bits for one symbol        |
;               r11 = buf_position                                                      ;|-------|---------------------------------------------|
; Destr: RAX, RBX, RDX, R8, R11, R14, R15                                  !!!          ;|  r14  |                   radix                     |
;=============================================================================          ;|-------|---------------------------------------------|
Converter:                                                                              ;|  r11  |              buffer position                |
        push r12                                                                        ;|-------|---------------------------------------------|
        mov r14, rdi

        xor rcx, rcx
        mov rax, 1

.count_n_bits:
        cmp rax, r14
        je .find_bit_mask
        inc rcx
        shl rax, 1
        jmp .count_n_bits

.find_bit_mask:
        mov r15, rcx                                    ; numb bits for one symb
        dec rax                                         ; bit mask

        mov rcx, 32
        cmp rdi, 8
        jne .find_first
        inc rcx

.find_first:
        sub rcx, r15
        mov rdx, rbx
        shr rdx, cl
        and rdx, rax
        cmp edx, 0                                      ; find first not zero for leading zeros
        jne .convert
        cmp rcx, -1
        jle .convert
        jmp .find_first

.convert:

        cmp r11, BUFFER_SIZE
        jne .skip_flush
        mov qword [buf_position], r11
        call FlushBuffer
        xor r11, r11

.skip_flush:
        push rcx
        mov rdx, rbx
        shr rdx, cl
        and rdx, rax

        mov cl, [digits + rdx]                          ; print in buffer
        mov [buffer + r11], cl

        inc r11
        pop rcx
        sub rcx, r15

        jge .convert
        jmp .exit

.exit:
        pop r12
        ret

;=============================================================================
; Converter to Decimal
; Entry:        dl = number
;               r11 = buf_pos
; Exit:
; Destr: RBX, RAX, RCX, RDX                                                !!!
;=============================================================================
ConvertDec:

        mov rbx, rdx

        mov r13, r11
        cmp rbx, 0
        jge .positive                                   ; >= 0

        mov byte [buffer + r13], '-'
        inc r13
        inc r11
        neg rbx

.positive:
        xor rdx, rdx
        mov rax, rbx
        mov rbx, 10
        div rbx                                         ; rax - quotient, rdx - remainder

        mov rbx, rax
        mov al, [digits + rdx]                          ; ASCII
        mov [buffer + r13], al
        inc r13
        cmp rbx, 0
        jg .positive                                    ; signed greater

        push r13

.turn_over:
        cmp r11, r13
        jge .exit

        mov al, [buffer + r13 - 1]
        mov bl, [buffer + r11]
        mov [buffer + r13 - 1], bl
        mov [buffer + r11], al

        inc r11
        dec r13
        jmp .turn_over

.exit:
        pop r11

        ret


section .data

ASCII_NULL      equ  "0"
ASCII_NINE      equ  "9"
ASCII_A         equ  "A"
ASCII_F         equ  "F"
ASCII_SPACE     equ  " "
ASCII_SL_N      equ  0Ah
ASCII_SL_R      equ  0Dh

BUFFER_SIZE     equ  102                               ; Linux page memory size (4096 bytes)

ErrorMessage    db      "Syntax error!", 0xA
ErrorMessageLen equ      $ - ErrorMessage

digits:         db      "0123456789abcdef"
buffer          times   BUFFER_SIZE  db  0              ; BUFFER_SIZE times 0 byte
buf_position:   dq      0                               ; 8 byte (to match the size of the registers)

jump_table:
                        dq Binary
                        dq Char
                        dq Decimal
 times ('o' - 'd' - 1)  dq Error
                        dq Octal
 times ('s' - 'o' - 1)  dq Error
                        dq String
 times ('x' - 's' - 1)  dq Error
                        dq Hexademical
