assume cs:codesg

codesg segment

start:
      mov ah,0
	  int 16h
	  
	  mov ah,1
	  cmp al,'r'
	  je red                     ;je == jump if zero or equal  jcxz == jump if cx = zero 
	  cmp al,'g'
	  je green
	  cmp al,'b'
	  je blue
	  jmp short sret
red:
      shl ah,1
green:
      shl ah,1
blue:
      mov bx,0b800h
	  mov es,bx
	  mov bx,1
	  mov cx,2000
s:
      and byte ptr es:[bx],11111000b
	  or es:[bx],ah
	  add bx,2
	  loop s
sret:
      mov ax,4c00h
	  int 21h
	  ;INT 21H ������ϵͳ�ж�
      ;MOV AX,4C00H
      ;��ʵ�����õľ��� AH=4CH����˼���ǵ��� 
	  ;INT 21H �� 4CH ���жϣ����жϾ��ǰ�ȫ�˳�����
      ;��ʵ���ȼ���MOV AH,4CH INT 21H
codesg ends
end start
	  
	  