REMOTE_CODE_START       equ this byte

_lpLoadLibrary          dd      ?       ;���뺯����ַ��
_lpGetProcAddress       dd      ?
_lpGetModuleHandle      dd      ?

lpMessageBox dd ?        ;����Ҫʹ�õĺ����ĵ�ַ
szCaption db 'A MessageBox !',0
szText db 'Hello,World !',0
_szDllUser     db    'User32.dll',0
szMessageBox db 'MessageBoxA',0  ;Ҫʹ�õĺ���������(�ַ���)
_RemoteThread proc uses ebx edi esi lParam
local @hM
call @F
@@:
pop ebx
sub ebx,offset @B       ;
    lea eax,[ebx + offset _szDllUser]
    _invoke [ebx+_lpGetModuleHandle],eax   ;��ȡUser32.dllģ��
    mov @hM,eax
   lea esi,[ebx + offset szMessageBox]
  _invoke [ebx + _lpGetProcAddress],@hM,esi  ;��ȡUser32.dll��MessageBoxA����
    mov [ebx+lpMessageBox],eax  ;��ȡ�ĺ�����ַ����
lea esi,[ebx + offset szCaption]
lea edi,[ebx + offset szText]
_invoke [ebx+lpMessageBox],NULL,edi,esi,MB_OK	;�����Ϣ��
ret
_RemoteThread endp
REMOTE_CODE_END         equ this byte
REMOTE_CODE_LENGTH      equ offset REMOTE_CODE_END - offset REMOTE_CODE_START