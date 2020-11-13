stacksg segment para stack 'stack'
	dw 30 dup (0) ;llena las 30 palabras con 0
stacksg ends

datasg segment para 'datos'
	mens1 db 'Proporcione a : $'
	mens2 db  ́Proporcione b: $ ́
	mens3 db 'suma = $'
	a db 0
datasg ends

lee 	proc 
	; devuelve carácter leído en AL
	push bx
	push cx
	push dx
	mov ah,1
	int 21h
	pop dx
	pop cx
	pop bx
lee 	endp
escribe 	proc
	; recibe caracter a escribir en DL
	push ax
	push bx
	push cx
	push dx
	mov ah,2
	int 21h
	pop dx
	pop cx
	pop bx
	pop ax
escribe 	endp
esc_cad proc 
	; Lee cadena en la dirección apuntada por DL
	push ax
	push bx
	push cx
	push dx
	mov ah,9
	int 21h
	pop dx
	pop cx
	pop bx
	pop ax
esc_cad endp
ascii-bin	proc
	144 cmp al,30h
	 jl error
	jg sigue
	sub al,39h
	jmp fin
	sigue: cmp al,'A'
	jl error
	cmp al,'F'
	jg error
	sub al,37h
	jmp fin
	error: mov al,0
ascii-bin 	endp
bin_ascii 	proc
	; convierte de binario a ascii (carácter)
	; recibe elemento a convertir en DL
	; devuelve dato convertido en DL
	cmp dl,9
	jg suma37
	add dl,30h
	jmp fin1
	suma37: add dl,37h
bin_ascii 	endp

ali_lin proc
	; escribe alimento de línea
	; escribe control de carro y alimento de línea
	136 push dx
	mov dl,0ah
	call escribe
	mov dl,0dh
	call escribe
	pop dx
ali_lin endp

desemp proc
	Push dx ; 
	Push cx;
	Mov dh,dl ;
	Mov cl,4
	Shr dl,cl
	Call bin_ascii
	Call escribe
	Mov dl,dh
	And dl,0f
	Call bin_ascii
	Call escribe
	Pop cx
	Pop dx 
desemp 	endp

empaq proc
	Push cx
	Call lee
	Call ascii_bin
	Mov cl,4
	Shl al,cl
	Mov ch,al
	Call lee
	Call ascii_bin
	Add al,ch
	Pop cx
empaq endp

codesg segment para 'code'

princi proc far
	assume cs:codesg, ds:datasg, ss:stacksg
inicio:

	Lea 	dx,mens1
	call 	esc_cad
	call 	ali_lin
	call 	empaq 
	mov 	a,al 
	call 	ali_lin
	lea 	dx,mens2
	call 	esc_cad
	call 	empaq 
	add 	a,al  
	call 	ali_lin
	lea 	dx,mens3 
	call 	esc_cad
	mov 	dl,a
	call 	desemp
	ret

princi endp

codesg ends