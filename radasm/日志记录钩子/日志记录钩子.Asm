.386
   .model flat,stdcall
   option casemap:none
  
   include    windows.inc
   include    user32.inc
   includelib user32.lib
   include    kernel32.inc
   includelib kernel32.lib
   include 	  日志记录钩子.inc
 
            .data
   hInstance dd ?
         
          .data?
   hHook dd ? 
   hWinMain dd ?
   szAscii db 32 dup(?)
   
   .code
  
  
HookProc proc _dwCode,_wParam,_lParam   ;键盘钩子回调函数
     
       ;wParam为按键虚拟码，lParam为重复次数,扫描码和标志
      
      local @szKeyState[256]:byte
     
      invoke CallNextHookEx,hHook,_dwCode,_wParam,_lParam  ;钩子链
      pushad
     
      .if _dwCode==HC_ACTION   ;当_dwCode==HC_ACTION时，_lParam为EVENTMSG结构
      mov ebx,_lParam
      assume ebx:ptr EVENTMSG   ;ebx为EVENTMSG结构
       
        .if [ebx].message==WM_KEYDOWN  ;ID=WM_KEYDOWN，这里还可以检测别的，如：鼠标
        invoke GetKeyboardState,addr @szKeyState  ;根据键盘状态填写缓冲区
        invoke GetKeyState,VK_SHIFT   ;获取VK_shift状态  
        mov @szKeyState+VK_SHIFT,al    ;修改状态，使之不区分左右shift
        mov ecx,[ebx].paramH     ;高十六位为扫描码
        shr ecx,16
        invoke ToAscii,[ebx].paramL,ecx,addr @szKeyState,addr szAscii,0  ;判断缓冲区中按键的按放，转换成ASCII码
        ;函数返回的eax是按下的键的数量0，1，2 最多三个
        mov byte ptr szAscii[eax],0   ;根据返回字符多少，在缓冲区后加NULL
      
          .if  szAscii==0dh
          mov word ptr szAscii+1,0ah
         .endif
         invoke SendDlgItemMessage,hWinMain,IDC_TEXT,\
         EM_REPLACESEL,0,addr szAscii
        .endif
       ;assume ebx:noting
     
      .endif
      popad
      ret
     
HookProc endp 
        
 
 
 _ProcDlgMain proc uses ebx edi hWnd,wMsg,wParam,lParam
    local @dwTemp
   
    mov eax,wMsg
    .if eax==WM_CLOSE
      invoke UnhookWindowsHookEx,hHook  ;卸载日志记录钩子
      invoke EndDialog,hWnd,NULL 
     
    .elseif eax==WM_INITDIALOG
      push hWnd
      pop hWinMain
      invoke SetWindowsHookEx,WH_JOURNALRECORD,\   ;安装日志记录钩子
       HookProc,hInstance,NULL
       .if eax
           mov hHook,eax
       .elseif
           invoke EndDialog,hWnd,NULL
       
       .endif    

    .else
         mov eax,FALSE   ;表示没有处理
         ret
   
    .endif
       mov eax,TRUE     ;处理完
       ret   
   
_ProcDlgMain endp

start:
invoke GetModuleHandle,NULL
    mov hInstance,eax
invoke DialogBoxParam,eax,DLG_MAIN,\
        NULL,offset _ProcDlgMain,NULL      ;显示对话框
invoke ExitProcess,NULL
end start