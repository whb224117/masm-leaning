assume cs:codesg

codesg segment  
      
;一个字一字节的判断是否含有0号单元                                                            
start:      
           mov ax,2000h
           mov ds,ax    
           mov bx,0                            
s:         
           mov cx,[bx]
           jcxz ok   ;偏移地址 not真实地址  编译的时候都已经编译好了 相对于此地址向下偏移三个地址
           ;jaxz 有条件跳转  当ax=0时发生跳转 段内短转移 偏移一个字节 即-128--127之间
           inc bx
           jmp short s   ;也是偏移地址
ok:
            mov dx,bx
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 