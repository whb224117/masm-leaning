;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.386
		.model flat,stdcall
		option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include �ļ�����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		  windows.inc
include		  user32.inc
includelib	  user32.lib
include		  kernel32.inc
includelib	  kernel32.lib
include       comctl32.inc
includelib    comctl32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����IDֵ
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
IDI_TEST        equ          106h			;ͼ��
IDD_DLGMAIN     equ          107h			;�Ի���
IDI_SMALL       equ          108h			;ͼ��
IDC_GETWINDOWS  equ          1000h			;��ȡ����
IDC_FLUSH       equ          1001h			;ˢ��
IDC_SHOWMSG     equ          1002h			;ListView


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ���ݶ�
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
szhWnd          db  "���ھ��", 0
szWndDir        db  "������Ӵ���", 0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; �����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		            .code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;��ʼ���Ի����б�ؼ�
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_InitMainDlgListView  proc uses ebx edi esi
;���߱���������ӳ���Ҫ�õ��⼸���Ĵ���,��Ҫ����ͻָ�,�������ͻ��Զ����ɱ���ͻָ��Ĵ���,push/pop
                local    @lvc:LV_COLUMN	
                local    lvm:LV_ITEM  

                mov     eax, LVS_EX_FULLROWSELECT or LVS_EX_HEADERDRAGDROP or LVS_EX_GRIDLINES 
				;����ѡ��
                invoke  SendMessage, hListView, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, eax	;����ListView��ʽ

                mov     @lvc.imask, LVCF_TEXT or LVCF_WIDTH 
                mov     @lvc.pszText, offset szWndDir
                mov     @lvc.lx, 300
                invoke  SendMessage, hListView, LVM_INSERTCOLUMN, 0, addr @lvc			;��һ��
                
                or      @lvc.imask, LVCF_FMT
                mov     @lvc.fmt, LVCFMT_RIGHT			;�Ҷ���
                mov     @lvc.pszText, offset szhWnd 		;���еı�ͷ��
                mov     @lvc.lx, 80						;���е����ؿ��
                invoke  SendMessage, hListView, LVM_INSERTCOLUMN, 1, addr @lvc          ;�ڶ���  
                
                                
                or      @lvc.imask, LVCF_FMT
                mov     @lvc.fmt, LVCFMT_RIGHT
                mov     @lvc.pszText, offset szhWnd 
                mov     @lvc.lx, 60
                invoke  SendMessage, hListView, LVM_INSERTCOLUMN, 2, addr @lvc        ;������                                         
                ret
_InitMainDlgListView endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
EunmWndProc     proc    hWnd:DWORD, lParam:DWORD
                local    lvm:LV_ITEM 
                local   @szBuffer[256]:byte
                local   @szhWnd[32]:byte
				
                invoke  RtlZeroMemory, addr @szBuffer, lengthof @szBuffer		;����������
                invoke	IsWindowVisible,hWnd 		;���ڵĿ���״̬
                .if     eax != 0		
                        invoke  GetWindowText, hWnd, addr @szBuffer, sizeof @szBuffer
						;�����ڵı������ı���������ڣ�������һ���������ڡ����ָ���Ĵ�����һ���ؼ����򿽱��ؼ����ı�
                        .if eax == 0			;�������سɹ������ַ�������
                            mov eax, 1
                            ret
                        .endif
                        invoke	RtlZeroMemory,addr lvm,sizeof lvm
                        mov	lvm.imask,LVIF_TEXT or LVIF_PARAM or LVIF_IMAGE		;�ṹ��Ա����λ
                        mov eax, wndCount
                        mov lvm.iItem, eax			;����������
                        mov	lvm.lParam,0			;�������ص�32λ��
                        mov	lvm.iSubItem,0			;�ӱ���������
                        lea eax, @szBuffer			;�������ı�
                        mov lvm.pszText, eax
;                        mov	lvm.pszText,addr @szBuffer
                        invoke	SendMessage,hListView,LVM_INSERTITEM, wndCount,addr lvm		;��Ӵ�������
                           
                        invoke  RtlZeroMemory, addr @szhWnd, lengthof @szhWnd                                               
                        invoke wsprintf, addr @szhWnd, addr szHandForMat, hWnd			;���ھ��
                        inc lvm.iSubItem
                        lea eax, @szhWnd
                        mov lvm.pszText, eax
;                        mov lvm.pszText, addr @szhWnd
                        invoke	SendMessage,hListView,LVM_SETITEMTEXT, wndCount,addr lvm 	;��Ӵ��ھ��
                        inc     wndCount					;ÿ�μ�һ
                .endif
                mov     eax, 1		;һֱ����TRUE ����ֱ��ö����Ž���
                ret
EunmWndProc     endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
DlgMain         proc    hDlg:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
                mov     eax, uMsg
                
                .if     eax == WM_COMMAND
                        mov  eax, wParam
                        .if  eax == IDCANCEL				;ȡ��
                             invoke ExitProcess, eax
                        .elseif eax == IDC_GETWINDOWS		;��ȡ����
                             xor eax, eax
                             mov wndCount, eax
                             invoke  SendMessage, hListView, LVM_DELETEALLITEMS, 0, 0		;ɾ�������б���Ŀ
                             invoke  EnumWindows, EunmWndProc, NULL
							;�ú���ö��������Ļ�ϵĶ��㴰�ڣ��������ھ�����͸�Ӧ�ó�����Ļص�������
							;�ص���������FALSE��ֹͣö�٣�����EnumWindows�������������ж��㴰��ö����Ϊֹ
							;BOOL EnumWindows(WNDENUMPROC lpEnumFunc,LPARAM lParam)
							;lpEnumFunc��ָ��һ��Ӧ�ó�����Ļص�����ָ��,��ο�EnumWindowsProc
							;lPararm��ָ��һ�����ݸ��ص�������Ӧ�ó�����ֵ
							;�ص�����ԭ��	BOOL CALLBACK EnumWindowsProc(HWND hwnd,LPARAM lParam);
							;hwnd�����㴰�ڵľ��   lparam��Ӧ�ó������һ��ֵ(��EnumWindows��lParam)
                        .elseif eax == IDC_FLUSH			;ˢ��
                             invoke  SendMessage, hListView, LVM_DELETEALLITEMS, 0, 0
                             xor eax, eax
                             mov wndCount, eax
                             invoke  SendMessage, hDlg, WM_COMMAND, IDC_GETWINDOWS, NULL
                        .endif
                ;��ʼ���Ի���
                .elseif eax == WM_INITDIALOG
                        invoke  GetDlgItem, hDlg, IDC_SHOWMSG		;��ȡListView�ؼ����
                        mov     hListView, eax
				;��ʼ���б�ؼ�
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
