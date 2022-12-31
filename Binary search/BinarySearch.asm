; *************************************************************************
; 32-bit Windows Hello World Application - MASM32 Example
; EXE File size: 2,560 Bytes
; Created by Visual MASM (http://www.visualmasm.com)
; Marco Antonio Acevedo Escudero
; *************************************************************************
     
.386					; Enable 80386+ instruction set
.model flat, stdcall	; Flat, 32-bit memory model (not used in 64-bit)
option casemap: none	; Case sensitive syntax

; *************************************************************************
; MASM32 proto types for Win32 functions and structures
; *************************************************************************  
include c:\masm32\include\msvcrt.inc
include c:\masm32\include\Irvine32.inc
         
; *************************************************************************
; MASM32 object libraries
; *************************************************************************  
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\msvcrt.lib
includelib c:\masm32\lib\Irvine32.lib

; *************************************************************************
; Our data section. Here we declare our strings for our message box
; *************************************************************************
.data
   	msg1fmt db 0Ah, "%s", 0
	msg2fmt db 0Ah, "%s", 0Ah, 0Ah, 0
	in1fmt  db "%d", 0
	msg1    db "Enter the number of integers to be input: ", 0
	msg2    db 0Ah, "Enter an integer ", 0
	msg3    db "No data entered", 0
	msg4    db "Enter a number for binary search: ", 0
	msg5    db 0Ah, 0Ah, " %d data is found at position %d", 0ah, 0
	msg6    db 0Ah, 0Ah, "%d data is not found in the array", 0ah, 0
	dos     sdword 2
	cuatro  sdword 4
	
.data?
	n       sdword ?
	r       sdword ? 
	l       sdword ?
	m       sdword ?
	dato    sdword ? 
	cont    sdword ?
	arry    sdword 20 dup(?)

; *************************************************************************
; Our executable assembly code starts here in the .code section
; *************************************************************************
.code

start:
	invoke crt_printf, ADDR msg1fmt,ADDR msg1
	invoke crt_scanf, ADDR in1fmt, ADDR n
	
	mov ecx, n 
	mov ebx, 0 
	mov cont, 0
	;se piden los numeros verificando que sea mayor a cero la cantidad
	.if ecx > 0
		.repeat
			push ecx 
			invoke crt_printf, ADDR msg2, cont
			invoke crt_scanf, ADDR in1fmt, ADDR arry[ebx]
			inc cont
			pop ecx 
			add ebx, 4
		.untilcxz
		;se pide el numero a buscar
		pushad
		invoke crt_printf,ADDR msg1fmt,ADDR msg4
	    invoke crt_scanf,ADDR in1fmt,ADDR dato
	    popad
	    
	    mov l, 0
		mov eax, n
		dec eax
		mov r, eax 
	    mov ebx, dato
	    mov edx, l
	    ;la variable r se queda con la longitud del arreglo ingresado
	    .while edx <= r                 ;l <= r 
			mov eax, r
			add eax, l
			cdq
			idiv dos                    ; m = l + r / 2
			mov m, eax		            
			imul cuatro                 ;obtenemos la real direccion de memoria
   										;del indice m
			.if ebx < arry[eax]
				;r = m - 1
				mov eax, m
				dec eax
				mov r, eax
			.elseif ebx > arry[eax]	
				;l = m + 1
				mov eax, m
				inc eax
				mov l, eax
				mov edx,eax
		    .else
				jmp encontrado		
		    .endif	
		.endw	
	.else
		;si no se ingresó ningún dato
		invoke crt_printf, ADDR msg2fmt, ADDR msg3
	.endif              
    
    encontrado:
    mov eax, m
    imul cuatro
	
	.if ebx == arry[eax]
		invoke crt_printf, ADDR msg5, dato, m
 	.else
	  	invoke crt_printf, ADDR msg6, dato
  	.endif
    
	invoke WaitMsg 
	; When the message box has been closed, exit the app with exit code 0
    invoke ExitProcess, 0
end start
