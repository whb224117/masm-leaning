assume ds:datasg , cs:codesg   

 ;本程序实现 100001 除以100的商和余数  div后商保存在ax中余数在dx中                           
datasg  segment                                                               
             dd 100001                           ;dd define double word
             dw 100                                 ;define word 没有单引号的为数字
             dw 0
datasg ends

codesg segment  
                                                               
start :                                                                                      
            mov ax,datasg                                                            
            mov ds,ax
            mov ax,ds:[0]                             ;asm当中不允许单独出现[数字] 但可以出现 ds:[数字]  被除数的低16位
            mov dx,ds:[2]                             ;被除数的高16位
            div  word ptr ds:[4]                 ;ds:ax 的32位数据除以 ds:[4]的字单元中的数据
            mov ds:[6],ax                              ;商从ax中转移到数据段中
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start    