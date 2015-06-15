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
AppName 				db "Win32 Debug Example no.4",0 
ofn OPENFILENAME <> 
FilterString 		db "Executable Files",0,"*.exe",0 
             		db "All Files",0,"*.*",0,0 
ExitProc 			db "The debuggee exits",0Dh,0Ah 
         			db "Total Instructions executed : %lu",0 
TotalInstruction 	dd 0
incFormat			db '%d',0

.data? 
buffer 				db 512 dup(?) 
startinfo 			STARTUPINFO 	<> 
pi 					PROCESS_INFORMATION 	<> 
DBEvent 				DEBUG_EVENT 	<> 
context 				CONTEXT 	<>
incData           dw ?
incBuf            db 10 dup(?)

.code 
start: 
mov ofn.lStructSize,SIZEOF ofn 
mov ofn.lpstrFilter, OFFSET FilterString 
mov ofn.lpstrFile, OFFSET buffer 
mov ofn.nMaxFile,512 
mov ofn.Flags, OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY 
invoke GetOpenFileName, ADDR ofn 
.if eax==TRUE 
    invoke GetStartupInfo,addr startinfo 			;获取一个进程的启动信息
    invoke CreateProcess, addr buffer, NULL, NULL, NULL, FALSE, DEBUG_PROCESS+ DEBUG_ONLY_THIS_PROCESS,
    								NULL, NULL, addr startinfo, addr pi      ;加载要调试的进程把父进程的信息赋给子进程
    .while TRUE 
    	 mov incData,0
       invoke WaitForDebugEvent, addr DBEvent, INFINITE 
       .if DBEvent.dwDebugEventCode==EXIT_PROCESS_DEBUG_EVENT 			;退出
          invoke wsprintf, addr buffer, addr ExitProc, TotalInstruction 
          invoke MessageBox, 0, addr buffer, addr AppName, MB_OK+MB_ICONINFORMATION 
          .break 
       .elseif DBEvent.dwDebugEventCode==EXCEPTION_DEBUG_EVENT        ;异常   
       		.if DBEvent.u.Exception.pExceptionRecord.ExceptionCode==EXCEPTION_BREAKPOINT  ;int 3断点
             	mov context.ContextFlags, CONTEXT_CONTROL 
             	invoke GetThreadContext, pi.hThread, addr context 		 ;获取控制器的信息	
					;在调用GetThreadContext函数之前，必须首先初始化CONTEXT结构的ContextFlags成员。要获得线程的所有重要的寄存器(也就是微软认为最常用的寄存器)应设置为 CONTEXT_FULL;  CONTEXT_CONTROL控制寄存器
             	 or context.regFlag,100h                               ;设置标志寄存器映象的陷阱位(第8位)
             	invoke SetThreadContext,pi.hThread, addr context 
             	invoke ContinueDebugEvent, DBEvent.dwProcessId, DBEvent.dwThreadId, DBG_CONTINUE 
             	.continue 			;跳过 下面代码 继续循环
       		 .elseif DBEvent.u.Exception.pExceptionRecord.ExceptionCode==EXCEPTION_SINGLE_STEP 
             	inc TotalInstruction 
             	invoke GetThreadContext,pi.hThread,addr context 
             	or context.regFlag,100h 										;设置标志寄存器映象的陷阱位(第8位) 以后每次都会发生EXCEPTION_SINGLE_STEP异常
             	inc incData
             	invoke wsprintf,offset incBuf,offset incFormat,incData
             	invoke MessageBox,NULL,offset incBuf,NULL,MB_OK
             	invoke SetThreadContext,pi.hThread, addr context 
             	invoke ContinueDebugEvent, DBEvent.dwProcessId, DBEvent.dwThreadId,DBG_CONTINUE 
             	.continue 			;跳过 下面代码 继续循环
          	.endif 
       .endif 
       invoke ContinueDebugEvent, DBEvent.dwProcessId, DBEvent.dwThreadId, DBG_EXCEPTION_NOT_HANDLED 
    .endw 
.endif 
invoke CloseHandle,pi.hProcess 
invoke CloseHandle,pi.hThread 
invoke ExitProcess, 0 
end start