assume cs:codesg , ds:datasg

datasg segment
      dd 12345678h   ;define double word
datasg ends

codesg segment  
                                                              
start:      
           mov ax,datasg
           mov ds,ax
            mov word ptr [bx],0                 ;��16λ
            mov [bx+2],cs     ;Ҫ��һ���ֵ��ڴ漴�����ֽ�  ��Ȼ ��֪��Ҫ��ֵ�����ֽ�     ��16λ
            jmp dword ptr ds:[0]      ; [����]ʱҪ��ƫ�Ƶ�ַ ��Ȼmasm�������ᰴ������ֵ ������ָ��  ���debug��һ��                                    
           
           ;debug  ��� jmp dword ptr ds:[0] ����Ϊ jmp far [0000]
            ;dword double word ptr pointer ˫�� ����16λ����cs������� ��16λ����ip����ε�ָ��
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 