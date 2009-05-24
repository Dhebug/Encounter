
#pragma warning( disable : 4786)	// Debug symbols thing

#include <vector>
#include <string>


#include <ctype.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
/* structs and defs */

#include "xah.h"
#include "xah2.h"

/* exported functions are defined here */

#include "xar.h"
#include "xa.h"
#include "xam.h"
#include "xal.h"
#include "xap.h"
#include "xat.h"
#include "xao.h"

/* exported globals */


FileData_c *afile = NULL;

int gFlag_ncmos;
int gFlag_cmosfl;
int gFlag_w65816;
int gFlag_n65816;

int gFlagMasmCompatibilityMode = 0;
int nolink = 0;
int romable = 0;
int romadr = 0;
int noglob = 0;
int gFlag_ShowBlocks = 0;

/* local variables */

static const char *copyright=
{
	"Cross-Assembler 65xx V2.2.0 ("__TIME__" / "__DATE__") \r\n"
	"(c) 1989-98 by A.Fachat\r\n"
	"65816 opcodes and modes coded by Jolse Maginnis\r\n"
	"Oric C adaptation and debugging by Mickael Pointier\r\n"
	"Clean Linux port by Jean-Yves Lamoureux\r\n"
};


static char out[MAXLINE];
static time_t tim1;
static time_t tim2;
static FILE *ptr_output_handle;
static FILE *ptr_error_handle;
static FILE *ptr_symbols_handle;
static int ner = 0;

static int align = 1;

static void printstat(void);
static void usage(void);
static int	setfext(char*,char*);
static int	pass1(void);
static int	pass2(void);
static void chrput(int);
static int	getline(char*);
static void lineout(void);
static long ga_p1(void);
static long gm_p1(void);
int unlink(const char *);
/* text */

int memode;
int xmode;

SEGMENT_e segment;
int SectionTextLenght=0;
int SectionTextBase=0x1000;
int SectionDataLenght=0;
int SectionDataBase=0x0400;
int SectionBssLenght=0;
int SectionBssBase=0x4000;
int SectionZeroLenght=0;
int SectionZeroBase=4;


int fmode=0;
int relmode=0;

int TablePcSegment[_eSEGMENT_MAX_];	/* segments */



static void usage(void)
{
	fprintf(stderr, "%s",copyright);
	fprintf(stderr, "usage : xa { option | sourcefile }\n"
		"options:\n"
		" -v          = verbose output\n"
		" -C          = no CMOS-opcodes\n"
		" -W          = no 65816-opcodes\n"
		" -B          = show lines with block open/close\n"
		" -c          = produce o65 object instead of executable files (i.e. do not link)\n"
		" -o filename = sets output filename, default is 'a.o65'\n"
		"               A filename of '-' sets stdout as output file\n"
		" -e filename = sets errorlog filename, default is none\n"
		" -l filename = sets labellist filename, default is none\n"
		" -M          = allow \":\" to appear in comments, for MASM compatibility\n"
		" -R          = start assembler in relocating mode\n"
		" -Llabel     = defines 'label' as absolute, undefined label even when linking\n"
		" -b? adr     = set segment base address to integer value adr. \n"
		"               '?' stands for t(ext), d(ata), b(ss) and z(ero) segment\n"
		"               (address can be given more than once, latest is taken)\n"
		" -A adr      = make text segment start at an address that when the _file_\n"
		"               starts at adr, relocation is not necessary. Overrides -bt\n"
		"               Other segments have to be take care of with -b?\n"
		" -G          = suppress list of exported globals\n"
		" -DDEF=TEXT  = defines a preprocessor replacement\n"
		" -Idir      = add directory 'dir' to include path (before XAINPUT)\n"
		"Environment:\n"
		" XAINPUT = include file path; components divided by ','\n"
		" XAOUTPUT= output file path\n"
		);
}


void error(const char *message)
{
	if (message)
	{
		printf("XA.EXE: %s\n",message);
	}
	else
	{
		usage();
	}

	exit(1);
}



int ConvertAdress(const char *ptr_value)
{
	int		adress;
	int		base;
	char	car;

	if (ptr_value[0]=='$')
	{
		// Hexadecimal (assembler syntax)
		base=16;
		ptr_value++;
	}
	else
	if ((ptr_value[0]=='0') && (ptr_value[1]=='x'))
	{
		// Hexadecimal (C/C++ syntax)
		base=16;
		ptr_value+=2;
	}
	else
	{
		// Decimal
		base=10;
	}

	adress=0;
	while ((car=(*ptr_value++)))
	{
		if ((car>='0') && (car<='9'))
		{
			adress*=base;
			adress+=car-'0';
		}
		else
		if ((car>='a') && (car<='f'))
		{
			if (base!=16)
			{
				error("Only hexadecimal values prefixed by a '$' or '0x' can contain letters");
			}
			adress*=base;
			adress+=car-'a';
		}
		else
		if ((car>='A') && (car<='F'))
		{
			if (base!=16)
			{
				error("Only hexadecimal values prefixed by a '$' or '0x' can contain letters");
			}
			adress*=base;
			adress+=car-'A';
		}
		else
		{
			error("Unknow character in the adress value");
		}
	}

	if ((adress<0x0000) || (adress>0xFFFF))
	{
		error("authorized adress range is $0000 to $FFFF");
	}

	return adress;
}



int main(int argc,char *argv[])
{
	int er=1,i;
	signed char *s=NULL;

	bool bFlagVerbose = false;

	std::vector<std::string>	cInputFileList;

	tim1=time(NULL);

	gFlag_ncmos=0;
	gFlag_n65816=0;
	gFlag_cmosfl=1;
	gFlag_w65816=1;

	afile = new FileData_c;
	if (!afile)
	{
		return 1;
	}

	if (argc<=1)
	{
		usage();
		return 1;
	}

	char* ptr_output_filename	="a.o65";
	char* ptr_error_filename	=NULL;
	char* ptr_symbols_filename	=NULL;

	if (gPreprocessor.Init())
	{
		logout("fatal: pp: no memory!");
		return 1;
	}
	if (b_init())
	{
		logout("fatal: b: no memory!");
		return 1;
	}


	i=1;
	while (i<argc)
	{
		if (argv[i][0]=='-')
		{
			switch (argv[i][1])
			{
			case 'M':
				// MASM compatibility mode
				gFlagMasmCompatibilityMode = 1;
				break;

			case 'A':
				// make text segment start so that text relocation
				// is not necessary when _file_ starts at adr
				romable = 2;
				if (argv[i][2]==0)
				{
					romadr = ConvertAdress(argv[++i]);
				}
				else
				{
					romadr = ConvertAdress(argv[i]+2);
				}
				break;

			case 'G':
				noglob = 1;
				break;

			case 'L':
				// define global label
				if (argv[i][2])
				{
					DefineGlobalLabel(argv[i]+2);
				}
				break;

			case 'R':
				relmode = 1;
				break;

			case 'D':
				s = (signed char*)strstr(argv[i]+2,"=");
				if (s) *s = ' ';
				gPreprocessor.command_define(argv[i]+2);
				break;

			case 'c':
				fmode |= FM_OBJ;
				break;

			case 'v':
				bFlagVerbose = true;
				break;

			case 'C':
				gFlag_cmosfl = 0;
				break;

			case 'W':
				gFlag_w65816 = 0;
				break;

			case 'B':
				gFlag_ShowBlocks = 1;
				break;

			case 'I':
				if (argv[i][2]==0)
				{
					reg_include(argv[++i]);
				}
				else
				{
					reg_include(argv[i]+2);
				}
				break;

			case 'o':
				if (argv[i][2]==0)
				{
					ptr_output_filename=argv[++i];
				}
				else
				{
					ptr_output_filename=argv[i]+2;
				}
				break;

			case 'l':
				if (argv[i][2]==0)
				{
					ptr_symbols_filename=argv[++i];
				}
				else
				{
					ptr_symbols_filename=argv[i]+2;
				}
				break;

			case 'e':
				if (argv[i][2]==0)
				{
					ptr_error_filename=argv[++i];
				}
				else
				{
					ptr_error_filename=argv[i]+2;
				}
				break;

			case 'b':
				// set segment base addresses
				switch (argv[i][2])
				{
				case 't':
					if (argv[i][3]==0)	SectionTextBase = ConvertAdress(argv[++i]);
					else				SectionTextBase = ConvertAdress(argv[i]+3);
					break;

				case 'd':
					if (argv[i][3]==0)	SectionDataBase = ConvertAdress(argv[++i]);
					else				SectionDataBase = ConvertAdress(argv[i]+3);
					break;

				case 'b':
					if (argv[i][3]==0)	SectionBssBase = ConvertAdress(argv[++i]);
					else				SectionBssBase = ConvertAdress(argv[i]+3);
					break;

				case 'z':
					if (argv[i][3]==0)	SectionZeroBase = ConvertAdress(argv[++i]);
					else				SectionZeroBase = ConvertAdress(argv[i]+3);
					break;

				default:
					fprintf(stderr,"unknow segment type '%c' - ignoring!\n",argv[i][2]);
					break;
				}
				break;

			case 0:
				fprintf(stderr, "Single dash '-' on command line - ignoring!\n");
				break;

			default:
				fprintf(stderr, "Unknown option '%c' - ignoring!\n",argv[i][1]);
				break;
			}
		}
		else
		{
			// no option -> filename
			cInputFileList.push_back(argv[i]);
		}
		i++;
	 }

	 if (cInputFileList.empty())
	 {
		 fprintf(stderr, "No input files given!\n");
		 exit(0);
	 }

	 ptr_symbols_handle	=xfopen(ptr_symbols_filename,"w");
	 ptr_error_handle	=xfopen(ptr_error_filename,"w");
	 if (!strcmp(ptr_output_filename,"-"))
	 {
		 ptr_output_filename=NULL;
		 ptr_output_handle = stdout;
	 }
	 else
	 {
		 ptr_output_handle= xfopen(ptr_output_filename,"wb");
	 }
	 if (!ptr_output_handle)
	 {
		 fprintf(stderr, "Couldn't open output file!\n");
		 exit(1);
	 }

	 if (bFlagVerbose)		fprintf(stderr, "%s",copyright);

	 if (ptr_error_handle)	fprintf(ptr_error_handle,"%s",copyright);
	 if (bFlagVerbose)		logout(ctime(&tim1));

	 //
	 // Pass 1
	 //
	 TablePcSegment[eSEGMENT_ABS]= 0;		/* abs addressing */
	 seg_start(fmode,SectionTextBase,SectionDataBase,SectionBssBase,SectionZeroBase,0,relmode);

	 if (relmode)
	 {
		 r_mode(RMODE_RELOC);
		 segment = eSEGMENT_TEXT;
	 }
	 else
	 {
		 r_mode(RMODE_ABS);
	 }

	 for (i=0;i<cInputFileList.size();i++)
	 {
		 const std::string& cSourceFilename=cInputFileList[i];

		 sprintf(out,"xAss65: Pass 1: %s\n",cSourceFilename.c_str());
		 if (bFlagVerbose) logout(out);

		 er=PreprocessorFile_c::Open(cSourceFilename.c_str(),b_depth());
		 if (!er)
		 {
			 er=pass1();
			 gPreprocessor.Close();
		 }
		 else
		 {
			 sprintf(out, "Couldn't open source file '%s'!\n", cSourceFilename.c_str());
			 logout(out);
		 }
	 }

	 if ((er=b_depth()))
	 {
		 sprintf(out,"Still %d blocks open at end of file!\n",er);
		 logout(out);
	 }

	 if (SectionTextBase & (align-1))
	 {
		 sprintf(out,"Warning: text segment ($%04x) start address doesn't align to %d!\n",SectionTextBase,align);
		 logout(out);
	 }
	 if (SectionDataBase & (align-1))
	 {
		 sprintf(out,"Warning: data segment ($%04x) start address doesn't align to %d!\n",SectionDataBase,align);
		 logout(out);
	 }
	 if (SectionBssBase & (align-1))
	 {
		 sprintf(out,"Warning: bss segment ($%04x) start address doesn't align to %d!\n",SectionBssBase,align);
		 logout(out);
	 }
	 if (SectionZeroBase & (align-1))
	 {
		 sprintf(out,"Warning: zero segment ($%04x) start address doesn't align to %d!\n",SectionZeroBase,align);
		 logout(out);
	 }
	 if (gFlag_n65816>0)
		 fmode |= 0x8000;

	 switch (align)
	 {
	 case 1:
		 break;
	 case 2:
		 fmode |= 1;
		 break;
	 case 4:
		 fmode |= 2;
		 break;
	 case 256:
		 fmode |=3;
		 break;
	 }

	 if ((!er) && relmode)
	 {
		 h_write(ptr_output_handle, fmode,SectionTextLenght,SectionDataLenght,SectionBssLenght,SectionZeroLenght, 0);
	 }


	 //
	 // Pass 2
	 //
	 if (!er)
	 {
		 if (bFlagVerbose) logout("xAss65: Pass 2:\n");

		 seg_pass2();

		 if (!relmode)
		 {
			 r_mode(RMODE_ABS);
		 }
		 else
		 {
			 r_mode(RMODE_RELOC);
			 segment = eSEGMENT_TEXT;
		 }
		 er=pass2();
	 }

	 if (ptr_symbols_handle)
	 {
		 afile->Label_PrintList(ptr_symbols_handle);
	 }

	 tim2=time(NULL);
	 if (bFlagVerbose)
	 {
		 printstat();
	 }

	 if ((!er) && relmode) seg_end(ptr_output_handle);	/* write reloc/label info */

	 if (ptr_error_handle)		fclose(ptr_error_handle);
	 if (ptr_symbols_handle)	fclose(ptr_symbols_handle);
	 if (ptr_output_handle)		fclose(ptr_output_handle);

	 gPreprocessor.Terminate();

	 if (ner || er)
	 {
		 fprintf(stderr, "Break after %d error%c\n",ner,ner?'s':0);
		 /*unlink();*/
		 if (ptr_output_filename)
		 {
			 unlink(ptr_output_filename);
		 }
	 }

	 return ( (er || ner) ? 1 : 0 );
}

static void printstat(void)
{
	logout("Statistics:\n");
	sprintf(out," %8d of %8d label used\n",afile->Label_GetUsedCount(),gm_lab());
	logout(out);
	sprintf(out," %8ld of %8ld byte label-memory used\n",ga_labm(),gm_labm());
	logout(out);
	sprintf(out," %8d of %8d PP-defs used\n",gPreprocessor.ga_pp(),gPreprocessor.gm_pp());
	logout(out);
	sprintf(out," %8ld of %8ld byte PP-memory used\n",gPreprocessor.ga_ppm(),gPreprocessor.gm_ppm());
	logout(out);
	sprintf(out," %8ld of %8ld byte buffer memory used\n",afile->ga_p1(),afile->gm_p1());
	logout(out);
	sprintf(out," %8d blocks used\n",ga_blk());
	logout(out);
	sprintf(out," %8ld seconds used\n",(long)difftime(tim2,tim1));
	logout(out);
}

#define fputw(a,fp) fputc((a)&255,fp);fputc((a>>8)&255,fp)

int h_length(void)
{
	return 26+o_length();
}


static int setfext(char *s, char *ext)
{
	int j,i=(int)strlen(s);

	if (i>MAXLINE-5)
	{
		return -1;
	}

	for (j=i-1;j>=0;j--)
	{
		if (s[j]==DIRCHAR)
		{
			strcpy(s+i,ext);
			break;
		}
		if (s[j]=='.')
		{
			strcpy(s+j,ext);
			break;
		}
	}
	if (!j)
		strcpy(s+i,ext);

	return 0;
}


#ifndef abs
#define abs(a) ((a)>=0 ? a : -a)
#endif

static int pass2(void)
{
	int					c,er,l,ll,i,al;
	signed char			*dataseg=NULL;
	signed char			*datap=NULL;

	memode=0;
	xmode=0;
	if ((dataseg=(signed char*)malloc(SectionDataLenght)))
	{
		if (!dataseg)
		{
			fprintf(stderr, "Couldn't alloc dataseg memory...\n");
			exit(1);
		}
		datap=dataseg;
	}

	PreprocessorFile_c datei;
	gPreprocessor.m_CurrentFile=&datei;
	afile->m_cMnData.tmpe=0L;

	while (ner<20 && afile->m_cMnData.tmpe<afile->m_cMnData.tmpz)
	{
		l=afile->m_cMnData.ReadByte();
		ll=l;

		if (!l)
		{
			int nType=afile->m_cMnData.ReadByte();
			if (nType==T_LINE)
			{
				datei.m_current_line=afile->m_cMnData.ReadShort();
			}
			else
			if (nType==T_FILE)
			{
				datei.m_current_line=afile->m_cMnData.ReadShort();
				datei.m_file_name=afile->m_cMnData.ReadString();
			}
		}
		else
		{
			er=t_p2(afile->m_cMnData.m_ptr_tmp+afile->m_cMnData.tmpe,&ll,0,&al);

			if (er==E_NOLINE)
			{
			}
			else
			if (er==E_OK)
			{
				if (segment<eSEGMENT_DATA)
				{
					for(i=0;i<ll;i++)
					{
						chrput(afile->m_cMnData.m_ptr_tmp[afile->m_cMnData.tmpe+i]);
					}
				}
				else
				if (segment==eSEGMENT_DATA && datap)
				{
					memcpy(datap,afile->m_cMnData.m_ptr_tmp+afile->m_cMnData.tmpe,ll);
					datap+=ll;
				}
			}
			else
			if (er==E_DSB)
			{
				c=afile->m_cMnData.m_ptr_tmp[afile->m_cMnData.tmpe];
				if (segment<eSEGMENT_DATA)
				{
					for(i=0;i<ll;i++)
					{
						chrput(c);
					}
				}
				else
				if (segment==eSEGMENT_DATA && datap)
				{
					memset(datap, c, ll);
					datap+=ll;
				}
			}
			else
			{
				errout(er);
			}
			afile->m_cMnData.tmpe+=abs(l);
		}
	}
	if (relmode)
	{
		if ((ll=fwrite(dataseg, 1,SectionDataLenght, ptr_output_handle))<SectionDataLenght)
		{
			fprintf(stderr, "Problems writing %d bytes, return gives %d\n",SectionDataLenght,ll);
		}
	}

	return ner;
}


static int pass1(void)
{
	signed char out[MAXLINE];
	int l,er, outlen;

	memode=0;
	xmode=0;
	SectionTextLenght=0;
	ner=0;
	while (!(er=getline(BufferLine)))
	{
		/*
		if (!strcmp(BufferLine,"Lctk-conio70"))
		{
			printf("\r\nBreak here !!!\r\n");
		}
		*/
		er=t_p1((signed char*)BufferLine,out,&l,&outlen);

		switch (segment)
		{
		case eSEGMENT_ABS:
		case eSEGMENT_TEXT:
			SectionTextLenght+= outlen;
			break;
		case eSEGMENT_DATA:
			SectionDataLenght+= outlen;
			break;
		case eSEGMENT_BSS :
			SectionBssLenght += outlen;
			break;
		case eSEGMENT_ZERO:
			SectionZeroLenght+= outlen;
			break;
		}

		if (l)
		{
			if (er)
			{
				if (er==E_OKDEF)
				{
					if (!(er=afile->MnDataPushCharacter(l)))
					{
						er=afile->MnDataPushString(out,l);
					}
				}
				else
				if (er==E_NOLINE)
				{
					er=E_OK;
				}
			}
			else
			{
				if (!(er=afile->MnDataPushCharacter(-l)))
				{
					er=afile->MnDataPushString(out,l);
				}
			}
		}
		if (er)
		{
			lineout();
			errout(er);
		}
	}

	if (er!=E_EOF)
	{
		errout(er);
	}

	return ner;
}



#define   ANZERR	31
#define   ANZWARN	6

/*
static char *ertxt[] = { "Syntax","Label definiert",
"Label nicht definiert","Labeltabelle voll",
"Label erwartet","Speicher voll","Illegaler Opcode",
"Falsche Adressierungsart","Branch ausserhalb des Bereichs",
"Ueberlauf","Division durch Null","Pseudo-Opcode erwartet",
"Block-Stack-Ueberlauf","Datei nicht gefunden",
"End of File","Block-Struktur nicht abgeschlossen",
"NoBlk","NoKey","NoLine","OKDef","DSB","NewLine",
"NewFile","CMOS-Befehl","pp:Falsche Anzahl Parameter" };
*/
static char *ertxt[] =
{
	"Syntax",
	"Label defined",
	"Label not defined",
	"Labeltab full",
	"Label expected",
	"no more memory",
	"Illegal opcode",
	"Wrong addressing mode",
	"Branch out of range",
	"Overflow",
	"Division by zero",
	"Pseudo-opcode expected",
	"Block stack overflow",
	"file not found",
	"End of file",
	"Too many block close",
	"NoBlk",
	"NoKey",
	"NoLine",
	"OKDef",
	"DSB",
	"NewLine",
	"NewFile",
	"CMOS-Befehl",
	"pp:Wrong parameter count",
	"Illegal pointer arithmetic",
	"Illegal segment",
	"File header option too long",
	"File Option not at file start (when ROM-able)",
	"Illegal align value",
	"65816 code used",
	/* warnings start here */
	"Cutting word relocation in byte value",
	"Byte relocation in word value",
	"Illegal pointer arithmetic",
	"Address access to low or high byte pointer",
	"High byte access to low byte pointer",
	"Low byte access to high byte pointer"
};

static int gFlagMasmCompatibilityWeirdSwitch;
static int gFlagLineOutTest;




static char GetLineBuffer[MAXLINE];

static int getline(char *s)
{
	static int ec;
	static int i,c;

	int j=0;
	int bFlagInQuotedString=0;
	ec=E_OK;

	if (!gFlagMasmCompatibilityWeirdSwitch)
	{
		do
		{
			ec=gPreprocessor.GetLine(GetLineBuffer);
			i=0;
			while (GetLineBuffer[i]==' ')
			{
				i++;
			}

			while (GetLineBuffer[i]!=0 && isdigit(GetLineBuffer[i]))
			{
				i++;
			}


			gFlagLineOutTest=1;

			if (ec==E_NEWLINE)
			{
				afile->MnDataPushCharacter(0);
				afile->MnDataPushCharacter(T_LINE);
				afile->MnDataPushCharacter((gPreprocessor.m_CurrentFile->m_current_line)&255);
				afile->MnDataPushCharacter(((gPreprocessor.m_CurrentFile->m_current_line)>>8)&255);
				ec=E_OK;
			}
			else
			if (ec==E_NEWFILE)
			{
				afile->MnDataPushCharacter(0);
				afile->MnDataPushCharacter(T_FILE);
				afile->MnDataPushCharacter((gPreprocessor.m_CurrentFile->m_current_line)&255);
				afile->MnDataPushCharacter(((gPreprocessor.m_CurrentFile->m_current_line)>>8)&255);
				afile->MnDataPushString((signed char*)gPreprocessor.m_CurrentFile->m_file_name.c_str(),gPreprocessor.m_CurrentFile->m_file_name.size()+1);
				ec=E_OK;
			}
		}
		while (!ec && GetLineBuffer[i]==0);
	}

	gFlagMasmCompatibilityWeirdSwitch=0;
	if (!ec)
	{
		do
		{
			c=s[j]=GetLineBuffer[i++];

			if (c=='\"')
				bFlagInQuotedString^=1;

			if (c==0)
				break;

			if ((!gFlagMasmCompatibilityMode) && (c==':') && !bFlagInQuotedString)
			{
				gFlagMasmCompatibilityWeirdSwitch=1;
				break;
			}
			j++;
		}
		while (c!=0 && j<MAXLINE-1 && i<MAXLINE-1);

		s[j]=0;
	}
	else
	{
		s[0]=0;
	}

	return ec;
}

void set_align(int a)
{
	align = (a>align)?a:align;
}

static void lineout(void)
{
	if (gFlagLineOutTest)
	{
		logout(gPreprocessor.m_CurrentFile->m_p_line_buffer);
		logout("\n");
		gFlagLineOutTest=0;
	}
}

void errout(int er)
{
	if (er<-ANZERR || er>-1)
	{
		if (er>=-(ANZERR+ANZWARN) && er < -ANZERR)
		{
			sprintf(out,"%s(%d):  %04x: Warning - %s\n",gPreprocessor.m_CurrentFile->m_file_name.c_str(), gPreprocessor.m_CurrentFile->m_current_line, TablePcSegment[segment], ertxt[-er-1]);
		}
		else
		{
			/* sprintf(out,"%s:Zeile %d: %04x:Unbekannter Fehler Nr.: %d\n",*/
			sprintf(out,"%s(%d):  %04x: Unknown error # %d\n",gPreprocessor.m_CurrentFile->m_file_name.c_str(),gPreprocessor.m_CurrentFile->m_current_line,TablePcSegment[segment],er);
			ner++;
		}
	}
	else
	{
		if (er==ERR_UNDEFINED_LABEL)
			sprintf(out,"%s(%d):  %04x:Label '%s' not defined\n",gPreprocessor.m_CurrentFile->m_file_name.c_str(),gPreprocessor.m_CurrentFile->m_current_line,TablePcSegment[segment],gError_LabelNamePointer);
		else
			sprintf(out,"%s(%d):  %04x:%s error\n",gPreprocessor.m_CurrentFile->m_file_name.c_str(),gPreprocessor.m_CurrentFile->m_current_line,TablePcSegment[segment],ertxt[-er-1]);

		ner++;
	}
	logout(out);
}

static void chrput(int c)
{
	/* 	printf(" %02x",c&255);*/

	putc( c&0x00ff,ptr_output_handle);
}

void logout(char *s)
{
	fprintf(stderr, "%s",s);
	if (ptr_error_handle)
		fprintf(ptr_error_handle,"%s",s);
}

