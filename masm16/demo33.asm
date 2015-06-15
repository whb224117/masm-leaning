assume cs:codesg , ds:datasg

datasg segment
      db 0,0,0                                 ;Ïàµ±ÓÚdb 0 db 0 db 0
datasg ends

codesg segment  
                                                              
start:      
           mov ax,datasg
           mov ds,ax
            mov bx,0
            jmp word ptr [bx+1]
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 