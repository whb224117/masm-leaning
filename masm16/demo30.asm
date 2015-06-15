assume cs:codesg
codesg segment  
 ;就是通过nop指令的填充（nop指令一个字节），使指令按字对齐，从而减少取指令时的内存访问次数。（一般用来内存地址偶数对齐，比如有一条指令，占3字节，这时候使用nop指令，cpu 就可以从第四个字节处读取指令了。）
;2）通过nop指令产生一定的延迟，但是对于快速的CPU来说效果不明显，可以使用rep前缀，多延迟几个时钟；-->具体应该说是占用了3个时钟脉冲! 
;3）i/o传输时，也会用一下 nop，等待缓冲区清空，总线恢复； 
;4）清除由上一个算术逻辑指令设置的flag位； 
;5）破解：）对于原程序中验证部分使用nop来填充，使验证失效； 
;6）有一个朋友说的比较厉害－－在航天飞机控制程序中防止程序跳飞！ 

                                                              
s :                                                                                      
            mov ax,bx
            mov si,offset s     ;si中保存的是s的偏移地址
            mov di,offset s0     ;di中保存的是s0的偏移地址
            mov dx,cs:[si]    ;复制成功  中间用一个dx
            mov cs:[di],dx
s0:
             nop                       ;nop为空指令 占一个字节 执行一个cpu一个周期 不做任何操作 是指令对齐 等待缓冲区清空
             nop
            mov ax,4c00h
            int 21h
            
codesg ends

end s   