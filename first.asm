format ELF64

public _start

section '.bss' writable
    buffer db 1

section '.text' executable
print_symbol:
    xor rbx, rbx

    cmp rax, 9
    jle .one_symb

    mov rcx, 10

.loop:
    xor rdx, rdx
    div rcx
    push rdx
    inc rbx
    test rax, rax
    jnz .loop

.print:
    pop rax
    add rax, '0'
    mov [buffer], al

    mov eax, 1
    mov edi, 1
    mov rsi, buffer
    mov edx, 1
    syscall
    dec rbx
    jnz .print

    ret

.one_symb:
    add rax, '0'
    mov [buffer], al

    mov eax, 1
    mov edi, 1
    mov rsi, buffer
    
