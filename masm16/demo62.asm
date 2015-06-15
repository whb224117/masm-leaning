assume cs:codesg

data segment

db 'Welcome to masm!'

data ends

codesg segment

start:
        mov ax,cs
        mov ds,ax
        mov si,offset do0        ;设置ds:si指向源地址
        mov ax,0
        mov ex,ax
        mov di,200h                ;设置es:di指向目的地址
        
        mov cx,offset do0end - offset do0                    ;设置cx为传输长度
        
        ;编译器是可以识别+ - * /指令的     如mov ax,(8+9)*3
        
        cld                                    ;设置传输方向为正
        rep movsb 
        
        ;设置中断向量表
        
        mov ax,4c00h
        int 21h
        
do0:
       
        mov ax,data
        mov ds,ax
         mov si,0
         mov ax,0b800h
         mov es,ax
         mov di,12*160+36*2
         
         mov cx,21
         
s:
         mov al,[si]
         mov es:[di],al
         inc si
         add di,2
         loop s
         
         mov ax 4c00h
         int 21h
         
codesg ends
end start