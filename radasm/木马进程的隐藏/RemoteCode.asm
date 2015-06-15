REMOTE_CODE_START       equ this byte

_lpLoadLibrary          dd      ?       ;导入函数地址表
_lpGetProcAddress       dd      ?
_lpGetModuleHandle      dd      ?

lpMessageBox dd ?        ;保存要使用的函数的地址
szCaption db 'A MessageBox !',0
szText db 'Hello,World !',0
_szDllUser     db    'User32.dll',0
szMessageBox db 'MessageBoxA',0  ;要使用的函数的名称(字符串)
_RemoteThread proc uses ebx edi esi lParam
local @hM
call @F
@@:
pop ebx
sub ebx,offset @B       ;
    lea eax,[ebx + offset _szDllUser]
    _invoke [ebx+_lpGetModuleHandle],eax   ;获取User32.dll模块
    mov @hM,eax
   lea esi,[ebx + offset szMessageBox]
  _invoke [ebx + _lpGetProcAddress],@hM,esi  ;获取User32.dll中MessageBoxA函数
    mov [ebx+lpMessageBox],eax  ;获取的函数地址保存
lea esi,[ebx + offset szCaption]
lea edi,[ebx + offset szText]
_invoke [ebx+lpMessageBox],NULL,edi,esi,MB_OK	;输出消息框
ret
_RemoteThread endp
REMOTE_CODE_END         equ this byte
REMOTE_CODE_LENGTH      equ offset REMOTE_CODE_END - offset REMOTE_CODE_START