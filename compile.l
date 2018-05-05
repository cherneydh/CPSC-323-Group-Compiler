L   [a-fA-F_]
A   [a-fA-F_0-9]
WS  [ \t\v\f]

%{
#include <iostream>
#include <stdio.h>
#include <string.h>
#include "compile.tab.h"
using namespace std;

//<<<<<<< HEAD
extern void yyerror(const char *);
extern int yylineno = 1;
char* cstr; 
char* cstr2;
char* cstr3;
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
{L}{A}*		{ string temp2; char *hold2 = yytext;
		  temp2 = hold2; cstr2 = new char[temp2.length() + 1];
		  strcpy(cstr2, temp2.c_str());
		  yylval.iden = cstr2;
		  return(IDENTIFIER); }
[1-9][0-9]*	{ string temp; char* hold = yytext; 
		  temp = hold; cstr = new char[temp.length() + 1]; 
		  strcpy(cstr, temp.c_str()); 
		  yylval.num = atoi(cstr); return (INT);}
"'"(.)+"'"	{ string temp3; char* hold3 = yytext;
		  temp3 = hold3; cstr3 = new char[temp3.length() + 1];
		  strcpy(cstr3, temp3.c_str());
		  yylval.strings = cstr3;
		  return(STRING); } 

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
.		{printf("Unexpected character at line %d\n", yylineno);}

%%

int yywrap(void){
	delete[] cstr;
	delete[] cstr2;
	delete[] cstr3;
	return 1;
}
