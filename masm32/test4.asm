
.386
.model flat,stdcall
;.model 内存模式[,语言格式],其他格式]
option casemap:none
;include 文件定义

;.386   使用386指令集 
;.model   flat   使用flat平坦内存模式 
;option   casemap:none　大小写敏感 
;.data 表示可读可写并定义的量
;.const 表示可读不可写的量
;data? 段中一般存放的是可读可写未定义的变量
;data? 段中的变量不会增加exe文件的大小 应为它只是一个标识
;szBuffer db 100*1024 dup(?) 表示用到100kb的缓冲区
include windows.inc   ;里面包含对MB_OK IDOK 的宏定义
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib

;数据段

.const
szCaption   db '欢迎光临鱼c工作室',0
szText1      db '你爱我吗?',0
szText2       db '谢谢，我也爱你!',0
;代码段
.code     ;带,的是伪指令 是给编译器看的
start:
      invoke MessageBox,\     ;反斜杠表示换行  invoke 调用
	  NULL,\                  ;父窗口句柄
	  offset szText1,\
	  offset szCaption,\         ;标题
	  MB_YESNO or MB_ICONQUESTION
	  .while  eax == IDNO	;带,的是伪指令 是给编译器看的
		invoke MessageBox,NULL,offset szText1,offset szCaption,MB_YESNO
	  .endw
	  invoke MessageBox,NULL,offset szText2,offset szCaption,MB_OK
end start