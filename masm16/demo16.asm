assume cs:codesg ,ds:datasg

                           
datasg segment                                                                        
            db 'ulIX'
            db 'ofRK'
datasg ends                                                                                          
                                                                                                     
codesg segment                                                                         
start :                                                                                        
            mov al,'a'  ; �Զ����ַ�ת����II��                                                         
            mov bl,'b'
             
            mov ax,4c00h
            int 21h
            
codesg ends ;�ν���

end start 