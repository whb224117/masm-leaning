assume ds:datasg , cs:codesg              

;demo23���Ż� ��cx���ݴ�����ڴ浱�� ������dx��                       
datasg  segment                                                               
             db 'file            '
             db 'edit            '
             db 'sear            '
             db 'view            '
             db 'opti            '
             db 'help            '
             db ' '
datasg ends

codesg segment                                                                         
start :                                                                                      
            mov ax,datasg                                                            
            mov ds,ax
            mov bx,0
            mov cx,6
            mov si,0
s0 :   
          
           mov ds:[60h],cx
           mov cx,4
           mov bx,0
s1:  
            mov al,[bx+si]
            and al,11011111b
            mov [bx][si],al
            inc bx
            
            loop s1  ;�ڴ˴��Ĵ���cx�Ż��һ
            
            mov cx,ds:[60h]  ;�����ѭ����cx�ļ����������ݷ����ڴ��� ��ֹ�ڲ����ͻ
            
            add si,16
            
            loop s0
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 