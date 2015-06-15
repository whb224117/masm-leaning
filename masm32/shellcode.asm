;----------------
;编译模式
;----------------
.386
.model flat,stdcall
;.model 内存模式[,语言格式],其他格式]
option casemap:none
.data
	szMsg db 'Hello World!',13,10,'$'
	
.CODE
START:
	lea edx,szMsg
	mov ah,9
	int 21h
	
	mov ah,4ch    ;结束，可更改al设置返回码
	int 21h
	
	push ebp
	mov ebp,esp
	xor eax,eax
	push eax
	push eax
	push eax
	mov byte ptr[ebp-0ch],6dh
	mov byte ptr[ebp-0bh],73h
	mov byte ptr[ebp-0ah],76h
	mov byte ptr[ebp-09h],63h
	mov byte ptr[ebp-08h],72h
	mov byte ptr[ebp-07h],74h
	mov byte ptr[ebp-06h],2eh
	mov byte ptr[ebp-05h],64h
	mov byte ptr[ebp-04h],6ch
	mov byte ptr[ebp-03h],6ch
	lea eax,[ebp-0ch]
	push eax
	mov eax,76a10000h
	call eax
END START