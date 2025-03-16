
; |=================================================|
; | <---------------------------------------------> |
; | <------------> MyPrintf FUNCTION <------------> |
; | <---------------------------------------------> |
; |=================================================|

section .text

global MyPrintf

MyPrintf:

        pop r15                                         ; return address

        push r9                                         ; 6th argument
        push r8                                         ; 5th
        push rcx                                        ; 4th
        push rdx                                        ; 3th
        push rsi                                        ; 2th
        push rdi                                        ; 1th

        call Parcing

        cmp r14, 666                                    ; if error
        je .exit

        call FlushBuffer

.exit:
        pop rdi
        pop rsi
        pop rdx
        pop rcx
        pop r8
        pop r9

        push r15

        ret

;=============================================================================
; Parcing string func
; Entry:        all arguments in stack
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

next_parcing:
        mov al, [rsi]

        cmp al, 0
        je exit_parcing

        cmp al, '%'
        je PercentHandler

        call CharCopy
        inc rsi
        jmp next_parcing

exit_parcing:
        mov rsp, rbp
        pop rbp

        ret

PercentHandler:
        inc r12
        inc rsi
        xor rax, rax

        mov al, [rsi]
        mov rax, [jump_table + (rax - 'b')*8]
        jmp rax

Error:

        mov rax, 0x01
        mov rdi, 1
        mov rsi, ErrorMessage
        mov rdx, ErrorMessageLen
        syscall

        mov r14, 666                                    ; error code
        jmp exit_parcing

Binary:
        mov r11, [buf_position]
        movsxd rdx, [rbp + 16 + r12*8]

        call ConvertBin

        inc rsi
        mov [buf_position], r11
        jmp next_parcing

Char:
        movsxd rax, [rbp + 16 + r12*8]

        call CharCopy

        inc rsi
        jmp next_parcing

Decimal:
        mov r11, [buf_position]
        movsxd rdx, [rbp + 16 + r12*8]                  ; save my life... (int 32 bites)

        call ConvertHex

        inc rsi
        mov [buf_position], r11
        jmp next_parcing

;=============================================================================
; Copy one symbol to buffer
; Entry:        al - symbol
; Exit:
; Destr: R11                                                               !!!
;=============================================================================
CharCopy:

        mov r11, [buf_position]
        mov [buffer + r11], al
        inc r11
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

        mov rax, 1
        mov rdi, 1
        mov rsi, buffer
        mov rdx, [buf_position]
        syscall

        mov qword [buf_position], 0

.exit:
        ret


;=============================================================================
; Convert to Binary number
; Entry:        dl = number
;               r11 = buf_pos
; Exit:
; Destr: RDX, RAX, RCX                                                     !!!
;=============================================================================
ConvertBin:

        mov rcx, 31                                     ; 31 bites (0th bit - sign)

        cmp dl, 0
        jng .convert

.find_first:
        mov rax, rdx
        shr rax, cl
        and rax, 1
        cmp rax, 1                                      ; find first 1 for leading zeros
        je .convert
        dec rcx
        cmp rcx, -1
        je .convert
        jmp .find_first

.convert:
        mov rax, rdx
        shr rax, cl
        and rax, 1
        mov al, [digits + rax]                          ; ASCII
        mov [buffer + r11], al
        inc r11
        dec rcx
        jns .convert                                    ; checks SF flag (rcx = -1 -> SF = 1)

        ret

;=============================================================================
; Convert Hex to good numbers
; Entry:        dl = number
;               r11 = buf_pos
; Exit:
; Destr: RBX, RAX, RCX, RDX                                                !!!
;=============================================================================
ConvertHex:

        mov rbx, rdx

        mov r13, r11
        cmp dl, 0
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
        xor rax, rax
        mov al, [digits + rdx]                          ; ASCII
        mov [buffer + r13], al
        inc r13
        cmp rbx, 0
        jg .positive                                    ; signed greater

        xor rax, rax
        xor rbx, rbx

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

ASCII_NULL      equ  "0"
ASCII_NINE      equ  "9"
ASCII_A         equ  "A"
ASCII_F         equ  "F"
ASCII_SPACE     equ  " "
ASCII_SL_N      equ  0Ah
ASCII_SL_R      equ  0Dh

BUFFER_SIZE     equ  4096                               ; Linux page memory size

ErrorMessage    db      "Syntax error!"
ErrorMessageLen equ      $ - ErrorMessage

digits:         db      "0123456789"
buffer          times BUFFER_SIZE  db  0                ; BUFFER_SIZE times 0 byte
buf_position:   dq      0                               ; 8 byte (to match the size of the registers)

jump_table:
                        dq Binary
                        dq Char
                        dq Decimal
 times ('o' - 'd' - 1)  dq Error
;                        dq Octal
;  times ('s' - 'o' - 1) dq Error
;                        dq String
;  times ('x' - 's' - 1) dq Error
;                        dq Hexademical
