assume cs:codesg , ds:datasg

datasg segment
      dd 12345678h   ;define double word
datasg ends

codesg segment  
                                                              
start:      
           mov ax,datasg
           mov ds,ax
            mov word ptr [bx],0                 ;低16位
            mov [bx+2],cs     ;要带一个字的内存即两个字节  不然 不知道要赋值几个字节     高16位
            jmp dword ptr ds:[0]      ; [常数]时要带偏移地址 不然masm编译器会按常数赋值 而不是指针  这和debug不一样                                    
           
           ;debug  会把 jmp dword ptr ds:[0] 解释为 jmp far [0000]
            ;dword double word ptr pointer 双字 即高16位赋给cs即代码段 低16位赋给ip代码段的指针
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 