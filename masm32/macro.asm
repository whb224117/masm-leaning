include windows.inc
include kernel32.inc
include user32.inc

includelib  kernel32.lib
includelib  user32.lib

CTEXT MACRO y:VARARG
        LOCAL sym
        CONST segment
        ifidni ,<>
            sym db 0
        else
            sym db y,0
        endif
        CONST ends
        exitm 
ENDM

        .code
Start:
        invoke MessageBoxA,NULL,CTEXT("Hello, world !"),CTEXT("Hi!"),MB_ICONINFORMATION
        invoke ExitProcess,NULL
        end Start