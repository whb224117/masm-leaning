 .386
        .model flat ,stdcall

NULL    equ 0
MB_OK   equ 0

ExitProcess PROTO :DWORD
MessageBoxA PROTO :DWORD,:DWORD,:DWORD,:DWORD

;���������� û��Ҳ���� ����д��include user32.inc ��include kernel32.inc

includelib kernel32.lib
includelib user32.lib

          .data
szText    db "Hello, world!",0
szCaption db "Win32Asm",0

        .code 
start: 
        push MB_OK
        lea eax,szCaption
        push eax
        lea eax,szText
        push eax
        push NULL
        call MessageBoxA
        xor eax,eax
        push eax
        call ExitProcess
        end start
