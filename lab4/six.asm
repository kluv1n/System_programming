format ELF64                  ; Указываем 64-битный ELF формат
entry _start                  ; Точка входа в программу

section .bss                  ; Секция для неинициализированных данных
    input_buffer resb 256     ; Буфер для ввода (256 байт)
    result_buffer resb 32     ; Буфер для результата (32 байта)
    count resb 1              ; Переменная для хранения количества чисел

section .text                 ; Секция кода, должна быть исполняемой
    ; Внешние функции
    extern input_keyboard
    extern str_number
    extern number_str
    extern print_str
    extern new_line
    extern exit

_start:
    ; Чтение числа пользователя
    mov rsi, input_buffer
    call input_keyboard       ; Ввод числа с клавиатуры

    ; Преобразование строки в число
    mov rsi, input_buffer
    call str_number           ; Преобразование строки в число, результат в RAX

    ; Сброс счетчика
    xor rbx, rbx              ; count = 0
    mov rcx, 1                ; Начинаем проверку с числа 1

check_loop:
    cmp rcx, rax              ; Сравниваем текущее значение с введенным числом
    ja end_loop               ; Если больше, выходим из цикла

    ; Проверка делимости на 5
    mov rdx, 0
    mov rbx, rcx
    mov rdi, 5
    div rdi                   ; rax = rcx / 5, rdx = rcx % 5
    test rdx, rdx             ; Проверяем остаток от деления на 5
    jnz next_number           ; Если не делится на 5, переходим к следующему числу

    ; Проверка делимости на 3
    mov rdx, 0
    mov rbx, rcx
    mov rdi, 3
    div rdi                   ; rax = rcx / 3, rdx = rcx % 3
    test rdx, rdx             ; Проверяем остаток от деления на 3
    jz next_number            ; Если делится на 3, переходим к следующему числу

    ; Проверка делимости на 7
    mov rdx, 0
    mov rbx, rcx
    mov rdi, 7
    div rdi                   ; rax = rcx / 7, rdx = rcx % 7
    test rdx, rdx             ; Проверяем остаток от деления на 7
    jz next_number            ; Если делится на 7, переходим к следующему числу

    ; Если число прошло все проверки, увеличиваем счетчик
    inc byte [count]

next_number:
    inc rcx                   ; Увеличиваем текущее число
    jmp check_loop            ; Возвращаемся в начало цикла

end_loop:
    ; Преобразование результата в строку
    movzx rax, byte [count]
    mov rsi, result_buffer
    call number_str

    ; Вывод результата
    mov rsi, result_buffer
    call print_str

    ; Переход на новую строку и завершение программы
    call new_line
    call exit
