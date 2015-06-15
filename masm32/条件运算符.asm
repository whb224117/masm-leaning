;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; by 小甲鱼, http://www.fishc.com+ V7 v: @% l' W9 R/ N% `
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>/ a; z8 N. G1 X6 g, V
; 功能：条件运算符的使用
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        .386
        .model flat,stdcall
        option casemap:none

include windows.inc
include user32.inc
include kernel32.inc
includelib user32.lib
includelib kernel32.lib
    .data
szCaption   db  '鱼C工作室', 0
szText1     db  '代号为我爱你', 0
szText2     db  '木有进位', 0
szText3     db  '进，进位了', 0
szFmt       db  'eax = %d(eax==1满足), ebx = %d(置进位标识), edx = %d(edx为零满足)', 0
buffer      db  80 dup(0)

    .code
start:
    mov ax, 250
    xor ax, 754
    cmp ax, 520
    .if ZERO?
        invoke MessageBox, NULL, offset szText1, offset szCaption, MB_OK
    .endif   
    .if CARRY?
        invoke  MessageBox, NULL, offset szText3, offset szCaption, MB_OK
    .else
        invoke  MessageBox, NULL, offset szText2, offset szCaption, MB_OK
    .endif
    
    mov ax, 32769
    add ax, ax
    .if CARRY?
        invoke  MessageBox, NULL, offset szText3, offset szCaption, MB_OK
    .else
        invoke  MessageBox, NULL, offset szText2, offset szCaption, MB_OK
    .endif
    
    invoke ExitProcess, 0  ; 结束进程
    
end start

;ＣＡＲＲＹ?　　　　　　测试进位标志位是否置位
;ＺＥＲＯ?　　　　　　　测试零标志位是否置位'
;ＳＩＧＮ?　　　　　　　测试符号标志位是否置位
;ＰＡＲＩＴＹ?　　　　　测试奇偶标志位是否置位
;ＯＶＥＲＦＬＯＷ?　　　测试溢出标志位是否置位