assume cs:codesg

codesg segment
demo2:      mov ax,2000h
            mov ds,ax
            mov al,[0]
            mov bl,[1]
            mov cl,[2]
            mov dl,[3]
;其中的start demo2 可以为任何字母  表示程序入口点;为注释

          mov ax,4c00h
          int 21h

codesg ends

end demo2