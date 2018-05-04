myscanner: lex.yy.c compile.tab.h compile.tab.c
	g++ lex.yy.c compile.tab.c -o a.out

compile.tab.c: compile.y
	bison -d compile.y

lex.yy.c: compile.l
	flex compile.l

clean: 
	rm a.out compile.tab.c compile.tab.h lex.yy.c
