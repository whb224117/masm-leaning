assume cs:codesg,ds:data

data segment
a db 1,2,3,4,5,6,7,8
b dw 0   
;c dw offset a,seg a,offset b,seg b  ;seg ������ ȡ��ĳһ��ŵĶε�ַ
;ds:data����ȥ�� ʡ�Ի�����
;�б�žͲ���ʡ�� ��Ϊ��ſ��������еĶ���ʹ��
;�˴���a��b�൱��ƫ�Ƶ�ַ
data ends
codesg segment

start:
       mov ax,data
	   mov ds,ax
	   mov si,0
	   mov cx,8
s:     
       mov al,a[si]
	   mov ah,0
	   add b,ax
	   inc si
	   loop s
	   
	   mov ax,4c00h
	   int 21h
	   
codesg ends
end start