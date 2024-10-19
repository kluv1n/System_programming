format ELF64

public _start
public exit
public print_symb

section '.data'
  string db 'FbsokKqcURDycPFLeXnlZEXWllfrioUStB'

section '.bss' writable
  place db 1
  newline db 0x0A

section '.text' executable
  _start:
    mov rcx, 34

    .iter:
       mov al, [string+rcx]
       push rcx
       call print_symb
       pop rcx
       dec rcx
       cmp rcx, -1
       jne .iter

    mov al, [newline]
    call print_symb
    call exit

print_symb:
  push rax
  mov eax, 1
  mov edi, 1
  pop rdx
  mov [place], dl
  mov rsi, place
  mov edx, 1
  syscall
  ret

exit:
  mov eax, 60
  xor edi, edi
  syscall