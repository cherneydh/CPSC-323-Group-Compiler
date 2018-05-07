L   [a-fA-F_]
A   [a-fA-F_0-9]
WS  [ \t\v\f]

%{
#include <iostream>
#include <fstream>
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
string appendage = "";
bool flag = false;
bool pflag = false;
bool printFlag = false;
// When ready, change printf -> return
//=======
//extern void yyerror(const char *); 
//>>>>>>> master
ofstream outfile("abc13.cpp");
%}

%%

"PROGRAM"	{ outfile << "#include<iostream>\nusing namespace std;"; pflag = true; return(PROGRAM); }
"INTEGER"	{ outfile << "int "; outfile << appendage; appendage.clear(); return(INTEGER); }
"BEGIN"		{ outfile << "int main(){"; return(START); }
"END."		{ outfile << "return 0;}"; return(END); }
"PRINT"		{ outfile << "cout << "; printFlag = true; return(PRINT); }
"VAR"		{ flag = true; pflag = false; return(VAR); }
{L}{A}*		{ string temp2; char *hold2 = yytext;
		  temp2 = hold2; cstr2 = new char[temp2.length() + 1];
		  strcpy(cstr2, temp2.c_str());
		  yylval.iden = cstr2;
		  if(flag)
		  {
		  appendage += cstr2;
		  }
		  else
		  {
		  if(pflag) 
		  	{}
		  else 
			{outfile << cstr2;}
		  }
		  return(IDENTIFIER); }
[1-9][0-9]*	{ string temp; char* hold = yytext; 
		  temp = hold; cstr = new char[temp.length() + 1]; 
		  strcpy(cstr, temp.c_str()); 
		  yylval.num = atoi(cstr);
		  outfile << atoi(cstr); return (INT);}
"'"(.)+"'"	{ string temp3; char* hold3 = yytext;
		  temp3 = hold3; cstr3 = new char[temp3.length() + 1];
		  strcpy(cstr3, temp3.c_str());
		  yylval.strings = cstr3;
		  outfile << "\"" << cstr3 << "\"";
		  return(STRING); } 

"-"		{ outfile << "-"; return '-'; }
"+"		{ outfile << "+"; return '+'; }
"*"		{ outfile << "*"; return '*'; }
"/"		{ outfile << "/"; return '/'; }
","		{ if(flag){appendage += ",";}else { if(printFlag){outfile << " << ";} else {outfile << ",";}} return ','; }
":"		{ flag = false; return ':'; }
"="		{ outfile << "="; return '='; }
"("		{ if(printFlag){}else {outfile << "(";} return '('; }
")"		{ if(printFlag){}else {outfile << ")";} printFlag = false; return ')'; }
";"		{ if(pflag){}else{outfile << ";";} return ';'; }
"'"		{ outfile << "\'"; return '\''; }

{WS}+		{if(flag){appendage += " ";} else{outfile << " ";}}
[\n]		{outfile << "\n"; yylineno++;}
.		{printf("Unexpected character at line %d\n", yylineno);}

%%

int yywrap(void){
	delete[] cstr;
	delete[] cstr2;
	delete[] cstr3;
	outfile.close();
	return 1;
}
