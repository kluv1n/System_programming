strcpy:
    xor rax, rax
.loop:
    lodsb
    stosb
    test al, al
    jnz .loop
    ret

; Открытие файла на чтение
open_file:
    mov rax, 2            ; Открыть файл (sys_open)
    mov rsi, 0            ; Только чтение
    mov rdx, 0            ; Без дополнительных флагов
    syscall
    ret

; Открытие файла на запись
open_file_write:
    mov rax, 2            ; Открыть файл (sys_open)
    mov rsi, 577          ; Флаги O_WRONLY | O_CREAT
    mov rdx, 0666         ; Права доступа rw-rw-rw-
    syscall
    ret

; Чтение файла
read_file:
    mov rax, 0            ; sys_read
    mov rdx, 1024         ; Размер буфера
    syscall
    ret

; Запись в файл
write_file:
    mov rax, 1            ; sys_write
    mov rdx, 256          ; Размер данных (буфер для общих символов)
    syscall
    ret

; Заполнить массив учета символов из файла
fill_char_set1:
    ; Для каждого символа в buf1 установить соответствующий байт в char_set1
    xor rcx, rcx          ; Сбросить счетчик
.fill_loop:
    mov al, [rsi + rcx]
    test al, al
    jz .done_fill
    mov [char_set1 + rax], byte 1
    inc rcx
    jmp .fill_loop
.done_fill:
    ret

fill_char_set2:
    ; Для каждого символа в buf2 установить соответствующий байт в char_set2
    xor rcx, rcx          ; Сбросить счетчик
.fill_loop2:
    mov al, [rsi + rcx]
    test al, al
    jz .done_fill2
    mov [char_set2 + rax], byte 1
    inc rcx
    jmp .fill_loop2
.done_fill2:
    ret

; Найти общие символы
find_common_chars:
    xor rcx, rcx          ; Сбросить счетчик
    xor rbx, rbx          ; Сбросить индекс в буфере для общих символов
.find_loop:
    cmp rcx, 256
    jge .done_common
    mov al, [char_set1 + rcx]
    test al, al
    jz .skip
    mov al, [char_set2 + rcx]
    test al, al
    jz .skip
    mov [common_chars + rbx], cl
    inc rbx
.skip:
    inc rcx
    jmp .find_loop
.done_common:
    ret