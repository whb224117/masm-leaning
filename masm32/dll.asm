 .386
        .model flat,stdcall
        option casemap:none
;link subsystem:windows /dll /def:dll.def
include windows.inc

        .code
;DllEntry�Ƕ�̬���ӿ����ڣ�����̬���ӿⱻ����/ж��ʱ����ͬһ���̵��߳�����/�˳�ʱ��������ø���ں���
;��Ȼ����������һ�������������Ҫ������End DllEntry����һ�¡�
DllEntry proc hInstDLL:HINSTANCE, reason:DWORD, reserved1:DWORD 
         mov  eax,TRUE  ;������FALSE����̬���ӿ�Ͳ��������
         ret 
DllEntry Endp 

;��EDX:EAX�е�ֵת����ʮ���������ʽ�ַ���������Ϥ�ɣ�ǰ����������еģ�
OutEdxEax proc \            ;���磺EDX=0,EAX=01234567H,��ת������ַ���Ϊ��
  uses ebx esi edi,lpString ;        -> '19088743',0
        mov edi,lpString    ;ָ���Ž���ĵ�ַ
        mov esi,lpString

        mov ecx,10          ;ת����ʮ����
        .while eax!=0 || edx!=0
            push eax    
            mov eax,edx
            xor edx,edx
            div ecx
            mov ebx,eax
            pop eax
            div ecx
            add dl,'0'      
            mov [edi],dl    ;��Ž��
            inc edi
            mov edx,ebx
        .endw

        mov BYTE ptr [edi],0;�ַ�����0Ϊ��β
        dec edi

        .while edi>esi      ;���ǰ��󣬺��ǰ��
            mov al,[esi]
            xchg al,[edi]
            mov [esi],al
            inc esi
            dec edi
        .endw
        ret
OutEdxEax endp
          end DllEntry
