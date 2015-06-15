assume cs:codesg
codesg segment  
                                                              
start:      
s0:
            mov ax,0
                                                                                           
            mov ax,15
            
            jmp short s0                                 ;jmp short 无条件栈内跳转   最多跳转-128--127之间  一个字节  用补码表示
            ;pi的减8 因为当jmp stort s0执行完成之后 pi+2 其前三个指令令pi从0增加到8   这次再令pi反向偏移8个单位回到s0处  这在编译的时候就已经编译好了
            ;jmp near 无条件栈内跳转   最多跳转-32769--32767之间  两个字节  用补码表示
            ;jmp 指令在机器码中 并不是把ip的指令转到s0处 而是计算出s0处所要执行的指令的地址与此指令的偏移地址之间的值
            ;并把其保存在其jmp指令中  在编译的时候就已经确定偏移地址了
            add ax,ax
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 