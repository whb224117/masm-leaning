assume cs:codesg  ;codesg为代码段
codesg segment ;段开始cs 表示代码段 以下的数据均编译放在代码段
            dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
             ;先给代码段开始放入数据，再放入下面代码 即下面代码在偏移地址为16的位置以后
start:   ;程序开始 如果放在前面dw前面ip=16指针会指向cs:0 把前面数据当代码处理 在此以后会ip=16
            mov bx,0
            mov ax,0
            mov cx,8
s:            
            add ax,cs:[bx]         
            add bx,2
            
            loop s     
                
            mov ax,4c00h
            int 21h
;p结束程序 也可以结束循环loop即后台完成 前台不单步显示
codesg ends ;段结束

end start 
;程序结束  编译器先找end end即是程序的结束位置 也从end出找到程序的开始部分 因为start可以修改为任何值只是一个标识