assume cs:codesg
;��demo10 �Ĵ����Ż� ����ѭ�� ���Ч��
codesg segment ;�ο�ʼ
start:      ;����ʼ
            mov bx,0
            mov cx,12;Ĭ�ϵ��Ǽ�����
            mov ax,0ffffh
            mov ds,ax ;���ݶ� 
            mov ax,0020h
            mov es,ax ;���Ӷ�
s:            
            mov dl,[bx]         
            mov es:[bx],dl
            inc bx
            
            loop s     
                
            mov ax,4c00h
            int 21h
;p�������� Ҳ���Խ���ѭ��loop����̨��� ǰ̨��������ʾ
codesg ends ;�ν���

end start ;�������