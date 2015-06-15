



charstack:
          jmp short charstart
		  
		  table dw charpush,charpop,charshow
		  top dw 0
		  
charstart:
          push bx
		  push dx
		  push di
		  push es
		  
		  cmp ah,2
		  ja sret                ;ja jump above 大于则转移到目标指令执行
		  mov bl,ah
		  mov bh,0
		  add bx,bx
		  jmp word ptr table[bx]
charpush: 
          mov bx,top
		  mov [si][bx],al
		  inc top
		  jmp sret
charpop:
          cmp top,0
		  je sret
		  dec top
		  mov bx,top
		  mov al,[si][bx]
		  jmp sret
charshow:
          mov bx,0b800h
		  mov es,bx
		  mov al,160
		  mov ah,0
		  mul dh
		  mov di,ax
		  
		  mov bx,0
charshows:
          cmp bx,top
		  jne noempty    ;JNE jump not equal 是两个操作数不相等的时候执行跳转
		  mov byte ptr es:[di],' '
		  jmp sret
noempty:
          mov al,[si][bx]
		  mov es:[di],al
		  mov byte ptr es:[di+2],' '
		  inc bx
		  add di,2
		  jmp charshows
sret:
          pop es
		  pop di
		  pop dx
		  ret
		  
		  
		  
		  
		  
		  
		  