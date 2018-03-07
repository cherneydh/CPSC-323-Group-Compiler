%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *);
extern int yylex();
%}

/* Yacc Definitions */
%token PROGRAM START END PRINT VAR
%token INTEGER INT IDENTIFIER STRING
%start start

%%
start		: PROGRAM pname ';' VAR declist ';' START statlist END 
		;

pname		: id
		;

id		: IDENTIFIER
		| error { printf("***UNKNOWN IDENTIFIER\n"); }
		;

declist		: dec ':' type
		;

dec		: id ',' dec 
		| id
		;

statlist	: stat ';' 
		| stat ';' statlist
		;

stat		: print 
		| assign
		;

print		: PRINT '(' output ')'
		;

output 		: id
		| STRING ',' id 
		;

assign		: id '=' expr
		| error { printf("= is missing\n"); }
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

number		: INT
		;

type		: INTEGER
		;
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
