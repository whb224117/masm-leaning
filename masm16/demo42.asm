assume cs:codesg

codesg segment

start : 
          mov ax,1
          mov cx,3
          call s    
          ; call  s的含义： push cs:ip  将当前的ip压入站     jmp  s 跳转到s地址  
          ;则压入站的是mov bx,ax 这条指令的偏移地址 因为当call s执行完成后ip指向movbx, ax这条指令
          mov bx,ax
          mov ax,4c00h
          int 21h
s : 
         add ax,ax
         loop s
         ret 
codesg ends

end start

;call di 和 call dword ptr [di]都是对的，但功能（结果）不一样。
;call di是说所调用的子程序的入口偏移地址=di的值，段地址CS不变（段内调用）；
;call dword ptr [di]是说所调用的子程序的入口的“偏移地址”存放在内存单元DS:{di]中，而其“段地址”则存在DS:[di+2]中，这是段间调用。
