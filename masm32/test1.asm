
.386
.model flat,stdcall
;.model �ڴ�ģʽ[,���Ը�ʽ],������ʽ]
option casemap:none
;include �ļ�����

;.386   ʹ��386ָ� 	.386p��ʾ��Ȩ�ȼ���0������
;.model   flat   ʹ��flatƽ̹�ڴ�ģʽ 
;option   casemap:none����Сд���� 
;.data ��ʾ�ɶ���д���������
;.const ��ʾ�ɶ�����д����
;data? ����һ���ŵ��ǿɶ���дδ����ı���
;data? ���еı�����������exe�ļ��Ĵ�С ӦΪ��ֻ��һ����ʶ
;szBuffer db 100*1024 dup(?) ��ʾ�õ�100kb�Ļ�����
include windows.inc
include user32.inc
includelib user32.lib			;����user32��̬���ӿ�ĵ����
include kernel32.inc
includelib kernel32.lib

;���ݶ�

.const
szCaption db '��ӭ������c������',0
szText db '���ɣ�����һ��ʼwin32�Ļ��֮·��',0

;�����
.code
start:
      invoke MessageBox,\     ;��б�ܱ�ʾ����  invoke ����
	  NULL,\                  ;�����ھ��
	  offset szCaption,\
	  offset szText,\         ;����
	  MB_OK
	  invoke ExitProcess,NULL
end start
