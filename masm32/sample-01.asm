;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.386
		.model flat,stdcall
		option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		  windows.inc
include		  user32.inc
includelib	  user32.lib
include		  kernel32.inc
includelib	  kernel32.lib
include       comctl32.inc
includelib    comctl32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;定义ID值
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
IDI_TEST        equ          106h			;图标
IDD_DLGMAIN     equ          107h			;对话框
IDI_SMALL       equ          108h			;图标
IDC_GETWINDOWS  equ          1000h			;获取窗口
IDC_FLUSH       equ          1001h			;刷新
IDC_SHOWMSG     equ          1002h			;ListView


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.data
wndCount        dd  0
szBuffer	    db	256 dup (?)
hInstance       dd  ?
hListView       dd  ?


		.const
szError         db  'error', 0
szStart		    db	'Press OK to start SendMessage, param: %08x!',0
szWndName       db  'sample-01', 0
szText		    db	'Text send to other windows',0
szHello         db  'hello, world', 0
szNotFound	    db	'Receive Message Window not found!',0
szHandForMat    db  '%08x', 0 
szhWnd          db  "窗口句柄", 0
szWndDir        db  "桌面可视窗口", 0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		            .code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;初始主对话框列表控件
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_InitMainDlgListView  proc uses ebx edi esi
;告诉编译器这个子程序要用到这几个寄存器,需要保存和恢复,编译器就会自动生成保存和恢复的代码,push/pop
                local    @lvc:LV_COLUMN	
                local    lvm:LV_ITEM  

                mov     eax, LVS_EX_FULLROWSELECT or LVS_EX_HEADERDRAGDROP or LVS_EX_GRIDLINES 
				;多行选择
                invoke  SendMessage, hListView, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, eax	;设置ListView样式

                mov     @lvc.imask, LVCF_TEXT or LVCF_WIDTH 
                mov     @lvc.pszText, offset szWndDir
                mov     @lvc.lx, 300
                invoke  SendMessage, hListView, LVM_INSERTCOLUMN, 0, addr @lvc			;第一列
                
                or      @lvc.imask, LVCF_FMT
                mov     @lvc.fmt, LVCFMT_RIGHT			;右对齐
                mov     @lvc.pszText, offset szhWnd 		;表列的表头名
                mov     @lvc.lx, 80						;表列的像素宽度
                invoke  SendMessage, hListView, LVM_INSERTCOLUMN, 1, addr @lvc          ;第二列  
                
                                
                or      @lvc.imask, LVCF_FMT
                mov     @lvc.fmt, LVCFMT_RIGHT
                mov     @lvc.pszText, offset szhWnd 
                mov     @lvc.lx, 60
                invoke  SendMessage, hListView, LVM_INSERTCOLUMN, 2, addr @lvc        ;第三列                                         
                ret
_InitMainDlgListView endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
EunmWndProc     proc    hWnd:DWORD, lParam:DWORD
                local    lvm:LV_ITEM 
                local   @szBuffer[256]:byte
                local   @szhWnd[32]:byte
				
                invoke  RtlZeroMemory, addr @szBuffer, lengthof @szBuffer		;缓冲区清零
                invoke	IsWindowVisible,hWnd 		;窗口的可视状态
                .if     eax != 0		
                        invoke  GetWindowText, hWnd, addr @szBuffer, sizeof @szBuffer
						;将窗口的标题条文本（如果存在）拷贝到一个缓存区内。如果指定的窗口是一个控件，则拷贝控件的文本
                        .if eax == 0			;函数返回成功就是字符串个数
                            mov eax, 1
                            ret
                        .endif
                        invoke	RtlZeroMemory,addr lvm,sizeof lvm
                        mov	lvm.imask,LVIF_TEXT or LVIF_PARAM or LVIF_IMAGE		;结构成员屏蔽位
                        mov eax, wndCount
                        mov lvm.iItem, eax			;表项索引号
                        mov	lvm.lParam,0			;与表项相关的32位数
                        mov	lvm.iSubItem,0			;子表项索引号
                        lea eax, @szBuffer			;表项名文本
                        mov lvm.pszText, eax
;                        mov	lvm.pszText,addr @szBuffer
                        invoke	SendMessage,hListView,LVM_INSERTITEM, wndCount,addr lvm		;添加窗口名称
                           
                        invoke  RtlZeroMemory, addr @szhWnd, lengthof @szhWnd                                               
                        invoke wsprintf, addr @szhWnd, addr szHandForMat, hWnd			;窗口句柄
                        inc lvm.iSubItem
                        lea eax, @szhWnd
                        mov lvm.pszText, eax
;                        mov lvm.pszText, addr @szhWnd
                        invoke	SendMessage,hListView,LVM_SETITEMTEXT, wndCount,addr lvm 	;添加窗口句柄
                        inc     wndCount					;每次加一
                .endif
                mov     eax, 1		;一直返回TRUE 所以直到枚举完才结束
                ret
EunmWndProc     endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DlgMain         proc    hDlg:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
                mov     eax, uMsg
                
                .if     eax == WM_COMMAND
                        mov  eax, wParam
                        .if  eax == IDCANCEL				;取消
                             invoke ExitProcess, eax
                        .elseif eax == IDC_GETWINDOWS		;获取窗口
                             xor eax, eax
                             mov wndCount, eax
                             invoke  SendMessage, hListView, LVM_DELETEALLITEMS, 0, 0		;删除所有列表项目
                             invoke  EnumWindows, EunmWndProc, NULL
							;该函数枚举所有屏幕上的顶层窗口，并将窗口句柄传送给应用程序定义的回调函数。
							;回调函数返回FALSE将停止枚举，否则EnumWindows函数继续到所有顶层窗口枚举完为止
							;BOOL EnumWindows(WNDENUMPROC lpEnumFunc,LPARAM lParam)
							;lpEnumFunc：指向一个应用程序定义的回调函数指针,请参看EnumWindowsProc
							;lPararm：指定一个传递给回调函数的应用程序定义值
							;回调函数原型	BOOL CALLBACK EnumWindowsProc(HWND hwnd,LPARAM lParam);
							;hwnd：顶层窗口的句柄   lparam：应用程序定义的一个值(即EnumWindows中lParam)
                        .elseif eax == IDC_FLUSH			;刷新
                             invoke  SendMessage, hListView, LVM_DELETEALLITEMS, 0, 0
                             xor eax, eax
                             mov wndCount, eax
                             invoke  SendMessage, hDlg, WM_COMMAND, IDC_GETWINDOWS, NULL
                        .endif
                ;初始化对话框
                .elseif eax == WM_INITDIALOG
                        invoke  GetDlgItem, hDlg, IDC_SHOWMSG		;获取ListView控件句柄
                        mov     hListView, eax
				;初始化列表控件
                        invoke _InitMainDlgListView               
                .endif
                xor     eax, eax
                ret
DlgMain         endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	

	
	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

start:
                invoke  InitCommonControls
                invoke  GetModuleHandleA, NULL
                .if     eax != 0
                        mov hInstance, eax
                .elseif 
                        invoke MessageBox, NULL, addr szError, addr szError, MB_OK
                .endif
                invoke  DialogBoxParam, hInstance, IDD_DLGMAIN, NULL, offset DlgMain, NULL

                invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                end	start
