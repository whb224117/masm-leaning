NAME = FirstWindow
OBJS = $(NAME).obj

LINK_FLAG = /subsystem:windows
ML_FLAG = /c /coff

$(NAME).exe: $(OBJS)
	Link $(LINK_FLAG) $(OBJS)
.asm.obj:
	ml $(ML_FLAG) $<

#	$<	第一个依赖文件的名称。

clean:
	del *.obj
