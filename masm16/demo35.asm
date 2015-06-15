assume cs:codesg

codesg segment  
;一个字节一个字节的判断是否含有0号单元                                                              
start:      
           mov ax,2000h
           mov ds,ax    
           mov bx,0                            
s:         
           mov cl,[bx]
           mov ch,0
           jcxz ok                            ; 这个有问题 
           inc bx
           loop s
ok:
            dec bx               ;  inc   increase自增一 dec decrease 自减一
            mov dx,bx
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 