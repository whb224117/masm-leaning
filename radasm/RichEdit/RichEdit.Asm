;--------------------------------------------------------------------------------
;��������notepad
;���ܣ�һ���ܼ򵥵�RichEdit���±����򡣿�����ʾ�к�
;
;ʹ�û�����2000/xp
;����������win2000 �� RadASM 2.2.0 ������ �� MASM32V8
;
;���ߣ�jhkdiy
;Blog: http://blog.csdn.net/jhkdiy
;E-mail��jhkdiy_gzb@21cn.net
;���ڣ�2005/5/24
;�汾��1.0
;����޸����ڣ�2005/5/25
;ע�⣺	 ��������ɴ��������룬���뱣������������Ժ�������Ϣ���ұ����벻������
;	 �κ���ʽ����ҵ���лл.
;˵����
;	 ������Ҫ��Ϊ���������ʾ�ı��кŵ�ʵ�����������ڡ�Windows������32λ������Գ�����ơ�
;	 �еھ��µ�RichEdit����Ϊ�����ģ�ֻ�Ǽ�������ʾ�кš������ҵ�ʱ��ѧϰ�����ӣ�����
;	 �����еĴ����кܶ�û����ע�ͣ������в����׵ĵط����Կ��顣��������ʾ�кŵ�
;	 ������������ϸ���ܡ�
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

include		MACROS.ASM	;masm�Դ��ĺ꣬�ܺ����ޡ�
	
	;difine to equ ������ж���
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
	szFont				db	"����", 0
	szAbout				db	"���ߣ�jhkdiy", 0dh, 0ah, 0dh, \
							"E-mail��jhkdiy_gzb@21cn.net", 0dh, 0ah, \
							"���ڣ�2005/5/24", 0dh, 0ah, \
							"�汾��1.0", 0dh, 0ah, \
							"����޸����ڣ�2005/5/25", 0

	
.data
	stFind		FINDREPLACE	<sizeof FINDREPLACE, 0, 0, FR_DOWN, szFindText, 0, sizeof szFindText, 0, 0, 0, 0>
	
	
.data?
	hInstance		dd	?
	hWinMain			dd	?
	hMenu				dd	?
	hWinEdit			dd	?	;RichEdit�Ĵ��ھ��
	lpEditProc		dd	?	;RichEdit�Ĵ��ڵ�ַ
	hFile				dd	?
	hFindDialog		dd	?
	idFindMessage	dd	?
	szFileName		db	MAX_PATH  dup(?)
	szFindText		db	100  dup(?)
	
	
.code

	_ProcStream  proc  uses ebx esi edi _dwCookie, _lpBuffer, _dwBytes, _lpBytes
		
		;_dwCookie ָ����EDITSTREAM�ṹ�ж����dwCookie 	һ�����ڴ���ļ��򿪾��
		;_lpBuffer ָ��һ�����������������������������������������ı�����������������������Ҫ�������ı�
		;_dwBytes  ���ε��ÿɲ������ֽ��������������������ʾ����д��Ļ�����������ֽ������������ڲ�������ʾ��Ҫ�������ı��ͳ���
		;_lpBytes  ָ��һ��˫�ֽ�,����ʵ�ʲ������ֽ���
		.if	_dwCookie
			invoke  ReadFile, hFile, _lpBuffer, _dwBytes, _lpBytes, 0
			
		.else
			invoke  WriteFile, hFile, _lpBuffer, _dwBytes, _lpBytes, 0		;д���ļ�
			
		.endif
		xor  eax, eax
		
		ret

	_ProcStream endp

	
	_SaveFile  proc  
		
		;�����ļ�
		
		LOCAL	@stES:EDITSTREAM
		
		mov	@stES.dwCookie, FALSE								;�û��Զ���ֵ
		mov	@stES.dwError, NULL									;�����������������̵Ĵ�����Ϣ
		mov	@stES.pfnCallback, offset _ProcStream			;�ص�������ַ
		
		;����ʽ�����ı� RichEdit ר��   SF_TEXT �ı���TXT��ʽ
		invoke  SendMessage, hWinEdit, EM_STREAMOUT, SF_TEXT, addr @stES
		
		;���ú����һ���༭���Ƶ��޸ı�־  FALSE ��ʾδ�޸�����  ��ʾ�����޸ı�־Ϊδ�޸�
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
			.if  hFile					;�ر�ԭ���򿪵��ļ�
				invoke  CloseHandle, hFile
				
			.endif
			pop  eax
			mov  hFile, eax							;���ļ��ľ������
			mov  @stES.dwCookie, TRUE				;���ص����������ı�� TRUEΪ��ȡ�ļ� FLASEΪд���ļ�
			mov  @stES.dwError, NULL
			mov  @stES.pfnCallback, offset _ProcStream
			invoke  SendMessage, hWinEdit, EM_STREAMIN, SF_TEXT, addr @stES
			invoke  SendMessage, hWinEdit, EM_SETMODIFY, FALSE, 0
			
		.endif
		
		
		ret

	_OpenFile endp
	
	_CheckModify  proc	
							
		;����ı����ı��Ƿ��޸�
		
		LOCAL	@dwReturn
		
		mov	@dwReturn, TRUE
		invoke  SendMessage, hWinEdit, EM_GETMODIFY, 0, 0					;��ȡ�Ƿ��޸����ı����е�����
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
	
	_FindText  proc							;�����ı�
		
		LOCAL	@stFindText:FINDTEXTEX
		
		;��ȡ�༭������е�ǰѡ���ַ�������ʼ�ַ�����ֹ�ַ���λ��(����64KB)
		invoke  SendMessage, hWinEdit, EM_EXGETSEL, 0, addr @stFindText.chrg
		.if  stFind.Flags & FR_DOWN
			push	@stFindText.chrg.cpMax
			pop	@stFindText.chrg.cpMin
		.endif
		mov	@stFindText.chrg.cpMax, -1
		mov	@stFindText.lpstrText, offset szFindText
		mov	ecx, stFind.Flags
		
		;FR_DOWN ������ FR_MATCHCASE ���ִ�Сд FR_WHOLEWORD ƥ����������
		and	ecx, FR_MATCHCASE OR FR_DOWN OR FR_WHOLEWORD
		
		;�ڱ༭�ؼ��в���ָ�����ַ���
		invoke  SendMessage, hWinEdit, EM_FINDTEXTEX, ecx, addr @stFindText
		.if  eax == -1							;û�ҵ�
			mov	ecx, hWinMain
			.if	hFindDialog
				mov	ecx, hFindDialog
			.endif
			invoke  MessageBox, ecx, addr szNotFound, NULL, MB_OK or MB_ICONINFORMATION
			ret
		.endif
		invoke  SendMessage, hWinEdit, EM_EXSETSEL, 0, addr @stFindText.chrgText
		
		;�Ѳ����ַ��������༭����ƵĿɼ�����
		invoke  SendMessage, hWinEdit, EM_SCROLLCARET, NULL, NULL
		
		ret

	_FindText endp
	
	_LockMenu  proc  @hMenu:dword, MenuId:dword, bLock:byte
		
		;����˵��ͻһ��˵�
		.if  bLock == TRUE
			invoke  EnableMenuItem, @hMenu, MenuId, MF_GRAYED
		.else
			invoke  EnableMenuItem, @hMenu, MenuId, MF_ENABLED
		.endif
		ret

	_LockMenu endp
	
	_SetStatus proc
		
		LOCAL  @stRange:CHARRANGE
		
		;��ȡ�༭������е�ǰѡ���ַ�������ʼ�ַ�����ֹ�ַ���λ��(����64KB)��
		invoke  SendMessage, hWinEdit, EM_EXGETSEL, 0, addr @stRange
		mov  eax, @stRange.cpMin
		.if  eax == @stRange.cpMax
			invoke  _LockMenu, hMenu, IDM_COPY, TRUE
			invoke  _LockMenu, hMenu, IDM_CUT,  TRUE
		.else
			invoke  _LockMenu, hMenu, IDM_COPY, FALSE
			invoke  _LockMenu, hMenu, IDM_CUT,  FALSE
			
		.endif
		
		;�鿴���а��ܷ�ճ��
		invoke  SendMessage, hWinEdit, EM_CANPASTE, 0, 0
		.if  eax
			invoke  _LockMenu, hMenu, IDM_PASTE, FALSE
		.else
			invoke  _LockMenu, hMenu, IDM_PASTE, TRUE
		.endif
		
		;�鿴�ܷ�ָ���һ�β���
		invoke  SendMessage, hWinEdit, EM_CANREDO, 0, 0
		.if  eax
			invoke  _LockMenu, hMenu, IDM_REDO, FALSE
		.else
			invoke  _LockMenu, hMenu, IDM_REDO, TRUE
		.endif
		
		;�鿴�ܷ���
		invoke  SendMessage, hWinEdit, EM_CANUNDO, 0, 0
		.if  eax
			invoke  _LockMenu, hMenu, IDM_UNDO, FALSE
		.else
			invoke  _LockMenu, hMenu, IDM_UNDO, TRUE
		.endif  
		
		;��ȡ�༭���ı�����
		invoke  GetWindowTextLength, hWinEdit
		.if  eax
			invoke  _LockMenu, hMenu, IDM_SELALL, FALSE
		.else
			invoke  _LockMenu, hMenu, IDM_SELALL, TRUE
		.endif
		
		;��ȡ�ļ��޸�λ��־
		invoke  SendMessage, hWinEdit, EM_GETMODIFY, 0, 0
		.if  eax && hFile
			invoke  _LockMenu, hMenu, IDM_SAVE, FALSE
		.else
			invoke  _LockMenu, hMenu, IDM_SAVE, TRUE
		.endif
		
		.if  szFindText					;�����������ı��Ļ����� ��һ�β���ʱ��Ϊ0 ����һ��ʱ��ֵ��ı�
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
		invoke  RegisterWindowMessage, addr FINDMSGSTRING				;ע�ṫ�����ҿ�
		mov	idFindMessage, eax
		invoke  CreateWindowEx, WS_EX_CLIENTEDGE, offset szClassEdit, \
			NULL, WS_CHILD OR WS_VISIBLE OR WS_VSCROLL OR WS_HSCROLL OR ES_MULTILINE OR ES_NOHIDESEL, \
			0, 0, 0, 0, hWinMain, 0, hInstance, NULL
			
		mov	hWinEdit, eax
		
		;���ñ༭��ؼ��Ĺ���ģʽ  TM_PLAINTEXT �ؼ��л���������ʽģʽ
		invoke  SendMessage, hWinEdit, EM_SETTEXTMODE, TM_PLAINTEXT, 0
		invoke  RtlZeroMemory, addr @stCF, sizeof @stCF
		mov	@stCF.cbSize, sizeof @stCF
		mov	@stCF.yHeight, 11*20
		mov	@stCF.dwMask, CFM_FACE OR CFM_SIZE OR CFM_BOLD
		invoke  lstrcpy, addr @stCF.szFaceName, addr szFont
		
		;���ÿؼ���һ��ѡ�����ı�ȫ�����ĵĸ�ʽ   SCF_ALL Ϊȫ���ı�
		invoke  SendMessage, hWinEdit, EM_SETCHARFORMAT, SCF_ALL, addr @stCF
		
		;����Richedit�ؼ��е�������ֳ���	-1��ʾ���޳���
		invoke  SendMessage, hWinEdit, EM_EXLIMITTEXT, 0, -1
		
		ret

	_Init endp
	
	_Quit  proc					
	;�������˳�ʱ����
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
		;���ܣ���ʾ�ı���������
		;������	
		;	hEdit��Ҫ��ʾ�кŵ��ı�����ͨ��Edit�ؼ�û�в��Թ�������ֻ��RichEdit
		;
		;����ֵ��û�С�
		;--------------------------------------------------------------------------------
		
		LOCAL	@stClientRect:RECT		;RichEdit�Ŀͻ�����С
		LOCAL @hDcEdit						;RichEdit��Dc���豸������
		LOCAL @Char_Height				;�ַ��ĸ߶�
		LOCAL @Line_Count					;�ı���������	
		LOCAL @ClientHeight				;RichEdit�Ŀͻ����߶�
		LOCAL	@hdcBmp						;��RichEdit���ݵ�λͼdc
		LOCAL	@hdcCpb						;��RichEdit���ݵ�Dc
		LOCAL	@CharFmt:CHARFORMAT		;RichEdit�е�һ���ṹ�����ڻ�ȡ�ַ���һϵ����Ϣ������ֻ��������ȡ�ַ��߶�	
		LOCAL	@stBuf[10]:byte			;��ʾ�кŵĻ�����
		
		LOCAL	@szTest[64]:byte			;Only Test
		pushad
		
		;��ȡRichEdit��Dc
		invoke  GetDC, hEdit		
		mov	@hDcEdit, eax
		
		;��ȡRichEdit�Ŀͻ����߶�
		invoke  GetClientRect, hEdit, addr @stClientRect
		mov	ebx, @stClientRect.bottom
		sub	ebx, @stClientRect.top
		mov	@ClientHeight, ebx
		
		;������RichEdit���ݵ�Dc
		invoke  CreateCompatibleDC, @hDcEdit
		mov	@hdcCpb, eax
		
		;������RichEdit���ݵ�λͼDc������������ʾ�к��õġ�
		invoke  CreateCompatibleBitmap, @hDcEdit, 40, @ClientHeight
		mov	@hdcBmp, eax
		
		;��λͼdcѡ�����DC��
		invoke  SelectObject, @hdcCpb, @hdcBmp
		
		;����һ��ʵ�Ļ�ˢ�����������FillRect������
		invoke  CreateSolidBrush, 08080ffh
		
		;�����ʾ�кŵ�dc�ı�����ɫ��
		invoke  FillRect, @hdcCpb, addr @stClientRect, eax
		;���ñ���ɫΪ��ɫ 
		invoke  SetBkMode, @hdcCpb, TRANSPARENT			
		
		;��ȡ��ǰRichEdit�ı��е�������
		invoke  SendMessage, hEdit, EM_GETLINECOUNT, 0, 0
		mov 	@Line_Count, eax 
		
		;��ȡ�ַ���Ϣ
		invoke  RtlZeroMemory, addr @CharFmt, sizeof @CharFmt
		push	sizeof @CharFmt			;�������ṹ��С
		pop	@CharFmt.cbSize
		invoke  SendMessage, hEdit, EM_GETCHARFORMAT, TRUE, addr @CharFmt
		mov	eax, @CharFmt.yHeight	;��ȡ�ַ��߶ȣ���Ӣ��Ϊ��λ����ת��Ϊ����ֻҪ����20����
		cdq									;��edx��չΪeax�ĸ�λ								
		mov	bx, 20
		div	ebx							
		; ������: Ĭ�Ϸ��� ax �� dx �� ax ��	 
		;al �洢������������, ah �洢�������������� �� ax �洢������������, dx �洢��������������.
		mov	@Char_Height, eax			;�ַ��߶�
		
		.data
			charFmt  byte  "%4u", 0
		.code
		invoke	RtlZeroMemory, addr @stBuf, sizeof @stBuf
		;������ʾ�кŵ�ǰ��ɫ
		invoke  SetTextColor, @hdcCpb, 0000000h
		mov	ebx, @Char_Height
		mov	@Char_Height, 1
		
		;��ȡ�ı����е�һ���ɼ����е��кţ�û������к���ʾ��������ı��Ĺ�����������
		invoke  SendMessage, hEdit, EM_GETFIRSTVISIBLELINE, 0, 0
		mov	edi, eax
		inc	edi
		;��λͼdc��ѭ������к�
		.while	edi <= @Line_Count
			invoke  wsprintf, addr @stBuf, addr charFmt, edi
			invoke  TextOut, @hdcCpb, 1, @Char_Height, addr @stBuf, eax
			mov	edx, @Char_Height
			add	edx, ebx
			add	edx, 4		;��������м�࣬������ȷ��
			mov	@Char_Height, edx
			inc  	edi
			.break  .if  edx > @ClientHeight
		.endw
		;����"����"��λͼ����"��"��RichEdit��
		invoke BitBlt, @hDcEdit, 0, 0, 40, @ClientHeight, @hdcCpb, 0, 0, SRCCOPY 
		invoke DeleteDC, @hdcCpb
		invoke ReleaseDC, hEdit, @hDcEdit
		invoke DeleteObject, @hdcBmp
		
		popad
		
		ret

	_ShowLineNum endp
	
	;--------------------------------------------------------------------------------
	_SubProcEdit  proc  hWnd, uMsg, wParam, lParam
	;���ܣ��ػ�RichEdit��WM_PAINT��Ϣ�����ڵ�RichEditˢ��ʱ��ʾ�кš�
	;������
	;	hWnd, uMsg, wParam, lParam ��Ϊԭ��Windows����RichEdit����Ϣ�Ͳ���
	;����ֵ��û��
	;˵��������Ϣ������Ϻ�������Ϣ���͸�Ĭ�ϵ�RichEdit�Ĵ��ڴ�������, 
	;      lpEditProcΪRichEdit�ľɴ��ڵ�ַ��
	;--------------------------------------------------------------------------------
		LOCAL	@stPS:PAINTSTRUCT
		
		.if	uMsg == WM_PAINT
			invoke  CallWindowProc, lpEditProc, hWnd, uMsg, wParam, lParam
			invoke  BeginPaint, hWinEdit, addr @stPS
			;���к�������ʵ����ʾ�кš�
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
			;�������ڴ�С�ı�ʱ�ı��ı���Ĵ�С
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
				;ȫѡ							
				mov	@stRange.cpMin, 0
				mov	@stRange.cpMax, -1
				invoke  SendMessage, hWinEdit, EM_EXSETSEL, 0, addr @stRange	;ָ��ѡ������Ŀ�ʼ�ͽ���λ��
				
			.elseif  eax == IDM_COPY
				;����
				invoke  SendMessage, hWinEdit, WM_COPY, 0, 0
				
			.elseif  eax == IDM_CUT
				;����
				invoke  SendMessage, hWinEdit, WM_CUT, 0, 0
				
			.elseif  eax == IDM_PASTE
				;ճ��
				invoke  SendMessage, hWinEdit, WM_PASTE, 0, 0
				
			.elseif  eax == IDM_FIND
				;����  �����Ի���
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
			
		.elseif  eax == idFindMessage										;���ҶԻ���������Ϣ
			.if  stFind.Flags & FR_DIALOGTERM
				mov  hFindDialog, 0
				
			.else
				invoke  _FindText
			.endif
			
		.elseif  eax == WM_ACTIVATE										;ͨ���������Ĺ��ߣ�����̣������˸ô���
			mov	eax, wParam
			.if  (ax == WA_CLICKACTIVE) || (ax == WA_ACTIVE)		;����
				invoke  SetFocus, hWinEdit
			.endif
			
		.elseif  eax == WM_CREATE
			push  hWnd
			pop   hWinMain
			invoke  _Init
			;����RichEdit���ı��༭������������һЩ������ʾ�кš�
			invoke  SendMessage, hWinEdit, EM_SETMARGINS, EC_RIGHTMARGIN or EC_LEFTMARGIN, 00050005h+40
			;���ô������༼���������Լ�����WM_PAINT��Ϣ��
			invoke  SetWindowLong, hWinEdit, GWL_WNDPROC, addr _SubProcEdit
			mov	lpEditProc, eax		;����ԭ����RichEdit�Ĵ��ڵ�ַ��
			
			
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
		invoke  GetModuleHandle, NULL								;��ȡʵ�����
		mov	hInstance, eax
		invoke  LoadMenu, hInstance, IDM_MAIN					;���ز˵���Դ
		mov	hMenu, eax
		invoke  LoadAccelerators, hInstance, IDA_MAIN		;���ؼ��ټ���Դ
		mov	@hAccelerator, eax
		
		invoke  RtlZeroMemory, addr @stWndClass, sizeof @stWndClass
		invoke  LoadCursor, hInstance, IDC_ARROW				;���ع��
		mov	@stWndClass.hCursor, eax
		invoke  LoadIcon, hInstance, 10							;����ͼ��
		mov	@stWndClass.hIcon, eax
		mov	@stWndClass.hIconSm, eax
		push 	hInstance
		pop	@stWndClass.hInstance
		mov	@stWndClass.cbSize, sizeof WNDCLASSEX
		mov 	@stWndClass.style, CS_HREDRAW OR CS_VREDRAW
		mov	@stWndClass.lpfnWndProc, offset _ProcWinMain
		mov	@stWndClass.hbrBackground, COLOR_BTNFACE + 1
		mov	@stWndClass.lpszClassName, offset szClassName
		
		invoke  RegisterClassEx, addr @stWndClass	;ע�ᴰ����
		;����������
		invoke  CreateWindowEx, NULL, offset szClassName, offset szCaptionMain, WS_OVERLAPPEDWINDOW, 200, 150, 700, 500, NULL, hMenu, hInstance, NULL
		mov	hWinMain, eax
		invoke  ShowWindow, hWinMain, SW_SHOWNORMAL
		invoke  UpdateWindow, hWinMain
		;��Ϣѭ��
		.while  TRUE
			invoke  GetMessage, addr @stMsg, NULL, 0, 0
			.break .if  eax == 0
			;�ȴ�����ݼ���Ϣ
			invoke  TranslateAccelerator, hWinMain, @hAccelerator, addr @stMsg		;������ټ��� ֱ�����ڹ��̴�������Ϣ��ŷ��ء�
			.if  eax == 0
				invoke  TranslateMessage, addr @stMsg
				invoke  DispatchMessage, addr @stMsg
			.endif
		.endw
		invoke  FreeLibrary, @hRichEdit
		
		ret

	_WinMain endp
	
start:
	;�������
	call  _WinMain
	invoke  ExitProcess, NULL

end  start