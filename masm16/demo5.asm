assume cs:codesg

codesg segment
demo2:      mov ax,2
            mov cx,11
;ÿִ��һ�μ�����cx���һ ֱ����Ϊֹ2^12
s:          add ax,ax
            loop s

;cpu���������־ debugĬ��16����masm������Ĭ��10��������Ҫ��h           
            mov ax,4c00h
            int 21h

codesg ends

end demo2
;demo2 ����Ŀ�ʼ��ַ