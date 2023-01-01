.386
.model flat,stdcall
option casemap:none
include c:\masm32\include\windows.inc 
include c:\masm32\include\user32.inc 
include c:\masm32\include\kernel32.inc
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
IDT_TIMER2   equ 101
IDT_TIMER3   equ 102
IDT_TIMER4   equ 103
IDT_TIMER5   equ 104
IDB_CUPHEAD  equ 1
IDB_CUPHEAD2 equ 2
IDB_GHOST1   equ 3
IDB_GHOST2   equ 4
IDB_GHOST3   equ 5
IDB_GHOST4   equ 6
IDB_GHOST5   equ 7
IDB_GHOST6   equ 8
IDB_GHOST7   equ 9
IDB_GHOST8   equ 10
IDM_MENU     equ 11	 
IDM_NUEVO    equ 12
IDM_JUEGO    equ 13
IDM_ACERCA   equ 14
IDB_FUEGO1   equ 15
IDB_FUEGO2   equ 16
IDB_FUEGO3   equ 17
IDB_FUEGO4   equ 18
IDB_FUEGO5   equ 19
IDB_FUEGO6   equ 20
IDB_FUEGO7   equ 21
IDB_FUEGO8   equ 22
IDB_FUEGO9   equ 23
IDB_FUEGO10  equ 24
IDB_FUEGO11  equ 25
IDB_FUEGO12  equ 26

IDB_FONDO1   equ 100
IDB_FONDO2   equ 101

DERECHA      equ 200  ;banderas de movimiento
ARRIBA	     equ 201
ABAJO	     equ 202
IZQUIERDA    equ 203

NIVEL1     	 equ 203
NIVEL2       equ 204  ;constantes del Estado del juego
NIVEL3       equ 206
NIVEL4       equ 207
ESPERA       equ 208
PAUSA        equ 209

.data
msgfmt    byte "%s%s%s",0Ah,0
msg2fmt   byte "%s%s",0Ah,0
scorefmt  byte "%s%s%d", 0
ClassName byte "SimpleWinClass",0
AppName   byte "Mausoleum from Cuphead with Assembly",0
Juego1    byte "Se mueve con las flechas direccionales", 0ah,0
Juego2    byte "No deje que lo atrapen o el juego se termina", 0ah, 0
Juego3    byte 0
AcercaT   byte "Acerca de Mausoleum from Cuphead with Assembly", 0
Acerca1   byte "Universidad del Istmo - Ingienieria en Computación", 0ah, 0
Acerca2   byte "Por Marco Antonio Acevedo Escudero - 04 de Junio de 2019", 0ah
Acerca3   byte "Lenguaje Ensamblador - 2018B-2019A",0
Win1Msg   db "Mausoleum from Cuphead with Assembly - Felicidades, pasó el nivel 1 :D",0
Win2Msg   db "Mausoleum from Cuphead with Assembly - Felicidades, pasó el nivel 2 :D",0
Win3Msg   db "Mausoleum from Cuphead with Assembly - Felicidades, pasó el nivel 3 :D",0
Win4Msg   db "Mausoleum from Cuphead with Assembly - Felicidades, ha llegado al nivel 3 SOBREVIVA :D",0
LossMsg   db "Ha perdido :(( ", 0ah, 0
Score1Msg db "Su puntaje ha sido: ", 0
Contador  sdword 0
Contador2 sdword 0    ;variable auxiliar que nos permitirá saber cuando pasará de nivel el jugador
Contador3 sdword 0
Contador4 sdword 0
dos       sdword 2	  ;variables auxiliares para generar las posiciones
tres      sdword 3
cuatro    sdword 4
diez      sdword 10


.data?
hInstance   HINSTANCE ?
CommandLine LPSTR ?
CupheadBmp  dd ?        ;variables para cargar las imagenes
Cuphead2Bmp dd ?
Ghost1Bmp   dd ?
Ghost2Bmp   dd ?
Ghost3Bmp   dd ?
Ghost4Bmp   dd ?
Ghost5Bmp   dd ?
Ghost6Bmp   dd ?
Ghost7Bmp   dd ?
Ghost8Bmp   dd ?
FondoBmp    dd ?
Fondo2Bmp   dd ?
Fuego1Bmp   dd ?
Fuego2Bmp   dd ?
Fuego3Bmp   dd ?
Fuego4Bmp   dd ?
Fuego5Bmp   dd ?
Fuego6Bmp   dd ?
Fuego7Bmp   dd ?
Fuego8Bmp   dd ?
Fuego9Bmp   dd ?
Fuego10Bmp  dd ?
Fuego11Bmp  dd ?
Fuego12Bmp  dd ?
JuegoMsg    sdword ?     ;variabes para almacenar los mensajes del juego
AcercaMsg   sdword ?
ScoreMsg    sdword ?
Estado      sdword ?     ;variable auxiliar que nos ayuda a conocer los Estados del juego
DirCuphead  sdword ?	 ;Variables auxiliares para las direcciones de los personajes
DirGhost1   sdword ?
DirGhost2   sdword ?	;variables de posición de despliegue de las imagenes
DirGhost3   sdword ?
DirGhost4   sdword ?
CupheadX    sdword ?
CupheadY    sdword ?
Ghost1X     sdword ?
Ghost1Y     sdword ?
Ghost2X     sdword ?
Ghost2Y     sdword ?
Ghost3X     sdword ?
Ghost3Y     sdword ?
Ghost4X     sdword ?
Ghost4Y     sdword ?
Score       sdword ?
ContFuego1  sdword ?
FlagFuego1  sdword ?
ContFuego2  sdword ?
FlagFuego2  sdword ?
ContFuego3  sdword ?
FlagFuego3  sdword ?
ContLuz     sdword ?
FlagLuz     sdword ?

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
           CW_USEDEFAULT,1000,730,NULL,NULL,\
           hInst,NULL
	mov   hwnd,eax
	invoke ShowWindow, hwnd,SW_SHOWNORMAL
	invoke UpdateWindow, hwnd
	
	;se carga el menu
	invoke LoadMenu, hInst, IDM_MENU  
	invoke SetMenu, hwnd, eax
	;se declaran las condiciones iniciales del juego
	mov Estado, PAUSA
	mov DirCuphead, DERECHA
	mov DirGhost1, IZQUIERDA
	mov DirGhost2, IZQUIERDA
	mov DirGhost3, IZQUIERDA
	mov DirGhost4, IZQUIERDA
	mov Score, 0
	
	mov ContFuego1, 0
	mov FlagFuego1, 1
	mov ContFuego2, 0
	mov FlagFuego2, 2
	mov ContFuego3, 0
	mov FlagFuego3, 3
	mov ContLuz, 0
	mov FlagLuz, 0
	
	.repeat
		call GenerarPosC 
	.until !((CupheadX > 10 && CupheadX < 450) && (CupheadY > 50 && CupheadY < 220)) &&  !((CupheadX > 460 && CupheadX < 800) && (CupheadY > 260 && CupheadY < 530)) && !((CupheadX > 75 && CupheadX < 290) && (CupheadY > 240 && CupheadY < 580))
	.repeat
		call GenerarPos1
	.until !((Ghost1X > 10 && Ghost1X < 450) && (Ghost1Y > 50 && Ghost1Y < 220)) &&  !((Ghost1X > 500 && Ghost1X < 800) && (Ghost1Y > 240 && Ghost1Y < 530)) &&  !((Ghost1X > 40 && Ghost1X < 290) && (Ghost1Y > 240 && Ghost1Y < 580))

	
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
 	LOCAL hMemDC:HDC
	.IF uMsg==WM_DESTROY
		invoke DeleteObject, FondoBmp
		invoke DeleteObject, Fondo2Bmp
		invoke DeleteObject, CupheadBmp
		invoke DeleteObject, Cuphead2Bmp
		invoke DeleteObject, Ghost1Bmp
		invoke DeleteObject, Ghost2Bmp
		invoke DeleteObject, Ghost3Bmp
		invoke DeleteObject, Ghost4Bmp
		invoke DeleteObject, Ghost5Bmp
		invoke DeleteObject, Ghost6Bmp
		invoke DeleteObject, Ghost7Bmp
		invoke DeleteObject, Ghost8Bmp
		invoke DeleteObject, Fuego1Bmp
		invoke DeleteObject, Fuego2Bmp
		invoke DeleteObject, Fuego3Bmp
		invoke DeleteObject, Fuego4Bmp
		invoke DeleteObject, Fuego5Bmp
		invoke DeleteObject, Fuego6Bmp
		invoke DeleteObject, Fuego7Bmp
		invoke DeleteObject, Fuego8Bmp
		invoke DeleteObject, Fuego9Bmp
		invoke DeleteObject, Fuego10Bmp
		invoke DeleteObject, Fuego11Bmp
		invoke DeleteObject, Fuego12Bmp
		invoke PostQuitMessage,NULL
	
	.elseif uMsg == WM_CREATE
		invoke SetTimer, hWnd, IDT_TIMER5, 500, NULL
		invoke InvalidateRect, hWnd, NULL, TRUE
	 	;Se cargan las imagenes
		invoke LoadBitmap,hInstance,IDB_FONDO1
		mov FondoBmp,eax
		invoke LoadBitmap,hInstance,IDB_FONDO2
		mov Fondo2Bmp,eax
		
		invoke LoadBitmap,hInstance,IDB_CUPHEAD
		mov CupheadBmp,eax
		invoke LoadBitmap,hInstance,IDB_CUPHEAD2
		mov Cuphead2Bmp,eax
		
		invoke LoadBitmap,hInstance,IDB_GHOST1
		mov Ghost1Bmp,eax
		invoke LoadBitmap,hInstance,IDB_GHOST2
		mov Ghost2Bmp,eax
		
		invoke LoadBitmap,hInstance,IDB_GHOST3
		mov Ghost3Bmp,eax
		invoke LoadBitmap,hInstance,IDB_GHOST4
		mov Ghost4Bmp,eax
		
		invoke LoadBitmap,hInstance,IDB_GHOST5
		mov Ghost5Bmp,eax
		invoke LoadBitmap,hInstance,IDB_GHOST6
		mov Ghost6Bmp,eax
		
		invoke LoadBitmap,hInstance,IDB_GHOST7
		mov Ghost7Bmp,eax
		invoke LoadBitmap,hInstance,IDB_GHOST8
		mov Ghost8Bmp,eax
		
		invoke LoadBitmap,hInstance,IDB_FUEGO1
		mov Fuego1Bmp,eax
		invoke LoadBitmap,hInstance,IDB_FUEGO2
		mov Fuego2Bmp,eax
		invoke LoadBitmap,hInstance,IDB_FUEGO3
		mov Fuego3Bmp,eax
		invoke LoadBitmap,hInstance,IDB_FUEGO4
		mov Fuego4Bmp,eax
		
		invoke LoadBitmap,hInstance,IDB_FUEGO5
		mov Fuego5Bmp,eax
		invoke LoadBitmap,hInstance,IDB_FUEGO6
		mov Fuego6Bmp,eax
		invoke LoadBitmap,hInstance,IDB_FUEGO7
		mov Fuego7Bmp,eax
		invoke LoadBitmap,hInstance,IDB_FUEGO8
		mov Fuego8Bmp,eax
		
		invoke LoadBitmap,hInstance,IDB_FUEGO9
		mov Fuego9Bmp,eax
		invoke LoadBitmap,hInstance,IDB_FUEGO10
		mov Fuego10Bmp,eax
		invoke LoadBitmap,hInstance,IDB_FUEGO11
		mov Fuego11Bmp,eax
		invoke LoadBitmap,hInstance,IDB_FUEGO12
		mov Fuego12Bmp,eax
		
		
	.elseif uMsg==WM_COMMAND ;comandos de la barra de herramientas
	    mov eax, wParam

	  	.if wParam == IDM_JUEGO
	  		invoke crt_sprintf, ADDR JuegoMsg, ADDR msgfmt, ADDR Juego1, ADDR Juego2, ADDR Juego3
 	 	invoke MessageBox,NULL,ADDR JuegoMsg,ADDR AppName,MB_OK
 	 	
   	 	.elseif wParam == IDM_ACERCA
     	 	invoke crt_sprintf, ADDR AcercaMsg, ADDR msg2fmt, ADDR Acerca1, ADDR Acerca2
 	 		invoke MessageBox,NULL,ADDR AcercaMsg,ADDR AcercaT,MB_OK
 		
 		.elseif wParam == IDM_NUEVO
		 	call JuegoNuevo
		 	mov Estado, NIVEL1
		 	invoke SetTimer, hWnd, IDT_TIMER1,100, NULL
		 	invoke InvalidateRect, hWnd, NULL, TRUE
		 .endif

	.elseif uMsg == WM_KEYDOWN
    	;en esta parte se mueve a nuestro personaje
    	;preguntando primero si el juego no está detenido
    	;dependiendo de la tecla que se está pulsando
    	;nuestro personaje se va a mover
    	;con las nuevas condiciones que implican no poder atravesar
    	;los obstaculos que están en la zona de juego
		.if Estado == NIVEL1 || Estado == NIVEL2 || Estado == NIVEL3 || Estado == NIVEL4
			.if wParam == VK_RIGHT
				.if CupheadX != 910 && !(CupheadX == 30 && (CupheadY > 50  && CupheadY < 220)) && !(CupheadX == 530 && (CupheadY > 250 && CupheadY < 530)) && !(CupheadX == 140 && (CupheadY > 290 && CupheadY < 580))
					mov DirCuphead, DERECHA
					add CupheadX, 10
				.endif	
			.elseif wParam == VK_LEFT
				.if CupheadX != 0 && !(CupheadX == 450 && (CupheadY > 50 && CupheadY < 220)) && !(CupheadX == 800 && (CupheadY > 250 && CupheadY < 530)) && !(CupheadX == 290 && (CupheadY > 290 && CupheadY < 580))
					mov DirCuphead, IZQUIERDA
					sub CupheadX, 10
				.endif
			.endif
			.if wParam == VK_UP
				.if CupheadY != 10 && !(CupheadY == 220 && (CupheadX > 30 && CupheadX < 450)) && !(CupheadY == 530 && (CupheadX > 530 && CupheadX < 800)) && !(CupheadY == 580 && (CupheadX > 140 && CupheadX < 290))
					sub CupheadY, 10
				.endif
			.elseif wParam == VK_DOWN
				.if CupheadY != 620  && !(CupheadY == 50 && (CupheadX > 30 && CupheadX < 450)) && !(CupheadY == 250 && (CupheadX > 530 && CupheadX < 800)) && !(CupheadY == 290 && (CupheadX > 140 && CupheadX < 290))
					add CupheadY, 10
				.endif
			.endif
			;invoke InvalidateRect, hWnd, NULL, TRUE
		.endif
	
	.elseif uMsg==WM_TIMER
		.if wParam == IDT_TIMER1
;			En adelante se hacen las operaciones para determinar
;			cuando el jugador es alcanzado por el fantasma 1
   			pushad
			mov eax, CupheadX
			mov ebx, CupheadY
  			;Se mueve el fantasma 1
	  		call MovGhost1
   			;para determinar si alcanzó al jugador o no
			.if Ghost1X == eax && Ghost1Y == ebx
				invoke KillTimer,hWnd,IDT_TIMER1
				invoke KillTimer,hWnd,IDT_TIMER2
				mov Estado, ESPERA
				mov FlagLuz, 0
				invoke SetWindowTextA, hWnd, ADDR AppName
				invoke crt_sprintf, ADDR ScoreMsg, ADDR scorefmt, ADDR LossMsg, ADDR Score1Msg, Score
				invoke MessageBox, hWnd, ADDR ScoreMsg, ADDR AppName, MB_OK
			.endif
			popad
			contadores:
			;condicion de victoria:
			;Ninguna en realidad, el juego se termina cuando el jugador es atrapado
			;mostrando el puntaje obtenido
			;primer nivel
			.if Contador == 40
				invoke KillTimer,hWnd,IDT_TIMER1
				mov Estado, PAUSA
				mov Contador,0
				mov Contador2, 0
				;se genera la posicion del segundo fantasma teniendo en cuenta que no aparezca
				;sobre puesto en los obtaculos
				.repeat
					call GenerarPos2
				.until !((Ghost2X > 10 && Ghost2X < 450) && (Ghost2Y > 50 && Ghost2Y < 220)) &&  !((Ghost2X > 500 && Ghost2X < 800) && (Ghost2Y > 240 && Ghost2Y < 530)) &&  !((Ghost2X > 40 && Ghost2X < 290) && (Ghost2Y > 240 && Ghost2Y < 580))
				mov Estado, NIVEL2
				;el segundo nivel implica un dificultad mayor con ambos fantasmas moviendose más rápido
				invoke SetTimer, hWnd, IDT_TIMER1, 90, NULL
				invoke SetTimer, hWnd, IDT_TIMER2, 80, NULL
				
				invoke SetWindowTextA, hWnd, ADDR Win1Msg
			.endif 
			;Segundo nivel
			.if Contador2 == 40
				invoke KillTimer,hWnd,IDT_TIMER1
				invoke KillTimer,hWnd,IDT_TIMER2
				mov Estado, PAUSA
				mov Contador, 0
				mov Contador2, 0
				mov Contador3, 0
				;se genera la posicion del tercer fantasma teniendo en cuenta que no aparezca
				;sobre puesto en los obtaculos
				.repeat
					call GenerarPos3
				.until !((Ghost3X > 10 && Ghost3X < 450) && (Ghost3Y > 50 && Ghost3Y < 220)) &&  !((Ghost3X > 500 && Ghost3X < 800) && (Ghost3Y > 240 && Ghost3Y < 530)) &&  !((Ghost3X > 40 && Ghost3X < 290) && (Ghost3Y > 240 && Ghost3Y < 580))
				mov Estado, NIVEL3
				;el segundo nivel implica un dificultad mayor con ambos fantasmas moviendose más rápido
				invoke SetTimer, hWnd, IDT_TIMER1, 85, NULL
				invoke SetTimer, hWnd, IDT_TIMER2, 75, NULL
				invoke SetTimer, hWnd, IDT_TIMER3, 65, NULL
				invoke SetWindowTextA, hWnd, ADDR Win2Msg	
			.endif 
			;Tercer nivel
			.if Contador3 == 40
				invoke KillTimer,hWnd,IDT_TIMER1
				invoke KillTimer,hWnd,IDT_TIMER2
				invoke KillTimer,hWnd,IDT_TIMER3
				mov Estado, PAUSA
				mov Contador, 0
				mov Contador2, 0
				mov Contador3, 0
				mov Contador4, 0
				;se genera la posicion del tercer fantasma teniendo en cuenta que no aparezca
				;sobre puesto en los obtaculos
				.repeat
					call GenerarPos4
				.until !((Ghost4X > 10 && Ghost4X < 450) && (Ghost4Y > 20 && Ghost4Y < 220)) &&  !((Ghost4X > 500 && Ghost4X < 800) && (Ghost4Y > 240 && Ghost4Y < 530)) &&  !((Ghost4X > 40 && Ghost4X < 290) && (Ghost4Y > 240 && Ghost4Y < 580))
				mov Estado, NIVEL4
				;el segundo nivel implica un dificultad mayor con ambos fantasmas moviendose más rápido
				invoke SetTimer, hWnd, IDT_TIMER1, 80, NULL
				invoke SetTimer, hWnd, IDT_TIMER2, 70, NULL
				invoke SetTimer, hWnd, IDT_TIMER3, 60, NULL
				invoke SetTimer, hWnd, IDT_TIMER4, 70, NULL
				invoke SetWindowTextA, hWnd, ADDR Win3Msg	
			.endif
			;cuarto nivel
			.if Contador4 == 40
				invoke KillTimer,hWnd,IDT_TIMER1
				invoke KillTimer,hWnd,IDT_TIMER2
				invoke KillTimer,hWnd,IDT_TIMER3
				invoke KillTimer,hWnd,IDT_TIMER4
				
				invoke SetTimer, hWnd, IDT_TIMER1, 70, NULL
				invoke SetTimer, hWnd, IDT_TIMER2, 60, NULL
				invoke SetTimer, hWnd, IDT_TIMER3, 50, NULL
				invoke SetTimer, hWnd, IDT_TIMER4, 65, NULL
				invoke SetWindowTextA, hWnd, ADDR Win4Msg	
			.endif
			;proc auxiliar para llevar el conteo del tiempo transcurrido del juego
			.if Estado == NIVEL1
				inc Contador
			.elseif Estado == NIVEL2
				inc Contador2
			.elseif Estado == NIVEL3
				inc Contador3
			.elseif Estado == NIVEL4
				inc Contador4
			.endif
			;Se incrementa la variable de puntaje
			inc Score
			
			invoke InvalidateRect, hWnd, NULL, TRUE
		.endif
		mover2:
		;Utilizo un segundo TIMER para controlar al fantasma del segundo nivel
		;Pues este TIMER "va más rápido" para aumentar la dificultad del juego
		.if wParam == IDT_TIMER2
			pushad
			mov eax, CupheadX
			mov ebx, CupheadY
			;se mueve al fantasma
			call MovGhost2
   			;para determinar si alcanzó al jugador o no
			.if Ghost2X == eax && Ghost2Y == ebx
				invoke KillTimer,hWnd,IDT_TIMER1
				invoke KillTimer,hWnd,IDT_TIMER2
				mov Estado, ESPERA
				mov FlagLuz, 0
				invoke SetWindowTextA, hWnd, ADDR AppName
				invoke crt_sprintf, ADDR ScoreMsg, ADDR scorefmt, ADDR LossMsg, ADDR Score1Msg, Score
				invoke MessageBox, hWnd, ADDR ScoreMsg, ADDR AppName, MB_OK
			.endif
			popad	
		.endif
		;De igual manera utilizo uno para el tercero y el cuarto fantasma
		.if wParam == IDT_TIMER3
			pushad
			mov eax, CupheadX
			mov ebx, CupheadY
			;se mueve al fantasma
			call MovGhost3
   			;para determinar si alcanzó al jugador o no
			.if Ghost3X == eax && Ghost3Y == ebx
				invoke KillTimer,hWnd,IDT_TIMER1
				invoke KillTimer,hWnd,IDT_TIMER2
				invoke KillTimer,hWnd,IDT_TIMER3
				mov Estado, ESPERA
				mov FlagLuz, 0
				invoke SetWindowTextA, hWnd, ADDR AppName
				invoke crt_sprintf, ADDR ScoreMsg, ADDR scorefmt, ADDR LossMsg, ADDR Score1Msg, Score
				invoke MessageBox, hWnd, ADDR ScoreMsg, ADDR AppName, MB_OK
			.endif
			popad	
		.endif
		.if wParam == IDT_TIMER4
			pushad
			mov eax, CupheadX
			mov ebx, CupheadY
			;se mueve al fantasma
			call MovGhost4
   			;para determinar si alcanzó al jugador o no
			.if Ghost4X == eax && Ghost4Y == ebx
				invoke KillTimer,hWnd,IDT_TIMER1
				invoke KillTimer,hWnd,IDT_TIMER2
				invoke KillTimer,hWnd,IDT_TIMER3
				invoke KillTimer,hWnd,IDT_TIMER4
				mov Estado, ESPERA
				mov FlagLuz, 0
				invoke SetWindowTextA, hWnd, ADDR AppName
				invoke crt_sprintf, ADDR ScoreMsg, ADDR scorefmt, ADDR LossMsg, ADDR Score1Msg, Score
				invoke MessageBox, hWnd, ADDR ScoreMsg, ADDR AppName, MB_OK
			.endif
			popad	
		.endif
		timerfuego:
		;este timer sirve para controlar el moviemiento de las antorchas
		;y del momento cuando se atenua la luz del escenario
		.if wParam == IDT_TIMER5
			.if ContFuego1 == 0
				mov FlagFuego1, 1
			.elseif ContFuego1 == 1
				mov FlagFuego1, 2
			.elseif ContFuego1 == 2
				mov FlagFuego1, 3
			.elseif ContFuego1 == 3
				mov FlagFuego1, 4
				mov ContFuego1, -1
			.endif
			inc ContFuego1
			
			.if ContFuego2 == 0
				mov FlagFuego2, 3
			.elseif ContFuego2 == 1
				mov FlagFuego2, 1
			.elseif ContFuego2 == 2
				mov FlagFuego2, 4
			.elseif ContFuego2 == 3
				mov FlagFuego2, 1
				mov ContFuego2, -1
			.endif
			inc ContFuego2
			
			.if ContFuego3 == 0
				mov FlagFuego3, 2
			.elseif ContFuego3 == 1
				mov FlagFuego3, 4
			.elseif ContFuego3 == 2
				mov FlagFuego3, 1
			.elseif ContFuego3 == 3
				mov FlagFuego3, 3
				mov ContFuego3, -1
			.endif
			inc ContFuego3
			;la luz sólo se atenuará cuando se esté en el nivel 4
			.if Estado == NIVEL4
				.if ContLuz == 5
					mov FlagLuz, 1	
				.elseif ContLuz == 6
					mov FlagLuz, 1
					mov ContLuz, 0
				.else 
					mov FlagLuz, 0
				.endif	
				inc ContLuz
			.endif
			.if Estado == PAUSA
				invoke InvalidateRect, hWnd, NULL, TRUE
			.endif	
		.endif
		
	pintar:	
	.elseif uMsg==WM_PAINT 
		invoke BeginPaint,hWnd,addr ps 
      	mov    hdc,eax
	  	;se pinta el fondo
	  	invoke CreateCompatibleDC,hdc 
		mov    hMemDC,eax 
		invoke SelectObject,hMemDC,FondoBmp 
		invoke GetClientRect,hWnd,addr rect 
		invoke BitBlt,hdc,0,0,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
		invoke DeleteDC,hMemDC
		;se pintan las antorchas
		.if FlagFuego1 == 1
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego1Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,675,380,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.elseif FlagFuego1 == 2
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego2Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,675,380,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.elseif FlagFuego1 == 3
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego3Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,675,380,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.elseif FlagFuego1 == 4
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego4Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,675,380,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.endif
		
		.if FlagFuego2 == 1
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego5Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,220,430,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.elseif FlagFuego2 == 2
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego6Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,220,430,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.elseif FlagFuego2 == 3
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego7Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,220,430,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.elseif FlagFuego2 == 4
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego8Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,220,430,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.endif
		
		.if FlagFuego3 == 1
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego9Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,240,125,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.elseif FlagFuego3 == 2
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego10Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,240,125,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.elseif FlagFuego3 == 3
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego11Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,240,125,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.elseif FlagFuego3 == 4
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fuego12Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,240,125,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.endif
		
	  	;se pintan a los personajes dependiendo de su direccion actual
  		.if DirCuphead == DERECHA
  			invoke CreateCompatibleDC,hdc 
  			mov    hMemDC,eax 
  			invoke SelectObject,hMemDC,CupheadBmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,CupheadX,CupheadY,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
  		.else
  			invoke CreateCompatibleDC,hdc 
  			mov    hMemDC,eax 
  			invoke SelectObject,hMemDC,Cuphead2Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,CupheadX,CupheadY,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
  		.endif
  		
  		.if DirGhost1 == IZQUIERDA
  			invoke CreateCompatibleDC,hdc 
  			mov    hMemDC,eax 
  			invoke SelectObject,hMemDC, Ghost1Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,Ghost1X,Ghost1Y,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
  		.else
  			invoke CreateCompatibleDC,hdc 
  			mov    hMemDC,eax 
  			invoke SelectObject,hMemDC,Ghost2Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,Ghost1X,Ghost1Y,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
  		.endif
  		
  		;Solamente si se pasa al nivel 2 se pinta al otro fantasma
	  	.if Estado == NIVEL2 || Estado == ESPERA || Estado == NIVEL3 || Estado == NIVEL4
	  		.if DirGhost2 == IZQUIERDA 
	  			invoke CreateCompatibleDC,hdc 
  				mov    hMemDC,eax 
      				invoke SelectObject,hMemDC,Ghost3Bmp 
      				invoke GetClientRect,hWnd,addr rect 
      				invoke BitBlt,hdc,Ghost2X,Ghost2Y,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
	  			invoke DeleteDC,hMemDC
	  		.else
	  			invoke CreateCompatibleDC,hdc 
      				mov    hMemDC,eax 
      				invoke SelectObject,hMemDC,Ghost4Bmp 
     				invoke GetClientRect,hWnd,addr rect 
      				invoke BitBlt,hdc,Ghost2X,Ghost2Y,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
	  			invoke DeleteDC,hMemDC
	  		.endif
		.endif
		
		.if Estado == ESPERA || Estado == NIVEL3 || Estado == NIVEL4
	  		.if DirGhost3 == IZQUIERDA 
	  			invoke CreateCompatibleDC,hdc 
  				mov    hMemDC,eax 
  				invoke SelectObject,hMemDC,Ghost5Bmp 
  				invoke GetClientRect,hWnd,addr rect 
  				invoke BitBlt,hdc,Ghost3X,Ghost3Y,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
	  			invoke DeleteDC,hMemDC
	  		.else
	  			invoke CreateCompatibleDC,hdc 
  				mov    hMemDC,eax 
  				invoke SelectObject,hMemDC,Ghost6Bmp 
  				invoke GetClientRect,hWnd,addr rect 
  				invoke BitBlt,hdc,Ghost3X,Ghost3Y,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
	  			invoke DeleteDC,hMemDC
	  		.endif
		.endif
		
		.if Estado == ESPERA || Estado == NIVEL4
	  		.if DirGhost4 == IZQUIERDA 
	  			invoke CreateCompatibleDC,hdc 
  				mov    hMemDC,eax 
  				invoke SelectObject,hMemDC,Ghost7Bmp 
  				invoke GetClientRect,hWnd,addr rect 
  				invoke BitBlt,hdc,Ghost4X,Ghost4Y,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
	  			invoke DeleteDC,hMemDC
	  		.else
	  			invoke CreateCompatibleDC,hdc 
  				mov    hMemDC,eax 
  				invoke SelectObject,hMemDC,Ghost8Bmp 
  				invoke GetClientRect,hWnd,addr rect 
  				invoke BitBlt,hdc,Ghost4X,Ghost4Y,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
	  			invoke DeleteDC,hMemDC
	  		.endif
		.endif
		;fondo sin luz
		.if FlagLuz
			invoke CreateCompatibleDC,hdc 
			mov    hMemDC,eax 
			invoke SelectObject,hMemDC,Fondo2Bmp 
			invoke GetClientRect,hWnd,addr rect 
			invoke BitBlt,hdc,0,0,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
			invoke DeleteDC,hMemDC
		.endif
		invoke EndPaint,hWnd,addr ps
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam		
		ret
	.ENDIF
	xor eax,eax
	ret
WndProc endp
;este proc es para iniciar un juego nuevo
;volviendo el juego a sus condiciones iniciales
;y generando nuevas posiciones para los personajes
JuegoNuevo proc
pushad
.if Estado != PAUSA
	.repeat
		call GenerarPosC 
	.until !((CupheadX > 10 && CupheadX < 450) && (CupheadY > 50 && CupheadY < 220)) &&  !((CupheadX > 460 && CupheadX < 800) && (CupheadY > 260 && CupheadY < 530)) && !((CupheadX > 75 && CupheadX < 290) && (CupheadY > 240 && CupheadY < 580))
	.repeat
		call GenerarPos1
	.until !((Ghost1X > 10 && Ghost1X < 450) && (Ghost1Y > 50 && Ghost1Y < 220)) &&  !((Ghost1X > 500 && Ghost1X < 800) && (Ghost1Y > 240 && Ghost1Y < 530)) &&  !((Ghost1X > 40 && Ghost1X < 290) && (Ghost1Y > 240 && Ghost1Y < 580))
.endif
mov Estado, NIVEL1
mov DirCuphead, DERECHA
mov DirGhost1, IZQUIERDA
mov DirGhost2, IZQUIERDA
mov DirGhost3, IZQUIERDA
mov DirGhost4, IZQUIERDA
mov Score, 0
mov Ghost2X, 2000
mov Ghost2Y, 2000
mov Ghost3X, 2000
mov Ghost3Y, 2000
mov Ghost4X, 2000
mov Ghost4Y, 2000
mov Contador, 0
mov Contador2, 0
mov Contador3, 0
mov Contador4, 0
mov ContFuego1, 0
mov ContLuz, 0
mov FlagLuz, 0
popad
ret
JuegoNuevo endp
;los siguientes dos procedimientos describen el movimiento de los fantasmas
MovGhost1 proc
pushad
mov eax, CupheadX
mov ebx, CupheadY


.if Ghost1X < eax
	.if (Ghost1X == 0 && (Ghost1Y > 30 && Ghost1Y < 220)) || (Ghost1X == 510 && (Ghost1Y > 250 && Ghost1Y < 550)) || (Ghost1X == 110 && (Ghost1Y > 280 && Ghost1Y < 580))
			
	.else
		mov DirGhost1, DERECHA
		add Ghost1X, 10
	.endif
.elseif Ghost1X > eax
	.if (Ghost1X == 450 && (Ghost1Y > 30 && Ghost1Y < 220)) || (Ghost1X == 800 && (Ghost1Y > 250 && Ghost1Y < 550)) || (Ghost1X == 290 && (Ghost1Y > 280 && Ghost1Y < 580))
		
	.else
		mov DirGhost1, IZQUIERDA
		sub Ghost1X, 10
	.endif
.endif
.if Ghost1Y < ebx
	.if (Ghost1Y == 50  && (Ghost1X > 0 && Ghost1X < 450)) || (Ghost1Y == 250 && (Ghost1X > 500 && Ghost1X < 800)) || (Ghost1Y == 280 && (Ghost1X > 100 && Ghost1X < 290))
		
	.else
		add Ghost1Y, 10
	.endif
.elseif Ghost1Y > ebx
	.if (Ghost1Y == 220  && (Ghost1X > 0 && Ghost1X < 450)) || (Ghost1Y == 530 && (Ghost1X > 500 && Ghost1X < 800)) || (Ghost1Y == 580 && (Ghost1X > 100 && Ghost1X < 290))
		
	.else
		sub Ghost1Y, 10
	.endif
.endif
  
popad
ret
MovGhost1 endp

MovGhost2 proc
pushad
mov eax, CupheadX
mov ebx, CupheadY
.if Ghost2X < eax
	.if (Ghost2X == 40 && (Ghost2Y > 40 && Ghost2Y < 220)) || (Ghost2X == 540 && (Ghost2Y > 240 && Ghost2Y < 540)) || (Ghost2X == 140 && (Ghost2Y > 270 && Ghost2Y < 600))
	;codigo
	.else
		mov DirGhost2, DERECHA
		add Ghost2X, 10
	.endif
.elseif Ghost2X > eax
	.if (Ghost2X == 450 && (Ghost2Y > 40 && Ghost2Y < 220)) || (Ghost2X == 800 && (Ghost2Y > 250 && Ghost2Y < 540)) || (Ghost2X == 290 && (Ghost2Y > 270 && Ghost2Y < 600))
	;codigo
	.else
		mov DirGhost2, IZQUIERDA
		sub Ghost2X, 10
	.endif
.endif
.if Ghost2Y < ebx
	.if (Ghost2Y == 40  && (Ghost2X > 40 && Ghost2X < 450)) || (Ghost2Y == 240 && (Ghost2X > 540 && Ghost2X < 800)) || (Ghost2Y == 270 && (Ghost2X > 150 && Ghost2X < 290))
		;codigo
	.else
		add Ghost2Y, 10
	.endif
.elseif Ghost2Y > ebx
	.if (Ghost2Y == 220  && (Ghost2X > 40 && Ghost2X < 450)) || (Ghost2Y == 530 && (Ghost2X > 540 && Ghost2X < 800)) || (Ghost2Y == 580 && (Ghost2X > 150 && Ghost2X < 290))
		;.if Ghost2X < eax
	.else
		sub Ghost2Y, 10
	.endif
.endif  
popad
ret
MovGhost2 endp

MovGhost3 proc
pushad
mov eax, CupheadX
mov ebx, CupheadY
.if Ghost3X < eax
	.if (Ghost3X == 30 && (Ghost3Y > 40 && Ghost3Y < 220)) || (Ghost3X == 530 && (Ghost3Y > 250 && Ghost3Y < 540)) || (Ghost3X == 120 && (Ghost3Y > 280 && Ghost3Y < 590))
	;codigo
	.else
		mov DirGhost3, DERECHA
		add Ghost3X, 10
	.endif
.elseif Ghost3X > eax                                                                                          
	.if (Ghost3X == 450 && (Ghost3Y > 40 && Ghost3Y < 220)) || (Ghost3X == 800 && (Ghost3Y > 250 && Ghost3Y < 540)) || (Ghost3X == 290 && (Ghost3Y > 280 && Ghost3Y < 590))
	;codigo
	.else
		mov DirGhost3, IZQUIERDA
		sub Ghost3X, 10
	.endif
.endif
.if Ghost3Y < ebx
	.if (Ghost3Y == 40  && (Ghost3X > 30 && Ghost3X < 450)) || (Ghost3Y == 250 && (Ghost3X > 530 && Ghost3X < 800)) || (Ghost3Y == 280 && (Ghost3X > 120 && Ghost3X < 290))
		;codigo
	.else
		add Ghost3Y, 10
	.endif
.elseif Ghost3Y > ebx
	.if (Ghost3Y == 220  && (Ghost3X > 30 && Ghost3X < 450)) || (Ghost3Y == 540 && (Ghost3X > 530 && Ghost3X < 800)) || (Ghost3Y == 590 && (Ghost3X > 120 && Ghost3X < 290))
		;.if Ghost2X < eax
	.else
		sub Ghost3Y, 10
	.endif
.endif  
popad
ret
MovGhost3 endp

MovGhost4 proc
pushad
mov eax, CupheadX
mov ebx, CupheadY
.if Ghost4X < eax
	.if (Ghost4X == 0 && (Ghost4Y > 20 && Ghost4Y < 220)) || (Ghost4X == 500 && (Ghost4Y > 220 && Ghost4Y < 550)) || (Ghost4X == 100 && (Ghost4Y > 250 && Ghost4Y < 590))
	;codigo
	.else
		mov DirGhost4, DERECHA
		add Ghost4X, 10
	.endif
.elseif Ghost4X > eax
	.if (Ghost4X == 450 && (Ghost4Y > 20 && Ghost4Y < 220)) || (Ghost4X == 800 && (Ghost4Y > 220 && Ghost4Y < 550)) || (Ghost4X == 290 && (Ghost4Y > 250 && Ghost4Y < 590))
	;codigo
	.else
		mov DirGhost4, IZQUIERDA
		sub Ghost4X, 10
	.endif
.endif
.if Ghost4Y < ebx
	.if (Ghost4Y == 20  && (Ghost4X > 0 && Ghost4X < 450)) || (Ghost4Y == 220 && (Ghost4X > 500 && Ghost4X < 800)) || (Ghost4Y == 250 && (Ghost4X > 100 && Ghost4X < 290))
		;codigo
	.else
		add Ghost4Y, 10
	.endif
.elseif Ghost4Y > ebx
	.if (Ghost4Y == 220  && (Ghost4X > 0 && Ghost4X < 450)) || (Ghost4Y == 550 && (Ghost4X > 500 && Ghost4X < 800)) || (Ghost4Y == 590 && (Ghost4X > 100 && Ghost4X < 290))
		;.if Ghost2X < eax
	.else
		sub Ghost4Y, 10
	.endif
.endif  
popad
ret
MovGhost4 endp

;generar las posiciones para Cuphead
GenerarPosC proc           
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
popad
ret
GenerarPosC endp
;generar las posiciones para el fantasma 1
GenerarPos1 proc
pushad	 
invoke GetTickCount
imul tres
invoke nseed, eax
invoke nrandom, 82
imul diez
mov Ghost1X, eax
invoke GetTickCount
imul cuatro
invoke nseed, eax
invoke nrandom, 56
imul diez
mov Ghost1Y, eax
popad
ret
GenerarPos1 endp
;genera las posiciones para el fantasma 2
GenerarPos2 proc                  
pushad
invoke GetTickCount
imul tres
imul dos
invoke nseed, eax
invoke nrandom, 82
imul diez
mov Ghost2X, eax
invoke GetTickCount
imul cuatro
imul dos
invoke nseed, eax
invoke nrandom, 56
imul diez
mov Ghost2Y, eax
popad
ret
GenerarPos2 endp

;genera las posiciones para el fantasma 3
GenerarPos3 proc                  
pushad
invoke GetTickCount
imul tres
imul dos
invoke nseed, eax
invoke nrandom, 82
imul diez
mov Ghost3X, eax
invoke GetTickCount
imul cuatro
imul dos
invoke nseed, eax
invoke nrandom, 56
imul diez
mov Ghost3Y, eax
popad
ret
GenerarPos3 endp

;genera las posiciones para el fantasma 4
GenerarPos4 proc                  
pushad
invoke GetTickCount
imul tres
imul dos
invoke nseed, eax
invoke nrandom, 82
imul diez
mov Ghost4X, eax
invoke GetTickCount
imul cuatro
imul dos
invoke nseed, eax
invoke nrandom, 56
imul diez
mov Ghost4Y, eax
popad
ret
GenerarPos4 endp

end start
