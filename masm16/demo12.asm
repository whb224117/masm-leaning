assume cs:codesg  ;codesgΪ�����
codesg segment ;�ο�ʼcs ��ʾ����� ���µ����ݾ�������ڴ����
            dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
             ;�ȸ�����ο�ʼ�������ݣ��ٷ���������� �����������ƫ�Ƶ�ַΪ16��λ���Ժ�
start:   ;����ʼ �������ǰ��dwǰ��ip=16ָ���ָ��cs:0 ��ǰ�����ݵ����봦�� �ڴ��Ժ��ip=16
            mov bx,0
            mov ax,0
            mov cx,8
s:            
            add ax,cs:[bx]         
            add bx,2
            
            loop s     
                
            mov ax,4c00h
            int 21h
;p�������� Ҳ���Խ���ѭ��loop����̨��� ǰ̨��������ʾ
codesg ends ;�ν���

end start 
;�������  ����������end end���ǳ���Ľ���λ�� Ҳ��end���ҵ�����Ŀ�ʼ���� ��Ϊstart�����޸�Ϊ�κ�ֵֻ��һ����ʶ