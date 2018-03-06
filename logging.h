#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

FILE *file;

int c;
char buffer[1024];

char *asciitime;
time_t current;
struct tm * formal_time;

char type[20];
char *err = type;

void open_log(){
	file = fopen("console.log", "w");
	memset(buffer, '\0', sizeof(buffer));
	setvbuf(file, buffer, _IOFBF, 1024);
}

void close_log(){
	fclose(file);
}

void read_log(){
	system("cat console.log");
}

/* DATE AND TIME || LINE NUMBER || CONTEXTUAL NAME || TYPE || DESCRIPTION || OTHER */
void write_log(const int line, const char *name, int severity, char *descript, char* other){
	switch(severity){
		case 1:
			err = "Error";
			break;
		case 2:
			err = "Warning";
			break;
		case 3: 
			err = "Announce";
			break;
		default:
			err = "Note";
			break;	
	}
	time(&current);
	formal_time = localtime(&current);
	asciitime = asctime(formal_time);
	asciitime[strlen(asciitime)-1] = 0;
	fprintf(file, "%s || Line: %d || Contextual Name: %s || Type: %s || Description: %s || Other: %s\n", asciitime,line, name, err, descript, other);
}

void flush_log(){
	fflush(file);
}


