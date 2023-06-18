BITS 64

section .data
    msg db "Enter a number:", 0
    msg_len equ $-msg
    err db "Invalid input.", 0
    err_len equ $-err
    pri db "Prime.\n", 0
    pri_len equ $-pri
    npr db "Not prime.\n", 0
    npr_len equ $-npr

section .bss
    buffer resb 11 ; 11 bytes for the prime number

section .text
    global _start
    
    _start:
        ; print prompt
        mov eax, 1 ; 1 is the system call number for write in linux
        mov edi, eax ; File descriptor (1 is stdout)
        mov rsi, msg ; Address of the data to be written
        mov rdx, msg_len ; Number of bytes to be written
        syscall

        ; read input
        mov eax, 0 ; read syscall number
        mov edi, eax ; file descriptor (stdin)
        mov rsi, buffer ; address to read the data into
        mov rdx, 11 ; size of the buffer
        syscall

        ; convert ascii string to integer
        mov rdi, rsi
        xor rax, rax
        .loop:
            movzx ecx, byte [rdi]
            sub ecx, '0'
            jb .error ; if the input is not a number, print an error message and exit
            imul rax, 10
            add rax, rcx
            inc rdi
            cmp byte [rdi], 10 ; if we've reached the end of the string (newline), exit the loop
            jne .loop
        jmp .prime_check

        .error:
            ; print error message
            mov eax, 1
            mov edi, eax
            mov rsi, err
            mov rdx, err_len
            syscall
            jmp .exit

        .prime_check:
            ; check if it's a prime number
            mov ecx, 2
            .loop_prime:
                cmp ecx, eax
                jge .end
                xor edx, edx
                mov rbx, rax
                div ecx
                cmp edx, 0
                je .not_prime
                inc ecx
                jmp .loop_prime

            .not_prime:
                ; if it's not a prime, print a message or exit
                mov eax, 1
                mov edi, eax
                mov rsi, npr
                mov rdx, npr_len
                syscall
                jmp .exit

            .end:
                ; if it's a prime, print a message or exit
                mov eax, 1
                mov edi, eax
                mov rsi, pri
                mov rdx, pri_len
                syscall
                jmp .exit
        
        ; exit
        .exit:
            mov eax, 60 ; exit syscall number
            xor edi, edi ; exit code 0
            syscall
