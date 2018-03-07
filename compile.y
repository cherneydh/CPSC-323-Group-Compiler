%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *);
extern int yylex();
%}

/* Yacc Definitions */
%token PROGRAM START END PRINT VAR
%token IDENTIFIER INTEGER 
%start start

%%
start		: PROGRAM pname';' VAR declist';' START statlist END 
		;
pname		: id
		;
id		: letter
		| id letter 
		| id digit
		;
declist		: dec ':' type
		;
dec		: id',' dec 
		| id
		;
statlist	: stat';' 
		| stat';' statlist
		;
stat		: print 
		| assign
		;
print		: PRINT '(' output ')'
		;
output 		: id
		| string ',' id 
		;
assign		: id '=' expr
		;
expr		: term
		| expr '+' term
		| expr '-' term
		;
term		: term '*' factor
		| term '/' factor
		| factor
		;
factor		: id
		| number
		| '(' expr ')'
		;
number		: digit 
		| digit number
		;
type		: INTEGER
		;
digit		: '0'
		| '1'
		| '2'
		| '3'
		| '4'
		| '5'
		| '6'
		| '7'
		| '8'
		| '9'
		;
letter		: 'a'
		| 'b'
		| 'c'
		| 'd'
		| 'e'
		| 'f'
		;
string		:;
%%
#include <stdio.h>

int main(){
	return(yyparse());
}

void yyerror(const char *s)
{
	fflush(stdout);
	fprintf(stderr, "*** %s\n", s);
}
