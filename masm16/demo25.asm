assume ds:datasg , cs:codesg , ss:stacksg         

;demo23,24���Ż� ��cx���ݴ�����ڴ浱�� ������dx��                       
datasg  segment                                                               
             db 'file            '
             db 'edit            '
             db 'sear            '
             db 'view            '
             db 'opti            '
             db 'help            '
datasg ends

stacksg segment
             dw 0,0,0,0,0,0,0,0
stacksg ends

codesg segment                                                                         
start :    
            mov ax,stacksg                                                            
            mov ss,ax        
            mov sp,16                                                                          
            mov ax,datasg                                                            
            mov ds,ax
            mov bx,0
            mov cx,6
            mov si,0
s0 :   
          
           push cx
           mov cx,4
           mov bx,0
s1:  
            mov al,[bx+si]
            and al,11011111b
            mov [bx][si],al
            inc bx
            
            loop s1  ;�ڴ˴��Ĵ���cx�Ż��һ
            
            pop cx  ;�����ѭ����cx�ļ����������ݷ���ջ�� ��ֹ�ڲ����ͻ
            
            add si,16
            
            loop s0
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 