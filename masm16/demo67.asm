assume cs:codesg
codesg segment

start:
       mov ax,0b800h
	   mov es,ax
	   mov ah,'a'
s:     
       mov es:[160*12+40*2],ah
	   inc ah
	   cmp ah,'z'
	   jna s
	   
	   mov ax,4c00h
	   int 21h
	   
codesg ends
end start