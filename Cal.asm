.model small
.stack 100h

.data
    mensaje_bienvenida db 'Calculadora Simple', 0Ah, '$'
    prompt_num1 db 'Ingrese el primer numero: $'
    prompt_num2 db 'Ingrese el segundo numero: $'
    prompt_operacion db 'Ingrese la operacion (+, -, *, /): $'
    mensaje_resultado db 'El resultado es: $'

    num1 db 10 dup(0)
    num2 db 10 dup(0)
    operacion db ?
    resultado db 11 dup(0)

.code
    main:
        ; Imprimir mensaje de bienvenida
        mov ah, 9
        lea dx, mensaje_bienvenida
        int 21h

        ; Solicitar el primer número
        mov ah, 9
        lea dx, prompt_num1
        int 21h

        mov ah, 0Ah
        lea dx, num1
        int 21h

        ; Solicitar el segundo número
        mov ah, 9
        lea dx, prompt_num2
        int 21h

        mov ah, 0Ah
        lea dx, num2
        int 21h

        ; Solicitar la operación
        mov ah, 9
        lea dx, prompt_operacion
        int 21h

        mov ah, 01h
        int 21h
        mov operacion, al

        ; Realizar la operación
        mov al, operacion
        mov ah, 0 ; Limpiar registro AH para evitar errores inesperados
        mov ax, word ptr num1  ; Cargar num1 en AX
        mov bx, word ptr num2  ; Cargar num2 en BX

        cmp al, '+'   ; Realizar la operación según la entrada del usuario
        je sumar
        cmp al, '-'
        je restar
        cmp al, '*'
        je multiplicar
        cmp al, '/'
        je dividir
        jmp fin

    sumar:
        add ax, bx
        jmp imprimir_resultado

    restar:
        sub ax, bx
        jmp imprimir_resultado

    multiplicar:
        imul bx
        jmp imprimir_resultado

    dividir:
        xor dx, dx
        div bx
        jmp imprimir_resultado

    imprimir_resultado:
        ; Convertir el resultado de entero a cadena
        mov di, offset resultado
        call int2str

        ; Imprimir mensaje de resultado
        mov ah, 9
        lea dx, mensaje_resultado
        int 21h

        ; Imprimir resultado
        mov ah, 9
        lea dx, resultado
        int 21h

    fin:
        ; Salir
        mov ah, 4Ch
        int 21h

    ; Subrutina para convertir un entero a cadena
    int2str proc
        mov cx, 10
        mov bx, 0
        mov ax, di

    convertir_bucle:
        mov dx, 0
        div cx
        add dl, '0'
        push dx
        inc bx
        cmp ax, 0
        jnz convertir_bucle

    imprimir_bucle:
        pop dx
        mov [di], dl
        inc di
        loop imprimir_bucle
        mov byte ptr [di], '$'
        ret
    int2str endp

end main
