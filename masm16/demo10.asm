assume cs:codesg

codesg segment ;�ο�ʼ
start:      ;����ʼ
            mov bx,0
            mov cx,12
s:        
            mov ax,0ffffh
            mov ds,ax ;�ڲ�ͬ�Ķ� 
            mov dl,[bx] 
            mov ax,0020h
            mov ds,ax ;�ڲ�ͬ�Ķ� 
            mov [bx],dl
            inc bx
            
            loop s         
            mov ax,4c00h
            int 21h
;p�������� Ҳ���Խ���ѭ��loop����̨��� ǰ̨��������ʾ
codesg ends ;�ν���

end start ;�������