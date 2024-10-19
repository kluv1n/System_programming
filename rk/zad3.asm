format PE console 4.0
entry start

include 'win32a.inc'

section '.data' data readable writeable
    directory db 260 dup(0)          ; буфер для имени каталога
    find_data WIN32_FIND_DATAW       ; структура для хранения данных о файле
    file_list dd 100 dup(0)          ; массив указателей на имена файлов
    file_count dd 0                  ; количество файлов
    random1 dd 0                     ; индекс первого случайного файла
    random2 dd 0                     ; индекс второго случайного файла
    err_msg db 'Error: please provide a valid directory as an argument.', 0xA, 0
    file_handle dd 0                 ; дескриптор файла
    bytes_read dd 0                  ; количество считанных байт
    file_buffer1 rb 65536            ; буфер для первого файла (64 КБ)
    file_buffer2 rb 65536            ; буфер для второго файла (64 КБ)

section '.bss' data readable writeable
    ; Здесь могут быть неинициализированные данные

section '.text' code readable executable
start:
    ; Получаем аргумент командной строки (имя каталога)
    invoke GetCommandLine
    invoke CommandLineToArgvW, eax, file_count
    mov eax, [file_count]
    cmp eax, 2                      ; проверяем, что передан хотя бы один аргумент
    je process_directory
    invoke printf, err_msg
    invoke ExitProcess, 1

process_directory:
    mov ebx, [file_count+4]          ; берем второй аргумент (имя каталога)
    invoke FindFirstFile, ebx, find_data
    cmp eax, INVALID_HANDLE_VALUE
    je no_files                      ; если не удалось открыть каталог

    ; Чтение всех файлов в каталоге
    mov [file_list], 0               ; начнем с нуля
    .read_loop:
        lea edi, [file_list+file_count*4]  ; место для нового имени
        mov [edi], eax               ; сохраняем указатель на файл
        inc dword [file_count]
        invoke FindNextFile, [file_list], find_data
        cmp eax, 0
        jne .read_loop

    ; Генерация двух случайных индексов
    invoke GetTickCount
    mov edx, eax
    xor edx, [file_count]            ; случайное число на основе количества файлов
    xor edx, [file_count+4]
    mov [random1], edx
    invoke GetTickCount
    xor eax, [random1]
    mov [random2], eax

    ; Проверяем, что два случайных файла не совпадают
    cmp [random1], [random2]
    je process_directory             ; если совпали, генерируем заново

    ; Открытие первого файла и чтение его содержимого
    lea eax, [file_list+random1*4]
    invoke CreateFile, [eax], GENERIC_READ, 0, 0, OPEN_EXISTING, 0, 0
    mov [file_handle], eax
    invoke ReadFile, [file_handle], file_buffer1, 65536, bytes_read, 0
    invoke CloseHandle, [file_handle]

    ; Открытие второго файла и чтение его содержимого
    lea eax, [file_list+random2*4]
    invoke CreateFile, [eax], GENERIC_READ, 0, 0, OPEN_EXISTING, 0, 0
    mov [file_handle], eax
    invoke ReadFile, [file_handle], file_buffer2, 65536, bytes_read, 0
    invoke CloseHandle, [file_handle]

    ; Пишем содержимое первого файла во второй
    lea eax, [file_list+random2*4]
    invoke CreateFile, [eax], GENERIC_WRITE, 0, 0, CREATE_ALWAYS, 0, 0
    mov [file_handle], eax
    invoke WriteFile, [file_handle], file_buffer1, 65536, bytes_read, 0
    invoke CloseHandle, [file_handle]

    ; Пишем содержимое второго файла в первый
    lea eax, [file_list+random1*4]
    invoke CreateFile, [eax], GENERIC_WRITE, 0, 0, CREATE_ALWAYS, 0, 0
    mov [file_handle], eax
    invoke WriteFile, [file_handle], file_buffer2, 65536, bytes_read, 0
    invoke CloseHandle, [file_handle]

    ; Завершение программы
    invoke ExitProcess, 0

no_files:
    invoke printf, err_msg
    invoke ExitProcess, 1
