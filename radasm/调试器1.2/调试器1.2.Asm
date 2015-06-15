.386 
.model flat,stdcall 
option casemap:none 
include windows.inc 
include kernel32.inc 
include comdlg32.inc 
include user32.inc 
includelib kernel32.lib 
includelib comdlg32.lib 
includelib user32.lib 

.data 
AppName       db "Win32 Debug Example no.2",0 
ClassName     db "Notepad",0 
SearchFail    db "Cannot find the target process",0 
TargetPatched db "Target patched!",0 
buffer dw 9090h			;NOP 指令

.data? 
DBEvent DEBUG_EVENT <> 
ProcessId    dd ? 
ThreadId     dd ? 
align dword 
context CONTEXT <> 

.code 
start: 
invoke FindWindow, addr ClassName, NULL 
.if eax != NULL 
    invoke GetWindowThreadProcessId, eax, addr ProcessId 		;获取被调试进程的进程ID和线程ID
    mov ThreadId, eax 
    invoke DebugActiveProcess, ProcessId 								;将调试器捆绑到一个正在运行的进程上
    .while TRUE 
       invoke WaitForDebugEvent, addr DBEvent, INFINITE 
       .break .if DBEvent.dwDebugEventCode==EXIT_PROCESS_DEBUG_EVENT     ;.break 伪指令 调试程序退出
       .if DBEvent.dwDebugEventCode==CREATE_PROCESS_DEBUG_EVENT          ;进程被创建.当debuggee进程刚被创建(还未运行)这是我们的程序应该获得的第一个事件.
          mov context.ContextFlags, CONTEXT_CONTROL 							 ;将上下文结构成员中ContextFlags设置 为CONTEXT_CONTROL ，这样告诉GetThreadContext我们需要它去填充上下 文结构的成员中的控制寄存器。
          invoke GetThreadContext,DBEvent.u.CreateProcessInfo.hThread, addr context      ;获取指定线程的执行环境  此时debuggee线程处于挂起状态     
          ;在调用GetThreadContext函数之前，必须首先初始化CONTEXT结构的ContextFlags成员。要获得线程的所有重要的寄存器(也就是微软认为最常用的寄存器)应设置为 CONTEXT_FULL;
		  invoke WriteProcessMemory, DBEvent.u.CreateProcessInfo.hProcess, context.regEip ,addr buffer, 2, NULL
          invoke MessageBox, 0, addr TargetPatched, addr AppName, MB_OK+MB_ICONINFORMATION 
       .elseif DBEvent.dwDebugEventCode==EXCEPTION_DEBUG_EVENT 
          .if DBEvent.u.Exception.pExceptionRecord.ExceptionCode==EXCEPTION_BREAKPOINT        ;int 3断点异常
             invoke ContinueDebugEvent, DBEvent.dwProcessId,DBEvent.dwThreadId, DBG_CONTINUE  ;调试器处理异常 不交给系统默认处理 继续执行
             .continue 						;不执行底下的ContinueDebugEvent函数继续循环
          .endif 
       .endif 
       invoke ContinueDebugEvent, DBEvent.dwProcessId, DBEvent.dwThreadId, DBG_EXCEPTION_NOT_HANDLED 
    .endw 
.else 
    invoke MessageBox, 0, addr SearchFail, addr AppName,MB_OK+MB_ICONERROR 
.endif 
invoke ExitProcess, 0 
end start

