assume cs:codesg

codesg segment

start:
        mov ax,003eh
        mov bx,1000h
        sub bx,2000h
        sbb ax,0020h             ;ºı»•ΩËŒª ax =ax-0020h-cf
        
        mov ax,4c00h
        int 21h
codesg ends

end start
        