format ELF64
public _start
public exit

section '.data' writable
    n dq 0
    result dq 0   ; Переменная для хранения результата
    buffer rb 20
    minus db '-'

section '.text' executable
_start:
    pop rcx
    pop rsi
    pop rsi
    call string_to_number
    mov [n], rax
    mov rcx, [n]

    .iter:
        mov rax, rcx
        call first_digit
        mul rcx
        ;add [result], rcx
        add [result], rax

    loop .iter

    mov rax, [result] ;вывод
    mov rbx, buffer
    mov rcx, 20
    call number_to_string
    mov rax, buffer
    call print

    call exit

first_digit:
    push rbx
    push rcx
    push rdx
    cmp rax, 9
    jle .pos8
    .pos7:
    xor rdx, rdx      ; обнулить остаток
    mov rcx, 10
    div rcx         ; делим rax на 10
    cmp rax, 10      
    jge .pos7
    .pos8:
    pop rdx
    pop rcx
    pop rbx
    ret

; Процедура для преобразования целого числа в строку
; rax = number
; rbx = buffer
; rcx = buffer size
number_to_string:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi

    cmp rax, 0              ; проверяем, меньше ли число 0
    jge .pos               ; если число положительное или ноль, переходим на метку ._pos
    ._neg:
      neg rax               ; если число отрицательное, меняем его знак на положительный
      push rax              ; сохраняем положительное значение на стеке
      push rbx
      push rdx
      mov rax, 4
      mov rcx, minus        ; загружаем символ '-' в rax (для вывода минуса)
      mov rbx, 1 ; stdout
      mov rdx, 1; длина сообщения
      int 0x80
      pop rdx
      pop rbx
      pop rax
    
    .pos:
    mov rsi, rcx
    dec rsi
    xor rcx, rcx
    .next_iter:
        push rbx
        mov rbx, 10
        xor rdx, rdx
        div rbx
        pop rbx
        add rdx, '0'
        push rdx
        inc rcx
        cmp rax, 0
        je .next_step
        jmp .next_iter
    .next_step:
        mov rdx, rcx
        xor rcx, rcx
    .to_string:
        cmp rcx, rsi
        je .pop_iter
        cmp rcx, rdx
        je .null_char
        pop rax
        mov [rbx+rcx], rax
        inc rcx
        jmp .to_string
    .pop_iter:
        cmp rcx, rdx
        je .close
        pop rax
        inc rcx
        jmp .pop_iter
    .null_char:
        mov rsi, rdx
    .close:
        mov [rbx+rsi], byte 0
        pop rsi
        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret

string_to_number:
    push rsi
    push rbx
    push rcx
    push rdx 

    xor al, al
    xor rcx, rcx
    cmp byte [rsi], '-'
    jne .next_char
    mov al, 1 
    inc rcx

    .next_char:
        movzx rbx, byte [rsi + rcx] ; Загружаем текущий символ строки в rbx
        cmp bl, 0                ; Проверяем, достигли ли конца строки
        je .finished             ; Если символ нулевой, заканчиваем

        cmp bl, '0'             
        jl .finished             ; Если символ меньше '0', завершаем
        cmp bl, '9'
        jg .finished             ; Если символ больше '9', завершаем

        sub bl, '0'              ; Преобразуем символ в число (ASCII '0' = 48)
        
        ; Умножаем текущее значение rax на 10 и добавляем новую цифру
        mov rdx, 10
        mul rdx                  
        add rax, rbx             
        
        ; Увеличиваем счетчик и продолжаем цикл
        inc rcx
        jmp .next_char
        
    test al, 1            
    jz .finished               ; если флаг 0 пропускаем инверсию
        neg rax  
    .finished:
    pop rdx
    pop rcx
    pop rbx
    pop rsi
    ret

print:
    push rax
    push rbx
    push rcx
    push rdx
    mov rcx, rax
    mov rax, 4 ; write
    mov rbx, 1 ; stdout
    mov rdx, 20 ; длина сообщения
    int 0x80
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

exit:
    mov rax, 1     
    xor rbx, rbx   
    int 0x80