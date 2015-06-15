assume cs:codesg

codesg segment

start:

       mov al,97h
       sub al,98h
       
       mov ax,4c00h
       int 21h
codesg ends

end start