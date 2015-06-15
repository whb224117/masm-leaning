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
	  ;INT 21H 调用了系统中断
      ;MOV AX,4C00H
      ;其实起作用的就是 AH=4CH，意思就是调用 
	  ;INT 21H 的 4CH 号中断，该中断就是安全退出程序。
      ;其实这句等价于MOV AH,4CH INT 21H
codesg ends
end start
	  
	  