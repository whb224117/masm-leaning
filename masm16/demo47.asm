assume cs:codesg

data segment

db 'Welcome to masm!',0

data ends

codesg segment

start:
           mov dh,8                             ;dhװ�кţ���Χ��0-25��
           mov dl,3                               ;dlװ�кţ���Χ��0-80��ע��ÿ����80�����к��Զ���һ
           mov cl,2                               ;cl�д��������ɫ��0cahΪ��׸�����˸��ɫ���ԣ�
           
           mov ax,data
           mov ds,ax
           
           mov si,0
           
           call show_str
           
           mov ax,4c00h
           int 21h
           
show_str:                                        ;��ʾ�ַ������ӳ���
           push cx
           push si
           
           mov al,0a0h                        ;ÿ����80*2=160���ֽ�
           dec dh                                   ;�к����Դ��±��0��ʼ ���Լ�һ
           mul dh                                ;�൱�ڴ�(n-1)*0a0h��byte��Ԫ��ʼ
           
           mov bx,ax                         ;��λ�õ�λ��ƫ�Ƶ�ַ������bx��У�
           
           mov al,2                            ;ÿ���ַ�ռ�����ֽ�
           mul dl                                ;dl==3��λ�� ���ax��ŵ��Ƕ�λ�õ��е�λ��
           sub ax,2                           ;�к����Դ��д��±�0��ʼ ����Ϊ��ż�ֽڴ���ַ� ���Լ�2
           
           add ax,bx                        ;��ʱbx�д�ŵ��������кŵ�ƫ�Ƶ�ַ
           
           mov ax,0b800h              ;�Դ濪ʼ�ĵ�ַ
           mov es,ax                        ;es�д�ŵ����Դ�ĵ�0ҳ����0--7ҳ������ʼ�Ķε�ַ
           
           mov di,0                          ;diָ���Դ��ƫ�Ƶ�ַ
           
           mov al,cl                         ;cl�Ǵ����ɫ�Ĳ�������ʱ��al�����ɫ�� ����cl������ʱ���Ҫ������ַ�
           
           mov ch,0                           ;cl��ŵ���ÿ��׼��������ַ�
s:           
           mov cl,ds:[si]                   ;ds:[si]ָ��"Welcome to masm!",0
           
           jcxz ok                               ;��clֵΪ0ʱ cx==0������ת��ok��������
           
           mov es:[bx+di],cl           ;ż��ַ����ַ�
           mov es:[bx+di+1],al
           
           inc si
           
           add di,2
           jmp short s
ok:
          pop si
          pop cx
          ret
codesg ends

end start
          
           
           
           
           