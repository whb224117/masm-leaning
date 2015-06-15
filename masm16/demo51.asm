assume cs:codesg

datasg segment

db 16 dup(88h)
db 16 dup(11h)

datasg ends
codesg segment

start:
        mov ax,datasg
        mov ds,ax
        mov si,0
        mov di,16
        
        mov cx,8
        
        call s0;
        
        mov ax,4c00h
        int 21h
s0:
        push ax
        push ds
        push cx
        push si
        
        sub ax,ax     ;确保进位cf为0
        
s1:
        mov ax,[si]        ;刚开始的进位为零 以后的进位就由其确定 后面的额外运算不能产生任何进位信息 以免影响 cf的值
        adc ax,[di]
        mov [si],ax
        
        inc si
        inc si                ;为什么不用add si,2呢 因为add会影响cf的值 而loop inc不会影响cf的值
        inc di
        inc di
        
        loop s1
        
        pop si
        pop cx
        pop ds
        pop ax
        
        ret
             
codesg ends

end start