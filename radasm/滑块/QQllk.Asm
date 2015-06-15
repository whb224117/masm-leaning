;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 对话框方式创建窗口的标准模版
; 制作时间:2010-11-24
; 如果把start标志放在程序头,必须定义 _ProcDlgMain 的原型
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.386
		.model flat, stdcall
		option casemap :none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		windows.inc
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib
include		gdi32.inc
includelib	gdi32.lib
;include		Comctl32.inc
;includelib	comctl32.lib
include		Strings.mac
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equ 等值定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DLG_MAIN		equ	1
ICO_MAIN		equ	1000
EDT_TIME 	equ	1002
TRB_TIME		equ	1004
BTN_START	equ	1005
BTN_STOP		equ	1006

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?

hInstance	dd	?
hIcon			dd	?
hEidt			dd	?
hTbr			dd	?
hStart		dd	?
hStop			dd ?
		.const

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

_ProcDlgMain	proc	uses ebx edi esi hWnd,wMsg,wParam,lParam
		mov	eax,wMsg
;----------------------------------------------------
; 默认初始化消息
;----------------------------------------------------
		.if	eax == WM_INITDIALOG
			invoke	LoadIcon,hInstance,ICO_MAIN
			mov	hIcon,eax
			invoke	SendMessage,hWnd,WM_SETICON,ICON_BIG,hIcon
			invoke	GetDlgItem,hWnd,EDT_TIME
			mov	hEidt,eax
			invoke	GetDlgItem,hWnd,TRB_TIME
			mov	hTbr,eax
			invoke	GetDlgItem,hWnd,BTN_START
			mov	hStart,eax
			invoke	GetDlgItem,hWnd,BTN_STOP
			mov	hStop,eax
			invoke	SendMessage,hTbr,TBM_SETRANGEMAX,0,9999
			invoke	SendMessage,hTbr,TBM_SETRANGEMIN,0,1
			invoke	SendMessage,hTbr,TBM_SETPAGESIZE,0,100
			invoke	SendMessage,hTbr,TBM_SETPOS,1,2000
			invoke	SetWindowText,hEidt,$CTA0("2000")
;----------------------------------------------------
; 程序关闭时的退出消息
;----------------------------------------------------
		.elseif	eax == WM_CLOSE
			invoke	EndDialog,hWnd,NULL
;----------------------------------------------------
; 各种菜单控件的消息
;----------------------------------------------------
		.elseif	eax == WM_COMMAND
;----------------------------------------------------

;----------------------------------------------------
		.elseif	eax == WM_HSCROLL
			mov	eax,lParam
			.if	eax == hTbr
				invoke	SendMessage,hTbr,TBM_GETPOS,0,0
				invoke	SetDlgItemInt,hWnd,EDT_TIME,eax,0
				
			.endif
;----------------------------------------------------
		.else
			mov	eax,FALSE
			ret
		.endif
		mov	eax,TRUE
		ret

_ProcDlgMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
		invoke	GetModuleHandle,NULL
		mov	hInstance,eax
		;invoke	InitCommonControls
		invoke	DialogBoxParam,hInstance,DLG_MAIN,NULL,offset _ProcDlgMain,NULL
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start
