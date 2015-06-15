 .model small
        .stack 200h
        .data
        .code
Start:                          ;程序开始执行时DS及ES都指向PSP

        mov ax,ds:[16h]         ;取父进程的PSP段值
        mov ds,ax
        call DispAx
        call CrLf
        cmp ax,ds:[16h]         ;不相同,说明程序被跟踪!
        jnz Start

        mov ah,4ch
        int 21h

CrLf    proc uses ax dx         ;显示回车换行的子程序
        mov dl,0dh
        mov ah,2
        int 21h
        mov dl,0ah
        mov ah,2
        int 21h
        ret
CrLf    endp


DispAx  proc uses ax cx dx bp   ;显示AX寄存器的值
        xor cx,cx
        mov bp,16               ;以16进制显示
DispAx1:
        xor dx,dx
        div bp
        push dx
        inc cx
        or ax,ax
        jnz DispAx1
DispAx2:
        pop ax
        add al,'0'
        cmp al,'9'
        jbe DispAx3
        add al,'A'-'9'-1
DispAx3:
        mov dl,al
        mov ah,2
        int 21h
        loop DispAx2
        ret
DispAx  endp

        end Start
