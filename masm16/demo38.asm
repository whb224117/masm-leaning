assume cs:codesg

codesg segment

start:
         jmp short s            ;һ������� loop jmp jaxz�Ȼ��������ڴ����� �ı��˵�ַ ��������ʵ��Ҫ��ש����ʵ��ַ �������ڳ������ؼ���
         
         db 129 dup(0)     ;short ���ܳ���һ���ֽ� ��-128��127֮�� �������� 
         
s:
         mov ax,0ffffffh;
        
        
        mov ax,4c00h
        int 21h
codesg ends

end start