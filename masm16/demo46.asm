assume cs:codesg

data segment

db 'word',0
db 'unix',0
db 'wind',0
db 'good',0

data ends

stack segment

db 16 dup(0)

stack ends

codesg segment

start : 
            mov ax,data
            mov ds,ax
            mov ax,stack
            mov ss,ax
            mov sp,16
            mov bx,0
            
            mov cx,4
s:          
            mov ss:[0],cx                                   ;外层循环4次  先将cx 放入栈中最前面 因为每次只压栈一次出栈一次  所以cx不能push
            mov si,bx
            call capital                ;函数跳转 执行大写转换   call 和ret是一对  call 有压栈
            add bx,5                    ;每次指向完成后bx+5跳到下一个
            loop s
            
            mov ax,4c00h
            int 21h
            
capital:
           mov cl,[si]                                 ;内层当[si]为0时结束循环
           ;此函数中 会对cx进行覆盖 导致开始mov cx,4 loop s 4次的执行次数变为无数次 解决办法就是cx压栈
           mov ch,0
           jcxz ok                                       ;当cx为0时执行跳转
           and byte ptr [si] , 11011111b
           inc si
           jmp short capital                     ;jmp short capital 相当于loop capital 但是没有cx的限制 jmp
ok:
          mov cx,ss:[0]
          ret     
codesg ends

end start