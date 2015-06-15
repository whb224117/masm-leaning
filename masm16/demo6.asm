assume cs:codesg

codesg segment
demo2:      
            mov ax,2
            mov cx,0
;每执行一次计数器cx会减一 直到零为止2^12
s:         add ax,ax
            loop s

;cpu运算结束标志 debug默认16进制masm编译器默认10进制所以要加h           
            mov ax,4c00h
            int 21h
;Intel80x86系列汇编语言中的LOOP指令，是循环指令，循环次数由计数寄存器CX指定。是否执行循环体的判断指令在循环体之后，所以，至少执行1次循环体，即至少循环1次。执行LOOP指令时，CPU自动将CX的值减1，若CX=0，则结束循环；否则，重复执行循环体。
;本题是个特例，虽然计数寄存器的初值为0，但当执行完1次循环体，遇到LOOP指令时，CX=0-1=65535。虽然产生了借位，但CX不等于0，所以，要继续执行循环体。
codesg ends

end demo2
;demo2 程序的开始地址