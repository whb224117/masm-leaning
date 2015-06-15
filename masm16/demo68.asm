assume cs:codesg,ds:data

data segment
a db 1,2,3,4,5,6,7,8
b dw 0   
;c dw offset a,seg a,offset b,seg b  ;seg 操作符 取得某一标号的段地址
;ds:data不能去掉 省略换报错
;有标号就不能省略 因为标号可以再所有的段中使用
;此处的a，b相当于偏移地址
data ends
codesg segment

start:
       mov ax,data
	   mov ds,ax
	   mov si,0
	   mov cx,8
s:     
       mov al,a[si]
	   mov ah,0
	   add b,ax
	   inc si
	   loop s
	   
	   mov ax,4c00h
	   int 21h
	   
codesg ends
end start