format ELF64

public _start

include 'func.asm'

section ".bss" writable
    file1_name rb 256
    file2_name rb 256
    file3_name rb 256
    buf1 rb 1024
    buf2 rb 1024
    common_chars rb 256
    char_set1 rb 256
    char_set2 rb 256

section ".text" executable
_start:
    mov rdi, [rsp]
    cmp rdi, 4
    jne error_exit

    mov rsi, [rsp + 16]
    mov rdi, file1_name
    call strcpy
    mov rsi, [rsp + 24]
    mov rdi, file2_name
    call strcpy
    mov rsi, [rsp + 32]
    mov rdi, file3_name
    call strcpy

    mov rdi, file1_name
    call open_file
    mov r12, rax

    mov rdi, file2_name
    call open_file
    mov r13, rax

    mov rdi, r12
    mov rsi, buf1
    call read_file

    mov rdi, r13
    mov rsi, buf2
    call read_file

    mov rdi, file3_name
    call open_file_write
    mov r14, rax

    mov rsi, buf1
    call fill_char_set1
    mov rsi, buf2
    call fill_char_set2

    call find_common_chars

    mov rdi, r14
    mov rsi, common_chars
    call write_file

    mov rax, 60
    xor rdi, rdi
    syscall

error_exit:
    mov rax, 60
    xor rdi, rdi
    syscall
