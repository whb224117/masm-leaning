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
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equ 等值定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DLG_MAIN	equ	1
DLG_MY	equ 1000
TXT_MY	equ 1001
BTN_MY   equ 1002
IDC_EDT2 equ 1003

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?

hInstance	dd	?

		.const
		.data
MyString db ?
strTmp  db 30 dup(?)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcDlgMain	proc	uses ebx edi esi hWnd,wMsg,wParam,lParam

		mov	eax,wMsg
;********************************************************************
; 默认初始化消息
;----------------------------------------------------
		.if	eax == WM_INITDIALOG
;********************************************************************
; 程序关闭时的退出消息
;----------------------------------------------------
		.elseif	eax == WM_CLOSE
			invoke	EndDialog,hWnd,NULL
;********************************************************************
; 各种菜单控件的消息
;----------------------------------------------------
		.elseif	eax == WM_COMMAND;控件消息
			mov eax,wParam
			movzx eax,ax	;低16位取到控件ID
			.if eax==BTN_MY;如果响应消息的ID是我们的按钮则
				invoke GetDlgItemText,hWnd,TXT_MY,addr MyString,100;获取hWnd窗口（这里是我们的主窗口）的
				;ID为TXT_MY的控件的字符串到MyString，记得加入取地址符号addr哦，最多获取100个字符
				invoke MessageBox,NULL,addr MyString,addr MyString,0 ;弹出字串
			.elseif eax==IDC_EDT2
				invoke GetDlgItemText,hWnd,IDC_EDT2,offset strTmp,30
				invoke MessageBeep,0FFFFFFFFh
				;invoke MessageBox,hWnd,
				invoke SetWindowText,hWnd,offset strTmp
				invoke SetDlgItemText,hWnd,TXT_MY,offset strTmp
			.endif
;********************************************************************
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
		invoke	DialogBoxParam,hInstance,DLG_MY,NULL,offset _ProcDlgMain,NULL
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start
