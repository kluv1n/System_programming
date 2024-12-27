format ELF64

public _start

extrn initscr
extrn start_color
extrn init_pair
extrn getmaxx
extrn getmaxy
extrn raw
extrn noecho
extrn keypad
extrn stdscr
extrn move
extrn getch
extrn addch
extrn refresh
extrn endwin
extrn exit
extrn timeout
extrn usleep
extrn printw

section '.bss' writable
  xmax dq 1                    ; Максимальная ширина экрана
  ymax dq 1                    ; Максимальная высота экрана
  delay dq 2000                ; Задержка (в микросекундах)
  step dq 1                    ; Шаг движения
  palette dq 0                 ; Палитра

section '.text' executable

_start:
  call initscr
  xor rdi, rdi
  mov rdi, [stdscr]
  call getmaxx
  dec rax
  mov [xmax], rax             ; Сохраняем максимальную ширину экрана
  call getmaxy
  dec rax
  mov [ymax], rax             ; Сохраняем максимальную высоту экрана

  ; Инициализация цветов
  call start_color
  mov rdi, 1                  ; Цветовая пара 1
  mov rsi, 6                  ; Цвет для фона
  mov rdx, 6                  ; Цвет для текста
  call init_pair

  mov rdi, 2                  ; Цветовая пара 2
  mov rsi, 5                  ; Другой цвет для фона
  mov rdx, 5                  ; Другой цвет для текста
  call init_pair

  call refresh
  call noecho
  call raw

  ; Основные переменные
  xor r9, r9                  ; x = 0
  xor r10, r10                ; y = 0

  ; Основной цикл движения
  .main_loop:
    ; Двигаемся из левого верхнего угла в правый нижний
    cmp r9, [xmax]            ; Если x > xmax
    jg .reverse_x             ; Если x > xmax, начинаем двигаться обратно

    cmp r10, [ymax]           ; Если y > ymax
    jg .reverse_y             ; Если y > ymax, начинаем двигаться обратно

    ; Двигаем курсор на экране
    mov rdi, r10              ; y
    mov rsi, r9               ; x
    call move                 ; Двигаем курсор на позицию (x, y)
    mov rdi, [palette]        ; Используем палитру
    call addch                ; Отображаем символ на экране
    call refresh

    ; Получаем ввод пользователя для регулировки скорости
    mov rdi, 1
    call timeout
    call getch
    cmp rax, 'f'              ; Если нажата клавиша 'f', выходим
    je .exit

    cmp rax, 'x'              ; Если нажата клавиша 'x', изменяем скорость
    je .toggle_speed

    ; Установка задержки
    mov rdi, [delay]
    call usleep               ; Задержка перед следующим шагом

    ; Увеличиваем x и y
    inc r9
    inc r10
    jmp .main_loop

  .reverse_x:
    ; Если x достиг xmax, начинаем двигаться влево
    dec r9
    jmp .main_loop

  .reverse_y:
    ; Если y достиг ymax, начинаем двигаться вверх
    dec r10
    jmp .main_loop

  .toggle_speed:
    ; Изменяем скорость движения
    cmp [delay], 2000
    je .fast_speed
    mov [delay], 2000
    jmp .main_loop

  .fast_speed:
    mov [delay], 100         ; Устанавливаем быструю скорость
    jmp .main_loop

  .exit:
    ; Завершаем работу ncurses
    call endwin
    call exit
