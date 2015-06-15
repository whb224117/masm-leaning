assume cs:codesg

codesg segment

start:
         jmp short s            ;一般情况下 loop jmp jaxz等会给出相对于次命令 的便宜地址 而不是其实际要添砖的真实地址 这样便于程序的随地加载
         
         db 129 dup(0)     ;short 不能超过一个字节 即-128到127之间 会编译错误 
         
s:
         mov ax,0ffffffh;
        
        
        mov ax,4c00h
        int 21h
codesg ends

end start