assume cs:codesg ,ds:datasg

                           
datasg segment                                                                        
            db 'ulIX'
            db 'ofRK'
datasg ends                                                                                          
                                                                                                     
codesg segment                                                                         
start :                                                                                        
            mov al,'a'  ; 自动将字符转换成II码                                                         
            mov bl,'b'
             
            mov ax,4c00h
            int 21h
            
codesg ends ;段结束

end start 