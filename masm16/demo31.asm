assume cs:codesg
codesg segment  
                                                              
start:                                                                                      
            mov ax,15
            jmp short s0                                     ;jmp short ������ջ����ת   �����ת-128--127֮��  һ���ֽ�  �ò����ʾ
             ;jmp near ������ջ����ת   �����ת-32769--32767֮��  �����ֽ�  �ò����ʾ
            ;jmp ָ���ڻ������� �����ǰ�ip��ָ��ת��s0�� ���Ǽ����s0����Ҫִ�е�ָ��ĵ�ַ���ָ���ƫ�Ƶ�ַ֮���ֵ
            ;�����䱣������jmpָ����  �ڱ����ʱ����Ѿ�ȷ��ƫ�Ƶ�ַ��
            add ax,ax
s0:
            inc ax
            mov ax,4c00h
            int 21h
            
codesg ends

end start   