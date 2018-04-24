%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *);
extern int yylex();
extern int yylineno;
extern char* yytext;
%}

/* Yacc Definitions */
%token PROGRAM START END PRINT VAR
%token INTEGER INT IDENTIFIER STRING
%start start

%%
start		: PROGRAM pname middle {;} // ';' VAR declist ';' START statlist stop {;} 
		| error {printf("Expected PROGRAM at line %d, but found %s instead\n", yylineno, yytext); exit(EXIT_FAILURE);}
		;

middle		: ';' {;}
		| ';' variable {;}
		| error {printf("Expected ; at line %d\n", (yylineno - 1)); exit(EXIT_FAILURE);}
		;

variable	: VAR declist ending {;}
		| error {printf("Expected VAR at line %d, but found %s instead\n", yylineno, yytext); exit(EXIT_FAILURE);}
		;

ending		: ';' {;}
		| ';' statements {;}
		| error {printf("Expected ; at line %d\n", (yylineno - 1)); exit(EXIT_FAILURE);}
		;

statements	: START statlist stop {;}
		| error {printf("Expected BEGIN at line %d, but found %s instead\n", yylineno, yytext); exit(EXIT_FAILURE);}
		;

stop		: END {exit(EXIT_SUCCESS);}
		;

pname		: id {;}
		;

id		: IDENTIFIER {;}
		| error { printf("Expected an identifier at line %d, but found %s instead\n", yylineno, yytext); exit(EXIT_FAILURE);}
		;

declist		: dec ':' type {;}
		| error {printf("Expected : at line %d\n", yylineno); exit(EXIT_FAILURE);}
		;

/*colonCheck	: ':' type {;}
		| error {printf("Expected : at line %d\n", yylineno); exit(EXIT_FAILURE);}
		;*/

dec		: /*id commaCheck {;}*/id ',' dec {;} 
		| id {;}
//		| error {printf("Expected , at line %d\n", yylineno); exit(EXIT_FAILURE);} // fix this, there is a reduce problem
		;

/*commaCheck	: ',' decCheck {;}
		| error {printf("Expected , at line %d\n", yylineno); exit(EXIT_FAILURE);}
		;

decCheck	: dec {;}
		| error {printf("Expected an identifier at line %d, but found %s instead\n", yylineno, yytext); exit(EXIT_FAILURE);}
		;*/

statlist	: stat ';' {;}
		| stat ';' statlist {;}
		| error {printf("Expected a ; at line %d\n", yylineno); exit(EXIT_FAILURE);}
		;

/*semiColonCheck	: ';' {;}
		| ';' statlist {;}
		| error {printf("Expected a ; at line %d", yylineno); exit(EXIT_FAILURE);} 
		;*/

stat		: print {;}
		| assign {;}
		;

print		: PRINT '(' output ')' {;}
		;

output 		: id {;}
		| STRING ',' id {;} 
		;

assign		: id '=' expr
		| error { printf("= is missing at line %d\n", yylineno); exit(EXIT_FAILURE);}
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
		| error {printf("Expected INTEGER at line %d, but found %s", yylineno, yytext); exit(EXIT_FAILURE);}
		;
%%
#include <stdio.h>

int main(){
	return(yyparse());
}

void yyerror(const char *s)
{
	fflush(stdout);
	fprintf(stderr, "*** %s at line %d\n", s, yylineno);
}
