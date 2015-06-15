
        .model small    ;生成EXE格式文件

        .stack 100h     ;若不带100h，则默认堆栈大小为400H
        
        .data           ;初始化的数据段
mess    db 'How, world!$'
        
        .data?          ;未初始化数据段，该段不占用EXE文件的大小！
pp      Dw 200H DUP(?)  ;对于未初始化数据，只能是使用“？”

        .code           ;代码段
        
        .startup        ;可使用该伪指令初始化DS及堆栈值（参后面的例子）
        mov ah,9        
        lea dx,mess
        int 21h         ;显示信息
        mov pp,ax
        .exit           ;可设置返回码
        end             ;因使用了.startup，所以不用指出程序从哪里开始啦！
