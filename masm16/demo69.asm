;assume cs:codesg
;功能子程序 向上滚动一行
sub4:
      push cx
	  push si
	  push di
	  push es
	  push ds
	  
	  mov si,0b800h
	  mov es,si
	  mov si,160       ;ds:si指向第n+1行
	  mov di,0         ;es:di指向第n行
	  cld
	  mov cs,24        ;共复制24
sub4s:
      push cx
	  mov cx,160
	  rep movsb        ;复制
	  pop cx
	  loop sub4s     
	  
	  mov cx,80
	  mov si,0
sub4s1:
      mov byte ptr es:[160*24+si],' '  ;最后一行清空
	  add si,2
	  loop sub4s1
	  
	  pop ds
	  pop es
	  pop si
	  pop si
	  pop cx
	  ret                 ;sub4 ends
	  