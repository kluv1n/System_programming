format ELF64

public _start

include 'func.asm'

section '.bss' writable
  output dq 0
  input_buffer rb 255

section '.text' executable
  _start:
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buffer
    call input_keyboard
    mov rsi, input_buffer
    call str_number
    xor r8, r8

    mov rbx, rax
    xor rdi, rdi
    cmp rax, 5
    jl .finish
    mov rsi, 5

  .main_loop:
     xor rcx, rcx
     xor rdx, rdx
     cmp rsi, rbx
     jg .finish

  .check_seven_div:
     xor rax, rax
     mov rax, rsi
     xor rcx, rcx
     xor rdx, rdx
     mov rcx, 7
     div rcx
     cmp rdx, 0
     jg .check_three_div

     add rsi, 5
     cmp rsi, rbx
     jg .finish

  .check_three_div:
     xor rax, rax
     mov rax, rsi
     xor rcx, rcx
     xor rdx, rdx
     mov rcx, 3
     div rcx
     cmp rdx, 0
     jg .increment_counter

     add rsi, 5
     cmp rsi, rbx
     jg .finish

  .increment_counter:
     add rdi, 1
     add rsi, 5
     cmp rsi, rbx
     jl .main_loop

.finish:
    mov rax, rdi
    call print_num
    call exit