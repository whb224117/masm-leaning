assume cs:codesg ,ds:datasg
                          
datasg segment                                                                        
             db 'BaSiC'
            db 'iNfOrMaTiOn'
datasg ends                                                                                          
                                                                                                     
codesg segment                                                                         
start :  
            mov ax,datasg
            mov ds,ax
                    
            mov bx,0
            
            mov cx,5     
                                                                                
s1:       mov al,[bx]  ;��д����ĸ����λΪ0
            and al,11011111b  ;b��ʾ2����
            mov [bx],al
            inc bx
            
            loop s1
            
            mov bx,5
            mov cx,11
            
s2:       mov al,[bx]  ;Сд����ĸ����λΪ1
            or al,00100000b  ;b��ʾ2����
            mov [bx],al
            inc bx
            
            loop s2
                        
            mov ax,4c00h
            int 21h
            
codesg ends ;�ν���

end start 