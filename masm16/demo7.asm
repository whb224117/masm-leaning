assume cs:codesg

codesg segment
demo2:      
            mov ax,0ffffh  ;ʮ������ǰ����ĸ��ʼ��Ҫ��0
            mov ds,ax
            add bx,6
            mov ax,[bx]
            
            mov dx,0
            
            mov cx,3
 s:         add dx,ax
            loop s           
            mov ax,4c00h
            int 21h
codesg ends

end demo2