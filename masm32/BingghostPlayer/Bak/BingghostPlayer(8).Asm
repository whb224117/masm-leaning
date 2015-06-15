			.586
			.model flat,stdcall
			option casemap:none
include BingghostPlayer.Inc
include BrowseFolder.asm
include Player.asm
include  Initialize.asm
include     SkinH.Inc
includelib SkinH.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;Code Segment
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			.code					
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;关闭设备
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Close	proc
	
	.if stMciOpen.wDeviceID
		invoke mciSendCommand,stMciOpen.wDeviceID,MCI_CLOSE,NULL,NULL
	.endif
	ret

_Close endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;打开设备
;lpFileName-当前打开的音频文件路径
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Open proc lpFileName:DWORD
	.if	stMciOpen.wDeviceID
	invoke _Close
	.endif
	;初始化结构
	mov	stMciOpen.lpstrDeviceType,L("MPEGVideo")
	mov	eax,lpFileName
	mov	stMciOpen.lpstrElementName,eax
	invoke 	mciSendCommand,0,MCI_OPEN,MCI_OPEN_ELEMENT or MCI_OPEN_TYPE,addr stMciOpen
	;如果打开成功-返回0否则是其他值
	.if	eax == 0
		mov	eax,TRUE
	.else
		mov eax,FALSE
	.endif
	ret

_Open endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;播放MCI-------
;hWnd为回调窗口句柄
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Play	proc hWnd:DWORD
	LOCAL	@stMciPlay:MCI_PLAY_PARMS
	
	mov	eax,stMciOpen.wDeviceID
	mov	hDevice,eax
	push	hWinMain
	pop	@stMciPlay.dwCallback
	invoke	mciSendCommand,hDevice,MCI_PLAY,MCI_NOTIFY,addr @stMciPlay
	.if	eax == 0
		;播放成功-设置按钮为暂停播放
		invoke	SetDlgItemText,hWinMain,IDC_PLAY,L("暂停")
		;查询歌曲长度
		invoke	_QueryLength
		mov	szMusicLength,eax
		invoke	_SetVolume,dwPosSound
	.else
		invoke	MessageBox,hWinMain,L("无法播放此文件"),L("错误"),MB_OK	
	.endif
	ret

_Play endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;停止设备
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Stop	proc
;*****************************************************************************************
;	@stMciStop:MCI_GENERIC_PARMS
;	
;	mov	eax,hWinMain
;	mov	@stMciStop.dwCallback,eax
;	invoke mciSendCommand,hDevice,MCI_STOP,MCI_NOTIFY,addr @stMciStop
;*****************************************************************************************
	.if	hDevice
		invoke	mciSendCommand,stMciOpen.wDeviceID,MCI_STOP,NULL,NULL
	.endif
	;不能改变4~32位的数据
	mov	dwOption,0
	or	dwOption,F_START
	invoke	SetDlgItemText,hWinMain,IDC_PLAY,L("播放")
	invoke	SetDlgItemText,hWinMain,MUSIC_TIME,L("00:00")
	invoke	SetDlgItemText,hWinMain,MUSIC_LENGTH,L("00:00")
	invoke 	SendMessage,hPlayProgress,TBM_SETPOS,TRUE,0
	ret

_Stop endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;暂停设备-恢复设备
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_Pasue	proc
	
	.if	hDevice
		invoke	mciSendCommand,hDevice,MCI_PAUSE,NULL,NULL
		invoke	_QueryPosition
		mov	dwCurrentTime,eax
		invoke	SetDlgItemText,hWinMain,IDC_PLAY,L("播放")
	.endif
	ret

_Pasue endp

;_ReStart
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;检测设备状态
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_QueryPosition	proc
	LOCAL	@stMciStatus:MCI_STATUS_PARMS
	
	mov	@stMciStatus.dwItem,MCI_STATUS_POSITION
	invoke 	mciSendCommand,hDevice,MCI_STATUS,MCI_STATUS_ITEM,addr @stMciStatus
	mov	eax,@stMciStatus.dwReturn
	ret

_QueryPosition endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;检测时间长度
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_QueryLength	proc
	LOCAL	@stMciStatus:MCI_STATUS_PARMS
	
	mov	@stMciStatus.dwItem,MCI_STATUS_LENGTH
	invoke	mciSendCommand,hDevice,MCI_STATUS,MCI_STATUS_ITEM,addr @stMciStatus
	mov	eax,@stMciStatus.dwReturn
	
	ret

_QueryLength endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:显示歌曲的总时间
;参数:当前播放的时间
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ShowTime	proc _szNowMusic:DWORD
	LOCAL	@dwMin:DWORD
	LOCAL	@dwSecond:DWORD

	mov	eax,_szNowMusic
	;微秒转秒
	mov	edx,0
	mov	ecx,1000
	div	ecx
	;秒转换成分钟
	mov 	edx,0
	mov	ecx,60
	div	ecx
	mov	@dwMin,eax
	mov	@dwSecond,edx
	;时间格式化
	invoke	RtlZeroMemory,addr szTimeBuffer,sizeof szTimeBuffer
	invoke	wsprintf,addr szTimeBuffer,L("00:%d:%d"),@dwMin,@dwSecond
	ret

_ShowTime endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;重新播放
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ReplayMusic	proc
	LOCAL	@stMciPlay:MCI_PLAY_PARMS
	invoke	_QueryPosition
	mov	@stMciPlay.dwFrom,eax
	invoke	mciSendCommand,hDevice,MCI_PLAY,MCI_FROM,addr @stMciPlay
	ret

_ReplayMusic endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;获取音频文件
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_GetFileName	proc 
		
		invoke	RtlZeroMemory,addr szBuffer ,sizeof szBuffer 
		invoke	RtlZeroMemory,addr stOpenFileName,sizeof stOpenFileName
		mov	stOpenFileName.Flags,OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST 
		mov	stOpenFileName.lStructSize,SIZEOF stOpenFileName 
		mov	eax,hWinMain 
		mov	stOpenFileName.hWndOwner,eax 
		mov	stOpenFileName.lpstrFilter,offset szFilter	;扩展名 
		mov	stOpenFileName.lpstrFile,offset szBuffer	;文件名缓冲 
		mov	stOpenFileName.nMaxFile,255			;文件名缓冲长度 
		mov	stOpenFileName.lpstrInitialDir,0 
		mov	stOpenFileName.lpstrTitle,offset szTitleSave 
		mov	stOpenFileName.lpstrDefExt,offset szExt 
		invoke	GetOpenFileName,offset stOpenFileName 
		.if	eax == FALSE 
			ret 
		.endif 
		invoke	SetDlgItemText,hWinMain,IDC_FILENAME,addr szBuffer 
		mov	dwOption,0		
		or	dwOption,F_START
		invoke	SetDlgItemText,hWinMain,IDC_PLAY,L("播放")
		
		invoke	_Stop
		Invoke	_Close
		ret 
 
_GetFileName	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcDlgMain	proc uses ebx edi esi hWnd,uMsg,wParam,lParam
	LOCAL	@stMciSeek:MCI_SEEK_PARMS
	
	mov		eax,uMsg
	.if	eax == WM_CLOSE
			
			;保存当前声音(配置文件)
			invoke	_GetVolumeInConf
			;保存当前播放选项
			invoke	_SavePlayModel
			invoke	EndDialog,hWnd,NULL
			
	.elseif	eax == WM_INITDIALOG
;***************************************************************************
			;Initialize Diaglog
;***************************************************************************
			invoke	SkinH_AttachEx,L("Skin\\vista.she"),NULL	;设置皮肤文件
			invoke	SkinH_SetWindowAlpha,hWnd,235	;窗口透明度
			invoke	SkinH_SetAero,TRUE			;玻璃效果
			;获取当前程序的文件路径-获取配置文件路径
			invoke	GetCurrentDirectory,sizeof szCurrentPath,addr szCurrentPath
			invoke	lstrcpy,addr szConfPath,addr szCurrentPath
			invoke	lstrcat,addr szConfPath,L("\\conf.ini")
			;初始化句柄
			push	hWnd
			pop 	hWinMain
			invoke	GetDlgItem,hWnd,IDC_MUSICLIST
			mov	hListMusic,eax
			invoke	GetDlgItem,hWnd,SOUND_VALUE
			mov	hSondValue,eax
			
			invoke	GetDlgItem,hWnd,IDC_PLAYPROGRASS
			mov	hPlayProgress,eax
			;使Text空间失效
			invoke	GetDlgItem,hWnd,IDC_FILENAME
			invoke	EnableWindow,eax,FALSE
			;设置标志位
			or	dwOption,F_START
			;Not Thick Frame Diaglog
			invoke	GetWindowLong,hWnd,GWL_STYLE
			and	eax,not WS_THICKFRAME
			invoke	SetWindowLong,hWnd,GWL_STYLE,eax
			;初始化滚动条
			invoke 	InvalidateRect,hSondValue,NULL,TRUE
			invoke 	InvalidateRect,hPlayProgress,NULL,TRUE
			invoke	SendDlgItemMessage,hWnd,SOUND_VALUE,SBM_SETRANGE,0,100
			invoke	SendMessage,hPlayProgress,SBM_SETRANGE,0,100
;			invoke	SendMessage,hPlayProgress,TBM_SETRANGEMAX,TRUE,1000
			;初始化窗体相关的信息
			invoke	_InitizlizeWindows
			;初始化索引值
			invoke SendMessage,hListMusic,LB_GETCOUNT,0,0
			sub	eax,1
			mov	nMaxIndex,eax
			;初始化计时器
			invoke	SetTimer,NULL,IDC_TIMER1,1000,addr _CountTimer
			;创建事件
			;初始化滚动条滑块位置
;			invoke 	InvalidateRect,hSondValue,NULL,TRUE
;			invoke 	SendMessage,hSondValue,TBM_SETPOS,TRUE,50
;*******************************************************************************************************************
		;处理按钮消息控件
	.elseif	eax == WM_COMMAND
			mov	eax,wParam
			;选择歌曲
			.if	ax == IDC_OPEN
				invoke	_GetFileName
			;播放-暂停
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			.elseif	ax == IDC_PLAY
				;判断文件是否被Open-判断 列表框中是否有歌曲
				invoke	SendMessage,hListMusic,LB_GETCOUNT,0,0
				.if	eax == 0
					invoke	MessageBox,hWinMain,L("列表中没有歌曲-请导入歌曲"),L("错误"),MB_OK
				.else
					.if	dwFileOpen & F_OPEN
						mov	dwFileOpen,0
						.if	dwOption & F_START
							;清空标志位-并改变标志位为暂停
							mov	dwOption,0
							or	dwOption,F_PAUSE
							invoke	_Open,offset szBuffer
							.if	eax == TRUE
								invoke	_Play,hWinMain
								invoke	_ShowTime,szMusicLength
								invoke	SetDlgItemText,hWinMain,MUSIC_LENGTH,offset szTimeBuffer
							.endif
						.endif
					.else
						;自己判断播放
						.if	dwOption & F_START
							;清空标志位-并改变标志位为暂停
	;						mov	dwOption,0
	;						or	dwOption,F_PAUSE
							invoke	_JudgeModel
	;						invoke	_ShowTime,szMusicLength
	;						invoke	SetDlgItemText,hWinMain,MUSIC_LENGTH,offset szTimeBuffer
						.elseif	dwOption & F_PAUSE
							;清空标志位-并且改变标志位为继续播放
							invoke	_Pasue
							mov	dwOption,0
							or	dwOption,F_RESTART
						.elseif	dwOption & F_RESTART
							invoke	_SeekMusic,dwCurrentTime
	;						invoke	_ReplayMusic		;这样 这个函数岂不是没有用了?
							mov	dwOption,0
							or	dwOption,F_PAUSE
							invoke	SetDlgItemText,hWinMain,IDC_PLAY,L("暂停")
						.endif
					.endif
				.endif
 ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			;停止播放
			.elseif	ax == IDC_STOP
				invoke	_Stop
				invoke	_Close
			;上一曲
			.elseif	ax == IDC_UPMUSIC
				sub	dwMusicIndex,1
				invoke	_PlayMusic,dwMusicIndex
			;下一曲
			.elseif	ax == IDC_DOWNMUSIC
				add	dwMusicIndex,1
				invoke	_PlayMusic,dwMusicIndex
			;快进
			.elseif	ax == PALY_FAST
				invoke	_SetPlaySpeed,16000
			;快退
			.elseif	ax == PALY_SLOW
				invoke	_SetPlaySpeed,-16000
			;删除当前歌曲
			.elseif	ax == MUSIC_DELETE
				invoke	MessageBox,hWinMain,L("您确定要删除该歌曲么"),L("删除歌曲"),MB_OKCANCEL or MB_ICONQUESTION
				.if	eax == IDOK
					;获取索引所在的Key
					;这里的变量--可能会引起冲突---注意一下---如果不行---则使用局部变量
					invoke	RtlZeroMemory,addr szBuffer,sizeof szBuffer 
					invoke	SendMessage,hListMusic,LB_GETCURSEL,0,0
					mov	dwSaveValue,eax
					invoke	SendMessage,hListMusic,LB_GETTEXT,dwSaveValue,addr szBuffer 
					;删除配置文件中的歌曲信息-和清除列表选项
					invoke	SendMessage,hListMusic,LB_DELETESTRING,dwSaveValue,0
					;这里一定要注意-重新设置最大项索引-不然会出错的-添加目录的时候也是
					sub	eax,1
					mov	nMaxIndex,eax
					invoke	WritePrivateProfileString,addr MusicINI,addr szBuffer,NULL,addr szConfPath
				.else	
					;不发生任何事情
				.endif	
			;随机播放
			.elseif	ax == PALY_RANDOM
				mov	dwPlayModel,0
				or	dwPlayModel,F_RANDOM
			;列表循环
			.elseif	ax == PALY_SEQUENCE
				mov	dwPlayModel,0
				or	dwPlayModel,F_SEQUENCE
			;循环一次
			.elseif	ax == PALY_ONCE
				mov	dwPlayModel,0
				or	dwPlayModel,F_ONCE
;------------------------------------------------------------------------------------------
			;处理组合框的选择事件
			.elseif	ax == IDC_CBSKIN
				shr eax,16
				;用户完成选择项目
				.if ax == CBN_SELENDOK
					invoke RtlZeroMemory,addr szListFileName,sizeof szListFileName
					invoke SendDlgItemMessage,hWnd,IDC_CBSKIN,CB_GETCURSEL,0,0
					lea       ecx,szListFileName
					invoke SendMessage,lParam,CB_GETLBTEXT,eax,ecx
					;okay -开始换肤-在加一个备注为何上面要用ecx
					;因为在使用寄存器传参后-后面就都必须用寄存器了-具体的什么的-好像忘记了-好像和栈平衡什么的有关系
					invoke _GetCurrentFilePath,addr szListFileName,addr SkinINI
					;换肤开始
					invoke	SkinH_AttachEx,addr szCurrentMSPath,NULL	;设置皮肤文件
				.endif
;------------------------------------------------------------------------------------------
			;处理播放列表的双击事件
			.elseif	ax == IDC_MUSICLIST
				shr eax,16
				;如果用户双击了一下列表项
				.if ax == LBN_DBLCLK
					;获取点击的事件
					invoke SendMessage,lParam,LB_GETCURSEL,0,0
					mov    dwMusicIndex,eax
					mov    dwMusicNext,eax
					add     dwMusicNext,1
					invoke _PlayMusic,dwMusicIndex	
				.endif
;------------------------------------------------------------------------------------------
			;导入皮肤
			.elseif	ax == IDC_ADDSKIN
				invoke RtlZeroMemory,addr szFolderPath,sizeof szFolderPath
				;因为皮肤文件存在于当前文件夹下-所以-嘿嘿默认设置算了
				invoke GetCurrentDirectory,sizeof szFolderPath,addr szFolderPath
				invoke lstrcat,addr szFolderPath,L("\skin")
				invoke _BrowseFolder,NULL,addr szFolderPath
				.if	eax
					;导入皮肤文件开始
					invoke	_GetFilesInConf,addr szFolderPath,addr SkinINI,addr szSheSkinExtend
					.if	eax
						;刷新皮肤列表
						invoke	_InitizlizeSkinList
					.else
						invoke MessageBox,NULL,L("遍历文件失败"),L("失败"),MB_OK
					.endif
				.else
					invoke	MessageBox,NULL,L("您取消了导入皮肤文件"),L("取消"),MB_OK
				.endif
			;添加播放目录-添加音乐文件
			.elseif	ax == IDC_ADDLIST
				invoke RtlZeroMemory,addr szFolderPath,sizeof szFolderPath
				invoke GetCurrentDirectory,sizeof szFolderPath,addr szFolderPath
				invoke _BrowseFolder,NULL,addr szFolderPath
				.if	eax
					;导入音乐文件到-ini配置文件中
					invoke	_GetFilesInConf,addr szFolderPath,addr MusicINI,addr szMp3Extend
					.if	eax
						;刷新播放列表
						invoke	_InitializePlayList
						;重新设置-列表项最大索引值
						invoke SendMessage,hListMusic,LB_GETCOUNT,0,0
						sub	eax,1
						mov	nMaxIndex,eax
						invoke MessageBox,NULL,L("添加歌曲成功"),L("成功"),MB_OK
					.else
						invoke MessageBox,NULL,L("遍历文件失败-请查看该文件夹根目录下是否存在音乐文件"),L("失败"),MB_OK
					.endif
				.else
					invoke	MessageBox,NULL,L("您取消了导入音乐文件"),L("取消"),MB_OK
				.endif
			.endif
;*******************************************************************************************************************
		;处理垂直滚动条消息
	.elseif	eax == WM_HSCROLL
		mov	eax,lParam	
		;lParam------------滚动条控件的窗体窗体句柄
		;wParam高16位----滚动条的当前位置
		;wParam低16位----动作码
;*******************************************************************************************************************
		;处理时间的滚动跳
		.if	eax == hSondValue
			mov eax,wParam
			;左移了一格
			.if	ax ==	SB_LINELEFT
				dec	dwPosSound
			;右移了一格
			.elseif	ax ==	SB_LINERIGHT
				inc	dwPosSound
			;左移了一页
			.elseif	ax ==	SB_PAGELEFT
				sub	dwPosSound,10
			;右移了一页
			.elseif	ax ==	SB_PAGERIGHT
				add	dwPosSound,10
			;滚动条在拖动中-和滚动跳脱到了某处
			.elseif	ax ==	SB_THUMBPOSITION || ax == SB_THUMBTRACK
				mov	eax,wParam
				shr	eax,16
				mov	dwPosSound,eax
			.else
				mov	eax,TRUE
				ret
			.endif
			;对滚动条进行控制~控制范围在0~100
			cmp	dwPosSound,0
			jge	@F
			mov	dwPosSound,0
			@@:
			cmp	dwPosSound,100
			jle	@F
			mov	dwPosSound,100
			@@:
			;dwPosSound
			invoke	_SetVolume,dwPosSound
			invoke 	SendMessage,hSondValue,TBM_SETPOS,TRUE,dwPosSound
;*******************************************************************************************************************			
		;处理播放进度条
		.elseif	eax == hPlayProgress
			mov eax,wParam
			;左移了一格
			.if	ax ==	SB_LINELEFT
				dec	dwPosPlay
			;右移了一格
			.elseif	ax ==	SB_LINERIGHT
				inc	dwPosPlay
			;左移了一页
			.elseif	ax ==	SB_PAGELEFT
				sub	dwPosPlay,10
			;右移了一页
			.elseif	ax ==	SB_PAGERIGHT
				add	dwPosPlay,10
			;滚动条在拖动中-和滚动跳脱到了某处
			.elseif	ax ==	SB_THUMBPOSITION || ax == SB_THUMBTRACK
				mov	eax,wParam
				shr	eax,16
				mov	dwPosPlay,eax
;			.elseif	ax == 	SB_BOTTOM
;				invoke SendMessage,hWnd,MM_MCINOTIFY,MCI_NOTIFY_SUCCESSFUL,0
			.else
				mov	eax,TRUE
				ret
			.endif
			;对滚动条进行控制~控制范围在0~100
			cmp	dwPosPlay,0
			jge	@F
			mov	dwPosPlay,0
			@@:
			mov	eax,100
			cmp	dwPosPlay,eax
			jle	@F
			mov	eax,100
			mov	dwPosPlay,eax
			@@:
			
			;算出当前进度条的时间			
			mov	eax,dwPosPlay
			mul	szMusicLength
			mov	ecx,100
			div	ecx
			mov	dwCurrentTime,eax
			invoke	_ShowTime,eax
			invoke	SetDlgItemText,hWnd,MUSIC_TIME,addr szTimeBuffer
			.if	dwOption & F_RESTART
				
			;呵呵 -- 这里想了一会才发现这里的逻辑是相反的哦 	
			.elseif	dwOption & F_PAUSE
				invoke	_SeekMusic,dwCurrentTime
			.endif
			;这句话可能是不要的哦-先写着 提示一下
			invoke 	SendMessage,hPlayProgress,TBM_SETPOS,TRUE,dwPosPlay
		.endif
;*******************************************************************************************************************
;MCI消息
	.elseif	eax == MM_MCINOTIFY	
		mov	eax,wParam
		.if 	wParam == MCI_NOTIFY_FAILURE
			invoke	MessageBox,NULL,L("-2"),L("------"),MB_OK
		.elseif	wParam == MCI_NOTIFY_SUCCESSFUL
			invoke	_Stop
			invoke	_Close
			invoke	_JudgeModel
		.endif
;			push	hWinMain
;			pop	@stMciSeek.dwCallback
;			invoke	mciSendCommand,hDevice,MCI_SEEK,MCI_WAIT or MCI_SEEK_TO_START,addr @stMciSeek
;			invoke	_JudgeModel
;*******************************************************************************************************************

;*******************************************************************************************************************
	;对话框必要的循环判断	
	.else		
		mov		eax,FALSE
		ret
	.endif
		mov		eax,TRUE
	ret

_ProcDlgMain endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
		invoke	GetModuleHandle,NULL
		mov	hInstance,eax
		invoke	DialogBoxParam,hInstance,DLG_MAIN,NULL,offset _ProcDlgMain,NULL
		invoke	ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end start
