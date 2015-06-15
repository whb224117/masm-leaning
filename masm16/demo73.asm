assume cs:code
code segment
start:
      mov ax,0b800h
	  mov es,ax
	  mov bx,0  ;es:bxÖ¸Ïò½«Ğ´Èë´ÅÅÌµÄÊı¾İµÄÄÚ´æÇø
	  
	  mov al,8  ;Ğ´ÈëµÄÉÈÇøÊı
	  mov ch,0  ;´ÅµÀºÅ ´Ó0¿ªÊ¼
	  mov cl,1  ;ÉÈÇøºÅ ´Ó1¿ªÊ¼
	  mov dl,0  ;Çı¶¯Æ÷ºÅ0£ºÈíÇıa£¬1£ºÈíÇıb£¬´ÅÅÌ´Ó80h¿ªÊ¼ 80h:Ó²ÅÌc 81h:Ó²ÅÌd
	  mov dh,0  ;´ÅÍ·ºÅ(¶ÔÓÚÈíÅÌ¼´ÃæºÅ£¬ÒòÎªÒ»¸öÃæÓÃÒ»¸ö´ÅÍ·À´¶ÁĞ´£)
	  mov ah,3  ;´«µİ int13h Ğ´ÈëÊı¾İµÄ¹¦ÄÜºÅ
	  int 13h
	  ;·µ»Ø²ÎÊı
	  ;²Ù×÷³É¹¦£º(ah)=0(al)=Ğ´ÈëµÄÉÈÇøÊı
	  ;²Ù×÷Ê§°Ü(ah)=³ö´í´úÂë
return:
      mov ax,4c00h
	  int 21h
code ends
end start