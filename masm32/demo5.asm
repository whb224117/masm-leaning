 .386
        .model flat,stdcall
        option casemap:none

include windows.inc

include kernel32.inc
include user32.inc

includelib kernel32.lib
includelib user32.lib

        .data
mess    db 'How are you !',0    ;要显示的信息

        .data?
StdOut  dd ?    ;存放标准输出的把柄
CharOut dd ?    ;记录实际输出的字符数

        .code
start:  
        invoke GetStdHandle,STD_OUTPUT_HANDLE   ;获取标准输出的把柄
        mov StdOut,eax      ;保存把柄号

        lea eax,mess
        invoke lstrlen,eax  ;求字符串的长度

        lea ecx,CharOut
        invoke WriteFile,StdOut,addr mess,eax,ecx,NULL  ;写文件
        
        invoke ExitProcess,NULL   ;程序结束
        end start
