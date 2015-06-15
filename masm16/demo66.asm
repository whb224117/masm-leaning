assume cs:codesg

codesg segment

start:
             mov ax,cs
             mov ds,ax
             mov si,offset capital                                                 ;设置ds:si指向源地址
             mov ax,0
             mov es,ax
             mov di,200h                                                         ;设置es:di指向目的地址
             mov cx,offset capitalend - offset capital                       ;设置cx为传输长度
             cld                                                                           ;设置传输方向为正
             
             rep movsb
             
             mov ax,0
             mov es,ax
             mov word ptr es:[7ch*4],200h
             mov word ptr es:[7ch*4+2],0
             
             ;中断和跳转 int  iret 和call  ret的最大区别就是中断指令会让标志寄存器入站 相应的iret会让flag registr 出战
             
             mov ax,4c00h
             int 21h
             
 capital:
             push cx
             push si
             
change:
             mov cl,[si]
             mov ch,0
             jcxz ok
             and byte ptr [si],11011111b
             inc si
             jmp short change
             
ok:
             pop si
             pop cx
             iret
             
capitalend:
             nop
                         
codesg ends

end start