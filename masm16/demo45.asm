assume cs:codesg

data segment

db 'abcdefghijklmn'

data ends

codesg segment

start : 
            mov ax,data
            mov ds,ax
            mov si,0
            
            mov cx,14
            
            call capital
            
            mov ax,4c00h
            int 21h
            
capital:                            ;�ӳ��� ��������������ַ�����д
           and byte ptr [si] , 11011111b          ;b��ʾ2����  masm������Ĭ�ϵ���10����    
           ; add  ���Զ��ڴ����  mov ����ȫ���ڴ� add ֻ�ܼĴ�����ò��
           inc si
           loop capital
           ret 
           
codesg ends

end start           
