assume cs:codesg

data segment

db 'abcdefghijklmn'

data ends

codesg segment

start : 
            mov ax,data
            mov ds,ax
            mov si,0
            
            mov cx,14
            
            call capital
            
            mov ax,4c00h
            int 21h
            
capital:                            ;子程序 对数据区里面的字符串大写
           and byte ptr [si] , 11011111b          ;b表示2进制  masm编译器默认的是10进制    
           ; add  可以对内存操作  mov 可以全部内存 add 只能寄存器把貌似
           inc si
           loop capital
           ret 
           
codesg ends

end start           
