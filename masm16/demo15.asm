assume cs:codesg            ;����ջ��α����   ����ʡ�� 
;assume ds:datasg��׼ȷ�����ǽ�data����μĴ���ds��������
;Ҳ������ds���洢data�εĵ�ַ���ε�ַ������Ȼ��������Ǹ����������ģ�
;��������assumeд������ǰ�棬������һ��ʼ���ܹ���������ô���ڱ���ʱ�������й�data�ı�ţ�
;��Ҫ��ε�ַ�ͻ�Ĭ��ʹ��ds�Ĵ���

;demo 13 ���Ż����� 
                           
a segment                                                                      ; ���ݶ�                   
            db 1,2,3,4,5,6,7,8
a ends

b segment                                                                        ;ջ��
            db 1,2,3,4,5,6,7,8
b ends
   
c segment                                                                        ;ջ��
            db 1,2,3,4,5,6,7,8
c ends                                                                                          ;DW  ����һ���� define word �����ֽ�
                                                                                                      ;DB  ����һ���ֽ� define byte һ���ֽ� 
codesg segment                                                                         ;DD  ����һ��˫�� define double world �ĸ��ֽ�
start :                                                                                         ;ipָ���λ�� �������ڵ�
            mov ax,a                                                            ;ջ�ε�ַ����
            mov es,ax
            mov ax,c                                                             ;���ݶε�ַ����
            mov ds,ax
            mov bx,0
            mov cx,8
s0 :            
            mov [bx],es:[bx]
            add bx,1      
            
            loop s0
            
            mov bx,0
            mov cx,8
s1 :   
            mov ax,b
            mov es,ax
            mov dx,es:[bx]
            add [bx],dx    
            add bx,1
            
             loop s1
             
            mov ax,4c00h
            int 21h
;p�������� Ҳ���Խ���ѭ��loop����̨��� ǰ̨��������ʾ
codesg ends ;�ν���

end start 
;�������  ����������end end���ǳ���Ľ���λ�� Ҳ��end���ҵ�����Ŀ�ʼ���� ��Ϊstart�����޸�Ϊ�κ�ֵֻ��һ����ʶ