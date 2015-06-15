;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;Include Files
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include	windows.inc 
include	user32.inc 
include	kernel32.inc 
include	comctl32.inc 
include	comdlg32.inc 
include	winmm.inc 
include	shell32.inc
include	ole32.inc

includelib ole32.lib
includelib shell32.lib 
includelib	user32.lib 
includelib	kernel32.lib 
includelib	comctl32.lib 
includelib	comdlg32.lib 
includelib	winmm.lib 

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;格式：宏名 MACRO　[形参x[:REQ][:VARARG], ……] 
;              … ;宏体内的自定义指令列表
;           ENDM 
;宏名 在调用宏时用到的指令名称 
;MACRO 指令关键字
;形参x 调用宏时对应的一系列参数 
;:REQ 指定该参数是不可缺少。在宏引用时，若该参数不对应某个“实参”，那么，汇编程序会报错； 
;:VARARG 该参数对应一个可变长的实参表，各实参之间用逗号分开；若参数的属性指定为VARARG，那么，该参数一定要是最后一个参数。 
;ENDM  宏结束指令关键字 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;Macro Define
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
L macro var:VARARG
	LOCAL @lbl
	.const
	@lbl db var,0
	.code
	exitm <offset @lbl>
endm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;Struct
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;没办法 --只有把这个结构重新定义一下
MCI_DGV_SETAUDIO_PARMS STRUCT
  dwCallback        		DWORD      ?
  dwItem         			DWORD      ?
  dwValue  					DWORD      ?
  dwOver  					DWORD      ?
  lpstrAlgorithm        DWORD      ?
  lpstrQuality				DWORD      ?
MCI_DGV_SETAUDIO_PARMS ENDS
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;Equ define
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
MANIFEST				equ 24
DLG_MAIN				equ 1100
IDC_OPEN				equ 1101
IDC_PLAY				equ 1102
IDC_STOP				equ 1103
IDC_DOWNMUSIC		equ 1104
IDC_GRP2				equ 1106
IDC_FILENAME		equ 1108
IDC_ADDLIST			equ 1105
IDC_UPMUSIC			equ 1107
IDC_MUSICLIST		equ 1109
IDC_CBSKIN			equ 1111
IDC_STC1				equ 1112
SOUND_VALUE			equ 1113
IDC_STC2				equ 1114
IDC_STC3				equ 1115
IDC_STC4				equ 1116
IDC_ADDSKIN			equ 1117
IDC_PLAYPROGRASS	equ 1110
MUSIC_TIME			equ 1118
MUSIC_LENGTH		equ 1119
PALY_FAST			equ 1123
PALY_SLOW			equ 1124
PALY_SEQUENCE		equ 1125
PALY_ONCE			equ 1126
PALY_RANDOM			equ 1127
MUSIC_DELETE		equ 1120
IDR_XPMANIFEST1	equ 1
IDC_TIMER1			equ 1500

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;Function Define
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_SetPlaySpeed		proto :DWORD
_QueryLength		proto
_Close				proto
_Open					proto :DWORD
_Play					proto :DWORD
_Stop					proto
_Pasue				proto
_QueryPosition		proto
_ShowTime			proto :DWORD
_ReplayMusic		proto
_GetFileName		proto
_JudgeModel			proto 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;位标记-判断当前歌曲信息状态
F_START		equ		0001h		;0001B----第一位----开始播放
F_RESTART	equ		0002h		;0010B----第二位----继续播放
F_PAUSE		equ		0004h		;0100B----第三位----暂停播放
;上面的用低4位 -  那么下面的用高8位
F_RANDOM		equ		10h		;0001-0000----随机播放--or 0Fh
F_SEQUENCE	equ		20h		;0010-0000----顺序播放--or 0Fh
F_ONCE		equ		40h		;0100-0000----播放一次--or 0Fh
;打开 or 关闭 - 单独选一首的情况
F_OPEN		equ		100h		;0000-0001-0000-0000 =>0100h ----打开状态--or 0FFh
F_CLOSE		equ		200h		;0000-0010-0000-0000 =>0200h ----关闭状态--or 0FFh
;先记录一下-为了使播放不受到影响-那么清空标志位的时候应该保留低4位
;and 0000-0000-0000-0000-0000-0000-0000-1111 =>0Fh 保留低4位
;为了保证及时的更新状态-所以每次点击单选框后-每个消息都要相应的更新下信息
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;Data Segment
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			.data?
hInstance		dd		?				;实例句柄
hDevice			dd		?				;音频设备句柄
hWinMain			dd		?				;主窗体句柄
hListMusic		dd		?				;列表框控件句柄
hSondValue		dd		?				;声音滚动条句柄
hPlayProgress	dd		?				;播放进度条句柄
dwOption			dd		?				;判断当前按钮信息
dwPlayModel		dd		?				;判断当前播放模式
dwFileOpen		dd		?				;判断文件是否打开
szDefault		dd		?				;本来是不想要这个的-没办法呀那个丑陋的函数非得要返回一个无用的值
dwPosSound		dd		?				;声音进度跳条位置--数值
dwPosPlay		dd		?				;播放进度条位置--数值的哦
szMusicLength	dd		?				;当前播放歌曲的长度-(毫秒)
dwMusicIndex	dd		?				;当前播放歌曲的索引
dwMusicNext		dd		?				;下一首的索引
nMaxIndex		dd		?				;列表中索引的最大值
dwCurrentTime	dd		?				;当前歌曲的播放时间
dwSaveValue		dd		?				;保存最后播放选项的临时空间
stMciOpen		MCI_OPEN_PARMS		<?>  		;打开音频结构体
stOpenFileName	OPENFILENAME		<?>  		;打开文教对话框结构体
szFolderPath	db	MAX_PATH dup (?)			;打开目录的目录存放缓冲
szCurrentPath	db	MAX_PATH	dup(?)			;当前程序路径
szCurrentMSPath	dd	MAX_PATH	dup(?)		;当前文件的全路径-可能是播放文件-可能是皮肤文件
szConfPath		db	MAX_PATH	dup(?)			;配置文件的路径
szBuffer			db	256 		dup(?) 			;返回的文件名缓冲区
szTimeBuffer	db	10 		dup(?)			;显示播放时间的缓冲
szINIKeyBuffer	db	20240		dup(?)			;歌曲信息存放的缓冲 - -!
szListFileName	dd	256		dup(?)			;返回当前列表框的文件项目
szTemppBuffer	dd	1000		dup(?)

			.data
szPlay		db	"&Play",0 
szStop		db	"&Stop",0 
szTitleSave	db	"Open MP3 file...",0 
szExt			db	'*.mp3',0 
szFilter		db	'MP3 Files(*.mp3)',0,'*.mp3',0,'All Files(*.*)',0,'*.*',0,0	;
			.const
szMp3Extend			db	'\\*.mp3',0
szSheSkinExtend	db	'\\*.she',0
MusicINI				db	'MusicHistory',0
SkinINI				db	'SkinHistroy',0
confINI				db	'\conf.ini',0
szPlayOption		db	'PlayOption',0				;播放选项-Section
szSoundValue		db	'SoundValue',0				;音量大小的键值
szPlayStatus		db	'PlayStatus',0				;播放的选项状态
szPlayIndex			db	'PlayIndex',0				;当前播放的索引值