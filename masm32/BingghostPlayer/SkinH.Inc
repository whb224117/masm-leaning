;************************************************************
;子程序作者：	非虫 fei_cong@hotmail.com
;子程序功能： 	skinsharp v1.0.5.6 的声明
 
;************************************************************


SkinH_Attach	PROTO

;功能:加载程序当前目录下的skinh.she皮肤 
;返回值:成功返回0，失败返回非0 


SkinH_AttachEx	PROTO	strSkin:LPCTSTR, strPwd:LPCTSTR  

;参数:
;strSkin 皮肤文件路径  
;strPwd 皮肤密钥  
;
;功能:加载指定路径的皮肤进行换肤 
;返回值:成功返回0，失败返回非0  



SkinH_AttachExt	PROTO strSkin:LPCTSTR, strPwd:LPCTSTR, nHue:DWORD, nSat:DWORD, nBri:DWORD

;参数:
;strSkin 皮肤文件路径  
;strPwd 皮肤密钥  
;nHue 色调，取值范围1-360,默认值0 
;nSat 饱和度，取值范围1-256,默认值0 
;nBri 亮度，取值范围1-256,默认值0 
;
;功能:加载指定路径的皮肤进行换肤并指定相应的色调，饱和度，亮度 
;返回值:成功返回0，失败返回非0  




SkinH_AttachRes	PROTO	pShe:DWORD, nSize:DWORD, strPwd:LPCTSTR, nHue:DWORD, nSat:DWORD, nBri:DWORD

;参数:
;pShe 	资源皮肤数据指针  
;nSize 	资源皮肤数据长度  
;strPwd 皮肤密钥  
;nHue 	色调，取值范围1-360,默认值0 
;nSat 	饱和度，取值范围1-256,默认值0 
;nBri 	亮度，取值范围1-256,默认值0 
;
;功能:加载指定资源进行换肤并指定相应的色调，饱和度，亮度 
;返回值:成功返回0，失败返回非0  



SkinH_AttachResEx	PROTO strResName:LPCTSTR,strResType:LPCTSTR

;参数:
;strResName 资源名
;strResType 资源类型
;
;功能:从exe或dll资源加载皮肤.
;返回值:成功返回0，失败返回非0  



SkinH_Detach	PROTO 

;参数:无 
;
;功能:卸载换肤 (注意:在换肤或者程序退出时换肤库会自动卸载当前皮肤,无需再
;				调用此接口进行卸载) 
;返回值:成功返回0，失败返回非0  


SkinH_DetachEx	PROTO hWnd:HWND

;参数:
;hWnd 指定窗体或控件的句柄  
;
;功能:卸载指定句柄的窗体或者控件的皮肤 
;返回值:成功返回0，失败返回非0  




SkinH_SetWindowAlpha	PROTO hWnd:HWND, nAlpha:DWORD 

;参数:
;hWnd 指定窗体或控件的句柄  
;nAlpha 透明度  
;
;功能:设置指定句柄的窗体的透明度 
;返回值:成功返回0，失败返回非0 



SkinH_SetFont	PROTO	hWnd:HWND, hFont:HFONT

;参数:
;hWnd,		//控件的句柄
;hFont		//字体句柄
;
;功能:	设置控件的字体
;返回值: 成功返回0, 失败返回非0
 

SkinH_SetFontEx	PROTO	hWnd:HWND, szFace:DWORD, nHeight:DWORD, \
						nWidth:DWORD, nWeight:DWORD, nItalic:DWORD, \
						nUnderline:DWORD, nStrikeOut:DWORD

;参数:
;hWnd,		//控件的句柄
;szFace,	//字体名称
;nHeight,	//字体高度
;nWidth,		//字体宽度
;nWeight,	//字体磅数
;nItalic,	//是否斜体
;nUnderline,	//是否下划线
;nStrikeOut	//是否删除线

;功能:	设置控件的字体
;返回值: 成功返回0, 失败返回非00
		

SkinH_GetColor	PROTO hWnd:HWND, nPosX:DWORD, nPosY:DWORD

;参数:
;hWnd 指定窗体或控件的句柄  
;nPosX 横坐标  
;nPosY 纵坐标  
;
;功能:获取指定窗口或控件在nX,nY处的颜色值  
;返回值:成功返回无符号整型的颜色值(RGB)，失败返回0  




SkinH_AdjustHSV	PROTO	nHue:DWORD, nSat:DWORD, nBri:DWORD

;参数:
;nHue 色调，取值范围1-360,默认值0 
;nSat 饱和度，取值范围1-256,默认值0 
;nBri 亮度，取值范围1-256,默认值0 
;
;功能:调整当前皮肤的色调，饱和度，亮度 
;返回值:成功返回0，失败返回非0  



SkinH_Map	PROTO	hWnd:HWND, nType:DWORD 

;参数:
;hWnd 指定窗体或控件的句柄  
;nType 				换肤类型				取值如下
;类型  				对应数值  			注释 
TYPE_UNKNOWN 		EQU		0 		;未知类型
TYPE_ANIMATE 	 	EQU		1001 	;动画控件 
TYPE_CHECKBOX  		EQU		1002 	;复选框
TYPE_COMBOBOX  		EQU		1003 	;组合框
TYPE_COMBOLBOX  	EQU		1004	;组合下拉框
TYPE_CONTROLBAR  	EQU		1005 	;控件栏
TYPE_DATETIME  		EQU		1006 	;日期控件
TYPE_EDITBOX  		EQU		1007 	;文本框
TYPE_GROUPBOX  		EQU		1008 	;分组框
TYPE_HEADERCTRL  	EQU		1009 	;列头控件
TYPE_HOTKEY  		EQU		1010 	;热键控件
TYPE_IPADDRESS  	EQU		1011 	;IP地址控件
TYPE_LABEL  		EQU		1012 	;标签控件
TYPE_LISTBOX  		EQU		1013 	;列表框
TYPE_LISTVIEW  		EQU		1014 	;列表视图
TYPE_MDICLIENT  	EQU		1015 	;MDI客户区
TYPE_MENU  			EQU		1016 	;菜单
TYPE_MONTHCAL  		EQU		1017 	;月历控件
TYPE_PICTURE  		EQU		1018 	;图片框
TYPE_PROGRESS  		EQU		1019 	;进度条
TYPE_PUSHBUTTON  	EQU		1020 	;普通按钮
TYPE_RADIOBUTTON  	EQU		1021 	;单选框
TYPE_REBAR  		EQU		1022 	;重组栏
TYPE_RICHEDIT  		EQU		1023 	;富文本框
TYPE_SCROLLBAR  	EQU		1024 	;滚动条
TYPE_SCROLLCTRL  	EQU		1025 	;内置滚动条的控件
TYPE_SPINCTRL  		EQU		1026 	;调节器
TYPE_STATUSBAR  	EQU		1027 	;状态栏
TYPE_TABCTRL  		EQU		1028 	;选择夹
TYPE_TOOLBAR  		EQU		1029 	;工具栏
TYPE_TOOLBARWND  	EQU		1030 	;MFC工具栏窗体
TYPE_TRACKBAR  		EQU		1031 	;滑条控件
TYPE_TREEVIEW  		EQU		1032 	;树形视图
TYPE_WINDOW  		EQU		1034 	;标准窗体
TYPE_COMCTRL  		EQU		1036 	;通用换肤
TYPE_PAINTCTRL  	EQU		1037 	;通用换肤

;功能:指定窗体和控件的换肤类型 
;返回值:成功返回0，失败返回非0 



SkinH_LockUpdate	PROTO	hWnd:HWND, nLocked:DWORD 

;参数:
;hWnd 指定窗体或控件的句柄  
;nLocked 是否锁定。1为锁定，0为解锁  
;
;功能:用于填充表格或者列表控件数据时，重复绘制滚动条影响执行效率问题 
;返回值:成功返回0，失败返回非0  



SkinH_SetAero	PROTO	nEnable:DWORD

;参数:
;nEnable  1为开启特效,0为关闭特效  
;
;功能:设置Vista特效 
;返回值:成功返回0，失败返回非0  




SkinH_SetBackColor	PROTO	hWnd:HWND, nRed:DWORD, nGreen:DWORD, nBlue:DWORD

;参数:
;hWnd 控件句柄  
;nRed 红色分量  
;nGreen 绿色分量  
;nBlue 蓝色分量  
;
;功能:设置控件的背景色(目前仅对单选框,复选框,分组框有效) 
;返回值:成功返回0，失败返回非0  



SkinH_SetForeColor	PROTO	hWnd:HWND, nRed:DWORD, nGreen:DWORD, nBlue:DWORD 

;参数:
;hWnd 控件句柄  
;nRed 红色分量  
;nGreen 绿色分量  
;nBlue 蓝色分量  
;
;功能:设置控件的文本颜色色(目前仅对单选框,复选框,分组框有效) 
;返回值:成功返回0，失败返回非0  


SkinH_SetWindowMovable	PROTO	hWnd:HWND, bMove:BOOL
 
;参数:
;hWnd 窗口句柄  
;bMove 0为不可移动,1为可移动 
;
;功能:设置窗体是否可以移动 
;返回值:成功返回0，失败返回非0  



SkinH_AdjustAero	PROTO	nAlpha:DWORD,  nShwDark:DWORD,  nShwSharp:DWORD, \
							nShwSize:DWORD, nX:DWORD, nY:DWORD, nRed:DWORD, \
							nGreen:DWORD, nBlue:DWORD

;参数:
;nAlpha 透明度, 0-255, 默认值0 
;nShwDark 亮度, 0-255, 默认值0 
;nShwSharp 锐度, 0-12, 默认值0  
;nShwSize 阴影大小, 0-18, 默认值0  
;nX 水平偏移, 0-25, 默认值0  
;nY 垂直偏移, 0-25, 默认值0  
;nRed 红色分量, 0-255, 默认值0  
;nGreen 绿色分量, 0-255, 默认值0  
;nBlue 蓝色分量, 0-255, 默认值0  
;
;功能:设置透明窗体参数
;返回值:成功返回0，失败返回非0  



SkinH_NineBlt	PROTO	hDtDC:HDC, left:DWORD, top:DWORD, right:DWORD, bottom:DWORD, nMRect:DWORD

;参数:
;hDtDC 目标设备上下文 
;left 左上角水平坐标 
;top 左上角垂直坐标 
;right 右下角水平坐标 
;bottom 右下角垂直坐标 
;nMRect 元素id 
;
;功能:绘制指定设备上下文的元素 
;返回值:成功返回0，失败返回非0   



SkinH_SetTitleMenuBar	PROTO	hWnd:HWND, nEnable:DWORD, nTop:DWORD, nRight:DWORD

;参数:
;hWnd 指定窗体句柄  
;nEnable 是否启用标题菜单栏；0停用，1启用
;nHeight 0为默认；一般设置为22或10；根据需要设置
;nTop 顶部偏移
;nRight 右部偏移
;
;功能:在窗口标题栏定义菜单
;返回值:成功返回0，失败返回非0  
;说明:WIN7系统下不可与SkinH_SetAero()函数同时使用.



SkinH_SetMenuAlpha	PROTO	nAlpha:DWORD

;参数:
;nAlpha 透明度, 0-255
;
;功能:设置菜单的透明度
;返回值:成功返回0，失败返回非0  



;错误代码  
SRET_OK 			EQU		0 ;操作成功 
SRET_ERROR 			EQU		1 ;操作失败 
SRET_ERROR_FILE 	EQU		2 ;文件操作失败 
SRET_ERROR_PARAM 	EQU		3 ;参数错误 
SRET_ERROR_CREATE 	EQU		4 ;创建皮肤失败 
SRET_ERROR_FORMAT 	EQU		5 ;皮肤格式错误 
SRET_ERROR_VERSION 	EQU		6 ;皮肤版本错误 
SRET_ERROR_PASSWORD EQU		7 ;皮肤密码错误 

