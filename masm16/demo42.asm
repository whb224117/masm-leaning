assume cs:codesg

codesg segment

start : 
          mov ax,1
          mov cx,3
          call s    
          ; call  s�ĺ��壺 push cs:ip  ����ǰ��ipѹ��վ     jmp  s ��ת��s��ַ  
          ;��ѹ��վ����mov bx,ax ����ָ���ƫ�Ƶ�ַ ��Ϊ��call sִ����ɺ�ipָ��movbx, ax����ָ��
          mov bx,ax
          mov ax,4c00h
          int 21h
s : 
         add ax,ax
         loop s
         ret 
codesg ends

end start

;call di �� call dword ptr [di]���ǶԵģ������ܣ��������һ����
;call di��˵�����õ��ӳ�������ƫ�Ƶ�ַ=di��ֵ���ε�ַCS���䣨���ڵ��ã���
;call dword ptr [di]��˵�����õ��ӳ������ڵġ�ƫ�Ƶ�ַ��������ڴ浥ԪDS:{di]�У����䡰�ε�ַ�������DS:[di+2]�У����Ƕμ���á�
