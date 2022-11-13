#if 0

#include <stdio.h>
#include <stdlib.h>


#define MAXLINE 30

struct student
{
	char name[MAXLINE];
	float marks;
};

FILE *stream;

int main()
{
	char ch;

	struct student s1, s2;

	stream = fopen("student.dat", "w+b");

	if (!stream) puts("file not open!!");
	fclose(stream);

	return 0;
}
#endif
