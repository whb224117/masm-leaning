assume cs:codesg

codesg segment

start:
        mov ax,001eh
        mov bx,0f000h
        add bx,1000h
        adc ax,0020h                   ;���Ͻ�λ ax =ax+0020h+cf     carry flag ��λ��ʶ��
        
        mov ax,4c00h
        int 21h
        ;cmp ax,10h  �൱�� sub ax,10h  �����޸ļĴ���ax��ֵ ֻ���޸� ��־�Ĵ�����ֵ ���������鿴 ���ݵĴ�С�ͱȶ�
codesg ends

end start
        