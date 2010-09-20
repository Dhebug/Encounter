

#include <stdio.h>
#include <stdlib.h>
#include <string.h> 

#include "xah.h"
#include "xar.h"
#include "xa.h"
#include "xat.h"
#include "xao.h"


// -----------------------------------------------------------------------------
//
//									Options
//
// -----------------------------------------------------------------------------

struct Fopt 
{
	signed char 	*text;          // text after pass1 
	int     		len;
};

Options::Options()
{
	m_olist = NULL;
	m_mlist = 0;
	m_nlist = 0;
}


Options::~Options()
{
	Clear();
}

void Options::Clear()
{
	for (int i=0;i<m_nlist;i++) 
	{
		free(m_olist[i].text);
	}
	free(m_olist);
	m_olist = NULL;
	m_nlist = 0;
	m_mlist = 0;
}

// sets file option after pass 1 
void Options::set_fopt(int l, signed char *buf, int reallen) 
{
	while (m_mlist<=m_nlist) 
	{
		m_mlist +=5;
		m_olist = (Fopt*)realloc(m_olist, m_mlist*sizeof(Fopt));
		if (!m_olist) 
		{	
			fprintf(stderr, "Fatal: Couldn't alloc memory (%d bytes) for fopt list!\n",m_mlist*sizeof(Fopt));
			exit(1);
		}
	}
	m_olist[m_nlist].text=(signed char*)malloc(l);
	if (!m_olist[m_nlist].text) 
	{
		fprintf(stderr, "Fatal: Couldn't alloc memory (%d bytes) for fopt!\n",l);
		exit(1);
	}
	memcpy(m_olist[m_nlist].text, buf, l);
	m_olist[m_nlist++].len = reallen;
}

// writes file options to a file
void Options::o_write(FILE *fp)
{
	int i,j,l,afl;
	signed char *t;
	
	for (i=0;i<m_nlist;i++) 
	{
		l=m_olist[i].len;
		t=m_olist[i].text;
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
	
	Clear();
}

size_t Options::o_length(void) 
{
	int i;
	size_t n = 0;
	for (i=0;i<m_nlist;i++) 
	{
		// printf("found option: %s, len=%d, n=%d\n", m_olist[i].text, m_olist[i].len,n);
		n += m_olist[i].len +1;
	}
	return ++n;
}

