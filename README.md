# CPSC-323-Group-Compiler
Group Project for CPSC 323

## Progress
**03-05-2018:** 
Created compiler.c which determines if we are in a comment. 
Added the final.txt and abc13.cpp from the project specification.
Was able to get excess space, excess newlines and comments removed from text.
Next step is to adjust spacing around variabes.

**03-06-2018:**
Created compile.l, renamed compiler.c -> scanner.c, created new lex and yacc that do syntactical analysis of program.
Basic syntactical analysis using lex/yacc.

Compilation Instructions:
lex compile.l
yacc -d compile.y
cc lex.yy.c y.tab.c
./a.out

To test the final1.txt against the language:
./a.out <final1.txt

### To Do List: ###

* Polish off the remaining grammar issues in Yacc

* Add actions for each section in Yacc

* Create error list for syntax errors

* Translate to C++
