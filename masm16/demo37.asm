assume cs:codesg

stack segment
      db 16 dup (0)
stack  ends

codesg  segment

      mov ax,4c00h
      int 21h
start:
      mov ax,stack
      mov ss,ax
      mov sp,16
      mov ax,0
      
      push ax                    ;因为push ax   ax为0 所以ip指向也为0 
      
      mov bx,0
      ret                              ;ret 指令会执行当前栈中所指向的那个数 把那个数的值赋给ip 并且sp+2
      ;即当前栈中所指向的那个是位ip
codesg ends

end start
