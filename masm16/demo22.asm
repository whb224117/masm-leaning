assume ds:datasg , cs:codesg              

                           
datasg  segment                                                               
             db 'file            '
             db 'edit            '
             db 'sear            '
             db 'view            '
             db 'opti            '
             db 'help            '
datasg ends

codesg segment                                                                         
start :                                                                                      
            mov ax,datasg                                                            
            mov ds,ax
            mov bx,0
            mov cx,6
            mov si,0
s0 :   
          
           mov cx,4
           mov bx,0
s1:  
            mov al,[bx+si]
            and al,11011111b
            mov [bx][si],al
            inc bx
            
            loop s1
            
            add si,16
            
            loop s0
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 