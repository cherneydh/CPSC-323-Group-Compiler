L   [a-zA-Z_]
A   [a-zA-Z_0-9]
WS  [ \t\v\n\f]

%{
#include <stdio.h>
#include "y.tab.h"

extern void yyerror(const char *); 
// When ready, change printf -> return
%}

%%

"PROGRAM"	{ return(PROGRAM); }
"INTEGER"	{ return(INTEGER); }
"BEGIN"		{ return(START); }
"END."		{ return(END); }
"PRINT"		{ return(PRINT); }
"VAR"		{ return(VAR); }

{L}{A}*		{ return(IDENTIFIER); }
[1-9][0-9]*	{ return(INTEGER); }

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

{WS}+		;
.		;

%%

int yywrap(void){
	return 1;
}
