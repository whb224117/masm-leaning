;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Sample code for < Win32ASM Programming 2nd Edition>
; by 罗云彬, http://asm.yeah.net
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Send.asm
; 从一个程序向另一个窗口程序发送消息 之 发送程序
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 使用 nmake 或下列命令进行编译和链接:
; ml /c /coff Send.asm
; Link /subsystem:windows Send.obj



;WM_SETTEXT消息。此消息默认的lParam参数携带的是一个字符串指针，该字符串用于设置窗体文本信息
;当Windows处理SendMessage、PostMessage处理消息（例如WM_SETTEXT消息）的时候，它会检查消息的类型，读取lParam指针，
;将它指向的字符串  (拷贝)  到接收消息进程的缓冲区里头，并且修改lParam参数，以便在两个进程的地址空间中传递信息。

; 对于编辑框（Edit）来说，此消息字符串用于设置文本框内容；对于Combox控件来说，用于设置组合框的文本框部分内容
;对于按钮来说，就是按钮的名字，对于其它的窗体来说，是窗体的标题。

;用FindWindow查找到某个窗体，得到去句柄，然后用SendMessage发送此消息修改窗体的标题和控件的名字等。
;发现一般的窗体都可以被修改
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
szBuffer	db	256 dup (?)

		.const
szCaption	db	'SendMessage',0
szStart		db	'Press OK to start SendMessage, param: %08x!',0
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
			invoke	SendMessage,hWnd,WM_SETTEXT,0,addr szText
			invoke	MessageBox,NULL,offset szReturn,offset szCaption,MB_OK
		.else
			invoke	MessageBox,NULL,offset szNotFound,offset szCaption,MB_OK
		.endif
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start
