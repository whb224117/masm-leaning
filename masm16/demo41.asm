assume cs:codesg

stack segment
      db 16 dup (0)          ;ջ��0~15
stack  ends

codesg  segment

      mov ax,4c00h
      int 21h
start:
      mov ax,stack
      mov ss,ax
      mov sp,16           ;ipָ��16 ����ջһλ����ջΪ��
      mov ax,0
      
      push cs      ;��λ��ip   ÿ����վsp���Զ���2���߱�� ��սsp���2 ���߱��
      push ax     ;��λ��cs �������Ǹ�λcxѹվ ����ip��ָ�� ����ָ��cs :0ָ��mov ax 4c00h
      
      mov bx,0
      retf         ;retf ָ���ѵ�ǰջ����ָ����Ǹ��� ���Ǹ�����ֵ����cs ����sp+2  ������sp+2��ջ����ָ����Ǹ��� ���Ǹ�����ֵ����ip ����sp����+2  ǰ��spһ������
      ;����ǰջ�е�λΪcs ��λΪip
codesg ends

end start
