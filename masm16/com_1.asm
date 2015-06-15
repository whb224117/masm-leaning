.model tiny        ;这句很关键
     .data              ;对于COM格式文件，数据段的内容会自动放到代码段后
data db 'My data Area!',0    
     
     .code
     .startup           ;可使下面的指令从0100H 开始（适应COM格式文件的要求）
     
     
     .exit              ;结束程序，相当于 MOV AH,4CH/INT 21H
     end
