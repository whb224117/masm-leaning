
.386
.model flat,stdcall
;.model �ڴ�ģʽ[,���Ը�ʽ],������ʽ]
option casemap:none
;include �ļ�����

;.386   ʹ��386ָ� 
;.model   flat   ʹ��flatƽ̹�ڴ�ģʽ 
;option   casemap:none����Сд���� 
;.data ��ʾ�ɶ���д���������
;.const ��ʾ�ɶ�����д����
;data? ����һ���ŵ��ǿɶ���дδ����ı���
;data? ���еı�����������exe�ļ��Ĵ�С ӦΪ��ֻ��һ����ʶ
;szBuffer db 100*1024 dup(?) ��ʾ�õ�100kb�Ļ�����
include windows.inc   ;���������MB_OK IDOK �ĺ궨��
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib

;���ݶ�

.const
szCaption   db '��ӭ������c������',0
szText      db '���ɣ�����һ��ʼwin32�Ļ��֮·��',0
szOK        db '���ղŵ����OK��ť',0
szCANCEL    db '���ղŵ����CANCEL��ť',0
;�����
.code     ;��,����αָ�� �Ǹ�����������
start:
      invoke MessageBox,\     ;��б�ܱ�ʾ����  invoke ����
	  NULL,\                  ;�����ھ��
	  offset szCaption,\
	  offset szText,\         ;����
	  MB_OKCANCEL or MB_ICONQUESTION
	  .if  eax==IDOK	;��,����αָ�� �Ǹ�����������
	  invoke MessageBox,NULL,offset szOK,offset szText,MB_OK
	  .else
	  invoke MessageBox,NULL,offset szCANCEL,offset szText,MB_OK
	  .endif
	  invoke ExitProcess,NULL
end start