

#include <stdio.h>
#include <stdlib.h>
#include <string.h> 

#include "xah.h"
#include "xar.h"
#include "xa.h"
#include "xat.h"
#include "xao.h"


// sets file option after pass 1 
void set_fopt(int l, signed char *buf, int reallen) 
{
	while (afile->fo.mlist<=afile->fo.nlist) 
	{
		afile->fo.mlist +=5;
		afile->fo.olist = (Fopt*)realloc(afile->fo.olist, afile->fo.mlist*sizeof(Fopt));
		if (!afile->fo.olist) 
		{	
			fprintf(stderr, "Fatal: Couldn't alloc memory (%d bytes) for fopt list!\n",afile->fo.mlist*sizeof(Fopt));
			exit(1);
		}
	}
	afile->fo.olist[afile->fo.nlist].text=(signed char*)malloc(l);
	if (!afile->fo.olist[afile->fo.nlist].text) 
	{
		fprintf(stderr, "Fatal: Couldn't alloc memory (%d bytes) for fopt!\n",l);
		exit(1);
	}
	memcpy(afile->fo.olist[afile->fo.nlist].text, buf, l);
	afile->fo.olist[afile->fo.nlist++].len = reallen;
}

// writes file options to a file
void o_write(FILE *fp)
{
	int i,j,l,afl;
	signed char *t;
	
	for (i=0;i<afile->fo.nlist;i++) 
	{
		l=afile->fo.olist[i].len;
		t=afile->fo.olist[i].text;
		t_p2(t, &l, 1, &afl);
		
		if (l>254) 
		{
			errout(E_OPTLEN);
		} 
		else 
		{
			fputc((l+1)&0xff,fp);
		}
		for (j=0;j<l;j++) 
		{ 
			fputc(t[j],fp);
			// printf("%02x ", t[j]);
		}
		// printf("\n");
	}
	fputc(0,fp);		// end option list
	
	for (i=0;i<afile->fo.nlist;i++) 
	{
		free(afile->fo.olist[i].text);
	}
	free(afile->fo.olist);
	afile->fo.olist = NULL;
	afile->fo.nlist = 0;
	afile->fo.mlist = 0;
}

size_t o_length(void) 
{
	int i;
	size_t n = 0;
	for (i=0;i<afile->fo.nlist;i++) 
	{
		// printf("found option: %s, len=%d, n=%d\n", afile->fo.olist[i].text, afile->fo.olist[i].len,n);
		n += afile->fo.olist[i].len +1;
	}
	return ++n;
}

