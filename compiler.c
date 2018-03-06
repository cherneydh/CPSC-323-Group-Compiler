#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include "logging.h"
/* 0 = Note, 1 = Error, 2 = Warning, 3 = Announce */

enum{
 COMMENT, NORMAL /* 0000 0001 */
/* f |= to on */
/* f &= to off */
} op = NORMAL;

int getc(FILE * _File);

int main(){
	/* Declare variables */
	int c;
	int check;
	int prev_c;
	char string[1];
	FILE * source;
	FILE * dest;
	
	/* Starting Log */
	open_log();

	/* Open source and destination files */
	if (!(source = fopen("final.txt", "r+"))){
		write_log(__LINE__,__func__,1,"Failed to Open final.txt","");
		exit(1);
	}else{
		write_log(__LINE__,__func__,3,"Opened final.txt","");
	}
	if (!(dest = fopen("final1.txt", "w"))){
		write_log(__LINE__,__func__,1,"Failed to Open final1.txt","");
		exit(1);
	}else{
		write_log(__LINE__,__func__,3,"Opened final1.txt","");
	}
	
	while((c = getc(source)) != EOF){
		string[0] = c;
		write_log(__LINE__,__func__,3,"Start Processing",string);

		/* Set the flag that we are in a comment if these conditions are true */
		if(c == '(' && (check=getc(source)) == '*'){
			ungetc(check, source);
			write_log(__LINE__,__func__,3,"Start Comment","");
			op = COMMENT;
		}
		
		/* Set the flag that we left the comment if these conditions are true */
		if(c == ')' && prev_c == '*'){
			write_log(__LINE__,__func__,3,"End Comment","");
			op = NORMAL;
			continue;
		}
		
		/* If there is white space after a newline, ignore. */
		if(isspace(c) && prev_c == '\n'){
			write_log(__LINE__,__func__,0,"Ignoring Space after new line","");
			continue;
		}
		
		/* If there is a space after a space, ignore. */
		if(c == ' ' && prev_c == ' '){
			write_log(__LINE__,__func__,0,"Ignoring Excess Space","");
			continue;
		}
		
		/* If we are in a comment, ignore the character. */
		if(op == COMMENT){
			write_log(__LINE__,__func__,0,"Ignoring","Inside Comment");
			prev_c = c;
			continue;
		}
		
		/* Print char to destination file */
		write_log(__LINE__,__func__,3,"Commiting to File",string);
		fputc(c, dest);
		
		prev_c = c;
	}
	

	fclose(source);
	fclose(dest);
	close_log();
}
