
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
szText1      db '�㰮����?',0
szText2       db 'лл����Ҳ����!',0
;�����
.code     ;��,����αָ�� �Ǹ�����������
start:
      invoke MessageBox,\     ;��б�ܱ�ʾ����  invoke ����
	  NULL,\                  ;�����ھ��
	  offset szText1,\
	  offset szCaption,\         ;����
	  MB_YESNO or MB_ICONQUESTION
	  .while  eax == IDNO	;��,����αָ�� �Ǹ�����������
		invoke MessageBox,NULL,offset szText1,offset szCaption,MB_YESNO
	  .endw
	  invoke MessageBox,NULL,offset szText2,offset szCaption,MB_OK
end start