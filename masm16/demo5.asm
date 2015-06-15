assume cs:codesg

codesg segment
demo2:      mov ax,2
            mov cx,11
;每执行一次计数器cx会减一 直到零为止2^12
s:          add ax,ax
            loop s

;cpu运算结束标志 debug默认16进制masm编译器默认10进制所以要加h           
            mov ax,4c00h
            int 21h

codesg ends

end demo2
;demo2 程序的开始地址