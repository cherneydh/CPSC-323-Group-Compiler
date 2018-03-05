#include <stdio.h>

#define COMMENT 1 /* 0000 0001 */
/* f |= to on */
/* f &= to off */

int main(){
	int c;
	int prev_c;
	FILE * source;
	FILE * dest;
	
	source = fopen("final.txt", "r");
	dest = fopen("final1.txt", "w");
	
	if(source != NULL){
		while((c = fgetchar()) != EOF){
			if(c == '*' && prev_c == '('){
				flags |= COMMENT;
			}
			
			if(c == ')' && prev_c == '*'){
				flags &= COMMENT;
			}
			
			if(c == '\n' && prev_c == '\n'){
				continue;
			}
			
			if(flags & COMMENT){
				prev_c = c;
				continue;
			}
			
			fprintf(dest, c);
			
			prev_c = c;
		}
	}
	
	fclose(source);
	fclose(dest);
}