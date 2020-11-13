;Rodrigo Bazán Zurita
;201922279
;Muestra hasta n numero
stacksg segment para stack 'stack'
	dw 30 dup (0) ;llena las 30 palabras con 0
stacksg ends

datasg segment para 'data'
	mens1 db 'Escribe n : $'
	mens2 db '$'
	a db 0
	n db 0
datasg ends

codesg segment para 'code'
	princi proc far
assume cs:codesg, ds:datasg, ss:stacksg

inicio: ;
	push ds ; 
	xor ax,ax ; 
	push ax ; 
	mov ax,datasg ; 
	mov ds,ax ; 
	Lea dx,mens1 ; 
	call escribe_cad
	call empaqueta ; 
	mov a,al
	call ali_lin
	bucle:
		inc n
		mov dl,n
		call desempaqueta
		call ali_lin
		cmp n,al
		jne bucle
		je salir
	salir:	inc cx
	ret ;
princi endp

lee proc near
	push bx
	push cx
	push dx
	mov ah,1
	int 21h
	pop dx
	pop cx
	pop bx
	ret
	lee endp
	
escribe proc
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
	ret
escribe endp

escribe_cad proc
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
	ret
escribe_cad endp

ascii_bin proc ; recibe dato en al
	cmp al,'0'
	jl error
	cmp al,39h
	jg sigue
	sub al,30h
	jmp fin
	sigue: cmp al,'A'
	jl error
	cmp al,'F'
	jg sigue1
	sub al,37h
	jmp fin
	sigue1: cmp al,'a'
	jl error
	cmp al,'f'
	jg error
	sub al,57h
	jmp fin
	error: mov al,0
	fin: ret
ascii_bin endp

bin_ascii proc ; recibe dato en dl
	cmp dl,9
	jg suma37
	add dl,30h
	jmp fin1
	suma37: add dl,37h
	fin1: ret
bin_ascii endp

ali_lin proc
	push dx
	mov dl,0ah
	call escribe
	mov dl,0dh
	call escribe
	pop dx
	ret
ali_lin endp

desempaqueta proc
	push cx
	push dx
	mov ch,dl
	mov cl,4
	shr dl,cl
	call bin_ascii
	call escribe
	mov dl,ch
	and dl,0fh
	call bin_ascii
	call escribe
	pop dx
	pop cx
	ret
desempaqueta endp

empaqueta proc
	push cx
	call lee
	call ascii_bin
	mov cl,4
	shl al,cl
	mov ch,al
	call lee
	call ascii_bin
	add al,ch
	pop cx
	ret
empaqueta endp

codesg ends
	end inicio; indica la posición de la primera instrucción dir
end