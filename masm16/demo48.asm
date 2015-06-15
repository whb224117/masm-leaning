assume cs:codesg

codesg segment

start:
        mov al,98h
        add al,al
        
        mov ax,4c00h
        int 21h
        
codesg ends

end start