/* C compiler: definitions */
/* default sizes */
#define MAXLINE   512		/* maximum output line length */
#define MAXTOKEN   32		/* maximum token length */
#define	BUFSIZE	 4096		/* input buffer size */
#define HASHSIZE  128		/* default hash table size */
#define MEMINCR    10		/* blocks (1kb) allocated per arena */

#if defined(__LCC__) || defined(_MSC_VER)
#ifndef __STDC__
#define __STDC__ 1
#endif
#endif

#include "ops.h"
#include <assert.h>

#ifdef __STDC__
#include <stdarg.h>
#define va_init va_start

typedef enum tokencode {
#define xx(a,b,c,d,e,f,g) a=b,
#define yy(a,b,c,d,e,f,g)
#include "token.h"
	NTOKENS
} Typeop;			/* type operators are a subset of tokens */

#define dclproto(func,args) func args
typedef void *Generic;
#else
#include <varargs.h>
#define va_init(a,b) va_start(a)

#define xx(a,b,c,d,e,f,g)
#include "token.h"
typedef int Typeop;

#define dclproto(func,args) func()
typedef char *Generic;
#endif

typedef struct list {		/* lists: */
	Generic x;			/* element */
	struct list *link;		/* next node */
} *List;
typedef struct symbol *Symbol;	/* symbol table entries */
typedef struct table *Table;	/* symbol tables */
typedef struct tynode *Type;	/* type nodes */
typedef struct node *Node;	/* dag nodes */
typedef struct tree *Tree;	/* tree nodes */
typedef struct field *Field;	/* struct/union fields */
typedef struct swtch *Swtch;	/* switch data */
typedef union value {	/* constant values: */
	char sc;		/* signed */
	short ss;		/* signed */
	int i;			/* signed */
	unsigned char uc;
	unsigned short us;
	unsigned int u;
	double f;
	double d;
	char *p;		/* pointer to anything */
} Value;

typedef struct coord {	/* source coordinates: */
	char *file;		/* file name */
	unsigned short x, y;	/* x,y position in file */
} Coordinate;

dclproto(extern void address,(Symbol, Symbol, int));
dclproto(extern void asmcode,(char *, Symbol []));
dclproto(extern void defaddress,(Symbol));
dclproto(extern void defconst,(int, Value));
dclproto(extern void defstring,(int, char *));
dclproto(extern void defsymbol,(Symbol));
dclproto(extern void emit,(Node));
dclproto(extern void export,(Symbol));
dclproto(extern void function,(Symbol, Symbol [], Symbol [], int));
dclproto(extern Node gen,(Node));
dclproto(extern void global,(Symbol));
dclproto(extern void import,(Symbol));
dclproto(extern void local,(Symbol));
dclproto(extern void progbeg,(int, char **));
dclproto(extern void progend,(void));
dclproto(extern void segment,(int));
dclproto(extern void space,(int));
/* symbol table */
dclproto(extern void stabblock,(int, int, Symbol*));
dclproto(extern void stabend,(Coordinate *, Symbol, Coordinate **, Symbol *, Symbol *));
dclproto(extern void stabfend,(Symbol, int));
dclproto(extern void stabinit,(char *, int, char *[]));
dclproto(extern void stabline,(Coordinate *));
dclproto(extern void stabsym,(Symbol));
dclproto(extern void stabtype,(Symbol));

#include "config.h"
#ifndef MAXKIDS
#define MAXKIDS 2
#endif
#ifndef MAXSYMS
#define MAXSYMS 3
#endif
#ifndef blockbeg
dclproto(extern void blockbeg,(Env *));
#endif
#ifndef blockend
dclproto(extern void blockend,(Env *));
#endif
#ifndef JUMP_ON_RETURN
#define JUMP_ON_RETURN 0
#endif

/* limits */
#if 1
//#ifdef __LCC__
#include <limits.h>
#include <float.h>
#else
/*
 * The magnitudes of the values below are greater than or equal to the minimum
 * permitted by the standard (see Appendix D) and are typical for byte-addressed
 * machines with 32-bit integers. These values are suitable for bootstrapping.
 */
#define CHAR_BIT	8
#define MB_LEN_MAX	1

#define UCHAR_MAX	0xff
#define USHRT_MAX	0xff
#define UINT_MAX	0xffff
#define ULONG_MAX	0xffffL

#define CHAR_MAX	SCHAR_MAX
#define SCHAR_MAX	0x7f
#define SHRT_MAX	0x7f
#define INT_MAX	0x7fff
#define LONG_MAX	0x7fffL

#define CHAR_MIN	SCHAR_MIN
#define SCHAR_MIN	(-SCHAR_MAX-1)
#define SHRT_MIN	(-SHRT_MAX-1)
#define INT_MIN		(-INT_MAX-1)
#define LONG_MIN	(-LONG_MAX-1)

#define FLT_MAX		1e37
#define DBL_MAX		1e37
#endif

/* data structures */

struct symbol {		/* symbol structures: */
	Xsymbol x;		/* back-end's type extension */
	char *name;		/* name */
	unsigned short scope;	/* scope level */
	unsigned char sclass;	/* storage class */
	unsigned defined:1;	/* 1 if defined */
	unsigned temporary:1;	/* 1 if a temporary */
	unsigned generated:1;	/* 1 if a generated identifier */
	unsigned computed:1;	/* 1 if an address computation identifier */
	unsigned addressed:1;	/* 1 if its address is taken */
	unsigned initialized:1;	/* 1 if local is initialized */
	unsigned structarg:1;	/* 1 if parameter is a struct */
	int ref;		/* weighted # of references */
	Type type;		/* data type */
	Coordinate src;		/* definition coordinate */
	Coordinate **uses;	/* array of Coordinate *'s for uses (omit) */
	Symbol up;		/* next symbol in this or outer scope */
	union {
		struct {		/* labels: */
			int label;		/* label number */
			Symbol equatedto;	/* equivalent label */
		} l;
		struct {	/* struct/union types: */
			unsigned cfields:1; 	/* 1 if >= 1 const fields */
			unsigned vfields:1;	/* 1 if >= 1 volatile fields */
			Table ftab;		/* if xref != 0, table of field names */
			Field flist;		/* field list */
		} s;
		int value;	/* enumeration identifiers: value */
		Symbol *idlist;	/* enumeration types: identifiers */
		struct {	/* constants: */
			Value v;	/* value */
			Symbol loc;	/* out-of-line location */
		} c;
		struct {	/* functions: */
			Coordinate pt[3];/* source code coordinates */
			int label;	/* exit label */
			int ncalls;	/* # calls in this function */
			Symbol *callee;	/* parameter symbols */
		} f;
		int seg;	/* globals, statics: definition segment */
	} u;
#ifdef Ysymbol		/* (omit) */
	Ysymbol y;	/* (omit) */
#endif			/* (omit) */
};


typedef struct {
	unsigned printed:1;
	unsigned marked:1;
	unsigned short typeno;
} Xtype;

#ifdef __STDC__
enum { CODE=1, BSS, DATA, LIT, SYM };	/* logical segments */
enum { CONSTANTS=1, LABELS, GLOBAL, PARAM, LOCAL };
#else
#define CODE	1
#define BSS	2
#define DATA	3
#define LIT	4
#define SYM	5
#define CONSTANTS 1
#define LABELS	2
#define GLOBAL	3
#define PARAM	4
#define LOCAL	5
#endif

/* misc. macros */
#define roundup(x,n) (((x)+((n)-1))&(~((n)-1)))
#define utod(x)	(2.*(int)((unsigned)(x)>>1)+(int)((x)&1))
#ifdef NDEBUG
#define assert(c)
//#else
//#define assert(c) ((c) || fatal(__FILE__,"assertion failure at line %d\n",__LINE__))
#endif

/* C library */
#ifdef OLDOLDOLD
dclproto(extern double strtod,(char *, char **));
dclproto(extern int atoi,(char *));
dclproto(extern int close,(int));
dclproto(extern int creat,(char *, int));
dclproto(extern void exit,(int));
dclproto(extern Generic malloc,(unsigned));
dclproto(extern int open,(char *, int));
dclproto(extern int read,(int, char *, int));
dclproto(extern long strtol,(char *, char **, int));
dclproto(extern int sprintf,(char *, const char *, ...));
dclproto(extern char *strchr,(const char *, int));
dclproto(extern int strcmp,(const char *, const char *));
dclproto(extern unsigned strlen,(const char *));
dclproto(extern char *strncmp,(const char *, const char *, unsigned));
dclproto(extern char *strncpy,(char *, const char *, unsigned));
dclproto(extern int write,(int, char *, int));
#endif

struct node {		/* dag nodes: */
	Opcode op;		/* operator */
	short count;		/* reference count */
 	Symbol syms[MAXSYMS];	/* symbols */
	Node kids[MAXKIDS];	/* operands */
	Node link;		/* next dag in the forest */
	Xnode x;		/* back-end's type extension */
};
#define islabel(p) ((p) && (p)->op == LABEL+V && (p)->syms[0])
struct tree {		/* tree nodes: */
	Opcode op;		/* operator */
	Type type;		/* type of result */
	Tree kids[2];		/* operands */
	Node node;		/* associated dag node */
	union {
		Symbol sym;	/* associated symbol */
		Value v;	/* associated value */
		Field field;	/* associated struct/union bit field */
	} u;
};
typedef struct arena *Arena;
struct arena {			/* storage allocation arena: */
	int m;				/* size of current allocation request */
	char *avail;			/* next available location */
	char *limit;			/* address 1 past end of arena */
	Arena first;			/* pointer to first arena */
	Arena next;			/* link to next arena */
};
#define yyalloc(n,ap) (ap->m = roundup(n,sizeof(double)), \
	ap->avail + ap->m >= ap->limit ? allocate(ap->m, &ap) : \
	(ap->avail += ap->m, ap->avail - ap->m))
#define alloc(n)  yyalloc(n, permanent)
#define talloc(n) yyalloc(n, transient)
#define BZERO(p,t) \
	{ unsigned *q1 = (unsigned *)(p), *q2 = q1 + ((sizeof (t)/sizeof (unsigned))&~(8-1)); \
	for ( ; q1 < q2; q1 += 8) \
		q1[0] = q1[1] = q1[2] = q1[3] = q1[4] = q1[5] = q1[6] = q1[7] = 0; \
	sizeof (t)/sizeof (unsigned)%8 >= 1 ? q1[0] = 0 : 0; \
	sizeof (t)/sizeof (unsigned)%8 >= 2 ? q1[1] = 0 : 0; \
	sizeof (t)/sizeof (unsigned)%8 >= 3 ? q1[2] = 0 : 0; \
	sizeof (t)/sizeof (unsigned)%8 >= 4 ? q1[3] = 0 : 0; \
	sizeof (t)/sizeof (unsigned)%8 >= 5 ? q1[4] = 0 : 0; \
	sizeof (t)/sizeof (unsigned)%8 >= 6 ? q1[5] = 0 : 0; \
	sizeof (t)/sizeof (unsigned)%8 >= 7 ? q1[6] = 0 : 0; \
	sizeof (t)%sizeof (unsigned) >= 1 ? ((char *)(q1 + sizeof (t)/sizeof (unsigned)%8))[0] = 0 : 0; \
	sizeof (t)%sizeof (unsigned) >= 2 ? ((char *)(q1 + sizeof (t)/sizeof (unsigned)%8))[1] = 0 : 0; \
	sizeof (t)%sizeof (unsigned) >= 3 ? ((char *)(q1 + sizeof (t)/sizeof (unsigned)%8))[2] = 0 : 0; \
	}
typedef struct code *Code;
struct code {		/* code list entries: */
#ifdef __STDC__
	enum {
		Blockbeg, Blockend, Local, Address, Defpoint,
		Label, Start, Asm, Gen, Jump, Switch } kind;
#else
	int kind;
#define Blockbeg	0
#define Blockend	1
#define Local		2
#define Address		3
#define Defpoint	4
#define Label		5
#define Start		6
#define Asm		7
#define Gen		8
#define Jump		9
#define Switch		10
#endif
	Code prev;			/* previous code node */
	Code next;			/* next code node */
	union {
		struct {		/* Asm: assembly language */
			char *code;		/* assembly code */
			Symbol *argv;		/* %name arguments */
		} acode;
		struct {		/* Blockbeg: */
			Code prev;		/* previous Blockbeg */
			short bnumber;		/* block number */
			short level;		/* block level */
			Symbol *locals;		/* locals */
			Table identifiers, types;/* symbol tables; used for -g */
			Env x;			/* value filled in by blockbeg() */
		} block;
		Symbol var;		/* Local: local variable */
		struct {		/* Address: */
			Symbol sym;		/* created symbol */
			Symbol base;		/* local or parameter */
			int offset;		/* offset from sym */
		} addr;
		struct {		/* Defpoint: execution point */
			Coordinate src;		/* source location */
			int point;		/* execution point number */
		} point;
		Node node;		/* Label, Gen, Jump: a dag node */
		struct swselect {	/* Switch: swselect data */
			Symbol sym;		/* temporary holding value */
			Symbol table;		/* branch table */
			Symbol deflab;		/* default label */
			int size;		/* size of value & label arrays */
			int *values;		/* value, label pairs */
			Symbol *labels;
		} swtch;
	} u;
};
struct tynode {		/* type nodes: */
	Typeop op;		/* operator */
	short align;		/* alignment in storage units */
	int size;		/* size in storage units */
	Type type;		/* operand */
	union {
		Symbol sym;		/* associated symbol */
		Type *proto;		/* function prototype */
		Generic ptr;
	} u;
	Xtype x;		/* symbol table information */
#ifdef Ytype
	Ytype y;
#endif
};
struct field {		/* struct/union fields: */
	char *name;		/* field name */
	Type type;		/* data type */
	int offset;		/* field offset */
	short from, to;		/* bit fields: bits from..to */
	Field link;		/* next field in this type */
};
#define fieldsize(p) ((p)->to - (p)->from)
#ifdef LITTLE_ENDIAN
#define fieldright(p) (p)->from
#else
#define fieldright(p) (8*(p)->type->size - (p)->to)
#endif
#define fieldmask(p) (~(~(unsigned)0<<fieldsize(p)))
#define fieldleft(p) (8*(p)->type->size - fieldsize(p) - fieldright(p))
/*
 * type-checking macros.
 * the operator codes are defined in token.h
 * to permit the range tests below; don't change them.
 */
#define isqual(t)	((t)->op >= CONST)
#define isvolatile(t)	((t)->op == VOLATILE || (t)->op == CONST+VOLATILE)
#define isconst(t)	((t)->op == CONST    || (t)->op == CONST+VOLATILE)
#define unqual(t)	(isqual(t) ? (t)->type : t)
#define	isarray(t)	(unqual(t)->op == ARRAY)
#define	isstruct(t)	(unqual(t)->op == STRUCT || unqual(t)->op == UNION)
#define isunion(t)	(unqual(t)->op == UNION)
#define	isfunc(t)	(unqual(t)->op == FUNCTION)
#define	isptr(t)	(unqual(t)->op == POINTER)
#define ischar(t)	(unqual(t)->op == CHAR)
#define isint(t)	(unqual(t)->op >= CHAR && unqual(t)->op <= UNSIGNED)
#define isfloat(t)	(unqual(t)->op <= DOUBLE)
#define isarith(t)	(unqual(t)->op <= UNSIGNED)
#define isunsigned(t)	(unqual(t)->op == UNSIGNED)
#define isdouble(t)	(unqual(t)->op == DOUBLE)
#define isscalar(t)	(unqual(t)->op <= POINTER || unqual(t)->op == ENUM)
#define isenum(t)	(unqual(t)->op == ENUM)
#define widen(t)	(isint(t) || isenum(t) ? INT : ttob(t))
dclproto(extern void addlocal,(Symbol));
dclproto(extern Code code,(int));
/*G*/dclproto(extern void emitcode,(void));
/*G*/dclproto(extern void gencode,(Symbol [], Symbol []));
dclproto(extern Node listnodes,(Tree, int, int));
dclproto(extern Node jump,(int));
/*G*/dclproto(extern Node newnode,(int, Node, Node, Symbol));
dclproto(extern Node node,(int, Node, Node, Symbol));
dclproto(extern void printdag,(Node, int));
dclproto(extern void walk,(Tree, int, int));
extern struct code codehead;
extern Code codelist;
extern int nodecount;
dclproto(extern void compound,(int, Swtch, int));
dclproto(extern void finalize,(void));
dclproto(extern void program,(void));
dclproto(extern Type typename,(void));
extern Symbol cfunc;
extern char *fname;
extern Symbol retv;
dclproto(extern int genconst,(Tree, int));
dclproto(extern int hascall,(Tree));
dclproto(extern int nodeid,(Tree));
dclproto(extern char *opname,(int));
dclproto(extern int *printed,(int));
dclproto(extern void printtree,(Tree, int));
dclproto(extern Tree retype,(Tree, Type));
dclproto(extern Tree root,(Tree));
dclproto(extern Tree texpr,(Tree (*)(int), int));
dclproto(extern void tfree,(void));
dclproto(extern Tree tree,(int, Type, Tree, Tree));
extern int ntree;
dclproto(extern Tree addrof,(Tree));
dclproto(extern Tree asgn,(Symbol, Tree));
dclproto(extern Type assign,(Type, Tree));
dclproto(extern Tree cast,(Tree, Type));
dclproto(extern Tree cond,(Tree));
dclproto(extern Tree conditional,(int));
dclproto(extern Tree constexpr,(int));
dclproto(extern Tree expr0,(int));
dclproto(extern Tree expr,(int));
dclproto(extern Tree expr1,(int));
dclproto(extern Tree field,(Tree, char *));
dclproto(extern char *funcname,(Tree));
dclproto(extern Tree idnode,(Symbol));
dclproto(extern Tree incr,(int, Tree, Tree));
dclproto(extern int intexpr,(int, int));
dclproto(extern Tree lvalue,(Tree));
dclproto(extern Tree pointer,(Tree));
dclproto(extern Type promote,(Type));
dclproto(extern Tree right,(Tree, Tree));
dclproto(extern Tree rvalue,(Tree));
dclproto(extern Tree cvtconst,(Tree));
dclproto(extern void defglobal,(Symbol, int));
dclproto(extern void defpointer,(Symbol));
dclproto(extern void doconst,(Symbol, Generic));
dclproto(extern void initglobal,(Symbol, int));
dclproto(extern Type initializer,(Type, int));
dclproto(extern Tree structexp,(Type, Symbol));
dclproto(extern void swtoseg,(int));
dclproto(extern void inputInit,(int));
dclproto(extern void inputstring,(char *));
dclproto(extern void fillbuf,(void));
dclproto(extern void nextline,(void));
extern unsigned char *cp;
extern char *file;
extern char *firstfile;
extern unsigned char *limit;
extern char *line;
extern int lineno;
dclproto(extern int getchr,(void));
dclproto(extern int gettok,(void));
extern char kind[];
extern Coordinate src;
#ifdef __STDC__
extern enum tokencode t;
#else
extern int t;
#endif
extern char *token;
extern Symbol tsym;
dclproto(extern int main,(int, char **));
dclproto(extern Symbol mkstr,(char *));
dclproto(extern Symbol mksymbol,(int, char *,Type));
extern int Aflag;
extern int Pflag;
extern Symbol YYnull;
/*G*/extern int glevel;
extern int xref;
dclproto(void bbinit,(char *));
extern int ncalled;
extern int npoints;
dclproto(void traceinit,(char *));
typedef struct {
	List entry;
	List exit;
	List returns;
	List points;
	List calls;
	List end;
} Events;
extern Events events;
dclproto(typedef void (*Apply),(Generic, Generic, Generic));
dclproto(extern void attach,(Apply, Generic, List *));
dclproto(extern void apply,(List, Generic, Generic));
/*G*/dclproto(extern void fprint,(int, char *, ...));
/*G*/dclproto(extern void print,(char *, ...));
/*G*/dclproto(extern char *stringf,(char *, ...));
/*G*/dclproto(extern void outflush,(void));
/*G*/dclproto(extern void outs,(char *));
dclproto(extern void vfprint,(int, char *, va_list));
dclproto(extern void vprint,(char *, va_list));
/*G*/extern char *bp;
dclproto(extern void error,(char *, ...));
/*G*/dclproto(extern int fatal,(char *, char *, int));
dclproto(extern void warning,(char *, ...));
dclproto(extern int expect,(int));
dclproto(extern void skipto,(int, char *));
dclproto(extern void test,(int, char *));
extern int errcnt;
extern int errlimit;
extern int wflag;
dclproto(extern int process,(char *));
dclproto(extern int findfunc,(char *, char *));
dclproto(extern int findcount,(char *, int, int));
dclproto(extern Tree asgnnode,(int, Tree, Tree));
dclproto(extern Tree bitnode,(int, Tree, Tree));
dclproto(extern Tree callnode,(Tree, Type, Tree));
dclproto(extern Tree condnode,(Tree, Tree, Tree));
dclproto(extern Tree constnode,(unsigned int, Type));
dclproto(extern Tree eqnode,(int, Tree, Tree));
dclproto(extern Tree shnode,(int, Tree, Tree));
dclproto(extern void typeerror,(int, Tree, Tree));
dclproto(extern Tree (*opnode[]),(int, Tree, Tree));
dclproto(extern Tree simplify,(int, Type, Tree, Tree));
dclproto(extern int ispow2,(unsigned u));
dclproto(extern char *vtoa,(Type, Value));
extern int needconst;
dclproto(extern void definelab,(int));
dclproto(extern Code definept,(Coordinate *));
dclproto(extern void equatelab,(Symbol, Symbol));
dclproto(extern void flushequ,(void));
dclproto(extern void retcode,(Tree, int));
dclproto(extern void statement,(int, Swtch, int));
extern float density;
extern int refinc;
/*G*/dclproto(extern char *allocate,(int, Arena *));
dclproto(extern void deallocate,(Arena *));
/*G*/extern Arena permanent;
/*G*/extern Arena transient;
dclproto(extern List append,(Generic, List));
dclproto(extern int length,(List));
dclproto(extern Generic *list_to_a,(List, Generic []));
/*G*/dclproto(extern char *string,(char *));
/*G*/dclproto(extern char *stringd,(int));
dclproto(extern char *stringn,(char *, int));
dclproto(extern Symbol constant,(Type, Value));
dclproto(extern void enterscope,(void));
dclproto(extern void exitscope,(void));
dclproto(extern void fielduses,(Symbol, Generic));
dclproto(extern Symbol findlabel,(int));
dclproto(extern Symbol findtype,(Type));
/*G*/dclproto(extern void foreach,(Table, int, void (*)(Symbol, Generic), Generic));
dclproto(extern Symbol genident,(int, Type, int));
/*G*/dclproto(extern int genlabel,(int));
dclproto(extern Symbol install,(char *, Table *, int));
dclproto(extern Symbol intconst,(int));
dclproto(extern void locus,(Table, Coordinate *));
dclproto(extern Symbol lookup,(char *, Table));
/*G*/dclproto(extern Symbol newconst,(Value, int));
/*G*/dclproto(extern Symbol newtemp,(int, int));
dclproto(extern void rmtemps,(int, int));
dclproto(extern void release,(Symbol));
dclproto(extern void setuses,(Table));
dclproto(extern Table table,(Table, int));
dclproto(extern Symbol temporary,(int, Type));
dclproto(extern void use,(Symbol, Coordinate));
extern int bnumber;
extern Table constants;
extern Table externals;
extern Table globals;
extern Table identifiers;
extern Table labels[2];
/*G*/extern Table types;
extern int level;
extern List symbols;
dclproto(extern void typeInit,(void));
dclproto(extern Type array,(Type, int, int));
dclproto(extern Type atop,(Type));
dclproto(extern void checkfields,(Type));
dclproto(extern Type composite,(Type, Type));
dclproto(extern Symbol deftype,(char *, Type, Coordinate *));
dclproto(extern Type deref,(Type));
dclproto(extern int eqtype,(Type, Type, int));
dclproto(extern Field extends,(Type, Type));
/*G*/dclproto(extern Field fieldlist,(Type));
dclproto(extern Field fieldref,(char *, Type));
/*G*/dclproto(extern Type freturn,(Type));
dclproto(extern Type func,(Type, Type *));
dclproto(extern int hasproto,(Type));
dclproto(extern Field newfield,(char *, Type, Type));
dclproto(extern Type newstruct,(int, char *));
dclproto(extern void outtype,(Type));
dclproto(extern void printdecl,(Symbol, Type));
dclproto(extern void printproto,(Symbol, Symbol *));
dclproto(extern void printtype,(Type, int));
dclproto(extern Type ptr,(Type));
dclproto(extern Type qual,(int, Type));
dclproto(extern void rmtypes,(void));
/*G*/dclproto(extern int ttob,(Type));
dclproto(extern char *typestring,(Type, char *));
/*G*/dclproto(extern int variadic,(Type));
/*G*/extern Type chartype;
extern Type doubletype;
extern Type floattype;
/*G*/extern Type inttype;
extern Type longdouble;
extern Type longtype;
extern Type shorttype;
extern Type signedchar;
/*G*/extern Type unsignedchar;
extern Type unsignedlong;
/*G*/extern Type unsignedshort;
extern Type unsignedtype;
extern Type voidptype;
extern Type voidtype;
