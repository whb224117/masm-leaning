assume cs:codesg

stack segment
          db 8 dup(0)
          db 8 dup(0)
stack ends

codesg segment

start:
          mov ax,stack
          mov ss,ax
          mov sp,16
          mov ax,1000
          call s          ;call s ִ����ɺ� ip+2    
           ;����ִ����ɺ�ĵ�ipָ��ѹ��ջ ����mov ax,4c00h����ָ��ĵ�ַѹ��ջ ��jmp ��s ����ת��s 
          
          mov ax,4c00h
          int 21h
s:
         add ax,ax
         ret    ;����ǰջ�е����ݸ���ip �� push ip ����������mov ax,4c00h��
codesg ends

end start