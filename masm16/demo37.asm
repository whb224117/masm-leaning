assume cs:codesg

stack segment
      db 16 dup (0)
stack  ends

codesg  segment

      mov ax,4c00h
      int 21h
start:
      mov ax,stack
      mov ss,ax
      mov sp,16
      mov ax,0
      
      push ax                    ;��Ϊpush ax   axΪ0 ����ipָ��ҲΪ0 
      
      mov bx,0
      ret                              ;ret ָ���ִ�е�ǰջ����ָ����Ǹ��� ���Ǹ�����ֵ����ip ����sp+2
      ;����ǰջ����ָ����Ǹ���λip
codesg ends

end start
