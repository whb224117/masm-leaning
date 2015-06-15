assume ds:datasg , cs:codesg , es:externsg
                        
datasg  segment                                                               
         db
datasg ends

codesg segment  
                                                               
start :                                                                                      
            mov ax,datasg                                                            
            mov ds,ax
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start   