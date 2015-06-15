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
include		RADbg.inc


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equ 等值定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
MAIN	equ	1
EDT_TIME equ 1001


DTM		struct
  h	dd	?
  m	dd	?
  s	dd	?
DTM		ends

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?

hInstance	dd	?
Time	 SYSTEMTIME <>
Ehwd	dd ?
		.data
;定义dword

Tbuf	db 1024 dup(0)
Tfmt  db "%d时%d分%d秒",13,10,0
time	 DTM <>

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
;********************************************************************
		invoke SetTimer,hWnd,1,500,NULL  ;绑定ID为1的Timer到主窗口上;为了响应Timer事件
		invoke Sleep,250;延时造成闪烁效果
		invoke SetTimer,hWnd,2,1000,NULL  ;绑定ID为1的Timer到主窗口上;为了响应Timer事件
		invoke GetDlgItem,hWnd,EDT_TIME  ;获取
		mov Ehwd,eax
; 加入Timer响应消息处理
		.elseif eax==WM_TIMER
			mov eax,wParam
			.if eax==1;如果是1号定时器
				invoke GetLocalTime,offset Time;获取系统时间
				;转换Time的word类型到dword
				movzx eax,Time.wHour
				mov time.h,eax
				movzx eax,Time.wMinute
				mov time.m,eax
				movzx eax,Time.wSecond
				mov time.s,eax
				;格式化为字符串
				invoke wsprintf,offset Tbuf,offset Tfmt,time.h,time.m,time.s
				invoke SetDlgItemText,hWnd,EDT_TIME,offset Tbuf;写入时间
			.elseif eax==2;如果是2号定时器
				invoke SetDlgItemText,hWnd,EDT_TIME,0;清空文本
			.endif
; 程序关闭时的退出消息
;----------------------------------------------------
		.elseif	eax == WM_CLOSE
			invoke	EndDialog,hWnd,NULL
;********************************************************************
; 各种菜单控件的消息
;----------------------------------------------------
		.elseif	eax == WM_COMMAND
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
		invoke	DialogBoxParam,hInstance,MAIN,NULL,offset _ProcDlgMain,NULL
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start
