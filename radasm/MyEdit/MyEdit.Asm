;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; �Ի���ʽ�������ڵı�׼ģ��
; ����ʱ��:2010-11-24
; �����start��־���ڳ���ͷ,���붨�� _ProcDlgMain ��ԭ��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.386
		.model flat, stdcall
		option casemap :none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include �ļ�����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		windows.inc
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib
include		gdi32.inc
includelib	gdi32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equ ��ֵ����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DLG_MAIN	equ	1
DLG_MY	equ 1000
TXT_MY	equ 1001
BTN_MY   equ 1002
IDC_EDT2 equ 1003

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ���ݶ�
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?

hInstance	dd	?

		.const
		.data
MyString db ?
strTmp  db 30 dup(?)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; �����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcDlgMain	proc	uses ebx edi esi hWnd,wMsg,wParam,lParam

		mov	eax,wMsg
;********************************************************************
; Ĭ�ϳ�ʼ����Ϣ
;----------------------------------------------------
		.if	eax == WM_INITDIALOG
;********************************************************************
; ����ر�ʱ���˳���Ϣ
;----------------------------------------------------
		.elseif	eax == WM_CLOSE
			invoke	EndDialog,hWnd,NULL
;********************************************************************
; ���ֲ˵��ؼ�����Ϣ
;----------------------------------------------------
		.elseif	eax == WM_COMMAND;�ؼ���Ϣ
			mov eax,wParam
			movzx eax,ax	;��16λȡ���ؼ�ID
			.if eax==BTN_MY;�����Ӧ��Ϣ��ID�����ǵİ�ť��
				invoke GetDlgItemText,hWnd,TXT_MY,addr MyString,100;��ȡhWnd���ڣ����������ǵ������ڣ���
				;IDΪTXT_MY�Ŀؼ����ַ�����MyString���ǵü���ȡ��ַ����addrŶ������ȡ100���ַ�
				invoke MessageBox,NULL,addr MyString,addr MyString,0 ;�����ִ�
			.elseif eax==IDC_EDT2
				invoke GetDlgItemText,hWnd,IDC_EDT2,offset strTmp,30
				invoke MessageBeep,0FFFFFFFFh
				;invoke MessageBox,hWnd,
				invoke SetWindowText,hWnd,offset strTmp
				invoke SetDlgItemText,hWnd,TXT_MY,offset strTmp
			.endif
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
		invoke	DialogBoxParam,hInstance,DLG_MY,NULL,offset _ProcDlgMain,NULL
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start