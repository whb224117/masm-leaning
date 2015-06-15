assume cs:codesg

stack segment
      db 16 dup (0)          ;栈是0~15
stack  ends

codesg  segment

      mov ax,4c00h
      int 21h
start:
      mov ax,stack
      mov ss,ax
      mov sp,16           ;ip指向16 超过栈一位表明栈为空
      mov ax,0
      
      push cs      ;低位是ip   每次入站sp会自动减2或者别的 出战sp会加2 或者别的
      push ax     ;高位是cs 所以先是高位cx压站 再是ip的指针 最后的指针cs :0指向mov ax 4c00h
      
      mov bx,0
      retf         ;retf 指令会把当前栈中所指向的那个数 把那个数的值赋给cs 并且sp+2  继续把sp+2后栈中所指向的那个数 把那个数的值赋给ip 并且sp继续+2  前后sp一共加四
      ;即当前栈中低位为cs 高位为ip
codesg ends

end start
