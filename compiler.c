#include <stdio.h>
#include <ctype.h>

#define COMMENT 1 /* 0000 0001 */
/* f |= to on */
/* f &= to off */

int main(){
	/* Declare variables */
	int c;
	int prev_c;
	FILE * source;
	FILE * dest;

	/* Open source and destination files */
	source = fopen("final.txt", "r");
	dest = fopen("final1.txt", "w");
	
	if((source != NULL) && (dest != NULL)){
		while((c = fgetchar()) != EOF){
			/* Set the flag that we are in a comment if these conditions are true */
			if(c == '*' && prev_c == '('){
				flags |= COMMENT;
			}
			
			/* Set the flag that we left the comment if these conditions are true */
			if(c == ')' && prev_c == '*'){
				flags &= COMMENT;
			}
			
			/* If there is white space after a newline, ignore. */
			if(isspace(c) && prev_c == '\n'){
				continue;
			}
			
			/* If we are in a comment, ignore the character. */
			if(flags & COMMENT){
				prev_c = c;
				continue;
			}
			
			/* Print char to destination file */
			fprintf(dest, c);
			
			prev_c = c;
		}
	}
	
	fclose(source);
	fclose(dest);
}
