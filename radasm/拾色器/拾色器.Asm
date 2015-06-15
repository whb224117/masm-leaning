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
IDD_DLG1				equ	1000
IDI_APP_ICON		equ	1000
IDC_EDT_X			equ 	1004
IDC_EDT_Y			equ 	1005
IDC_IMG_SHOW		equ 	1001
IDC_IMG_COLOR		equ	1006
IDC_EDT_R			equ 	1010
IDC_EDT_G			equ 	1011
IDC_EDT_B			equ 	1012
DC_EXIT				equ	1013
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?

hInstance	dd	?
hIcon			dd ?
hHwnd			dd ?
pt 			POINT <>
dwDy			dd ?
dwDx			dd ?
hDcScreen	dd ?
hDcShowPic	dd ?
hDcShowCol	dd ?
rt				RECT<>
col			dd <> 
byColR		db ?
byColG		db ?
byColB		db ?
hHook			dd ?
strTmp		db 'yes',0
		.const

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
MouseProc		proc	uses ebx edx nCode,wParam,lParam
		
		mov eax,nCode		
		.if eax == HC_ACTION
			mov edx,wParam
			.if edx == WM_RBUTTONDOWN
				 ;invoke MessageBox,NULL,offset strTmp,NULL,0
				 invoke UnhookWindowsHookEx,hHook
				 invoke KillTimer,hHwnd,1
				ret
			.elseif edx == WM_LBUTTONDOWN
				 ;invoke MessageBox,NULL,offset strTmp,NULL,0
				 invoke UnhookWindowsHookEx,hHook
				 invoke KillTimer,hHwnd,1
				ret
			.elseif edx == WM_MOUSEMOVE
				 invoke CallNextHookEx,hHook,nCode,wParam,lParam
				ret
			.elseif edx == WM_MOUSEWHEEL
				 invoke CallNextHookEx,hHook,nCode,wParam,lParam
				ret
			.endif
		.endif
MouseProc		endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcDlgMain	proc	uses ebx edi esi hWnd,wMsg,wParam,lParam

		mov	eax,wMsg
;********************************************************************
; 默认初始化消息
;----------------------------------------------------
		.if	eax == WM_INITDIALOG
		
			mov eax,hWnd
			mov hHwnd,eax
			invoke LoadIcon,hInstance,IDI_APP_ICON
			mov	hIcon,eax
			invoke	SendMessage,hWnd,WM_SETICON,ICON_BIG,hIcon
			;动态的放在最前面
			invoke SetWindowPos,hWnd,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE
			
			;设置定时器
			invoke SetTimer,hWnd,1,100,NULL
			
			;设置全局HOOK
			invoke GetCurrentThreadId
			invoke SetWindowsHookEx,WH_MOUSE_LL,addr MouseProc,NULL,NULL
			mov hHook,eax
			
			;获取整个屏幕的DC
			invoke GetDC,NULL
			mov hDcScreen,eax
			
			;获取显示屏幕指定区域的窗口
			invoke GetDlgItem,hWnd,IDC_IMG_SHOW
			invoke GetDC,eax
			mov hDcShowPic,eax
			
			
			;获取幕指定区域的窗口的大小
			mov rt.left,0
			mov rt.top,0
			mov rt.right,150
			mov rt.bottom,20
;********************************************************************
; 定时器	设置x，y值
;----------------------------------------------------
		.elseif eax == WM_TIMER
			;GetCursorPos 是获取的屏幕坐标 相对于屏幕左上角
			;WM_MOUSEMOVE获取的是客户坐标 相对于客户端左上角
			invoke GetCursorPos,offset pt;
			;invoke wsprintf,offset strX,offset strFormat,pt.x;
			;invoke wsprintf,offset strY,offset strFormat,pt.y;
			invoke SetDlgItemInt,hWnd,IDC_EDT_X,pt.x,TRUE
			invoke SetDlgItemInt,hWnd,IDC_EDT_Y,pt.y,TRUE
			
			;向XY坐标靠前一点
			mov eax,pt.x
			sub eax,10
			mov dwDx,eax
			mov eax,pt.y
			sub eax,10
			mov dwDy,eax
			
			
			;将屏幕指定的区域绘制到指定的窗口DC中
			;bitblt 直接进行位块的拷贝。
			;StretchBlt 具有缩放功能，
			;TransparentBlt最后一个参数用来指定透明色，本函数也具有缩放功能。
			invoke StretchBlt,hDcShowPic,0,0,120,120,hDcScreen,dwDx,dwDy,20,20,SRCCOPY
			
			;画十字线
			invoke MoveToEx,hDcShowPic,0,60,NULL
			invoke LineTo,hDcShowPic,120,60
			invoke MoveToEx,hDcShowPic,60,0,NULL
			invoke LineTo,hDcShowPic,60,120
			
			;获取显示屏幕指定区域颜色的窗口的DC
			invoke GetDlgItem,hWnd,IDC_IMG_COLOR
			invoke GetDC,eax
			mov hDcShowCol,eax
			
			;获取鼠标所指点的颜色值
			invoke GetPixel,hDcScreen,pt.x,pt.y
			mov col,eax
			
			;鼠标颜色值显示到指定窗口上
			invoke  CreateSolidBrush, eax
			invoke FillRect,hDcShowCol,offset rt,eax
			
			mov eax,col
			mov byColR,al
			mov byColG,ah
			shr eax,16
			mov byColB,al
			invoke SetDlgItemInt,hWnd,IDC_EDT_R,byColR,TRUE
			invoke SetDlgItemInt,hWnd,IDC_EDT_G,byColG,TRUE
			invoke SetDlgItemInt,hWnd,IDC_EDT_B,byColB,TRUE
;********************************************************************
; 当鼠标右键单击时取消定时器
;----------------------------------------------------
		.elseif	eax == WM_RBUTTONDOWN
			invoke KillTimer,hWnd,1
;********************************************************************
; 程序关闭时的退出消息
;----------------------------------------------------
		.elseif	eax == WM_CLOSE
			invoke	EndDialog,hWnd,NULL
;********************************************************************
; 实现无标提栏的的窗口，通过拖拉边框可改变窗口大小
;----------------------------------------------------
		.elseif  eax == WM_LBUTTONDOWN
			mov eax,lParam
			invoke PostMessage,hWnd,WM_NCLBUTTONDOWN,HTCAPTION,eax
;********************************************************************
; 各种菜单控件的消息
;----------------------------------------------------
		.elseif	eax == WM_COMMAND
;********************************************************************
			mov eax,wParam
			.if eax == DC_EXIT
				invoke EndDialog,hWnd,0
			.endif
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
		invoke	DialogBoxParam,hInstance,IDD_DLG1,NULL,offset _ProcDlgMain,NULL
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end	start