assume cs:codesg
;��� ��װ7ch���ж�����
;���� ��һword�����ݵ�ƽ��
;��������ax������Ҫ���������
;����ֵ��dx��ax�д�Ž���ĸ�16λ�͵�16λ
codesg segment

start:
             mov ax,cs                                                             
             mov ds,ax                                                              ;�μĴ���֮�䲻��ֱ�Ӵ��� ֻ��ͨ��ͨ�üĴ�������
             mov si,offset sqr                                                   ;����ds:siָ��Դ��ַ
             mov ax,0
             mov es,ax                                                               ;�μĴ������ܴ��������� Ҳֻ��ͨ��ͨ�üĴ�������
             mov di,200h                                                         ;����es:diָ��Ŀ�ĵ�ַ
             mov cx,offset sqrend - offset sqr                       ;����cxΪ���䳤��
             cld                                                                           ;���ô��䷽��Ϊ��
             
             rep movsb                                                          ;�ȿ������뵽��ȫ�ڴ����
             
             mov ax,0
             mov es,ax
             mov word ptr es:[7ch*4],200h                     ;�����ж��������ַ
             mov word ptr es:[7ch*4+2],0
             
             ;�жϺ���ת int  iret ��call  ret�������������ж�ָ����ñ�־�Ĵ�����վ ��Ӧ��iret����flag registr ��ս
             int 7ch                                                             ;���Զ���cs ip frѹջ
             mov ax,4c00h
             int 21h
             
sqr:
            mul ax
            iret           ;��cs ip fr��ջ
            ;���������7ch�ж���ִ�д��ӳ�������ԭ����
sqrend:
           nop
codesg ends

end start

             
             
             