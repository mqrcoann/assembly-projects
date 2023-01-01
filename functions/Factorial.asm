; *************************************************************************
; 32-bit Windows Console Hello World Application - MASM32 Example
; EXE File size: 2,560 Bytes
; Created by Visual MASM (http://www.visualmasm.com)
; Marco Antonio Acevedo Esc.
; *************************************************************************
                                    
.386					; Enable 80386+ instruction set
.model flat, stdcall	; Flat, 32-bit memory model (not used in 64-bit)
option casemap: none	; Case insensitive syntax

; *************************************************************************
; MASM32 proto types for Win32 functions and structures
; *************************************************************************  
include c:\masm32\include\user32.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\msvcrt.inc
         
; *************************************************************************
; MASM32 object libraries
; *************************************************************************  
includelib c:\masm32\lib\user32.lib
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\msvcrt.lib

; *************************************************************************
; Our data section. Here we declare our strings for our message
; *************************************************************************
.data
	msgfmt  byte "%s", 0
	ansfmt  byte "%s%d", 0
	menufmt byte "%s%s%s%s", 0
	intfmt  byte "%d", 0
	msg1    byte 0ah, 0ah, "Ingrese una opcion: ", 0ah, 0
	msg2    byte "1) Factorial", 0ah, 0
	msg3    byte "2) Fibonacci", 0ah, 0
	msg4    byte "3) Salir", 0ah, 0
	msg5    byte "Ingrese el numero para calcular su factorial: ", 0
	msg6    byte "Ingrese una posicion de la serie de Fibonacci: ", 0
	ans1    byte 0ah, "El factorial es: " ,0
	ans2    byte 0ah, "La posicion en la serie es: ", 0
	des     sdword 1
	ant     sdword 0
	
.data?
	opcion     sdword ?
	numero     sdword ?
	nFactorial sdword ?
	nFibonacci sdword ?
	i		   sdword ?
	temp sdword ?
	

; *************************************************************************
; Our executable assembly code starts here in the .code section
; *************************************************************************
.code
FactorialMacro MACRO num:REQ
mov i, 1
mov nFactorial, 1
mov eax, i

.while eax <= num
	push eax
	mov eax, nFactorial
	imul i
	mov nFactorial, eax
	pop eax
	inc i
	inc eax
.endw
endm

start:
	invoke crt_printf, ADDR msgfmt, ADDR msg5
	invoke crt_scanf, ADDR intfmt, ADDR numero
	call Factorial
	invoke crt_printf, ADDR ansfmt, ADDR ans1, nFactorial
	FactorialMacro numero
	invoke crt_printf, ADDR ansfmt, ADDR ans1, nFactorial

    invoke ExitProcess, 0
    
Factorial proc
pushad
mov i, 1
mov nFactorial, 1
mov eax, i

.while eax <= numero 
	push eax
	mov eax, nFactorial
	imul i
	mov nFactorial, eax
	pop eax
	inc i
	inc eax
.endw
popad
ret
Factorial endp

end start
