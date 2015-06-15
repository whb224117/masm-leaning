assume cs:codesg

codesg segment

start:

        mov ax,0b800h
        mov es,ax
        mov byte ptr es:[12*160+40*2],'!'
        
        int 0                  ; 0好中断就是溢出中断 没有溢出中断 用int 0照样可以发生溢出中断
        ;int 调用的的时段程序 call不是 int这些还会保存flag register
        
codesg ends

end start