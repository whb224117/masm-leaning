assume cs:codesg

codesg segment  
      
;һ����һ�ֽڵ��ж��Ƿ���0�ŵ�Ԫ                                                            
start:      
           mov ax,2000h
           mov ds,ax    
           mov bx,0                            
s:         
           mov cx,[bx]
           jcxz ok   ;ƫ�Ƶ�ַ not��ʵ��ַ  �����ʱ���Ѿ�������� ����ڴ˵�ַ����ƫ��������ַ
           ;jaxz ��������ת  ��ax=0ʱ������ת ���ڶ�ת�� ƫ��һ���ֽ� ��-128--127֮��
           inc bx
           jmp short s   ;Ҳ��ƫ�Ƶ�ַ
ok:
            mov dx,bx
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 