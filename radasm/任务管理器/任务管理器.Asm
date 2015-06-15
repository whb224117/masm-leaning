			.386
			.model flat,stdcall
		option casemap:none
		include 任务管理器.inc
		include windows.inc
		include user32.inc
		includelib user32.lib
		include kernel32.inc
		includelib kernel32.lib
		
			.data?
		hInstance dd ?
		hWinList  dd ?
		
			.const
		szErrTerminate db '无法结束该进程',0
		
			.code
_GetProcessList proc _hWnd
      
       local @stProcess:PROCESSENTRY32    ;数据结构
       local @hSnapShot
      
       invoke RtlZeroMemory,addr @stProcess,sizeof @stProcess ;结构清零
       invoke SendMessage,hWinList,LB_RESETCONTENT,0,0		  ;删除一个列表框中的所有项
       mov @stProcess.dwSize,sizeof @stProcess
       invoke CreateToolhelp32Snapshot,TH32CS_SNAPPROCESS,0   ;获取进程快照句柄
       mov @hSnapShot,eax
       invoke Process32First,@hSnapShot,addr @stProcess       ;第一个进程放入结构中
      
       .while eax
              invoke SendMessage,hWinList,LB_ADDSTRING,\
                     0,addr @stProcess.szExeFile    ;hWinlist中显示进程的名称（添加项目）
              invoke SendMessage,hWinList,LB_SETITEMDATA,eax,\
                     @stProcess.th32ProcessID       ;hWinlist添加进程的ID（赋值）
              invoke Process32Next,@hSnapShot,addr @stProcess  ;下一个进程放入结构中，没有返回false
       .endw    
       invoke CloseHandle,@hSnapShot    ; 关闭快照句柄
       
       ;灰化IDOK按钮
       invoke GetDlgItem,_hWnd,IDOK
       invoke EnableWindow,eax,FALSE    
       ret
              
_GetProcessList endp
_ProcDlgMain proc uses ebx edi hWnd,wMsg,wParam,lParam
   
   
     mov eax,wMsg
    .if eax==WM_CLOSE
      invoke EndDialog,hWnd,NULL 
     
    .elseif eax==WM_INITDIALOG
    	;设置图标
      invoke LoadIcon,hInstance,ICO_MAIN
      invoke SendMessage,hWnd,WM_SETICON,ICON_BIG,eax
      
      ;获取list_box的句柄
      invoke GetDlgItem,hWnd,IDC_PROCESS 
      mov hWinList,eax
      
      ;把进程显示到list_box中
      invoke _GetProcessList,hWnd              
   
    .elseif eax==WM_COMMAND   ;低16位为控件ID
      mov eax,wParam
        .if ax==IDOK		;低16位是列表框的ID
         
            invoke SendMessage,hWinList,LB_GETCURSEL,0,0   			;获取选中项到eax
            invoke SendMessage,hWinList,LB_GETITEMDATA,eax,0     	;获取选中项的值，即进程ID
            invoke OpenProcess,PROCESS_TERMINATE,FALSE,eax   		;打开进程 PROCESS_TERMINATE 允许关闭进程
                .if eax											;打开进程成功
                   mov ebx,eax
                   invoke TerminateProcess,ebx,-1  	;关闭该进程
                   invoke CloseHandle,ebx     			;销毁打开进程句柄
                   invoke Sleep,200							;休息200毫秒
                   invoke _GetProcessList,hWnd			;刷新进程列表
                   jmp @F
                 .endif
                 	;打开进程失败
            invoke MessageBox,hWnd,addr szErrTerminate,\
                   NULL,MB_OK or MB_ICONWARNING
             @@:
          .elseif ax==IDC_REFRESH
                   invoke _GetProcessList,hWnd
          .elseif ax==IDC_PROCESS
                   shr eax,16   								;高十六位为通知码
                   .if ax==LBN_SELCHANGE   				;选项改变
                       invoke GetDlgItem,hWnd,IDOK
                       invoke EnableWindow,eax,TRUE  	;IDOK按钮可用
                   .endif
          .endif
   
    .else
         mov eax,FALSE  
         ret
   
    .endif
       mov eax,TRUE    
       ret   
   
_ProcDlgMain endp
start:
	invoke GetModuleHandle,NULL	;获取当前实例句柄
	mov hInstance,eax
	invoke DialogBoxParam,hInstance,DLG_MAIN,\
	        NULL,offset _ProcDlgMain,NULL      ;显示对话框
	invoke ExitProcess,NULL
end start