assume cs:codesg

data segment

db 8,11,8,1,8,5,63,38

data ends

codesg segment

start:
        mov ax,data
        mov ds,ax
        mov bx,0
        mov ax,0
        mov cx,0
 s0:       
        cmp byte ptr [bx],8
        je s1                                     ; JNE ZF��־λ��Ϊ1 ����������������ȵ�ʱ��ִ����ת  JE ZF��־λΪ1 ��������������ȵ�ʱ��ִ����ת
        jmp short s2
s1:
       inc ax
s2:
       inc bx
       loop s0
       
       mov ax,4c00h
       int 21h
       
codesg ends

end start