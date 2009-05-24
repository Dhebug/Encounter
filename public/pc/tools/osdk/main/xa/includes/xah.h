

#include <string>
#include <vector>

//#define		C64_ASCII


#define   ANZLAB    5000       /* mal 14 -> Byte   */
#define   LABMEM    40000L
#define   MAXLAB    32
#define   MAXBLK    16
#define   MAXFILE   7
#define   MAXLINE   8192		// 2048 -> Explodes with large recursions
#define   MAX_PREPROCESSOR_BUFFER_SIZE     1000000		// 40000L		// MAX PREPROCESSOR !!!
#define   ANZDEF    2340      /* mal 14 -> Byte , ANZDEF*14<32768       */
//#define   TMPMEM    200000L   // Zwischenspeicher von Pass1 nach Pass 2
#define   TMPMEM    400000L   // Zwischenspeicher von Pass1 nach Pass 2

enum OPERATOR_e
{
	eOPERATOR_NONE=0,				// 0
	eOPERATOR_ADD,					// 1
	eOPERATOR_SUBTRACT,				// 2
	eOPERATOR_MULTIPLY,				// 3
	eOPERATOR_DIVIDE,				// 4
	eOPERATOR_SHIFTRIGHT,			// 5
	eOPERATOR_SHIFTLEFT,			// 6
	eOPERATOR_INFERIOR,				// 7
	eOPERATOR_SUPERIOR,				// 8
	eOPERATOR_EQUAL,				// 9
	eOPERATOR_INFERIOR_OR_EQUAL,	// 10
	eOPERATOR_SUPERIOR_OR_EQUAL,	// 11
	eOPERATOR_DIFFERENT,			// 12
	eOPERATOR_BINARY_AND,			// 13
	eOPERATOR_XOR,					// 14
	eOPERATOR_BINARY_OR,			// 15
	eOPERATOR_LOGICAL_AND,			// 16 
	eOPERATOR_LOGICAL_OR,			// 17
	_eOPERATOR_MAX_
};


enum SEGMENT_e
{
	eSEGMENT_ABS=0,	// 0
	eSEGMENT_UNDEF, // 1
	eSEGMENT_TEXT,	// 2
	eSEGMENT_DATA,	// 3
	eSEGMENT_BSS,	// 4
	eSEGMENT_ZERO,	// 5
	_eSEGMENT_MAX_ 
};


enum SYMBOLSTATUS_e
{
	eSYMBOLSTATUS_UNKNOWN=0,	// 0 label value not valid/known
	eSYMBOLSTATUS_VALID,		// 1 label value known
	eSYMBOLSTATUS_GLOBAL,		// 2 = Global symbol
};


struct SymbolEntry
{
     int			blk;
     int			value;
     SYMBOLSTATUS_e	symbol_status;   	// 0 = label value not valid/known, 1 = label value known
     SEGMENT_e		program_section;	// 0 = no address (no relocation), 1 = address label, 5=ZERO
     int			nextindex;
     char			*ptr_label_name;
     int			label_name_lenght;
};




#define   MEMLEN    (4+TMPMEM+MAX_PREPROCESSOR_BUFFER_SIZE+LABMEM+(long)(sizeof(SymbolEntry)*ANZLAB)+(long)(sizeof(List)*ANZDEF))

#define   DIRCHAR    '/'
#define	  DIRCSTRING "/" 
/* for Atari:
#define	  DIRCHAR    '\\'
#define	  DIRCSTRING "\\"
*/

#define	BUFSIZE	4096		/* File-Puffegroesse (wg Festplatte)	*/
	
#define   E_OK      0         /* Fehlernummern                   */
#define   E_SYNTAX  -1        /* Syntax Fehler                   */
#define   E_LABDEF  -2        /* Label definiert                 */
#define   ERR_UNDEFINED_LABEL   -3        /* Label nicht definiert           */
#define   E_LABFULL -4        /* Labeltabelle voll               */
#define   E_LABEXP  -5        /* Label erwartet                  */
#define   E_OUT_OF_MEMORY   -6        /* kein Speicher mehr              */
#define   E_ILLCODE -7        /* Illegaler Opcode                */
#define   E_ADRESS  -8        /* Illegale Adressierung           */
#define   E_RANGE   -9        /* Branch out of range             */
#define   E_OVERFLOW -10      /* Ueberlauf                       */
#define   E_DIV     -11       /* Division durch Null             */
#define   E_PSOEXP  -12       /* Pseudo-Opcode erwartet          */
#define   E_BLKOVR  -13       /* Block-Stack Uebergelaufen       */
#define   ERR_FILE_NOT_FOUND     -14       /* File not found (pp)             */
#define   E_EOF     -15       /* End of File                     */
#define   E_BLOCK   -16       /* Block inkonsistent              */
#define   E_NOBLK   -17
#define   E_NOKEY   -18
#define   E_NOLINE  -19
#define   E_OKDEF   -20	      /* okdef */
#define   E_DSB     -21
#define   E_NEWLINE -22
#define   E_NEWFILE -23
#define   E_CMOS    -24
#define   E_PARENTHESIS_MISMATCH  -25
#define	  E_ILLPOINTER -26    /* illegal pointer arithmetic! */
#define	  E_ILLSEGMENT -27    /* illegal pointer arithmetic! */
#define	  E_OPTLEN  -28       /* file header option too long */
#define	  E_ROMOPT  -29       /* header option not directly after file start in romable mode */
#define	  E_ILLALIGN -30      /* illegal align value */

#define	  W_ADRRELOC	-32	/* word relocation in byte value */
#define	  W_BYTRELOC	-33	/* byte relocation in word value */
#define	  E_WPOINTER 	-34     /* illegal pointer arithmetic!   */
#define	  W_ADDRACC	-35	/* addr access to low or high byte pointer */
#define	  W_HIGHACC	-36	/* high byte access to low byte pointer */
#define	  W_LOWACC	-37	/* low byte access to high byte pointer */

#define   E_65816   -31


#define   T_VALUE   -1
#define   T_LABEL   -2 
#define   T_OP      -3
#define   T_END     -4
#define   T_LINE    -5
#define   T_FILE    -6
#define   T_POINTER -7

#define   P_START   0         /* Prioritaeten fuer Arithmetik    */
#define   P_LOR     1         /* Von zwei Operationen wird immer */
#define   P_LAND    2         /* die mit der hoeheren Prioritaet */
#define   P_OR      3         /* zuerst ausgefuehrt              */
#define   P_XOR     4
#define   P_AND     5
#define   P_EQU     6
#define   P_CMP     7
#define   P_SHIFT   8
#define   P_ADD     9
#define   P_MULT    10
#define   P_INV     11

#define	  A_ADR	    0x8000	/* all are or'd with (afl = segment type)<<8 */
#define   A_HIGH    0x4000	/* or'd with the low byte */
#define   A_LOW     0x2000

#define   A_LONG    0xc000
#define   A_MSB     0xa000

#define   A_MASK    0xe000	/* reloc type mask */
#define   A_FMASK   0x0f00	/* segment type mask */


#define	  FM_OBJ    0x1000
#define   FM_SIZE   0x2000
#define   FM_RELOC  0x4000
#define   FM_CPU    0x8000


struct Fopt 
{
    signed char 	*text;          /* text after pass1 */
    int     		len;
};

struct relocateInfo 
{
    int             next;
    int             adr;
    int             afl;			
    int             lab;
};



class MnData_c
{
public:
	MnData_c();

	int ReadByte(bool bMoveReadPosition=true);
	int ReadShort(bool bMoveReadPosition=true);
	std::string ReadString(bool bMoveReadPosition=true);

public:
	signed char 	*m_ptr_tmp;
	unsigned long	tmpz;
	unsigned long	tmpe;
};


class SymbolData_c
{
public:
	SymbolData_c();
	~SymbolData_c();

public:
	int 			hashindex[256];
	SymbolEntry*	ptr_table_entries;
	int				nb_labels;
	int				max_labels;
} ;



class FileData_c
{
public:
	FileData_c();
	~FileData_c();
	
	long ga_p1();
	long gm_p1();
		
	//
	// Mn Stuff
	//
	int MnDataPushCharacter(int c);
	int MnDataPushString(signed char *s,int l);

	//
	// label stuff
	//
	int Label_GetUsedCount();
	void Label_PrintList(FILE *fp);

public:
	int	fmode;
	int slen;
	int	relmode;
	int	old_abspc;
	int	base[_eSEGMENT_MAX_];
	int	len[_eSEGMENT_MAX_];

	struct 
	{
		int		*ulist;
		int 	un;
		int 	um;
	} ud;

	struct 
	{
		relocateInfo 	*rlist;
		int 			mlist;
		int				nlist;
		int			first;
	} rt;

	struct 
	{
		relocateInfo 	*rlist;
		int 			mlist;
		int				nlist;
		int				first;
	} rd;

	struct 
	{
		Fopt	*olist;
		int		mlist;
		int		nlist;
	} fo;

	MnData_c			m_cMnData;
	SymbolData_c		m_cSymbolData;
};

extern FileData_c *afile;


