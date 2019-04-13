/* C compiler: configuration parameters for 6502 generator */

#define R6502

/* type metrics: size,alignment,constants */
#define CHAR_METRICS     1,1,0
#define SHORT_METRICS    1,1,0
#define INT_METRICS      2,1,0
#define FLOAT_METRICS    5,1,1
#define DOUBLE_METRICS   5,1,1
#define POINTER_METRICS  2,1,0
#define STRUCT_ALIGN     1

#define LEFT_TO_RIGHT	 /* evaluate args left-to-right */
#define LITTLE_ENDIAN	 /* right-to-left bit fields */
#define JUMP_ON_RETURN	0

typedef struct {
	int offset;	/* max offset of locals in current sub-block */
} Env;

enum symboltype { UNKNOWN, GLOBALVAR, LOCALVAR, TEMPORARY, PARAMETER, ARGBUILD};

typedef struct {
	char	*name;		/* node's result external representation */
	char	adrmode;	/* addressing mode of the result */
	Symbol	result;		/* operator's result */
	int		argoffset;	/* offset pour ARG et CALL */
    unsigned int busy;  /* busy state for CALL */
	Node	next;		/* next node on linearized list */
	char	optimized;
	char	visited;
} Xnode;

typedef struct {
	char	*name;			/* name for back end */
	char	adrmode;		/* addressing mode */
} Xsymbol;

#define stabblock(a,b,c)
#define stabend(a,b,c,d,e)
#define stabfend(a,b)
#define stabinit(a,b,c)
#define stabline(a)
#define stabsym(a)
#define stabtype(a)
