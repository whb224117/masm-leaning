
        .model small    ;����EXE��ʽ�ļ�

        .stack 100h     ;������100h����Ĭ�϶�ջ��СΪ400H
        
        .data           ;��ʼ�������ݶ�
mess    db 'How, world!$'
        
        .data?          ;δ��ʼ�����ݶΣ��öβ�ռ��EXE�ļ��Ĵ�С��
pp      Dw 200H DUP(?)  ;����δ��ʼ�����ݣ�ֻ����ʹ�á�����

        .code           ;�����
        
        .startup        ;��ʹ�ø�αָ���ʼ��DS����ջֵ���κ�������ӣ�
        mov ah,9        
        lea dx,mess
        int 21h         ;��ʾ��Ϣ
        mov pp,ax
        .exit           ;�����÷�����
        end             ;��ʹ����.startup�����Բ���ָ����������￪ʼ����
