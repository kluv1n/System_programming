format ELF64
public _start
public exit

section '.data' writable
    n dq 0
    result dq 0  
    buffer rb 20
    minus db '-'

section '.text' executable
_start:
    pop rcx
    pop rsi
    pop rsi
    call string_to_number
    mov [n], rax
    mov rcx, [n]

    .iter:
        mov rax, rcx
        call first_digit
        mul rcx
        ;add [result], rcx
        add [result], rax

    loop .iter

    mov rax, [result]
    mov rbx, buffer
    mov rcx, 20
    call number_to_string
    mov rax, buffer
    call print

    call exit

first_digit:
    push rbx
    push rcx
    push rdx
    cmp rax, 9
    jle .pos8
    .pos7:
    xor rdx, rdx      
    mov rcx, 10
    div rcx         
    cmp rax, 10      
    jge .pos7
    .pos8:
    pop rdx
    pop rcx
    pop rbx
    ret

number_to_string:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi

    cmp rax, 0          
    jge .pos             
    ._neg:
      neg rax           
      push rax    
      push rbx
      push rdx
      mov rax, 4
      mov rcx, minus      
      mov rbx, 1
      mov rdx, 1
      int 0x80
      pop rdx
      pop rbx
      pop rax
    
    .pos:
    mov rsi, rcx
    dec rsi
    xor rcx, rcx
    .next_iter:
        push rbx
        mov rbx, 10
        xor rdx, rdx
        div rbx
        pop rbx
        add rdx, '0'
        push rdx
        inc rcx
        cmp rax, 0
        je .next_step
        jmp .next_iter
    .next_step:
        mov rdx, rcx
        xor rcx, rcx
    .to_string:
        cmp rcx, rsi
        je .pop_iter
        cmp rcx, rdx
        je .null_char
        pop rax
        mov [rbx+rcx], rax
        inc rcx
        jmp .to_string
    .pop_iter:
        cmp rcx, rdx
        je .close
        pop rax
        inc rcx
        jmp .pop_iter
    .null_char:
        mov rsi, rdx
    .close:
        mov [rbx+rsi], byte 0
        pop rsi
        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret

string_to_number:
    push rsi
    push rbx
    push rcx
    push rdx 

    xor al, al
    xor rcx, rcx
    cmp byte [rsi], '-'
    jne .next_char
    mov al, 1 
    inc rcx

    .next_char:
        movzx rbx, byte [rsi + rcx]
        cmp bl, 0      
        je .finished       

        cmp bl, '0'             
        jl .finished  
        cmp bl, '9'
        jg .finished         

        sub bl, '0'            
        
        mov rdx, 10
        mul rdx                  
        add rax, rbx             
        
        inc rcx
        jmp .next_char
        
    test al, 1            
    jz .finished           
        neg rax  
    .finished:
    pop rdx
    pop rcx
    pop rbx
    pop rsi
    ret

print:
    push rax
    push rbx
    push rcx
    push rdx
    mov rcx, rax
    mov rax, 4 ;
    mov rbx, 1 ;
    mov rdx, 20 ;
    int 0x80
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

exit:
    mov rax, 1     
    xor rbx, rbx   
    int 0x80