		.386
		.model flat,stdcall
		option casemap:none
		include windows.inc
		include user32.inc
		includelib user32.lib
		include kernel32.inc
		includelib kernel32.lib
		include Gdi32.inc
		includelib Gdi32.lib
		include Comdlg32.inc
		includelib Comdlg32.lib
		include Comctl32.inc
		includelib Comctl32.lib
		include 状态栏.inc
 
 
		.data?
		hInstance dd ?
		dwPos dd ?
		hdcBack dd ?
		hWinMain dd ?
		hStatus dd ?
		
		.data
		szCaption1 db 'A MessageBox !',0
		szText db 'Hello,World !',0
		szCaption2 db 'HEHE !',0
		szText1 db 'HEHE !',0
		flg dw 0
		 dWcc  dw 0
		 
		.const
		dwSwidth dd 160,240,372,-1
		szText10 db '项目1',0
		szText2 db '项目2',0
		szText3 db '项目3',0
		szPath  db '*.*',0
		szFilter db 'Text Files(*.txt)',0,'*.txt',0
		szFileName db MAX_PATH dup(?)
		szBuffer db 1024 dup(?)
		
.code
_OpenFile proc
    local @stOF:OPENFILENAME
   
    invoke RtlZeroMemory,addr @stOF,sizeof @stOF
    mov @stOF.lStructSize,sizeof @stOF
    push NULL
    pop @stOF.hwndOwner
    mov @stOF.lpstrFilter,offset szFilter   ;文件筛选字符串
    mov @stOF.lpstrFile,offset szFileName   ;路径及文件名
    mov @stOF.nMaxFile,offset MAX_PATH    ;缓冲区长度
    mov @stOF.Flags,OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST  ;标志
    invoke GetOpenFileName,addr @stOF
    .if eax
      invoke MessageBox,NULL,offset szText1,\
              offset szCaption2,MB_OK
     .endif
     ret
 _OpenFile endp           
_ProcDlgMain proc uses ebx edi hWnd,wMsg,wParam,lParam
	 local @szBuffer[128]:byte
	 local @szBuffer1[128]:byte
	 local @dwCount
	 local @sysT:SYSTEMTIME
	 local @timeSub
	 local @stPS:PAINTSTRUCT
	 local @stRect:RECT
	 local @hDc
	 local @hBrush
	 local @hBmp   
    
     mov eax,wMsg
    .if eax==WM_CLOSE
      invoke KillTimer,hWnd,ID_TIMER1 ;关闭定时器
      invoke EndDialog,hWnd,NULL      ;关闭对话框（模态，非模态用DestroyWindow函数）
   
    .elseif eax==WM_PAINT
       invoke BeginPaint,hWnd,addr @stPS  ;获取设备环境
       mov @hDc,eax
      
       invoke MoveToEx,@hDc,2,175,NULL  ;画线
       invoke LineTo,@hDc,490,175
      
       ;invoke MoveToEx,@hDc,490,20,NULL
       invoke CreatePen,PS_SOLID,2,0   ;自定义画笔，宽5，颜色白色；实线PS_SLOID
       mov @hBrush,eax
      
       invoke GetClientRect,hWnd,addr @stRect  ;取rect后赋值
       mov @stRect.left,500   ;矩形长从500->600，宽从20->170
       mov @stRect.right,600
       mov @stRect.bottom,170
       mov @stRect.top,20
       invoke FillRect,@hDc,addr @stRect,addr @hBrush  ;填充rect矩形区域
      
       invoke EndPaint,hWnd,addr @stPS
     
    .elseif eax==WM_TIMER
        mov eax,wParam
        .if eax==ID_TIMER1
        ;invoke MessageBeep,-1   ;主板发出beep声
        inc dWcc
        invoke SetDlgItemInt,hWnd,IDC_VALUE2,dWcc,FALSE  ;文本编辑框输出数值
        .endif
        invoke GetLocalTime,addr @sysT  ;取本地时间
        movzx eax,@sysT.wSecond    ;16位扩展成32位
        invoke SetDlgItemInt,hWnd,IDC_VALUE3,eax,FALSE
        
        
     
        
    .elseif eax==WM_SIZE
    invoke MoveWindow,hStatus,0,0,0,0,TRUE   ;状态栏缩放
        
    .elseif eax==WM_INITDIALOG ;初始化
      mov eax,hWnd
      mov hWinMain,eax
     
      invoke GetTickCount  ;计算时间间隔开始点
      mov @timeSub,eax
     
     
      invoke LoadIcon,hInstance,ICO_MAIN
      invoke SendMessage,hWnd,WM_SETICON,ICON_BIG,eax  ;初始化标题栏和图标
     
      invoke CheckDlgButton,hWnd,IDC_SHOWBMP,BST_CHECKED  ;初始化单选框IDC_SHOWBMP为选中状态
      invoke CheckDlgButton,hWnd,IDC_ONTOP,BST_CHECKED
      invoke CheckDlgButton,hWnd,IDC_THICKFRAME,BST_CHECKED ;初始化复选框IDC_THICKFRAME为选中状态
     
      invoke SetTimer,hWnd,ID_TIMER1,1000,NULL      ;初始化定时器
     
    
      invoke CreateStatusWindow,WS_CHILD OR WS_VISIBLE OR \
      SBARS_SIZEGRIP,NULL,hWinMain,ID_STATUSBAR      ;初始化状态栏
      mov hStatus,eax
      invoke SendMessage,hStatus,SB_SETPARTS,\
      4,offset dwSwidth   ;按dwSwidth分栏
      invoke SendMessage,hStatus,SB_SETTEXT,2,offset szText10 ;设置状态栏的文字
      invoke SendMessage,hStatus,SB_SETTEXT,0,offset szText2
      
      invoke SendDlgItemMessage,hWnd,\    ;初始化水平滚动条
             IDC_SCROLL,SBM_SETRANGE,0,100     ;设置滚动范围0到100
      
      invoke SendDlgItemMessage,hWnd,\     ;初始化列表框
      IDC_LISTBOX1,LB_ADDSTRING,0,addr szText10
      invoke SendDlgItemMessage,hWnd,\
      IDC_LISTBOX1,LB_ADDSTRING,0,addr szText2
      invoke SendDlgItemMessage,hWnd,\
      IDC_LISTBOX1,LB_ADDSTRING,0,addr szText3
     
      invoke SendDlgItemMessage,hWnd,IDC_LISTBOX2,LB_DIR,\
      DDL_ARCHIVE or DDL_DRIVES or DDL_DIRECTORY,\
      addr szPath
     
      invoke GetTickCount  ;计算时间间隔结束点 
      sub eax,@timeSub
      invoke SetDlgItemInt,hWnd,IDC_VALUE4,eax,FALSE    
   
    .elseif eax==WM_COMMAND   ;低16位为控件ID
      mov eax,wParam
        .if ax==IDOK
            invoke _OpenFile
            invoke EndDialog,hWnd,NULL
        .elseif ax==IDC_ONTOP     ;处理单选框“总在最前”
            invoke IsDlgButtonChecked,hWnd,IDC_ONTOP
            .if eax==BST_CHECKED
              invoke MessageBox,NULL,offset szText,\
              offset szCaption1,MB_OK
              invoke SendMessage,hStatus,SB_SETTEXT,1,offset szText3
            .else
              invoke MessageBox,NULL,offset szText1,\
              offset szCaption2,MB_OK
            .endif 
         .elseif ax==IDC_MODALFRAME   ;处理复选框
              invoke MessageBox,NULL,offset szText,\
              offset szCaption1,MB_OK
         .elseif ax==IDC_THICKFRAME
              invoke MessageBox,NULL,offset szText1,\
              offset szCaption2,MB_OK
         .elseif ax==IDC_LISTBOX1
              shr eax,16
              .if ax==LBN_SELCHANGE
                invoke SendMessage,lParam,LB_GETCURSEL,0,0  ;获取单选列表选中项
                lea ecx,@szBuffer
                invoke SendMessage,lParam,LB_GETTEXT,eax,ecx  ;选中项的字符串传入buffer
                invoke MessageBox,NULL,addr @szBuffer,\
                 offset szCaption2,MB_OK
              .endif
         .elseif ax==IDC_LISTBOX2
              shr eax,16
              .if ax==LBN_SELCHANGE
               
                invoke SendDlgItemMessage,hWnd,IDC_LISTBOX2,LB_GETSELCOUNT,0,0  ;获取多选列表选中项个数
               
                mov @dwCount,eax
                invoke SendDlgItemMessage,hWnd,IDC_LISTBOX2,LB_GETSELITEMS,128/4,addr @szBuffer ;返回全部选中索引到缓冲区
                lea esi,@szBuffer
                .while @dwCount
                   lodsd          ;DS:ESI 的指向地址的数据放到eax中
                   lea ecx,@szBuffer1
                   invoke SendDlgItemMessage,hWnd,IDC_LISTBOX2,LB_GETTEXT,eax,ecx  ;某一项的字符串传入buffer1
                   invoke MessageBox,NULL,addr @szBuffer1,\
                   offset szCaption2,MB_OK
                   dec @dwCount
                 .endw
              .endif
        
         .endif
   
       
        
        
    .elseif eax==WM_HSCROLL  ;处理滚动条
          mov eax,wParam
          .if ax==SB_LINELEFT
           dec dwPos
          .elseif ax==SB_LINERIGHT
           inc dwPos
          .elseif ax==SB_PAGELEFT
           sub dwPos,10
          .elseif ax==SB_PAGERIGHT
           add dwPos,10
          .elseif ax==SB_THUMBPOSITION||AX==SB_THUMBTRACK
           mov eax,wParam   ;高16位为当前为当前位置，低16位为动作码
           shr eax,16
           mov dwPos,eax
          .else
             mov eax,TRUE
             ret
          .endif
         
          cmp dwPos,0
          jge @F
          mov dwPos,0
          @@:
          cmp dwPos,100
          jle @F
          mov dwPos,100
          @@:
          invoke SetDlgItemInt,hWnd,IDC_VALUE,dwPos,FALSE  ;文本编辑框输出数值
          invoke SendDlgItemMessage,hWnd,\
          IDC_SCROLL,SBM_SETPOS,dwPos,TRUE   ;滚动条设置位置
         
                
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
invoke DialogBoxParam,hInstance,DLG_MAIN,\
        NULL,offset _ProcDlgMain,NULL      ;显示对话框
invoke ExitProcess,NULL
end start