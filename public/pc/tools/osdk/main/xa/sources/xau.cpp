
#include <stdio.h>
#include <stdlib.h>

#include "xau.h"
#include "xah.h"
#include "xal.h"

/*
static int *ulist = NULL;
static int un = 0;
static int um = 0;
*/

#define fputw(a,fp)     fputc((a)&255,fp);fputc((a>>8)&255,fp)

int u_label(int labnr) 
{
	int i;
	// printf("u_label: %d\n",labnr);
	if(!afile->ud.ulist) 
	{
		afile->ud.ulist = (int*)malloc(200*sizeof(int));
		if(afile->ud.ulist) afile->ud.um=200;
	}
	
	for(i=0;i<afile->ud.un;i++) 
	{
		if(afile->ud.ulist[i] == labnr) return i;
	}
	if(afile->ud.un>=afile->ud.um) 
	{
		afile->ud.um    = (int)(afile->ud.um*1.5);
		afile->ud.ulist = (int*)realloc(afile->ud.ulist, afile->ud.um * sizeof(int));
		if(!afile->ud.ulist) 
		{
			fprintf(stderr, "Panic: No memory!\n");
			exit(1); 
		}
	}
	afile->ud.ulist[afile->ud.un] = labnr;
	return afile->ud.un++;
}


void u_write(FILE *fp) 
{
	int i, d;
	char *s;
	// printf("u_write: un=%d\n",afile->ud.un);
	fputw(afile->ud.un, fp);
	
	for(i=0;i<afile->ud.un;i++) 
	{
		LabelGetInformations(afile->ud.ulist[i], &d, &s);
		fprintf(fp,"%s", s);
		fputc(0,fp);
	}
	free(afile->ud.ulist);
	afile->ud.ulist=NULL;
	afile->ud.um = afile->ud.un = 0;
}

