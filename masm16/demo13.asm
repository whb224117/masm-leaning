assume cs:codesg                                 ;codesgΪ�����
codesg segment                                   ;�ο�ʼcs ��ʾ����� ���µ����ݾ�������ڴ����
            dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
            dw 0,0,0,0,0,0,0,0
                                                                    ;DW  ����һ���� define word �����ֽ�
                                                                      ;DB  ����һ���ֽ� define byte һ���ֽ� 
                                                                        ;DD  ����һ��˫�� define double world �ĸ��ֽ�
start:                                                                          ;ip=32
            mov ax,codesg                                    ;cs == codesg  �������Ὣcodesg�����cs
            mov ss,ax                                            ;�μĴ���֮�䲻��ֱ�Ӹ�ֵ ֻ��ͨ��ͨ�üĴ�����ֵ
            mov bx,0
            mov sp,32                                          ;0~31Ϊ���ݴ洢��Ԫ spָ��32��ʾջΪ��
            mov cx,8
s0 :            
            push cs:[bx]  
            add bx,2       
            
            loop s0
            
            mov bx,0
            mov cx,8
s1 :   
            pop cs:[bx]     
            add bx,2
            
             loop s1
             
            mov ax,4c00h
            int 21h
;p�������� Ҳ���Խ���ѭ��loop����̨��� ǰ̨��������ʾ
codesg ends ;�ν���

end start 
;�������  ����������end end���ǳ���Ľ���λ�� Ҳ��end���ҵ�����Ŀ�ʼ���� ��Ϊstart�����޸�Ϊ�κ�ֵֻ��һ����ʶ