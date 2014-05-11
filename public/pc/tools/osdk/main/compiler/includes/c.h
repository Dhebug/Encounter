/* C compiler: definitions */
#ifdef POSIX
#include <unistd.h>
#endif

/* default sizes */
#define MAXLINE   512		/* maximum output line length */
#define MAXTOKEN   32		/* maximum token length */
#define	BUFSIZE	 4096		/* input buffer size */
#define HASHSIZE  128		/* default hash table size */
#define MEMINCR    10		/* blocks (1kb) allocated per arena */


#include "ops.h"

#include <stdio.h>
#include <stdarg.h>
#include <string.h>

#define va_init va_start

typedef enum tokencode {
#define xx(a,b,c,d,e,f,g) a=b,
#define yy(a,b,c,d,e,f,g)
#include "token.h"
	NTOKENS
} Typeop;			/* type operators are a subset of tokens */

#define dclproto(func,args) func args
typedef void *Generic;

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

typedef union value
{	/* constant values: */
	char sc;		/* signed */
	short ss;		/* signed */
	int i;			/* signed */
	unsigned char uc;
	unsigned short us;
	unsigned int u;
	float f;
	double d;
	char *p;		/* pointer to anything */
} Value;

typedef struct coord {	/* source coordinates: */
	char *file;		/* file name */
	unsigned short x, y;	/* x,y position in file */
} Coordinate;

void address(Symbol, Symbol, int);
void asmcode(char *, Symbol []);
void defaddress(Symbol);
void defconst(int, Value);
void defstring(int, char *);
void defsymbol(Symbol);
void emit(Node);
void export(Symbol);
void function(Symbol, Symbol [], Symbol [], int);
Node gen(Node);
void global(Symbol);
void import(Symbol);
void local(Symbol);
void progbeg(int, char **);
void progend(void);
void segment(int);
void space(int);
/* symbol table */
void stabblock(int, int, Symbol*);
void stabend(Coordinate *, Symbol, Coordinate **, Symbol *, Symbol *);
void stabfend(Symbol, int);
void stabinit(char *, int, char *[]);
void stabline(Coordinate *);
void stabsym(Symbol);
void stabtype(Symbol);

#include "config.h"
#ifndef MAXKIDS
#define MAXKIDS 2
#endif
#ifndef MAXSYMS
#define MAXSYMS 3
#endif
#ifndef blockbeg
void blockbeg(Env *);
#endif
#ifndef blockend
void blockend(Env *);
#endif
#ifndef JUMP_ON_RETURN
#define JUMP_ON_RETURN 0
#endif

/* limits */
#ifdef __LCC__
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
#define USHRT_MAX	0xffff
#define UINT_MAX	0xffffffff
#define ULONG_MAX	0xffffffffL

#define CHAR_MAX	SCHAR_MAX
#define SCHAR_MAX	0x7f
#define SHRT_MAX	0x7fff
#define INT_MAX		0x7fffffff
#define LONG_MAX	0x7fffffffL

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

enum { CODE=1, BSS, DATA, LIT, SYM };	/* logical segments */
enum { CONSTANTS=1, LABELS, GLOBAL, PARAM, LOCAL };


/* misc. macros */
#define roundup(x,n) (((x)+((n)-1))&(~((n)-1)))
#define utod(x)	(2.*(int)((unsigned)(x)>>1)+(int)((x)&1))
#ifdef NDEBUG
#define assert(c)
#else
#define assert(c) ((c) || fatal(__FILE__,"assertion failure at line %d\n",\
	__LINE__))
#endif

#ifndef strtod
dclproto(extern double strtod,(char *, char **));
#endif


/* C library */
#ifndef _POSIX_VERSION
int atoi(char *);
int close(int);
int creat(char *, int);
void exit(int);
Generic malloc(unsigned);
int read(int, char *, int);
int open(char *, int);
long strtol(char *, char **, int);
int sprintf(char *, const char *, ...);
char *strchr(const char *, int);
int strcmp(const char *, const char *);
unsigned strlen(const char *);
//char *strncmp(const char *, const char *, unsigned);
//char *strncpy(char *, const char *, unsigned);
int write(int, char *, int);
#else
#define _strdup strdup
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

	enum {
		Blockbeg, Blockend, Local, Address, Defpoint,
		Label, Start, Asm, Gen, Jump, Switch } kind;

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


void addlocal(Symbol);
Code code(int);
void emitcode(void);
void gencode(Symbol [], Symbol []);
Node listnodes(Tree, int, int);
Node jump(int);
Node newnode(int, Node, Node, Symbol);
Node node(int, Node, Node, Symbol);
void printdag(Node, int);
void walk(Tree, int, int);
extern struct code codehead;
extern Code codelist;
extern int nodecount;
void compound(int, Swtch, int);
void finalize(void);
void program(void);
Type typename(void);
extern Symbol cfunc;
extern char *fname;
extern Symbol retv;
int genconst(Tree, int);
int hascall(Tree);
int nodeid(Tree);
char *opname(int);
int *printed(int);
void printtree(Tree, int);
Tree retype(Tree, Type);
Tree root(Tree);
Tree texpr(Tree (*)(int), int);
void tfree(void);
Tree tree(int, Type, Tree, Tree);
extern int ntree;
Tree addrof(Tree);
Tree asgn(Symbol, Tree);
Type assign(Type, Tree);
Tree cast(Tree, Type);
Tree cond(Tree);
Tree conditional(int);
Tree constexpr(int);
Tree expr0(int);
Tree expr(int);
Tree expr1(int);
Tree field(Tree, char *);
char *funcname(Tree);
Tree idnode(Symbol);
Tree incr(int, Tree, Tree);
int intexpr(int, int);
Tree lvalue(Tree);
Tree pointer(Tree);
Type promote(Type);
Tree right(Tree, Tree);
Tree rvalue(Tree);
Tree cvtconst(Tree);
void defglobal(Symbol, int);
void defpointer(Symbol);
void doconst(Symbol, Generic);
void initglobal(Symbol, int);
Type initializer(Type, int);
Tree structexp(Type, Symbol);
void swtoseg(int);
void inputInit(int);
void inputstring(char *);
void fillbuf(void);
void nextline(void);
extern unsigned char *cp;
extern char *file;
extern char *firstfile;
extern unsigned char *limit;
extern char *line;
extern int lineno;
int getchr(void);
int gettok(void);
extern char kind[];
extern Coordinate src;
extern enum tokencode t;
extern char *token;
extern Symbol tsym;
int main(int, char **);
Symbol mkstr(char *);
Symbol mksymbol(int, char *,Type);
extern int Aflag;
extern int Pflag;
extern Symbol YYnull;
extern int glevel;
extern int xref;
void bbinit(char *);
extern int ncalled;
extern int npoints;
void traceinit(char *);

typedef struct
{
	List entry;
	List exit;
	List returns;
	List points;
	List calls;
	List end;
} Events;

extern Events events;
typedef void (*Apply)(Generic, Generic, Generic);
void attach(Apply, Generic, List *);
void apply(List, Generic, Generic);
void fprint(int, char *, ...);
void print(char *, ...);

char *stringf(char *, ...);


void outflush(void);
void outs(char *);
void vfprint(int, char *, va_list);
void vprint(char *, va_list);
extern char *bp;
void error(char *, ...);
int fatal(char *, char *, int);
void warning(char *, ...);
int expect(int);
void skipto(int, char *);
void test(int, char *);
extern int errcnt;
extern int errlimit;
extern int wflag;
int process(char *);
int findfunc(char *, char *);
int findcount(char *, int, int);
Tree asgnnode(int, Tree, Tree);
Tree bitnode(int, Tree, Tree);
Tree callnode(Tree, Type, Tree);
Tree condnode(Tree, Tree, Tree);
Tree constnode(unsigned int, Type);
Tree eqnode(int, Tree, Tree);
Tree shnode(int, Tree, Tree);
void typeerror(int, Tree, Tree);
Tree (*opnode[])(int, Tree, Tree);
Tree simplify(int, Type, Tree, Tree);
int ispow2(unsigned u);
char *vtoa(Type, Value);
extern int needconst;
void definelab(int);
Code definept(Coordinate *);
void equatelab(Symbol, Symbol);
void flushequ(void);
void retcode(Tree, int);
void statement(int, Swtch, int);
extern float density;
extern int refinc;
char *allocate(int, Arena *);
void deallocate(Arena *);
extern Arena permanent;
extern Arena transient;
List append(Generic, List);
int length(List);
Generic *ltoa(List, Generic []);
char *string(char *);
char *stringd(int);
char *stringn(char *, int);
Symbol constant(Type, Value);
void enterscope(void);
void exitscope(void);
void fielduses(Symbol, Generic);
Symbol findlabel(int);
Symbol findtype(Type);
void foreach(Table, int, void (*)(Symbol, Generic), Generic);
Symbol genident(int, Type, int);
int genlabel(int);
Symbol install(char *, Table *, int);
Symbol intconst(int);
void locus(Table, Coordinate *);
Symbol lookup(char *, Table);
Symbol newconst(Value v,int tc);
Symbol newtemp(int, int);
void rmtemps(int, int);
void release(Symbol);
void setuses(Table);
Table table(Table, int);
Symbol temporary(int, Type);
void use(Symbol, Coordinate);
extern int bnumber;
extern Table constants;
extern Table externals;
extern Table globals;
extern Table identifiers;
extern Table labels[2];
extern Table types;
extern int level;
extern List symbols;
void typeInit(void);
Type array(Type, int, int);
Type atop(Type);
void checkfields(Type);
Type composite(Type, Type);
Symbol deftype(char *, Type, Coordinate *);
Type deref(Type);
int eqtype(Type, Type, int);
Field extends(Type, Type);
Field fieldlist(Type);
Field fieldref(char *, Type);
Type freturn(Type);
Type func(Type, Type *);
int hasproto(Type);
Field newfield(char *, Type, Type);
Type newstruct(int, char *);
void outtype(Type);
void printdecl(Symbol, Type);
void printproto(Symbol, Symbol *);
void printtype(Type, int);
Type ptr(Type);
Type qual(int, Type);
void rmtypes(void);
int ttob(Type);
char *typestring(Type, char *);
int variadic(Type);
extern Type chartype;
extern Type doubletype;
extern Type floattype;
extern Type inttype;
extern Type longdouble;
extern Type longtype;
extern Type shorttype;
extern Type signedchar;
extern Type unsignedchar;
extern Type unsignedlong;
extern Type unsignedshort;
extern Type unsignedtype;
extern Type voidptype;
extern Type voidtype;
