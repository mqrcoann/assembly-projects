.386
.model flat,stdcall
option casemap:none
include c:\masm32\include\windows.inc 
include c:\masm32\include\user32.inc 
include c:\masm32\include\kernel32.inc; 
include c:\masm32\include\gdi32.inc
include c:\masm32\include\masm32.inc
include c:\masm32\include\msvcrt.inc

includelib c:\masm32\lib\user32.lib 
includelib c:\masm32\lib\kernel32.lib 
includelib c:\masm32\lib\gdi32.lib
includelib c:\masm32\lib\masm32.lib
includelib c:\masm32\lib\msvcrt.lib

VK_LEFT   EQU	000000025h     ;constantes para identificar a las teclas
VK_UP	  EQU	000000026h
VK_RIGHT  EQU	000000027h
VK_DOWN   EQU	000000028h
VK_RETURN EQU   00000000Dh

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD

.const
IDT_TIMER1   equ 100
IDT_TIMER2   equ 101  ;para identificar a los personajes  	
IDB_CUPHEAD  equ 1    ;y otros elementos del programa
IDB_CUPHEAD2 equ 2
IDB_ROCKET   equ 3
IDB_ROCKET2  equ 4
IDB_HILDA    equ 5
IDB_FONDO    equ 6
IDB_ROCKET3  equ 7
IDB_ROCKET4  equ 8
IDM_MENU     equ 10	 
IDM_NUEVO    equ 11
IDM_JUEGO    equ 12
IDM_ACERCA   equ 13

DERECHA    equ 20  ;banderas de movimiento
ARRIBA	   equ 21
ABAJO	   equ 22
IZQUIERDA  equ 23
					
NIVEL1     equ 23
NIVEL2     equ 24  ;constantes del estado del juego
PAUSA      equ 25

.data
msgfmt    byte "%s%s%s",0Ah,0
msg2fmt   byte "%s%s",0Ah,0
ClassName byte "SimpleWinClass",0
AppName   byte "Threatenin' Zeppelin with Assembly",0
Juego1    byte "Se mueve con las flechas direccionales", 0ah,0
Juego2    byte "No deje que lo atrapen o el juego se termina", 0ah, 0
Juego3    byte 0
AcercaT   byte "Acerca de Threatenin' Zeppelin with Assembly", 0
Acerca1   byte "Universidad del Istmo - Ingienieria en Computación", 0ah, 0
Acerca2   byte "Por Marco Antonio Acevedo Escudero - 28 de Mayo de 2019", 0ah
Acerca3   byte "Lenguaje Ensamblador - 2018B-2019A",0
Win1Msg   byte "Felicidades, pasó el nivel 1 :D",0
Win2Msg   byte "Felicidades, pasó el nivel 2 :D (el último en realidad)",0
LossMsg   byte "Ha perdido :(( ", 0
HildaX    sdword 900
HildaY    sdword 100
Contador  sdword 0
Contador2 sdword 0    ;variable auxiliar que nos permitirá saber cuando ganará el jugador
dos       sdword 2	  ;variables auxiliares para generar las posiciones
tres      sdword 3
cuatro    sdword 4
diez      sdword 10				      

.data?
hInstance   HINSTANCE ?
CommandLine LPSTR ?
CupheadBmp  dd ?     ;Variables que almacenarán
Cuphead2Bmp dd ?     ;las imagenes
RocketBmp   dd ?
Rocket2Bmp  dd ?
HildaBmp    dd ?
FondoBmp    dd ?
Rocket3Bmp  dd ?
Rocket4Bmp  dd ?

CupheadX    sdword ?  ;posiciones iniciales de cada personaje
CupheadY    sdword ?
RocketX     sdword ?
RocketY     sdword ?
Rocket2X    sdword ?
Rocket2Y    sdword ?
DirCuphead  sdword ? ;Banderas de dirección
DirRocket   sdword ?
DirRocket2  sdword ?
DirHilda    sdword ?
JuegoMsg    sdword ? 
AcercaMsg   sdword ?
Estado      sdword ? ;Nos idica si el juego está en pausa o no

.code
start:
	invoke GetModuleHandle, NULL
	mov    hInstance,eax
	invoke GetCommandLine
	mov    CommandLine,eax
	invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT
	invoke ExitProcess,eax

WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	LOCAL wc:WNDCLASSEX
	LOCAL msg:MSG
	LOCAL hwnd:HWND
	mov   wc.cbSize,SIZEOF WNDCLASSEX
	mov   wc.style, CS_HREDRAW or CS_VREDRAW
	mov   wc.lpfnWndProc, OFFSET WndProc
	mov   wc.cbClsExtra,NULL
	mov   wc.cbWndExtra,NULL
	push  hInstance
	pop   wc.hInstance
	mov   wc.hbrBackground,COLOR_WINDOW+1
	mov   wc.lpszMenuName,NULL
	mov   wc.lpszClassName,OFFSET ClassName
	invoke LoadIcon,NULL,IDI_APPLICATION
	mov   wc.hIcon,eax
	mov   wc.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov   wc.hCursor,eax
	invoke RegisterClassEx, addr wc
	INVOKE CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,\
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
           CW_USEDEFAULT,1200,700,NULL,NULL,\
           hInst,NULL
	mov   hwnd,eax
	invoke ShowWindow, hwnd,SW_SHOWNORMAL
	invoke UpdateWindow, hwnd
	
	;se carga el menu
	invoke LoadMenu, hInst, IDM_MENU  
	invoke SetMenu, hwnd, eax
	;Se declaran las condiciones iniciales del juego
	mov Estado, NIVEL1
	mov DirCuphead, DERECHA	
	mov DirRocket, IZQUIERDA
	mov DirRocket2, IZQUIERDA
	mov DirHilda, ARRIBA
	
	call GenerarPos
	
	.WHILE TRUE
		invoke GetMessage, ADDR msg,NULL,0,0
		.BREAK .IF (!eax)
		invoke TranslateMessage, ADDR msg
		invoke DispatchMessage, ADDR msg
	.ENDW
	mov     eax,msg.wParam
	ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	LOCAL ps:PAINTSTRUCT 
   	LOCAL hdc:HDC
 	LOCAL rect:RECT
 	LOCAL hMemDC1:HDC
 	LOCAL hMemDC2:HDC
 	LOCAL hMemDC3:HDC
 	LOCAL hMemDC4:HDC
 	
	.IF uMsg==WM_DESTROY
		invoke DeleteObject, FondoBmp
		invoke DeleteObject, CupheadBmp
		invoke DeleteObject, Cuphead2Bmp
		invoke DeleteObject, RocketBmp
		invoke DeleteObject, Rocket2Bmp
		invoke DeleteObject, Rocket3Bmp
		invoke DeleteObject, Rocket4Bmp
		invoke DeleteObject, HildaBmp
		invoke PostQuitMessage,NULL
		
	.elseif uMsg == WM_CREATE
		;El timer reccibe la velocidad como constante
		invoke SetTimer, hWnd, IDT_TIMER1,90, NULL
	 	;Se cargan las imagenes
		invoke LoadBitmap,hInstance,IDB_FONDO
		mov FondoBmp,eax
		invoke LoadBitmap,hInstance,IDB_CUPHEAD
		mov CupheadBmp,eax
		invoke LoadBitmap,hInstance,IDB_ROCKET
		mov RocketBmp,eax
		invoke LoadBitmap,hInstance,IDB_CUPHEAD2
		mov Cuphead2Bmp,eax
		invoke LoadBitmap,hInstance,IDB_ROCKET2
		mov Rocket2Bmp,eax
		invoke LoadBitmap,hInstance,IDB_HILDA
		mov HildaBmp,eax
		invoke LoadBitmap,hInstance,IDB_ROCKET3
		mov Rocket3Bmp,eax
		invoke LoadBitmap,hInstance,IDB_ROCKET4
		mov Rocket4Bmp,eax
		
	.elseif uMsg==WM_COMMAND ;comandos de la barra de herramientas
	    mov eax, wParam
	  	;.if lParam==0     
;			invoke DestroyWindow,hWnd   
;	  	.endif
	  	.if wParam == IDM_JUEGO
	  		invoke crt_sprintf, ADDR JuegoMsg, ADDR msgfmt, ADDR Juego1, ADDR Juego2, ADDR Juego3
 	 		invoke MessageBox,NULL,ADDR JuegoMsg,ADDR AppName,MB_OK
     	 .elseif wParam == IDM_ACERCA
     	 	invoke crt_sprintf, ADDR AcercaMsg, ADDR msg2fmt, ADDR Acerca1, ADDR Acerca2
 	 		invoke MessageBox,NULL,ADDR AcercaMsg,ADDR AcercaT,MB_OK
	
		 .elseif wParam == IDM_NUEVO
		 	call JuegoNuevo
		 	call GenerarPos
		 	invoke SetTimer, hWnd, IDT_TIMER1,90, NULL
		 	invoke InvalidateRect, hWnd, NULL, TRUE
		 .endif
		 
	.elseif uMsg==WM_TIMER
		.if wParam == IDT_TIMER1
			;El timer nos ayudará amover a los otros personajes
			;Hilda solo se mueve decrativamente hacia arriba y 
			;hacia abajo
			call MovHilda
			pushad
			;En adelante se hacen las operaciones para determinar
			;cuando el jugador es alcanzado
			;Se mueve el Cohete
			call MovRocket
			mov eax, CupheadX
			mov ebx, CupheadY
   			;para determinar si alcanzó al jugador o no
			.if RocketX == eax && RocketY == ebx
				invoke KillTimer,hWnd,IDT_TIMER1
				invoke KillTimer,hWnd,IDT_TIMER2
				mov Estado, PAUSA
				invoke MessageBox, hWnd, ADDR LossMsg, ADDR AppName, MB_OK
			.endif
				
			;condicion de victoria:
			;cuando el jugador lleve cierta cantidad de tiempo
			;el juego se detendrá anunciando la victoria del jugador
			.if Contador == 100
				invoke KillTimer,hWnd,IDT_TIMER1
				mov Estado, PAUSA
				mov Contador,0
				mov Contador2, 0
				invoke MessageBox, hWnd, ADDR Win1Msg, ADDR AppName, MB_OK
				call GenerarPos2
				mov Estado, NIVEL2
				invoke SetTimer, hWnd, IDT_TIMER1, 85, NULL
				invoke SetTimer, hWnd, IDT_TIMER2,50, NULL
			.endif  
			;Segundo nivel
			.if Contador2 == 150
				invoke KillTimer,hWnd,IDT_TIMER1
				invoke KillTimer,hWnd,IDT_TIMER2
				;mov Estado, PAUSA
				invoke MessageBox, hWnd, ADDR Win2Msg, ADDR AppName, MB_OK
			.endif
			
			.if Estado == NIVEL1
				inc Contador
			.else
				inc Contador2
			.endif
			
			invoke InvalidateRect, hWnd, NULL, TRUE
		    popad
		.endif
		;Utilizo un segundo TIMER para controlar al cohete del segundo nivel
		;Pues este TIMER "va más rápido" para aumentar la dificultad del juego
		.if wParam == IDT_TIMER2
			call MovRocket2
			mov eax, CupheadX
			mov ebx, CupheadY
   			;para determinar si alcanzó al jugador o no
			.if Rocket2X == eax && Rocket2Y == ebx
				invoke KillTimer,hWnd,IDT_TIMER1
				invoke KillTimer,hWnd,IDT_TIMER2
				mov Estado, PAUSA
				invoke MessageBox, hWnd, ADDR LossMsg, ADDR AppName, MB_OK
			.endif
				
		.endif

    .elseif uMsg == WM_KEYDOWN
    	;en esta parte se mueve a nuestro personaje
    	;preguntando primero si el juego no está detenido
    	;dependiendo de la tecla que se está pulsando
    	;nuestro personaje se va a mover
		.if Estado == NIVEL1 || Estado == NIVEL2
			.if wParam == VK_RIGHT
				.if CupheadX != 820
					mov DirCuphead, DERECHA
					add CupheadX, 10
				.endif	
			.elseif wParam == VK_LEFT
				.if CupheadX != 10
					mov DirCuphead, IZQUIERDA
					sub CupheadX, 10
				.endif
			.endif
			.if wParam == VK_UP
				.if CupheadY != 10
					sub CupheadY, 10
				.endif
			.elseif wParam == VK_DOWN
				.if CupheadY != 560
					add CupheadY, 10
				.endif
			.endif
			;invoke InvalidateRect, hWnd, NULL, TRUE
		.endif	
	.elseif uMsg==WM_PAINT 
		invoke BeginPaint,hWnd,addr ps 
      
	  	mov    hdc,eax
	  	
  		invoke CreateCompatibleDC,hdc 
  		mov    hMemDC1,eax 
  		invoke SelectObject,hMemDC1,FondoBmp 
		invoke GetClientRect,hWnd,addr rect 
		invoke BitBlt,hdc,0,0,rect.right,rect.bottom,hMemDC1,0,0,SRCCOPY 
		invoke DeleteDC,hMemDC1
	    ;Se pintan a los personajes dependiendo de su direccion
	  	.if DirCuphead == DERECHA
			invoke CreateCompatibleDC,hdc 
      		mov    hMemDC1,eax 
      		invoke SelectObject,hMemDC1,CupheadBmp 
			invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,CupheadX,CupheadY,rect.right,rect.bottom,hMemDC1,0,0,SRCCOPY 
		  	invoke DeleteDC,hMemDC1
	  	.else
			invoke CreateCompatibleDC,hdc 
      		mov    hMemDC1,eax 
      		invoke SelectObject,hMemDC1,Cuphead2Bmp 
			invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,CupheadX,CupheadY,rect.right,rect.bottom,hMemDC1,0,0,SRCCOPY 
		  	invoke DeleteDC,hMemDC1
	  	.endif
	  
	  	.if DirRocket == IZQUIERDA
	  		invoke CreateCompatibleDC,hdc 
      		mov    hMemDC2,eax 
      		invoke SelectObject,hMemDC2,RocketBmp 
      		invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,RocketX,RocketY,rect.right,rect.bottom,hMemDC2,0,0,SRCCOPY 
	  		invoke DeleteDC,hMemDC2
	  	.else
	  		invoke CreateCompatibleDC,hdc 
      		mov    hMemDC2,eax 
      		invoke SelectObject,hMemDC2,Rocket2Bmp 
      		invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,RocketX,RocketY,rect.right,rect.bottom,hMemDC2,0,0,SRCCOPY 
	  		invoke DeleteDC,hMemDC2
	  	.endif
	  	;Solamente si se pasa al nivel 2 se pinta al otro cohete
	  	.if Estado == NIVEL2
	  		.if DirRocket2 == IZQUIERDA 
	  			invoke CreateCompatibleDC,hdc 
  				mov    hMemDC2,eax 
      			invoke SelectObject,hMemDC2,Rocket3Bmp 
      			invoke GetClientRect,hWnd,addr rect 
      			invoke BitBlt,hdc,Rocket2X,Rocket2Y,rect.right,rect.bottom,hMemDC2,0,0,SRCCOPY 
	  			invoke DeleteDC,hMemDC2
	  		.else
	  			invoke CreateCompatibleDC,hdc 
      			mov    hMemDC2,eax 
      			invoke SelectObject,hMemDC2,Rocket4Bmp 
     				invoke GetClientRect,hWnd,addr rect 
      			invoke BitBlt,hdc,Rocket2X,Rocket2Y,rect.right,rect.bottom,hMemDC2,0,0,SRCCOPY 
	  			invoke DeleteDC,hMemDC2
	  		.endif
	  	.endif
	  
 	 	invoke CreateCompatibleDC,hdc 
      	mov    hMemDC3,eax 
      	invoke SelectObject,hMemDC3,HildaBmp 
      	invoke GetClientRect,hWnd,addr rect 
      	invoke BitBlt,hdc,HildaX,HildaY,rect.right,rect.bottom,hMemDC3,0,0,SRCCOPY 
	  	invoke DeleteDC,hMemDC3                       
	  
	  	invoke EndPaint,hWnd,addr ps
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam		
		ret
	.ENDIF
	xor eax,eax
	ret
WndProc endp

MovHilda proc                   ;este procedimiento sirve para
pushad							;para mover a Hilda Berg
.if DirHilda == ARRIBA
	sub HildaY, 10
	.if HildaY == 10
		mov DirHilda, ABAJO
	.endif
.elseif DirHilda == ABAJO
	add HildaY, 10
	.if HildaY == 360
		mov DirHilda, ARRIBA
	.endif			
.endif
popad
ret
MovHilda endp

MovRocket proc                  ;este proc sirve para mover al Cohete
pushad

mov eax, CupheadX
mov ebx, CupheadY

.if RocketX < eax
	mov DirRocket, DERECHA
	add RocketX, 10
.elseif RocketX > eax
	mov DirRocket, IZQUIERDA
	sub RocketX, 10
.endif

.if RocketY < ebx
	;mov DirRocket, ABAJO
	add RocketY, 10
.elseif RocketY > ebx
	;mov DirRocket, ARRIBA
	sub RocketY, 10
.endif

popad
ret
MovRocket endp

MovRocket2 proc                  ;este proc sirve para mover al Cohete 2
pushad

mov eax, CupheadX
mov ebx, CupheadY

.if Rocket2X < eax
	mov DirRocket2, DERECHA
	add Rocket2X, 10
.elseif Rocket2X > eax
	mov DirRocket2, IZQUIERDA
	sub Rocket2X, 10
.endif

.if Rocket2Y < ebx
	;mov DirRocket, ABAJO
	add Rocket2Y, 10
.elseif Rocket2Y > ebx
	;mov DirRocket, ARRIBA
	sub Rocket2Y, 10
.endif

popad
ret
MovRocket2 endp

GenerarPos proc           ;generar las posiciones para Cuphead y el Cohete1
pushad
invoke GetTickCount
invoke nseed, eax	
invoke nrandom, 82
imul diez
mov CupheadX, eax
	 
invoke GetTickCount
imul dos
invoke nseed, eax
invoke nrandom, 56
imul diez
mov CupheadY, eax
	 
invoke GetTickCount
imul tres
invoke nseed, eax
invoke nrandom, 82
imul diez
mov RocketX, eax
	 
invoke GetTickCount
imul cuatro
invoke nseed, eax
invoke nrandom, 56
imul diez
mov RocketY, eax

popad
ret
GenerarPos endp

GenerarPos2 proc                  ;genera las posiciones para el cohete 2
pushad

invoke GetTickCount
imul tres
imul dos
invoke nseed, eax
invoke nrandom, 82
imul diez
mov Rocket2X, eax
	 
invoke GetTickCount
imul cuatro
imul dos
invoke nseed, eax
invoke nrandom, 56
imul diez
mov Rocket2Y, eax

popad
ret
GenerarPos2 endp

JuegoNuevo proc                    ;este procedimiento sirve para reiniciar
pushad							   ;el juego

mov Estado, NIVEL1	
mov DirCuphead, DERECHA	
mov DirRocket, IZQUIERDA
mov DirRocket, IZQUIERDA
mov DirHilda, ARRIBA
mov Contador, 0
mov Contador2, 0

mov HildaX,   900
mov HildaY,   100

popad
ret
JuegoNuevo endp

end start
