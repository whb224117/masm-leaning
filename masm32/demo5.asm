 .386
        .model flat,stdcall
        option casemap:none

include windows.inc

include kernel32.inc
include user32.inc

includelib kernel32.lib
includelib user32.lib

        .data
mess    db 'How are you !',0    ;Ҫ��ʾ����Ϣ

        .data?
StdOut  dd ?    ;��ű�׼����İѱ�
CharOut dd ?    ;��¼ʵ��������ַ���

        .code
start:  
        invoke GetStdHandle,STD_OUTPUT_HANDLE   ;��ȡ��׼����İѱ�
        mov StdOut,eax      ;����ѱ���

        lea eax,mess
        invoke lstrlen,eax  ;���ַ����ĳ���

        lea ecx,CharOut
        invoke WriteFile,StdOut,addr mess,eax,ecx,NULL  ;д�ļ�
        
        invoke ExitProcess,NULL   ;�������
        end start
