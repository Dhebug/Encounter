
#include <stdio.h>
#include <stdlib.h>

#include "xau.h"
#include "xah.h"
#include "xal.h"
//#include "xah.h"


#define fputw(a,fp)     fputc((a)&255,fp);fputc((a>>8)&255,fp)


// -----------------------------------------------------------------------------
//
//								UndefinedLabels
//
// -----------------------------------------------------------------------------

UndefinedLabels::UndefinedLabels()
{
	m_ulist = NULL;
	m_un = 0;
	m_um = 0;
}

UndefinedLabels::~UndefinedLabels()
{
	Clear();
}

void UndefinedLabels::Clear()
{
	free(m_ulist);
	m_ulist=NULL;
	m_um = m_un = 0;
}


int UndefinedLabels::u_label(int labnr) 
{
	int i;
	// printf("u_label: %d\n",labnr);
	if (!m_ulist) 
	{
		m_ulist = (int*)malloc(200*sizeof(int));
		if(m_ulist) m_um=200;
	}
	
	for(i=0;i<m_un;i++) 
	{
		if(m_ulist[i] == labnr) return i;
	}
	if(m_un>=m_um) 
	{
		m_um    = (int)(m_um*1.5);
		m_ulist = (int*)realloc(m_ulist, m_um * sizeof(int));
		if(!m_ulist) 
		{
			fprintf(stderr, "Panic: No memory!\n");
			exit(1); 
		}
	}
	m_ulist[m_un] = labnr;
	return m_un++;
}


void UndefinedLabels::u_write(FILE *fp) 
{
	// printf("u_write: un=%d\n",un);
	fputw(m_un,fp);
	
	for(int i=0;i<m_un;i++) 
	{
		SymbolEntry& symbol_entry=afile->m_cSymbolData.GetSymbolEntry(m_ulist[i]);
		const char *s=symbol_entry.GetSymbolName();
		fprintf(fp,"%s", s);
		fputc(0,fp);
	}
	Clear();
}

