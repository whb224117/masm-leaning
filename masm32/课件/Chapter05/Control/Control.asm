;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Sample code for < Win32ASM Programming 2nd Edition>
; by 罗云彬, http://asm.yeah.net
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Control.asm
; 对话框资源中子窗口控件的使用方法
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 使用 nmake 或下列命令进行编译和链接:
; ml /c /coff Control.asm
; rc Control.rc
; Link /subsystem:windows Control.obj Control.res
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
ICO_MAIN	equ	1000h
DLG_MAIN	equ	1
IDB_1		equ	1
IDB_2		equ	2
IDC_ONTOP	equ	101
IDC_SHOWBMP	equ	102
IDC_ALOW	equ 	103
IDC_MODALFRAME	equ	104
IDC_THICKFRAME	equ	105
IDC_TITLETEXT	equ	106
IDC_CUSTOMTEXT	equ	107
IDC_BMP		equ	108
IDC_SCROLL	equ	109
IDC_VALUE	equ	110
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?

hInstance	dd	?
hBmp1		dd	?
hBmp2		dd	?
dwPos		dd	?

		.const
szText1		db	'Hello, World!',0
szText2		db	'嘿，你看到标题栏变了吗?',0
szText3		db	'自定义',0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcDlgMain	proc	uses ebx edi esi hWnd,wMsg,wParam,lParam
		local	@szBuffer[128]:byte

		mov	eax,wMsg
		.if	eax == WM_CLOSE
			invoke	EndDialog,hWnd,NULL
			invoke	DeleteObject,hBmp1
			invoke	DeleteObject,hBmp2
		.elseif	eax == WM_INITDIALOG
;********************************************************************
; 设置标题栏图标
;********************************************************************
			invoke	LoadIcon,hInstance,ICO_MAIN
			invoke	SendMessage,hWnd,WM_SETICON,ICON_BIG,eax
;********************************************************************
; 初始化组合框
;********************************************************************
			invoke	SendDlgItemMessage,hWnd,IDC_TITLETEXT,CB_ADDSTRING,0,addr szText1	;设置combobox的的值
			invoke	SendDlgItemMessage,hWnd,IDC_TITLETEXT,CB_ADDSTRING,0,addr szText2
			invoke	SendDlgItemMessage,hWnd,IDC_TITLETEXT,CB_ADDSTRING,0,addr szText3
			invoke	SendDlgItemMessage,hWnd,IDC_TITLETEXT,CB_SETCURSEL,0,0
			invoke	GetDlgItem,hWnd,IDC_CUSTOMTEXT		;文本框禁用
			invoke	EnableWindow,eax,FALSE

			invoke	LoadBitmap,hInstance,IDB_1
			mov	hBmp1,eax
			invoke	LoadBitmap,hInstance,IDB_2
			mov	hBmp2,eax
;********************************************************************
; 初始化单选钮和复选框
;********************************************************************
			invoke	CheckDlgButton,hWnd,IDC_SHOWBMP,BST_CHECKED		;改变按钮控制的选中状态 单选和复选都可以
			invoke	CheckDlgButton,hWnd,IDC_ALOW,BST_CHECKED
			invoke	CheckDlgButton,hWnd,IDC_THICKFRAME,BST_CHECKED
;********************************************************************
; 初始化滚动条
;********************************************************************
			invoke	SendDlgItemMessage,hWnd,IDC_SCROLL,SBM_SETRANGE,0,100	;设置滚动条的范围
		.elseif	eax == WM_COMMAND
			mov	eax,wParam					;因为没有热键 所以eax的高16位为0
			.if	ax ==	IDCANCEL
				invoke	EndDialog,hWnd,NULL
				invoke	DeleteObject,hBmp1	;删除一个逻辑笔、画笔、字体、位图、区域或者调色板，释放所有与该对象有关的系统资源，在对象被删除之后，指定的句柄也就失效了。
				invoke	DeleteObject,hBmp2
;********************************************************************
; 更换图片
;********************************************************************
			.elseif	ax ==	IDOK
				mov	eax,hBmp1
				xchg	eax,hBmp2		;XCHG Reg/Mem, Mem/Reg,Reg/Reg 交换两个操作数的数据
				mov	hBmp1,eax			;每执行一次 hBmp1和hBmp2中的数据就交换一次
				invoke	SendDlgItemMessage,hWnd,IDC_BMP,STM_SETIMAGE,IMAGE_BITMAP,eax	;设置图像句柄
;********************************************************************
; 设置是否“总在最前面”
;********************************************************************
			.elseif	ax ==	IDC_ONTOP
				invoke	IsDlgButtonChecked,hWnd,IDC_ONTOP		;确定某个按钮控制是否有选中标志
				.if	eax == BST_CHECKED
					invoke	SetWindowPos,hWnd,HWND_TOPMOST,0,0,0,0,\ ;改变子窗口、弹出窗口和顶层窗口的大小、位置和Z轴次序。
					SWP_NOMOVE or SWP_NOSIZE
				.else
					invoke	SetWindowPos,hWnd,HWND_NOTOPMOST,0,0,0,0,\
					SWP_NOMOVE or SWP_NOSIZE
				.endif
;********************************************************************
; 演示隐藏和显示图片控件
;********************************************************************
			.elseif	ax ==	IDC_SHOWBMP
				invoke	GetDlgItem,hWnd,IDC_BMP		
				mov	ebx,eax
				invoke	IsWindowVisible,ebx				;获得给定窗口的可视状态
				.if	eax
					invoke	ShowWindow,ebx,SW_HIDE		;隐藏
				.else
					invoke	ShowWindow,ebx,SW_SHOW		;显示
				.endif
;********************************************************************
; 演示允许和灰化“更换图片”按钮
;********************************************************************
			.elseif	ax ==	IDC_ALOW
				invoke	IsDlgButtonChecked,hWnd,IDC_ALOW
				.if	eax == BST_CHECKED
					mov	ebx,TRUE
				.else
					xor	ebx,ebx
				.endif
				invoke	GetDlgItem,hWnd,IDOK
				invoke	EnableWindow,eax,ebx
;********************************************************************
			.elseif	ax ==	IDC_MODALFRAME
				invoke	GetWindowLong,hWnd,GWL_STYLE
				and	eax,not WS_THICKFRAME						;WS_THICKFRAME 取反再和eax相与 刚好去掉WS_THICKFRAME样式		
				invoke	SetWindowLong,hWnd,GWL_STYLE,eax		;WS_THICKFRAME 创建一个可调边框窗口
			.elseif	ax ==	IDC_THICKFRAME
				invoke	GetWindowLong,hWnd,GWL_STYLE
				or	eax,WS_THICKFRAME
				invoke	SetWindowLong,hWnd,GWL_STYLE,eax
;********************************************************************
; 演示处理下拉式组合框
;********************************************************************
			.elseif	ax ==	IDC_TITLETEXT
				shr	eax,16
				.if	ax ==	CBN_SELENDOK		;CBN_SELENDOK 通知码表示用户完成选择项目
					invoke	SendDlgItemMessage,hWnd,IDC_TITLETEXT,CB_GETCURSEL,0,0  ;获取当前选中项
					.if	eax ==	2
						invoke	GetDlgItem,hWnd,IDC_CUSTOMTEXT	;如果是第三项就恢复文本框
						invoke	EnableWindow,eax,TRUE
					.else
						mov	ebx,eax
						invoke	SendDlgItemMessage,hWnd,IDC_TITLETEXT,CB_GETLBTEXT,ebx,addr @szBuffer	;获取下拉式组合框选择内容
						invoke	SetWindowText,hWnd,addr @szBuffer	;设置窗口名称
						invoke	GetDlgItem,hWnd,IDC_CUSTOMTEXT
						invoke	EnableWindow,eax,FALSE				;设置文本框不可写
					.endif
				.endif
;********************************************************************
; 在文本框中输入文字
;********************************************************************
			.elseif	ax ==	IDC_CUSTOMTEXT
				invoke	GetDlgItemText,hWnd,IDC_CUSTOMTEXT,addr @szBuffer,sizeof @szBuffer	;由题意可知每次按键都会发送消息 
				invoke	SetWindowText,hWnd,addr @szBuffer												;获取文本框内容并设置窗口标题
			.endif
;********************************************************************
; 处理滚动条消息
;********************************************************************
		.elseif	eax ==	WM_HSCROLL
			mov	eax,wParam
			.if	ax ==	SB_LINELEFT  ;左移一格
				dec	dwPos
			.elseif	ax ==	SB_LINERIGHT	;右移一格
				inc	dwPos
			.elseif	ax ==	SB_PAGELEFT		;左移一页
				sub	dwPos,10
			.elseif	ax ==	SB_PAGERIGHT	;右移一页
				add	dwPos,10
			.elseif	ax ==	SB_THUMBPOSITION || ax == SB_THUMBTRACK
				mov	eax,wParam
				shr	eax,16
				mov	dwPos,eax
			.else
				mov	eax,TRUE
				ret
			.endif
			cmp	dwPos,0
			jge	@F
			mov	dwPos,0
			@@:
			cmp	dwPos,100
			jle	@F
			mov	dwPos,100
			@@:
			invoke	SetDlgItemInt,hWnd,IDC_VALUE,dwPos,FALSE
			invoke	SendDlgItemMessage,hWnd,IDC_SCROLL,SBM_SETPOS,dwPos,TRUE	;设置
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

		

;函数功能：该函数把一个消息发送给指定的对话框中的控件。
;　　函数原型：LONG SendDlgItemMessage(
;　　HWND hDlg, // handle of dialog box
;　　int nIDDlgItem, // identifier of control
;　　UINT Msg, // message to send
;　　WPARAM wParam, // first message parameter
;　　LPARAM lParam // second message parameter
;　　);
;　　参数：
;　　hDlg:指定含有控件的对话框。
;　　nIDDigItem:指定接收消息的控件的标识符。
;　　Msg：指定将被发送的消息。
;　　wParam:指定消息特定的其他信息。
;　　lParam:指定消息特定的其他信息。
;　　返回值：返回值指定消息处理的结果，且依赖于发送的消息。



;函数功能：该函数改变按钮控制的选中状态。
;　　函数原型：BOOL CheckDlgButton（HWNDhDlg，int nlDButton,UINT uCheck）；
;　　参数：
;　　hDlg：指向含有该按钮的对话框的句柄。
;　　nlDButton：标识要修改的按钮。
;　　uCheck：给定该按钮的选中状态。该参数可取下列值，这些值的含义如下：
;　　BST_CHECKED：设置按钮状态为己选中（checked）。
;　　BST_INDETERMINATE：设置按钮状态变灰，表示不确定状态。只有在该按钮具有BS_3STATE或BS_AUTO3STATE样式时才能使用该值。
;　　BST_UNCHECKED：设置按钮为未选中状态（unchecked）。
;　　返回值：如果函数执行成功，返回值非零；如果函数失败，则返回值为零。



;BOOL SetWindowPos(const CWnd* pWndInsertAfter, int x, int y, int cx, int cy,UINT nFlags);
;改变子窗口、弹出窗口和顶层窗口的大小、位置和Z轴次序。