.386
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc 
include \masm32\include\user32.inc 
include \masm32\include\kernel32.inc; 
include \masm32\include\gdi32.inc
include \masm32\include\masm32.inc
include \masm32\include\msvcrt.inc

includelib \masm32\lib\user32.lib 
includelib \masm32\lib\kernel32.lib 
includelib \masm32\lib\gdi32.lib
includelib c:\masm32\lib\masm32.lib
includelib c:\masm32\lib\msvcrt.lib


WinMain proto :DWORD,:DWORD,:DWORD,:DWORD

.const
IDT_TIMER1 equ 100
IDB_KIRBY  equ 1  ;para identificar a los personajes
IDB_FLUFF  equ 2  ;y otros elementos del programa
IDB_GEMITA equ 3
IDB_BRONTO equ 4
IDB_KIRBY2  equ 5  
IDB_FLUFF2  equ 6  
IDB_GEMITA2 equ 7
IDB_BRONTO2 equ 8
IDB_PISTA  equ 9
IDM_MENU  equ 10
IDM_NUEVO equ 11
IDM_JUEGO  equ 12
IDM_ACERCA equ 13

DERECHA    equ 20  ;banderas de movimiento
ARRIBA	   equ 21
ABAJO	   equ 22
IZQUIERDA  equ 23

.data
msgfmt byte "%s%s%s",0Ah,0
msg2fmt byte "%s%s",0Ah,0
ClassName db "SimpleWinClass",0
AppName  db "Random Race with Assembly",0
AcercaTitle db "Acerca de Random Race with Assembly", 0
Juego1 byte "El juego genera un numero aleatorio para cada personaje", 0ah,0
Juego2 byte "Ese numero le indicará el moverse o no", 0ah, 0
Juego3 byte "Solo vea y disfrute :)",0
Acerca1 byte "Universidad del Istmo - Ingienieria en Computación", 0ah, 0
Acerca2 byte "Por Marco Antonio Acevedo Escudero - 19 de Mayo de 2019", 0ah
Acerca3 byte "Lenguaje Ensamblador - 2018B-2019A",0
WinKirby byte "Ha ganado Kirby (el rosita)", 0
WinFluff byte "Ha ganado el Principe Fluff (el de la coronita)", 0
WinGemita byte "Ha ganado Gemita (la cosa kawaii azulita)", 0
WinBronto byte "Ha ganado Bronto (el mosquito)", 0
KirbyX  sdword 134 ;posisiones iniciales 
KirbyY  sdword 416 ;elegidas arbitrariamente
FluffX  sdword 334 ;para no dar ventaja
FluffY  sdword 364
GemitaX sdword 534
GemitaY sdword 314
BrontoX sdword 350        
BrontoY sdword 150
AuxKirby sdword 1  ;variables auxilares para la
AuxFluff sdword 2   ;generacion de los numeros
AuxGemita sdword 3  ;aleatorios
AuxBronto sdword 4


.data?
hInstance HINSTANCE ?
CommandLine LPSTR ?
KirbyBmp dd ?         
FluffBmp dd ?
GemitaBmp dd ?
BrontoBmp dd ?
KirbyBmp2 dd ?         
FluffBmp2 dd ?
GemitaBmp2 dd ?
BrontoBmp2 dd ?
PistaBmp dd ?
DirKirby sdword ?     ;direccion actual
DirFluff sdword ?
DirGemita sdword ?
DirBronto sdword ?
RanKirby sdword ?     ;bandera que nos indica si
RanFluff sdword ?	  ;podrá avanzar
RanGemita sdword ?
RanBronto sdword ?
JuegoMsg sdword ?
AcercaMsg sdword ?

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
           CW_USEDEFAULT,700,523,NULL,NULL,\
           hInst,NULL
	mov   hwnd,eax
	invoke ShowWindow, hwnd,SW_SHOWNORMAL
	invoke UpdateWindow, hwnd
	
	invoke LoadMenu, hInst, IDM_MENU  ;se carga el menu
	invoke SetMenu, hwnd, eax
	
	mov DirKirby, IZQUIERDA     ;direccion de inicio
 	mov DirFluff, IZQUIERDA     ;elegidas arbitrariamente para 
 	mov DirGemita, IZQUIERDA    ;no otorgar ventaja a algun personaje
 	mov DirBronto, DERECHA
	 
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
 	LOCAL hMemDC:HDC    ;pista   
   	LOCAL hMemDC1:HDC   ;Kirby     
   	LOCAL hMemDC2:HDC   ;Fluff prince
   	LOCAL hMemDC3:HDC   ;Gemita
	LOCAL hMemDC4:HDC   ;Bronto 

	.IF uMsg==WM_DESTROY
		invoke PostQuitMessage,NULL
	    invoke DeleteObject, KirbyBmp
	    invoke DeleteObject, FluffBmp
	    invoke DeleteObject, GemitaBmp
	    invoke DeleteObject, BrontoBmp
	    invoke DeleteObject, PistaBmp
	    invoke DeleteObject, KirbyBmp2
	    invoke DeleteObject, FluffBmp2
	    invoke DeleteObject, GemitaBmp2
	    invoke DeleteObject, BrontoBmp2
	    invoke KillTimer,hWnd,IDT_TIMER1
	    
	.elseif uMsg==WM_CREATE
		;El timer reccibe la velocidad como constante
		invoke SetTimer, hWnd, IDT_TIMER1,32, NULL

		;Se cargan las imagenes
		invoke LoadBitmap,hInstance,IDB_PISTA
		mov PistaBmp,eax
		invoke LoadBitmap,hInstance,IDB_KIRBY 
      	mov KirbyBmp,eax
      	invoke LoadBitmap,hInstance,IDB_FLUFF
      	mov FluffBmp,eax
		invoke LoadBitmap,hInstance,IDB_GEMITA
      	mov GemitaBmp,eax
      	invoke LoadBitmap,hInstance,IDB_BRONTO
      	mov BrontoBmp,eax
      	
      	invoke LoadBitmap,hInstance,IDB_KIRBY2 
      	mov KirbyBmp2,eax
      	invoke LoadBitmap,hInstance,IDB_FLUFF2
      	mov FluffBmp2,eax
		invoke LoadBitmap,hInstance,IDB_GEMITA2
      	mov GemitaBmp2,eax
      	invoke LoadBitmap,hInstance,IDB_BRONTO2
      	mov BrontoBmp2,eax
      	
	
	.elseif uMsg==WM_COMMAND ;comandos de la barra de herramientas
	    mov eax, wParam
	  	.if lParam==0     
			;invoke DestroyWindow,hWnd   
	  	.endif
	  	.if wParam == IDM_JUEGO
	  		invoke crt_sprintf, ADDR JuegoMsg, ADDR msgfmt, ADDR Juego1, ADDR Juego2, ADDR Juego3
 	 		invoke MessageBox,NULL,ADDR JuegoMsg,ADDR AppName,MB_OK
     	 .elseif wParam == IDM_ACERCA
     	 	invoke crt_sprintf, ADDR AcercaMsg, ADDR msg2fmt, ADDR Acerca1, ADDR Acerca2
 	 		invoke MessageBox,NULL,ADDR AcercaMsg,ADDR AcercaTitle,MB_OK	
		 .elseif wParam == IDM_NUEVO
		 	call JuegoNuevo
		 	invoke SetTimer, hWnd, IDT_TIMER1,32, NULL
		 	invoke InvalidateRect, hWnd, NULL, TRUE
		 .endif
	
	.elseif uMsg==WM_TIMER
		.if wParam == IDT_TIMER1 ;se genera un numero aleatorio
			invoke GetTickCount  ;si es igual a 1, el personaje
		 	invoke nseed, eax    ;se moverá dos pixeles en el circuito
	 		invoke nrandom, 2
	 		mov RanKirby, eax
	 		
		 	invoke GetTickCount
	 		imul AuxFluff
		 	invoke nseed, eax
		 	invoke nrandom, 2
	 		mov RanFluff, eax
	 		
		 	invoke GetTickCount
	 		imul AuxGemita
		 	invoke nseed, eax 
	 		invoke nrandom, 2
	 		mov RanGemita, eax
	 		
		 	invoke GetTickCount
	 		imul AuxBronto
		 	invoke nseed, eax
	 		invoke nrandom, 2
	 		mov RanBronto, eax
		
			.if RanKirby == 1
				call MovKirby
				.if KirbyX == 350 ;condicion de victoria
					invoke KillTimer,hWnd,IDT_TIMER1
					invoke MessageBox, hWnd, ADDR WinKirby, ADDR AppName, MB_OK
				.endif
			.endif
			
			.if RanFluff == 1
				call MovFluff
				.if FluffX == 350 ;condicion de victoria
					invoke KillTimer,hWnd,IDT_TIMER1
					invoke MessageBox, hWnd, ADDR WinFluff, ADDR AppName, MB_OK
				.endif
			.endif
			
			.if RanGemita == 1
				call MovGemita
				.if GemitaX == 350 && GemitaY == 100  ;condicion de victoria
					invoke KillTimer,hWnd,IDT_TIMER1
					invoke MessageBox, hWnd, ADDR WinGemita, ADDR AppName, MB_OK
				.endif
			.endif
			
			.if RanBronto == 1
				call MovBronto
				.if BrontoX == 350 && BrontoY == 150 ;condicion de victoria
					invoke KillTimer,hWnd,IDT_TIMER1
					invoke MessageBox, hWnd, ADDR WinBronto, ADDR AppName, MB_OK
				.endif
			.endif
		.endif 
		invoke InvalidateRect, hWnd, NULL, TRUE
	
	.elseif uMsg==WM_PAINT 
	  invoke BeginPaint,hWnd,addr ps 
      
	  mov    hdc,eax
	  invoke CreateCompatibleDC,hdc 
      mov    hMemDC,eax 
      invoke SelectObject,hMemDC,PistaBmp 
      invoke GetClientRect,hWnd,addr rect 
      invoke BitBlt,hdc,0,0,rect.right,rect.bottom,hMemDC,0,0,SRCCOPY 
	  invoke DeleteDC,hMemDC
	   
      .if DirKirby == IZQUIERDA                      ;se pinta una diferente posicion
      		invoke CreateCompatibleDC,hdc			 ;del personaje 
     		mov    hMemDC1,eax 
      		invoke SelectObject,hMemDC1,KirbyBmp2 
      		invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,KirbyX,KirbyY,rect.right,rect.bottom,hMemDC1,0,0,SRCCOPY 
      		invoke DeleteDC,hMemDC1	
      .else
			invoke CreateCompatibleDC,hdc 
      		mov    hMemDC1,eax 
      		invoke SelectObject,hMemDC1,KirbyBmp 
      		invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,KirbyX,KirbyY,rect.right,rect.bottom,hMemDC1,0,0,SRCCOPY 
      		invoke DeleteDC,hMemDC1	
	  .endif
	  
	  
      .if DirFluff == IZQUIERDA
      		invoke CreateCompatibleDC,hdc
      		mov    hMemDC2,eax 
      		invoke SelectObject,hMemDC2,FluffBmp2 
      		invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,FluffX,FluffY,rect.right,rect.bottom,hMemDC2,0,0,SRCCOPY 
   			invoke DeleteDC,hMemDC2		
      .else
      		invoke CreateCompatibleDC,hdc
      		mov    hMemDC2,eax 
      		invoke SelectObject,hMemDC2,FluffBmp 
      		invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,FluffX,FluffY,rect.right,rect.bottom,hMemDC2,0,0,SRCCOPY 
   			invoke DeleteDC,hMemDC2
	  .endif
      
      .if DirGemita == IZQUIERDA
      		invoke CreateCompatibleDC,hdc
      		mov    hMemDC3,eax 
      		invoke SelectObject,hMemDC3,GemitaBmp2 
      		invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,GemitaX,GemitaY,rect.right,rect.bottom,hMemDC3,0,0,SRCCOPY 
      		invoke DeleteDC,hMemDC3
	  .else
	  		invoke CreateCompatibleDC,hdc
      		mov    hMemDC3,eax 
      		invoke SelectObject,hMemDC3,GemitaBmp 
      		invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,GemitaX,GemitaY,rect.right,rect.bottom,hMemDC3,0,0,SRCCOPY 
      		invoke DeleteDC,hMemDC3		
      .endif	
      
      .if DirBronto == IZQUIERDA || DirBronto == ABAJO
      		invoke CreateCompatibleDC,hdc
      		mov    hMemDC4,eax 
      		invoke SelectObject,hMemDC4,BrontoBmp2 
      		invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,BrontoX,BrontoY,rect.right,rect.bottom,hMemDC4,0,0,SRCCOPY 
      		invoke DeleteDC,hMemDC4
      .else
      		invoke CreateCompatibleDC,hdc
      		mov    hMemDC4,eax 
      		invoke SelectObject,hMemDC4,BrontoBmp 
      		invoke GetClientRect,hWnd,addr rect 
      		invoke BitBlt,hdc,BrontoX,BrontoY,rect.right,rect.bottom,hMemDC4,0,0,SRCCOPY 
      		invoke DeleteDC,hMemDC4		
      .endif
      
	  invoke EndPaint,hWnd,addr ps 
	
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam		
		ret
	.ENDIF
	xor eax,eax
	ret
WndProc endp

MovKirby proc
pushad                                  ;procedimientos para mover
.if DirKirby == DERECHA					;a los personajes 
	add KirbyX,2						;dependiendo de su direccion actual
	.if KirbyX == 634
		mov DirKirby, ABAJO
	.endif
.elseif DirKirby == ABAJO
	add KirbyY,2
	.if KirbyY == 414
		mov DirKirby, IZQUIERDA
	.endif
.elseif DirKirby == IZQUIERDA
	sub KirbyX,2    
	.if KirbyX == 0
		mov DirKirby, ARRIBA
	.endif
.elseif DirKirby == ARRIBA
	sub KirbyY, 2  
	.if KirbyY == 0
		mov DirKirby, DERECHA
	.endif	
.endif 
popad
ret						
MovKirby endp

MovFluff proc
pushad
.if DirFluff == DERECHA
	add FluffX, 2
	.if FluffX == 584
		mov DirFluff, ABAJO
	.endif
.elseif DirFluff == ABAJO
	add FluffY, 2
	.if FluffY == 364
		mov DirFluff, IZQUIERDA
	.endif
.elseif DirFluff == IZQUIERDA	
	sub FluffX, 2
	.if FluffX == 50
		mov DirFluff, ARRIBA
	.endif
.elseif DirFluff == ARRIBA
	sub FluffY,2
	.if FluffY == 50
		mov DirFluff, DERECHA
	.endif	
.endif
popad
ret
MovFluff endp

MovGemita proc
pushad
.if DirGemita == DERECHA
	add GemitaX, 2
	.if GemitaX == 534
		mov DirGemita, ABAJO
	.endif
.elseif DirGemita == ABAJO	
	add GemitaY, 2
	.if GemitaY == 314
		mov DirGemita, IZQUIERDA
	.endif
.elseif DirGemita == IZQUIERDA
	sub GemitaX, 2
	.if GemitaX == 100
		mov DirGemita, ARRIBA
	.endif
.elseif DirGemita == ARRIBA
	sub GemitaY, 2
	.if GemitaY == 100
		mov DirGemita, DERECHA
	.endif	
.endif						
popad
ret
MovGemita endp

MovBronto proc
pushad
.if DirBronto == DERECHA
	add BrontoX, 2
	.if BrontoX == 484
		mov DirBronto, ABAJO
	.endif
.elseif DirBronto == ABAJO
	add BrontoY, 2 
	.if BrontoY == 264
		mov DirBronto, IZQUIERDA
	.endif		
.elseif DirBronto == IZQUIERDA
	sub BrontoX, 2
	.if BrontoX == 150
		mov DirBronto, ARRIBA
	.endif
.elseif DirBronto == ARRIBA
	sub BrontoY, 2
	.if BrontoY == 150
		mov DirBronto, DERECHA
	.endif	
.endif
popad
ret
MovBronto endp

JuegoNuevo proc       			;este procedimiento sirve para reiniciar las 
pushad				  			;posiciones
	mov DirKirby, IZQUIERDA     ;direccion de inicio
 	mov DirFluff, IZQUIERDA     ;elegidas arbitrariamente para 
 	mov DirGemita, IZQUIERDA    ;no otorgar ventaja a algun personaje
 	mov DirBronto, DERECHA
 	
 	mov KirbyX, 134 			;posisiones iniciales 
	mov KirbyY, 416 			;elegidas arbitrariamente
	mov FluffX, 334 			;para no dar ventaja
	mov FluffY, 364
	mov GemitaX, 534
	mov GemitaY, 314
	mov BrontoX, 350        
	mov BrontoY, 150
popad
ret
JuegoNuevo endp
end start
