assume cs:code
code segment
start:
      mov ax,0b800h
	  mov es,ax
	  mov bx,0  ;es:bxָ��д����̵����ݵ��ڴ���
	  
	  mov al,8  ;д���������
	  mov ch,0  ;�ŵ��� ��0��ʼ
	  mov cl,1  ;������ ��1��ʼ
	  mov dl,0  ;��������0������a��1������b�����̴�80h��ʼ 80h:Ӳ��c 81h:Ӳ��d
	  mov dh,0  ;��ͷ��(�������̼���ţ���Ϊһ������һ����ͷ����д�)
	  mov ah,3  ;���� int13h д�����ݵĹ��ܺ�
	  int 13h
	  ;���ز���
	  ;�����ɹ���(ah)=0(al)=д���������
	  ;����ʧ��(ah)=�������
return:
      mov ax,4c00h
	  int 21h
code ends
end start