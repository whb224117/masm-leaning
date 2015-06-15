assume cs:codesg

codesg segment ;段开始
start:      ;程序开始
            mov bx,0
            mov cx,12
s:        
            mov ax,0ffffh
            mov ds,ax ;在不同的段 
            mov dl,[bx] 
            mov ax,0020h
            mov ds,ax ;在不同的段 
            mov [bx],dl
            inc bx
            
            loop s         
            mov ax,4c00h
            int 21h
;p结束程序 也可以结束循环loop即后台完成 前台不单步显示
codesg ends ;段结束

end start ;程序结束