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
	menufmt byte "%s%s%s%s", 0
	intfmt  byte "%d", 0
	msg1    byte "Arreglo inicial: ", 0
	msg2    byte 0ah, "Arreglo ordenado: ", 0
	
	arreglo sdword 3, 1, 5, 4, 2 ,3
	
.data?
	temp    sdword ?
	i		sdword ?
	j		sdword ?
	cant    sdword ?

; *************************************************************************
; Our executable assembly code starts here in the .code section
; *************************************************************************
.code
imprimirMatriz MACRO array:REQ, cantidad:REQ
	mov ecx, cantidad
	lea esi, array+0
	mov eax, [esi]
	mov i, 0
	
	.while i < ecx 
		pushad
		invoke crt_printf, ADDR intfmt, eax
		popad
		add esi, 4
		mov eax, [esi]
		inc i
	.endw
endm

BubbleSort MACRO arreglo:REQ, cantidad:REQ
	mov i, 0
	mov edx, cantidad
	dec edx
	.while i < edx
		mov ecx, 6
		sub ecx, i
		dec ecx
		
		mov ebp, 0
		.repeat
			push ecx
			
			mov eax, arreglo[ebp]
			.if eax > arreglo[ebp+4]
				mov ebx, arreglo[ebp+4]
				
				mov arreglo[ebp], ebx
				mov arreglo[ebp+4], eax	
			.endif
			add ebp, 4
			
			pop ecx
		.untilcxz
		inc i
	.endw
endm
start:
	invoke crt_printf, ADDR msgfmt, ADDR msg1
	mov cant, 6
	imprimirMatriz arreglo, cant
	     
	BubbleSort arreglo, cant
	
	invoke crt_printf, ADDR msgfmt, ADDR msg2
	imprimirMatriz arreglo, cant
	
	; When the console has been closed, exit the app with exit code 0
    invoke ExitProcess, 0
end start
