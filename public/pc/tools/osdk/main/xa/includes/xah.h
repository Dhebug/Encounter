

#include <string>
#include <vector>

#include "xau.h"		// UndefinedLabels
#include "xao.h"		// Options
#include "xar.h"		// Relocation


//#define		C64_ASCII
extern char *gError_LabelNamePointer;

#define   ANZLAB    5000       /* mal 14 -> Byte   */
#define   LABMEM    40000L
#define   MAXBLK    32                  // Was 16
#define   MAXFILE   15                  // Was 7
#define   MAXLINE   16000               // Was 8192		// 2048 -> Explodes with large recursions
#define   MAX_PREPROCESSOR_BUFFER_SIZE     1000000		// 40000L		// MAX PREPROCESSOR !!!
#define   ANZDEF    10000               // Was 2340      /* mal 14 -> Byte , ANZDEF*14<32768       */
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





#define   MEMLEN    (4+TMPMEM+MAX_PREPROCESSOR_BUFFER_SIZE+LABMEM+(long)(sizeof(SymbolEntry)*ANZLAB)+(long)(sizeof(List)*ANZDEF))

#define   DIRCHAR    '/'
#define	  DIRCSTRING "/" 
/* for Atari:
#define	  DIRCHAR    '\\'
#define	  DIRCSTRING "\\"
*/

#define	BUFSIZE	4096		/* File-Puffegroesse (wg Festplatte)	*/
	
enum ErrorCode
{
	E_OK				=0,         // Fehlernummern                   
	E_SYNTAX			=-1,        // Syntax Fehler                   
	E_LABDEF			=-2,        // Label definiert                 
	ERR_UNDEFINED_LABEL	=-3,        // Label nicht definiert           
	E_LABFULL			=-4,        // Labeltabelle voll               
	E_LABEXP			=-5,        // Label erwartet                  
	E_OUT_OF_MEMORY		=-6,        // kein Speicher mehr              
	E_ILLCODE			=-7,        // Illegaler Opcode                
	E_ADRESS			=-8,        // Illegale Adressierung           
	E_RANGE				=-9,        // Branch out of range             
	E_OVERFLOW			=-10,       // Ueberlauf                       
	E_DIV				=-11,       // Division durch Null             
	E_PSOEXP			=-12,       // Pseudo=-Opcode erwartet         
	E_BLKOVR			=-13,       // Block=-Stack Uebergelaufen      
	ERR_FILE_NOT_FOUND  =-14,       // File not found (pp)             
	E_EOF				=-15,       // End of File
	E_BLOCK				=-16,       // Block inkonsistent
	E_NOBLK   			=-17,
	E_NOKEY   			=-18,
	E_NOLINE  			=-19,
	E_OKDEF   			=-20,	    // okdef 
	E_DSB     			=-21,
	E_NEWLINE 			=-22,
	E_NEWFILE 			=-23,
	E_CMOS    			=-24,
	E_PARENTHESIS_MISMATCH=-25,
	E_ILLPOINTER 		=-26,		// illegal pointer arithmetic! 
	E_ILLSEGMENT 		=-27,		// illegal pointer arithmetic! 
	E_OPTLEN 			=-28,       // file header option too long 
	E_ROMOPT 			=-29,       // header option not directly after file start in romable mode 
	E_ILLALIGN			=-30,		// illegal align value 
	E_65816				=-31,
	W_ADRRELOC			=-32,		// word relocation in byte value 
	W_BYTRELOC			=-33,		// byte relocation in word value 
	E_WPOINTER 			=-34,		// illegal pointer arithmetic!   
	W_ADDRACC			=-35,		// addr access to low or high byte pointer 
	W_HIGHACC			=-36,		// high byte access to low byte pointer 
	W_LOWACC			=-37		// low byte access to high byte pointer 
};


enum Tokens
{
	T_VALUE   =-1,
	T_LABEL   =-2, 
	T_OP      =-3,
	T_END     =-4,
	T_LINE    =-5,
	T_FILE    =-6,
	T_POINTER =-7
};

enum OperatorPriority
{
	P_START   =0,         // Prioritaeten fuer Arithmetik    
	P_LOR     =1,         // Von zwei Operationen wird immer
	P_LAND    =2,         // die mit der hoeheren Prioritaet 
	P_OR      =3,         // zuerst ausgefuehrt             
	P_XOR     =4,
	P_AND     =5,
	P_EQU     =6,
	P_CMP     =7,
	P_SHIFT   =8,
	P_ADD     =9,
	P_MULT    =10,
	P_INV     =11
};


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



class SymbolEntry
{
	friend class SymbolData;

public:
	void Set(int v,SEGMENT_e afl);
	ErrorCode Get(int *v,int *afl);

	void SetBlockLevel(int block_level)	{ m_block_level=block_level; }
	int GetBlockLevel() const			{ return m_block_level; }

	const char* GetSymbolName() const	{ return ptr_label_name; }

	int DefineSymbol(char *ptr_src,int block_level);		// Returns hash

private:
	int				m_block_level;
	int				value;
	SYMBOLSTATUS_e	symbol_status;   	// 0 = label value not valid/known, 1 = label value known
	SEGMENT_e		program_section;	// 0 = no address (no relocation), 1 = address label, 5=ZERO
	int				nextindex;
	char			*ptr_label_name;
	int				label_name_lenght;
};



class MnData
{
public:
	MnData();

	int ReadByte(bool bMoveReadPosition=true);
	int ReadUByte(bool bMoveReadPosition=true);
	int ReadShort(bool bMoveReadPosition=true);
	unsigned int ReadUShort(bool bMoveReadPosition=true);
	std::string ReadString(bool bMoveReadPosition=true);

	ErrorCode WriteByte(int c);
	ErrorCode WriteShort(int c);
	ErrorCode WriteUShort(unsigned int c);
	ErrorCode WriteString(signed char *s, int l);

	void ResetReadPos()					{ m_read_pos=0; }
	unsigned long GetReadPos() const	{ return m_read_pos; }
	unsigned long GetWritePos() const	{ return m_write_pos; }
	void MoveReadPos(int offset)		{ m_read_pos+=offset; }

	bool CanReadMore() const			{ return m_read_pos<m_write_pos; }

	signed char *GetReadPointer()  { return m_ptr_tmp+m_read_pos; }				// Mike: Should be const, but t_p2 modifies the buffer

private:
	signed char 	*m_ptr_tmp;
	unsigned long	m_write_pos;
	unsigned long	m_read_pos;
};


class SymbolData
{
public:
	SymbolData();
	~SymbolData();

	ErrorCode DefineGlobalLabel(char *s);
	ErrorCode DefineLabel(char *ptr_src,int *size_read,int *x,bool *flag_redefine_label);

	ErrorCode DefineSymbol(char *ptr_src,int *label_index,int block_level);
	ErrorCode SearchSymbol(char *ptr_src,int *label_index);

	SymbolEntry& GetSymbolEntry(int index)
	{
		SymbolEntry	*ptr_symbol_entry=m_ptr_table_entries+index;
		return *ptr_symbol_entry;
	}

	int GetLabelCount() const
	{
		return m_nb_labels;
	}

	int SaveSymbols(FILE *fp);
	void PrintSymbols(FILE *fp);

	void ExitBlock(SEGMENT_e a,SEGMENT_e b);

	ErrorCode l_such(char *s, int *l, int *x, int *v, int *afl);
	ErrorCode ll_pdef(char *t);

private:
	SymbolEntry*	m_ptr_table_entries;
	int				m_max_labels;
	int 			m_hashindex[256];
	int				m_nb_labels;
};




class FileData
{
public:
	FileData();
	~FileData();
	
	long ga_p1();
	long gm_p1();

	int pass2();
		
	//
	// Mn Stuff
	//
	ErrorCode WriteByte(int c);
	ErrorCode WriteShort(int c);
	ErrorCode WriteUShort(unsigned int c);
	ErrorCode WriteSequence(signed char *s,int l);

	void StartSegment(int fmode,int t_base,int d_base,int b_base,int z_base,int stacklen,int relmode);
	void SegmentPass2();
	void SegmentEnd(FILE *fpout);

	int WriteRelocatableHeader(FILE *fp,int mode,int tlen,int dlen,int blen,int zlen,int stack);

	void SetSegmentBase(SEGMENT_e segment,int base);

	int u_set(int pc,int afl,int label,int l);
	int r_set(int pc,int afl,int l);

	void set_fopt(int l, signed char *buf, int reallen);

	int h_length();

private:
	int					m_fmode;
	int 				m_slen;
	int					m_relmode;
	int					m_old_abspc;
	int					m_base[_eSEGMENT_MAX_];
	int					m_len[_eSEGMENT_MAX_];
	UndefinedLabels		m_undefined_labels;
	Relocation			m_relocation_text;
	Relocation			m_relocation_data;
	Options				m_options;
	MnData				m_cMnData;

public:

	SymbolData			m_cSymbolData;
};

extern FileData *afile;


