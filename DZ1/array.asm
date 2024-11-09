format ELF64

section '.bss' writable
    head rq 1                   ; указатель на начало массива
    tail rq 1                   ; указатель на конец массива
    size rq 1                   ; размер массива в байтах

section '.text' executable
    public init_array
    public free_array
    public arr_push             ; был add_to_end
    public arr_pop              ; был remove_from_start
    public count_odd            ; был count_odd_numbers
    public count_even           ; был count_even_numbers
    public ends_with_one

include 'func.asm'

; Функция инициализации массива
init_array:
    mov rbx, rdi                ; rdi - размер массива (количество элементов)
    imul rbx, 8                 ; умножаем на размер элемента (8 байт для 64-битных чисел)
    mov [size], rbx

    mov rdi, 0                  ; адрес (0 - выбирается системой)
    mov rsi, rbx                ; размер массива
    mov rdx, 0x3                ; PROT_READ | PROT_WRITE
    mov r10, 0x22               ; MAP_PRIVATE | MAP_ANONYMOUS
    mov r8, -1                  ; fd (не используется)
    mov r9, 0                   ; offset
    mov rax, 9                  ; номер syscall для mmap
    syscall

    mov [head], rax             ; сохраняем адрес начала массива
    mov [tail], rax             ; начальное значение tail совпадает с head
    ret

; Функция освобождения массива
free_array:
    mov rdi, [head]             ; адрес массива
    mov rsi, [size]             ; размер массива
    mov rax, 11                 ; номер syscall для munmap
    syscall
    ret

; Функция добавления элемента в конец массива
arr_push:
    mov rbx, [tail]
    mov rcx, [head]
    add rcx, [size]

    cmp rbx, rcx
    jae .overflow

    mov [rbx], rdi              ; добавляем элемент, переданный через rdi
    add rbx, 8                  ; сдвигаем tail на следующий элемент
    mov [tail], rbx

    mov rax, 0
    ret

.overflow:
    mov rax, -1                 ; возвращаем -1 в случае переполнения
    ret

; Функция удаления элемента из начала массива
arr_pop:
    mov rax, [head]
    cmp rax, [tail]
    je .empty                   ; если head == tail, массив пуст

    mov rdi, [rax]              ; сохраняем значение первого элемента для возврата
    add rax, 8                  ; сдвигаем head на следующий элемент
    mov [head], rax
    ret

.empty:
    mov rax, -1                 ; возвращаем -1, если массив пуст
    ret

; Подсчет количества нечетных чисел
count_odd:
    mov rbx, [head]
    xor rcx, rcx                ; счетчик нечетных чисел

.loop_odd:
    cmp rbx, [tail]
    jge .end_odd
    mov rax, [rbx]
    add rbx, 8
    test rax, 1                 ; проверка нечетности (проверяем последний бит)
    jz .loop_odd                ; если четное, пропускаем

    inc rcx                     ; если нечетное, увеличиваем счетчик
    jmp .loop_odd

.end_odd:
    mov rax, rcx                ; возвращаем результат
    ret

; Подсчет количества четных чисел
count_even:
    mov rbx, [head]
    xor rcx, rcx                ; счетчик четных чисел

.loop_even:
    cmp rbx, [tail]
    jge .end_even
    mov rax, [rbx]
    add rbx, 8
    test rax, 1                 ; проверка четности (проверяем последний бит)
    jnz .loop_even              ; если нечетное, пропускаем

    inc rcx                     ; если четное, увеличиваем счетчик
    jmp .loop_even

.end_even:
    mov rax, rcx                ; возвращаем результат
    ret

; Подсчет количества чисел, оканчивающихся на 1
ends_with_one:
    mov rbx, [head]
    xor rcx, rcx                ; счетчик чисел, оканчивающихся на 1

.loop_one:
    cmp rbx, [tail]
    jge .end_one
    mov rax, [rbx]
    add rbx, 8

    mov rdx, 0
    mov rdi, 10
    div rdi                      ; делим на 10, остаток в rdx
    cmp rdx, 1                   ; проверка, если остаток == 1
    jne .loop_one                ; если нет, переходим к следующему числу

    inc rcx                      ; если да, увеличиваем счетчик
    jmp .loop_one

.end_one:
    mov rax, rcx                 ; возвращаем результат
    ret
