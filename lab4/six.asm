format ELF64

public _start

include '/workspaces/System_programming/lab4/func.asm'

section '.bss' writable
    input_buffer resb 256  ; Буфер для строк

section '.text' executable
_start:
    ; Ввод числа с клавиатуры
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    call input_keyboard
    mov rsi, input_buffer
    call str_number
    xor r8, r8

    mov rbx, rax            ; Верхняя граница
    xor rdi, rdi            ; Счетчик чисел
    cmp rax, 5
    jl .finish              ; Если число меньше 5, завершаем
    mov rsi, 5              ; Начало диапазона

.main_loop:
    xor rcx, rcx
    xor rdx, rdx
    cmp rsi, rbx
    jg .finish              ; Если больше границы, завершаем

.check_seven_div:
    xor rax, rax
    mov rax, rsi
    xor rcx, rcx
    xor rdx, rdx
    mov rcx, 7              ; Проверка деления на 7
    div rcx
    cmp rdx, 0
    jg .check_three_div     ; Если остаток не 0, проверяем на 3

    add rsi, 5
    cmp rsi, rbx
    jg .finish              ; Если больше границы, завершаем

.check_three_div:
    xor rax, rax
    mov rax, rsi
    xor rcx, rcx
    xor rdx, rdx
    mov rcx, 3              ; Проверка деления на 3
    div rcx
    cmp rdx, 0
    jg .increment_counter   ; Если остаток не 0, увеличиваем счетчик

    add rsi, 5
    cmp rsi, rbx
    jg .finish              ; Если больше границы, завершаем

.increment_counter:
    add rdi, 1              ; Увеличиваем счетчик
    add rsi, 5
    cmp rsi, rbx
    jl .main_loop           ; Продолжаем цикл

.finish:
    mov rax, rdi            ; Выводим результат
    call print_num
    call exit
