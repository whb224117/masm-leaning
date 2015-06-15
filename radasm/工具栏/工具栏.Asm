  	.386
   .model flat,stdcall
   option casemap:none
  
   include    工具栏.inc
   include    windows.inc
   include    gdi32.inc
   includelib gdi32.lib
   include    user32.inc
   includelib user32.lib
   include    kernel32.inc
   includelib kernel32.lib
   include  Comctl32.inc
   includelib  Comctl32.lib
  
.data?
   hInstance dd ?
   hWinMain  dd ?
   hMenu     dd ?
   hIcoBig   dd ?
   hIcoSmall dd ?
   hCur1     dd ?
   hCur2     dd ?
   hWinEdit  dd ?
   hWinToolbar dd ?
  
   .const
   szText1       db 'HEHE!',0      
   szCaption     db 'qwer',0      
   szClass       db 'EDIT',0
   szClassName   db 'MyClass',0
   szCaptionMain db 'My first Window !',0
   szText        db 'Win32 Assembly,Simple and powerful !',0
   szCursorFile  db '3.cur',0
   stToolbar     equ  this byte
   szToolBar     db 'ToolbarWindow32',0
   TBBUTTON <STD_FILENEW,IDM_NEW,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
   TBBUTTON <STD_FILEOPEN,IDM_OPEN,TBSTATE_ENABLED,TBSTYLE_BUTTON,0,0,-1>
   NUM_BUTTONS EQU 2
  
   .code

_Quit proc

		invoke DestroyWindow,hWinMain
		invoke PostQuitMessage,NULL
		ret

_Quit endp            
          
  
_ProcWinMain proc uses ebx edi esi,hWnd,uMsg,wParam,lParam
      local @stPs:PAINTSTRUCT
      local @stRect:RECT
      local @hDc
      
      mov eax,uMsg
      
      .if eax==WM_PAINT
          invoke BeginPaint,hWnd,addr @stPs
          mov @hDc,eax
          
          invoke GetClientRect,hWnd,addr @stRect
          invoke DrawText,@hDc,addr szText,-1,\
          addr @stRect,\
          DT_SINGLELINE or DT_CENTER or DT_VCENTER
          
          invoke EndPaint,hWnd,addr @stPs
          
       .elseif eax==WM_CREATE
          
           invoke LoadCursorFromFile,addr szCursorFile    ;加载动态图标并返回句柄
           mov hCur1,eax
          
           invoke LoadCursor,hInstance,CUR_2               ;加载图标
           mov hCur2,eax
          
           ;invoke SendMessage,hWnd,WM_COMMAND,IDM_BIG,NULL      ;向窗口发送WM_COMMAND 且wParam为IDM_BIG
           ;invoke SendMessage,hWnd,WM_COMMAND,IDM_CUR1,NULL
          
           mov eax,hWnd
           mov hWinMain,eax
           invoke CreateWindowEx,WS_EX_CLIENTEDGE,addr szClass,\
           NULL,WS_CHILD or WS_VISIBLE or ES_MULTILINE \
           or ES_WANTRETURN or WS_VSCROLL or\
           ES_AUTOHSCROLL,0,0,0,0,\
           hWnd,ID_EDIT,hInstance,NULL   ;创建工具栏
           mov hWinEdit,eax
          
           invoke CreateToolbarEx,hWinMain,WS_VISIBLE or\
           WS_CHILD or TBSTYLE_FLAT or TBSTYLE_TOOLTIPS or\
           CCS_ADJUSTABLE,ID_TOOLBAR,0,HINST_COMMCTRL,\
           IDB_STD_SMALL_COLOR,offset stToolbar,\
           NUM_BUTTONS,0,0,0,0,sizeof TBBUTTON  ;初始化工具栏
           mov hWinToolbar,eax
           ;invoke CreateWindowEx,WS_EX_TOOLWINDOW,offset szToolBar,
          
        .elseif eax==WM_COMMAND
           mov eax,wParam
           movzx eax,ax
          
           .if eax==IDM_EXIT
               call _Quit
           .elseif eax==IDM_BIG
               invoke SendMessage,hWnd,WM_SETICON,ICON_BIG,hIcoBig  ;发送WM_SETICON消息  使用句柄hIcoBig的图标对象
               invoke CheckMenuRadioItem,hMenu,\
               IDM_BIG,IDM_SMALL,IDM_BIG,MF_BYCOMMAND
           .elseif eax==IDM_SMALL
               invoke SendMessage,hWnd,WM_SETICON,ICON_BIG,hIcoSmall
               invoke CheckMenuRadioItem,hMenu,\              ; 菜单选项IDM_SMALL获得黑点
               IDM_BIG,IDM_SMALL,IDM_SMALL,MF_BYCOMMAND
           .elseif eax==IDM_CUR1
               invoke SetClassLong,hWnd,GCL_HCURSOR,hCur1   ;永久改变窗口类GCL_HCURSOR属性成hCur1  (鼠标光标)
               invoke CheckMenuRadioItem,hMenu,\
               IDM_CUR1,IDM_CUR2,IDM_CUR1,MF_BYCOMMAND
           .elseif eax==IDM_CUR2
               invoke SetClassLong,hWnd,GCL_HCURSOR,hCur2
               invoke CheckMenuRadioItem,hMenu,\
               IDM_CUR1,IDM_CUR2,IDM_CUR2,MF_BYCOMMAND
              
            .elseif eax==IDM_OPEN    ;处理工具栏
               invoke MessageBox,NULL,offset szText1,\
               offset szCaption,MB_OK  
            .endif    
                                             
       .elseif eax==WM_CLOSE
          invoke PostQuitMessage,NULL                      ;结束消息循环
        
       .else
          invoke DefWindowProc,hWnd,uMsg,wParam,lParam     ;按windows默认方式处理
          ret
       .endif
      
       xor eax,eax
       ret      
          
_ProcWinMain endp
                
                                
_WinMain proc
      local  @stWndClass:WNDCLASSEX
      local  @stMsg:MSG
      
      invoke GetModuleHandle,NULL    ;取模块句柄
      mov hInstance,eax
      
      invoke LoadMenu,hInstance,IDM_MAIN   ;加载菜单
      mov hMenu,eax

      invoke RtlZeroMemory,addr @stWndClass,sizeof @stWndClass  ;局部变量初始化，填成全0
      
     invoke LoadIcon,hInstance,ICO_MAIN   ;桌面图标
     mov @stWndClass.hIcon,eax
     invoke LoadIcon,hInstance,ICO_MAIN2   ;菜单图标
     mov @stWndClass.hIconSm,eax
    
    
     ;注册窗口类
     invoke LoadCursor,0,IDC_ARROW      ;取默认的光标句柄
     mov @stWndClass.hCursor,eax
      push hInstance
      pop @stWndClass.hInstance
      mov @stWndClass.cbSize,sizeof WNDCLASSEX
      mov @stWndClass.style,CS_HREDRAW or CS_VREDRAW
      mov @stWndClass.lpfnWndProc,offset _ProcWinMain     ;基于这个类建立的窗口的窗口过程地址，给DispatchMessage用
      mov @stWndClass.hbrBackground,COLOR_WINDOW+1
      mov @stWndClass.lpszClassName,offset szClassName
      invoke RegisterClassEx,addr @stWndClass         ;注册
      
      
      ;建立并显示窗口
      invoke CreateWindowEx,WS_EX_CLIENTEDGE,\
      offset szClassName,offset szCaptionMain,\
      WS_OVERLAPPEDWINDOW,\
      100,100,600,400,\
      NULL,hMenu,hInstance,NULL
      mov hWinMain,eax
      invoke ShowWindow,hWinMain,SW_SHOWNORMAL
      invoke UpdateWindow,hWinMain

      ;消息循环
      .while TRUE
             invoke GetMessage,addr @stMsg,NULL,0,0
             .break .if eax==0
             invoke TranslateMessage,addr @stMsg    ;键盘消息转换，扫描码-->ascii
             invoke DispatchMessage,addr @stMsg     ;消息分送
       .endw
       ret
            
_WinMain  endp
            
          
start:
    call _WinMain
    invoke ExitProcess,NULL       ;结束进程
end start