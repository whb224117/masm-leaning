assume cs:codesg

codesg segment


         mov ax,4c00h
         int 21h

start:
         mov ax,0
s:     
         nop             ;�˴���ָ��ỻ��jum short s1 ���������ڱ����ʱ���Ѿ�ȷ�������ƫ�Ƶ�ַ ����ƫ��8����ַ ���ڴ˴�����ת�� mov ax,4c00������ִ��
         nop

        mov di,offset s
        mov si,offset s2
        mov ax,cs:[si]
        mov cs:[di],ax
        
s0:
        jmp short s
        
s1:
       mov ax,0
       int 21h
       mov ax,0
s2:
       jmp short s1   ;������ʾ������ǰ��ת ��ip-8  ��ָ��ƫ������ڴ���ǰ����8����ַ �����ʱ����Ѿ�ȷ��
       nop
       
codesg ends

end start