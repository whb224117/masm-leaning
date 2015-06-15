assume cs:codesg

codesg segment


         mov ax,4c00h
         int 21h

start:
         mov ax,0
s:     
         nop             ;此处的指令会换成jum short s1 而此命令在编译的时候都已经确定了其的偏移地址 向上偏移8个地址 则在此处会跳转到 mov ax,4c00处往下执行
         nop

        mov di,offset s
        mov si,offset s2
        mov ax,cs:[si]
        mov cs:[di],ax
        
s0:
        jmp short s
        
s1:
       mov ax,0
       int 21h
       mov ax,0
s2:
       jmp short s1   ;其所标示的是向前跳转 其ip-8  即指令偏移相对于此向前便宜8个地址 编译的时候就已经确定
       nop
       
codesg ends

end start