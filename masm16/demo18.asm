assume ds:datasg , cs:codesg              

                           
datasg  segment                                                               
            db 'welcome to masm!'
            dw 0,0,0,0,0,0,0,0
datasg ends
                                                                                                  
                                                                                                     
codesg segment                                                                         
start :                                                                                      
            mov ax,datasg                                                            
            mov ds,ax
            mov si,0
            mov di,16  
            mov cx,8
s0 :            
            mov ax,[si]
            mov [di],ax
            add di,2
            add si,2  
            
            loop s0
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start             