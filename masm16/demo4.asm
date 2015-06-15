assume cs:codesg

codesg segment
demo2:      mov ax,2000h
            mov ds,ax
            mov bx,1000h
            mov ax,[bx]
;asm文件会将mov ax,[1] 编译成mov ax,1 
;而mov ax,[bx]则会将偏移地址的数据传递给ax所以只能先把
;偏移地址传递给通用寄存器再通过通用寄存器传递给ax
            inc bx
            inc bx
;inc 自增1
            mov [bx],ax
            inc bx
            inc bx
            mov [bx],ax
            inc bx
            mov [bx],al
            inc bx
            mov [bx],al

;cpu运算结束标志 debug默认16进制masm编译器默认10进制所以要加h           
            mov ax,4c00h
            int 21h

codesg ends

end demo2