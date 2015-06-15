;dup伪指令  例如 db 3 dup(1,2) == db 1,2,1,2,1,2
;db 3 dup('abc',2) == db 'abc',2,'abc',2'abc',2  每个都表示一个字节

assume ds:datasg , cs:codesg   

 ;本程序实现 100001 除以100的商和余数  div后商保存在ax中余数在dx中                           
datasg  segment                                                               
         db 3 dup('abc',2)  ;db 'abc',2,'abc',2'abc',2  每个都表示一个字节  即 'a' 'b' 'c'  2 'a' 'b' 'c'  2 'a' 'b' 'c'  2
datasg ends

codesg segment  
                                                               
start :                                                                                      
            mov ax,datasg                                                            
            mov ds,ax
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start   