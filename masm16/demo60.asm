assume cs:codesg

codesg segment

start:

      ;����es:diָ��Ŀ�ĵ�ַ
      ;����ds:siָ��Դ��ַ
      ;����cxΪ���䳤��
      ;���ô��䷽��Ϊ��
      rep movsb
      
      ;�����ж�������
      
      mov ax,4c00h
      int 21h
      
d0:
       mov ax,4c00h
       int 21h
       
codesg ends

end start