assume ds:datasg , cs:codesg   

 ;������ʵ�� 100001 ����100���̺�����  div���̱�����ax��������dx��                           
datasg  segment                                                               
             dd 100001                           ;dd define double word
             dw 100                                 ;define word û�е����ŵ�Ϊ����
             dw 0
datasg ends

codesg segment  
                                                               
start :                                                                                      
            mov ax,datasg                                                            
            mov ds,ax
            mov ax,ds:[0]                             ;asm���в�����������[����] �����Գ��� ds:[����]  �������ĵ�16λ
            mov dx,ds:[2]                             ;�������ĸ�16λ
            div  word ptr ds:[4]                 ;ds:ax ��32λ���ݳ��� ds:[4]���ֵ�Ԫ�е�����
            mov ds:[6],ax                              ;�̴�ax��ת�Ƶ����ݶ���
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start    