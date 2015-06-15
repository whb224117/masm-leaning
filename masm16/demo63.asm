assume cs:codesg

codesg segment

start:

do0:
        ;设置ds:si指向字符串
        mov ax,0b800h
        mov es,ax
        mov di,12*160+36*2   ;设置es:di指向显存空间的中间位置
        mov cx,21                        ;设置cx为字符串长度
        
s:
        mov al,[si]
        mov es:[di],al
        inc si
        add di,2
        loop s
        
        mov ax,4c00h
        int 21h
        
do0end:

          nop 
codesg ends
end start