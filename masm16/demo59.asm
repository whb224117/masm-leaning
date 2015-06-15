assume cs:codesg

codesg segment

start:
      mov ax,1000h
      mov bh,1
      div bh
      ;发生溢出 会产生0号中断 cpu转去处理中断程序
      mov ax,4c00h
      int 21h
      
codesg ends

end start