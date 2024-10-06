format ELF64

public _start

section '.bss' writable
    buffer db 1

section '.text' executable

string_to_number:
    push rcx
    push rbx

    xor rax, rax
    xor rcx, rcx

.loop:
    xor rbx, rbx
    mov bl, byte [rsi + rcx]
    cmp bl, 48
    jl .is_finished_check
    cmp bl, 57
    jg .is_finished_check

    sub bl, 48
    add rax, rbx
    mov rbx, 10
    mul rbx
    inc rcx
    jmp .loop

.is_finished_check:
    cmp rcx, 0
    je .reset
    mov rbx, 10
    div rbx

.reset:
    pop rbx
    pop rcx
    ret

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
    pop rcx
    cmp rcx, 4
    jne .exit

    mov rsi, [rsp + 8]
    call string_to_number
    mov rbx, rax

    mov rsi, [rsp + 16]
    call string_to_number
    mov rcx, rax

    mov rsi, [rsp + 24]
    call string_to_number
    mov rdx, rax

    mov rax, rdx
    imul rax, rcx
    add rax, rbx
    sub rax, rcx
    mov rcx, rdx
    xor rdx, rdx
    div rcx

    call print_symbol

.exit:
    mov eax, 60
    xor edi, edi
    syscall