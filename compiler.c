#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include "logging.h"
/* 0 = Note, 1 = Error, 2 = Warning, 3 = Announce */

enum{
 COMMENT, NORMAL
} op = NORMAL;

enum{
 NEW, CONTENT, NO_CONTENT
} con = NEW;

enum{
 TRUE, FALSE
} need_space = FALSE;

enum{
 IN, OUT
} in_quote = OUT;

int getc(FILE * _File);

int main(){
	/* Declare variables */
	int c;
	int next_c;
	int prev_c;
	int space = ' ';
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

	next_c = getc(source);	
	while(c != EOF){
		if(con == NEW){
			write_log(__LINE__,__func__,3,"Con is set to NEW","");
		}
		if(con == CONTENT){
			write_log(__LINE__,__func__,3,"Con is set to CONTENT","");
		}
		if(con == NO_CONTENT){
			write_log(__LINE__,__func__,3,"Con is set to NO_CONTENT","");
		} 
		c = next_c;
		next_c = getc(source);	
		string[0] = c;

		/* Set con when new line in comment */
		if(con == NEW && op == COMMENT){
			con == NO_CONTENT;
			write_log(__LINE__,__func__,3,"Establishing no content on new line inside a comment","");
		}
		
		/* Establishing end of quote */
		if(c == '\'' && in_quote == TRUE){
			write_log(__LINE__,__func__,3,"Start Quote","");
			in_quote = FALSE;
		}
		
		/* Establishing inside a quote */
		if(c == '\'' && op != COMMENT){
			write_log(__LINE__,__func__,3,"End Quote","");
			in_quote = TRUE;
		}

		/* Set the flag that we are in a comment if these conditions are true */
		if(c == '(' && next_c == '*'){
			if(con == NEW){
				write_log(__LINE__,__func__,3,"Establishing no content on new line","");
				con = NO_CONTENT;
			}
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
		if(c == ' ' && next_c == ' '){
			write_log(__LINE__,__func__,0,"Ignoring Excess Space","");
			continue;
		}
	
		/* Ignoring space before a comma  */
		if(c == ' ' && next_c == ','){
			write_log(__LINE__,__func__,0,"Ignoring Space before comma","");
			continue;
		}
	

		/* Ignore space before a semi colon */
		if(c == ' ' && next_c == ';'){
			write_log(__LINE__,__func__,0,"Ignoring space before semicolon","");
			continue;
		}
	
		/* Adding space after comma */
		if(c == ',' && !(isspace(next_c))){
			write_log(__LINE__,__func__,0,"Adding Space after comma","");
			need_space = TRUE;	
		}

		/* Equals sign spacing */
		if((!(isspace(c))) && next_c == '=' && in_quote == FALSE){
			write_log(__LINE__,__func__,0,"Space before equals","");
			need_space = TRUE;
		}

		/* Equals sign spacing */
		if(c == '=' && (!(isspace(next_c))) && in_quote == FALSE){
			write_log(__LINE__,__func__,0,"Space after equals","");
			need_space = TRUE;
		}

		/* If we are in a comment, ignore the character. */
		if(op == COMMENT){
			write_log(__LINE__,__func__,0,"Ignoring","Inside Comment");
			prev_c = c;
			continue;
		}

		/* Skip the newline if the line had no content */
		if(isspace(c) && con == NO_CONTENT){
			write_log(__LINE__,__func__,0,"Skipping white space on no content line","");
			continue;
		}
	
		/* Print to file */	
		if(c != EOF){
			write_log(__LINE__,__func__,0,"Commiting",string);
			con = CONTENT;
			fputc(c, dest);
		}		
		
		/* Reset con */
		if(c == '\n'){
			con = NEW;
			write_log(__LINE__,__func__,3,"Reseting content","");		
		}
		
		/* Adding space where needed */
		if(need_space == TRUE){
			fputc(space, dest);
			need_space = FALSE;
		}

		prev_c = c;
	}
	

	fclose(source);
	fclose(dest);
	close_log();
}
