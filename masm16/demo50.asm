assume cs:codesg

codesg segment

start:
        mov ax,001eh
        mov bx,0f000h
        add bx,1000h
        adc ax,0020h                   ;加上借位 ax =ax+0020h+cf     carry flag 进位标识符
        
        mov ax,4c00h
        int 21h
        ;cmp ax,10h  相当于 sub ax,10h  不会修改寄存器ax的值 只会修改 标志寄存器的值 可以用来查看 数据的大小和比对
codesg ends

end start
        