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
include		Strings.mac
include		radbg.inc 
include		shell32.inc
includelib	shell32.lib
;**************************************
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equ 等值定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DLG_MAIN								equ	1
BTN_ADD 								equ	1001
IDC_EDT_SHOW_FILE					equ 	1003

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?

hInstance	dd	?
hWndTest		dd ?
dwBiHeight	dd	?
dwBiWidth	dd	?
dwCunt		dd	?
stRect		RECT	<>
hEdit			dd ?
szBuffer		 db MAX_PATH dup(?)
		.const

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
			;设置窗口属性可接受拖拽文件
			invoke DragAcceptFiles,hWnd,TRUE	
			
			;获取编辑框句柄
			invoke GetDlgItem,hWnd,IDC_EDT_SHOW_FILE
			mov hEdit,eax
;********************************************************************
; 程序关闭时的退出消息
;----------------------------------------------------
		.elseif	eax == WM_CLOSE
			invoke	EndDialog,hWnd,NULL
;********************************************************************
; 拖拽消息
;----------------------------------------------------
		.elseif	eax == WM_DROPFILES
			invoke DragQueryFile,wParam,-1,addr szBuffer,sizeof szBuffer
			mov ecx,eax ;取得拖拽的文件数量
			xor ebx,ebx
			NextFileName:
			push ecx
			push ebx
			invoke RtlZeroMemory,ADDR szBuffer,sizeof szBuffer
			invoke DragQueryFile,wParam,ebx,ADDR szBuffer,sizeof szBuffer
			invoke SendMessage,hEdit,LB_INSERTSTRING,ebx,addr szBuffer
;			*********************************************************************
			pop ebx
			inc ebx
			pop ecx
			loop NextFileName
;********************************************************************
; 各种菜单控件的消息
;----------------------------------------------------
		.elseif	eax == WM_COMMAND
			mov	ebx,wParam
			movzx	eax,bx
			shr	ebx,16
			.if eax == BTN_ADD
				invoke	FindWindow,NULL,$CTA0("负一楼游戏外挂演示程序")
				mov	hWndTest,eax
				invoke	GetWindowRect,hWndTest,addr stRect
				add	stRect.left,80
				add	stRect.top,80
				invoke	GetSystemMetrics,SM_CXSCREEN
				mov	dwBiWidth,eax
				invoke	GetSystemMetrics,SM_CYSCREEN
				mov	dwBiHeight,eax
				mov	dwCunt,65535
				fild	dwCunt
				fild	stRect.left
				fild	dwBiWidth
				fdivp	st(1),st
				fmulp	st(1),st
				fistp	dwBiWidth
				mov	dwCunt,65535
				fild	dwCunt
				fild	stRect.top
				fild	dwBiHeight
				fdivp	st(1),st
				fmulp	st(1),st
				fistp	dwBiHeight
;				invoke	mouse_event,MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_MOVE,dwBiWidth,dwBiHeight,0,0
;				invoke	mouse_event,MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN,0,0,0,0
;				invoke	mouse_event,MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP,0,0,0,0

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
		invoke	DialogBoxParam,hInstance,DLG_MAIN,NULL,offset _ProcDlgMain,NULL
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start
