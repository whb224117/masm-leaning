assume ds:datasg , cs:codesg , ss:stacksg                   ;����ջ��α����   

;demo 13 ���Ż����� 
                           
datasg  segment                                                                      ; ���ݶ�                   
            dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
datasg ends

stacksg segment                                                                        ;ջ��
            dw 0,0,0,0,0,0,0,0
stacksg ends
                                                                                                     ;DW  ����һ���� define word �����ֽ�
                                                                                                      ;DB  ����һ���ֽ� define byte һ���ֽ� 
codesg segment                                                                         ;DD  ����һ��˫�� define double world �ĸ��ֽ�
start :                                                                                         ;ipָ���λ�� �������ڵ�
            mov ax,stacksg                                                            ;ջ�ε�ַ����
            mov ss,ax
            mov ax,datasg                                                             ;���ݶε�ַ����
            mov ds,ax
            mov bx,0
            mov sp,16     ;ջ��ռ16���ֽ�  0~15 16��ʾջΪ��
            mov cx,8
s0 :            
            push [bx]  
            add bx,2       
            
            loop s0
            
            mov bx,0
            mov cx,8
s1 :   
            pop [bx]     
            add bx,2
            
             loop s1
             
            mov ax,4c00h
            int 21h
;p�������� Ҳ���Խ���ѭ��loop����̨��� ǰ̨��������ʾ
codesg ends ;�ν���

end start 
;�������  ����������end end���ǳ���Ľ���λ�� Ҳ��end���ҵ�����Ŀ�ʼ���� ��Ϊstart�����޸�Ϊ�κ�ֵֻ��һ����ʶ