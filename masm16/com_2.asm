MAN STRUCT      ;����һ���ṹ����win32�зǳ����ã�
  W  dw 1234h           ;dw Ҳ���� word
  B  db 9 dup(?)        ;db Ҳ���� byte
MAN ENDS

.model tiny     ;COM��ʽ�ļ�

.data           ;����COM��ʽ�ļ������ݶε����ݻ��Զ��ŵ�����κ�
zz  MAN <>,<1,"abcd">,<3,"Ldf">

.code           ;�����
.startup        ;��ʹ�����ָ���0100H ��ʼ��COM��ʽ�ļ�Ҫ��

    mov ax,3031h
    mov zz.W,ax         ;�Խṹ��ֵ
    mov zz.B,'1'
    mov ax,type(MAN)    ;ȡ�ṹ��ռ�ֽ���
    .exit               ;�����÷����룬�磺.EXIT 3�൱�� MOV AX,4C03H/INT 21H
    end
