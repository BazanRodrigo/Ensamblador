;Rodrigo Bazán Zurita
;201922279
;Muestra hasta n numero
stacksg segment para stack 'stack'
	dw 30 dup (0) ;llena las 30 palabras con 0
stacksg ends

datasg segment para 'data'
	mens1 db 'Escribe la cadena : $'
	men2 db 'Espacios: $'
	men3 db "mayusculas: $"
	men4 db "minusculas: $"
	men5 db "numeros: $"
	men6 db "otros: $"
	esp db 0
	otr db 0
	may db 0
	min db 0
	num db 0
	cadena db 50
	longi db 0
	inicad	db	50 dup(' ')
datasg ends

codesg segment para 'code'
	princi proc far
assume cs:codesg, ds:datasg, ss:stacksg

inicio: 
	push ds  
	xor ax,ax  
	push ax 
	mov ax,datasg  
	mov ds,ax  

	lea dx,mens1 ;solicita la cadena
	call esc_cad
	call ali_lin
	lea dx,cadena; lee cadena
	call lee_cad
	call ali_lin
	xor ch,ch; coloca en cx la longitud de la cadena
	mov cl,longi
	lea bx,inicad; BX apunta al primer carácter de la cadena
	cont: mov al,[bx]
		cesp:
			cmp al,' ' ;
			jne nume
			inc esp
			jmp sig
		nume:
			cmp al,3ah
			jl mayus
			cmp al,30h
			jg mayus
			inc num
			jmp sig
		mayus:	
			jmp sig
			cmp al,41h
			jl minus
			cmp al, 5bh
			jg minus
			inc may
			jmp sig
		minus:
			cmp al,61h
			jl otros
			cmp al,7ah
			jg otros
			inc min
			jmp sig
		otros: inc otr
			jmp sig
		sig: inc bx
		loop cont
	lea dx, men2
	call esc_cad
	mov dl,esp
	call desempaqueta
	call ali_lin
	lea dx,men3
	call esc_cad
	mov dl,may
	call desempaqueta
		call ali_lin
		lea dx, men4
		call esc_cad
		mov dl,min
		call desempaqueta
		call ali_lin
		lea dx,men5
		call esc_cad
		mov dl,num
		call desempaqueta
		call ali_lin
		lea dx, men6
		call esc_cad
		mov dl, otr
		call desempaqueta
		
	ret
princi endp

lee proc
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

esc_cad proc
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
esc_cad endp

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

lee_cad proc
	push bx
	push cx
	push dx
	mov ah,0ah
	int 21h
	pop dx
	pop cx
	pop bx
	ret
lee_cad endp

codesg ends
	end inicio; indica la posición de la primera instrucción dir
end