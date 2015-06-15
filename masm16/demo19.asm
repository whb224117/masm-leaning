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
            mov cx,8
s0 :            
            mov ax,0[si]
            mov [si+16],ax   ;16[di] == [16+di]     
            ;mov ax,[bx+si+idata]   mov ax,idata[bx][si]  mov ax,[bx].idata[si] mov ax,[bx][si]idata 
            add si,2  
            
            loop s0
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start           