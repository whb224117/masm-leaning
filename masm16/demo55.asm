assume cs:codesg

data segment

db 8,11,8,1,8,5,63,38

data ends

codesg segment

start:
        mov ax,data
        mov ds,ax
        mov bx,0
        mov ax,0
        mov cx,0
 s0:       
        cmp byte ptr [bx],8
        jna s1                                     ; jna 低于或等于，或不高于则转移 
        inc ax                                     ;大于8就累加
s1:                                                 
       inc bx
       loop s0
       
       mov ax,4c00h
       int 21h
       
codesg ends

end start