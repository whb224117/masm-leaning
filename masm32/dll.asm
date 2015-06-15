 .386
        .model flat,stdcall
        option casemap:none
;link subsystem:windows /dll /def:dll.def
include windows.inc

        .code
;DllEntry是动态链接库的入口，当动态链接库被加载/卸载时，或同一进程的线程生成/退出时，都会调用该入口函数
;当然，函数名不一定非是这个，但要和最后的End DllEntry保持一致。
DllEntry proc hInstDLL:HINSTANCE, reason:DWORD, reserved1:DWORD 
         mov  eax,TRUE  ;若返回FALSE，动态链接库就不会加载了
         ret 
DllEntry Endp 

;将EDX:EAX中的值转换成十进制输出形式字符串，很熟悉吧，前面的例子中有的！
OutEdxEax proc \            ;比如：EDX=0,EAX=01234567H,则转换后的字符串为：
  uses ebx esi edi,lpString ;        -> '19088743',0
        mov edi,lpString    ;指向存放结果的地址
        mov esi,lpString

        mov ecx,10          ;转换成十进制
        .while eax!=0 || edx!=0
            push eax    
            mov eax,edx
            xor edx,edx
            div ecx
            mov ebx,eax
            pop eax
            div ecx
            add dl,'0'      
            mov [edi],dl    ;存放结果
            inc edi
            mov edx,ebx
        .endw

        mov BYTE ptr [edi],0;字符串以0为结尾
        dec edi

        .while edi>esi      ;结果前变后，后变前！
            mov al,[esi]
            xchg al,[edi]
            mov [esi],al
            inc esi
            dec edi
        .endw
        ret
OutEdxEax endp
          end DllEntry
