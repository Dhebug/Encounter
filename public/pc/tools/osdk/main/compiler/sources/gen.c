/* C compiler: Fabrice Frances' 16 bits 6502 code generator */
char *version="/* 16bit code V1.29 by F.Frances */\n";

#include "c.h"

static int localsize;		/* max size of locals */
static int argoffset;		/* current stack position */
static int offset;		/* current local size */
static int tmpsize;		/* max size of temporary variables */
static int nbregs;		/* number of used registers */
static unsigned busy;		/* busy&(1<<t) == 1 if tmp t is used */
static char *fname;		/* current function name */
static char *callname;		/* current function called name */
static char *NamePrefix;	/* Prefix for all local names */
static int omit_frame;		/* if no params and no locals */
static int optimizelevel=3;	/* set by command line option -On */
static Symbol temp[32];		/* 32 symbols pointing to temporary variables... */
		/* (8 last ones for floating point) */
static char *regname[8];	/* 8 register variables names */

static Node *linearize(Node p, Node *last, Node next) 
{
	if (p && !p->x.visited) 
	{
		if ( optimizelevel>0 ) 
		{
		    switch (generic(p->op)) 
			{
			case CNST: 
			case ADDRG: 
			case ADDRL: 
			case ADDRF:
				p->x.optimized=1;
				p->x.result=p->syms[0];
				p->x.adrmode=p->syms[0]->x.adrmode;
				p->x.name=p->syms[0]->x.name;
				return last;
		    }
		}
		last = linearize(p->kids[0], last, 0);
		last = linearize(p->kids[1], last, 0);
		p->x.visited = 1;
		*last = p;
		last = &p->x.next;
	}
	*last = next;
	return last;
}

void progbeg(int argc,char *argv[]) 
{
	int i;
	print(version);
	for(i=1;i<argc;i++) 
	{
		if (strncmp(argv[i],"-N",2)==0) 
		{
			char *ptr;

			NamePrefix=_strdup(argv[i]+2);
			do
			{
				ptr=strpbrk(NamePrefix,"-");
				if (ptr)
				{
					*ptr='_';
				}
			}
			while (ptr);
		} 
		else 
		if (strcmp(argv[i],"-O")==0) 
		{
			optimizelevel=3;
		} 
		else 
		if (strcmp(argv[i],"-O0")==0) 
		{
			optimizelevel=0;	/* no optimization */
		} 
		else 
		if (strcmp(argv[i],"-O1")==0) 
		{
			optimizelevel=1;	/* remove ADDR and CNST leaves */
		} 
		else 
		if (strcmp(argv[i],"-O2")==0) 
		{
			optimizelevel=2;	/* allocate register variables */
						/* and do some easy opt. (INC...) */
		} 
		else 
		if (strcmp(argv[i],"-O3")==0) 
		{
			optimizelevel=3;	/* optimizes INDIR, ASGN ... */
		} 
		else 
		{
			printf("Unknown option %s\n",argv[i]);
			exit(1);
		}
	}
	for (i=0;i<8;i++) 
	{
		temp[i]= newtemp(STATIC,I);	/* temp[i]= newconst((Value)i,P); */
		temp[i]->x.name=stringf("tmp%d",i);
		temp[i]->x.adrmode='Z';		/* temp[i]->x.adrmode='C'; */
		regname[i]=stringf("reg%d",i);
	}
	for (i=8;i<32;i++) 
	{
		temp[i]= newtemp(STATIC,I);	/* temp[i]= newconst((Value)i,P); */
	}
}

void progend(void) 
{

}

void defsymbol(Symbol p) 
{
	if (p->x.name) return;
	if (p->scope == CONSTANTS) 
	{
		p->x.name = p->name;
		if (p->x.name[0]=='0' && p->x.name[1]=='x') 
		{
			p->x.name[0]=' ';
			p->x.name[1]='$';
		}
	} 
	else 
	if (p->sclass == STATIC)
		p->x.name = stringf("L%s%d", NamePrefix, genlabel(1));
	else 
	if (p->generated)
		p->x.name = stringf("L%s%s", NamePrefix, p->name);
	else
		p->x.name = stringf("_%s", p->name);
	p->x.adrmode = 'C';
}

void export(Symbol p) {}
void import(Symbol p) {}
void segment(int s) {}
void global(Symbol p) 
{ 
	print("%s\n", p->x.name); 
}

void printfloat(double val)
{
	int i,exp=32,negative=0;
	double two_pow31,two_pow32;
	unsigned long mantissa;
	
	if (val==0.0) 
	{
		print("\t.byt 0,0,0,0,0\n");
		return;
	}
	if (val<0.0) 
	{ 
		negative=1;
		val= -val; 
	}

	for (two_pow31=1.0,i=0;i<31;i++) two_pow31*=2;
	two_pow32=two_pow31*2;
	while (val>=two_pow32) 
	{
		val/=2;
		exp++;
	}
	while (val<two_pow31) 
	{
		val*=2;
		exp--;
	}
	if (!negative) val-=two_pow31;
	mantissa=(unsigned long)val;
	print("\t.byt $%x",exp+128);
	print(",$%x",(mantissa>>24)&0xFF);
	print(",$%x",(mantissa>>16)&0xFF);
	print(",$%x",(mantissa>>8)&0xFF);
	print(",$%x\n",mantissa&0xFF);
}


void defconst(int ty, Value v) 
{
	switch (ty) 
	{
	case C: 
		print("\tDB(%d)\n",   v.uc); 
		break;
	case S: 
		print("\tDB(%d)\n",   v.us); 
		break;
	case I: 
		print("\tDW(%d)\n",   v.i ); 
		break;
	case U: 
		print("\tDW($%x)\n",  v.u ); 
		break;
	case P: 
		print("\tDW($%x)\n",  v.p ); 
		break;
	case F: 
		//__asm { int 3 };
		printfloat(v.f); 
		break;
	case D: 
		//__asm { int 3 };
		printfloat(v.d); 
		break;
	default: 
		assert(0);
	}
}


void defstring(int len, char *s) 
{
	char buffer_temp[256];
	char buffer_temp_2[256];

	int count;
	while (len > 0) 
	{
		count=16;

		sprintf(buffer_temp_2,"\t.byt $%02x",((unsigned)(*s++))&255);
		strcpy(buffer_temp,buffer_temp_2);

		len--;
		while ((len>0) && (count>0))
		{
			sprintf(buffer_temp_2,",$%02x",((unsigned)(*s++))&255);
			strcat(buffer_temp,buffer_temp_2);
			len--;
			count--;
		}
		strcat(buffer_temp,"\n");
		print(buffer_temp);
	}
}


void defaddress(Symbol p) 
{ 
	print("\tDW(%s)\n",p->x.name); 
}

void space(int n)
{ 
	print("\tZERO(%d)\n",n); 
}

int allocreg(Symbol p) 
{
	if (nbregs==8 || p->type->size==5) return 0;
	p->x.name=regname[nbregs];
	p->x.adrmode='C';
	nbregs++;
	return 1;
}

void function(Symbol f, Symbol caller[], Symbol callee[], int ncalls) 
{
	int i;

	localsize=offset=tmpsize=nbregs=0; fname=f->x.name;
	for (i=8;i<32;i++) temp[i]->x.name="******";
	for (i = 0; caller[i] && callee[i]; i++) 
	{
		caller[i]->x.name=stringf("(ap),%d",offset);
		caller[i]->x.adrmode='A';
		offset+=caller[i]->type->size;
		if (optimizelevel>1 && callee[i]->sclass==REGISTER && allocreg(callee[i]))
			; /* allocreg ok */
		else 
		{
			callee[i]->x.adrmode=caller[i]->x.adrmode;
			callee[i]->x.name=caller[i]->x.name;
			callee[i]->sclass=AUTO;
		}
	}
	busy=localsize=0; offset=6;
	gencode(caller,callee);
	omit_frame=(i==0 && localsize==6);
	print("%s\n",fname);
	if (optimizelevel>1 && omit_frame && nbregs==0)
		;
	else print("\tENTER(%d,%d)\n",nbregs,localsize);
	if (isstruct(freturn(f->type)))
		print("\tMOVW_DI(op1,(fp),6)\n");
	emitcode();
}

void local(Symbol p) 
{
	if (optimizelevel>1 && p->sclass==REGISTER && allocreg(p))
		return; /* allocreg ok */
	if (p->x.name && p->x.name[0]!='*') return; /* keep previous local (it isn't busy) */
	p->x.name = stringf("(fp),%d",offset);
	p->x.adrmode = 'A';
	p->sclass = AUTO;
	offset+=p->type->size;
}

void address(Symbol q, Symbol p, int n) 
{
	q->x.name = stringf("%s%s%d", p->x.name, n >= 0 ? "+" : "", n);
	q->x.adrmode=p->x.adrmode;
}

void blockbeg(Env *e) 
{ 
	e->offset = offset; 
}

void blockend(Env *e) 
{
	if (offset > localsize) localsize = offset;
	offset = e->offset;
}

static void gettmp(Node p) 
{
	int t;
/*
	Node q;
	int call_found=0, use_zpage=1;
	for (q=p->x.next; q; q=q->x.next) {
		if (generic(q->op)==CALL) call_found=1;
		if ((q->kids[0]==p || q->kids[1]==p) && call_found)
			use_zpage=0; 
	}
*/
	if ( optype(p->op)!=F && optype(p->op)!=D ) 
	{
		for (t=0;t<24;t++)
			if ((busy&(1<<t))==0) 
			{
				busy|=1<<t;
				p->x.result=temp[t];
				p->x.adrmode='D';
				if (t>=8) 
				{
					temp[t]->type->size=2;
					local(temp[t]);
					p->x.adrmode='I';
				}
				p->x.name=temp[t]->x.name;
				return;
			}
	} 
	else
		for (t=24;t<32;t++)
			if ((busy&(1<<t))==0) 
			{
				busy|=1<<t;
				p->x.result=temp[t];
				p->x.adrmode='I';
				temp[t]->type->size=5;
				local(temp[t]);
				p->x.name=temp[t]->x.name;
				return;
			}
	perror("Too complex expression"); exit(1);
}

static void releasetmp(Node p) 
{
	if (!p) return;
	assert(p->count!=0);
	p->count--;
	switch(generic(p->op)) 
	{
		case ADDRG: 
		case ADDRL: 
		case ADDRF: 
		case CNST:
			if (optimizelevel>0) return;
			break;
		case INDIR:
			if (p->x.optimized) return;
	}
	if (p->count==0) {
		int i;
		for (i=0;i<32;i++)
			if (p->x.result==temp[i]) break;
		busy&= ~(1<<i);
	}
}
			
static int needtmp(Node p) 
{
	switch (generic(p->op)) 
	{
		case ADDRF: 
		case ADDRG: 
		case ADDRL:
		case CNST:
			assert(optimizelevel==0);
			return 1;
		case INDIR:
			if (optimizelevel>=3) 
			{
				if (optype(p->op)==B) 
				{ /* fix frontend bug: remove all INDIRB nodes */
					p->x.optimized=1;
					p->x.result=p->kids[0]->x.result;
					p->x.name=p->x.result->x.name;
					p->x.adrmode=p->kids[0]->x.adrmode;
					return 0;
				} 
				else 
				if (p->x.next
				     &&	( p->kids[0]->count==0
					|| p->count==1
					  && ( p->x.next->kids[0]==p
					    || p->x.next->kids[1]==p)
					)
				     && ( generic(p->kids[0]->op)==ADDRF
					|| generic(p->kids[0]->op)==ADDRG
					|| generic(p->kids[0]->op)==ADDRL
					|| generic(p->kids[0]->op)==CNST ))
				{
					p->x.optimized=1;
					p->x.result=p->kids[0]->x.result;
					p->x.name=p->x.result->x.name;
					if (p->x.result->x.adrmode=='C')
						p->x.adrmode='D';
					else p->x.adrmode='I';
					return 0;
				}
			}
			return 1;
		case ASGN:
		case ARG:
		case EQ: 
		case GE: 
		case GT: 
		case LE: 
		case LT: 
		case NE:
		case RET:
		case JUMP: 
		case LABEL:
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

static void tmpalloc(Node p) 
{
	p->x.optimized=0;
	p->x.name="*******";
	p->x.adrmode='*';
	releasetmp(p->kids[0]); releasetmp(p->kids[1]);
	switch (generic(p->op)) {
	case ARG:
		p->x.argoffset = argoffset;
		argoffset += p->syms[0]->u.c.v.i;
/*
		if (0) {
			Node k=p->kids[0];
			if (k->count==0
			    && generic(k->op)!=INDIR
			    && generic(k->op)!=ADDRF
			    && generic(k->op)!=ADDRG
			    && generic(k->op)!=ADDRL
			    && generic(k->op)!=CNST )
			{
				p->x.optimized=1;
				k->x.optimized=1;
				k->x.name=stringf("(sp),%d",p->x.argoffset);
				k->x.adrmode='I';
			}
		}
*/
		break;
	case CALL:
		p->x.argoffset = argoffset;
		argoffset = 0;
		break;
	case ASGN:
		if (optimizelevel>=3) 
		{	/* kids[1] : expression droite */
			if (optype(p->op)!=B
			    && p==p->kids[1]->x.next
			    &&   ( generic(p->kids[0]->op)==ADDRF
				|| generic(p->kids[0]->op)==ADDRG
				|| generic(p->kids[0]->op)==ADDRL)
			    && generic(p->kids[1]->op)!=INDIR
			    && generic(p->kids[1]->op)!=ADDRF
			    && generic(p->kids[1]->op)!=ADDRG
			    && generic(p->kids[1]->op)!=ADDRL
			    && generic(p->kids[1]->op)!=CNST )
			{
				Node k=p->kids[1];
				p->x.optimized=1;
				k->x.optimized=1;
				k->x.result=p->kids[0]->x.result;
				k->x.name=k->x.result->x.name;
				k->x.adrmode=k->x.result->x.adrmode;
				if (k->x.adrmode=='C') k->x.adrmode='D';
				else k->x.adrmode='I';
			}
		}
		break;
	}
	if (needtmp(p)) gettmp(p);
}

Node gen(Node p) 
{
	Node head, *last;
	for (last = &head; p; p = p->link)
		last = linearize(p, last, 0);
	for (p = head; p; p = p->x.next) tmpalloc(p);
	return head;
}

void asmcode(char *str, Symbol argv[]) 
{
	for ( ; *str; str++)
		if (*str == '%' && str[1] >= 0 && str[1] <= 9)
			print("%s", argv[*++str]->x.name);
		else
			print("%c", *str);
	print("\n");
}

static Node a,b,r;

void binary(char *inst) 
{
	print("\t%s_%c%c%c(", inst
		,a->x.adrmode
		,b->x.adrmode
		,r->x.adrmode);
	print("%s,%s,%s)\n", a->x.name, b->x.name, r->x.name);
}

void unary(char *inst) 
{
	print("\t%s_%c%c(", inst
		,a->x.adrmode
		,r->x.adrmode);
	print("%s,%s)\n", a->x.name, r->x.name);
}

void compare0(char *inst) 
{
	print("\t%s_%c(%s,%s)\n"
		,inst
		,a->x.adrmode
		,a->x.name
		,r->syms[0]->x.name);
}

void compare(char *inst) 
{
	print("\t%s_%c%c(", inst
		,a->x.adrmode
		,b->x.adrmode);
	print("%s,%s,%s)\n", a->x.name, b->x.name, r->syms[0]->x.name);
}

char adrmode(Node p) 
{
	if (p->x.adrmode!='D') return p->x.adrmode;
	return p->x.name[0]=='_' ? 'D': 'Z';
}

void emitdag(Node p) 
{
	a = p->kids[0];
	b = p->kids[1]; 
	r=p;

	switch (p->op) 
	{
		case BANDU:				
			binary("ANDW");   
			break;
		case BORU:				
			binary("ORW");   
			break;
		case BXORU:			
			binary("XORW");   
			break;
		case ADDD:  
		case ADDF:			
			binary("ADDF");  
			break;
		case ADDI:  
		case ADDP:  
		case ADDU:
			if (optimizelevel>=2 && strcmp(a->x.name,p->x.name)==0
					&& p->x.adrmode=='D'
					&& strcmp(b->x.name,"1")==0)
				print("\tINCW_%c(%s)\n"
					,(p->x.name[0]=='_' || p->x.name[0]=='L')? 'D':'Z'
					,p->x.name);
			else
				binary("ADDW");
			break;
		case SUBD:  
		case SUBF:			
			binary("SUBF");  
			break;
		case SUBI:  
		case SUBP:  
		case SUBU:
			if (optimizelevel>=2 && strcmp(a->x.name,p->x.name)==0
					&& p->x.adrmode=='D'
					&& strcmp(b->x.name,"1")==0)
			{
				print("\tDECW_%c(%s)\n"
					,(p->x.name[0]=='_' || p->x.name[0]=='L')? 'D':'Z'
					,p->x.name);
			}
			else
				binary("SUBW");
			break;
		case MULD:  
		case MULF:			
			binary("MULF");	 
			break;
		case MULI:				
			binary("MULI");   
			break;
		case MULU:				
			binary("MULU");   
			break;
		case DIVD:  
		case DIVF:			
			binary("DIVF");	 
			break;
		case DIVI:				
			binary("DIVI");   
			break;
		case DIVU:				
			binary("DIVU");   
			break;
		case MODI:				
			binary("MODI");   
			break;
		case MODU:				
			binary("MODU");   
			break;
		case RSHU:  
		case RSHI:			
			binary("RSHW");	 
			break;
		case LSHI:  
		case LSHU:
			if (optimizelevel>=2 && strcmp(b->x.name,"1")==0) 
			{
				unary("LSH1W");
			} 
			else 
				binary("LSHW");
			break;
		case INDIRC: 
		case INDIRS:
			if (!p->x.optimized)
				print("\tINDIRB_%c%c(%s,%s)\n"
					,adrmode(a)
					,r->x.adrmode
					,a->x.name
					,r->x.name);
			break;
		case INDIRI: 
		case INDIRP:
			if (!p->x.optimized)
				print("\tINDIRW_%c%c(%s,%s)\n"
					,adrmode(a)
					,r->x.adrmode
					,a->x.name
					,r->x.name);
			break;
		case INDIRD: 
		case INDIRF:
			if (!p->x.optimized)
				unary("INDIRF");
			break;
		case INDIRB:
			if (!p->x.optimized)
				unary("INDIRS");
			break;
		case BCOMU:				
			unary("COMW" );   
			break;
		case NEGD:  
		case NEGF:			
			unary("NEGF" );   
			break;
		case NEGI:				
			unary("NEGI" );   
			break;
		case CVCI: 
		case CVSI:			
			unary("CSBW");	
			break;
		case CVCU: 
		case CVSU:			
			unary("CZBW");  
			break;
		case CVUC: 
		case CVUS: 
		case CVIC: 
		case CVIS:
			if (optimizelevel<=1 || strcmp(a->x.name,p->x.name)!=0)
				unary("CWB");
			break;
		case CVPU: 
		case CVUP: 
		case CVIU: 
		case CVUI:
			if (optimizelevel<=1 || strcmp(a->x.name,p->x.name)!=0)
				unary("MOVW");
			break;
		case CVID:				
			unary("CIF" );  
			break;
		case CVDF: 
		case CVFD:
			if (optimizelevel<=1 || strcmp(a->x.name,p->x.name)!=0)
				unary("MOVF");
			break;
		case CVDI:				
			unary("CFI" );	
			break;
		case RETD: 
		case RETF:
			if (optimizelevel>=2 && omit_frame && nbregs==0)
				print("\tRETF_%c(%s)\n"
					,a->x.adrmode
					,a->x.name);
			else
				print("\tLEAVEF_%c(%s)\n"
					,a->x.adrmode
					,a->x.name);
			break;
		case RETI:
			if (optimizelevel>=2 && omit_frame && nbregs==0)
				print("\tRETW_%c(%s)\n"
					,a->x.adrmode
					,a->x.name);
			else
				print("\tLEAVEW_%c(%s)\n"
					,a->x.adrmode
					,a->x.name);
			break;
		case RETV:
			if (optimizelevel>=2 && omit_frame && nbregs==0)
				print("\tRET\n");
			else print("\tLEAVE\n");
			break;
		case ADDRGP: 
		case ADDRFP: 
		case ADDRLP:
			if (optimizelevel==0)
				print("\tADDR_%c%c(%s,%s)\n"
					,p->syms[0]->x.adrmode
					,p->x.adrmode
					,p->syms[0]->x.name
					,p->x.name);
			break;
		case CNSTC: 
		case CNSTS:
		case CNSTI: 
		case CNSTU:
		case CNSTP:
			if (optimizelevel==0)
				print("\tCNST_%c%c(%s,%s)\n"
					,p->syms[0]->x.adrmode
					,p->x.adrmode
					,p->syms[0]->name
					,p->x.name);
			break;
		case JUMPV:
			print("\tJUMP_%c(%s)\n"
					,a->x.adrmode, a->x.name);
			break;
		case ASGNB:
			print("\tASGNS_%c%c(%s,%s,%s)\n"
				,b->x.adrmode
				,a->x.adrmode
				,b->x.name
				,a->x.name
				,p->syms[0]->x.name);
			break;
		case ASGNC: 
		case ASGNS:
			if (!p->x.optimized)
				print("\tASGNB_%c%c(%s,%s)\n"
					,b->x.adrmode
					,adrmode(a)
					,b->x.name
					,a->x.name);
			break;
		case ASGND: 
		case ASGNF:
			if (!p->x.optimized)
				print("\tASGNF_%c%c(%s,%s)\n"
					,b->x.adrmode
					,adrmode(a)
					,b->x.name
					,a->x.name);
			break;
		case ASGNI: 
		case ASGNP:
			if (!p->x.optimized)
				print("\tASGNW_%c%c(%s,%s)\n"
					,b->x.adrmode
					,adrmode(a)
					,b->x.name
					,a->x.name);
			break;
		case ARGB:
			print("\tARGS_%c(%s,(sp),%d,%s)\n"
				,a->x.adrmode
				,a->x.name
				,p->x.argoffset
				,p->syms[0]->x.name);
			break;
		case ARGD: 
		case ARGF:
			if (!p->x.optimized)
				print("\tARGF_%c(%s,(sp),%d)\n"
					,a->x.adrmode
					,a->x.name
					,p->x.argoffset);
			break;
		case ARGI: 
		case ARGP:
			if (!p->x.optimized)
				print("\tARGW_%c(%s,(sp),%d)\n"
					,a->x.adrmode
					,a->x.name
					,p->x.argoffset);
			break;
		case CALLB:
			print("\tMOVW_%cD(%s,op1)\n"
				,b->x.adrmode
				,b->x.name);
		case CALLV:
			print("\tCALLV_%c(%s,%d)\n"
				,a->x.adrmode
				,a->x.name
				,p->x.argoffset);
			break;
		case CALLD: 
		case CALLF:
			print("\tCALLF_%c%c(%s,%d,%s)\n"
				,a->x.adrmode
				,p->x.adrmode
				,a->x.name
				,p->x.argoffset
				,p->x.name);
			break;
		case CALLI:
			print("\tCALLW_%c%c(%s,%d,%s)\n"
				,a->x.adrmode
				,p->x.adrmode
				,a->x.name
				,p->x.argoffset
				,p->x.name);
			break;
		case EQD:   
		case EQF: 			
			compare("EQF" ); 
			break;
		case EQI:
			if (optimizelevel>=2 && strcmp(b->x.name,"0")==0)
				compare0("EQ0W");
			else compare("EQW" );
			break;
		case GED:   
		case GEF:			
			compare("GEF" ); 
			break;
		case GEI:				
			compare("GEI" ); 
			break;
		case GEU:				
			compare("GEU" ); 
			break;
		case GTD:   
		case GTF:			
			compare("GTF" ); 
			break;
	 	case GTI:				
			compare("GTI" ); 
			break;
		case GTU:				
			compare("GTU" ); 
			break;
		case LED:   
		case LEF: 			
			compare("LEF" ); 
			break;
		case LEI:				
			compare("LEI" ); 
			break;
		case LEU:				
			compare("LEU" ); 
			break;
		case LTD:   
		case LTF: 			
			compare("LTF" ); 
			break;
		case LTI:				
			compare("LTI" ); 
			break;
		case LTU:				
			compare("LTU" ); 
			break;
		case NED:   
		case NEF:			
			compare("NEF" ); 
			break;
		case NEI:
			if (optimizelevel>=2 && strcmp(b->x.name,"0")==0)
				compare0("NE0W");
			else 
				compare("NEW" );
			break;
		case LABELV:
			print("%s\n", p->syms[0]->x.name); 
			break;
		default: 
			assert(0);
	}
}

void emit(Node p) 
{
	for (; p; p=p->x.next) 
	{
		emitdag(p);
	}
}

