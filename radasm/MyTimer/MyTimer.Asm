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
include		RADbg.inc


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equ ��ֵ����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
MAIN	equ	1
EDT_TIME equ 1001


DTM		struct
  h	dd	?
  m	dd	?
  s	dd	?
DTM		ends

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ���ݶ�
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data?

hInstance	dd	?
Time	 SYSTEMTIME <>
Ehwd	dd ?
		.data
;����dword

Tbuf	db 1024 dup(0)
Tfmt  db "%dʱ%d��%d��",13,10,0
time	 DTM <>

		.const

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
		invoke SetTimer,hWnd,1,500,NULL  ;��IDΪ1��Timer����������;Ϊ����ӦTimer�¼�
		invoke Sleep,250;��ʱ�����˸Ч��
		invoke SetTimer,hWnd,2,1000,NULL  ;��IDΪ1��Timer����������;Ϊ����ӦTimer�¼�
		invoke GetDlgItem,hWnd,EDT_TIME  ;��ȡ
		mov Ehwd,eax
; ����Timer��Ӧ��Ϣ����
		.elseif eax==WM_TIMER
			mov eax,wParam
			.if eax==1;�����1�Ŷ�ʱ��
				invoke GetLocalTime,offset Time;��ȡϵͳʱ��
				;ת��Time��word���͵�dword
				movzx eax,Time.wHour
				mov time.h,eax
				movzx eax,Time.wMinute
				mov time.m,eax
				movzx eax,Time.wSecond
				mov time.s,eax
				;��ʽ��Ϊ�ַ���
				invoke wsprintf,offset Tbuf,offset Tfmt,time.h,time.m,time.s
				invoke SetDlgItemText,hWnd,EDT_TIME,offset Tbuf;д��ʱ��
			.elseif eax==2;�����2�Ŷ�ʱ��
				invoke SetDlgItemText,hWnd,EDT_TIME,0;����ı�
			.endif
; ����ر�ʱ���˳���Ϣ
;----------------------------------------------------
		.elseif	eax == WM_CLOSE
			invoke	EndDialog,hWnd,NULL
;********************************************************************
; ���ֲ˵��ؼ�����Ϣ
;----------------------------------------------------
		.elseif	eax == WM_COMMAND
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
		invoke	DialogBoxParam,hInstance,MAIN,NULL,offset _ProcDlgMain,NULL
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		end	start