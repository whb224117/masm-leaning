assume cs:codesg

data segment

db 'Welcome to masm!',0

data ends

codesg segment

start:
           mov dh,8                             ;dh装行号（范围：0-25）
           mov dl,3                               ;dl装列号（范围：0-80）注：每超过80等于行号自动加一
           mov cl,2                               ;cl中存放属性颜色（0cah为红底高亮闪烁绿色属性）
           
           mov ax,data
           mov ds,ax
           
           mov si,0
           
           call show_str
           
           mov ax,4c00h
           int 21h
           
show_str:                                        ;显示字符串的子程序
           push cx
           push si
           
           mov al,0a0h                        ;每行有80*2=160个字节
           dec dh                                   ;行号在显存下标从0开始 所以减一
           mul dh                                ;相当于从(n-1)*0a0h个byte单元开始
           
           mov bx,ax                         ;定位好的位置偏移地址保存在bx里（行）
           
           mov al,2                            ;每个字符占两个字节
           mul dl                                ;dl==3定位列 结果ax存放的是定位好的列的位置
           sub ax,2                           ;列号在显存中从下标0开始 又因为是偶字节存放字符 所以减2
           
           add ax,bx                        ;此时bx中存放的是行与列号的偏移地址
           
           mov ax,0b800h              ;显存开始的地址
           mov es,ax                        ;es中存放的是显存的地0页（共0--7页）的起始的段地址
           
           mov di,0                          ;di指向显存的偏移地址
           
           mov al,cl                         ;cl是存放颜色的参数，这时候al存放颜色了 下面cl用来临时存放要处理的字符
           
           mov ch,0                           ;cl存放的是每次准备处理的字符
s:           
           mov cl,ds:[si]                   ;ds:[si]指向"Welcome to masm!",0
           
           jcxz ok                               ;当cl值为0时 cx==0则发生跳转到ok结束处理
           
           mov es:[bx+di],cl           ;偶地址存放字符
           mov es:[bx+di+1],al
           
           inc si
           
           add di,2
           jmp short s
ok:
          pop si
          pop cx
          ret
codesg ends

end start
          
           
           
           
           