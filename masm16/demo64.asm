assume cs:codesg

codesg segment

start:

        mov ax,0b800h
        mov es,ax
        mov byte ptr es:[12*160+40*2],'!'
        
        int 0                  ; 0���жϾ�������ж� û������ж� ��int 0�������Է�������ж�
        ;int ���õĵ�ʱ�γ��� call���� int��Щ���ᱣ��flag register
        
codesg ends

end start