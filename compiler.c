#include <stdio.h>
#include "scanner.h"

extern int yylex();
extern int yylineno;
extern char* yytext;

char *names[] = {NULL, "BEGIN", "END.", "PRINT", "PROGRAM", "VAR", "INTEGER"};

int main(void){
	int ntoken, vtoken;

	ntoken = yylex();
	while(ntoken) {
		printf("%d\n", ntoken);
		//if(yylex() != COLON){
			// printf("Syntax error in line %d, UNKNOWN IDENTIFIER %s\n", yylineno, yytext);
		//	return 1;
		//}
		ntoken = yylex();
	}
	return 0;
}
