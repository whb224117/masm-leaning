;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;���ڲ������ĳ�ʼ������
;

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����̫�鷳��  �һ���ֱ�Ӱ���ͷ�ļ�����
include windows.inc
include user32.inc
include kernel32.inc

includelib user32.lib
includelib kernel32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:�����һ��Ŀ¼ʱ��-������Ŀ¼�µ������ļ�-д��conf�����ļ���
;����1:lpFolderPath-ָ��Ҫ�������ļ���
;����2:lpSectionName-ָ��Ҫд��������ļ��Ľڵ�
;����ֵ:����ִ�гɹ�����TRUE-ִ��ʧ�ܷ���FALSE
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_GetFilesInConf proc lpFolderPath:DWORD,lpSectionName:DWORD,lpFileExtend:DWORD
	LOCAL	@hListFile:DWORD
	LOCAL	@szFilePath[MAX_PATH]:BYTE
	LOCAL	@szTempPath[MAX_PATH]:BYTE
	LOCAL	@stFindFileData:WIN32_FIND_DATA
	;�ϵ�ʹ��
;	invoke MessageBox,NULL,L("�ɹ�"),L("�ɹ�"),MB_OK
	;��Ŀ¼��Ϣ�������ֲ�������
	invoke	lstrcpy,addr @szTempPath,lpFolderPath
	invoke	lstrcpy,addr @szFilePath,lpFolderPath
;	invoke	MessageBox,NULL,addr @szFilePath,L("��ѡ����:"),MB_OK
	invoke	lstrcat,lpFolderPath,lpFileExtend
	invoke	FindFirstFile,lpFolderPath,addr @stFindFileData
	mov	@hListFile,eax
	.if	@hListFile == INVALID_HANDLE_VALUE
		invoke	MessageBox,NULL,L("��Ч��·��--or--��ȡ��һ�ļ�ʧ��"),L("��Ŀ¼ʧ��"),MB_OK
	.else
		.repeat
			;--------------------------------------------------------------------------------
			;���ӳ��ļ���ȫ·��
			invoke	RtlZeroMemory,addr @szTempPath,sizeof @szTempPath
			invoke	lstrcpy,addr @szTempPath,addr  @szFilePath
			invoke	lstrcat,addr @szTempPath,L("\")
			invoke	lstrcat,addr @szTempPath,addr @stFindFileData.cFileName
;			invoke	MessageBox,NULL,addr @szTempPath,L("��ǰ�����ļ���"),MB_OK
			;д�����ļ�
			invoke	WritePrivateProfileString,lpSectionName,addr @stFindFileData.cFileName,addr @szTempPath,addr szConfPath
			;--------------------------------------------------------------------------------
			;������һ���ļ�
			invoke	FindNextFile,@hListFile,addr @stFindFileData
			invoke	GetLastError
;			invoke	wsprintf,addr szTemp,L("%d"),eax
;			invoke	MessageBox,NULL,addr szTemp,L("�������"),MB_OK
;			ERROR_NO_MORE_FILES
			;ѭ��ִֻ����һ��?
		.until	eax == ERROR_NO_MORE_FILES
		;�����ƺ���-��մ�Ŀ¼����
		invoke	RtlZeroMemory,addr szFolderPath,sizeof szFolderPath
		mov	eax,TRUE
		ret
	.endif
	mov eax,FALSE
	ret
_GetFilesInConf endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:��ʼ�������б�
;����:����
;����ֵ:����TRUE��ʼ���ɹ�-����FALSE��ʼ��ʧ��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_InitializePlayList	proc
	;�����ֵָ��ΪNULL----��ô:
	;���ص�szINIKeyBuffer�ļ��ĸ�ʽΪ---------����1,0,����2,0������������n,0,0
	;��windows�� ����ȷ��0ah,0dh-�ַ��������ķ�ʽ ���Ǻ����0
	;�������뵽�ķ�ʽ����lstrlen�������ַ����ĳ���-
	;�ܺ�-���ָ���˼�ֵ-��ô���صľ���ȫ·��������-Very good-д���Ե����ﰳСС����ϲһ��
	invoke	RtlZeroMemory,addr szINIKeyBuffer,sizeof szINIKeyBuffer
	invoke	GetPrivateProfileString,addr MusicINI,NULL,addr szDefault,addr szINIKeyBuffer,sizeof szINIKeyBuffer,addr szConfPath
	;ȡ��������ַ
	mov	esi,offset szINIKeyBuffer
	;���������-��ѭ��ȡ����
	.while	byte ptr [esi]
		;ÿһ�ζ��ɹ�������ȷ����ֵ-��ʼʹ��֮ǰ��ʼ��0�Ĳ����ǳ���
		;���ڿ�ʼ����б�  - -!
		invoke	SendDlgItemMessage,hWinMain,IDC_MUSICLIST,LB_ADDSTRING,0,esi
		invoke	lstrlen,esi
		add	esi,eax
		inc	esi
	.endw
	ret

_InitializePlayList endp


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:��ʼ��Ƥ���б��
;����:����
;����ֵ:����TRUE��ʼ���ɹ�-����FALSE��ʼ��ʧ��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_InitizlizeSkinList	proc
	;�����������ĺ���
	invoke	RtlZeroMemory,addr szINIKeyBuffer,sizeof szINIKeyBuffer
	invoke	GetPrivateProfileString,addr SkinINI,NULL,addr szDefault,addr szINIKeyBuffer,sizeof szINIKeyBuffer,addr szConfPath
	;ȡ��������ַ
	mov	esi,offset szINIKeyBuffer
	;���������-��ѭ��ȡ����
	.while	byte ptr [esi]
		;ÿһ�ζ��ɹ�������ȷ����ֵ-��ʼʹ��֮ǰ��ʼ��0�Ĳ����ǳ���
		;���ڿ�ʼ����б�  - -!
		invoke	SendDlgItemMessage,hWinMain,IDC_CBSKIN,CB_ADDSTRING,0,esi
		invoke	lstrlen,esi
		add	esi,eax
		inc	esi
	.endw
	ret

_InitizlizeSkinList endp
	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:��������
;����:
;����ֵ:����TRUE��ʼ���ɹ�-����FALSE��ʼ��ʧ��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_InitizlizeWindows proc
	;��ʼ�������б�
	invoke	_InitializePlayList
	;��ʼ��Ƥ���б�
	invoke	_InitizlizeSkinList
;-------------------------------------------------------------------------------------------------------------------
	;��ʼ������-�����ϴβ��ŵļ�¼-szConfPath
	invoke	GetPrivateProfileInt,addr szPlayOption,addr szSoundValue,addr szDefault,addr szConfPath
	mov	dwPosSound,eax
	invoke 	SendMessage,hSondValue,TBM_SETPOS,TRUE,dwPosSound
;-------------------------------------------------------------------------------------------------------------------
	;��ʼ��-����ѡ�������
	invoke	GetPrivateProfileInt,addr szPlayOption,addr szPlayStatus,addr szDefault,addr szConfPath
	;������������
	.if	eax == 1
		mov	dwPlayModel,0
		or	dwPlayModel,F_RANDOM
		invoke	CheckDlgButton,hWinMain,PALY_RANDOM,BST_CHECKED
	;�����ѭ������
	.elseif	eax == 2
		mov	dwPlayModel,0
		or	dwPlayModel,F_SEQUENCE
		invoke	CheckDlgButton,hWinMain,PALY_SEQUENCE,BST_CHECKED
	;������б�ѭ��һ��
	.elseif	eax == 3
		mov	dwPlayModel,0
		or	dwPlayModel,F_ONCE
		invoke	CheckDlgButton,hWinMain,PALY_ONCE,BST_CHECKED
	.endif
;-------------------------------------------------------------------------------------------------------------------
	;��ʼ����ǰ�����ŵĸ���
	invoke	GetPrivateProfileInt,addr szPlayOption,addr szPlayIndex,addr szDefault,addr szConfPath
	mov	dwMusicIndex,eax
	mov	dwMusicNext,eax
	;�����б�򽹵�
	invoke	SendMessage,hListMusic,LB_SETCURSEL,eax,0
	ret

_InitizlizeWindows endp




