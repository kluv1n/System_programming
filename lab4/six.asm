format ELF64

public _start

include 'func2.asm'

section '.bss' writable
    output dq 0
    input_buffer rb 255
    num_str db 20  ; Строка для числа, длиной 20 символов

section '.text' executable
_start:
    ; Чтение строки с клавиатуры
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    call input_keyboard

    ; Преобразование строки в число
    mov rsi, input_buffer
    call str_number

    ; Инициализация счетчиков
    xor r8, r8
    mov rbx, rax
    xor rdi, rdi
    cmp rax, 5
    jl .finish
    mov rsi, 5

.main_loop:
    xor rcx, rcx
    xor rdx, rdx
    cmp rsi, rbx
    jg .finish

.check_seven_div:
    xor rax, rax
    mov rax, rsi
    xor rcx, rcx
    xor rdx, rdx
    mov rcx, 7
    div rcx
    cmp rdx, 0
    jg .check_three_div

    add rsi, 5
    cmp rsi, rbx
    jg .finish

.check_three_div:
    xor rax, rax
    mov rax, rsi
    xor rcx, rcx
    xor rdx, rdx
    mov rcx, 3
    div rcx
    cmp rdx, 0
    jg .increment_counter

    add rsi, 5
    cmp rsi, rbx
    jg .finish

.increment_counter:
    add rdi, 1
    add rsi, 5
    cmp rsi, rbx
    jl .main_loop

.finish:
    ; Преобразование результата в строку
    mov rsi, num_str  ; Адрес строки
    mov rax, rdi      ; Число для вывода
    call number_str   ; Преобразовать число в строку

    ; Вывод строки
    mov rsi, num_str  ; Адрес строки
    call print_str    ; Вывести строку

    ; Переход на новую строку
    call new_line     ; Печать новой строки

    call exit
