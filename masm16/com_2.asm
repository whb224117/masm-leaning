MAN STRUCT      ;定义一个结构，在win32中非常常用！
  W  dw 1234h           ;dw 也可用 word
  B  db 9 dup(?)        ;db 也可用 byte
MAN ENDS

.model tiny     ;COM格式文件

.data           ;对于COM格式文件，数据段的内容会自动放到代码段后
zz  MAN <>,<1,"abcd">,<3,"Ldf">

.code           ;代码段
.startup        ;可使下面的指令从0100H 开始（COM格式文件要求）

    mov ax,3031h
    mov zz.W,ax         ;对结构赋值
    mov zz.B,'1'
    mov ax,type(MAN)    ;取结构所占字节数
    .exit               ;可设置返回码，如：.EXIT 3相当于 MOV AX,4C03H/INT 21H
    end
