 
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
static int b_test(int);
static int ll_def(char *s, int *n, int b);     

static SEGMENT_e bt[MAXBLK];
static SEGMENT_e blk;
static int bi;

#define   hashcode(n,l)  (n[0]&0x0f)|(((l-1)?(n[1]&0x0f):0)<<4)



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


int DefineGlobalLabel(char *s ) 
{
	int n;
	int er = LabelTableLookUp(s,&n);
	if (er==E_OK) 
	{
		fprintf(stderr,"Warning: global label doubly defined!\n");
	}
	else 
	{
		if (!(er=ll_def(s,&n,0))) 
		{
			SymbolEntry	*ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+n;
			ptr_symbol_entry->symbol_status		=eSYMBOLSTATUS_GLOBAL;
			ptr_symbol_entry->program_section	=eSEGMENT_UNDEF;
		}
	}
	return er;
}

          
int DefineLabel(char *s,int *l,int *x,int *f)
{     
    int		n,er,b,i=0;
	
	*f=0;
	b=0;
	n=0;
	
	if (s[0]=='-')
	{
		*f+=1;
		i++;
	} 
	else
	if (s[0]=='+')
	{
		i++;
		n++;
		b=0;
	} 
	while (s[i]=='&')
	{
		n=0;     
		i++;
		b++;
	}
	if (!n)
	{
		b_fget(&b,b);
	}
		
		
	if (!isalpha(s[i]) && s[i]!='_')
	{
		er=E_SYNTAX;
	}
	else
	{
		er=LabelTableLookUp(s+i,&n);
		
		if (er==E_OK)
		{
			SymbolEntry	*ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+n;
			
			if (*f)
			{
                *l=ptr_symbol_entry->label_name_lenght+i;
			} 
			else
			if (ptr_symbol_entry->symbol_status==eSYMBOLSTATUS_UNKNOWN)
			{
				*l=ptr_symbol_entry->label_name_lenght+i;
				if (b_ltest(ptr_symbol_entry->blk,b))
				{
					er=E_LABDEF;
				}
				else
				{
					ptr_symbol_entry->blk=b;
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
			if (!(er=ll_def(s+i,&n,b))) /* ll_def(...,*f) */
			{
				SymbolEntry	*ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+n;
				*l=ptr_symbol_entry->label_name_lenght+i;
				ptr_symbol_entry->symbol_status=eSYMBOLSTATUS_UNKNOWN;
			}
		} 
		
		*x=n;
	}
	return er;
}

int l_such(char *s, int *l, int *x, int *v, int *afl)
{
	int		n,er,b;
	SymbolEntry	*ptr_symbol_entry;
	
	*afl=0;
	
	er=LabelTableLookUp(s,&n);
	if (er==E_OK)
	{
		ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+n;
		*l=ptr_symbol_entry->label_name_lenght;
		if (ptr_symbol_entry->symbol_status==eSYMBOLSTATUS_VALID)
		{
			l_get(n,v,afl);
			*x=n;
		} 
		else
		{
			er=ERR_UNDEFINED_LABEL;
			gError_LabelNamePointer=ptr_symbol_entry->ptr_label_name;
			*x=n;
		}
	}
	else
	{
		b_get(&b);
		er=ll_def(s,x,b); /* ll_def(...,*v); */
		
		ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+(*x);
		
		*l=ptr_symbol_entry->label_name_lenght;
		
		if (!er) 
		{
			er=ERR_UNDEFINED_LABEL;
			gError_LabelNamePointer=ptr_symbol_entry->ptr_label_name;   
		}
	}
	return er;
}

int LabelGetInformations(int index,int *ptr_value, char **ptr_label_name)
{
	SymbolEntry	*ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+index;
	(*ptr_value)=ptr_symbol_entry->value;
	*ptr_label_name=ptr_symbol_entry->ptr_label_name;
	return 0;
}

int l_get(int n, int *v, int *afl)
{
	SymbolEntry	*ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+n;
	(*v)=ptr_symbol_entry->value;
	gError_LabelNamePointer=ptr_symbol_entry->ptr_label_name;
	*afl = ptr_symbol_entry->program_section;
	return ( (ptr_symbol_entry->symbol_status==eSYMBOLSTATUS_VALID) ? E_OK : ERR_UNDEFINED_LABEL);
}

void l_set(int n,int v,SEGMENT_e afl)
{
	SymbolEntry	*ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+n;
	ptr_symbol_entry->value = v;
	ptr_symbol_entry->symbol_status		=eSYMBOLSTATUS_VALID;
	ptr_symbol_entry->program_section	=afl;
}

static void ll_exblk(SEGMENT_e a,SEGMENT_e b)
{
	int	label_index;
	for (label_index=0;label_index<afile->m_cSymbolData.nb_labels;label_index++)
	{
		SymbolEntry	*ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+label_index;
		if ((!ptr_symbol_entry->symbol_status) && (ptr_symbol_entry->blk==a))
		{
			ptr_symbol_entry->blk=b;
		}
	}
}


// definiert naechstes Label  nr->n
static int ll_def(char *s, int *n, int b)          
{
	int		j=0,er=E_OUT_OF_MEMORY,hash;
	char	*s2;
	SymbolEntry	*ptr_symbol_entry;
		
	// Check if the label table has been created
	if (!afile->m_cSymbolData.ptr_table_entries) 
	{
		// Not yet created, then create a new one
		afile->m_cSymbolData.nb_labels = 0;
		afile->m_cSymbolData.max_labels = 1000;
		afile->m_cSymbolData.ptr_table_entries = (SymbolEntry*)malloc(afile->m_cSymbolData.max_labels * sizeof(SymbolEntry));
	} 

	// Check if the label table has enough room for a new label
	if (afile->m_cSymbolData.nb_labels>=afile->m_cSymbolData.max_labels) 
	{
		// Not enough memory, let reallocate the data
		afile->m_cSymbolData.max_labels = (int)(afile->m_cSymbolData.max_labels*1.5);
		afile->m_cSymbolData.ptr_table_entries = (SymbolEntry*)realloc(afile->m_cSymbolData.ptr_table_entries, afile->m_cSymbolData.max_labels * sizeof(SymbolEntry));
	}

	// Eventually abort the program if we ran out of memory
	if (!afile->m_cSymbolData.ptr_table_entries) 
	{
		fprintf(stderr, "Oops: no memory!\n");
		exit(1);
	}

	// We now allocate room for a new symbol entry
	ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+afile->m_cSymbolData.nb_labels;
	while ((s[j]!=0) && (isalnum(s[j]) || (s[j]=='_'))) j++;
	s2 = (char*)malloc(j+1);
	if (!s2) 
	{
		fprintf(stderr,"Oops: no memory!\n");
		exit(1);
	}
	strncpy(s2,s,j);
	s2[j]=0;
	er=E_OK;
	ptr_symbol_entry->label_name_lenght=j;
	ptr_symbol_entry->ptr_label_name = s2;
	ptr_symbol_entry->blk=b;
	ptr_symbol_entry->symbol_status		=eSYMBOLSTATUS_UNKNOWN;
	ptr_symbol_entry->program_section	=eSEGMENT_ABS;
	hash=hashcode(s,j); 
	ptr_symbol_entry->nextindex=afile->m_cSymbolData.hashindex[hash];
	afile->m_cSymbolData.hashindex[hash]=afile->m_cSymbolData.nb_labels;
	*n=afile->m_cSymbolData.nb_labels;
	afile->m_cSymbolData.nb_labels++;
	return er;
}


// such Label in Tabelle ,nr->n 
int LabelTableLookUp(char *s,int *n)          
{
	SymbolEntry	*ptr_symbol_entry;
	int i,j=0,k,er=ERR_UNDEFINED_LABEL,hash;
	
	while (s[j] && (isalnum(s[j])||(s[j]=='_')))  j++;
	
	hash=hashcode(s,j);
	i=afile->m_cSymbolData.hashindex[hash];
	
	if (i>=afile->m_cSymbolData.max_labels) 
	{
		return ERR_UNDEFINED_LABEL;
	}
	
	do
	{
		ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+i;
		
		if (j==ptr_symbol_entry->label_name_lenght)
		{
			for (k=0;(k<j)&&(ptr_symbol_entry->ptr_label_name[k]==s[k]);k++);
			
			if ((j==k)&&(!b_test(ptr_symbol_entry->blk)))
			{
				er=E_OK;
				break;
			}
		}
		
		if (!i)
		{
			break;
		}		
		i=ptr_symbol_entry->nextindex;		
	}
	while (1);
	
	*n=i;
	return er;
}

int ll_pdef(char *t)
{
	SymbolEntry	*ptr_symbol_entry;
	int n;
	
	if (LabelTableLookUp(t,&n)==E_OK)
	{
		ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+n;
		if (ptr_symbol_entry->symbol_status)
		{
			return E_OK;
		}
	}
	return ERR_UNDEFINED_LABEL;
}

int l_write(FILE *fp)
{
	SymbolEntry	*ptr_symbol_entry;
	int		i, afl, n=0;
	
	if (noglob) 
	{
		fputc(0, fp);
		fputc(0, fp);
		return 0;
	}
	for (i=0;i<afile->m_cSymbolData.nb_labels;i++) 
	{
		ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+i;
		if ((!ptr_symbol_entry->blk) && ptr_symbol_entry->symbol_status) 
		{
			n++;
		}
	}
	fputc(n&255, fp);
	fputc((n>>8)&255, fp);
	for (i=0;i<afile->m_cSymbolData.nb_labels;i++)
	{
		ptr_symbol_entry=afile->m_cSymbolData.ptr_table_entries+i;
		if ((!ptr_symbol_entry->blk) && (ptr_symbol_entry->symbol_status==eSYMBOLSTATUS_VALID)) 
		{
			fprintf(fp, "%s",ptr_symbol_entry->ptr_label_name);
			fputc(0,fp);
			afl = ptr_symbol_entry->program_section;
			if ( (afl & (A_FMASK>>8)) < eSEGMENT_TEXT) 
			{
				afl^=1;
			}
			fputc(afl,fp);
			fputc(ptr_symbol_entry->value&255, fp);
			fputc((ptr_symbol_entry->value>>8)&255, fp);
		}
	}
	return 0;
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

int b_close(void)
{
	
	if (bi)
	{
		ll_exblk(bt[bi],bt[bi-1]);
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

static int b_test(int n)
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

