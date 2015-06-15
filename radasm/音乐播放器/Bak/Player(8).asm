;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;���ڲ����еĿ���
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����̫�鷳��  �һ���ֱ�Ӱ���ͷ�ļ�����
include windows.inc
include user32.inc
include kernel32.inc

includelib user32.lib
includelib kernel32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:��ʱ��-���̺���-���ƹ�����-�����жϵ�ǰ�����Ƿ񲥷Ž���
;˵��:
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_CountTimer	proc _hWnd,uMsg,_idEvent,_dwTime
	LOCAL	@szCurrentTime:DWORD		;��ǰ���ŵ�ʱ��
	LOCAL	@szTemp:DWORD
	LOCAL	@szIData:DWORD
	pushad
	;�����ͣ������
	.if	dwOption & F_RESTART
		;��ת��---
	;����ǲ��ŵ�
	.elseif	dwOption & F_PAUSE	
		;�жϸ����Ƿ������
		invoke	_QueryPosition
		mov	@szCurrentTime,eax
		add	eax,1
		cmp	eax,szMusicLength
		jna	@F
		;�����������-������һ�ײ���
		;����Ҫע����-��־λľ�иı����-���Ի�����ķ��������Ϣ
		mov	dwOption,0
		or	dwOption,F_START
		invoke SendMessage,hWinMain,MM_MCINOTIFY,MCI_NOTIFY_SUCCESSFUL,0
		;���������
		@@:
		mov	@szIData,100
		;��ʼ��������-����ٷֱ�
		finit 				;��������г�ʼ��-��ôst0~st1֮�䶼��Щ����ֵ-���ܲ�ͣ�ĳ�ʼ�������Ч�ʿ���
		fild	@szCurrentTime		;st1
		fild	szMusicLength		;st0
		fdiv				;�����st0
		fild	@szIData			;
		fmul
		fist	@szTemp			;st0->@szTemp
		invoke 	SendMessage,hPlayProgress,TBM_SETPOS,TRUE,@szTemp
		;��Ҫ��������ʾ��ʱ��
		invoke	RtlZeroMemory,addr szTimeBuffer,sizeof szTimeBuffer
		invoke	_ShowTime,@szCurrentTime
		invoke	SetDlgItemText,hWinMain,MUSIC_TIME,addr szTimeBuffer
	.elseif	dwOption & F_START
		;��ת�� 
	.endif
	
	popad
	ret

_CountTimer endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:�̺߳���:���ƹ�����
;˵��:
;(1)�����ʽ���̺߳�����ͨ�ø�ʽ
;(2)�漰���߳�-�һ��ǰ�ÿһ����д��ϸ��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;_CoutBar	proc	uses ebx esi edi,_lParam
;		LOCAL	@szCurrentTime:DWORD
;		LOCAL	@szTemp:DWORD
;		LOCAL	@szIData:DWORD
;		
;		invoke	SetEvent,hEvent
;		@LOOP:	
;		invoke	_QueryPosition		;��ѯ��ǰ��ʱ��
;		mov	@szCurrentTime,eax
;		cmp	eax,szMusicLength		;��ǰʱ�䳤�Ⱥ��ܵ�ʱ�䳤�ȱȽ�
;		jne	@F			;����Ⱦ���-
;		invoke	_Stop
;		invoke	_Close
;		invoke	_JudgeModel
;		@@:
;		mov	@szIData,100
;		mov	@szCurrentTime,eax
;		;��ʼ��������-����ٷֱ�
;		finit 				;��������г�ʼ��-��ôst0~st1֮�䶼��Щ����ֵ-���ܲ�ͣ�ĳ�ʼ�������Ч�ʿ���
;		fild	@szCurrentTime		;st1
;		fild	szMusicLength		;st0
;		fdiv				;�����st0
;		fild	@szIData			;
;		fmul
;		fist	@szTemp			;st0->@szTemp
;		invoke 	SendMessage,hPlayProgress,TBM_SETPOS,TRUE,@szTemp
;		;��Ҫ��������ʾ��ʱ��
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
;����;����һ�������(��Χ:_dwFirst~_dwSecond)
;����1:�����������
;����2;�����������
;���ù�ʽ: Rand_Number = (Rand_Seed * X + Y) mod Z
;����˵��:
;           (1)�������� GetTickCount ��ȡ����������ӣ�
;              ��ʵ��Ӧ���У����ñ�ķ������档
;           (2)Ҫ�����������X��Y����֮һ������������
;              ���� X = 23, Y = 7�����ñ���������棩
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_iRand	proc _dwFirst:DWORD,_dwSecond:DWORD
	
	;GetTickCount ��ȡ��windows��������������ʱ�䳤�ȣ����룩
	invoke GetTickCount ; ȡ����������ӣ���Ȼ�����ñ�ķ�������
   	mov	ecx, 23         	 ; X = ecx = 23
   	mul 	ecx            	 ; eax = eax * X
   	add 	eax, 7         	 ; eax = eax + Y ��Y = 7��
   	mov	ecx,_dwSecond   	 ; ecx = ����
  	sub 	ecx, _dwFirst      	 ; ecx = ���� - ����
   	inc  	ecx             	 ; Z = ecx + 1 ���õ��˷�Χ��
   	xor  	edx, edx       	 ; edx = 0
   	div  	ecx             	 ; eax = eax mod Z ��������edx���棩
   	add	edx,_dwFirst        	 ; ����������������ķ�Χ
   	mov	eax, edx             ; eax = Rand_Number	
	ret

_iRand endp


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:��Ծ��ָ���ط�
;����1--�����ĵ�ǰ����ʱ��
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_SeekMusic proc _dwCurrentTime:DWORD
	LOCAL	@stSeekParam:MCI_SEEK_PARMS
	LOCAL	@stMciPlay:MCI_PLAY_PARMS
;	invoke	_QueryPosition
	
	push	hWinMain
	pop	@stSeekParam.dwCallback
	mov	eax,_dwCurrentTime
	mov	@stSeekParam.dwTo,eax
	;ÿ����ת֮��-��Ȼ����ͣ��-��������Ҫ�ָ����Ų���
	invoke	mciSendCommand,hDevice,MCI_SEEK,MCI_TO or MCI_WAIT,addr @stSeekParam
	push	_dwCurrentTime
	pop	@stMciPlay.dwFrom
	invoke	mciSendCommand,hDevice,MCI_PLAY,MCI_FROM,addr @stMciPlay
;	invoke	_ReplayMusic
	ret

_SeekMusic endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:ͨ����ǰ�ļ���-����ȡ��ǰ�ļ���ȫ·��
;����1:������·����
;����ֵ:�ļ���ȫ·�������szCurrentMSPath
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_GetCurrentFilePath proc lpListFileName:DWORD,lpSectionName:DWORD
	;��Ȼ��ʱ�����������һ��û�б�Ҫ������-����Ϊ�˱�����ֲ���Ҫ���������-�һ��������һ�»���
	;ͻȻ��������ĳһ������-̸��sizeof�ĺô�-�Ǳ����ʲô����-��-�������
	;��ʱ�����д����Ӧ����һ������������-��Ӧ����������-����ע��  �Ǻ� ����ϰ�߰�
	invoke RtlZeroMemory,addr szCurrentMSPath,sizeof szCurrentMSPath
	;д������-�Ҳ���ע����һ��-�����ļ���·���Ƿ��ڴ��崴����ʱ���д����-��Ҫע�����-�����ı����Ƿ��޸���?
	invoke GetPrivateProfileString,lpSectionName,lpListFileName,addr szDefault,addr szCurrentMSPath,sizeof szCurrentMSPath,addr szConfPath
	ret

_GetCurrentFilePath endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:���浱ǰ����״̬�������ļ���-������ǰ�����Ÿ���������ֵ
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_SavePlayModel	proc
	
	;���浱ǰ���Ÿ���������ֵ
;	invoke	RtlZeroMemory,addr dwSaveValue,sizeof dwSaveValue
	mov	dwSaveValue,0
	mov	eax,dwMusicIndex
	invoke	wsprintf,addr dwSaveValue,L("%d"),eax
	invoke	WritePrivateProfileString,addr szPlayOption,addr szPlayIndex,addr dwSaveValue,addr szConfPath
	;���浱ǰ���Ÿ�����״̬---szPlayStatus
	mov	dwSaveValue,0
	;������������
	.if	dwPlayModel & F_RANDOM
		mov	eax,1
	;�����ѭ������
	.elseif	dwPlayModel & F_SEQUENCE
		mov	eax,2
	;������б�ѭ��
	.elseif	dwPlayModel & F_ONCE
		mov	eax,3	
	.endif
	invoke	wsprintf,addr dwSaveValue,L("%d"),eax	
	invoke	WritePrivateProfileString,addr szPlayOption,addr szPlayStatus,addr dwSaveValue,addr szConfPath
	ret

_SavePlayModel endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:���浱ǰ������С-�������ļ� 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_GetVolumeInConf proc
	
;	dwPosSound   ;��Ҫ3���ֽ�--ʵ������4���ֽ�
	mov	dwSaveValue,0
	mov	eax,dwPosSound
	invoke	wsprintf,addr dwSaveValue,L("%d"),eax
	;д�����ļ�-���浽ָ����ֵ
	invoke	WritePrivateProfileString,addr szPlayOption,addr szSoundValue,addr dwSaveValue,addr szConfPath
	ret

_GetVolumeInConf endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:����������ֵ
;������ֵ�������Ĵ�С����10
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_SetVolume proc _dwSoundValue:DWORD
	LOCAL	@stSV:MCI_DGV_SETAUDIO_PARMS
	
;	invoke MessageBox,NULL,L("�ɹ�"),L("�ɹ�"),MB_OK
	mov ebx,10
	mov eax,_dwSoundValue
	mul  ebx						;MUL  EBX ;��EBX��ֵ����EAX��ֵ�����ѽ����EDX:EAX
	mov @stSV.dwValue,eax
	mov @stSV.dwItem,4002h 	;MCI_DGV_SETAUDIO_VOLUME
	
	invoke mciSendCommand,hDevice,0873h,00800000h or 01000000h,addr @stSV
	ret

_SetVolume endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:���-����
;����1:ƫ�Ƶ�ʱ��
;�����������-����������-0��ʾ��ǰֵ
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
	;��ʼ��������-����ٷֱ�
	finit 				;��������г�ʼ��-��ôst0~st1֮�䶼��Щ����ֵ-���ܲ�ͣ�ĳ�ʼ�������Ч�ʿ���
	fild	@szCurrentTime		;st1
	fild	szMusicLength		;st0
	fdiv							;�����st0
	fild	@szIData				;��st0������@szIData��
	fmul
	fist	@szTemp			;st0->@szTemp
	invoke 	SendMessage,hPlayProgress,TBM_SETPOS,TRUE,@szTemp
	;��Ҫ��������ʾ��ʱ��
	mov	eax,@szTemp
	mul	szMusicLength
	mov	ecx,100
	div	ecx
	invoke	_ShowTime,eax
	invoke	SetDlgItemText,hWinMain,MUSIC_TIME,addr szTimeBuffer
	ret

_SetPlaySpeed endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:���Ž�����-�Զ�����
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_SetPlayPos proc
	
	
	ret

_SetPlayPos endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:���Ÿ���
;����:���Ÿ���������ֵ
;˵��:
;(1)��������-�б�������ֵ�Ǵ�0��ʼ������
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_PlayMusic proc _dwMusicIndex:DWORD
	;�ر���һ��������---��֪���ǲ��Ƕ����
	invoke	_Stop
	invoke	_Close
	;��������ֵ�����ж�
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
	;�������������-���ǵ�ǰ�����б������
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
;����:��ȡ�б���е���Ŀ��-��������ֵ
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_GetMaxIndex proc 
	
	
	ret

_GetMaxIndex endp


;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;����:�жϵ�ǰ����ģʽ-��������ֵ
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_JudgeModel	proc
	LOCAL	@dwIndex
	
	invoke	SendMessage,hListMusic,LB_GETCOUNT,0,0
	.if	eax == 0
		invoke	MessageBox,hWinMain,L("�б���û�и���-��Ҳû�д�һ�׸���-�뵼�����--"),L("����"),MB_OK
	.else
		;������������
		.if	dwPlayModel & F_RANDOM
			invoke _iRand,0,nMaxIndex
			invoke _PlayMusic,eax
		;�����ѭ������
		.elseif	dwPlayModel & F_SEQUENCE
			mov	eax,dwMusicNext
			cmp	eax,nMaxIndex
			jb	@F
			;�Ѿ�������-��󲥷�����-���³�ʼ��Ϊ0-��������
			mov	dwMusicNext,0
			invoke	_PlayMusic,dwMusicNext
			;û�г����������
		@@:	mov	eax,dwMusicNext
			add	dwMusicNext,1
			invoke	_PlayMusic,eax
			
		;������б�ѭ��
		.elseif	dwPlayModel & F_ONCE	
			mov	eax,dwMusicNext
			cmp	eax,nMaxIndex
			jb	@F
			;�Ѿ�������-��󲥷�����-���³�ʼ��Ϊ0-��������
			invoke	MessageBox,hWinMain,L("�Ѿ������һ�׸���"),L("��ܰ��ʾ:"),MB_OK
			;û�г����������
		@@:	mov	eax,dwMusicNext
			add	dwMusicNext,1
			invoke	_PlayMusic,eax
		.endif
	.endif	
	ret

_JudgeModel endp


