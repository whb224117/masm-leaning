assume cs:codesg

codesg segment
demo2:      mov ax,2000h
            mov ds,ax
            mov bx,1000h
            mov ax,[bx]
;asm�ļ��Ὣmov ax,[1] �����mov ax,1 
;��mov ax,[bx]��Ὣƫ�Ƶ�ַ�����ݴ��ݸ�ax����ֻ���Ȱ�
;ƫ�Ƶ�ַ���ݸ�ͨ�üĴ�����ͨ��ͨ�üĴ������ݸ�ax
            inc bx
            inc bx
;inc ����1
            mov [bx],ax
            inc bx
            inc bx
            mov [bx],ax
            inc bx
            mov [bx],al
            inc bx
            mov [bx],al

;cpu���������־ debugĬ��16����masm������Ĭ��10��������Ҫ��h           
            mov ax,4c00h
            int 21h

codesg ends

end demo2