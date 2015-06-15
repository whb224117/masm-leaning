;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Sample code for < Win32ASM Programming 2nd Edition>
; by 罗云彬, http://asm.yeah.net
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Receive.asm
; 从一个程序向另一个窗口程序发送消息 之 消息接收程序
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 使用 nmake 或下列命令进行编译和链接:
; ml /c /coff Receive.asm
; Link /subsystem:windows Receive.obj



;在Win32中，WM_COPYDATA消息主要目的是允许在进程间传递只读数据。
;SDK文档推荐用户使用SendMessage()函数，接收方在数据复制完成前不返回，这样发送方就不可能删除和修改数据

;SendMessage(HWND,WM_COPYDATA,wParam,lParam)

;其中wParam设置为包含数据的窗口句柄，lParam指向一个COPYDATASTRUCT的结构，其定义为：

;typedef struct tagCOPYDATASTRUCT{
;DWORD dwData;
;DWORD cbData;
;PVOID lpData;
;}COPYDATASTRUCT;

;其中dwData为自定义数据， cbData为数据大小， lpData为指向数据的指针。
;需要注意的是，WM_COPYDATA消息保证发送的数据从原进程复制到目标进程。
;但是，WM_COPYDATA消息不能发送HDC、HBITMAP之类的东西，它们对于目标进程来说是无效的。
;目标进程得到这些数据不能在原进程作任何事情，因为它们属于不同的进程。
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
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?

hInstance	dd	?
hWinMain	dd	?
szBuffer	db	512 dup (?)

		.const
szClassName	db	'MyClass',0
szCaptionMain	db	'Receive Message',0

szReceive	db	'Receive WM_COPYDATA message',0dh,0ah
		db	'length: %08x',0dh,0ah
		db	'text address: %08x',0dh,0ah
		db	'text: "%s"',0dh,0ah,0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 窗口过程
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcWinMain	proc	uses ebx edi esi,hWnd,uMsg,wParam,lParam

		mov	eax,uMsg
;********************************************************************
		.if	eax ==	WM_CLOSE
			invoke	DestroyWindow,hWinMain
			invoke	PostQuitMessage,NULL
;********************************************************************
; 收到 WM_COPYDATA 消息将消息附带的数据长度和字符串数据显示出来
;********************************************************************
		.elseif	eax ==	WM_COPYDATA
			mov	eax,lParam
			assume	eax:ptr COPYDATASTRUCT
			invoke	wsprintf,addr szBuffer,addr szReceive,\
				[eax].cbData,[eax].lpData,[eax].lpData
			invoke	MessageBox,hWnd,offset szBuffer,addr szCaptionMain,MB_OK
			assume	eax:nothing
			
;			经常用来将寄存器当作结构体指针来用
;			ASSUME edx:ptr STRUCT   ;将edx 定义为STRUCT指针变量
;			把STRUCT结构体的起始地址给edx
;			lea edx, STRUCT
;			这个时候可以用 [edx].调用STRUCT的字段
;			ASSUME edx:nothing   ;取消定义 这个时候edx 不是指针
;			[edx].不能调用字段了
;
;			如果是8086的那么将段REG ASSUME DS:(某个数据段)
;			这样程序在使用这个数据段会用DS做段
;			Code段是不能指定段REG的 必须是CS:IP(EA)
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

		invoke	GetModuleHandle,NULL
		mov	hInstance,eax
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
		invoke	RegisterClassEx,addr @stWndClass
;********************************************************************
; 建立并显示窗口
;********************************************************************
		invoke	CreateWindowEx,WS_EX_CLIENTEDGE or WS_EX_TOPMOST,offset szClassName,offset szCaptionMain,\
			WS_OVERLAPPEDWINDOW,\
			50,50,200,150,\
			NULL,NULL,hInstance,NULL
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
