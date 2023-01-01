.386
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc  
include \masm32\include\masm32.inc
include c:\masm32\include\msvcrt.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\masm32.lib
includelib c:\masm32\lib\msvcrt.lib

WinMain proto :DWORD,:DWORD,:DWORD,:DWORD

.const
IDM_MENU   equ 10
IDM_NUEVO  equ 11
IDM_JUEGO  equ 12
IDM_ACERCA equ 13
IDM_NIVEL1 equ 14
IDM_NIVEL2 equ 15
IDM_NIVEL3 equ 16
IDM_NIVEL4 equ 17

ESPERA     equ 1
NIVEL1     equ 2    ;4 bombas
NIVEL2     equ 3    ;7 bombas
NIVEL3     equ 4    ;10 bombas
NIVEL4     equ 5    ;15 bombas

Btn00      equ 100
Btn01      equ 101
Btn02      equ 102
Btn03      equ 103
Btn04      equ 104
Btn05      equ 105
Btn06      equ 106
Btn07      equ 107

Btn10      equ 200
Btn11      equ 201
Btn12      equ 202
Btn13      equ 203
Btn14      equ 204
Btn15      equ 205
Btn16      equ 206
Btn17      equ 207

Btn20      equ 300
Btn21      equ 301
Btn22      equ 302
Btn23      equ 303
Btn24      equ 304
Btn25      equ 305
Btn26      equ 306
Btn27      equ 307

Btn30      equ 400
Btn31      equ 401
Btn32      equ 402
Btn33      equ 403
Btn34      equ 404
Btn35      equ 405
Btn36      equ 406
Btn37      equ 407

Btn40      equ 500
Btn41      equ 501
Btn42      equ 502
Btn43      equ 503
Btn44      equ 504
Btn45      equ 505
Btn46      equ 506
Btn47      equ 507

Btn50      equ 600
Btn51      equ 601
Btn52      equ 602
Btn53      equ 603
Btn54      equ 604
Btn55      equ 605
Btn56      equ 606
Btn57      equ 607

Btn60      equ 700
Btn61      equ 701
Btn62      equ 702
Btn63      equ 703
Btn64      equ 704
Btn65      equ 705
Btn66      equ 706
Btn67      equ 707

Btn70      equ 800
Btn71      equ 801
Btn72      equ 802
Btn73      equ 803
Btn74      equ 804
Btn75      equ 805
Btn76      equ 806
Btn77      equ 807


.data
intfmt       db "%d", 0
msgfmt       byte "%s%s%s", 0Ah, 0
msg2fmt      byte "%s%s", 0Ah, 0
msg3fmt      db "%s", 0
btnfmt       db 0
ClassName    db "SimpleWinClass", 0
AppName      db "Minesweeper with Assembly", 0
Juego1       byte "El objetivo del juego es despejar un campo de minas sin detonar ninguna.", 0ah,0
Juego2       byte "Un número indica la cantidad de bombas que están a su alrededor.", 0ah, 0
Juego3       byte 0
AcercaT      byte "Acerca de Minesweeper  with Assembly", 0
Acerca1      byte "Universidad del Istmo - Ingienieria en Computación", 0ah, 0
Acerca2      byte "Por Marco Antonio Acevedo Escudero - 11 de Junio de 2019", 0ah
Acerca3      byte "Lenguaje Ensamblador - 2018B-2019A",0
WinMsg      byte "Felicidades, pasó el nivel :D",0
LossMsg      byte "Ha perdido :(( ", 0
WarningMsg   byte "Debe ingresar el nivel primero",0
Nivel1Msg    db "Nivel 1", 0
Nivel2Msg    db "Nivel 2", 0
Nivel3Msg    db "Nivel 3", 0
Nivel4Msg    db "Nivel 4", 0


dosA         sdword 2 
cuatroA		 sdword 4
treintaydosA sdword 32
bomba	     db "*",0
cero	     db "0",0
uno		     db "1",0
dos          db "2",0
tres	     db "3",0
cuatro	     db "4",0
cinco	     db "5",0
seis         db "6",0
siete	     db "7",0
ocho         db "8",0
Button       db "button",0


.data?
Tablero     sdword 8 dup(?)
			sdword 8 dup(?)
		 	sdword 8 dup(?)
		 	sdword 8 dup(?)
		 	sdword 8 dup(?)
		 	sdword 8 dup(?)
		 	sdword 8 dup(?)
		 	sdword 8 dup(?)
EstadoJuego sdword ? 
i			sdword ?
j           sdword ?
x			sdword ?
y			sdword ?
JuegoMsg	sdword ?
AcercaMsg   sdword ?
Msg			sdword ?
MsgNivel    sdword ?
numMinas    sdword ?
contadorNiv sdword ?

hInstance   HINSTANCE ?
CommandLine LPSTR ?
btn00       HWND ?
btn01       HWND ?
btn02       HWND ?
btn03       HWND ?
btn04       HWND ?
btn05       HWND ?
btn06       HWND ?
btn07       HWND ?

btn10       HWND ?
btn11       HWND ?
btn12       HWND ?
btn13       HWND ?
btn14       HWND ?
btn15       HWND ?
btn16       HWND ?
btn17       HWND ?

btn20       HWND ?
btn21       HWND ?
btn22       HWND ?
btn23       HWND ?
btn24       HWND ?
btn25       HWND ?
btn26       HWND ?
btn27       HWND ?

btn30       HWND ?
btn31       HWND ?
btn32       HWND ?
btn33       HWND ?
btn34       HWND ?
btn35       HWND ?
btn36       HWND ?
btn37       HWND ?

btn40       HWND ?
btn41       HWND ?
btn42       HWND ?
btn43       HWND ?
btn44       HWND ?
btn45       HWND ?
btn46       HWND ?
btn47       HWND ?

btn50       HWND ?
btn51       HWND ?
btn52       HWND ?
btn53       HWND ?
btn54       HWND ?
btn55       HWND ?
btn56       HWND ?
btn57       HWND ?

btn60       HWND ?
btn61       HWND ?
btn62       HWND ?
btn63       HWND ?
btn64       HWND ?
btn65       HWND ?
btn66       HWND ?
btn67       HWND ?

btn70       HWND ?
btn71       HWND ?
btn72       HWND ?
btn73       HWND ?
btn74       HWND ?
btn75       HWND ?
btn76       HWND ?
btn77       HWND ?


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
           CW_USEDEFAULT,480,550,NULL,NULL,\
           hInst,NULL
	mov   hwnd,eax
	invoke ShowWindow, hwnd,SW_SHOWNORMAL
	invoke UpdateWindow, hwnd
	
	;se carga el menu
	invoke LoadMenu, hInst, IDM_MENU  
	invoke SetMenu, hwnd, eax						
		
	mov EstadoJuego, ESPERA
		
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
   	LOCAL hMemDC:HDC
   	LOCAL rect:RECT
	.IF uMsg==WM_DESTROY
		invoke PostQuitMessage,NULL
	.elseif uMsg == WM_CREATE
	;Para el juego ocupo una matriz que se pinta en la ventana
	;dicha matriz almacena las bombas y los numero que indican sus adyacencias

	;Ocupo también una serie de botones para sobreponerlos sobre los numeros pintados
	;que se ocultan al presionarlos
		creacion:
;       Primera fila de botones------------------------------------------------
        invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			30, 30,50,50,hWnd,Btn00,hInstance,NULL
			mov btn00,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			80, 30,50,50,hWnd,Btn01,hInstance,NULL
			mov btn01,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			130, 30,50,50,hWnd,Btn02,hInstance,NULL
			mov btn02,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			180, 30,50,50,hWnd,Btn03,hInstance,NULL
			mov btn03,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			230, 30,50,50,hWnd,Btn04,hInstance,NULL
			mov btn04,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			280, 30,50,50,hWnd,Btn05,hInstance,NULL
			mov btn05,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			330, 30,50,50,hWnd,Btn06,hInstance,NULL
			mov btn06,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			380, 30,50,50,hWnd,Btn07,hInstance,NULL
			mov btn07,eax
;		Segunda fila de botones------------------------------------------------	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			30, 80,50,50,hWnd,Btn10,hInstance,NULL
			mov btn10,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			80, 80,50,50,hWnd,Btn11,hInstance,NULL
			mov btn11,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			130, 80,50,50,hWnd,Btn12,hInstance,NULL
			mov btn12,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			180, 80,50,50,hWnd,Btn13,hInstance,NULL
			mov btn13,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			230, 80,50,50,hWnd,Btn14,hInstance,NULL
			mov btn14,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			280, 80,50,50,hWnd,Btn15,hInstance,NULL
			mov btn15,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			330, 80,50,50,hWnd,Btn16,hInstance,NULL
			mov btn16,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			380, 80,50,50,hWnd,Btn17,hInstance,NULL
			mov btn17,eax
;		Tercera fila de botones------------------------------------------------	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			30, 130,50,50,hWnd,Btn20,hInstance,NULL
			mov btn20,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			80, 130,50,50,hWnd,Btn21,hInstance,NULL
			mov btn21,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			130, 130,50,50,hWnd,Btn22,hInstance,NULL
			mov btn22,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			180, 130,50,50,hWnd,Btn23,hInstance,NULL
			mov btn23,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			230, 130,50,50,hWnd,Btn24,hInstance,NULL
			mov btn24,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			280, 130,50,50,hWnd,Btn25,hInstance,NULL
			mov btn25,eax         
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			330, 130,50,50,hWnd,Btn26,hInstance,NULL
			mov btn26,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			380, 130,50,50,hWnd,Btn27,hInstance,NULL
			mov btn27,eax
;		Cuarta fila de botones------------------------------------------------	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			30, 180,50,50,hWnd,Btn30,hInstance,NULL
			mov btn30,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			80, 180,50,50,hWnd,Btn31,hInstance,NULL
			mov btn31,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			130, 180,50,50,hWnd,Btn32,hInstance,NULL
			mov btn32,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			180, 180,50,50,hWnd,Btn33,hInstance,NULL
			mov btn33,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			230, 180,50,50,hWnd,Btn34,hInstance,NULL
			mov btn34,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			280, 180,50,50,hWnd,Btn35,hInstance,NULL
			mov btn35,eax         
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			330, 180,50,50,hWnd,Btn36,hInstance,NULL
			mov btn36,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			380, 180,50,50,hWnd,Btn37,hInstance,NULL
			mov btn37,eax
;		Quinta fila de botones------------------------------------------------	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			30, 230,50,50,hWnd,Btn40,hInstance,NULL
			mov btn40,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			80, 230,50,50,hWnd,Btn41,hInstance,NULL
			mov btn41,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			130, 230,50,50,hWnd,Btn42,hInstance,NULL
			mov btn42,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			180, 230,50,50,hWnd,Btn43,hInstance,NULL
			mov btn43,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			230, 230,50,50,hWnd,Btn44,hInstance,NULL
			mov btn44,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			280, 230,50,50,hWnd,Btn45,hInstance,NULL
			mov btn45,eax         
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			330, 230,50,50,hWnd,Btn46,hInstance,NULL
			mov btn46,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			380, 230,50,50,hWnd,Btn47,hInstance,NULL
			mov btn47,eax
;		Sexta fila de botones------------------------------------------------	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			30, 280,50,50,hWnd,Btn50,hInstance,NULL
			mov btn50,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			80, 280,50,50,hWnd,Btn51,hInstance,NULL
			mov btn51,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			130, 280,50,50,hWnd,Btn52,hInstance,NULL
			mov btn52,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			180, 280,50,50,hWnd,Btn53,hInstance,NULL
			mov btn53,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			230, 280,50,50,hWnd,Btn54,hInstance,NULL
			mov btn54,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			280, 280,50,50,hWnd,Btn55,hInstance,NULL
			mov btn55,eax         
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			330, 280,50,50,hWnd,Btn56,hInstance,NULL
			mov btn56,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			380, 280,50,50,hWnd,Btn57,hInstance,NULL
			mov btn57,eax
;		Septima fila de botones------------------------------------------------	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			30, 330,50,50,hWnd,Btn60,hInstance,NULL
			mov btn60,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			80, 330,50,50,hWnd,Btn61,hInstance,NULL
			mov btn61,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			130, 330,50,50,hWnd,Btn62,hInstance,NULL
			mov btn62,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			180, 330,50,50,hWnd,Btn63,hInstance,NULL
			mov btn63,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			230, 330,50,50,hWnd,Btn64,hInstance,NULL
			mov btn64,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			280, 330,50,50,hWnd,Btn65,hInstance,NULL
			mov btn65,eax         
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			330, 330,50,50,hWnd,Btn66,hInstance,NULL
			mov btn66,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			380, 330,50,50,hWnd,Btn67,hInstance,NULL
			mov btn67,eax
;		Octava fila de botones------------------------------------------------	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			30, 380,50,50,hWnd,Btn70,hInstance,NULL
			mov btn70,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			80, 380,50,50,hWnd,Btn71,hInstance,NULL
			mov btn71,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			130, 380,50,50,hWnd,Btn72,hInstance,NULL
			mov btn72,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			180, 380,50,50,hWnd,Btn73,hInstance,NULL
			mov btn73,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			230, 380,50,50,hWnd,Btn74,hInstance,NULL
			mov btn74,eax
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			280, 380,50,50,hWnd,Btn75,hInstance,NULL
			mov btn75,eax         
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			330, 380,50,50,hWnd,Btn76,hInstance,NULL
			mov btn76,eax	
		invoke CreateWindowEx, NULL,ADDR Button,ADDR btnfmt,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			380, 380,50,50,hWnd,Btn77,hInstance,NULL
			mov btn77,eax

	;comandos de la barra de herramientas
	.elseif uMsg == WM_COMMAND
		mov eax, wParam
		botones:
	  	.if wParam == IDM_JUEGO
	  		
		  	invoke crt_sprintf, ADDR JuegoMsg, ADDR msgfmt, ADDR Juego1, ADDR Juego2, ADDR Juego3
 	 		invoke MessageBox,NULL,ADDR JuegoMsg,ADDR AppName,MB_OK
 	 		
   	 	.elseif wParam == IDM_ACERCA
     	 	
		  	invoke crt_sprintf, ADDR AcercaMsg, ADDR msg2fmt, ADDR Acerca1, ADDR Acerca2
 	 		invoke MessageBox,NULL,ADDR AcercaMsg,ADDR AcercaT,MB_OK
 			
	 	.elseif wParam == IDM_NIVEL1
 			mov EstadoJuego, NIVEL1
 			mov eax, 64
			sub eax, 4
			mov contadorNiv, eax
	 	.elseif wParam == IDM_NIVEL2
	 		mov EstadoJuego, NIVEL2
 			mov eax, 64
			sub eax, 7
			mov contadorNiv, eax
	 	.elseif wParam == IDM_NIVEL3
	 		mov EstadoJuego, NIVEL3
 			mov eax, 64
			sub eax, 10
			mov contadorNiv, eax
 	 	.elseif wParam == IDM_NIVEL4
 	 		mov EstadoJuego, NIVEL4
 			mov eax, 64
			sub eax, 15
			mov contadorNiv, eax
 		 
	 	.elseif wParam == IDM_NUEVO
			.if EstadoJuego != ESPERA
			 	invoke InvalidateRect, hWnd, NULL, TRUE
		 		call GenerarBombas
		 		call GenerarAdyacencias
			 	habilitarbotones:
			 	invoke ShowWindow, btn00, 1
				invoke ShowWindow, btn01, 1
				invoke ShowWindow, btn02, 1
				invoke ShowWindow, btn03, 1
				invoke ShowWindow, btn04, 1
				invoke ShowWindow, btn05, 1
				invoke ShowWindow, btn06, 1     
				invoke ShowWindow, btn07, 1
				
				invoke ShowWindow, btn10, 1
				invoke ShowWindow, btn11, 1
				invoke ShowWindow, btn12, 1
				invoke ShowWindow, btn13, 1
				invoke ShowWindow, btn14, 1
				invoke ShowWindow, btn15, 1
				invoke ShowWindow, btn16, 1
				invoke ShowWindow, btn17, 1
				
				invoke ShowWindow, btn20, 1
				invoke ShowWindow, btn21, 1
				invoke ShowWindow, btn22, 1
				invoke ShowWindow, btn23, 1
				invoke ShowWindow, btn24, 1
				invoke ShowWindow, btn25, 1
				invoke ShowWindow, btn26, 1
				invoke ShowWindow, btn27, 1
				
				invoke ShowWindow, btn30, 1
				invoke ShowWindow, btn31, 1
				invoke ShowWindow, btn32, 1
				invoke ShowWindow, btn33, 1
				invoke ShowWindow, btn34, 1
				invoke ShowWindow, btn35, 1
				invoke ShowWindow, btn36, 1
				invoke ShowWindow, btn37, 1
				
				invoke ShowWindow, btn40, 1
				invoke ShowWindow, btn41, 1
				invoke ShowWindow, btn42, 1
				invoke ShowWindow, btn43, 1
				invoke ShowWindow, btn44, 1
				invoke ShowWindow, btn45, 1
				invoke ShowWindow, btn46, 1
				invoke ShowWindow, btn47, 1
				
				invoke ShowWindow, btn50, 1
				invoke ShowWindow, btn51, 1
				invoke ShowWindow, btn52, 1
				invoke ShowWindow, btn53, 1
				invoke ShowWindow, btn54, 1
				invoke ShowWindow, btn55, 1
				invoke ShowWindow, btn56, 1
				invoke ShowWindow, btn57, 1
				
				invoke ShowWindow, btn60, 1
				invoke ShowWindow, btn61, 1
				invoke ShowWindow, btn62, 1
				invoke ShowWindow, btn63, 1
				invoke ShowWindow, btn64, 1
				invoke ShowWindow, btn65, 1
				invoke ShowWindow, btn66, 1
				invoke ShowWindow, btn67, 1
				
				invoke ShowWindow, btn70, 1
				invoke ShowWindow, btn71, 1
				invoke ShowWindow, btn72, 1
				invoke ShowWindow, btn73, 1
				invoke ShowWindow, btn74, 1
				invoke ShowWindow, btn75, 1
				invoke ShowWindow, btn76, 1
				invoke ShowWindow, btn77, 1

	 	 		invoke InvalidateRect, hWnd, NULL, TRUE
	 		.else
	 			invoke MessageBox, NULL, ADDR WarningMsg, ADDR AppName, MB_OK	
	 		.endif
	 	.endif
	 	accion_botones:
		.if EstadoJuego != ESPERA
			mov edx,wParam
			shr edx,16
			.if ax == Btn00
				pushad
				mov ebx, 0
				mov ebp, 0
				invoke ShowWindow, btn00, 0
				
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					ocultarbotones:
					invoke ShowWindow, btn00, 0
					invoke ShowWindow, btn01, 0
					invoke ShowWindow, btn02, 0
					invoke ShowWindow, btn03, 0
					invoke ShowWindow, btn04, 0
					invoke ShowWindow, btn05, 0
					invoke ShowWindow, btn06, 0     
					invoke ShowWindow, btn07, 0
					
					invoke ShowWindow, btn10, 0
					invoke ShowWindow, btn11, 0
					invoke ShowWindow, btn12, 0
					invoke ShowWindow, btn13, 0
					invoke ShowWindow, btn14, 0
					invoke ShowWindow, btn15, 0
					invoke ShowWindow, btn16, 0
					invoke ShowWindow, btn17, 0
					
					invoke ShowWindow, btn20, 0
					invoke ShowWindow, btn21, 0
					invoke ShowWindow, btn22, 0
					invoke ShowWindow, btn23, 0
					invoke ShowWindow, btn24, 0
					invoke ShowWindow, btn25, 0
					invoke ShowWindow, btn26, 0
					invoke ShowWindow, btn27, 0
					
					invoke ShowWindow, btn30, 0
					invoke ShowWindow, btn31, 0
					invoke ShowWindow, btn32, 0
					invoke ShowWindow, btn33, 0
					invoke ShowWindow, btn34, 0
					invoke ShowWindow, btn35, 0
					invoke ShowWindow, btn36, 0
					invoke ShowWindow, btn37, 0
					
					invoke ShowWindow, btn40, 0
					invoke ShowWindow, btn41, 0
					invoke ShowWindow, btn42, 0
					invoke ShowWindow, btn43, 0
					invoke ShowWindow, btn44, 0
					invoke ShowWindow, btn45, 0
					invoke ShowWindow, btn46, 0
					invoke ShowWindow, btn47, 0
					
					invoke ShowWindow, btn50, 0
					invoke ShowWindow, btn51, 0
					invoke ShowWindow, btn52, 0
					invoke ShowWindow, btn53, 0
					invoke ShowWindow, btn54, 0
					invoke ShowWindow, btn55, 0
					invoke ShowWindow, btn56, 0
					invoke ShowWindow, btn57, 0
					
					invoke ShowWindow, btn60, 0
					invoke ShowWindow, btn61, 0
					invoke ShowWindow, btn62, 0
					invoke ShowWindow, btn63, 0
					invoke ShowWindow, btn64, 0
					invoke ShowWindow, btn65, 0
					invoke ShowWindow, btn66, 0
					invoke ShowWindow, btn67, 0
					
					invoke ShowWindow, btn70, 0
					invoke ShowWindow, btn71, 0
					invoke ShowWindow, btn72, 0
					invoke ShowWindow, btn73, 0
					invoke ShowWindow, btn74, 0
					invoke ShowWindow, btn75, 0
					invoke ShowWindow, btn76, 0
					invoke ShowWindow, btn77, 0	
				.endif
				dec contadorNiv
				finjuego:
				.if contadorNiv == 0
					invoke MessageBox, NULL, ADDR WinMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones
				.endif
				popad
			.elseif ax == Btn01
			 	pushad
				mov ebx, 0
				mov ebp, 4
				invoke ShowWindow, btn01, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn02
			 	pushad
				mov ebx, 0
				mov ebp, 8
				invoke ShowWindow, btn02, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA	
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn03
			 	pushad
				mov ebx, 0
				mov ebp, 12
				invoke ShowWindow, btn03, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn04
			 	pushad
				mov ebx, 0
				mov ebp, 16
				invoke ShowWindow, btn04, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn05
			 	pushad
				mov ebx, 0
				mov ebp, 20
				invoke ShowWindow, btn05, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif 
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn06
			 	pushad
				mov ebx, 0
				mov ebp, 24
				invoke ShowWindow, btn06, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego 
				popad
			.elseif ax == Btn07
			 	pushad
				mov ebx, 0
				mov ebp, 28
				invoke ShowWindow, btn07, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif 
				dec contadorNiv
				jmp finjuego
				popad
			;Segunda fila--------------------------------------------------------
			.elseif ax == Btn10
				pushad
				mov ebx, 32
				mov ebp, 0
				invoke ShowWindow, btn10, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn11
			 	pushad
				mov ebx, 32
				mov ebp, 4
				invoke ShowWindow, btn11, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn12
			 	pushad
				mov ebx, 32
				mov ebp, 8
				invoke ShowWindow, btn12, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn13
			 	pushad
				mov ebx, 32
				mov ebp, 12
				invoke ShowWindow, btn13, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn14
			 	pushad
				mov ebx, 32
				mov ebp, 16
				invoke ShowWindow, btn14, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn15
			 	pushad
				mov ebx, 32
				mov ebp, 20
				invoke ShowWindow, btn15, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn16
			 	pushad
				mov ebx, 32
				mov ebp, 24
				invoke ShowWindow, btn16, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn17
			 	pushad
				mov ebx, 32
				mov ebp, 28
				invoke ShowWindow, btn17, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			;tercera fila-------------------------------------------------------
			.elseif ax == Btn20
				pushad
				mov ebx, 64
				mov ebp, 0
				invoke ShowWindow, btn20, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn21
			 	pushad
				mov ebx, 64
				mov ebp, 4
				invoke ShowWindow, btn21, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn22
			 	pushad
				mov ebx, 64
				mov ebp, 8
				invoke ShowWindow, btn22, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn23
			 	pushad
				mov ebx, 64
				mov ebp, 12
				invoke ShowWindow, btn23, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn24
			 	pushad
				mov ebx, 64
				mov ebp, 16
				invoke ShowWindow, btn24, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn25
			 	pushad
				mov ebx, 64
				mov ebp, 20
				invoke ShowWindow, btn25, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn26
			 	pushad
				mov ebx, 64
				mov ebp, 24
				invoke ShowWindow, btn26, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn27
			 	pushad
				mov ebx, 64
				mov ebp, 28
				invoke ShowWindow, btn27, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			;cuarta fila-------------------------------------------------------
			.elseif ax == Btn30
				pushad
				mov ebx, 96
				mov ebp, 0
				invoke ShowWindow, btn30, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn31
			 	pushad
				mov ebx, 96
				mov ebp, 4
				invoke ShowWindow, btn31, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn32
			 	pushad
				mov ebx, 96
				mov ebp, 8
				invoke ShowWindow, btn32, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn33
			 	pushad
				mov ebx, 96
				mov ebp, 12
				invoke ShowWindow, btn33, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif 
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn34
			 	pushad
				mov ebx, 96
				mov ebp, 16
				invoke ShowWindow, btn34, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn35
			 	pushad
				mov ebx, 96
				mov ebp, 20
				invoke ShowWindow, btn35, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif 
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn36
			 	pushad
				mov ebx, 96
				mov ebp, 24
				invoke ShowWindow, btn36, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn37
			 	pushad
				mov ebx, 96
				mov ebp, 28
				invoke ShowWindow, btn37, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			;quinta fila--------------------------------------------------------
			.elseif ax == Btn40
				pushad
				mov ebx, 128
				mov ebp, 0
				invoke ShowWindow, btn40, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn41
			 	pushad
				mov ebx, 128
				mov ebp, 4
				invoke ShowWindow, btn41, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn42
			 	pushad
				mov ebx, 128
				mov ebp, 8
				invoke ShowWindow, btn42, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA	
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn43
			 	pushad
				mov ebx, 128
				mov ebp, 12
				invoke ShowWindow, btn43, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA	
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn44
			 	pushad
				mov ebx, 128
				mov ebp, 16
				invoke ShowWindow, btn44, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA	
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn45
			 	pushad
				mov ebx, 128
				mov ebp, 20
				invoke ShowWindow, btn45, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn46
			 	pushad
				mov ebx, 128
				mov ebp, 24
				invoke ShowWindow, btn46, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn47
			 	pushad
				mov ebx, 128
				mov ebp, 28
				invoke ShowWindow, btn47, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA	
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			;sexta fila--------------------------------------------------------
			.elseif ax == Btn50
				pushad
				mov ebx, 160
				mov ebp, 0
				invoke ShowWindow, btn50, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn51
			 	pushad
				mov ebx, 160
				mov ebp, 4
				invoke ShowWindow, btn51, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn52
			 	pushad
				mov ebx, 160
				mov ebp, 8
				invoke ShowWindow, btn52, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn53
			 	pushad
				mov ebx, 160
				mov ebp, 12
				invoke ShowWindow, btn53, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn54
			 	pushad
				mov ebx, 160
				mov ebp, 16
				invoke ShowWindow, btn54, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn55
			 	pushad
				mov ebx, 160
				mov ebp, 20
				invoke ShowWindow, btn55, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA	
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn56
			 	pushad
				mov ebx, 160
				mov ebp, 24
				invoke ShowWindow, btn56, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn57
			 	pushad
				mov ebx, 160
				mov ebp, 28
				invoke ShowWindow, btn57, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			;septima fila--------------------------------------------------------
			.elseif ax == Btn60
				pushad
				mov ebx, 192
				mov ebp, 0
				invoke ShowWindow, btn60, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif 
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn61
			 	pushad
				mov ebx, 192
				mov ebp, 4            
				invoke ShowWindow, btn61, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA	
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn62
			 	pushad
				mov ebx, 192
				mov ebp, 8
				invoke ShowWindow, btn62, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn63
			 	pushad
				mov ebx, 192
				mov ebp, 12
				invoke ShowWindow, btn63, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif 
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn64
			 	pushad
				mov ebx, 192
				mov ebp, 16
				invoke ShowWindow, btn64, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn65
			 	pushad
				mov ebx, 192
				mov ebp, 20
				invoke ShowWindow, btn65, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn66
			 	pushad
				mov ebx, 192
				mov ebp, 24
				invoke ShowWindow, btn66, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn67
			 	pushad
				mov ebx, 192
				mov ebp, 28
				invoke ShowWindow, btn67, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			;octava fila--------------------------------------------------------
			.elseif ax == Btn70
			 	pushad
				mov ebx, 224
				mov ebp, 0
				invoke ShowWindow, btn70, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn71
			 	pushad
				mov ebx, 224
				mov ebp, 4            
				invoke ShowWindow, btn71, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn72
			 	pushad
				mov ebx, 224
				mov ebp, 8
				invoke ShowWindow, btn72, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn73
			 	pushad
				mov ebx, 224
				mov ebp, 12
				invoke ShowWindow, btn73, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA	
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn74
			 	pushad
				mov ebx, 224
				mov ebp, 16
				invoke ShowWindow, btn74, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA	
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn75
			 	pushad
				mov ebx, 224
				mov ebp, 20
				invoke ShowWindow, btn75, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn76
			 	pushad
				mov ebx, 224
				mov ebp, 24
				invoke ShowWindow, btn76, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA
					jmp ocultarbotones	
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.elseif ax == Btn77
			 	pushad
				mov ebx, 224
				mov ebp, 28
				invoke ShowWindow, btn77, 0
				.if Tablero[ebx][ebp] < 0
					invoke MessageBox, NULL, ADDR LossMsg, ADDR AppName, MB_OK
					mov EstadoJuego, ESPERA	
					jmp ocultarbotones
				.endif
				dec contadorNiv
				jmp finjuego
				popad
			.endif
		.endif
		
		
	.elseif uMsg == WM_PAINT
		invoke BeginPaint,hWnd,addr ps
      	mov hdc,eax
      	invoke CreateCompatibleDC,hdc
      	mov hMemDC,eax
      	;invoke GetClientRect,hWnd, ADDR rect
      	
		pintartablero:
		;.if EstadoJuego != ESPERA
			mov ebx, 0
			mov esi, 0
	 		mov i, 0
	 		mov j, 0
		  	mov x, 50
		  	mov y, 50
		  	.while i < 8
				.while j < 8				
	 				.if Tablero[ebx][esi] >= 0
		 				invoke crt_sprintf, ADDR Msg, ADDR intfmt, Tablero[ebx][esi]
						invoke TextOut, hdc, x, y, ADDR Msg, SIZEOF Msg  
					.else 
					    invoke TextOut, hdc, x, y, ADDR bomba, SIZEOF bomba		    
					.endif
	 				add esi, 4
	 				inc j
	 				add x, 50 			
	 			.endw
	 			mov j, 0
	 			mov esi, 0
	 			add ebx, 32
	 			mov x, 50
	 			add y, 50
	 			inc i
		  	.endw
		  	
		;.endif
		
		invoke DeleteDC,hMemDC
		invoke EndPaint,hWnd,addr ps
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam		
		ret
	.ENDIF
	
	xor eax,eax
	ret
WndProc endp

AsignarBombas proc
pushad
case01: cmp EstadoJuego, NIVEL1
		je nivel1
		cmp EstadoJuego, NIVEL2
		je nivel2
		cmp EstadoJuego, NIVEL3
		je nivel3
		cmp EstadoJuego, NIVEL4
		je nivel4
nivel1: mov numMinas, 4
		jmp endswitch01
nivel2: mov numMinas, 7
		jmp endswitch01
nivel3: mov numMinas, 10
		jmp endswitch01
nivel4: mov numMinas, 15
		jmp endswitch01
endswitch01:
popad
ret
AsignarBombas endp

GenerarBombas proc
pushad
call AsignarBombas
mov ebx, 0
mov ebp, 0
mov i, 0
mov j, 0
.while i<8
	.while j<8
		mov Tablero[ebx][ebp], 0
		add ebp, 4
		inc j
	.endw
	 mov j, 0
	 inc i
	 mov ebp, 0
	 add ebx, 32
.endw
.while numMinas > 0
	invoke GetTickCount
	invoke nseed, eax	
	invoke nrandom, 8
	imul treintaydosA
	mov ebx,eax
		
	invoke GetTickCount
	imul dosA
	invoke nseed, eax	
	invoke nrandom, 8
	imul cuatroA
	mov ebp,eax	  
	
	.if Tablero[ebx][ebp] >= 0	
		sub Tablero[ebx][ebp],1
		dec numMinas
	.endif
.endw
popad
ret
GenerarBombas endp

GenerarAdyacencias proc
pushad

mov ebx, 0
mov ebp, 0
mov i, 0
mov j, 0

.while i < 8
	.while j < 8
		.if Tablero[ebx][ebp] < 0
			.if ebp != 0
				.if Tablero[ebx-32][ebp-4] >= 0
					add	Tablero[ebx-32][ebp-4], 1
				.endif
				
				.if Tablero[ebx][ebp-4] >= 0
					add	Tablero[ebx][ebp-4], 1
				.endif
			
				.if Tablero[ebx+32][ebp-4] >= 0
					add	Tablero[ebx+32][ebp-4], 1
				.endif
			.endif
			
			.if	ebp != 28
				.if Tablero[ebx-32][ebp+4] >= 0
					add	Tablero[ebx-32][ebp+4], 1
				.endif
			 	
			 	.if Tablero[ebx][ebp+4] >= 0 
					add	Tablero[ebx][ebp+4], 1
				.endif
				.if Tablero[ebx+32][ebp+4] >= 0
					add	Tablero[ebx+32][ebp+4], 1
				.endif
			.endif
			
			.if Tablero[ebx-32][ebp] >= 0
				add	Tablero[ebx-32][ebp], 1
			.endif
		
			.if Tablero[ebx+32][ebp] >= 0
				add	Tablero[ebx+32][ebp], 1
			.endif
			
		.endif
		add ebp, 4
		inc j
	.endw
	mov j, 0
	inc i
	mov ebp, 0
	add ebx, 32
.endw

popad
ret
GenerarAdyacencias endp

end start
