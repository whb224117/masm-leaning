assume cs:codesg

codesg segment  
;һ���ֽ�һ���ֽڵ��ж��Ƿ���0�ŵ�Ԫ                                                              
start:      
           mov ax,2000h
           mov ds,ax    
           mov bx,0                            
s:         
           mov cl,[bx]
           mov ch,0
           jcxz ok                            ; ��������� 
           inc bx
           loop s
ok:
            dec bx               ;  inc   increase����һ dec decrease �Լ�һ
            mov dx,bx
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 