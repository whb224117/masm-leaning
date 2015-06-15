;--------------------------------------------------------------------------------
;程序名：notepad
;功能：一个很简单的RichEdit记事本程序。可以显示行号
;
;使用环境：2000/xp
;开发环境：win2000 ＋ RadASM 2.2.0 汉化版 ＋ MASM32V8
;
;作者：jhkdiy
;Blog: http://blog.csdn.net/jhkdiy
;E-mail：jhkdiy_gzb@21cn.net
;日期：2005/5/24
;版本：1.0
;最后修改日期：2005/5/25
;注意：	 你可以自由传播本代码，但请保留代码的完整性和作者信息，且本代码不可用于
;	 任何形式的商业活动，谢谢.
;说明：
;	 这里主要是为了做如何显示文本行号的实例。代码是在《Windows环境下32位汇编语言程序设计》
;	 中第九章的RichEdit例子为蓝本的，只是加上了显示行号。由于我当时是学习该例子，所以
;	 程序中的代码有很多没有作注释，代码中不明白的地方可以看书。但关于显示行号的
;	 函数我做了详细介绍。
;--------------------------------------------------------------------------------


.386
.model flat, stdcall
option casemap:none

include		windows.inc
include		user32.inc
include		kernel32.inc
include		comdlg32.inc
include		gdi32.inc

includelib	user32.lib
includelib	kernel32.lib
includelib	comdlg32.lib
includelib	gdi32.lib

include		MACROS.ASM	;masm自带的宏，很好用噢。
	
	;difine to equ 输出下列定义
	IDA_MAIN				equ	2000
	IDM_MAIN				equ	2000
	IDM_OPEN				equ	2101
	IDM_SAVE				equ	2102
	IDM_EXIT				equ	2103
	IDM_UNDO				equ	2201
	IDM_REDO				equ	2202
	IDM_SELALL			equ	2203
	IDM_COPY				equ	2204
	IDM_CUT				equ	2205
	IDM_PASTE			equ	2206
	IDM_FIND				equ	2207
	IDM_FINDPREV		equ	2208
	IDM_FINDNEXT		equ	2209
	IDM_ABOUT			equ	2210

.const
	FINDMSGSTRING		db	"commdlg_FindReplace", 0
	szClassName			db	"Wordpad", 0
	szCaptionMain		db	"notepad( Win32Asm ) , Created by jhkdiy", 0
	szDllEdit			db	"RichEd20.dll", 0
	szClassEdit			db	"RichEdit20A", 0
	szNotFound			db	"String not found!", 0
	szFilter				db	"Text Files(*.txt)", 0, "*.txt", 0, "All Files(*.*)", 0, "*.*", 0,0
	szDefaultExt		db	"txt", 0
	szErrOpenFile		db	"Can not open file !", 0
	szModify				db	"File have changed!, do you want to save now?", 0
	szFont				db	"宋体", 0
	szAbout				db	"作者：jhkdiy", 0dh, 0ah, 0dh, \
							"E-mail：jhkdiy_gzb@21cn.net", 0dh, 0ah, \
							"日期：2005/5/24", 0dh, 0ah, \
							"版本：1.0", 0dh, 0ah, \
							"最后修改日期：2005/5/25", 0

	
.data
	stFind		FINDREPLACE	<sizeof FINDREPLACE, 0, 0, FR_DOWN, szFindText, 0, sizeof szFindText, 0, 0, 0, 0>
	
	
.data?
	hInstance		dd	?
	hWinMain			dd	?
	hMenu				dd	?
	hWinEdit			dd	?	;RichEdit的窗口句柄
	lpEditProc		dd	?	;RichEdit的窗口地址
	hFile				dd	?
	hFindDialog		dd	?
	idFindMessage	dd	?
	szFileName		db	MAX_PATH  dup(?)
	szFindText		db	100  dup(?)
	
	
.code

	_ProcStream  proc  uses ebx esi edi _dwCookie, _lpBuffer, _dwBytes, _lpBytes
		
		;_dwCookie 指定的EDITSTREAM结构中定义的dwCookie 	一般用于存放文件打开句柄
		;_lpBuffer 指向一个缓冲区，对于流入操作，这里用来接收流入的文本，对于流出操作，这里存放要流出的文本
		;_dwBytes  本次调用可操作的字节数，对于流入操作，表示可以写入的缓冲区的最大字节数，对于流于操作，表示需要流出的文本和长度
		;_lpBytes  指向一个双字节,返回实际操作的字节数
		.if	_dwCookie
			invoke  ReadFile, hFile, _lpBuffer, _dwBytes, _lpBytes, 0
			
		.else
			invoke  WriteFile, hFile, _lpBuffer, _dwBytes, _lpBytes, 0		;写入文件
			
		.endif
		xor  eax, eax
		
		ret

	_ProcStream endp

	
	_SaveFile  proc  
		
		;保存文件
		
		LOCAL	@stES:EDITSTREAM
		
		mov	@stES.dwCookie, FALSE								;用户自定义值
		mov	@stES.dwError, NULL									;用来返回流操作过程的错误信息
		mov	@stES.pfnCallback, offset _ProcStream			;回调函数地址
		
		;流方式保存文本 RichEdit 专用   SF_TEXT 文本是TXT格式
		invoke  SendMessage, hWinEdit, EM_STREAMOUT, SF_TEXT, addr @stES
		
		;设置和清除一个编辑控制的修改标志  FALSE 表示未修改文字  表示设置修改标志为未修改
		invoke  SendMessage, hWinEdit, EM_SETMODIFY, FALSE, 0							
	
		ret

	_SaveFile endp
	
	_OpenFile  proc
		
		LOCAL	@stOF:OPENFILENAME
		LOCAL	@stES:EDITSTREAM
		
		invoke	RtlZeroMemory, addr @stOF, sizeof @stOF
		mov	@stOF.lStructSize, sizeof @stOF
		push	hWinMain
		pop	@stOF.hwndOwner
		mov	@stOF.lpstrFilter, offset szFilter
		mov	@stOF.lpstrFile, offset szFileName
		mov	@stOF.nMaxFile, MAX_PATH
		mov	@stOF.Flags, OFN_FILEMUSTEXIST OR OFN_PATHMUSTEXIST
		mov	@stOF.lpstrDefExt, offset szDefaultExt
		invoke  GetOpenFileName, addr @stOF
		.if 	eax
			
			invoke  CreateFile, addr szFileName, GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
			.if  eax == INVALID_HANDLE_VALUE
				invoke  MessageBox, hWinMain, addr szErrOpenFile, NULL, MB_OK or MB_ICONSTOP
				ret
			.endif
			push  eax
			.if  hFile					;关闭原来打开的文件
				invoke  CloseHandle, hFile
				
			.endif
			pop  eax
			mov  hFile, eax							;新文件的句柄保存
			mov  @stES.dwCookie, TRUE				;给回调函数所传的标记 TRUE为读取文件 FLASE为写入文件
			mov  @stES.dwError, NULL
			mov  @stES.pfnCallback, offset _ProcStream
			invoke  SendMessage, hWinEdit, EM_STREAMIN, SF_TEXT, addr @stES
			invoke  SendMessage, hWinEdit, EM_SETMODIFY, FALSE, 0
			
		.endif
		
		
		ret

	_OpenFile endp
	
	_CheckModify  proc	
							
		;检查文本框文本是否被修改
		
		LOCAL	@dwReturn
		
		mov	@dwReturn, TRUE
		invoke  SendMessage, hWinEdit, EM_GETMODIFY, 0, 0					;获取是否修改了文本框中的内容
		.if  eax && hFile
			invoke  MessageBox, hWinMain, addr szModify, addr szCaptionMain, MB_YESNOCANCEL or MB_ICONQUESTION
			.if  eax == IDYES
				call  _SaveFile
				
			.elseif  eax == IDCANCEL
				mov  @dwReturn, FALSE
				
			.endif
		.endif
		mov  eax, @dwReturn
		ret

	_CheckModify endp
	
	_FindText  proc							;查找文本
		
		LOCAL	@stFindText:FINDTEXTEX
		
		;获取编辑框控制中当前选择字符串的起始字符和终止字符的位置(大于64KB)
		invoke  SendMessage, hWinEdit, EM_EXGETSEL, 0, addr @stFindText.chrg
		.if  stFind.Flags & FR_DOWN
			push	@stFindText.chrg.cpMax
			pop	@stFindText.chrg.cpMin
		.endif
		mov	@stFindText.chrg.cpMax, -1
		mov	@stFindText.lpstrText, offset szFindText
		mov	ecx, stFind.Flags
		
		;FR_DOWN 向后查找 FR_MATCHCASE 区分大小写 FR_WHOLEWORD 匹配整个单词
		and	ecx, FR_MATCHCASE OR FR_DOWN OR FR_WHOLEWORD
		
		;在编辑控件中查找指定的字符串
		invoke  SendMessage, hWinEdit, EM_FINDTEXTEX, ecx, addr @stFindText
		.if  eax == -1							;没找到
			mov	ecx, hWinMain
			.if	hFindDialog
				mov	ecx, hFindDialog
			.endif
			invoke  MessageBox, ecx, addr szNotFound, NULL, MB_OK or MB_ICONINFORMATION
			ret
		.endif
		invoke  SendMessage, hWinEdit, EM_EXSETSEL, 0, addr @stFindText.chrgText
		
		;把插入字符滚动到编辑框控制的可见区域
		invoke  SendMessage, hWinEdit, EM_SCROLLCARET, NULL, NULL
		
		ret

	_FindText endp
	
	_LockMenu  proc  @hMenu:dword, MenuId:dword, bLock:byte
		
		;激活菜单和灰化菜单
		.if  bLock == TRUE
			invoke  EnableMenuItem, @hMenu, MenuId, MF_GRAYED
		.else
			invoke  EnableMenuItem, @hMenu, MenuId, MF_ENABLED
		.endif
		ret

	_LockMenu endp
	
	_SetStatus proc
		
		LOCAL  @stRange:CHARRANGE
		
		;获取编辑框控制中当前选择字符串的起始字符和终止字符的位置(大于64KB)。
		invoke  SendMessage, hWinEdit, EM_EXGETSEL, 0, addr @stRange
		mov  eax, @stRange.cpMin
		.if  eax == @stRange.cpMax
			invoke  _LockMenu, hMenu, IDM_COPY, TRUE
			invoke  _LockMenu, hMenu, IDM_CUT,  TRUE
		.else
			invoke  _LockMenu, hMenu, IDM_COPY, FALSE
			invoke  _LockMenu, hMenu, IDM_CUT,  FALSE
			
		.endif
		
		;查看剪切板能否粘贴
		invoke  SendMessage, hWinEdit, EM_CANPASTE, 0, 0
		.if  eax
			invoke  _LockMenu, hMenu, IDM_PASTE, FALSE
		.else
			invoke  _LockMenu, hMenu, IDM_PASTE, TRUE
		.endif
		
		;查看能否恢复上一次操作
		invoke  SendMessage, hWinEdit, EM_CANREDO, 0, 0
		.if  eax
			invoke  _LockMenu, hMenu, IDM_REDO, FALSE
		.else
			invoke  _LockMenu, hMenu, IDM_REDO, TRUE
		.endif
		
		;查看能否撤消
		invoke  SendMessage, hWinEdit, EM_CANUNDO, 0, 0
		.if  eax
			invoke  _LockMenu, hMenu, IDM_UNDO, FALSE
		.else
			invoke  _LockMenu, hMenu, IDM_UNDO, TRUE
		.endif  
		
		;获取编辑框文本长度
		invoke  GetWindowTextLength, hWinEdit
		.if  eax
			invoke  _LockMenu, hMenu, IDM_SELALL, FALSE
		.else
			invoke  _LockMenu, hMenu, IDM_SELALL, TRUE
		.endif
		
		;获取文件修改位标志
		invoke  SendMessage, hWinEdit, EM_GETMODIFY, 0, 0
		.if  eax && hFile
			invoke  _LockMenu, hMenu, IDM_SAVE, FALSE
		.else
			invoke  _LockMenu, hMenu, IDM_SAVE, TRUE
		.endif
		
		.if  szFindText					;存放输入查找文本的缓冲区 第一次查找时其为0 查找一次时其值会改变
			invoke  _LockMenu, hMenu, IDM_FINDNEXT, FALSE
			invoke  _LockMenu, hMenu, IDM_FINDPREV, FALSE
		.else
			invoke  _LockMenu, hMenu, IDM_FINDNEXT, TRUE
			invoke  _LockMenu, hMenu, IDM_FINDPREV, TRUE
		.endif
		
		
		
		ret

	_SetStatus endp
	
	_Init  proc
		
		LOCAL	@stCF:CHARFORMAT
		
		push	hWinMain
		pop	stFind.hwndOwner
		invoke  RegisterWindowMessage, addr FINDMSGSTRING				;注册公共查找框
		mov	idFindMessage, eax
		invoke  CreateWindowEx, WS_EX_CLIENTEDGE, offset szClassEdit, \
			NULL, WS_CHILD OR WS_VISIBLE OR WS_VSCROLL OR WS_HSCROLL OR ES_MULTILINE OR ES_NOHIDESEL, \
			0, 0, 0, 0, hWinMain, 0, hInstance, NULL
			
		mov	hWinEdit, eax
		
		;设置编辑框控件的工作模式  TM_PLAINTEXT 控件切换到不带格式模式
		invoke  SendMessage, hWinEdit, EM_SETTEXTMODE, TM_PLAINTEXT, 0
		invoke  RtlZeroMemory, addr @stCF, sizeof @stCF
		mov	@stCF.cbSize, sizeof @stCF
		mov	@stCF.yHeight, 11*20
		mov	@stCF.dwMask, CFM_FACE OR CFM_SIZE OR CFM_BOLD
		invoke  lstrcpy, addr @stCF.szFaceName, addr szFont
		
		;设置控件中一段选定的文本全部正文的格式   SCF_ALL 为全部文本
		invoke  SendMessage, hWinEdit, EM_SETCHARFORMAT, SCF_ALL, addr @stCF
		
		;设置Richedit控件中的最大文字长度	-1表示不限长度
		invoke  SendMessage, hWinEdit, EM_EXLIMITTEXT, 0, -1
		
		ret

	_Init endp
	
	_Quit  proc					
	;当程序退出时调用
		invoke  _CheckModify
		.if  eax
			invoke  DestroyWindow, hWinMain
			invoke  PostQuitMessage, NULL
			.if  hFile
				invoke  CloseHandle, hFile
			.endif
		.endif
		ret

	_Quit endp
		
		;--------------------------------------------------------------------------------
		_ShowLineNum  proc  hEdit:HWND
		;功能：显示文本的总行数
		;参数：	
		;	hEdit：要显示行号的文本框，普通的Edit控件没有测试过，这里只用RichEdit
		;
		;返回值：没有。
		;--------------------------------------------------------------------------------
		
		LOCAL	@stClientRect:RECT		;RichEdit的客户区大小
		LOCAL @hDcEdit						;RichEdit的Dc（设备环境）
		LOCAL @Char_Height				;字符的高度
		LOCAL @Line_Count					;文本的总行数	
		LOCAL @ClientHeight				;RichEdit的客户区高度
		LOCAL	@hdcBmp						;与RichEdit兼容的位图dc
		LOCAL	@hdcCpb						;与RichEdit兼容的Dc
		LOCAL	@CharFmt:CHARFORMAT		;RichEdit中的一个结构，用于获取字符的一系列信息，这里只用它来获取字符高度	
		LOCAL	@stBuf[10]:byte			;显示行号的缓冲区
		
		LOCAL	@szTest[64]:byte			;Only Test
		pushad
		
		;获取RichEdit的Dc
		invoke  GetDC, hEdit		
		mov	@hDcEdit, eax
		
		;获取RichEdit的客户区高度
		invoke  GetClientRect, hEdit, addr @stClientRect
		mov	ebx, @stClientRect.bottom
		sub	ebx, @stClientRect.top
		mov	@ClientHeight, ebx
		
		;创建与RichEdit兼容的Dc
		invoke  CreateCompatibleDC, @hDcEdit
		mov	@hdcCpb, eax
		
		;创建与RichEdit兼容的位图Dc，我们用来显示行号用的。
		invoke  CreateCompatibleBitmap, @hDcEdit, 40, @ClientHeight
		mov	@hdcBmp, eax
		
		;将位图dc选入兼容DC中
		invoke  SelectObject, @hdcCpb, @hdcBmp
		
		;创建一个实心画刷，用于下面的FillRect函数。
		invoke  CreateSolidBrush, 08080ffh
		
		;填充显示行号的dc的背景颜色。
		invoke  FillRect, @hdcCpb, addr @stClientRect, eax
		;设置背景色为无色 
		invoke  SetBkMode, @hdcCpb, TRANSPARENT			
		
		;获取当前RichEdit文本中的总行数
		invoke  SendMessage, hEdit, EM_GETLINECOUNT, 0, 0
		mov 	@Line_Count, eax 
		
		;获取字符信息
		invoke  RtlZeroMemory, addr @CharFmt, sizeof @CharFmt
		push	sizeof @CharFmt			;必须填充结构大小
		pop	@CharFmt.cbSize
		invoke  SendMessage, hEdit, EM_GETCHARFORMAT, TRUE, addr @CharFmt
		mov	eax, @CharFmt.yHeight	;获取字符高度，以英寸为单位，需转化为磅，只要除以20就行
		cdq									;把edx扩展为eax的高位								
		mov	bx, 20
		div	ebx							
		; 被除数: 默认放在 ax 或 dx 和 ax 中	 
		;al 存储除法操作的商, ah 存储除法操作的余数 或 ax 存储除法操作的商, dx 存储除法操作的余数.
		mov	@Char_Height, eax			;字符高度
		
		.data
			charFmt  byte  "%4u", 0
		.code
		invoke	RtlZeroMemory, addr @stBuf, sizeof @stBuf
		;设置显示行号的前景色
		invoke  SetTextColor, @hdcCpb, 0000000h
		mov	ebx, @Char_Height
		mov	@Char_Height, 1
		
		;获取文本框中第一个可见的行的行号，没有这个行号显示不会跟着文本的滚动而滚动。
		invoke  SendMessage, hEdit, EM_GETFIRSTVISIBLELINE, 0, 0
		mov	edi, eax
		inc	edi
		;在位图dc中循环输出行号
		.while	edi <= @Line_Count
			invoke  wsprintf, addr @stBuf, addr charFmt, edi
			invoke  TextOut, @hdcCpb, 1, @Char_Height, addr @stBuf, eax
			mov	edx, @Char_Height
			add	edx, ebx
			add	edx, 4		;这里加上行间距，并不精确。
			mov	@Char_Height, edx
			inc  	edi
			.break  .if  edx > @ClientHeight
		.endw
		;将已"画好"的位图真正"贴"到RichEdit中
		invoke BitBlt, @hDcEdit, 0, 0, 40, @ClientHeight, @hdcCpb, 0, 0, SRCCOPY 
		invoke DeleteDC, @hdcCpb
		invoke ReleaseDC, hEdit, @hDcEdit
		invoke DeleteObject, @hdcBmp
		
		popad
		
		ret

	_ShowLineNum endp
	
	;--------------------------------------------------------------------------------
	_SubProcEdit  proc  hWnd, uMsg, wParam, lParam
	;功能：截获RichEdit的WM_PAINT消息，用于当RichEdit刷新时显示行号。
	;参数：
	;	hWnd, uMsg, wParam, lParam 都为原有Windows发给RichEdit的消息和参数
	;返回值：没有
	;说明：当消息处理完毕后必须把消息回送给默认的RichEdit的窗口处理过程, 
	;      lpEditProc为RichEdit的旧窗口地址。
	;--------------------------------------------------------------------------------
		LOCAL	@stPS:PAINTSTRUCT
		
		.if	uMsg == WM_PAINT
			invoke  CallWindowProc, lpEditProc, hWnd, uMsg, wParam, lParam
			invoke  BeginPaint, hWinEdit, addr @stPS
			;下列函数真正实现显示行号。
			invoke  _ShowLineNum, hWinEdit
			
			invoke  EndPaint, hWinEdit, addr @stPS
			ret
		.endif
		
		invoke  CallWindowProc, lpEditProc, hWnd, uMsg, wParam, lParam
		ret

	_SubProcEdit endp

	
	_ProcWinMain  proc  uses ebx edi esi hWnd, uMsg, wParam, lParam
		
		LOCAL  @stRange:CHARRANGE
		LOCAL  @stRect:RECT
		
		mov	eax, uMsg
		.if  eax == WM_SIZE
			;当主窗口大小改变时改变文本框的大小
			invoke  GetClientRect, hWinMain, addr @stRect
			invoke  MoveWindow, hWinEdit, 0, 0, @stRect.right, @stRect.bottom, TRUE
			
		.elseif  eax == WM_COMMAND
			mov	eax, wParam
			movzx   eax, ax
			.if  eax == IDM_OPEN
				invoke  _CheckModify
				.if  eax
					call  _OpenFile
					
				.endif
			.elseif  eax == IDM_SAVE
				call  _SaveFile
				
			.elseif  eax == IDM_EXIT
				call  _Quit
				
			.elseif  eax == IDM_UNDO
				invoke  SendMessage, hWinEdit, EM_UNDO, 0, 0
				
			.elseif  eax == IDM_REDO
				invoke  SendMessage, hWinEdit, EM_REDO, 0, 0
				
			.elseif  eax == IDM_SELALL
				;全选							
				mov	@stRange.cpMin, 0
				mov	@stRange.cpMax, -1
				invoke  SendMessage, hWinEdit, EM_EXSETSEL, 0, addr @stRange	;指定选择区域的开始和结束位置
				
			.elseif  eax == IDM_COPY
				;复制
				invoke  SendMessage, hWinEdit, WM_COPY, 0, 0
				
			.elseif  eax == IDM_CUT
				;剪切
				invoke  SendMessage, hWinEdit, WM_CUT, 0, 0
				
			.elseif  eax == IDM_PASTE
				;粘贴
				invoke  SendMessage, hWinEdit, WM_PASTE, 0, 0
				
			.elseif  eax == IDM_FIND
				;查找  公共对话框
				and	stFind.Flags, not FR_DIALOGTERM
				invoke  FindText, addr stFind
				.if  eax
					mov  hFindDialog, eax
				.endif
				
			.elseif  eax == IDM_FINDPREV
				and	stFind.Flags, not FR_DOWN
				invoke  _FindText
				
			.elseif  eax == IDM_FINDNEXT
				or  stFind.Flags, FR_DOWN
				invoke  _FindText
				
			.elseif	 eax == IDM_ABOUT
				invoke  MessageBox, hWnd, addr szAbout, addr szCaptionMain, MB_OK or MB_ICONINFORMATION
				
			.endif
			
		.elseif  eax == WM_INITMENU
			call  _SetStatus
			
		.elseif  eax == idFindMessage										;查找对话框发来的消息
			.if  stFind.Flags & FR_DIALOGTERM
				mov  hFindDialog, 0
				
			.else
				invoke  _FindText
			.endif
			
		.elseif  eax == WM_ACTIVATE										;通过鼠标以外的工具（如键盘）激活了该窗口
			mov	eax, wParam
			.if  (ax == WA_CLICKACTIVE) || (ax == WA_ACTIVE)		;括号
				invoke  SetFocus, hWinEdit
			.endif
			
		.elseif  eax == WM_CREATE
			push  hWnd
			pop   hWinMain
			invoke  _Init
			;设置RichEdit的文本编辑区域，这里留空一些用于显示行号。
			invoke  SendMessage, hWinEdit, EM_SETMARGINS, EC_RIGHTMARGIN or EC_LEFTMARGIN, 00050005h+40
			;利用窗口子类技术，这里自己处理WM_PAINT消息。
			invoke  SetWindowLong, hWinEdit, GWL_WNDPROC, addr _SubProcEdit
			mov	lpEditProc, eax		;保存原来的RichEdit的窗口地址。
			
			
		.elseif  eax == WM_CLOSE
			call  _Quit
			
		.else
			invoke  DefWindowProc, hWnd, uMsg, wParam, lParam
			ret
			
		.endif
		xor  eax, eax
		
		ret

	_ProcWinMain endp
	
	
	
	_WinMain  proc
		
		LOCAL	@stWndClass:WNDCLASSEX
		LOCAL	@stMsg:MSG
		LOCAL @hAccelerator, @hRichEdit
		
		invoke  LoadLibrary, offset szDllEdit
		mov	@hRichEdit, eax
		invoke  GetModuleHandle, NULL								;获取实例句柄
		mov	hInstance, eax
		invoke  LoadMenu, hInstance, IDM_MAIN					;加载菜单资源
		mov	hMenu, eax
		invoke  LoadAccelerators, hInstance, IDA_MAIN		;加载加速键资源
		mov	@hAccelerator, eax
		
		invoke  RtlZeroMemory, addr @stWndClass, sizeof @stWndClass
		invoke  LoadCursor, hInstance, IDC_ARROW				;加载光标
		mov	@stWndClass.hCursor, eax
		invoke  LoadIcon, hInstance, 10							;加载图标
		mov	@stWndClass.hIcon, eax
		mov	@stWndClass.hIconSm, eax
		push 	hInstance
		pop	@stWndClass.hInstance
		mov	@stWndClass.cbSize, sizeof WNDCLASSEX
		mov 	@stWndClass.style, CS_HREDRAW OR CS_VREDRAW
		mov	@stWndClass.lpfnWndProc, offset _ProcWinMain
		mov	@stWndClass.hbrBackground, COLOR_BTNFACE + 1
		mov	@stWndClass.lpszClassName, offset szClassName
		
		invoke  RegisterClassEx, addr @stWndClass	;注册窗口类
		;创建主窗口
		invoke  CreateWindowEx, NULL, offset szClassName, offset szCaptionMain, WS_OVERLAPPEDWINDOW, 200, 150, 700, 500, NULL, hMenu, hInstance, NULL
		mov	hWinMain, eax
		invoke  ShowWindow, hWinMain, SW_SHOWNORMAL
		invoke  UpdateWindow, hWinMain
		;消息循环
		.while  TRUE
			invoke  GetMessage, addr @stMsg, NULL, 0, 0
			.break .if  eax == 0
			;先处理快捷键消息
			invoke  TranslateAccelerator, hWinMain, @hAccelerator, addr @stMsg		;翻译加速键表 直到窗口过程处理完消息后才返回。
			.if  eax == 0
				invoke  TranslateMessage, addr @stMsg
				invoke  DispatchMessage, addr @stMsg
			.endif
		.endw
		invoke  FreeLibrary, @hRichEdit
		
		ret

	_WinMain endp
	
start:
	;程序入口
	call  _WinMain
	invoke  ExitProcess, NULL

end  start
