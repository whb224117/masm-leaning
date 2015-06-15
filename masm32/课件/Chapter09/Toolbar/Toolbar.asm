;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Sample code for < Win32ASM Programming 2nd Edition>
; by 罗云彬, http://asm.yeah.net
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Toolbar.asm
; 工具栏使用例子 —— 工具栏的创建、使用和定制工具栏
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 使用 nmake 或下列命令进行编译和链接:
; ml /c /coff Toolbar.asm
; rc Toolbar.rc
; Link /subsystem:windows Toolbar.obj Toolbar.res

;VC中消息的分类有三种，窗口消息，命令消息，和控件通知消息，
;WM_NOTIFY 即控件通知消息，是指一个窗口内的子控件发生了一些事情，需要通知父窗口，通知消息只适用于标准的
;窗口控件 如按钮，列表框，组合框等，以及windows公共控件，如树状视图，列表视图等，例如单击或双击一个控件
;在控件中选择部分文本，操作控件的滚动条都会产生通知消息，她类似于命令消息，当用户与控件窗口交互时，那么控件通知消息
;就会从控件窗口发送到它的主窗口，但是这种消息的存在并不是为了处理用户命令，而是为了能让主窗口改变控件，例如
;加载，显示数据，例如按下一个按钮，它向父窗口发送一个消息也可以看做一个控件通知消息
;单击鼠标所产生的消息可以有父窗口直接处理，也可交给控件窗口处理
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
include		Comctl32.inc
includelib	Comctl32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equ 等值定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ICO_MAIN	equ	1000
IDM_MAIN	equ	1000
IDM_NEW		equ	1101
IDM_OPEN	equ	1102
IDM_SAVE	equ	1103
IDM_PAGESETUP	equ	1104
IDM_PRINT	equ	1105
IDM_EXIT	equ	1106
IDM_CUT		equ	1201
IDM_COPY	equ	1202
IDM_PASTE	equ	1203
IDM_FIND	equ	1204
IDM_REPLACE	equ	1205
IDM_HELP	equ	1301

ID_TOOLBAR	equ	1
ID_EDIT		equ	2
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?

hInstance	dd	?
hWinMain	dd	?
hMenu		dd	?
hWinToolbar	dd	?
hWinEdit	dd	?

		.const
szClass		db	'EDIT',0
szClassName	db	'ToolbarExample',0
szCaptionMain	db	'工具栏示例',0
szCaption	db	'命令消息',0
szFormat	db	'收到 WM_COMMAND 消息，命令ID：%d',0
stToolbar	equ	this byte
TBBUTTON	<STD_FILENEW,IDM_NEW,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<STD_FILEOPEN,IDM_OPEN,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<STD_FILESAVE,IDM_SAVE,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<STD_PRINTPRE,IDM_PAGESETUP,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<STD_PRINT,IDM_PRINT,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<STD_COPY,IDM_COPY,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<STD_CUT,IDM_CUT,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<STD_PASTE,IDM_PASTE,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<STD_FIND,IDM_FIND,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<STD_REPLACE,IDM_REPLACE,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
TBBUTTON	<STD_HELP,IDM_HELP,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
TBBUTTON	<0,0,TBSTATE_ENABLED,TBSTYLE_SEP,0,0,-1>
NUM_BUTTONS	EQU	16
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Resize		proc
		local	@stRect:RECT,@stRect1:RECT

		invoke	SendMessage,hWinToolbar,TB_AUTOSIZE,0,0
		invoke	GetClientRect,hWinMain,addr @stRect
		invoke	GetWindowRect,hWinToolbar,addr @stRect1
		mov	eax,@stRect1.bottom
		sub	eax,@stRect1.top
		mov	ecx,@stRect.bottom
		sub	ecx,eax
		invoke	MoveWindow,hWinEdit,0,eax,@stRect.right,ecx,TRUE
		ret

_Resize		endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcWinMain	proc	uses ebx edi esi hWnd,uMsg,wParam,lParam
		local	@szBuffer[128]:byte

		mov	eax,uMsg
;********************************************************************
		.if	eax ==	WM_CLOSE
			invoke	PostMessage,hWnd,WM_COMMAND,IDM_EXIT,0
;********************************************************************
		.elseif	eax ==	WM_CREATE
			mov	eax,hWnd
			mov	hWinMain,eax
			invoke	CreateWindowEx,WS_EX_CLIENTEDGE,addr szClass,NULL,\
				WS_CHILD or WS_VISIBLE or ES_MULTILINE or ES_WANTRETURN or WS_VSCROLL or ES_AUTOHSCROLL,\
				0,0,0,0,hWnd,ID_EDIT,hInstance,NULL
			mov	hWinEdit,eax
			invoke	CreateToolbarEx,hWinMain,\
				WS_VISIBLE or WS_CHILD or TBSTYLE_FLAT or TBSTYLE_TOOLTIPS or CCS_ADJUSTABLE,\
				ID_TOOLBAR,0,HINST_COMMCTRL,IDB_STD_SMALL_COLOR,offset stToolbar,\
				NUM_BUTTONS,0,0,0,0,sizeof TBBUTTON
			mov	hWinToolbar,eax
			call	_Resize
;********************************************************************
		.elseif	eax ==	WM_COMMAND
			mov	eax,wParam
			.if	ax ==	IDM_EXIT
				invoke	DestroyWindow,hWinMain
				invoke	PostQuitMessage,NULL
			.elseif	ax !=	ID_EDIT
				invoke	wsprintf,addr @szBuffer,addr szFormat,wParam
				invoke	MessageBox,hWnd,addr @szBuffer,addr szCaption,MB_OK or MB_ICONINFORMATION
			.endif
;********************************************************************
		.elseif	eax ==	WM_SIZE
			call	_Resize
;********************************************************************
; 处理用户定制工具栏消息
;********************************************************************
		.elseif	eax ==	WM_NOTIFY
			mov	ebx,lParam
			.if	[ebx + NMHDR.code] == TTN_NEEDTEXT
				assume	ebx:ptr TOOLTIPTEXT
				mov	eax,[ebx].hdr.idFrom
				mov	[ebx].lpszText,eax
				push	hInstance
				pop	[ebx].hinst
				assume	ebx:nothing
			.elseif	([ebx + NMHDR.code] == TBN_QUERYINSERT) || \
				([ebx + NMHDR.code] == TBN_QUERYDELETE)
				mov	eax,TRUE
				ret
			.elseif	[ebx + NMHDR.code] == TBN_GETBUTTONINFO
				assume	ebx:ptr TBNOTIFY
				mov	eax,[ebx].iItem
				.if	eax < NUM_BUTTONS
					mov	ecx,sizeof TBBUTTON
					mul	ecx
					add	eax,offset stToolbar
					invoke	RtlMoveMemory,addr [ebx].tbButton,eax,sizeof TBBUTTON
					invoke	LoadString,hInstance,[ebx].tbButton.idCommand,addr @szBuffer,sizeof @szBuffer
					lea	eax,@szBuffer
					mov	[ebx].pszText,eax
					invoke	lstrlen,addr @szBuffer
					mov	[ebx].cchText,eax
					assume	ebx:nothing
					mov	eax,TRUE
					ret
				.endif
			.endif
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
_WinMain	proc
		local	@stWndClass:WNDCLASSEX
		local	@stMsg:MSG

		invoke	InitCommonControls
		invoke	GetModuleHandle,NULL
		mov	hInstance,eax
		invoke	LoadMenu,hInstance,IDM_MAIN
		mov	hMenu,eax
;********************************************************************
; 注册窗口类
;********************************************************************
		invoke	RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
		invoke	LoadIcon,hInstance,ICO_MAIN
		mov	@stWndClass.hIcon,eax
		mov	@stWndClass.hIconSm,eax
		invoke	LoadCursor,0,IDC_ARROW
		mov	@stWndClass.hCursor,eax
		push	hInstance
		pop	@stWndClass.hInstance
		mov	@stWndClass.cbSize,sizeof WNDCLASSEX
		mov	@stWndClass.style,CS_HREDRAW or CS_VREDRAW
		mov	@stWndClass.lpfnWndProc,offset _ProcWinMain
		mov	@stWndClass.hbrBackground,COLOR_BTNFACE+1
		mov	@stWndClass.lpszClassName,offset szClassName
		invoke	RegisterClassEx,addr @stWndClass
;********************************************************************
; 建立并显示窗口
;********************************************************************
		invoke	CreateWindowEx,NULL,\
			offset szClassName,offset szCaptionMain,\
			WS_OVERLAPPEDWINDOW,\
			CW_USEDEFAULT,CW_USEDEFAULT,700,500,\
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
		call	_WinMain
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start
