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
AppName      db "Win32 Debug Example no.1",0 
ofn     OPENFILENAME <> 
FilterString db "Executable Files",0,"*.exe",0 
             db "All Files",0,"*.*",0,0 
ExitProc     db "The debuggee exits",0 
NewThread    db "A new thread is created",0 
EndThread    db "A thread is destroyed",0 
ProcessInfo  db "File Handle: %lx ",0dh,0Ah 
             db "Process Handle: %lx",0Dh,0Ah 
             db "Thread Handle: %lx",0Dh,0Ah 
             db "Image Base: %lx",0Dh,0Ah 
             db "Start Address: %lx",0 
             
.data? 
buffer       db 512 dup(?) 
startinfo STARTUPINFO <> 
pi        PROCESS_INFORMATION <> 
DBEvent   DEBUG_EVENT <> 

.code 
start: 
mov ofn.lStructSize,sizeof ofn 
mov ofn.lpstrFilter, offset FilterString 
mov ofn.lpstrFile, offset buffer 
mov ofn.nMaxFile,512 
mov ofn.Flags, OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST or OFN_LONGNAMES or OFN_EXPLORER or OFN_HIDEREADONLY 
invoke GetOpenFileName, ADDR ofn 
.if eax==TRUE 
invoke GetStartupInfo,addr startinfo 		;获取进程信息
invoke CreateProcess, addr buffer, NULL, NULL, NULL, FALSE,\ 
							DEBUG_PROCESS or DEBUG_ONLY_THIS_PROCESS,\ 
							NULL, NULL, addr startinfo, addr pi 		;加载要调试的进程把父进程的信息赋给子进程
.while TRUE 			;无限循环
   invoke WaitForDebugEvent, addr DBEvent, INFINITE 				;默认可阻塞函数 不会大量消耗CPU   等待调试事件的产生
   .if DBEvent.dwDebugEventCode==EXIT_PROCESS_DEBUG_EVENT 		;调试程序退出
       invoke MessageBox, 0, addr ExitProc, addr AppName, MB_OK + MB_ICONINFORMATION 
       .break 		;退出循环
   .elseif DBEvent.dwDebugEventCode==CREATE_PROCESS_DEBUG_EVENT ;进程被创建.当debuggee进程刚被创建(还未运行)这是我们的程序应该获得的第一个事件.
       invoke wsprintf, addr buffer, addr ProcessInfo,\			 ;在buffer中打印格式化字符串ProcessInfo
       						DBEvent.u.CreateProcessInfo.hFile, DBEvent.u.CreateProcessInfo.hProcess,\
       						DBEvent.u.CreateProcessInfo.hThread, DBEvent.u.CreateProcessInfo.lpBaseOfImage,\
       						DBEvent.u.CreateProcessInfo.lpStartAddress 
       invoke MessageBox,0, addr buffer, addr AppName, MB_OK + MB_ICONINFORMATION    
   .elseif DBEvent.dwDebugEventCode==EXCEPTION_DEBUG_EVENT 		;在debuggee中发生异常时事件发生
       .if DBEvent.u.Exception.pExceptionRecord.ExceptionCode==EXCEPTION_BREAKPOINT 		     ;int 3断点异常
          invoke ContinueDebugEvent, DBEvent.dwProcessId, DBEvent.dwThreadId, DBG_CONTINUE 	  ;调试器处理异常 不交给系统默认处理 继续执行
         .continue 
       .endif 
   .elseif DBEvent.dwDebugEventCode==CREATE_THREAD_DEBUG_EVENT ;当一个新线程在deuggee进程中创建或我们的程序首次捆绑到运行中的进程时事件发生.要注意的是当debugge的主线程被创建时不会收到该通知.
       invoke MessageBox,0, addr NewThread, addr AppName, MB_OK + MB_ICONINFORMATION 
   .elseif DBEvent.dwDebugEventCode==EXIT_THREAD_DEBUG_EVENT 	;debuggee中的线程退出时事件发生
       invoke MessageBox,0, addr EndThread, addr AppName, MB_OK+MB_ICONINFORMATION 
   .endif 
   invoke ContinueDebugEvent, DBEvent.dwProcessId, DBEvent.dwThreadId, DBG_EXCEPTION_NOT_HANDLED ;恢复由于调试事件而挂起的线程
.endw 
invoke CloseHandle,pi.hProcess 	;结束debuggee进程
invoke CloseHandle,pi.hThread 
.endif 
invoke ExitProcess, 0 
end start