 .model small
        .stack 200h
        .data
        .code
Start:                          ;����ʼִ��ʱDS��ES��ָ��PSP

        mov ax,ds:[16h]         ;ȡ�����̵�PSP��ֵ
        mov ds,ax
        call DispAx
        call CrLf
        cmp ax,ds:[16h]         ;����ͬ,˵�����򱻸���!
        jnz Start

        mov ah,4ch
        int 21h

CrLf    proc uses ax dx         ;��ʾ�س����е��ӳ���
        mov dl,0dh
        mov ah,2
        int 21h
        mov dl,0ah
        mov ah,2
        int 21h
        ret
CrLf    endp


DispAx  proc uses ax cx dx bp   ;��ʾAX�Ĵ�����ֵ
        xor cx,cx
        mov bp,16               ;��16������ʾ
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
