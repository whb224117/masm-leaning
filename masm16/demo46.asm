assume cs:codesg

data segment

db 'word',0
db 'unix',0
db 'wind',0
db 'good',0

data ends

stack segment

db 16 dup(0)

stack ends

codesg segment

start : 
            mov ax,data
            mov ds,ax
            mov ax,stack
            mov ss,ax
            mov sp,16
            mov bx,0
            
            mov cx,4
s:          
            mov ss:[0],cx                                   ;���ѭ��4��  �Ƚ�cx ����ջ����ǰ�� ��Ϊÿ��ֻѹջһ�γ�ջһ��  ����cx����push
            mov si,bx
            call capital                ;������ת ִ�д�дת��   call ��ret��һ��  call ��ѹջ
            add bx,5                    ;ÿ��ָ����ɺ�bx+5������һ��
            loop s
            
            mov ax,4c00h
            int 21h
            
capital:
           mov cl,[si]                                 ;�ڲ㵱[si]Ϊ0ʱ����ѭ��
           ;�˺����� ���cx���и��� ���¿�ʼmov cx,4 loop s 4�ε�ִ�д�����Ϊ������ ����취����cxѹջ
           mov ch,0
           jcxz ok                                       ;��cxΪ0ʱִ����ת
           and byte ptr [si] , 11011111b
           inc si
           jmp short capital                     ;jmp short capital �൱��loop capital ����û��cx������ jmp
ok:
          mov cx,ss:[0]
          ret     
codesg ends

end start