/* C compiler: 16 bits 6502 code generator */
/* (C) Fabrice Frances 1997-2019 */
/*
 * Implementation notes:
 *
 * The general structure of this backend follows the interfacing guidelines of
 * Hanson & Fraser's Retargetable C Compiler : a number of specified functions
 * have to be implemented by every backend, and the frontend and backend
 * communicate information through a few structures (most important ones being
 * the symbol structure and the node structure).
 *
 * Each backend defines specific extensions of these symbol and node structures
 * in config.h (Xnode and Xsymbol), along with type metrics and a few other
 * parameters.
 *
 * This 6502 backend aims to be kept as simple as possible by introducing an
 * intermediate language of macros, so that most of the time, there's a one to
 * one correspondence between the Operator Nodes passed by the frontend and
 * the macros emitted by the backend. However, lcc's frontend was designed
 * for working straight forward with backends for RISC processors with
 * a load/store architecture and many registers so that operations only take
 * registers operand. The 6502 instead has a single register that can be used
 * in operations whilst the second operand is in memory. So, I designed this
 * 6502 backend to use pseudo-registers in zero-page (this seems natural),
 * but also to propagate addressing-mode information in order to exploit
 * some 6502 addressing modes. This way it becomes possible to optimize the
 * generated code by combining the load/store operations provided by the
 * frontend with the operations on pseudo-registers and/or memory.
 */


char *version="/* 16-bit code V1.35 */\n";
#include "c.h"
#include <string.h>
#include <stdio.h>
#ifdef _MSC_VER
// http://gel.sourceforge.net/examples/stdbool_8h-source.php
#define false   0
#define true    1
#define bool    _Bool
typedef int     _Bool;
#else
#include <stdbool.h>   // Not available on VS2010
#endif
extern void exit(int);

static bool graph_output;    /* output forest of dags from frontend */
static int localsize;        /* max size of locals */
static int argoffset;        /* current stack position */
static int offset;           /* current local size */
static int tmpsize;          /* max size of temporary variables */
static int nbregs;           /* number of used registers */
static unsigned busy;        /* busy&(1<<t) == 1 if tmp t is used */
static unsigned busy_flt;    /* busy_flt&(1<<t) == 1 if tmp t is used */
static char *NamePrefix;     /* Prefix for all local names */
static int omit_frame;       /* if no params and no locals */
static int optimizelevel=3;  /* set by command line option -On */
static Symbol temp[32];      /* 32 symbols pointing to temporary variables... */
static Symbol flt_temp[32];  /* 32 symbols pointing to temporary floating-point variables... */
static char *regname[8];     /* 8 register variables names */

static char *opcode_names[] = {
    NULL,"CNST","ARG","ASGN","INDIR","CVC","CVD","CVF","CVI","CVP",
    "CVS","CVU","NEG","CALL","LOAD","RET","ADDRG","ADDRF","ADDRL","ADD",
    "SUB","LSH","MOD","RSH","BAND","BCOM","BOR","BXOR","DIV","MUL",
    "EQ","GE","GT","LE","LT","NE","JUMP","LABEL","MAXOP" };
static char type_name[] = " FDCSIUPVB??????";
static char *additional_operators[] = {
    "AND","NOT","OR","COND","RIGHT","FIELD" };

void print_node(Node p) {
    fprintf(stderr,"Node %s%c\n",
            opcode_names[generic(p->op)>>4], type_name[optype(p->op)]);
    fprintf(stderr,"Node addr: %p\n", p);
    fprintf(stderr,"  optimized: %d\n", p->x.optimized);
    fprintf(stderr,"  referenced: %d\n", p->count);
    fprintf(stderr,"  Operator = %d\n", p->op);
    fprintf(stderr,"  link to next dag:  %p\n", p->link);
    fprintf(stderr,"  next on linearized list: %p\n", p->x.next);
    fprintf(stderr,"  syms[0]: %p\n", p->syms[0]);
    fprintf(stderr,"  syms[1]: %p\n", p->syms[1]);
    fprintf(stderr,"  kids[0]: %p\n", p->kids[0]);
    fprintf(stderr,"  kids[1]: %p\n", p->kids[1]);
    fprintf(stderr,"  result: %p\n",  p->x.result);
    fprintf(stderr,"  adrmode: %c\n", p->x.adrmode);
    fprintf(stderr,"  name: %s\n",    p->x.name);
}

static void print_graph_node(Node p) {
    Symbol s;
    Node left, right;
    if (p == NULL) return;
    s     = p->syms[0];
    left  = p->kids[0];
    right = p->kids[1];

    if (p->op < MAXOP)
        printf("\t%s%p [label=\"%s%c\"];\n", fname, p,
            opcode_names[generic(p->op)>>4], type_name[optype(p->op)]);
    else printf("\t%s%p [label=\"%s\"];\n", fname, p,
            additional_operators[p->op - MAXOP]);

    switch (generic(p->op)) {
    case ADDRF: case ADDRG: case ADDRL: case CNST: case LABEL:
        /* 1 symbol */
        printf("\t%s%p [shape=box,label=\"%s\"];\n",fname,s,s->x.name);
        printf("\t%s%p -> %s%p [style=dotted];\n",fname,p,fname,s);
        break;

    case EQ: case GE: case GT: case LE: case LT: case NE:
        /* 1 symbol, 2 kids */
        printf("\tN%p [shape=box,label=\"%s\"];\n",s,s->x.name);
        printf("\t%s%p -> N%p [style=dotted,label=\"label\"];\n",fname,p,s);

    case ASGN:
    case ADD: case SUB: case BAND: case BOR: case BXOR:
    case DIV: case LSH: case MOD: case MUL: case RSH:
        /* 2 kids */
        printf("\t%s%p -> %s%p [label=\"left\"];\n",fname,p,fname,left);
        printf("\t%s%p -> %s%p;\n",fname,p,fname,right);
        break;

    case BCOM:
    case CVC: case CVD: case CVF: case CVI: case CVP: case CVS: case CVU:
    case INDIR: case NEG:
    case JUMP:
    case ARG:
        /* 1 kid */
        printf("\t%s%p -> %s%p;\n",fname,p,fname,left);
        break;

    case RET:
        /* 0 or 1 kid */
        if (optype(p->op) != V)
            printf("\t%s%p -> %s%p;\n",fname,p,fname,left);
        break;

    case CALL:
        /* 1 or 2 kids */
        printf("\t%s%p -> %s%p;\n", fname,p,fname,left);
        if (optype(p->op) == B)
            printf("\t%s%p -> %s%p [label=\"res\"];\n",fname,p,fname,right);
        break;
    }
}

static Node *linearize(Node p, Node *last, Node next) {
    if (p && !p->x.visited) {
        if ( optimizelevel>0 ) {
            switch (generic(p->op)) {
            case CNST:
            case ADDRG: case ADDRL: case ADDRF:
                p->x.optimized=1;
                p->x.result=p->syms[0];
                p->x.adrmode=p->syms[0]->x.adrmode;
                p->x.name=p->syms[0]->x.name;
                return last;
            }
        }
        last = linearize(p->kids[0], last, NULL);
        last = linearize(p->kids[1], last, NULL);
        p->x.visited = 1;
        *last = p;
        last = &p->x.next;
    }
    *last = next;
    return last;
}

void progbeg(int argc,char *argv[]) {
    int i;
    for(i=1;i<argc;i++) {
        if (strncmp(argv[i],"-N",2)==0) {
            NamePrefix=argv[i]+2;
        } else if (strcmp(argv[i],"-G")==0) {
            graph_output=true;
        } else if (strcmp(argv[i],"-O")==0) {
            optimizelevel=3;
        } else if (strcmp(argv[i],"-O0")==0) {
            optimizelevel=0;    /* no optimization */
        } else if (strcmp(argv[i],"-O1")==0) {
            optimizelevel=1;    /* remove ADDR and CNST leaves */
        } else if (strcmp(argv[i],"-O2")==0) {
            optimizelevel=2;    /* allocate register variables */
                                /* and do some easy opt. (INC...) */
        } else if (strcmp(argv[i],"-O3")==0) {
            optimizelevel=3;    /* optimizes INDIR, ASGN ... */
        } else {
            fprintf(stderr,"Unknown option %s\n",argv[i]);
            exit(1);
        }
    }
    if (graph_output) optimizelevel=0;
    if (graph_output) printf("digraph Frontend_output {\n");
    else print(version);

    /* 8 virtual registers */
    for (i=0;i<8;i++) regname[i]=stringf("reg%d",i);

    /* No spilling for simplicity purpose:
     * 32 temporaries for integer/pointer expressions, 32 for float expresssions.
     * => it should be nearly impossible to have such a complex expression
     * that we run out of temporaries (a compilation error will be raised in such
     * a pathological case).
     * All 32 integer/pointer temporaries in page zero,
     * and all 32 floating-point temporaries on stack frame.
     * => the runtime has to declare enough temporaries in zero page,
     * previous versions only used tmp0-tmp7...
     */
    for (i=0;i<32;i++) {
        temp[i]     = newtemp(STATIC,I);
        flt_temp[i] = newtemp(STATIC,F);
    }
    for (i=0;i<32;i++) {
        temp[i]->x.name=stringf("tmp%d",i);
        temp[i]->x.adrmode='Z';
    }
}

void progend(void) {
    if (graph_output) printf("}\n");
}

static bool is_temporary(Symbol s) {
    int i;
    for (i=0;i<32;i++)
        if (s==temp[i]) return true;
    return false;
}

void defsymbol(Symbol p) {
    if (p->x.name) return;
    if (p->scope == CONSTANTS) {
        p->x.name = p->name;
        if (p->x.name[0]=='0' && p->x.name[1]=='x') {
            p->x.name[0]=' '; p->x.name[1]='$';
        }
    } else if (p->sclass == STATIC)
        p->x.name = stringf("L%s%d", NamePrefix, genlabel(1));
    else if (p->generated)
        p->x.name = stringf("L%s%s", NamePrefix, p->name);
    else
        p->x.name = stringf("_%s", p->name);
    p->x.adrmode = 'C';

}

void export(Symbol p) {}
void import(Symbol p) {}
void segment(int s) {}
void global(Symbol p) { if (!graph_output) print("%s\n", p->x.name); }

void printfloat(double val)
{
    int i,exp=32,negative=0;
    double two_pow31,two_pow32;
    unsigned long mantissa;

    if (val==0.0) {
        print("\tDB(0)\n");
        print("\tDB(0)\n");
        print("\tDB(0)\n");
        print("\tDB(0)\n");
        print("\tDB(0)\n");
        return;
    }
    if (val<0.0) { negative=1; val= -val; }
    for (two_pow31=1.0,i=0;i<31;i++) two_pow31*=2;
    two_pow32=two_pow31*2;
    while (val>=two_pow32) {
        val/=2;
        exp++;
    }
    while (val<two_pow31) {
        val*=2;
        exp--;
    }
    if (!negative) val-=two_pow31;
    mantissa=val;
    print("\tDB($%x)\n",exp+128);
    print("\tDB($%x)\n",(mantissa>>24)&0xFF);
    print("\tDB($%x)\n",(mantissa>>16)&0xFF);
    print("\tDB($%x)\n",(mantissa>>8)&0xFF);
    print("\tDB($%x)\n",mantissa&0xFF);
}


void defconst(int ty, Value v) {
    if (graph_output) return;
    switch (ty) {
    case C: print("\tDB(%d)\n",   v.uc); break;
    case S: print("\tDB(%d)\n",   v.us); break;
    case I: print("\tDW(%d)\n",   v.i ); break;
    case U: print("\tDW($%x)\n",  v.u ); break;
    case P: print("\tDW($%x)\n",  v.p ); break;
    case F: printfloat(v.f); break;
    case D: printfloat(v.d); break;
    default: assert(0);
    }
}

void defstring(int len, char *s) {
    if (graph_output) return;
    while (len > 0) {
        if (s[0]==';' || s[0]<32 || s[0]==127) {
            print("\tDB($%x)\n",(unsigned char)*s++);
            len--;
            while (len>0 && (s[0]==';' || s[0]<32 || s[0]==127)) {
                print("\tDB($%x)\n",(unsigned char)*s++);
                len--;
            }
            print("\n");
        } else {
            print("\tSTRING \"");
            while (len>0 && s[0]!=';' && s[0]>=32 && s[0]!=127) {
                len--;
                if (s[0]=='"') print("\\\"");
                else if (s[0]=='\\') print("\\\\");
                else print("%c",s[0]);
                s++;
            }
            print("\"\n");
        }
    }
}

void defaddress(Symbol p) {
    if (graph_output) return;
    print("\tDW(%s)\n",p->x.name);
}

void space(int n) {
    if (graph_output) return;
    print("\tZERO(%d)\n",n);
}

int allocreg(Symbol p) {
    if (nbregs==8 || p->type->size==5) return 0;
    p->x.name=regname[nbregs];
    p->x.adrmode='R';
    nbregs++;
    return 1;
}

void function(Symbol f, Symbol caller[], Symbol callee[], int ncalls) {
    int i;

    if (graph_output) {
        printf("subgraph cluster%s {\n", f->x.name);
        printf("\tlabel=\"%s\";\n",f->x.name);
    }
    localsize=offset=tmpsize=nbregs=0; fname=f->x.name;

    for (i=0;i<32;i++) flt_temp[i]->x.name="******";
    for (i=8;i<32;i++) temp[i]->x.name="******";

    for (i = 0; caller[i] && callee[i]; i++) {
        caller[i]->x.name=stringf(graph_output?"param(%d)":"(ap),%d",offset);
        caller[i]->x.adrmode='A';
        offset+=caller[i]->type->size;
        if (optimizelevel>1 && callee[i]->sclass==REGISTER && allocreg(callee[i]))
            ; /* allocreg ok */
        else {
            callee[i]->x.adrmode=caller[i]->x.adrmode;
            callee[i]->x.name=caller[i]->x.name;
            callee[i]->sclass=AUTO;
        }
    }
    busy=localsize=0; offset=6;
    gencode(caller,callee);

    omit_frame=(i==0 && localsize==6);
    if (!graph_output) {
        print("%s\n",fname);
        if (optimizelevel>1 && omit_frame && nbregs==0)
            ;
        else print("\tENTER(%d,%d)\n",nbregs,localsize);
        if (isstruct(freturn(f->type)))
            print("\tMOVW_DY(op1,(fp),6)\n");
    }
    emitcode();

    if (graph_output) printf("}\n");
}

void local(Symbol p) {
    if (optimizelevel>1 && p->sclass==REGISTER && allocreg(p))
        return; /* allocreg ok */
    if (p->x.name && p->x.name[0]!='*') return; /* keep previous local (it isn't busy) */
    p->x.name = stringf(graph_output?"local(%d)":"(fp),%d",offset);
    p->x.adrmode = 'A';
    p->sclass = AUTO;
    offset+=p->type->size;
}

void address(Symbol q, Symbol p, int n) {
    q->x.name = stringf("%s%s%d", p->x.name, n >= 0 ? "+" : "", n);
    q->x.adrmode=p->x.adrmode;
}

void blockbeg(Env *e) { e->offset = offset; }
void blockend(Env *e) {
    if (offset > localsize) localsize = offset;
    offset = e->offset;
}

static void gettmp(Node p) {
    int t;
    if ( optype(p->op)!=F && optype(p->op)!=D ) {
        for (t=0;t<32;t++)
            if ((busy&(1<<t))==0) {
                busy |= 1<<t;
                p->x.result=temp[t];
                p->x.adrmode='Z';

                p->x.name = temp[t]->x.name;
                return;
            }
    } else
        for (t=0;t<32;t++)
            if ((busy_flt&(1<<t))==0) {
                busy_flt |= 1<<t;
                p->x.result=flt_temp[t];
                p->x.adrmode='Y';
                local(flt_temp[t]);
                p->x.name = flt_temp[t]->x.name;
                return;
            }
    perror("Too complex expression"); exit(1);
}

static void releasetmp(Node p) {
    if (!p) return;
    assert(p->count!=0);
    p->count--;
    switch(generic(p->op)) {
        case ADDRG: case ADDRL: case ADDRF: case CNST:
            if (optimizelevel>0) return;
            break;
        case INDIR:
            if (p->x.optimized) return;
    }
    if (p->count==0) {
        int i;
        for (i=0;i<32;i++) {
            if (p->x.result == temp[i])   busy &= ~(1<<i);
            if (p->x.result==flt_temp[i]) busy_flt &= ~(1<<i);
        }
    }
}

void print_busy() {
    if (busy) fprintf(stderr,"Busy tmps when calling function: %x\n", busy);
    if (busy_flt) fprintf(stderr,"Busy flt_tmps when calling function: %x\n", busy_flt);
}

static bool is_dereferenceable(char adrmode)
{
    return adrmode=='C' || adrmode=='R' || adrmode=='A' || adrmode=='Z';
}

static char dereference(char adrmode)
{
    switch (adrmode) {
        case 'C': return 'D';
        case 'R': return 'Z';
        case 'A': return 'Y';
        case 'Z': return 'I';
        default:
            assert(is_dereferenceable(adrmode));
            return 0;
    }

}

static int needtmp(Node p) {
    Node left = p->kids[0];
    if (graph_output) return 0;
    switch (generic(p->op)) {
        case ADDRF: case ADDRG: case ADDRL:
        case CNST:
            assert(optimizelevel==0);
            return 1;
        case INDIR:
            if (optimizelevel!=0)
                if (optype(p->op)==B) { /* remove all INDIRB nodes */
                    p->x.optimized = 1;
                    p->x.result    = left->x.result;
                    p->x.name      = p->x.result->x.name;
                    p->x.adrmode   = left->x.adrmode;
                    return 0;
                }

            if (optimizelevel>=3) {
        /* these conditions must be true to optimize (=get rid of) an INDIR node:
         * - this INDIR node is referenced only once
         *   (otherwise by delaying the indirection in parent nodes we would duplicate it,
         *   and hence could have different behavior (TODO: example needed))
         * - the address mode of the INDIR operand is "de-referenceable"
         */
                if (p->count <= 1 && is_dereferenceable(left->x.adrmode)) {
                    p->x.optimized = 1;
                    p->x.result    = left->x.result;
                    p->x.name      = left->x.result->x.name;
                    p->x.adrmode   = dereference(left->x.adrmode);
                    return 0;
                }
            }
            return 1;
        case ASGN:
        case ARG:
        case EQ: case GE: case GT: case LE: case LT: case NE:
        case RET:
        case JUMP: case LABEL:
            return 0;
        case CALL:
            if (optype(p->op)==B) return 0;
            if (p->count==0) p->op=CALLV;
            if (optype(p->op)==V) return 0;
            else return 1;
        default:
            return 1;
    }
}

static void tmpalloc(Node p) {
    Node left = p->kids[0], right = p->kids[1];
    p->x.optimized=0;
    p->x.name="*******";
    p->x.adrmode='*';
    releasetmp(left); releasetmp(right);

    switch (generic(p->op)) {
    case ARG:
        p->x.argoffset = argoffset;
        argoffset += p->syms[0]->u.c.v.i;
        break;
    case CALL:
        p->x.argoffset = argoffset;
        p->x.busy      = busy;
        argoffset = 0;
        break;
    case ASGN:
        if (optimizelevel>=3) {
        /* these conditions must be true to optimize (=get rid of) an ASGN node:
         * - it gets its value (right child node) from a temporary variable,
         * - the right child child has not been eliminated (optimized)
         * - the ASGN node comes just after its right child node
         *   (TODO: could it be more general? => re-ordering ?)
         * - the left value is de-referenceable,
         * - and the temporary variable is not used afterwards,
         *
         * In this case, we try to directly assign the result inside the right child node
         * (as the result of this child node)
         */
            if (optype(p->op)!=B        // no optimization on ASGNB (struct) nodes
                && !right->x.optimized
                && p==right->x.next
                && is_temporary(right->x.result)
                && is_dereferenceable(left->x.adrmode)
                && right->count==0
                )
            {
                p->x.optimized     = 1;
                right->x.result    = left->x.result;
                right->x.name      = left->x.name;
                right->x.adrmode   = dereference(left->x.adrmode);
            }
        }
        break;
    }
    if (needtmp(p)) gettmp(p);
}

Node gen(Node p) {
    Node head, *last;
    for (last = &head; p; p = p->link)
        last = linearize(p, last, 0);
    for (p = head; p; p = p->x.next) {
        if (graph_output) print_graph_node(p);
        else tmpalloc(p);
    }
    return head;
}

void asmcode(char *str, Symbol argv[]) {
    for ( ; *str; str++)
        if (*str == '%' && str[1] >= 0 && str[1] <= 9)
            print("%s", argv[(int)*++str]->x.name);
        else
            print("%c", *str);
    print("\n");
}

static Node a,b,r;

/* avoid some proliferation of macros by rewriting
 * Zero-Page address mode as Direct address mode,
 * Register addresses as Constants,
 * and Indirect address mode as Indirect Y-indexed
 */
static char simple_adrmode(char adrmode) {
    if (adrmode=='Z') return 'D';
    else if (adrmode=='R') return 'C';
    else if (adrmode=='I') return 'Y';
    else return adrmode;
}
static char reduced_adrmode(char adrmode) {
    if (adrmode=='R') return 'C';
    else if (adrmode=='I') return 'Y';
    else return adrmode;
}
static char *output_name(Symbol s) {
    return s->x.adrmode=='I' ? stringf("(%s),0",s->x.name) : s->x.name;
}
static char *output_arg(Node n) {
    if (optimizelevel==0) return n->x.name;
    return n->x.adrmode=='I' ? stringf("(%s),0",n->x.name) : n->x.name;
}

static void binary(char *inst) {
    if (optimizelevel==0)
        print("\t%s(%s,%s,%s)\n"
            ,inst
            ,output_arg(a)
            ,output_arg(b)
            ,output_arg(r));
    else
        print("\t%s_%c%c%c(%s,%s,%s)\n"
            ,inst
            ,simple_adrmode(a->x.adrmode)
            ,simple_adrmode(b->x.adrmode)
            ,simple_adrmode(r->x.adrmode)
            ,output_arg(a)
            ,output_arg(b)
            ,output_arg(r));
}

static void unary(char *inst) {
    if (optimizelevel==0)
        print("\t%s(%s,%s)\n"
            ,inst
            ,output_arg(a)
            ,output_arg(r));
    else
        print("\t%s_%c%c(%s,%s)\n"
            ,inst
            ,simple_adrmode(a->x.adrmode)
            ,simple_adrmode(r->x.adrmode)
            ,output_arg(a)
            ,output_arg(r));
}

static void compare0(char *inst) {
    print("\t%s_%c(%s,%s)\n"
            ,inst
            ,simple_adrmode(a->x.adrmode)
            ,output_arg(a)
            ,r->syms[0]->x.name);
}

static void compare(char *inst) {
     if (optimizelevel==0)
        print("\t%s(%s,%s,%s)\n"
            ,inst
            ,output_arg(a)
            ,output_arg(b)
            ,r->syms[0]->x.name);
    else
        print("\t%s_%c%c(%s,%s,%s)\n"
            ,inst
            ,simple_adrmode(a->x.adrmode)
            ,simple_adrmode(b->x.adrmode)
            ,output_arg(a)
            ,output_arg(b)
            ,r->syms[0]->x.name);
}

static void save_busy(Node p) {
    int i, offset=p->x.argoffset;
    for (/*int*/ i=0; i<8; i++) {
        if (p->x.busy & (1<<i)) {
            // save on stack and increase the argsize
            print("\tSAVE(tmp%d,(sp),%d)\n", i, offset);
            offset += 2;
        }
    }
    // update the CALL's argoffset so that it is passed to the callee
    p->x.argoffset = offset;
}

static void restore_busy(Node p) {
    int i, offset=p->x.argoffset;
    for (/*int*/ i=7; i>=0; i--) { // reverse order
        if (p->x.busy & (1<<i)) {
            offset -= 2;
            print("\tRESTORE((sp),%d,tmp%d)\n", offset, i);
        }
    }
}

static void emitdag0(Node p) {
    a = p->kids[0]; b = p->kids[1]; r=p;
    switch (p->op) {
        case BANDU:  binary("BANDU");  break;
        case BORU:   binary("BORU" );  break;
        case BXORU:  binary("BXOR" );  break;
        case ADDD:   binary("ADDD");   break;
        case ADDF:   binary("ADDF");   break;
        case ADDI:   binary("ADDI");   break;
        case ADDP:   binary("ADDP");   break;
        case ADDU:   binary("ADDU");   break;
        case SUBD:   binary("SUBD");   break;
        case SUBF:   binary("SUBF");   break;
        case SUBI:   binary("SUBI");   break;
        case SUBP:   binary("SUBP");   break;
        case SUBU:   binary("SUBU");   break;
        case MULD:   binary("MULD");   break;
        case MULF:   binary("MULF");   break;
        case MULI:   binary("MULI");   break;
        case MULU:   binary("MULU");   break;
        case DIVD:   binary("DIVD");   break;
        case DIVF:   binary("DIVF");   break;
        case DIVI:   binary("DIVI");   break;
        case DIVU:   binary("DIVU");   break;
        case MODI:   binary("MODI");   break;
        case MODU:   binary("MODU");   break;
        case RSHU:   binary("RSHU");   break;
        case RSHI:   binary("RSHI");   break;
        case LSHI:   binary("LSHW");   break;
        case LSHU:   binary("LSHW");   break;
        case INDIRC: unary("INDIRC");  break;
        case INDIRS: unary("INDIRS");  break;
        case INDIRI: unary("INDIRI");  break;
        case INDIRP: unary("INDIRP");  break;
        case INDIRD: unary("INDIRD");  break;
        case INDIRF: unary("INDIRF");  break;
        case INDIRB: unary("INDIRB");  break;
        case BCOMU:  unary("BCOMU" );  break;
        case NEGD:   unary("NEGD" );   break;
        case NEGF:   unary("NEGF" );   break;
        case NEGI:   unary("NEGI" );   break;
        case CVCI:   unary("CVCI");    break;
        case CVSI:   unary("CVSI");    break;
        case CVCU:   unary("CVCU");    break;
        case CVSU:   unary("CVSU");    break;
        case CVUC:   unary("CVUC");    break;
        case CVUS:   unary("CVUS");    break;
        case CVIC:   unary("CVIC");    break;
        case CVIS:   unary("CVIS");    break;
        case CVPU:   unary("CVPU");    break;
        case CVUP:   unary("CVUP");    break;
        case CVIU:   unary("CVIU");    break;
        case CVUI:   unary("CVUI");    break;
        case CVID:   unary("CVID" );   break;
        case CVDF:   unary("CVDF");    break;
        case CVFD:   unary("CVFD");    break;
        case CVDI:   unary("CVDI" );   break;
        case RETD:   print("\tRETD(%s)\n",output_arg(a)); break;
        case RETF:   print("\tRETF(%s)\n",output_arg(a)); break;
        case RETI:   print("\tRETI(%s)\n",output_arg(a)); break;
        case RETV:   print("\tRETV\n"); break;
        case ADDRGP: print("\tADDRGP(%s,%s)\n"
                        ,p->syms[0]->x.name
                        ,output_arg(p)); break;
        case ADDRFP: print("\tADDRFP(%s,%s)\n"
                        ,p->syms[0]->x.name
                        ,output_arg(p)); break;
        case ADDRLP: print("\tADDRLP(%s,%s)\n"
                        ,p->syms[0]->x.name
                        ,output_arg(p)); break;
        case CNSTC: print("\tCNSTC(%s,%s)\n" ,output_name(p->syms[0]) ,output_arg(p)); break;
        case CNSTS: print("\tCNSTS(%s,%s)\n" ,output_name(p->syms[0]) ,output_arg(p)); break;
        case CNSTI: print("\tCNSTI(%s,%s)\n" ,output_name(p->syms[0]) ,output_arg(p)); break;
        case CNSTU: print("\tCNSTU(%s,%s)\n" ,output_name(p->syms[0]) ,output_arg(p)); break;
        case CNSTP: print("\tCNSTP(%s,%s)\n" ,output_name(p->syms[0]) ,output_arg(p)); break;
        case JUMPV: print("\tJUMPV(%s)\n" , output_arg(a)); break;
        case ASGNB: print("\tASGNB(%s,%s,%s)\n"
                    ,output_arg(b)
                    ,output_arg(a)
                    ,output_name(p->syms[0])); break;
        case ASGNC: print("\tASGNC(%s,%s)\n" ,output_arg(b) ,output_arg(a)); break;
        case ASGNS: print("\tASGNS(%s,%s)\n" ,output_arg(b) ,output_arg(a)); break;
        case ASGND: print("\tASGND(%s,%s)\n" ,output_arg(b) ,output_arg(a)); break;
        case ASGNF: print("\tASGNF(%s,%s)\n" ,output_arg(b) ,output_arg(a)); break;
        case ASGNI: print("\tASGNI(%s,%s)\n" ,output_arg(b) ,output_arg(a)); break;
        case ASGNP: print("\tASGNP(%s,%s)\n" ,output_arg(b) ,output_arg(a)); break;
        case ARGB:  print("\tARGB(%s,(sp),%d,%s)\n"
                    ,output_arg(a)
                    ,p->x.argoffset
                    ,output_name(p->syms[0])); break;
        case ARGD:  print("\tARGD(%s,%d)\n" ,output_arg(a) ,p->x.argoffset); break;
        case ARGF:  print("\tARGF(%s,%d)\n" ,output_arg(a) ,p->x.argoffset); break;
        case ARGI:  print("\tARGI(%s,%d)\n" ,output_arg(a) ,p->x.argoffset); break;
        case ARGP:  print("\tARGP(%s,%d)\n" ,output_arg(a) ,p->x.argoffset); break;
        case CALLB:
            save_busy(p);
            print("\tMOVW_%cD(%s,op1)\n"
                    ,simple_adrmode(b->x.adrmode)
                    ,output_arg(b));
            print("\tCALLV(%s,%d)\n"
                    ,output_arg(a)
                    ,p->x.argoffset);
            restore_busy(p);
            break;
        case CALLV:
            save_busy(p);
            print("\tCALLV(%s,%d)\n" ,output_arg(a) ,p->x.argoffset);
            restore_busy(p);
            break;
        case CALLD:
            save_busy(p);
            print("\tCALLD(%s,%d,%s)\n"
                    ,output_arg(a)
                    ,p->x.argoffset
                    ,output_arg(p));
            restore_busy(p);
            break;
        case CALLF:
            save_busy(p);
            print("\tCALLF(%s,%d,%s)\n"
                    ,output_arg(a)
                    ,p->x.argoffset
                    ,output_arg(p));
            restore_busy(p);
            break;
        case CALLI:
            save_busy(p);
            print("\tCALLI(%s,%d,%s)\n"
                    ,output_arg(a)
                    ,p->x.argoffset
                    ,output_arg(p));
            restore_busy(p);
            break;
        case EQD:     compare("EQD" ); break;
        case EQF:     compare("EQF" ); break;
        case EQI:     compare("EQI" ); break;
        case GED:     compare("GED" ); break;
        case GEF:     compare("GEF" ); break;
        case GEI:     compare("GEI" ); break;
        case GEU:     compare("GEU" ); break;
        case GTD:     compare("GTD" ); break;
        case GTF:     compare("GTF" ); break;
        case GTI:     compare("GTI" ); break;
        case GTU:     compare("GTU" ); break;
        case LED:     compare("LED" ); break;
        case LEF:     compare("LEF" ); break;
        case LEI:     compare("LEI" ); break;
        case LEU:     compare("LEU" ); break;
        case LTD:     compare("LTD" ); break;
        case LTF:     compare("LTF" ); break;
        case LTI:     compare("LTI" ); break;
        case LTU:     compare("LTU" ); break;
        case NED:     compare("NED" ); break;
        case NEF:     compare("NEF" ); break;
        case NEI:     compare("NEI" ); break;
        case LABELV: print("%s\n", p->syms[0]->x.name); break;
        default: assert(0);
    }
}

static void emitdag(Node p) {

    a = p->kids[0]; b = p->kids[1]; r=p;

    switch (p->op) {
        case BANDU:                       binary("ANDW");   break;
        case BORU:                        binary("ORW" );   break;
        case BXORU:                       binary("XORW");   break;
        case ADDD:  case ADDF:            binary("ADDF");   break;
        case ADDI:  case ADDP:  case ADDU:
            if (optimizelevel>=2
                    && strcmp(a->x.name,p->x.name)==0
                    && strcmp(b->x.name,"1")==0
                    && (p->x.adrmode=='Z' || p->x.adrmode=='D'))
                print("\tINCW_%c(%s)\n" ,simple_adrmode(p->x.adrmode) ,output_arg(p));
            else
                binary("ADDW");
            break;
        case SUBD:  case SUBF:            binary("SUBF");  break;
        case SUBI:  case SUBP:  case SUBU:
            if (optimizelevel>=2
                    && strcmp(a->x.name,p->x.name)==0
                    && strcmp(b->x.name,"1")==0
                    && (p->x.adrmode=='Z' || p->x.adrmode=='D'))
                print("\tDECW_%c(%s)\n" ,simple_adrmode(p->x.adrmode) ,output_arg(p));
            else
                binary("SUBW");
            break;
        case MULD:  case MULF:            binary("MULF");   break;
        case MULI:                        binary("MULI");   break;
        case MULU:                        binary("MULU");   break;
        case DIVD:  case DIVF:            binary("DIVF");   break;
        case DIVI:                        binary("DIVI");   break;
        case DIVU:                        binary("DIVU");   break;
        case MODI:                        binary("MODI");   break;
        case MODU:                        binary("MODU");   break;
        case RSHU:  case RSHI:            binary("RSHW");   break;
        case LSHI:  case LSHU:
            if (optimizelevel>=2 && strcmp(b->x.name,"1")==0) {
                unary("LSH1W");
            } else binary("LSHW");
            break;
        case INDIRC: case INDIRS:
            if (!p->x.optimized)
                print("\tINDIRB_%c%c(%s,%s)\n"
                        ,reduced_adrmode(a->x.adrmode)    // keep 'Z' adrmode different from 'D'
                        ,simple_adrmode(r->x.adrmode)
                        ,output_arg(a)
                        ,output_arg(r));
            break;
        case INDIRI: case INDIRP:
            if (!p->x.optimized)
                print("\tINDIRW_%c%c(%s,%s)\n"
                        ,reduced_adrmode(a->x.adrmode)    // keep 'Z' adrmode different from 'D'
                        ,simple_adrmode(r->x.adrmode)
                        ,output_arg(a)
                        ,output_arg(r));
            break;
        case INDIRD: case INDIRF:
            if (!p->x.optimized)
                unary("INDIRF");
            break;
        case INDIRB:
            if (!p->x.optimized)
                unary("INDIRS");
            break;
        case BCOMU:                       unary("COMW" );   break;
        case NEGD:  case NEGF:            unary("NEGF" );   break;
        case NEGI:                        unary("NEGI" );   break;
        case CVCI: case CVSI:             unary("CSBW");    break;
        case CVCU: case CVSU:             unary("CZBW");    break;
        case CVUC: case CVUS: case CVIC: case CVIS:
            if (optimizelevel<=1 || strcmp(a->x.name,p->x.name)!=0)
                unary("CWB");
            break;
        case CVPU: case CVUP: case CVIU: case CVUI:
            if (optimizelevel<=1 || strcmp(a->x.name,p->x.name)!=0)
                unary("MOVW");
            break;
        case CVID:                        unary("CIF" );  break;
        case CVDF: case CVFD:
            if (optimizelevel<=1 || strcmp(a->x.name,p->x.name)!=0)
                unary("MOVF");
            break;
        case CVDI:                        unary("CFI" );    break;
        case RETD: case RETF:
            if (optimizelevel>=2 && omit_frame && nbregs==0)
                print("\tRETF_%c(%s)\n"
                        ,simple_adrmode(a->x.adrmode)
                        ,output_arg(a));
            else
                print("\tLEAVEF_%c(%s)\n"
                        ,simple_adrmode(a->x.adrmode)
                        ,output_arg(a));
            break;
        case RETI:
            if (optimizelevel>=2 && omit_frame && nbregs==0)
                print("\tRETW_%c(%s)\n"
                        ,simple_adrmode(a->x.adrmode)
                        ,output_arg(a));
            else
                print("\tLEAVEW_%c(%s)\n"
                        ,simple_adrmode(a->x.adrmode)
                        ,output_arg(a));
            break;
        case RETV:
            if (optimizelevel>=2 && omit_frame && nbregs==0)
                print("\tRET\n");
            else print("\tLEAVE\n");
            break;
        case ADDRGP: case ADDRFP: case ADDRLP:
            if (optimizelevel==0)
                print("\tADDR_%c%c(%s,%s)\n"
                        ,simple_adrmode(p->syms[0]->x.adrmode)
                        ,simple_adrmode(p->x.adrmode)
                        ,output_name(p->syms[0])
                        ,output_arg(p));
            break;
        case CNSTC: case CNSTS:
        case CNSTI: case CNSTU:
        case CNSTP:
            if (optimizelevel==0)
                print("\tCNST_%c%c(%s,%s)\n"
                        ,simple_adrmode(p->syms[0]->x.adrmode)
                        ,simple_adrmode(p->x.adrmode)
                        ,output_name(p->syms[0])
                        ,output_arg(p));
            break;
        case JUMPV:
            print("\tJUMP_%c(%s)\n" ,simple_adrmode(a->x.adrmode), output_arg(a));
            break;
        case ASGNB:
            print("\tASGNS_%c%c(%s,%s,%s)\n"
                    ,simple_adrmode(b->x.adrmode)
                    ,reduced_adrmode(a->x.adrmode)     // keep 'Z' adrmode different from 'D'
                    ,output_arg(b)
                    ,output_arg(a)
                    ,output_name(p->syms[0]));
            break;
        case ASGNC: case ASGNS:
            if (!p->x.optimized)
                print("\tASGNB_%c%c(%s,%s)\n"
                        ,simple_adrmode(b->x.adrmode)
                        ,reduced_adrmode(a->x.adrmode)     // keep 'Z' adrmode different from 'D'
                        ,output_arg(b)
                        ,output_arg(a));
            break;
        case ASGND: case ASGNF:
            if (!p->x.optimized)
                print("\tASGNF_%c%c(%s,%s)\n"
                        ,simple_adrmode(b->x.adrmode)
                        ,reduced_adrmode(a->x.adrmode)     // keep 'Z' adrmode different from 'D'
                        ,output_arg(b)
                        ,output_arg(a));
            break;
        case ASGNI: case ASGNP:
            if (!p->x.optimized)
                print("\tASGNW_%c%c(%s,%s)\n"
                        ,simple_adrmode(b->x.adrmode)
                        ,reduced_adrmode(a->x.adrmode)     // keep 'Z' adrmode different from 'D'
                        ,output_arg(b)
                        ,output_arg(a));
            break;
        case ARGB:
            print("\tARGS_%c(%s,(sp),%d,%s)\n"
                    ,simple_adrmode(a->x.adrmode)
                    ,output_arg(a)
                    ,p->x.argoffset
                    ,output_name(p->syms[0]));
            break;
        case ARGD: case ARGF:
            if (!p->x.optimized)
                print("\tARGF_%c(%s,(sp),%d)\n"
                        ,simple_adrmode(a->x.adrmode)
                        ,output_arg(a)
                        ,p->x.argoffset);
            break;
        case ARGI: case ARGP:
            if (!p->x.optimized)
                print("\tARGW_%c(%s,(sp),%d)\n"
                        ,simple_adrmode(a->x.adrmode)
                        ,output_arg(a)
                        ,p->x.argoffset);
            break;
        case CALLB:
            save_busy(p);
            print("\tMOVW_%cD(%s,op1)\n"
                    ,simple_adrmode(b->x.adrmode)
                    ,output_arg(b));
            print("\tCALLV_%c(%s,%d)\n"
                    ,simple_adrmode(a->x.adrmode)
                    ,output_arg(a)
                    ,p->x.argoffset);
            restore_busy(p);
            break;
        case CALLV:
            save_busy(p);
            print("\tCALLV_%c(%s,%d)\n"
                    ,simple_adrmode(a->x.adrmode)
                    ,output_arg(a)
                    ,p->x.argoffset);
            restore_busy(p);
            break;
        case CALLD: case CALLF:
            save_busy(p);
            print("\tCALLF_%c%c(%s,%d,%s)\n"
                    ,simple_adrmode(a->x.adrmode)
                    ,simple_adrmode(p->x.adrmode)
                    ,output_arg(a)
                    ,p->x.argoffset
                    ,output_arg(p));
            restore_busy(p);
            break;
        case CALLI:
            save_busy(p);
            print("\tCALLW_%c%c(%s,%d,%s)\n"
                    ,simple_adrmode(a->x.adrmode)
                    ,simple_adrmode(p->x.adrmode)
                    ,output_arg(a)
                    ,p->x.argoffset
                    ,output_arg(p));
            restore_busy(p);
            break;
        case EQD:   case EQF:             compare("EQF" ); break;
        case EQI:
            if (optimizelevel>=2 && strcmp(b->x.name,"0")==0)
                compare0("EQ0W");
            else compare("EQW" );
            break;
        case GED:   case GEF:             compare("GEF" ); break;
        case GEI:                         compare("GEI" ); break;
        case GEU:                         compare("GEU" ); break;
        case GTD:   case GTF:             compare("GTF" ); break;
        case GTI:                         compare("GTI" ); break;
        case GTU:                         compare("GTU" ); break;
        case LED:   case LEF:             compare("LEF" ); break;
        case LEI:                         compare("LEI" ); break;
        case LEU:                         compare("LEU" ); break;
        case LTD:   case LTF:             compare("LTF" ); break;
        case LTI:                         compare("LTI" ); break;
        case LTU:                         compare("LTU" ); break;
        case NED:   case NEF:             compare("NEF" ); break;
        case NEI:
            if (optimizelevel>=2 && strcmp(b->x.name,"0")==0)
                compare0("NE0W");
            else compare("NEW" );
            break;
        case LABELV:
            print("%s\n", p->syms[0]->x.name); break;
        default: assert(0);
    }
}

void emit(Node p) {
    if (graph_output) return;
    for (; p; p=p->x.next)
        if (optimizelevel==0) emitdag0(p);
        else emitdag(p);
}
