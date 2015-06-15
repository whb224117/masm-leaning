assume cs:codesg

data segment

dw 1,2,3,4,5,6,7,8
dd  0,0,0,0,0,0,0,0

data ends

codesg segment

start : 
            mov ax,data
            mov ds,ax
            mov si,0
            mov di,16
            
            mov cx,8
s:         
            mov bx,[si]
            call cube
            mov [di],ax
            mov [di+2],dx
            add si,2
            add di,4
            loop s
            
            mov ax,4c00h
            int 21h
cube:  
            mov ax,bx
            mul bx       ;mul 如果都是8位的话 被乘数默认的是al 乘积保存在ax中  如果都是16位的话被乘数默认的是ax 乘积的高位保存在dx中 低位保存在 ax中
            mul bx
            ret
codesg ends

end start
            