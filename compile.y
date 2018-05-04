%{
#include <iostream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

void yyerror(const char *);
extern int yylex();
extern int yylineno;
extern char* yytext;
int tableCount;
string symbols[4];
int symbolTable[4]; //hard coded b/c i know there's only 4
int getSymbolValue(string symbol);
void updateSymbolTable(string symbol, int value);
%}

/* Yacc Definitions */
%union {int num; char* iden; char* strings;}
%token PROGRAM START END PRINT VAR
%token INTEGER
%token <num> INT
%token <iden> IDENTIFIER
%token <strings> STRING
%type <iden> assign //id
%type <num> expr term factor number
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

pname		: IDENTIFIER//id {;}
		| error {printf("Expected an identifier at line %d, but found %s instead\n", yylineno, yytext); exit(EXIT_FAILURE);}
		;

/*id		: IDENTIFIER {$$ = getSymbolValue($1);}//{$$ = getsymboltablevalue($1);}
		| error { printf("Expected an identifier at line %d, but found %s instead\n", yylineno, yytext); exit(EXIT_FAILURE);}
		;*/

declist		: dec ':' type {;}
		| error {printf("Expected : at line %d\n", yylineno); exit(EXIT_FAILURE);}
		;

/*colonCheck	: ':' type {;}
		| error {printf("Expected : at line %d\n", yylineno); exit(EXIT_FAILURE);}
		;*/

dec		: /*id commaCheck {;}*/IDENTIFIER ',' dec {;} 
		| IDENTIFIER {;}
		| error {printf("Expected an identifer at line %d, but found %s instead\n", yylineno, yytext); exit(EXIT_FAILURE);} // fix this, there is a 
																    // reduce problem
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

print		: PRINT outputCheck {;}//'(' output ')' {printf("%d", $3);}
		| error {printf("Expected PRINT on line %d, but found &s instead\n", yylineno, yytext); exit(EXIT_FAILURE);}
		;

outputCheck	: '(' output ')' {;}//{printf("%d", $2);}
		| error {printf("Expected parentheses on line %d, but found %s instead", yylineno, yytext); exit(EXIT_FAILURE);}
		;

output 		: IDENTIFIER {cout << getSymbolValue($1);}
		| STRING ',' IDENTIFIER {cout << $1 << getSymbolValue($3);} 
		;

assign		: IDENTIFIER '=' expr {updateSymbolTable($1, $3);}
//		| error { printf("= is missing at line %d\n", yylineno); exit(EXIT_FAILURE);}
		;

expr		: term {$$ = $1;}
		| expr '+' term {$$ = $1 + $3;}
		| expr '-' term {$$ = $1 - $3;}
		;

term		: term '*' factor {$$ = $1 * $3;}
		| term '/' factor {$$ = $1 / $3;}
		| factor {$$ = $1;}
		;

factor		: IDENTIFIER {$$ = getSymbolValue($1);}//{$$ = getSymbolValue($1);}
		| number {;} //{$$ = $1}
		| '(' expr ')' {$$ = $2;}
		;

number		: INT {$$ = $1;}
		;

type		: INTEGER
		| error {printf("Expected INTEGER at line %d, but found %s", yylineno, yytext); exit(EXIT_FAILURE);}
		;
%%
#include <stdio.h>

int getSymbolValue(string symbol){
	for(int i = 0; i < 4; i++)
	{
		if(symbols[i] == symbol)
		{
		return symbolTable[i];
		}
	}
cout << "Unrecognized symbol at line " << yylineno << endl;
exit(EXIT_FAILURE);
return 0;
}

void updateSymbolTable(string symbol, int value){
	symbols[tableCount] = symbol;
	symbolTable[tableCount] = value;
	tableCount++;
}

int main(){
	for(int i = 0; i < 4; i++)
	{
	symbols[i] = "";
	symbolTable[i] = 0;
	}
	tableCount = 0;
	return(yyparse());
}

void yyerror(const char *s)
{
	fflush(stdout);
	fprintf(stderr, "*** %s at line %d\n", s, yylineno);
}
