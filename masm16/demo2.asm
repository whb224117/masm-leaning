assume cs:codesg

codesg segment
demo2:   mov ax,0123h
            add bx,0456h
            add ax,bx
            add ax,ax
;���е�start demo2 ����Ϊ�κ���ĸ  ��ʾ������ڵ�;Ϊע��

          mov ax,4c00h
          int 21h

codesg ends

end demo2