assume cs:codesg

stack segment
          db 8 dup(0)
          db 8 dup(0)
stack ends

codesg segment

start:
          mov ax,stack
          mov ss,ax
          mov sp,16
          mov ax,1000
          call s          ;call s 执行完成后 ip+2    
           ;将其执行完成后的的ip指针压入栈 即把mov ax,4c00h这条指令的地址压入栈 再jmp 到s 即跳转到s 
          
          mov ax,4c00h
          int 21h
s:
         add ax,ax
         ret    ;将当前栈中的数据赋给ip 即 push ip 程序又跳回mov ax,4c00h了
codesg ends

end start