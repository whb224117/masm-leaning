assume cs:codesg , ds:datasg , ss:stacksg

datasg segment

          db 'welcome to masm!'
          db 02h,24h,71h
          
datasg ends

stacksg segment       

        dw 8 dup(0) 
        
stacksg ends  

codesg segment

start:
          mov ax,datasg
          mov ds,ax 
          mov ax,stacksg
          mov ss,ax
          mov sp,10h 
         
           xor bx,bx           ;bx清零,用来索引颜色
           mov ax,0b872h       ;算出屏幕第12行中间的显存的段起始位置放入ax中
           mov cx,3            ;S3循环控制行数，外循环为3次，因为要显示三个字符串
s3:     
           push cx             ;三个进栈操作为外循环s3保存相关寄存器的值
           push ax             ;以防止它们的值在内循环中被破坏
           push bx
           mov es,ax           ;此时es为屏幕第12行中间的显存的段起始位置
           mov si,0            ;si用来索引代码列的字符
           mov di,0            ;di用来定位目标列
           mov cx,10h          ;S1循环控制存放的字符，内循环为10h次，因为一个字符串中含10h个字节
s1:     
           mov al,ds:[si]
           mov es:[di],al
           inc si
           add di,2
           
           loop s1                 ;此循环实现偶地址中存放字符
           mov di,1                ;di的值设为1,从而为在显存奇地址中存放字符的颜色属性做准备
           pop bx 
           mov al,ds:10h[bx]       ;取颜色属性
           inc bx 
           mov cx,10h              ;第二个内循环也为10h次
 s2:    
            mov es:[di],al
            add di,2
           
           loop s2                 ;此循环实现奇地址中存放字符的颜色属性  
                                         ;以下4句为下一趟外循环做准备 
           pop ax 
           add ax,0ah              ;将显存的段起始地址设为当前行的下一行 
                                             ;[在段地址中加0ah,相当于在偏移地址中加了0a0h(=160d)]
           pop cx
             
           loop s3  
             
             
          mov ax,4c00h
            int 21h  
codesg ends

end start