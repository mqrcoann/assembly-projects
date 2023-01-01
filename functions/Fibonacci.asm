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
include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
include c:\masm32\include\msvcrt.inc
         
; *************************************************************************
; MASM32 object libraries
; *************************************************************************  
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib
includelib c:\masm32\lib\msvcrt.lib

; *************************************************************************
; Our data section. Here we declare our strings for our message
; *************************************************************************
.data

	num sdword ?
	ban sdword 0
	Nump sdword ?
	suma sdword 1
	temp sdword ?
	ant sdword 0
	des sdword 1 
	cadena byte "ingresa el %d numero: ",0
	cad byte "%d",0
	cad0 byte "%s",0
	cad1 byte "Ingresa un numero para calcular la serie fibonacci ",0
	cad2 byte 0ah, "El numero de la serie fibonacci es: %d",0
	

; *************************************************************************
; Our executable assembly code starts here in the .code section
; *************************************************************************
.code
FibonacciMacro MACRO numero:REQ
mov ecx,numero
	.if ecx==1 || ecx==2
		invoke crt_printf, addr cad2,des
	.elseif
		sub ecx,1
		.repeat
			mov temp,ecx
			
			mov eax,des
			add eax,ant
			mov ebx,des
			mov des,eax
			mov ant,ebx			
			
			mov ecx,temp
		.untilcxz
		invoke crt_printf,addr cad2,des
	.endif
endm

start:
	; Use the StdOut API function to display the text in a console.
    invoke crt_printf, addr cad0, addr cad1
	invoke crt_scanf, addr cad, addr num
	
	call Fibonacci
	pushad
	mov des, 1
	mov ant, 0
	FibonacciMacro num
	popad
	
	
	; When the console has been closed, exit the app with exit code 0
    invoke ExitProcess, 0
    
Fibonacci proc
pushad
mov ecx,num
	.if ecx==1 || ecx==2
		invoke crt_printf, addr cad2,des
	.elseif
		sub ecx,1
		.repeat
			mov temp,ecx
			
			mov eax,des
			add eax,ant
			mov ebx,des
			mov des,eax
			mov ant,ebx			
			
			mov ecx,temp
		.untilcxz
		invoke crt_printf,addr cad2,des
	.endif
	
popad
ret
Fibonacci endp
end start
