;21���жϵ�9���ӳ���Ĺ������ڹ�괦��ʾ�ַ���
assume cs:code
data segment
db 'welcome to masm','$'
data ends
code segment 
start: 
	  mov ah,2     ;�ù��
	  mov bh,0     ;��0ҳ
	  mov dh,5     ;dh�з��к�
	  mov dl,12    ;dl�з��к�
	  
	  int 10h
	  
	  mov ax,data
	  mov ds,ax    ;ds:dxָ���ַ������׵�ַdata:0
	  mov dx,0
	  mov ah,9
	  int 21h
	  
	  mov ah,4ch
	  int 21h
code ends
end start