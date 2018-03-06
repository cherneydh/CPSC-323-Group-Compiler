%{
#include "scanner.h"
%}

%%
:		return COLON;
[(]		return OPEN_PAREN;
[)]		return CLOSE_PAREN;
[,]		return COMMA;
'		return QUOTE;
[+*/-]		return OPERATOR;
=		return EQUAL;
PROGRAM		return PROGRAM;
INTEGER		return INTEGER;
BEGIN		return START;
END[.]		return END;
PRINT		return PRINT;
VAR		return VAR;
;		return SEMICOLON;

[a-zA-Z][_a-zA-Z0-9]*	return IDENTIFIER;
[1-9][0-9]*		return INTEGER;
[ \t\n]			;
.			;
%%

int yywrap(void){
	return 1;
}
