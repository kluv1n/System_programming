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
  extrn clear
  extrn addch
  extrn refresh
  extrn endwin
  extrn exit
  extrn color_pair
  extrn insch
  extrn cbreak
  extrn timeout
  extrn mydelay
  extrn setrnd
  extrn get_random


  section '.bss' writable

  xmax dq 1
  ymax dq 1
  rand_x dq 1
  rand_y dq 1
  palette dq 1
  count dq 1
  delay_time dq 10  ; Задержка в миллисекундах

  section '.data' writable

  digit db '0123456789'
  place db ?
  minus db "-", 0

  section '.text' executable

_start:
  ;; Инициализация
  call initscr

  ;; Размеры экрана
  xor rdi, rdi
  mov rdi, [stdscr]
  call getmaxx
  mov [xmax], rax
  call getmaxy
  mov [ymax], rax

  call start_color
  ;; Магента цвет
  mov rdx, 0x5
  mov rsi, 0x0
  mov rdi, 0x2
  call init_pair

  ;; Зеленый цвет
  mov rdx, 0x2
  mov rsi, 0x0
  mov rdi, 0x1
  call init_pair

  call refresh
  call noecho
  call cbreak
  call setrnd

  ;; Начальная инициализация палитры
  call get_digit
  or rax, 0x100
  mov [palette], rax
  mov [count], 0

  xor r15, r15
  xor rbp, rbp
  xor r12, r12
  xor r13, r13
  xor r14, r14

  mov rbp, 3
  mov r15, 1
  mov r12, 0
  mov r13, 1
  mov r14, 2
  jmp mloop

mloop:
  @@:
  cmp r12, 0
  je .down
  cmp r12, 1
  je .right
  cmp r12, 2
  je .up
  cmp r12, 3
  je .left
  jmp @f

  .down:
    inc r14
    cmp r14, r15
    jg .nextD
    jmp @f
    .nextD:
      dec r14
      add r14, 2
      mov r12, 1
      add r15, 2
      jmp @f
    jmp @f

  .right:
    inc r13
    cmp r13, rbp
    jg .nextR
    jmp @f
    .nextR:
      dec r13
      add r13, 2
      mov r12, 2
      add rbp, 2
      jmp @f
    jmp @f

  .up:
    dec r14
    cmp r14, 0
    je .nextU
    jmp @f
    .nextU:
      inc r14
      mov r12, 3
      jmp @f
    jmp @f

  .left:
    dec r13
    cmp r13, 0
    je .nextL
    jmp @f
    .nextL:
      inc r13
      mov r12, 0
      add rbp, 2
      jmp @f
    jmp @f

  @@:
  mov rax, [xmax]
  mov rcx, 2
  xor rdx, rdx
  div rcx

  push rdx
  push rcx
  push rax
    mov rax, rbp
    mov rcx, 2
    xor rdx, rdx
    div rcx
    mov rdx, rax
    pop rax
    add rax, r13
    sub rax, rdx
  pop rcx
  pop rdx

  mov [rand_x], rax

  mov rax, [ymax]
  mov rcx, 2
  xor rdx, rdx
  div rcx

  push rdx
  push rcx
  push rax
    mov rax, r15
    mov rcx, 2
    xor rdx, rdx
    div rcx
    mov rdx, rax
    pop rax
    add rax, r14
    sub rax, rdx
  pop rcx
  pop rdx

  mov [rand_y], rax

  ;; Перемещаем курсор в случайную позицию
  mov rdi, [rand_y]
  mov rsi, [rand_x]
  call move

  mov rax, [palette]
  and rax, 0x100
  cmp rax, 0x100
  jne @f
  call get_digit
  or rax, 0x100
  mov [palette], rax
  jmp yy
  @@:

  cmp rbp, 140
  jge .rest
  jmp .skiprest
  .rest:
    mov rbp, 3
    mov r15, 1
    mov r12, 0
    mov r13, 1
    mov r14, 2
  .skiprest:
  call get_digit
  or rax, 0x200
  mov [palette], rax
  yy:
  mov  rdi,[palette]
  call addch

  ;; Задержка
  mov rdi, [delay_time]
  call mydelay

  ;; Обновляем экран и количество выведенных знакомест в заданной палитре
  call refresh
  mov r8, [count]
  inc r8
  mov [count], r8

  ;; Анализируем текущее значение r8=[count]
  call analiz

  ;; Задаем таймаут для getch
  mov rdi, 1
  call timeout
  call getch

  ;; Анализируем нажатую клавишу
  cmp rax, 't'
  je next
  cmp rax, 'y'
  je change_speed
  jmp mloop

next:
  call endwin
  call exit

change_speed:
  ;; Изменяем скорость (задержку)
  mov rax, [delay_time]
  cmp rax, 10
  jne .increase
  mov rax, 5
  jmp .set
.increase:
  mov rax, 10
.set:
  mov [delay_time], rax
  jmp mloop

;; Анализируем количество выведенных знакомест в заданной палитре, меняем палитру, если количество больше 10000
analiz:
  cmp r8, 10000
  jl .p
  mov r8,[palette]
  and r8, 0x100 
  cmp r8, 0x100
  je .pp
  call get_digit
  or rax, 0x100
  mov [palette], rax
  xor r8, r8
  mov [count],r8
  ret
  .pp:
  call get_digit
  or rax, 0x200
  mov [palette], rax
  xor r8, r8
  mov [count], r8
  ret
  .p:
   ret

;; Выбираем случайную цифру
get_digit:
  push rcx
  push rdx
  call get_random
  mov rcx, 10
  xor rdx, rdx
  div rcx
  xor rax,rax
  mov al, [digit + rdx]
  pop rdx
  pop rcx
  ret
