assume cs:codesg

codesg segment
start:      
            mov ax,0ffffh
            mov ds,ax
            mov bx,0
            mov dx,0
            mov cx,12
s: 
            mov al,[bx] ;防溢出 
            mov ah,0
            add dx,ax
            inc bx
            loop s         
            mov ax,4c00h
            int 21h
;p结束程序 也可以结束循环loop即后台完成 前台不单步显示
codesg ends

end start