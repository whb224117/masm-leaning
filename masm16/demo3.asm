assume cs:codesg

codesg segment
demo2:      mov ax,2000h
            mov ds,ax
            mov al,[0]
            mov bl,[1]
            mov cl,[2]
            mov dl,[3]
;���е�start demo2 ����Ϊ�κ���ĸ  ��ʾ������ڵ�;Ϊע��

          mov ax,4c00h
          int 21h

codesg ends

end demo2