;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ��׼���ڳ����ģ�����
; ����ʱ��: 2010-11-23
; ����������ַ��,ע�͵����ǳ�����׼���,Ĭ��ʹ�ü򵥰�
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.386
		.model flat,stdcall
		option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include �ļ�����
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
; ����ԭ�Ͷ���,�ڱ�׼�����ʹ��
;_WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ���ݶ�
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?
hInstance		dd		?
hWinMain		dd		?
CommandLine 	dd		?    ;�򵥷���п���ȥ���������
hMenu dd ?
hSubMenu dd ?
hNewPopuMenu dd ?
hIcon dd ?
		.const
format db 'ID:%d',0
szClassName	db	'MyClass',0
szCaptionMain	db	'��������',0
szRight db '�Ҽ�����',0
szLeft db '�������',0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; �����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ���ڹ���
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcWinMain	proc	uses ebx edi esi hWnd,uMsg,wParam,lParam

		LOCAL @point:POINT
		LOCAL @temp [20]:byte
		mov	eax,uMsg
;********************************************************************
		.if	eax ==	WM_CREATE
					;���ڴ���ʱ��ʼ��������
			 invoke LoadIcon,hInstance,APP_ICON
			 mov hIcon,eax
			 invoke SendMessage,hWnd,WM_COMMAND,ICON_BIG,NULL
			 ;invoke RemoveMenu,hMenu,1,MF_BYPOSITION		;�Ƴ��˵���ڴ滹��
			 ;invoke DeleteMenu,hMenu,1,MF_BYPOSITION		;�Ƴ��˵����ڴ�����
			 invoke CreatePopupMenu
			 mov hNewPopuMenu,eax
			 invoke GetSubMenu,hMenu,1							;GetSubMenu ��ȡ����Menu����һ���˵� 
			 ;��һ���˵���Դ�ľ��  ��ΪTrackPopupMenuֻ�������Ӳ˵�
			 mov hSubMenu,eax
;********************************************************************
		.elseif eax  ==   WM_COMMAND
			invoke wsprintf,addr @temp,offset format,wParam
			invoke MessageBox,hWnd,addr @temp,offset szClassName,MB_OK
			mov eax,wParam
			movzx eax,ax     ;��ȱ�ٵ�λ����  wParam�ĵĸ�16λΪ֪ͨ�� 0���ʾ��������ؼ�������Ϣ 1��ʾ�ǿ�ݼ�������Ϣ ��ʮ��λΪ�ؼ�ID
			.if eax >= IDM_SELECT1 && eax <= IDM_SELECT2				;��ѡ��ť
				invoke CheckMenuRadioItem,hMenu,IDM_SELECT1,IDM_SELECT2,eax,MF_BYCOMMAND
				;У��һ��ָ���Ĳ˵��ʹ���Ϊһ��Բ��ť�ͬʱ��У���������������˵�������Щ��Ĺ���ť�����ͱ�־
			.elseif eax >=IDM_CHECK1 && eax <= IDM_CHECK3
				mov ebx,eax
				invoke GetMenuState,hMenu,eax,MF_BYCOMMAND		;ȡ����ָ���˵�������ϵ�Ĳ˵���־
			 	.if eax == MF_CHECKED
						mov eax,MF_UNCHECKED
				.elseif 
						mov eax,MF_CHECKED
			 	.endif
			 	invoke CheckMenuItem,hMenu,ebx,eax					;���ò˵�
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
; Ĭ�ϵı�׼���
;_WinMain	proc	hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WinMain	proc	
		local	@stWndClass:WNDCLASSEX
		local	@stMsg:MSG

		invoke	RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
;********************************************************************
; ע�ᴰ����
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
; ��������ʾ����
;********************************************************************
		invoke	CreateWindowEx,WS_EX_CLIENTEDGE,offset szClassName,offset szCaptionMain,\
			WS_OVERLAPPEDWINDOW,\
			100,100,600,400,\
			NULL,hMenu,hInstance,NULL
		mov	hWinMain,eax
		invoke	ShowWindow,hWinMain,SW_SHOWNORMAL
		invoke	UpdateWindow,hWinMain
;********************************************************************
; ��Ϣѭ��
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