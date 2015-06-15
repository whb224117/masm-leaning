
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
include windows.inc
include user32.inc
includelib user32.lib
include kernel32.inc
includelib kernel32.lib

;数据段

.const
szCaption   db '欢迎光临鱼c工作室',0
szText      db '来吧，和我一起开始win32的汇编之路吧',0
szOK        db '您刚才点击了OK按钮',0
szCANCEL    db '您刚才点击了CANCEL按钮',0
;代码段
.code     ;带,的是伪指令 是给编译器看的
start:
      invoke MessageBox,\     ;反斜杠表示换行  invoke 调用
	  NULL,\                  ;父窗口句柄
	  offset szCaption,\
	  offset szText,\         ;标题
	  MB_OKCANCEL or MB_ICONQUESTION
	  cmp eax,IDOK
	  je @F
	  invoke MessageBox,NULL,offset szCANCEL,offset szText,MB_OK
	  jmp EXIT
@@:   invoke MessageBox,NULL,offset szOK,offset szText,MB_OK
EXIT: invoke ExitProcess,NULL
end start

;当用@做标号时@F标号表示本指令之后最近的一个@@标号
;@B表示本指令之前的最近的一个@@标号
;当程序中有多个@@标号时 它们只寻找离他们最近的@@标号
;跳转时常用 不用定义那么多的跳转标号 头疼
