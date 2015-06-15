;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;用于播放中的控制
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;声明太麻烦了  我还是直接包含头文件算了
include windows.inc
include user32.inc
include kernel32.inc

includelib user32.lib
includelib kernel32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:计时器-过程函数-控制滚动条-并且判断当前歌曲是否播放结束
;说明:
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_CountTimer	proc _hWnd,uMsg,_idEvent,_dwTime
	LOCAL	@szCurrentTime:DWORD		;当前播放的时间
	LOCAL	@szTemp:DWORD
	LOCAL	@szIData:DWORD
	pushad
	;如果暂停按下了
	.if	dwOption & F_RESTART
		;空转吧---
	;如果是播放的
	.elseif	dwOption & F_PAUSE	
		;判断歌曲是否结束了
		invoke	_QueryPosition
		mov	@szCurrentTime,eax
		add	eax,1
		cmp	eax,szMusicLength
		jna	@F
		;歌曲播放完毕-处理下一首播放
		;这里要注意下-标志位木有改变过来-所以会持续的发送这个消息
		mov	dwOption,0
		or	dwOption,F_START
		invoke SendMessage,hWinMain,MM_MCINOTIFY,MCI_NOTIFY_SUCCESSFUL,0
		;处理进度条
		@@:
		mov	@szIData,100
		;开始浮点运算-计算百分比
		finit 				;如果不进行初始化-那么st0~st1之间都是些垃圾值-尽管不停的初始化会带来效率开销
		fild	@szCurrentTime		;st1
		fild	szMusicLength		;st0
		fdiv				;结果在st0
		fild	@szIData			;
		fmul
		fist	@szTemp			;st0->@szTemp
		invoke 	SendMessage,hPlayProgress,TBM_SETPOS,TRUE,@szTemp
		;还要设置下显示的时间
		invoke	RtlZeroMemory,addr szTimeBuffer,sizeof szTimeBuffer
		invoke	_ShowTime,@szCurrentTime
		invoke	SetDlgItemText,hWinMain,MUSIC_TIME,addr szTimeBuffer
	.elseif	dwOption & F_START
		;空转吧 
	.endif
	
	popad
	ret

_CountTimer endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:线程函数:控制滚动条
;说明:
;(1)这个格式是线程函数的通用格式
;(2)涉及到线程-我还是把每一步都写详细点
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;_CoutBar	proc	uses ebx esi edi,_lParam
;		LOCAL	@szCurrentTime:DWORD
;		LOCAL	@szTemp:DWORD
;		LOCAL	@szIData:DWORD
;		
;		invoke	SetEvent,hEvent
;		@LOOP:	
;		invoke	_QueryPosition		;查询当前的时间
;		mov	@szCurrentTime,eax
;		cmp	eax,szMusicLength		;当前时间长度和总的时间长度比较
;		jne	@F			;不相等就跳-
;		invoke	_Stop
;		invoke	_Close
;		invoke	_JudgeModel
;		@@:
;		mov	@szIData,100
;		mov	@szCurrentTime,eax
;		;开始浮点运算-计算百分比
;		finit 				;如果不进行初始化-那么st0~st1之间都是些垃圾值-尽管不停的初始化会带来效率开销
;		fild	@szCurrentTime		;st1
;		fild	szMusicLength		;st0
;		fdiv				;结果在st0
;		fild	@szIData			;
;		fmul
;		fist	@szTemp			;st0->@szTemp
;		invoke 	SendMessage,hPlayProgress,TBM_SETPOS,TRUE,@szTemp
;		;还要设置下显示的时间
;		mov	eax,@szTemp
;		mul	szMusicLength
;		mov	ecx,100
;		div	ecx
;		invoke	_ShowTime,eax
;		invoke	SetDlgItemText,hWinMain,MUSIC_TIME,addr szTimeBuffer
;		invoke	WaitForSingleObject,hEvent,INFINITE
;		jmp	@LOOP
;	ret
;
;_CoutBar endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能;产生一个随机数(范围:_dwFirst~_dwSecond)
;参数1:随机数的下限
;参数2;随机数的上限
;所用公式: Rand_Number = (Rand_Seed * X + Y) mod Z
;补充说明:
;           (1)本例中用 GetTickCount 来取得随机数种子，
;              在实际应用中，可用别的方法代替。
;           (2)要产生随机数，X和Y其中之一必须是素数，
;              所以 X = 23, Y = 7（可用别的素数代替）
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_iRand	proc _dwFirst:DWORD,_dwSecond:DWORD
	
	;GetTickCount 获取自windows启动以来经历的时间长度（毫秒）
	invoke GetTickCount ; 取得随机数种子，当然，可用别的方法代替
   	mov	ecx, 23         	 ; X = ecx = 23
   	mul 	ecx            	 ; eax = eax * X
   	add 	eax, 7         	 ; eax = eax + Y （Y = 7）
   	mov	ecx,_dwSecond   	 ; ecx = 上限
  	sub 	ecx, _dwFirst      	 ; ecx = 上限 - 下限
   	inc  	ecx             	 ; Z = ecx + 1 （得到了范围）
   	xor  	edx, edx       	 ; edx = 0
   	div  	ecx             	 ; eax = eax mod Z （余数在edx里面）
   	add	edx,_dwFirst        	 ; 修正产生的随机数的范围
   	mov	eax, edx             ; eax = Rand_Number	
	ret

_iRand endp


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:跳跃到指定地方
;参数1--歌曲的当前播放时间
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_SeekMusic proc _dwCurrentTime:DWORD
	LOCAL	@stSeekParam:MCI_SEEK_PARMS
	LOCAL	@stMciPlay:MCI_PLAY_PARMS
;	invoke	_QueryPosition
	
	push	hWinMain
	pop	@stSeekParam.dwCallback
	mov	eax,_dwCurrentTime
	mov	@stSeekParam.dwTo,eax
	;每次跳转之后-居然都暂停了-所以现在要恢复播放才行
	invoke	mciSendCommand,hDevice,MCI_SEEK,MCI_TO or MCI_WAIT,addr @stSeekParam
	push	_dwCurrentTime
	pop	@stMciPlay.dwFrom
	invoke	mciSendCommand,hDevice,MCI_PLAY,MCI_FROM,addr @stMciPlay
;	invoke	_ReplayMusic
	ret

_SeekMusic endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:通过当前文件名-来获取当前文件的全路径
;参数1:歌曲的路径名
;返回值:文件的全路径存放在szCurrentMSPath
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_GetCurrentFilePath proc lpListFileName:DWORD,lpSectionName:DWORD
	;虽然有时候清楚缓冲是一件没有必要的事情-但是为了避免出现不必要的情况出现-我还是先清空一下缓冲
	;突然想起来在某一本书上-谈到sizeof的好处-那本书叫什么来着-嗯-代码揭秘
	;有时候觉得写程序应该是一件很愉快的事情-不应该那样呆板-包括注释  呵呵 个人习惯吧
	invoke RtlZeroMemory,addr szCurrentMSPath,sizeof szCurrentMSPath
	;写到这里-我不禁注意了一下-配置文件的路径是否在窗体创建的时候就写好了-还要注意的是-其他的变量是否修改了?
	invoke GetPrivateProfileString,lpSectionName,lpListFileName,addr szDefault,addr szCurrentMSPath,sizeof szCurrentMSPath,addr szConfPath
	ret

_GetCurrentFilePath endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:保存当前播放状态到配置文件中-包括当前所播放歌曲的索引值
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_SavePlayModel	proc
	
	;保存当前播放歌曲的索引值
;	invoke	RtlZeroMemory,addr dwSaveValue,sizeof dwSaveValue
	mov	dwSaveValue,0
	mov	eax,dwMusicIndex
	invoke	wsprintf,addr dwSaveValue,L("%d"),eax
	invoke	WritePrivateProfileString,addr szPlayOption,addr szPlayIndex,addr dwSaveValue,addr szConfPath
	;保存当前播放歌曲的状态---szPlayStatus
	mov	dwSaveValue,0
	;如果是随机播放
	.if	dwPlayModel & F_RANDOM
		mov	eax,1
	;如果是循环播放
	.elseif	dwPlayModel & F_SEQUENCE
		mov	eax,2
	;如果是列表循环
	.elseif	dwPlayModel & F_ONCE
		mov	eax,3	
	.endif
	invoke	wsprintf,addr dwSaveValue,L("%d"),eax	
	invoke	WritePrivateProfileString,addr szPlayOption,addr szPlayStatus,addr dwSaveValue,addr szConfPath
	ret

_SavePlayModel endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:保存当前声音大小-到配置文件 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_GetVolumeInConf proc
	
;	dwPosSound   ;需要3个字节--实质上是4个字节
	mov	dwSaveValue,0
	mov	eax,dwPosSound
	invoke	wsprintf,addr dwSaveValue,L("%d"),eax
	;写配置文件-保存到指定键值
	invoke	WritePrivateProfileString,addr szPlayOption,addr szSoundValue,addr dwSaveValue,addr szConfPath
	ret

_GetVolumeInConf endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:设置音量的值
;传来的值是声音的大小除以10
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_SetVolume proc _dwSoundValue:DWORD
	LOCAL	@stSV:MCI_DGV_SETAUDIO_PARMS
	
;	invoke MessageBox,NULL,L("成功"),L("成功"),MB_OK
	mov ebx,10
	mov eax,_dwSoundValue
	mul  ebx						;MUL  EBX ;将EBX的值乘以EAX的值，并把结果将EDX:EAX
	mov @stSV.dwValue,eax
	mov @stSV.dwItem,4002h 	;MCI_DGV_SETAUDIO_VOLUME
	
	invoke mciSendCommand,hDevice,0873h,00800000h or 01000000h,addr @stSV
	ret

_SetVolume endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:快进-快退
;参数1:偏移的时间
;负数代表快退-正数代表快进-0表示当前值
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_SetPlaySpeed	proc szTimeExc:DWORD
	LOCAL	@szCurrentTime:DWORD
	LOCAL	@szTemp:DWORD
	LOCAL	@szIData:DWORD
	
	mov	@szIData,100
	invoke	_QueryPosition
	add	eax,szTimeExc
	mov	@szCurrentTime,eax
	invoke	_SeekMusic,eax
	;开始浮点运算-计算百分比
	finit 				;如果不进行初始化-那么st0~st1之间都是些垃圾值-尽管不停的初始化会带来效率开销
	fild	@szCurrentTime		;st1
	fild	szMusicLength		;st0
	fdiv							;结果在st0
	fild	@szIData				;将st0保存在@szIData中
	fmul
	fist	@szTemp			;st0->@szTemp
	invoke 	SendMessage,hPlayProgress,TBM_SETPOS,TRUE,@szTemp
	;还要设置下显示的时间
	mov	eax,@szTemp
	mul	szMusicLength
	mov	ecx,100
	div	ecx
	invoke	_ShowTime,eax
	invoke	SetDlgItemText,hWinMain,MUSIC_TIME,addr szTimeBuffer
	ret

_SetPlaySpeed endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:播放进度条-自动滚动
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_SetPlayPos proc
	
	
	ret

_SetPlayPos endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:播放歌曲
;参数:播放歌曲的索引值
;说明:
;(1)经过测试-列表框的索引值是从0开始索引的
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_PlayMusic proc _dwMusicIndex:DWORD
	;关闭上一曲的内容---不知道是不是多余的
	invoke	_Stop
	invoke	_Close
	;对索引的值进行判断
	cmp	_dwMusicIndex,0
	jge	@F
	mov	dwMusicNext,0
	@@:
	mov	eax,_dwMusicIndex
	cmp	eax,nMaxIndex
	jle	@F
	mov	eax,nMaxIndex
	mov	_dwMusicIndex,eax
	@@:
	;这里面的索引呢-就是当前播放列表的索引
	invoke SendMessage,hListMusic,LB_GETTEXT,_dwMusicIndex,addr szListFileName
	invoke _GetCurrentFilePath,addr szListFileName,addr MusicINI
	invoke SetDlgItemText,hWinMain,IDC_FILENAME,addr szCurrentMSPath
	invoke _Close
	invoke _Open,addr szCurrentMSPath
		.if	eax == TRUE
		mov	dwOption,0
		or	dwOption,F_PAUSE
		invoke	_Play,hWinMain
		invoke	_ShowTime,szMusicLength
		push	_dwMusicIndex
		pop	dwMusicIndex
		invoke	SetDlgItemText,hWinMain,MUSIC_LENGTH,offset szTimeBuffer
		invoke	SendMessage,hListMusic,LB_SETCURSEL,_dwMusicIndex,0
	.endif
	ret

_PlayMusic endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:获取列表框中的项目数-返回索引值
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_GetMaxIndex proc 
	
	
	ret

_GetMaxIndex endp


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:判断当前播放模式-返回索引值
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_JudgeModel	proc
	LOCAL	@dwIndex
	
	invoke	SendMessage,hListMusic,LB_GETCOUNT,0,0
	.if	eax == 0
		invoke	MessageBox,hWinMain,L("列表中没有歌曲-您也没有打开一首歌曲-请导入歌曲--"),L("错误"),MB_OK
	.else
		;如果是随机播放
		.if	dwPlayModel & F_RANDOM
			invoke _iRand,0,nMaxIndex
			invoke _PlayMusic,eax
		;如果是循环播放
		.elseif	dwPlayModel & F_SEQUENCE
			mov	eax,dwMusicNext
			cmp	eax,nMaxIndex
			jb	@F
			;已经超过了-最大播放索引-重新初始化为0-继续播放
			mov	dwMusicNext,0
			invoke	_PlayMusic,dwMusicNext
			;没有超出最大索引
		@@:	mov	eax,dwMusicNext
			add	dwMusicNext,1
			invoke	_PlayMusic,eax
			
		;如果是列表循环
		.elseif	dwPlayModel & F_ONCE	
			mov	eax,dwMusicNext
			cmp	eax,nMaxIndex
			jb	@F
			;已经超过了-最大播放索引-重新初始化为0-继续播放
			invoke	MessageBox,hWinMain,L("已经是最后一首歌啦"),L("温馨提示:"),MB_OK
			;没有超出最大索引
		@@:	mov	eax,dwMusicNext
			add	dwMusicNext,1
			invoke	_PlayMusic,eax
		.endif
	.endif	
	ret

_JudgeModel endp


