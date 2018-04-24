L   [a-fA-F_]
A   [a-fA-F_0-9]
WS  [ \t\v\f]

%{
#include <stdio.h>
#include "compile.tab.h"

//<<<<<<< HEAD
extern void yyerror(const char *);
extern int yylineno = 1; 
// When ready, change printf -> return
//=======
//extern void yyerror(const char *); 
//>>>>>>> master
%}

%%

"PROGRAM"	{ return(PROGRAM); }
"INTEGER"	{ return(INTEGER); }
"BEGIN"		{ return(START); }
"END."		{ return(END); }
"PRINT"		{ return(PRINT); }
"VAR"		{ return(VAR); }
{L}{A}*		{ return(IDENTIFIER); }
[1-9][0-9]*	{ return(INT); }
"'"(.)+"'"	{ return(STRING); } 

"-"		{ return '-'; }
"+"		{ return '+'; }
"*"		{ return '*'; }
"/"		{ return '/'; }
","		{ return ','; }
":"		{ return ':'; }
"="		{ return '='; }
"("		{ return '('; }
")"		{ return ')'; }
";"		{ return ';'; }
"'"		{ return '\''; }

{WS}+		{;}
[\n]		{yylineno++;}
.		{printf("Unexpected character at line %d\n", yylineno); exit(EXIT_FAILURE);}

%%

int yywrap(void){
	return 1;
}
