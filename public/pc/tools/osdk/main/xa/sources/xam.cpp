
#pragma warning( disable : 4996)   // #define _CRT_SECURE_NO_WARNINGS
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "xah.h"         // structs

static int ninc = 0;
static char **nip = NULL;
 
void reg_include(char *path) 
{
	char **nip2;
	if(path && *path) 
	{
		nip2 = (char**)realloc(nip,sizeof(char*)*(ninc+1));
		if(nip2) 
		{
			nip = nip2;
			nip[ninc++] = path;
		} 
		else 
		{
			fprintf(stderr,"Warning: couldn' alloc mem (reg_include)\n");
		}
	}
}


FILE *xfopen(const char *fn,const char *mode)
{
	FILE *file;
	char c,*cp,n[MAXLINE],path[MAXLINE];
	char xname[MAXLINE], n2[MAXLINE];
	int i,l;
	
	if (!fn)
	{
		// No filename defined
		return 0;
	}

	l=(int)strlen(fn);
	if (l>=MAXLINE) 
	{
		fprintf(stderr,"filename '%s' too long!\n",fn);
		return NULL;
	}
	
	for (i=0;i<l+1;i++) 
	{
		xname[i]=((fn[i]=='\\')?DIRCHAR:fn[i]);
	}
	
	if (mode[0]=='r')
	{
		if ((file=fopen(fn,mode))==NULL && (file=fopen(xname, mode))==NULL) 
		{
			for (i=0;(!file) && (i<ninc);i++) 
			{
				strcpy(n,nip[i]);
				c=n[(int)strlen(n)-1];
				if(c!=DIRCHAR) strcat(n,DIRCSTRING);
				strcpy(n2,n);
				strcat(n2,xname);
				strcat(n,fn);
				/* printf("name=%s,n2=%s,mode=%s\n",n,n2,mode); */
				file=fopen(n,mode);
				if(!file) file=fopen(n2,mode);
			}
			if ((!file) && (cp=getenv("XAINPUT"))!=NULL)
			{
				strcpy(path,cp);
				cp=strtok(path,",");
				while (cp && !file)
				{
					if (cp[0])
					{
						strcpy(n,cp);
						c=n[(int)strlen(n)-1];
						if(c!=DIRCHAR&&c!=':')
							strcat(n,DIRCSTRING);
						strcpy(n2,n);
						strcat(n2,xname);
						strcat(n,fn);
						/* printf("name=%s,n2=%s,mode=%s\n",n,n2,mode); */
						file=fopen(n,mode);
						if(!file) file=fopen(n2,mode);
					}
					cp=strtok(NULL,",");
				}
			}
		}
	} 
	else
	{
		if ((cp=getenv("XAOUTPUT"))!=NULL)
		{
			strcpy(n,cp);
			if (n[0])
			{
				c=n[(int)strlen(n)-1];
				if (c!=DIRCHAR&&c!=':')
				{
					strcat(n,DIRCSTRING);
				}
			}
			cp=strrchr((char*)fn,DIRCHAR);
			if (!cp)
			{
				cp=strrchr((char*)fn,':');
				if(!cp)
					cp=(char*)fn;
				else
					cp++;
			} 
			else
			{
				cp++;
			}
			strcat(n,cp);
			file=fopen(n,mode);
		} 
		else
		{
			file=fopen(fn,mode);
		}
	}
	if(file)
	{
		setvbuf(file,NULL,_IOFBF,BUFSIZE);
	}
	
	return file;
}

