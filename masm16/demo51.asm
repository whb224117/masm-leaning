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
        
        sub ax,ax     ;ȷ����λcfΪ0
        
s1:
        mov ax,[si]        ;�տ�ʼ�Ľ�λΪ�� �Ժ�Ľ�λ������ȷ�� ����Ķ������㲻�ܲ����κν�λ��Ϣ ����Ӱ�� cf��ֵ
        adc ax,[di]
        mov [si],ax
        
        inc si
        inc si                ;Ϊʲô����add si,2�� ��Ϊadd��Ӱ��cf��ֵ ��loop inc����Ӱ��cf��ֵ
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