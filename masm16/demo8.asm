assume cs:codesg

codesg segment
start:      
            mov ax,2000h
            mov ds,ax
            ;ds:[偏移地址] 可以解决问题
            ;ds:[偏移地址] ==[bx]
            mov al,ds:[0]
            mov bl,ds:[1]
            mov cl,ds:[2]
            mov dl,ds:[3]
                    
            mov ax,4c00h
            int 21h
;p结束程序 也可以结束循环loop即后台完成 前台不单步显示
codesg ends

end start