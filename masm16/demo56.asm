assume cs:codesg

datasg segment

db 'Welcome to masm!'
db 16 dup(0)

datasg ends

codesg segment

start:
      mov ax,datasg;
      mov ds,ax
      mov si,0
      mov di,16
      mov es,ax
      mov cx,16
      
      cld         ;cld clear diretion ��������־  ��df diretion flagΪ0 ������           std set direction �÷����־   ��df diretion flagΪ1 ��������    
      ;��������־�����ַ����ıȽϣ���ֵ��
      ;��ȡ��һϵ�к�rep���õĲ����У�
      ;di��si�ǿ����Զ������Ķ�����Ҫ�����Ӽ�����ֵ��
     ; cld�����߳���si��di��ǰ�ƶ���
     ; stdָ��Ϊ���÷��򣬸��߳���si��di����ƶ�
     
     rep movsb     ;������ָ�� ÿ�ΰ�ds:[si]���͵�ds:[di]�� ����cx��һ
     
     ;MOVSB��MOVe String Byte�������ַ�������ָ�����ָ��ֽڴ������ݡ� һ���ֽ�
     ;MOVSW��MOVE String Word�������ִ�����ָ�����ָ��ִ������ݡ�      �����ֽ�
     ;ͨ��SI��DI�������Ĵ��������ַ�����Դ��ַ��Ŀ���ַ��
     ;����DS:SI��ε�ַ��N���ֽڸ��Ƶ�ES:DIָ��ĵ�ַ��
     ;���ƺ�DS:SI�����ݱ��ֲ���
     
     ;REP��REPeat��ָ����ǡ��ظ�������˼��
     ;����������ظ�ǰ׺ָ�����Ϊ��Ȼ�Ǵ����ַ�����
     ;�򲻿���һ���֣��ڣ�һ���֣��ڣ��ش��ͣ�
     ;������Ҫ��һ���Ĵ��������ƴ����ȡ�
     ;����Ĵ�������CX��ָ��ÿ��ִ��ǰ�����ж�CX��ֵ�Ƿ�Ϊ0
     ;��Ϊ0�����ظ�����Ϊ0��CX��ֵ��1�����Դ����趨�ظ�ִ�еĴ�����
     ;������ú�CX��ֵ֮��Ϳ�����REP MOVSB��
     
     mov ax,4c00h
     int 21h
     
codesg ends

end start