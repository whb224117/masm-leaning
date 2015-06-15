;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;用于播放器的初始化操作
;

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;声明太麻烦了  我还是直接包含头文件算了
include windows.inc
include user32.inc
include kernel32.inc

includelib user32.lib
includelib kernel32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:当添加一个目录时候-遍历该目录下的所有文件-写入conf配置文件中
;参数1:lpFolderPath-指定要遍历的文件夹
;参数2:lpSectionName-指定要写入的配置文件的节点
;返回值:函数执行成功返回TRUE-执行失败返回FALSE
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_GetFilesInConf proc lpFolderPath:DWORD,lpSectionName:DWORD,lpFileExtend:DWORD
	LOCAL	@hListFile:DWORD
	LOCAL	@szFilePath[MAX_PATH]:BYTE
	LOCAL	@szTempPath[MAX_PATH]:BYTE
	LOCAL	@stFindFileData:WIN32_FIND_DATA
	;断点使用
;	invoke MessageBox,NULL,L("成功"),L("成功"),MB_OK
	;将目录信息拷贝到局部变量中
	invoke	lstrcpy,addr @szTempPath,lpFolderPath
	invoke	lstrcpy,addr @szFilePath,lpFolderPath
;	invoke	MessageBox,NULL,addr @szFilePath,L("您选择了:"),MB_OK
	invoke	lstrcat,lpFolderPath,lpFileExtend
	invoke	FindFirstFile,lpFolderPath,addr @stFindFileData
	mov	@hListFile,eax
	.if	@hListFile == INVALID_HANDLE_VALUE
		invoke	MessageBox,NULL,L("无效的路径--or--获取第一文件失败"),L("打开目录失败"),MB_OK
	.else
		.repeat
			;--------------------------------------------------------------------------------
			;连接成文件的全路径
			invoke	RtlZeroMemory,addr @szTempPath,sizeof @szTempPath
			invoke	lstrcpy,addr @szTempPath,addr  @szFilePath
			invoke	lstrcat,addr @szTempPath,L("\")
			invoke	lstrcat,addr @szTempPath,addr @stFindFileData.cFileName
;			invoke	MessageBox,NULL,addr @szTempPath,L("当前遍历文件是"),MB_OK
			;写配置文件
			invoke	WritePrivateProfileString,lpSectionName,addr @stFindFileData.cFileName,addr @szTempPath,addr szConfPath
			;--------------------------------------------------------------------------------
			;遍历下一个文件
			invoke	FindNextFile,@hListFile,addr @stFindFileData
			invoke	GetLastError
;			invoke	wsprintf,addr szTemp,L("%d"),eax
;			invoke	MessageBox,NULL,addr szTemp,L("错误代码"),MB_OK
;			ERROR_NO_MORE_FILES
			;循环只执行了一次?
		.until	eax == ERROR_NO_MORE_FILES
		;做点善后处理-清空打开目录缓冲
		invoke	RtlZeroMemory,addr szFolderPath,sizeof szFolderPath
		mov	eax,TRUE
		ret
	.endif
	mov eax,FALSE
	ret
_GetFilesInConf endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:初始化播放列表
;参数:暂无
;返回值:返回TRUE初始化成功-返回FALSE初始化失败
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_InitializePlayList	proc
	;如果键值指定为NULL----那么:
	;返回到szINIKeyBuffer的键的格式为---------键名1,0,键名2,0。。。。键名n,0,0
	;而windows中 换行确是0ah,0dh-字符串结束的方式 就是后面加0
	;所以我想到的方式是用lstrlen来计算字符串的长度-
	;很好-如果指定了键值-那么返回的就是全路径的名称-Very good-写测试到这里俺小小的窃喜一下
	invoke	RtlZeroMemory,addr szINIKeyBuffer,sizeof szINIKeyBuffer
	invoke	GetPrivateProfileString,addr MusicINI,NULL,addr szDefault,addr szINIKeyBuffer,sizeof szINIKeyBuffer,addr szConfPath
	;取缓冲区地址
	mov	esi,offset szINIKeyBuffer
	;如果有数据-就循环取数据
	.while	byte ptr [esi]
		;每一次都成功弹出正确的数值-开始使用之前初始化0的操作非常好
		;现在开始添加列表  - -!
		invoke	SendDlgItemMessage,hWinMain,IDC_MUSICLIST,LB_ADDSTRING,0,esi
		invoke	lstrlen,esi
		add	esi,eax
		inc	esi
	.endw
	ret

_InitializePlayList endp


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:初始化皮肤列表框
;参数:暂无
;返回值:返回TRUE初始化成功-返回FALSE初始化失败
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_InitizlizeSkinList	proc
	;具体参照上面的函数
	invoke	RtlZeroMemory,addr szINIKeyBuffer,sizeof szINIKeyBuffer
	invoke	GetPrivateProfileString,addr SkinINI,NULL,addr szDefault,addr szINIKeyBuffer,sizeof szINIKeyBuffer,addr szConfPath
	;取缓冲区地址
	mov	esi,offset szINIKeyBuffer
	;如果有数据-就循环取数据
	.while	byte ptr [esi]
		;每一次都成功弹出正确的数值-开始使用之前初始化0的操作非常好
		;现在开始添加列表  - -!
		invoke	SendDlgItemMessage,hWinMain,IDC_CBSKIN,CB_ADDSTRING,0,esi
		invoke	lstrlen,esi
		add	esi,eax
		inc	esi
	.endw
	ret

_InitizlizeSkinList endp
	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;功能:整个窗体
;参数:
;返回值:返回TRUE初始化成功-返回FALSE初始化失败
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_InitizlizeWindows proc
	;初始化播放列表
	invoke	_InitializePlayList
	;初始化皮肤列表
	invoke	_InitizlizeSkinList
;-------------------------------------------------------------------------------------------------------------------
	;初始化音量-根据上次播放的记录-szConfPath
	invoke	GetPrivateProfileInt,addr szPlayOption,addr szSoundValue,addr szDefault,addr szConfPath
	mov	dwPosSound,eax
	invoke 	SendMessage,hSondValue,TBM_SETPOS,TRUE,dwPosSound
;-------------------------------------------------------------------------------------------------------------------
	;初始化-播放选项的设置
	invoke	GetPrivateProfileInt,addr szPlayOption,addr szPlayStatus,addr szDefault,addr szConfPath
	;如果是随机播放
	.if	eax == 1
		mov	dwPlayModel,0
		or	dwPlayModel,F_RANDOM
		invoke	CheckDlgButton,hWinMain,PALY_RANDOM,BST_CHECKED
	;如果是循环播放
	.elseif	eax == 2
		mov	dwPlayModel,0
		or	dwPlayModel,F_SEQUENCE
		invoke	CheckDlgButton,hWinMain,PALY_SEQUENCE,BST_CHECKED
	;如果是列表循环一次
	.elseif	eax == 3
		mov	dwPlayModel,0
		or	dwPlayModel,F_ONCE
		invoke	CheckDlgButton,hWinMain,PALY_ONCE,BST_CHECKED
	.endif
;-------------------------------------------------------------------------------------------------------------------
	;初始化当前所播放的歌曲
	invoke	GetPrivateProfileInt,addr szPlayOption,addr szPlayIndex,addr szDefault,addr szConfPath
	mov	dwMusicIndex,eax
	mov	dwMusicNext,eax
	;设置列表框焦点
	invoke	SendMessage,hListMusic,LB_SETCURSEL,eax,0
	ret

_InitizlizeWindows endp




