;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Sample code for < Win32ASM Programming 2nd Edition>
; by 罗云彬, http://asm.yeah.net
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; SendMessage.asm
; 从一个程序向另一个窗口程序发送消息 之 发送程序
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 使用 nmake 或下列命令进行编译和链接:
; ml /c /coff SendMessage.asm
; Link /subsystem:windows SendMessage.obj



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
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data
hWnd		dd	?
szBuffer	db	512 dup (?)
stCopyData	COPYDATASTRUCT <>

szCaption	db	'SendMessage',0
szStart		db	'Press OK to start SendMessage, text address: %08x!',0
szReturn	db	'SendMessage returned!',0
szDestClass	db	'MyClass',0	;目标窗口的窗口类
szText		db	'Text send to other windows',0
szNotFound	db	'Receive Message Window not found!',0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
start:
		invoke	FindWindow,addr szDestClass,NULL
		.if	eax
			mov	hWnd,eax	;找到目标窗口则发送消息
			invoke	wsprintf,addr szBuffer,addr szStart,addr szText
			invoke	MessageBox,NULL,offset szBuffer,offset szCaption,MB_OK
			mov	stCopyData.cbData,sizeof szText
			mov	stCopyData.lpData,offset szText
			invoke	SendMessage,hWnd,WM_COPYDATA,0,addr stCopyData
			invoke	MessageBox,NULL,offset szReturn,offset szCaption,MB_OK
		.else
			invoke	MessageBox,NULL,offset szNotFound,offset szCaption,MB_OK
		.endif
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start
