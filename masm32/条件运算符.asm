;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; by С����, http://www.fishc.com+ V7 v: @% l' W9 R/ N% `
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>/ a; z8 N. G1 X6 g, V
; ���ܣ������������ʹ��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        .386
        .model flat,stdcall
        option casemap:none

include windows.inc
include user32.inc
include kernel32.inc
includelib user32.lib
includelib kernel32.lib
    .data
szCaption   db  '��C������', 0
szText1     db  '����Ϊ�Ұ���', 0
szText2     db  'ľ�н�λ', 0
szText3     db  '������λ��', 0
szFmt       db  'eax = %d(eax==1����), ebx = %d(�ý�λ��ʶ), edx = %d(edxΪ������)', 0
buffer      db  80 dup(0)

    .code
start:
    mov ax, 250
    xor ax, 754
    cmp ax, 520
    .if ZERO?
        invoke MessageBox, NULL, offset szText1, offset szCaption, MB_OK
    .endif   
    .if CARRY?
        invoke  MessageBox, NULL, offset szText3, offset szCaption, MB_OK
    .else
        invoke  MessageBox, NULL, offset szText2, offset szCaption, MB_OK
    .endif
    
    mov ax, 32769
    add ax, ax
    .if CARRY?
        invoke  MessageBox, NULL, offset szText3, offset szCaption, MB_OK
    .else
        invoke  MessageBox, NULL, offset szText2, offset szCaption, MB_OK
    .endif
    
    invoke ExitProcess, 0  ; ��������
    
end start

;�ã��ңң�?���������������Խ�λ��־λ�Ƿ���λ
;�ڣţң�?���������������������־λ�Ƿ���λ'
;�ӣɣǣ�?�����������������Է��ű�־λ�Ƿ���λ
;�У��ңɣԣ�?����������������ż��־λ�Ƿ���λ
;�ϣ֣ţңƣ̣ϣ�?���������������־λ�Ƿ���λ