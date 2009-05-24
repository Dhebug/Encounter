

#include <stdio.h>
#include <stdlib.h>

#include "xah.h"
#include "xar.h"
#include "xa.h"
#include "xal.h"
#include "xao.h"
#include "xau.h"

int rmode = RMODE_RELOC;

int r_set(int pc,int afl,int l) 
{
	// printf("set relocation @$%04x, l=%d, afl=%04x, segment=%d\n",pc, l, afl,segment);
	if (segment==eSEGMENT_TEXT) return rt_set(pc,afl,l,0);
	if (segment==eSEGMENT_DATA) return rd_set(pc,afl,l,0);
	return 0;
}

int u_set(int pc, int afl, int label, int l) 
{
	// printf("set relocation @$%04x, l=%d, afl=%04x, segment=%d, label=%d\n",pc, l, afl,segment, label);
	if((afl & A_FMASK) == (eSEGMENT_UNDEF<<8)) 
	{
		label = u_label(label);		// set label as undefined 
	}

	if (segment==eSEGMENT_TEXT) return rt_set(pc,afl,l,label);
	if (segment==eSEGMENT_DATA) return rd_set(pc,afl,l,label);
	return 0;
}

void r_mode(int m) 
{
	static SEGMENT_e old_segment = eSEGMENT_TEXT;
	// printf("setting mode to %s\n",(m==RMODE_RELOC)?"reloc":"abs");
	if (rmode!=m) 
	{
	  if (m==RMODE_RELOC) 
	  {
	    segment = old_segment;
	  } 
	  else 
	  {	
		// absolute mode
	    old_segment = segment;
	    segment = eSEGMENT_ABS;
	  }
	}
	rmode = m;
}

int rt_set(int pc, int afl, int l, int lab) 
{
	int p,pp;
	
	if(!rmode) return 0;

	/*printf("set relocation @$%04x, l=%d, afl=%04x\n",pc, l, afl);*/

	if(l==2 && ((afl & A_MASK)==A_LOW) && ((afl & A_MASK)==A_HIGH)) 
	{
	  errout(W_BYTRELOC);
	  /*printf("Warning: byte relocation in word value at PC=$%04x!\n",pc);*/
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
	
	if(afile->rt.nlist>=afile->rt.mlist) 
	{
	  afile->rt.mlist+=500;
	  afile->rt.rlist=(relocateInfo*)realloc(afile->rt.rlist, afile->rt.mlist*sizeof(relocateInfo));
	}
	if(!afile->rt.rlist) 
	{
	  fprintf(stderr, "Oops: no memory for relocation table!\n");
	  exit(1);
	}

	afile->rt.rlist[afile->rt.nlist].adr = pc;
	afile->rt.rlist[afile->rt.nlist].afl = afl;
	afile->rt.rlist[afile->rt.nlist].lab = lab;
	afile->rt.rlist[afile->rt.nlist].next= -1;

	/* sorting this into the list is not optimized, to be honest... */
	if(afile->rt.first<0) 
	{
	  afile->rt.first = afile->rt.nlist;
	} 
	else 
	{
	  p=afile->rt.first; pp=-1;
	  while(afile->rt.rlist[p].adr<pc && afile->rt.rlist[p].next>=0) 
	  { 
	    pp=p; 
	    p=afile->rt.rlist[p].next; 
	  }
/*
printf("endloop: p=%d(%04x), pp=%d(%04x), nlist=%d(%04x)\n",
		p,p<0?0:afile->rt.rlist[p].adr,pp,pp<0?0:afile->rt.rlist[pp].adr,afile->rt.nlist,afile->rt.nlist<0?0:afile->rt.rlist[afile->rt.nlist].adr);
*/
	  if(afile->rt.rlist[p].next<0 && afile->rt.rlist[p].adr<pc) 
	  {
	    afile->rt.rlist[p].next=afile->rt.nlist;
	  } 
	  else 
	  if(pp==-1) 
	  {
	    afile->rt.rlist[afile->rt.nlist].next = afile->rt.first;
	    afile->rt.first = afile->rt.nlist;
	  } 
	  else 
	  {
	    afile->rt.rlist[afile->rt.nlist].next = p;
	    afile->rt.rlist[pp].next = afile->rt.nlist;
	  }
	}
	afile->rt.nlist++;

	return 0;
}

int rt_write(FILE *fp, int pc) 
{
	int p=afile->rt.first;
	int pc2, afl;

	while(p>=0) 
	{
	  pc2=afile->rt.rlist[p].adr;
	  afl=afile->rt.rlist[p].afl;
	  /* hack to switch undef and abs flag from internal to file format */
	  if( ((afl & A_FMASK)>>8) < eSEGMENT_TEXT) afl^=0x100;
/*printf("rt_write: pc=%04x, pc2=%04x, afl=%x\n",pc,pc2,afl);*/
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
	    if((afile->rt.rlist[p].afl&A_FMASK)==(eSEGMENT_UNDEF<<8)) 
		{
		fputc(afile->rt.rlist[p].lab & 255, fp);
		fputc((afile->rt.rlist[p].lab>>8) & 255, fp);
	    }
	    if((afl&A_MASK)==A_HIGH) fputc(afl&255,fp);
	  }
	  p=afile->rt.rlist[p].next;
	}
	fputc(0, fp);

	free(afile->rt.rlist);
	afile->rt.rlist = NULL;
	afile->rt.mlist = afile->rt.nlist = 0;
	afile->rt.first = -1;

	return 0;
}


void seg_start(int fmode,int t_base,int d_base,int b_base,int z_base,int slen,int relmode) 
{
	afile->fmode = fmode;
	afile->slen = slen;
	afile->relmode = relmode;

	TablePcSegment[eSEGMENT_TEXT] = afile->base[eSEGMENT_TEXT] = t_base;
	TablePcSegment[eSEGMENT_DATA] = afile->base[eSEGMENT_DATA] = d_base;
	TablePcSegment[eSEGMENT_BSS]  = afile->base[eSEGMENT_BSS]  = b_base;
	TablePcSegment[eSEGMENT_ZERO] = afile->base[eSEGMENT_ZERO] = z_base;

	afile->old_abspc = TablePcSegment[eSEGMENT_ABS];
	TablePcSegment[eSEGMENT_ABS]  = TablePcSegment[eSEGMENT_TEXT];
}




void seg_pass2(void) 
{

	TablePcSegment[eSEGMENT_TEXT] = afile->base[eSEGMENT_TEXT];
	TablePcSegment[eSEGMENT_DATA] = afile->base[eSEGMENT_DATA];
	TablePcSegment[eSEGMENT_BSS]  = afile->base[eSEGMENT_BSS];
	TablePcSegment[eSEGMENT_ZERO] = afile->base[eSEGMENT_ZERO];

	afile->old_abspc = TablePcSegment[eSEGMENT_ABS];
	TablePcSegment[eSEGMENT_ABS]  = TablePcSegment[eSEGMENT_TEXT];
}

void seg_end(FILE *fpout) 
{
	/* TODO: file length to embed */
/*	pc[eSEGMENT_ABS] = afile->old_abspc + seg_flen();*/

/*printf("seg_end: len[text]=%d, len[data]=%d, len[bss]=%d, len[zero]=%d\n",
		afile->len[eSEGMENT_TEXT], afile->len[eSEGMENT_DATA], afile->len[eSEGMENT_BSS], afile->len[eSEGMENT_ZERO]);*/
	segment = eSEGMENT_ABS;

	u_write(fpout);
    rt_write(fpout, afile->base[eSEGMENT_TEXT]-1);
    rd_write(fpout, afile->base[eSEGMENT_DATA]-1);
    l_write(fpout);
}

#define fputw(a,fp)     fputc((a)&255,fp);fputc((a>>8)&255,fp)


// Write header for relocatable output format
int h_write(FILE *fp,int mode,int tlen,int dlen,int blen,int zlen,int stack) 
{
	afile->len[eSEGMENT_TEXT] = tlen;
	afile->len[eSEGMENT_DATA] = dlen;
	afile->len[eSEGMENT_BSS ] = blen;
	afile->len[eSEGMENT_ZERO] = zlen;

    fputc(1, fp);							// version byte 
    fputc(0, fp);							// hi address 0 -> no C64 
    fputc('o', fp);
    fputc('6', fp);
    fputc('5', fp);
    fputc(0, fp);							// format version 
    fputw(mode, fp);						// file mode 
    fputw(afile->base[eSEGMENT_TEXT],fp);   // text base 
    fputw(tlen,fp);							// text length 
    fputw(afile->base[eSEGMENT_DATA],fp);   // data base 
    fputw(dlen,fp);							// data length 
    fputw(afile->base[eSEGMENT_BSS],fp);    // bss base 
    fputw(blen,fp);							// bss length 
    fputw(afile->base[eSEGMENT_ZERO],fp);   // zerop base 
    fputw(zlen,fp);							// zerop length 
    fputw(stack,fp);						// needed stack size 

    o_write(fp);

    return 0;
}





// -----------------------------------------------------------------------------
//
//								FileData_c
//
// -----------------------------------------------------------------------------

FileData_c::FileData_c()
{
	ud.ulist = NULL;
	ud.un = ud.um = 0;

	rt.rlist = NULL; 
	rt.first = -1;
	rt.mlist = rt.nlist = 0;

	rd.rlist = NULL; 
	rd.first = -1;
	rd.mlist = rd.nlist = 0;

	fo.olist = NULL;
	fo.mlist = fo.nlist = 0;
		
	len[eSEGMENT_TEXT] = 0;
	len[eSEGMENT_DATA] = 0; 
	len[eSEGMENT_BSS]  = 0; 
	len[eSEGMENT_ZERO] = 0;
}

FileData_c::~FileData_c()
{
}

/*
static char *tmp;
static unsigned long tmpz;
static unsigned long tmpe;
*/

long FileData_c::ga_p1()
{
	return m_cMnData.tmpz;
}
		   
long FileData_c::gm_p1()
{
	return TMPMEM;
}



int FileData_c::Label_GetUsedCount()
{
	return m_cSymbolData.nb_labels;
}

void FileData_c::Label_PrintList(FILE *fp)
{
	for (int label_index=0;label_index<m_cSymbolData.nb_labels;label_index++)
	{
		SymbolEntry	*ptr_symbol_entry=m_cSymbolData.ptr_table_entries+label_index;
		//fprintf(fp,"%s, 0x%04x, %d, 0x%04x\n",ptr_symbol_entry->name,ptr_symbol_entry->value,ptr_symbol_entry->blk,ptr_symbol_entry->afl);
		fprintf(fp,"%04x %s\n",ptr_symbol_entry->value,ptr_symbol_entry->ptr_label_name);
	}
}


int FileData_c::MnDataPushCharacter(int c)
{
	int er=E_OUT_OF_MEMORY;
	if (m_cMnData.tmpz<TMPMEM)
	{
		m_cMnData.m_ptr_tmp[m_cMnData.tmpz++]=c;
		er=E_OK;
	}
	return er;
}

int FileData_c::MnDataPushString(signed char *s, int l)
{
	int i=0,er=E_OUT_OF_MEMORY;
	
	if (m_cMnData.tmpz+l<TMPMEM)
	{
		while (i<l)
		{
			m_cMnData.m_ptr_tmp[m_cMnData.tmpz++]=s[i++];
		}		
		er=E_OK;
	}
	return er;
}

// -----------------------------------------------------------------------------
//
//								MnData_c
//
// -----------------------------------------------------------------------------

MnData_c::MnData_c()
{
	m_ptr_tmp = (signed char*)malloc(TMPMEM);
	if (!m_ptr_tmp) 
	{
		fprintf(stderr,"Oops: not enough memory!\n");
		exit(1);
	}
	tmpz = 0;
	tmpe = 0;
}

int MnData_c::ReadByte(bool bMoveReadPosition)
{
	int nValue=m_ptr_tmp[tmpe];
	if (bMoveReadPosition)
	{
		tmpe++;
	}
	return nValue;
}

int MnData_c::ReadShort(bool bMoveReadPosition)
{
	int nValueLow =m_ptr_tmp[tmpe];
	int nValueHigh=m_ptr_tmp[tmpe+1];
	if (bMoveReadPosition)
	{
		tmpe+=2;
	}
	return nValueLow|(nValueHigh<<8);
}


std::string MnData_c::ReadString(bool bMoveReadPosition)
{
	std::string cString;
	unsigned long offset=tmpe;

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
		tmpe=offset;
	}

	return cString;
}



// -----------------------------------------------------------------------------
//
//								SymbolData_c
//
// -----------------------------------------------------------------------------

SymbolData_c::SymbolData_c()
{
	for (int i=0;i<256;i++) 
	{
		hashindex[i]=0;
	}
	ptr_table_entries	= NULL;
	nb_labels			= 0;
	max_labels			= 0;
}

SymbolData_c::~SymbolData_c()
{
}

