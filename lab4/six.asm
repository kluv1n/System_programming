format ELF64

public _start

section '.bss' writable
    input_buffer rb 256
    result_buffer rb 32
    count resb 1            ; Переменная для хранения результата (количества подходящих чисел)

section '.text' executable

include 'func.asm'

_start:
    ; Считывание числа от пользователя
    mov rsi, input_buffer
    call input_keyboard      ; Считываем строку

    ; Преобразование введенной строки в число
    mov rsi, input_buffer
    call str_number          ; Преобразуем строку в число, результат в RAX

    xor rbx, rbx             ; count = 0 (счетчик для количества чисел)
    mov rcx, 1               ; i = 1 (начальное значение для проверки)

check_loop:
    cmp rcx, rax             ; сравниваем i с n
    ja end_loop              ; если i > n, завершаем цикл

    ; Проверка делимости на 5
    mov rdx, 0
    mov rdi, 5
    mov rbx, rcx
    div rdi                  ; rax = i / 5, rdx = i % 5
    test rdx, rdx            ; Проверяем остаток
    jnz next_number          ; Если остаток не равен 0, пропускаем

    ; Проверка делимости на 3
    mov rdx, 0
    mov rdi, 3
    mov rbx, rcx
    div rdi
    test rdx, rdx            ; Проверяем остаток
    jz next_number           ; Если делится на 3, пропускаем

    ; Проверка делимости на 7
    mov rdx, 0
    mov rdi, 7
    mov rbx, rcx
    div rdi
    test rdx, rdx            ; Проверяем остаток
    jz next_number           ; Если делится на 7, пропускаем

    ; Если число прошло все проверки, увеличиваем счетчик
    inc byte [count]

next_number:
    inc rcx                  ; Увеличиваем i
    jmp check_loop           ; Переходим к следующему числу

end_loop:
    ; Преобразование результата (count) в строку для вывода
    movzx rax, byte [count]
    mov rsi, result_buffer
    call number_str

    ; Вывод результата
    mov rsi, result_buffer
    call print_str

    ; Переход на новую строку и завершение программы
    call new_line
    call exit
