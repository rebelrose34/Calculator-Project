; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

.model small
.stack 100h

.data
msg1 db 10,13,'Enter first number: $'
msg2 db 10,13,'Enter second number: $'
msg3 db 10,13,'Choose operation:',10,13,'1. Addition',10,13,'2. Subtraction',10,13,'3. Multiplication',10,13,'4. Division',10,13,'Choice: $'
msg4 db 10,13,'Result: $'
msg5 db 10,13,'Invalid choice!$'
newline db 10,13,'$'

num1 dw ?
num2 dw ?
result dw ?

.code
main proc
    mov ax, @data
    mov ds, ax
    
    ; First number input
    mov ah, 9
    lea dx, msg1
    int 21h
    
    call input_number
    mov num1, bx
    
    ; Second number input
    mov ah, 9
    lea dx, msg2
    int 21h
    
    call input_number
    mov num2, bx
    
    ; Operation choice
    mov ah, 9
    lea dx, msg3
    int 21h
    
    mov ah, 1
    int 21h
    
    cmp al, '1'
    je addition
    cmp al, '2'
    je subtraction
    cmp al, '3'
    je multiplication
    cmp al, '4'
    je division
    
    ; Invalid choice
    mov ah, 9
    lea dx, msg5
    int 21h
    jmp exit
    
addition:
    mov ax, num1
    add ax, num2
    mov result, ax
    jmp display_result

subtraction:
    mov ax, num1
    sub ax, num2
    mov result, ax
    jmp display_result

multiplication:
    mov ax, num1
    imul num2
    mov result, ax
    jmp display_result

division:
    mov dx, 0
    mov ax, num1
    idiv num2
    mov result, ax
    jmp display_result

display_result:
    mov ah, 9
    lea dx, msg4
    int 21h
    
    mov ax, result
    call print_number
    
exit:
    mov ah, 4ch
    int 21h
main endp

; Input number procedure
input_number proc
    mov bx, 0
input_loop:
    mov ah, 1
    int 21h
    cmp al, 13
    je input_done
    sub al, '0'
    mov cl, al
    mov ch, 0
    mov ax, bx
    mov dx, 10
    mul dx
    add ax, cx
    mov bx, ax
    jmp input_loop
input_done:
    ret
input_number endp

; Print number procedure
print_number proc
    mov cx, 0
    mov bx, 10
    
    cmp ax, 0
    jge positive
    neg ax
    push ax
    mov ah, 2
    mov dl, '-'
    int 21h
    pop ax
    
positive:
    mov dx, 0
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne positive
    
print_loop:
    pop dx
    add dl, '0'
    mov ah, 2
    int 21h
    loop print_loop
    ret
print_number endp

end main

ret