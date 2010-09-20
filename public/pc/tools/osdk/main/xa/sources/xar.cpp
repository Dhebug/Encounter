

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include "xah.h"
#include "xar.h"
#include "xa.h"
#include "xal.h"
#include "xao.h"
#include "xau.h"




int rmode = RMODE_RELOC;



void r_mode(int m) 
{
	static SEGMENT_e old_segment = eSEGMENT_TEXT;
	// printf("setting mode to %s\n",(m==RMODE_RELOC)?"reloc":"abs");
	if (rmode!=m) 
	{
	  if (m==RMODE_RELOC) 
	  {
	    gCurrentSegment = old_segment;
	  } 
	  else 
	  {	
		// absolute mode
	    old_segment = gCurrentSegment;
	    gCurrentSegment = eSEGMENT_ABS;
	  }
	}
	rmode = m;
}



// -----------------------------------------------------------------------------
//
//									Relocation
//
// -----------------------------------------------------------------------------

Relocation::Relocation(bool is_text) :
	m_is_text(is_text),
	rlist(NULL),
	first(-1),
	mlist(0),
	nlist(0)
{
}

Relocation::~Relocation()
{

}


int Relocation::Set(int pc, int afl, int l, int lab) 
{
	int p,pp;
	
	if(!rmode) return 0;

	/*printf("set relocation @$%04x, l=%d, afl=%04x\n",pc, l, afl);*/

	if (m_is_text && (l==2) && ((afl & A_MASK)==A_LOW) && ((afl & A_MASK)==A_HIGH)) 
	{
	  errout(W_BYTRELOC);	//printf("Warning: byte relocation in word value at PC=$%04x!\n",pc);
	}
	if ( (!m_is_text) && (l==2 && ((afl & A_MASK)!=A_ADR)) )
	{
		errout(W_BYTRELOC);	//printf("Warning: byte relocation in word value at PC=$%04x!\n",pc);
	}


	if(l==1 && ((afl&A_MASK)==A_ADR)) 
	{
	  if((afl & A_FMASK) != (eSEGMENT_ZERO<<8)) 
	  {
/*printf("afl=%04x\n",afl);*/
	    errout(W_ADRRELOC);
	  }
	  /*printf("Warning: cutting address relocation in byte value at PC=$%04x!\n",pc);*/
	  afl = (afl & (~A_MASK)) | A_LOW;
	}
	
	if(nlist>=mlist) 
	{
	  mlist+=500;
	  rlist=(relocateInfo*)realloc(rlist, mlist*sizeof(relocateInfo));
	}
	if(!rlist) 
	{
	  fprintf(stderr, "Oops: no memory for relocation table!\n");
	  exit(1);
	}

	rlist[nlist].adr = pc;
	rlist[nlist].afl = afl;
	rlist[nlist].lab = lab;
	rlist[nlist].next= -1;

	/* sorting this into the list is not optimized, to be honest... */
	if(first<0) 
	{
	  first = nlist;
	} 
	else 
	{
	  p=first; pp=-1;
	  while(rlist[p].adr<pc && rlist[p].next>=0) 
	  { 
	    pp=p; 
	    p=rlist[p].next; 
	  }
/*
printf("endloop: p=%d(%04x), pp=%d(%04x), nlist=%d(%04x)\n",
		p,p<0?0:rlist[p].adr,pp,pp<0?0:rlist[pp].adr,nlist,nlist<0?0:rlist[nlist].adr);
*/
	  if(rlist[p].next<0 && rlist[p].adr<pc) 
	  {
	    rlist[p].next=nlist;
	  } 
	  else 
	  if(pp==-1) 
	  {
	    rlist[nlist].next = first;
	    first = nlist;
	  } 
	  else 
	  {
	    rlist[nlist].next = p;
	    rlist[pp].next = nlist;
	  }
	}
	nlist++;

	return 0;
}

int Relocation::Write(FILE *fp, int pc) 
{
	int p=first;
	int pc2, afl;

	while(p>=0) 
	{
	  pc2=rlist[p].adr;
	  afl=rlist[p].afl;
	  // hack to switch undef and abs flag from internal to file format
	  if( ((afl & A_FMASK)>>8) < eSEGMENT_TEXT) afl^=0x100;
	  // printf("rt_write: pc=%04x, pc2=%04x, afl=%x\n",pc,pc2,afl);
	  if((pc2-pc) < 0) 
	  { 
	    fprintf(stderr, "Oops, negative offset!\n"); 
	  } 
	  else 
	  {
	    while((pc2-pc)>254) 
		{ 
	      fputc(255,fp);
	      pc+=254;
	    }
	    fputc(pc2-pc, fp);
	    pc=pc2;
	    fputc((afl>>8)&255, fp);
	    if((rlist[p].afl&A_FMASK)==(eSEGMENT_UNDEF<<8)) 
		{
		fputc(rlist[p].lab & 255, fp);
		fputc((rlist[p].lab>>8) & 255, fp);
	    }
	    if((afl&A_MASK)==A_HIGH) fputc(afl&255,fp);
	  }
	  p=rlist[p].next;
	}
	fputc(0, fp);

	free(rlist);
	rlist = NULL;
	mlist = nlist = 0;
	first = -1;

	return 0;
}





#define fputw(a,fp)     fputc((a)&255,fp);fputc((a>>8)&255,fp)




// -----------------------------------------------------------------------------
//
//								FileData
//
// -----------------------------------------------------------------------------

FileData::FileData() :
	m_relocation_text(true),
	m_relocation_data(false)
{
	m_len[eSEGMENT_TEXT] = 0;
	m_len[eSEGMENT_DATA] = 0; 
	m_len[eSEGMENT_BSS]  = 0; 
	m_len[eSEGMENT_ZERO] = 0;
}

FileData::~FileData()
{
}

/*
static char *tmp;
static unsigned long tmpz;
static unsigned long tmpe;
*/

long FileData::ga_p1()
{
	return m_cMnData.GetWritePos();
}
		   
long FileData::gm_p1()
{
	return TMPMEM;
}

ErrorCode FileData::WriteByte(int c)
{
	return m_cMnData.WriteByte(c);
}

ErrorCode FileData::WriteShort(int c)
{
	return m_cMnData.WriteShort(c);
}

ErrorCode FileData::WriteUShort(unsigned int c)
{
	return m_cMnData.WriteUShort(c);
}

ErrorCode FileData::WriteSequence(signed char *s, int l)
{
	return m_cMnData.WriteString(s,l);
}


void FileData::StartSegment(int fmode,int t_base,int d_base,int b_base,int z_base,int slen,int relmode) 
{
	m_fmode   = fmode;
	m_slen    = slen;
	m_relmode = relmode;

	TablePcSegment[eSEGMENT_TEXT] = m_base[eSEGMENT_TEXT] = t_base;
	TablePcSegment[eSEGMENT_DATA] = m_base[eSEGMENT_DATA] = d_base;
	TablePcSegment[eSEGMENT_BSS]  = m_base[eSEGMENT_BSS]  = b_base;
	TablePcSegment[eSEGMENT_ZERO] = m_base[eSEGMENT_ZERO] = z_base;

	m_old_abspc = TablePcSegment[eSEGMENT_ABS];
	TablePcSegment[eSEGMENT_ABS]  = TablePcSegment[eSEGMENT_TEXT];
}

void FileData::SegmentPass2() 
{
	TablePcSegment[eSEGMENT_TEXT] = m_base[eSEGMENT_TEXT];
	TablePcSegment[eSEGMENT_DATA] = m_base[eSEGMENT_DATA];
	TablePcSegment[eSEGMENT_BSS]  = m_base[eSEGMENT_BSS];
	TablePcSegment[eSEGMENT_ZERO] = m_base[eSEGMENT_ZERO];

	m_old_abspc = TablePcSegment[eSEGMENT_ABS];
	TablePcSegment[eSEGMENT_ABS]  = TablePcSegment[eSEGMENT_TEXT];
}

void FileData::SegmentEnd(FILE *fpout) 
{
	/* TODO: file length to embed */
	/*	pc[eSEGMENT_ABS] = afile->old_abspc + seg_flen();*/

	/*printf("seg_end: len[text]=%d, len[data]=%d, len[bss]=%d, len[zero]=%d\n",
	afile->len[eSEGMENT_TEXT], afile->len[eSEGMENT_DATA], afile->len[eSEGMENT_BSS], afile->len[eSEGMENT_ZERO]);*/
	gCurrentSegment = eSEGMENT_ABS;

	m_undefined_labels.u_write(fpout);
	afile->m_relocation_text.Write(fpout,m_base[eSEGMENT_TEXT]-1);
	afile->m_relocation_data.Write(fpout,m_base[eSEGMENT_DATA]-1);
	m_cSymbolData.SaveSymbols(fpout);
}

// Write header for relocatable output format
int FileData::WriteRelocatableHeader(FILE *fp,int mode,int tlen,int dlen,int blen,int zlen,int stack) 
{
	m_len[eSEGMENT_TEXT] = tlen;
	m_len[eSEGMENT_DATA] = dlen;
	m_len[eSEGMENT_BSS ] = blen;
	m_len[eSEGMENT_ZERO] = zlen;

	fputc(1, fp);							// version byte 
	fputc(0, fp);							// hi address 0 -> no C64 
	fputc('o', fp);
	fputc('6', fp);
	fputc('5', fp);
	fputc(0, fp);							// format version 
	fputw(mode, fp);						// file mode 
	fputw(m_base[eSEGMENT_TEXT],fp);		// text base 
	fputw(tlen,fp);							// text length 
	fputw(m_base[eSEGMENT_DATA],fp);		// data base 
	fputw(dlen,fp);							// data length 
	fputw(m_base[eSEGMENT_BSS],fp);			// bss base 
	fputw(blen,fp);							// bss length 
	fputw(m_base[eSEGMENT_ZERO],fp);		// zerop base 
	fputw(zlen,fp);							// zerop length 
	fputw(stack,fp);						// needed stack size 

	m_options.o_write(fp);

	return 0;
}

void FileData::SetSegmentBase(SEGMENT_e segment,int base)
{
	m_base[segment] = TablePcSegment[segment] = base;
}


int FileData::r_set(int pc,int afl,int l) 
{
	// printf("set relocation @$%04x, l=%d, afl=%04x, segment=%d\n",pc, l, afl,segment);
	if (gCurrentSegment==eSEGMENT_TEXT) return m_relocation_text.Set(pc,afl,l,0);
	if (gCurrentSegment==eSEGMENT_DATA) return m_relocation_data.Set(pc,afl,l,0);
	return 0;
}


int FileData::u_set(int pc, int afl, int label, int l) 
{
	// printf("set relocation @$%04x, l=%d, afl=%04x, segment=%d, label=%d\n",pc, l, afl,segment, label);
	if((afl & A_FMASK) == (eSEGMENT_UNDEF<<8)) 
	{
		label = m_undefined_labels.u_label(label);		// set label as undefined 
	}

	if (gCurrentSegment==eSEGMENT_TEXT) return m_relocation_text.Set(pc,afl,l,label);
	if (gCurrentSegment==eSEGMENT_DATA) return m_relocation_data.Set(pc,afl,l,label);
	return 0;
}

void FileData::set_fopt(int l, signed char *buf, int reallen)
{
	m_options.set_fopt(l,buf,reallen);
}

int FileData::h_length()
{
	return 26+m_options.o_length();
}






// -----------------------------------------------------------------------------
//
//								MnData
//
// -----------------------------------------------------------------------------

MnData::MnData()
{
	m_ptr_tmp = (signed char*)malloc(TMPMEM);
	if (!m_ptr_tmp) 
	{
		fprintf(stderr,"Oops: not enough memory!\n");
		exit(1);
	}
	m_write_pos = 0;
	m_read_pos = 0;
}

int MnData::ReadByte(bool bMoveReadPosition)
{
	int nValue=m_ptr_tmp[m_read_pos];
	if (bMoveReadPosition)
	{
		m_read_pos++;
	}
	return nValue;
}

int MnData::ReadUByte(bool bMoveReadPosition)
{
	unsigned int nValue=(unsigned char)m_ptr_tmp[m_read_pos];
	if (bMoveReadPosition)
	{
		m_read_pos++;
	}
	return nValue;
}

int MnData::ReadShort(bool bMoveReadPosition)
{
	int nValueLow =(unsigned char)m_ptr_tmp[m_read_pos]&255;
	int nValueHigh=m_ptr_tmp[m_read_pos+1];
	if (bMoveReadPosition)
	{
		m_read_pos+=2;
	}
	return nValueLow|(nValueHigh<<8);
}

unsigned int MnData::ReadUShort(bool bMoveReadPosition)
{
	unsigned int nValueLow =(unsigned char)m_ptr_tmp[m_read_pos];
	unsigned int nValueHigh=(unsigned char)m_ptr_tmp[m_read_pos+1];
	if (bMoveReadPosition)
	{
		m_read_pos+=2;
	}
	return nValueLow|(nValueHigh<<8);
}

std::string MnData::ReadString(bool bMoveReadPosition)
{
	std::string cString;
	unsigned long offset=m_read_pos;

	while (true)
	{
		signed char car=m_ptr_tmp[offset++];
		if (!car)
		{
			// Null terminator
			break;
		}
		cString+=car;
	}

	if (bMoveReadPosition)
	{
		m_read_pos=offset;
	}

	return cString;
}


ErrorCode MnData::WriteByte(int c)
{
	ErrorCode er=E_OUT_OF_MEMORY;
	if (m_write_pos<TMPMEM)
	{
		m_ptr_tmp[m_write_pos++]=c;
		er=E_OK;
	}
	return er;
}
			   

ErrorCode MnData::WriteShort(int c)
{
	ErrorCode er=E_OUT_OF_MEMORY;
	if ((m_write_pos+1)<TMPMEM)
	{
		m_ptr_tmp[m_write_pos++]=c&255;
		c>>=8;
		m_ptr_tmp[m_write_pos++]=c&255;
		er=E_OK;
	}
	return er;
}

ErrorCode MnData::WriteUShort(unsigned int c)
{
	ErrorCode er=E_OUT_OF_MEMORY;
	if ((m_write_pos+1)<TMPMEM)
	{
		m_ptr_tmp[m_write_pos++]=c&255;
		c>>=8;
		m_ptr_tmp[m_write_pos++]=c&255;
		er=E_OK;
	}
	return er;
}

ErrorCode MnData::WriteString(signed char *s, int l)
{
	int i=0;
	ErrorCode er=E_OUT_OF_MEMORY;

	if (m_write_pos+l<TMPMEM)
	{
		while (i<l)
		{
			m_ptr_tmp[m_write_pos++]=s[i++];
		}		
		er=E_OK;
	}
	return er;
}




// -----------------------------------------------------------------------------
//
//								SymbolData
//
// -----------------------------------------------------------------------------

SymbolData::SymbolData()
{
	for (int i=0;i<256;i++) 
	{
		m_hashindex[i]=0;
	}
	m_ptr_table_entries	= NULL;
	m_nb_labels			= 0;
	m_max_labels		= 0;
}

SymbolData::~SymbolData()
{
}

ErrorCode SymbolData::DefineGlobalLabel(char *s ) 
{
	int n;
	ErrorCode er=SearchSymbol(s,&n);
	if (er==E_OK) 
	{
		fprintf(stderr,"Warning: global label doubly defined!\n");
	}
	else 
	{
		if (!(er=DefineSymbol(s,&n,0))) 
		{
			SymbolEntry& symbol_entry=GetSymbolEntry(n);
			symbol_entry.symbol_status		=eSYMBOLSTATUS_GLOBAL;
			symbol_entry.program_section	=eSEGMENT_UNDEF;
		}
	}
	return er;
}



void SymbolData::PrintSymbols(FILE *fp)
{
	for (int label_index=0;label_index<m_nb_labels;label_index++)
	{
		SymbolEntry& symbol_entry=GetSymbolEntry(label_index);
		//fprintf(fp,"%s, 0x%04x, %d, 0x%04x\n",symbol_entry.name,symbol_entry.value,symbol_entry.blk,symbol_entry.afl);
		fprintf(fp,"%04x %s\n",symbol_entry.value,symbol_entry.ptr_label_name);
	}
}


// definiert naechstes Label  nr->n
ErrorCode SymbolData::DefineSymbol(char *ptr_src,int *label_index,int block_level)
{
	// Check if the label table has been created
	if (!m_ptr_table_entries) 
	{
		// Not yet created, then create a new one
		m_nb_labels = 0;
		m_max_labels = 1000;
		m_ptr_table_entries = (SymbolEntry*)malloc(m_max_labels * sizeof(SymbolEntry));
	} 

	// Check if the label table has enough room for a new label
	if (m_nb_labels>=m_max_labels) 
	{
		// Not enough memory, let reallocate the data
		m_max_labels = (int)(m_max_labels*1.5);
		m_ptr_table_entries = (SymbolEntry*)realloc(m_ptr_table_entries, m_max_labels * sizeof(SymbolEntry));
	}

	// Eventually abort the program if we ran out of memory
	if (!m_ptr_table_entries) 
	{
		fprintf(stderr, "Oops: no memory!\nlabel_index");
		exit(1);
	}

	// We now allocate room for a new symbol entry
	SymbolEntry	*ptr_symbol_entry=m_ptr_table_entries+m_nb_labels;
	int hash=ptr_symbol_entry->DefineSymbol(ptr_src,block_level);
	ptr_symbol_entry->nextindex=m_hashindex[hash];
	m_hashindex[hash]=m_nb_labels;
	*label_index=m_nb_labels;
	m_nb_labels++;
	return E_OK;
}


// such Label in Tabelle ,nr->n 
ErrorCode SymbolData::SearchSymbol(char *ptr_src,int *label_index)
{
	int j=0;
	while (ptr_src[j] && (isalnum(ptr_src[j])||(ptr_src[j]=='_')))  j++;

	int hash=hashcode(ptr_src,j);
	int i=m_hashindex[hash];
	if (i>=m_max_labels) 
	{
		return ERR_UNDEFINED_LABEL;
	}

	ErrorCode er=ERR_UNDEFINED_LABEL;
	do
	{
		SymbolEntry	*ptr_symbol_entry=m_ptr_table_entries+i;
		if (j==ptr_symbol_entry->label_name_lenght)
		{
			int k;
			for (k=0;(k<j)&&(ptr_symbol_entry->ptr_label_name[k]==ptr_src[k]);k++);

			if ((j==k)&&(!b_test(ptr_symbol_entry->m_block_level)))
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

	*label_index=i;
	return er;
}


int SymbolData::SaveSymbols(FILE *fp)
{
	int	i, afl, n=0;

	if (noglob) 
	{
		fputc(0, fp);
		fputc(0, fp);
		return 0;
	}

	SymbolEntry	*ptr_symbol_entry;
	for (i=0;i<m_nb_labels;i++) 
	{
		ptr_symbol_entry=m_ptr_table_entries+i;
		if ((!ptr_symbol_entry->m_block_level) && ptr_symbol_entry->symbol_status) 
		{
			n++;
		}
	}
	fputc(n&255, fp);
	fputc((n>>8)&255, fp);
	for (i=0;i<m_nb_labels;i++)
	{
		ptr_symbol_entry=m_ptr_table_entries+i;
		if ((!ptr_symbol_entry->m_block_level) && (ptr_symbol_entry->symbol_status==eSYMBOLSTATUS_VALID)) 
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


void SymbolData::ExitBlock(SEGMENT_e a,SEGMENT_e b)
{
	int	label_index;
	for (label_index=0;label_index<m_nb_labels;label_index++)
	{
		SymbolEntry& symbol_entry=GetSymbolEntry(label_index);
		if ((!symbol_entry.symbol_status) && (symbol_entry.m_block_level==a))
		{
			symbol_entry.m_block_level=b;
		}
	}
}

