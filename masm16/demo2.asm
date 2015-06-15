assume cs:codesg

codesg segment
demo2:   mov ax,0123h
            add bx,0456h
            add ax,bx
            add ax,ax
;其中的start demo2 可以为任何字母  表示程序入口点;为注释

          mov ax,4c00h
          int 21h

codesg ends

end demo2