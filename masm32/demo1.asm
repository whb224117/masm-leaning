;----------------
;编译模式
;----------------
.model small
.stack 200h
.data
	szMsg db 'Hello World!',13,10,'$'
	
.CODE
START:
	mov ax,@data
	mov ds,ax
	
	lea dx,szMsg
	mov ah,9
	int 21h
	
	mov ah,4ch    ;结束，可更改al设置返回码
	int 21h
END START