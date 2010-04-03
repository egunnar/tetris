#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char * argv[]){
	//size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream); 	
	FILE * fh = fopen("sample.dat", "wb");
	char * name = "erik";
	int score = 40;
	fwrite(name, 1, strlen(name) + 1, fh);
	fwrite(&score, sizeof(score), 1, fh);

	name = "joe";
	score = 3;
	fwrite(name, 1, strlen(name) + 1, fh);
	fwrite(&score, sizeof(score), 1, fh);

	fclose(fh);
}
