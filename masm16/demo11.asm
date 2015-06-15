assume cs:codesg
;对demo10 的代码优化 减少循环 提高效率
codesg segment ;段开始
start:      ;程序开始
            mov bx,0
            mov cx,12;默认的是计数器
            mov ax,0ffffh
            mov ds,ax ;数据段 
            mov ax,0020h
            mov es,ax ;附加段
s:            
            mov dl,[bx]         
            mov es:[bx],dl
            inc bx
            
            loop s     
                
            mov ax,4c00h
            int 21h
;p结束程序 也可以结束循环loop即后台完成 前台不单步显示
codesg ends ;段结束

end start ;程序结束