format ELF64

public _start

section '.bss' writable
    buffer db 1

section '.text' executable

; Функция для преобразования строки в число
string_to_number:
    push rcx
    push rbx

    xor rax, rax   ; результат
    xor rcx, rcx   ; индекс

.loop:
    xor rbx, rbx
    mov bl, byte [rsi + rcx] ; получаем текущий символ
    cmp bl, 48               ; проверяем, что символ >= '0'
    jl .is_finished_check
    cmp bl, 57               ; проверяем, что символ <= '9'
    jg .is_finished_check

    sub bl, 48               ; преобразуем символ в число
    imul rax, rax, 10        ; умножаем результат на 10
    add rax, rbx             ; добавляем текущую цифру
    inc rcx
    jmp .loop

.is_finished_check:
    pop rbx
    pop rcx
    ret

; Функция для нахождения первой значащей цифры числа k
first_digit:
    test rax, rax            ; проверка, что rax != 0
    jz .return_zero          ; если 0, возвращаем 0

.next_digit:
    cmp rax, 10
    jl .found_first_digit
    xor rdx, rdx
    mov rbx, 10
    div rbx                  ; делим rax на 10, пока не найдем первую цифру
    jmp .next_digit

.return_zero:
    mov rax, 0               ; если k == 0, возвращаем 0
    ret

.found_first_digit:
    ret

; Функция для вывода числа
print_symbol:
    xor rbx, rbx
    cmp rax, 9
    jle .one_sym

    mov rcx, 10
.loop:
    xor rdx, rdx
    div rcx
    push rdx
    inc rbx
    test rax, rax
    jnz .loop

.print_loop:
    pop rax
    add rax, '0'
    mov [buffer], al

    mov eax, 1
    mov edi, 1
    mov rsi, buffer
    mov edx, 1
    syscall

    dec rbx
    jnz .print_loop
    ret

.one_sym:
    add rax, '0'
    mov [buffer], al

    mov eax, 1
    mov edi, 1
    mov rsi, buffer
    mov edx, 1
    syscall
    ret

_start:
    ; Проверяем, что есть аргумент командной строки (число n)
    pop rcx
    cmp rcx, 2
    jne exit

    ; Преобразуем аргумент командной строки в число n
    mov rsi, [rsp + 8]
    call string_to_number
    mov rcx, rax              ; n сохраняется в rcx

    ; Инициализируем счетчик и сумму
    xor rbx, rbx              ; rbx будет содержать сумму
    xor rdx, rdx              ; счетчик k

calc_loop:
    inc rdx                   ; k++
    mov rax, rdx              ; rax = k
    call first_digit          ; находим первую цифру k
    mov rbx, rax              ; сохраняем первую цифру k в rbx

    ; Если первая цифра равна 0, пропускаем шаг (проверка)
    test rbx, rbx
    jz .skip_multiply

    mov rax, rdx              ; rax = k
    imul rax, rbx             ; умножаем k на первую цифру
    add rbx, rax              ; добавляем результат к сумме

.skip_multiply:
    cmp rdx, rcx              ; проверяем, не достигли ли n
    jl calc_loop              ; продолжаем цикл

    ; Выводим результат
    mov rax, rbx              ; rax = сумма
    call print_symbol

exit:
    mov eax, 60               ; системный вызов выхода
    xor edi, edi
    syscall
