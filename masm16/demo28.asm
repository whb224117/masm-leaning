;dupαָ��  ���� db 3 dup(1,2) == db 1,2,1,2,1,2
;db 3 dup('abc',2) == db 'abc',2,'abc',2'abc',2  ÿ������ʾһ���ֽ�

assume ds:datasg , cs:codesg   

 ;������ʵ�� 100001 ����100���̺�����  div���̱�����ax��������dx��                           
datasg  segment                                                               
         db 3 dup('abc',2)  ;db 'abc',2,'abc',2'abc',2  ÿ������ʾһ���ֽ�  �� 'a' 'b' 'c'  2 'a' 'b' 'c'  2 'a' 'b' 'c'  2
datasg ends

codesg segment  
                                                               
start :                                                                                      
            mov ax,datasg                                                            
            mov ds,ax
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start   