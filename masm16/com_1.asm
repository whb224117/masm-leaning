.model tiny        ;���ܹؼ�
     .data              ;����COM��ʽ�ļ������ݶε����ݻ��Զ��ŵ�����κ�
data db 'My data Area!',0    
     
     .code
     .startup           ;��ʹ�����ָ���0100H ��ʼ����ӦCOM��ʽ�ļ���Ҫ��
     
     
     .exit              ;���������൱�� MOV AH,4CH/INT 21H
     end
