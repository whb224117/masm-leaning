
		.386
		.model flat,stdcall
		option casemap:none
		
		include         windows.inc
		include         user32.inc
		includelib      user32.lib
		include         kernel32.inc
		includelib      kernel32.lib

		.const
		szMsg           db  '异常发生位置：%08X，异常代码：%08X，标志：%08X',0
		szSafe          db  '回到了安全的地方!',0
		szCaption       db  '筛选器异常处理的例子',0
 
       .code
 
_Handler    proc        _lpExceptionPoint
        local   @szBuffer[256]:byte
        pushad
        mov     esi,_lpExceptionPoint
        assume  esi:ptr EXCEPTION_POINTERS   ;指向EXCEPTION_POINTERS结构
        mov     edi,[esi].ContextRecord
        mov     esi,[esi].pExceptionRecord
        assume  esi:ptr EXCEPTION_RECORD,edi:ptr CONTEXT 
        invoke  wsprintf,addr @szBuffer,addr szMsg,\
                     [edi].regEip,[esi].ExceptionCode,[esi].ExceptionFlags   ;格式化输出
       invoke  MessageBox,NULL,addr @szBuffer,NULL,MB_OK
       mov     [edi].regEip,offset _SafePlace    ;重新定义返回地址到offset _SafePlace
       assume  esi:nothing,edi:nothing
       popad
       mov     eax,EXCEPTION_CONTINUE_EXECUTION  ;返回eax (函数遇到EXCEPTION_CONTINUE_EXECUTION会把CONTEXT设置回去并继续执行)
       ret
_Handler    endp
 
start:
       invoke  SetUnhandledExceptionFilter,addr _Handler  ;产生异常就执行_Handler
       xor     eax,eax
       mov     dword ptr [eax],0 ;产生异常，然后_Handler被调用
 
; 如果这中间有指令，这些指令将不会被执行!

_SafePlace:
       invoke   MessageBox,NULL,addr szSafe,addr szCaption,MB_OK
       invoke  ExitProcess,NULL
       
end     start