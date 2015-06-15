assume cs:codesg

codesg segment

start:

      ;设置es:di指向目的地址
      ;设置ds:si指向源地址
      ;设置cx为传输长度
      ;设置传输方向为正
      rep movsb
      
      ;设置中断向量表
      
      mov ax,4c00h
      int 21h
      
d0:
       mov ax,4c00h
       int 21h
       
codesg ends

end start