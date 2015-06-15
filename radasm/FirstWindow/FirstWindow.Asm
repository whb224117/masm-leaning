;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 标准窗口程序的模板代码
; 制作时间: 2010-11-23
; 代码采用两种风格,注释掉的是常见标准风格,默认使用简单版
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.386
		.model flat,stdcall
		option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		windows.inc
include		gdi32.inc
includelib	gdi32.lib
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib
include     FirstWindow.inc

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 函数原型定义,在标准风格中使用
;_WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?
hInstance		dd		?
hWinMain		dd		?
CommandLine 	dd		?    ;简单风格中可以去掉这个变量
hMenu dd ?
hSubMenu dd ?
hNewPopuMenu dd ?
hIcon dd ?
		.const
format db 'ID:%d',0
szClassName	db	'MyClass',0
szCaptionMain	db	'窗口名称',0
szRight db '右键单击',0
szLeft db '左键单击',0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 窗口过程
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcWinMain	proc	uses ebx edi esi hWnd,uMsg,wParam,lParam

		LOCAL @point:POINT
		LOCAL @temp [20]:byte
		mov	eax,uMsg
;********************************************************************
		.if	eax ==	WM_CREATE
					;窗口创建时初始化的内容
			 invoke LoadIcon,hInstance,APP_ICON
			 mov hIcon,eax
			 invoke SendMessage,hWnd,WM_COMMAND,ICON_BIG,NULL
			 ;invoke RemoveMenu,hMenu,1,MF_BYPOSITION		;移除菜单项但内存还在
			 ;invoke DeleteMenu,hMenu,1,MF_BYPOSITION		;移除菜单项内存销毁
			 invoke CreatePopupMenu
			 mov hNewPopuMenu,eax
			 invoke GetSubMenu,hMenu,1							;GetSubMenu 获取的是Menu的下一级菜单 
			 ;下一级菜单资源的句柄  因为TrackPopupMenu只弹出其子菜单
			 mov hSubMenu,eax
;********************************************************************
		.elseif eax  ==   WM_COMMAND
			invoke wsprintf,addr @temp,offset format,wParam
			invoke MessageBox,hWnd,addr @temp,offset szClassName,MB_OK
			mov eax,wParam
			movzx eax,ax     ;将缺少的位补零  wParam的的高16位为通知码 0则表示是鼠标点击控件产生消息 1表示是快捷键产生消息 后十六位为控件ID
			.if eax >= IDM_SELECT1 && eax <= IDM_SELECT2				;单选按钮
				invoke CheckMenuRadioItem,hMenu,IDM_SELECT1,IDM_SELECT2,eax,MF_BYCOMMAND
				;校核一个指定的菜单项并使其成为一个圆按钮项。同时不校核相关组里的其他菜单项并清除这些项的国按钮的类型标志
			.elseif eax >=IDM_CHECK1 && eax <= IDM_CHECK3
				mov ebx,eax
				invoke GetMenuState,hMenu,eax,MF_BYCOMMAND		;取得与指定菜单项相联系的菜单标志
			 	.if eax == MF_CHECKED
						mov eax,MF_UNCHECKED
				.elseif 
						mov eax,MF_CHECKED
			 	.endif
			 	invoke CheckMenuItem,hMenu,ebx,eax					;设置菜单
			.endif
			.if eax == APP_ICON
				invoke SendMessage,hWnd,WM_SETICON,ICON_BIG,hIcon
			.endif
;********************************************************************
		.elseif	eax ==	WM_DESTROY
			invoke	DestroyWindow,hWinMain
;********************************************************************
		.elseif	eax ==	WM_CLOSE
			invoke	PostQuitMessage,NULL
;********************************************************************
		.elseif	eax ==	WM_RBUTTONDOWN
			invoke GetCursorPos,addr @point
			invoke   TrackPopupMenu,hSubMenu,TPM_LEFTALIGN,@point.x,@point.y,0,hWnd,0
			;invoke	MessageBox,hWnd,offset szRight,offset szClassName,MB_OK
;********************************************************************
		.elseif	eax ==	WM_LBUTTONDOWN
			;invoke	MessageBox,hWnd,offset szLeft,offset szClassName,MB_OK
;********************************************************************
		.else
			invoke	DefWindowProc,hWnd,uMsg,wParam,lParam
			ret
		.endif
;********************************************************************
		xor	eax,eax
		ret

_ProcWinMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 默认的标准风格
;_WinMain	proc	hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WinMain	proc	
		local	@stWndClass:WNDCLASSEX
		local	@stMsg:MSG

		invoke	RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
;********************************************************************
; 注册窗口类
;********************************************************************
		invoke	LoadCursor,0,IDC_ARROW
		mov	@stWndClass.hCursor,eax
		push	hInstance
		pop	@stWndClass.hInstance
		mov	@stWndClass.cbSize,sizeof WNDCLASSEX
		mov	@stWndClass.style,CS_HREDRAW or CS_VREDRAW
		mov	@stWndClass.lpfnWndProc,offset _ProcWinMain
		mov	@stWndClass.hbrBackground,COLOR_WINDOW + 1
		mov	@stWndClass.lpszClassName,offset szClassName
		invoke LoadCursor,NULL,IDC_CROSS
		mov @stWndClass.hCursor,eax
		invoke LoadIcon,NULL,APP_ICON
		mov  @stWndClass.hIcon,eax
		invoke	RegisterClassEx,addr @stWndClass
		invoke LoadMenu,hInstance,IDR_MENU
		mov hMenu,eax
;********************************************************************
; 建立并显示窗口
;********************************************************************
		invoke	CreateWindowEx,WS_EX_CLIENTEDGE,offset szClassName,offset szCaptionMain,\
			WS_OVERLAPPEDWINDOW,\
			100,100,600,400,\
			NULL,hMenu,hInstance,NULL
		mov	hWinMain,eax
		invoke	ShowWindow,hWinMain,SW_SHOWNORMAL
		invoke	UpdateWindow,hWinMain
;********************************************************************
; 消息循环
;********************************************************************
		.while	TRUE
			invoke	GetMessage,addr @stMsg,NULL,0,0
			.break	.if eax	== 0
			invoke	TranslateMessage,addr @stMsg
			invoke	DispatchMessage,addr @stMsg
		.endw
		ret
		
_WinMain	endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		invoke	GetModuleHandle,NULL
		mov	hInstance,eax	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		call	_WinMain
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end	start
