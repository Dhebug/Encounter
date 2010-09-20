 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* structs and defs */

#include "xah.h"
#include "xar.h"
#include "xa.h"

// externals

#include "xam.h"
#include "xal.h"

// exported globals

char   *gError_LabelNamePointer;

// local prototypes 

static int b_fget(int*,int);
static int b_ltest(int,int);
static int b_get(int*);
int b_test(int);

static SEGMENT_e bt[MAXBLK];
static SEGMENT_e blk;
static int bi;



int gm_lab(void)
{
	return ANZLAB;
}

long gm_labm(void)
{
	return ((long)LABMEM);
}

long ga_labm(void)
{
	return 0;
}


          
ErrorCode SymbolData::DefineLabel(char *ptr_src,int *size_read,int *x,bool *flag_redefine_label)
{     
	*flag_redefine_label=false;

	int block_level=0;
	int n=0;
	int	i=0;
	
	if (ptr_src[0]=='-')
	{
		// Allows label redefinition
		*flag_redefine_label=true;
		i++;
	} 
	else
	if (ptr_src[0]=='+')
	{
		// Defines a global label
		i++;
		n++;
		block_level=0;
	} 
	while (ptr_src[i]=='&')
	{
		// If a label is proceeded by a '&', this label is defined one level 'up' in the block hierarchy, and you can use more than one '&'.
		n=0;     
		i++;
		block_level++;
	}
	if (!n)
	{
		b_fget(&block_level,block_level);
	}
		
		
	if (!isalpha(ptr_src[i]) && ptr_src[i]!='_')
	{
		return E_SYNTAX;
	}

	ErrorCode er=SearchSymbol(ptr_src+i,&n);	
	if (er==E_OK)
	{
		SymbolEntry& symbol_entry=GetSymbolEntry(n);
		
		if (*flag_redefine_label)
		{
            *size_read=symbol_entry.label_name_lenght+i;
		} 
		else
		if (symbol_entry.symbol_status==eSYMBOLSTATUS_UNKNOWN)
		{
			*size_read=symbol_entry.label_name_lenght+i;
			if (b_ltest(symbol_entry.GetBlockLevel(),block_level))
			{
				er=E_LABDEF;
			}
			else
			{
				symbol_entry.SetBlockLevel(block_level);
			}
			
		} 
		else
		{
			er=E_LABDEF;
		}
	} 
	else
	if (er==ERR_UNDEFINED_LABEL)
	{
		//
		// Add a new label in the global table
		//
		if (!(er=DefineSymbol(ptr_src+i,&n,block_level))) /* ll_def(...,*flag_redefine_label) */
		{
			SymbolEntry& symbol_entry=GetSymbolEntry(n);
			*size_read=symbol_entry.label_name_lenght+i;
			symbol_entry.symbol_status=eSYMBOLSTATUS_UNKNOWN;
		}
	} 	
	*x=n;
	return er;
}

ErrorCode SymbolData::l_such(char *s, int *l, int *x, int *v, int *afl)
{
	ErrorCode er;
	int	n,b;
	
	*afl=0;
	
	er=SearchSymbol(s,&n);
	if (er==E_OK)
	{
		SymbolEntry& symbol_entry=GetSymbolEntry(n);
		*l=symbol_entry.label_name_lenght;
		if (symbol_entry.symbol_status==eSYMBOLSTATUS_VALID)
		{
			SymbolEntry& symbol_entry=GetSymbolEntry(n);
			er=symbol_entry.Get(v,afl);
			*x=n;
		} 
		else
		{
			er=ERR_UNDEFINED_LABEL;
			gError_LabelNamePointer=symbol_entry.ptr_label_name;
			*x=n;
		}
	}
	else
	{
		b_get(&b);
		er=DefineSymbol(s,x,b); /* ll_def(...,*v); */
		
		SymbolEntry& symbol_entry=GetSymbolEntry(*x);
		
		*l=symbol_entry.label_name_lenght;
		
		if (!er) 
		{
			er=ERR_UNDEFINED_LABEL;
			gError_LabelNamePointer=symbol_entry.ptr_label_name;   
		}
	}
	return er;
}




ErrorCode SymbolData::ll_pdef(char *t)
{
	int n;
	if (SearchSymbol(t,&n)==E_OK)
	{
		SymbolEntry& symbol_entry=GetSymbolEntry(n);
		if (symbol_entry.symbol_status)
		{
			return E_OK;
		}
	}
	return ERR_UNDEFINED_LABEL;
}


int b_init(void)
{
     blk =eSEGMENT_ABS;
     bi	 =0;
     bt[bi]=blk;

     return E_OK;
}     

int b_depth(void)
{
     return bi;
}

int ga_blk(void)
{
	return blk;
}

int b_open(void)
{
	int er=E_BLKOVR;
	
	if (bi<MAXBLK-1)
	{
		blk=(SEGMENT_e)(blk+1);
		bt[++bi]=blk;
		
		er=E_OK;  
	}
	return er;
}

ErrorCode b_close(void)
{	
	if (bi)
	{
		afile->m_cSymbolData.ExitBlock(bt[bi],bt[bi-1]);
		bi--;
	} 
	else 
	{
		return E_BLOCK;
	}
	
	return E_OK;
}

static int b_get(int *n)
{
	*n=bt[bi];
	
	return E_OK;
}

static int b_fget(int *n, int i)
{
	if((bi-i)>=0)
		*n=bt[bi-i];
	else
		*n=0;
	return E_OK;
}

int b_test(int n)
{
     int i=bi;

     while( i>=0 && n!=bt[i] )
          i--;

     return i+1 ? E_OK : E_NOBLK;
}

static int b_ltest(int a, int b)    /* testet ob bt^-1(b) in intervall [0,bt^-1(a)]   */
{
     int i=0;
	 int er=E_OK;

     if(a!=b)
     {
          er=E_OK;

          while(i<=bi && b!=bt[i])
          {
               if(bt[i]==a)
               {
                    er=E_NOBLK;
                    break;
               }
               i++;
          }
     }
     return er;
}



// -----------------------------------------------------------------------------
//
//								SymbolEntry
//
// -----------------------------------------------------------------------------


void SymbolEntry::Set(int v,SEGMENT_e afl)
{
	value			= v;
	symbol_status	=eSYMBOLSTATUS_VALID;
	program_section	=afl;
}

ErrorCode SymbolEntry::Get(int *v,int *afl)
{
	(*v)=value;
	gError_LabelNamePointer=ptr_label_name;
	*afl = program_section;
	return ( (symbol_status==eSYMBOLSTATUS_VALID) ? E_OK : ERR_UNDEFINED_LABEL);
}

int SymbolEntry::DefineSymbol(char *ptr_src,int block_level)
{
	int	j=0;
	while ((ptr_src[j]!=0) && (isalnum(ptr_src[j]) || (ptr_src[j]=='_'))) j++;
	char *label_name = (char*)malloc(j+1);
	if (!label_name) 
	{
		fprintf(stderr,"Oops: no memory!\nlabel_index");
		exit(1);
	}
	strncpy(label_name,ptr_src,j);
	label_name[j]=0;
	ErrorCode er=E_OK;
	value				=0;
	label_name_lenght	=j;
	ptr_label_name		=label_name;
	m_block_level		=block_level;
	symbol_status		=eSYMBOLSTATUS_UNKNOWN;
	program_section		=eSEGMENT_ABS;
	int hash=hashcode(ptr_src,j); 
	return hash;
}

