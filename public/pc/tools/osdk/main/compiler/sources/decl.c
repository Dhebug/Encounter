/* C compiler: declaration parsing */

#include "c.h"

Symbol cfunc = 0;		/* current function */
char *fname=0;          /* function name */
Symbol retv;			/* return value location for structs */

static List autos;		/* auto locals for current block */
static int funcdclr;		/* declarator has parameters */
static int nglobals;		/* number of external ids */
static int regcount;		/* number of explicit register declarations */
static List registers;		/* register locals for current block */

dclproto(static void checklab,(Symbol, Generic));
dclproto(static void checkparam,(Symbol, Generic));
dclproto(static void checkref,(Symbol, Generic));
dclproto(static Symbol dclglobal,(int, char *, Type, Coordinate *));
dclproto(static Symbol dcllocal,(int, char *, Type, Coordinate *));
dclproto(static Symbol dclparam,(int, char *, Type, Coordinate *));
dclproto(static Type dclr,(Type, char **, int));
dclproto(static Type dclr1,(char **, int));
dclproto(static void decl,(Symbol (*)(int, char *, Type, Coordinate *), int));
dclproto(static void doglobal,(Symbol, Generic));
dclproto(static void doextern,(Symbol, Generic));
dclproto(static Type enumdecl,(void));
dclproto(static void fields,(Type));
dclproto(static void funcdecl,(int, char *, Type, Coordinate));
dclproto(static Type newstyle,(Type, Symbol[], Symbol[]));
dclproto(static void oldparam,(Symbol, Generic));
dclproto(static Type oldstyle,(char *, Type, Symbol[], Symbol[]));
dclproto(static Type *parameters,(int));
dclproto(static Type structdcl,(int));
dclproto(static Type tnode,(int, Type));
dclproto(static Type type,(int, int *));

/* checklab - check for undefined labels; called at ends of functions */
static void checklab(p, cl) Symbol p; Generic cl; {
	if (!p->defined)
		error("undefined label `%s'\n", p->name);
	p->defined = 1;
}

/* checkref - check for unreferenced variables; called at ends of blocks */
static void checkref(p, cl) Symbol p; Generic cl; {
	Symbol q;

	if (p->scope >= PARAM && isvolatile(p->type))
		p->addressed = 1;
	if (Aflag >= 2 && p->defined && p->ref == 0) {
		if (p->sclass == STATIC)
			warning("static `%t %s' is not referenced\n", p->type, p->name);
		else if (p->scope == PARAM)
			warning("parameter `%t %s' is not referenced\n", p->type, p->name);
		else if (p->scope > PARAM && p->sclass != EXTERN)
			warning("local `%t %s' is not referenced\n", p->type, p->name);
	} else if (p->scope >= PARAM + (regcount > 0) && p->sclass == AUTO
	&& !p->addressed && isscalar(p->type) && p->ref >= 3000)
		p->sclass = REGISTER;
	if (p->scope > PARAM && (q = lookup(p->name, externals))) {
		q->ref += p->ref;
	} else if (p->sclass == STATIC && !p->defined) {
		if (p->ref > 0)
			error("undefined static `%t %s'\n", p->type, p->name);
		else if (isfunc(p->type))
			warning("undefined static `%t %s'\n", p->type, p->name);
	}
}

/* compound - { ( decl ; )* statement* } */
void compound(int loop, struct swtch *swp, int lev) {
	Symbol p;
	Code cp;
	int i, j, nregs;

	walk(0, 0, 0);
	cp = code(Blockbeg);
	enterscope();
	cp->u.block.bnumber = ++bnumber;
	cp->u.block.level = level;
	autos = registers = 0;
	if (level == LOCAL && isstruct(freturn(cfunc->type))) {
		retv = genident(AUTO, ptr(freturn(cfunc->type)), level);
		retv->defined = 1;
		retv->initialized = 1;
		registers = append(retv, registers);	/* insures that retv is the 1st local */
	}
	if (level == LOCAL && events.entry)
		apply(events.entry, (Generic)cfunc, (Generic)0);
	expect('{');
	while (kind[t] == CHAR || kind[t] == STATIC
	|| (t == ID && tsym && tsym->sclass == TYPEDEF && (level < LOCAL || getchr() != ':')))
		decl(dcllocal, 0);
	nregs = length(registers);
	cp->u.block.locals = (Symbol *)list_to_a(registers, (Generic *)talloc((nregs + length(autos) + 1)*sizeof(Symbol)));
	list_to_a(autos, (Generic *)&cp->u.block.locals[nregs]);
	while (kind[t] == IF || kind[t] == ID)
		statement(loop, swp, lev);
	walk(0, 0, 0);
	foreach(identifiers, level, checkref, (Generic)0);
	for (i = nregs; p = cp->u.block.locals[i]; i++) {
		for (j = i; j > nregs && cp->u.block.locals[j-1]->ref < p->ref; j--)
			cp->u.block.locals[j] = cp->u.block.locals[j-1];
		cp->u.block.locals[j] = p;
	}
	cp->u.block.identifiers = identifiers;
	cp->u.block.types = types;
	code(Blockend);
	if (level > LOCAL) {
		exitscope();
		expect('}');
	}
}

/* dclglobal - called from decl to declare a global */
static Symbol dclglobal(int sclass, char *id, Type ty, Coordinate *pos) {
	Symbol p, q;

	if (sclass == 0 || sclass == REGISTER)
		sclass = AUTO;
	if ((p = lookup(id, identifiers)) && p->scope == GLOBAL) {
		if (p->sclass != TYPEDEF && eqtype(ty, p->type, 1))
			ty = composite(ty, p->type);
		else
			error("redeclaration of `%s' previously declared at %w\n",
				p->name, &p->src);
		if (!isfunc(ty) && p->defined && t == '=')
			error("redefinition of `%s' previously defined at %w\n",
				p->name, &p->src);
		if (p->sclass == STATIC && sclass == AUTO
		||  p->sclass != STATIC && sclass == STATIC)
			warning("inconsistent linkage for `%s' previously declared at %w\n",
				p->name, &p->src);
	} else if (sclass == STATIC && !isfunc(ty) && ty->size == 0 && t != '=')
		warning("undefined size for static `%t %s'\n", ty, id);
	if (p == 0 || p->scope != GLOBAL)
		p = install(id, &globals, 1);
	p->type = ty;
	if (p->sclass == 0 || sclass != EXTERN && p->sclass != STATIC)
		p->sclass = sclass;
	if (p->sclass != STATIC) {
		nglobals++;
		if (Aflag >= 2 && nglobals == 512)
			warning("more than 511 external identifiers\n");
	}
	p->src = *pos;
	if (!p->defined)
		defsymbol(p);
	if (q = lookup(p->name, externals)) {
		if ((p->sclass == AUTO ? EXTERN : p->sclass) != q->sclass
		|| !eqtype(p->type, q->type, 1))
			warning("declaration of `%s' does not match previous declaration at %w\n",
				p->name, &q->src);
		p->ref += q->ref;
	}
	if (!isfunc(p->type))
		initglobal(p, 0);
	else if (t == '=') {
		error("illegal initialization for `%s'\n", p->name);
		t = gettok();
		initializer(p->type, 0);
	}
	return p;
}

/* dcllocal - called from decl to declare a local */
static Symbol dcllocal(int sclass, char *id, Type ty, Coordinate *pos) {
	Symbol p, q;

	if (isfunc(ty)) {
		if (sclass && sclass != EXTERN)
			error("invalid storage class `%k' for `%t %s'\n", sclass, ty, id);
		sclass = EXTERN;
	} else if (sclass == 0)
		sclass = AUTO;
	if (sclass == REGISTER && (isvolatile(ty) || isstruct(ty) || isarray(ty))) {
		warning("register declaration ignored for `%t %s'\n", ty, id);
		sclass = AUTO;
	}
	if ((q = lookup(id, identifiers))
	&& (q->scope >= level || q->scope == PARAM && level == PARAM+1))
		if (sclass == EXTERN && q->sclass == EXTERN && eqtype(q->type, ty, 1))
			ty = composite(ty, q->type);
		else
			error("redeclaration of `%s' previously declared at %w\n",
				q->name, &q->src);
	assert(level >= LOCAL);
	p = install(id, &identifiers, 0);
	p->type = ty;
	p->sclass = sclass;
	p->src = *pos;
	switch (sclass) {
	case EXTERN: {
		Symbol r;
		if (q && q->scope == GLOBAL && q->sclass == STATIC) {
			p->sclass = STATIC;
			p->scope = GLOBAL;
			defsymbol(p);
			p->scope = level;
		} else
			defsymbol(p);
		if ((r = lookup(id, externals)) == 0) {
			r = install(p->name, &externals, 1);
			r->src = p->src;
			r->type = p->type;
			r->sclass = p->sclass;
			if ((q = lookup(id, globals)) && q->sclass != TYPEDEF && q->sclass != ENUM)
				r = q;
		}
		if (r && ((r->sclass == AUTO ? EXTERN : r->sclass) != p->sclass
		|| !eqtype(r->type, p->type, 1)))
			warning("declaration of `%s' does not match previous declaration at %w\n",
				r->name, &r->src);
		break;
		}
	case STATIC:
		defsymbol(p);
		initglobal(p, 0);
		if (!p->defined)
			if (p->type->size > 0) {
				defglobal(p, BSS);
				space(p->type->size);
			} else
				error("undefined size for `%t %s'\n", p->type, p->name);
		p->defined = 1;
		break;
	case REGISTER:
		registers = append(p, registers);
		regcount++;
		p->defined = 1;
		break;
	case AUTO:
		autos = append(p, autos);
		p->defined = 1;
		break;
	default: assert(0);
	}
	if (t == '=') {
		Tree e;
		if (sclass == EXTERN)
			error("illegal initialization of `extern %s'\n", id);
		t = gettok();
		definept(0);
		if (isscalar(p->type) || isstruct(p->type) && t != '{') {
			if (t == '{') {
				t = gettok();
				e = constexpr(0);
				genconst(e, 0);
				expect('}');
			} else
				e = expr1(0);
		} else {
			Type ty = p->type;
			if (!isconst(ty) && (!isarray(ty) || !isconst(ty->type)))
				ty = qual(CONST, ty);
			q = genident(STATIC, ty, GLOBAL);
			initglobal(q, 1);
			if (isarray(p->type) && p->type->size == 0 && q->type->size > 0)
				p->type = array(p->type->type, q->type->size/q->type->type->size, 0);
			e = idnode(q);
		}
		walk(root(asgn(p, e)), 0, 0);
		p->initialized = 1;
		p->ref = 0;
	}
	if (p->sclass == AUTO && isarray(p->type) && p->type->type->size > 0
	&& p->type->align < STRUCT_ALIGN)
		p->type = array(p->type->type,
			p->type->size/p->type->type->size, STRUCT_ALIGN);
	if (!isfunc(p->type) && p->defined && p->type->size <= 0)
			error("undefined size for `%t %s'\n", p->type, id);
	return p;
}

/* dclparam - called from decl to declare a parameter */
static Symbol dclparam(int sclass, char *id, Type ty, Coordinate *pos) {
	Symbol p;

	if ((p = lookup(id, identifiers)) && p->scope == level
	&& (p->defined || p->type == 0 && ty == 0))
		error("duplicate definition for `%s' previously declared at %w\n",
			id, &p->src);
	else if (p == 0 || p->scope < level)
		p = install(id, &identifiers, 0);
	if (ty && isfunc(ty))
		ty = ptr(ty);
	else if (ty && isarray(ty))
		ty = atop(ty);
	if (sclass == 0)
		sclass = AUTO;
	if (sclass == REGISTER && ty && (isvolatile(ty) || isstruct(ty))) {
		warning("register declaration ignored for `%t%s\n", ty,
			stringf(id ? " %s'" : "' parameter", id));
		sclass = AUTO;
	}
	p->sclass = sclass;
	p->src = *pos;
	if (p->type = ty)
		p->defined = 1;
	if (t == '=') {
		error("illegal initialization for parameter `%s'\n", id);
		t = gettok();
		expr1(0);
	}
	return p;
}

/* dclr - declarator */
static Type dclr(Type basety, char **id, int lev) {
	Type ty;

	for (ty = dclr1(id, lev); ty; ty = ty->type)
		switch (ty->op) {
		case POINTER:
			basety = ptr(basety);
			break;
		case FUNCTION:
			basety = func(basety, ty->u.proto);
			break;
		case ARRAY:
			basety = array(basety, ty->size, 0);
			break;
		case CONST: case VOLATILE:
			basety = qual(ty->op, basety);
			break;
		default:
			assert(0);
		}
	if (Aflag >= 2 && basety->size > 32767)
		warning("more than 32767 bytes in `%t'\n", basety);
	return basety;
}

/* dclr1 - ( id |  * ( const | volatile )* | '(' dclr1 ')' ) ( (...) | [...] )* */
static Type dclr1(char **id, int lev) {
	Type ty = 0;

	switch (t) {
	case ID:
		if (id)
			*id = token;
		else
			error("extraneous identifier `%s'\n", token);
		t = gettok();
		break;
	case '*':
		t = gettok();
		if (t == CONST || t == VOLATILE) {
			Type ty1;
			ty1 = ty = tnode(t, 0);
			while ((t = gettok()) == CONST || t == VOLATILE)
				ty1 = tnode(t, ty1);
			ty->type = dclr1(id, lev);
			ty = ty1;
		} else
			ty = dclr1(id, lev);
		ty = tnode(POINTER, ty);
		break;
	case '(':
		t = gettok();
		if (kind[t] == CHAR || t == ID && tsym && tsym->sclass == TYPEDEF) {
			ty = tnode(FUNCTION, ty);
			ty->u.proto = parameters(lev);
			{ foreach(identifiers, level, checkparam, (Generic)0); exitscope(); }
		} else {
			ty = dclr1(id, lev);
			expect(')');
			if (ty == 0 && id == 0)
				return tnode(FUNCTION, ty);
		}
		break;
	case '[':
		break;
	default:
		return ty;
	}
	while (t == '(' || t == '[')
		if (t == '(') {
			t = gettok();
			ty = tnode(FUNCTION, ty);
			ty->u.proto = parameters(lev);
			if (lev == 0 && funcdclr == 0)
				funcdclr++;
			else
				{ foreach(identifiers, level, checkparam, (Generic)0); exitscope(); }
		} else {
			int n = 0;
			t = gettok();
			if (kind[t] == ID) {
				n = intexpr(']', 1);
				if (n <= 0) {
					error("`%d' is an illegal array size\n", n);
					n = 1;
				}
			} else
				expect(']');
			ty = tnode(ARRAY, ty);
			ty->size = n;
		}
	return ty;
}

/* decl - type [ dclr ( , dclr )* ] ; */
static void decl(dcl, eflag)
dclproto(Symbol (*dcl),(int, char *, Type, Coordinate *));
int eflag;
{
	int sclass;
	char *id = 0;
	Type ty, ty1;
	Coordinate pt;
	static char follow[] = { CHAR, STATIC, ID, 0 };

	pt = src;
	ty = type(level, &sclass);
	if (t == ID || t == '*' || t == '(' || t == '[') {
		Coordinate pos;
		pos = src;
		funcdclr = 0;
		if (level == GLOBAL) {
			ty1 = dclr(ty, &id, 0);
			if (funcdclr && id && isfunc(ty1)
			&& (t == '{' || kind[t] == CHAR
			|| (kind[t] == STATIC && t != TYPEDEF)
			||  t == ID && tsym && tsym->sclass == TYPEDEF)) {
				if (sclass == TYPEDEF) {
					error("invalid use of `typedef'\n");
					sclass = EXTERN;
				}
				funcdecl(sclass, id, ty1, pt);
				return;
			} else if (funcdclr)
				{ foreach(identifiers, level, checkparam, (Generic)0); exitscope(); }
		} else
			ty1 = dclr(ty, &id, 1);
		for (;;) {
			if (Aflag >= 1 && !hasproto(ty1))
				warning("missing prototype\n");
			if (id == 0)
				error("missing identifier\n");
			else if (sclass == TYPEDEF)
				deftype(id, ty1, &pos);
			else
				(*dcl)(sclass, id, ty1, &pos);
			if (level == GLOBAL)
				tfree();
			if (t != ',')
				break;
			t = gettok();
			id = 0;
			pos = src;
			ty1 = dclr(ty, &id, 1);
		}
	} else if (ty && eflag)
		error("empty declaration\n");
	else if (ty && (sclass || !isstruct(ty) && !isenum(ty)))
		warning("empty declaration\n");
	test(';', follow);
}

/* doextern - import external declared in a block, if necessary, propagate flags */
static void doextern(Symbol p, Generic cl){
	Symbol q;

	if (q = lookup(p->name, identifiers))
		q->ref += p->ref;
	else {
		defsymbol(p);
		import(p);
	}
}

/* doglobal - finalize tentative definitions, check for imported symbols */
static void doglobal(Symbol p, Generic cl) {
	if (p->sclass == TYPEDEF || p->sclass == ENUM || p->defined) {
		if (Pflag && !isfunc(p->type) && !p->generated)
			printdecl(p, p->type);
		return;
	}
	if (p->sclass == EXTERN || isfunc(p->type))
		import(p);
	else if (!isfunc(p->type)) {
		if (p->type->size > 0) {
			defglobal(p, BSS);
			space(p->type->size);
		} else
			error("undefined size for `%t %s'\n", p->type, p->name);
		p->defined = 1;
		if (Pflag && !p->generated)
			printdecl(p, p->type);
	}
}

/* enumdecl - enum [ id ] [ { id [ = cexpr ] ( , id [ = cexpr ] )* } ] */
static Type enumdecl() {
	char *tag;
	Type ty;
	Symbol p;
	Coordinate pos;

	t = gettok();
	if (t == ID) {
		tag = token;
		pos = src;
		t = gettok();
	} else
		tag = string("");
	if (t == '{') {
		static char follow[] = { IF, 0 };
		int n = 0, min, max, k = -1;
		List idlist = 0;
		ty = newstruct(ENUM, tag);
		t = gettok();
		if (t != ID)
			error("expecting an enumerator identifier\n");
		while (t == ID) {
			char *id = token;
			Coordinate s;
			if (tsym && tsym->scope == level)
				error("redeclaration of `%s' previously declared at %w\n",
					token, &tsym->src);
			s = src;
			t = gettok();
			if (t == '=') {
				t = gettok();
				k = intexpr(0, 0);
			} else {
				if (k == INT_MAX)
					error("overflow in value for enumeration constant `%s'\n", p->name);
				k++;
			}
			if (idlist) {
				if (k < min)
					min = k;
				if (k > max)
					max = k;
			} else
				min = max = k;
			p = install(id, &identifiers, level < LOCAL);
			p->src = s;
			p->type = ty;
			p->sclass = ENUM;
			p->u.value = k;
			idlist = append(p, idlist);
			n++;
			if (Aflag >= 2 && n == 128)
				warning("more than 127 enumeration constants in `%t'\n", ty);
			if (t != ',')
				break;
			t = gettok();
			if (Aflag >= 2 && t == '}')
				warning("non-ANSI trailing comma in enumerator list\n");
		}
		test('}', follow);
		if (min >= 0 && max <= 255)
			ty->type = unsignedchar;
		else if (min >= -128 && max <= 127)
			ty->type = signedchar;
		else if (min >= 0 && max <= 65535 && unsignedshort->size >= 2)
			ty->type = unsignedshort;
		else if (min >= -32768 && max <= 32767 && shorttype->size >= 2)
			ty->type = shorttype;
		else
			ty->type = inttype;
		ty->size = ty->type->size;
		ty->align = ty->type->align;
		ty->u.sym->u.idlist = (Symbol *)list_to_a(idlist, (Generic *)alloc((length(idlist) + 1)*sizeof(Symbol)));
		ty->u.sym->defined = 1;
	} else if ((p = lookup(tag, types)) && p->type->op == ENUM) {
		if (*tag && xref)
			use(p, pos);
		ty = p->type;
	} else {
		error("unknown enumeration `%s'\n",  tag);
		ty = newstruct(ENUM, tag);
		ty->type = inttype;
	}
	return ty;
}

/* fields - ( type dclr ( , dclr )* ; )* */
static void fields(Type ty) {
	int n = 0, bits, off, overflow = 0;
	Field p, *q;

	while (kind[t] == CHAR
	|| t == ID && tsym && tsym->sclass == TYPEDEF) {
		static char follow[] = { IF, CHAR, '}', 0 };
		Type ty1 = type(0, (int *)0);
		do {
			char *id = 0;
			Type fty;
			if ((fty = dclr(ty1, &id, 1)) == 0)
				fty = ty1;
			if (Aflag >= 1 && !hasproto(fty))
				warning("missing prototype\n");
			p = newfield(id, ty, fty);	/* refme */
			if (t == ':') {
				fty = unqual(fty);
				if (isenum(fty))
					fty = fty->type;
				if (fty != inttype && fty != unsignedtype) {
					error("`%t' is an illegal bit field type\n", p->type);
					p->type = inttype;
				}
				t = gettok();
				p->to = intexpr(0, 0);
				if (p->to > 8*inttype->size || p->to < 0) {
					error("`%d' is an illegal bit field size\n", p->to);
					p->to = 8*inttype->size;
				} else if (p->to == 0 && id) {
					warning("extraneous 0-width bit field `%t %s' ignored\n",
						p->type, id);
					p->name = stringd(genlabel(1));
				}
				p->to++;
			} else if (id == 0 && isstruct(p->type)) {
				if (Aflag >= 2)
					warning("non-ANSI unnamed substructure in `%t'\n", ty);
				if (p->type->size == 0)
					error("undefined size for field `%t'\n", p->type);
				p->name = 0;
				break;
			} else {
				if (id == 0)
					error("field name missing\n");
				else if (p->type->size == 0)
					error("undefined size for field `%t %s'\n", p->type, id);
			}
			n++;
			if (Aflag >= 2 && n == 128)
				warning("more than 127 fields in `%t'\n", ty);
		} while (t == ',' && (t = gettok()));
		test(';', follow);
	}
	ty->align = STRUCT_ALIGN;
	off = bits = 0;
#define add(x,n) (x > INT_MAX - (n) ? (overflow = 1, x) : x + n)
	q = &ty->u.sym->u.s.flist;
	for (p = *q; p; p = p->link) {
		int a = p->type->align ? p->type->align : 1;
		if (ty->op == UNION) {
			if (p->to)
				a = unsignedtype->align;
			bits = 0;
		} else if (bits == 0 || p->to <= 1
		|| bits - 1 + p->to - 1 > 8*unsignedtype->size) {
			if (bits)
				off = add(off, (bits + 6)/8);
			if (p->to)
				a = unsignedtype->align;
			add(off, a - 1);
			off = roundup(off, a);
			bits = 0;
		}
		if (a > ty->align)
			ty->align = a;
		p->offset = off;
		if (p->to) {
			if (bits == 0)
				bits = 1;
			p->from = bits - 1;
			p->to = p->from + p->to - 1;
			bits += p->to - p->from;
			if (ty->op == UNION && (bits + 6)/8 > ty->size)
				ty->size = (bits + 6)/8;
		} else if (ty->op == STRUCT)
			off = add(off, p->type->size);
		else if (p->type->size > ty->size)
			ty->size = p->type->size;
		if (isconst(p->type))
			ty->u.sym->u.s.cfields = 1;
		if (isvolatile(p->type))
			ty->u.sym->u.s.vfields = 1;
		if (p->name == 0 || *p->name > '9') {
			*q = p;
			q = &p->link;
		}
	}
	*q = 0;
	if (bits)
		off = add(off, (bits + 6)/8);
	if (ty->op == STRUCT)
		ty->size = off;
	else if (off > ty->size)
		ty->size = off;
	add(ty->size, ty->align - 1);
	ty->size = roundup(ty->size, ty->align);
	if (overflow) {
		error("size of `%t' exceeds %d bytes\n", ty, INT_MAX);
		ty->size = INT_MAX&(~(ty->align - 1));
	}
	checkfields(ty);
}

/* finalize - finalize tentative definitions, constants, check unref'd statics */
void finalize() {
	if (xref) {
		setuses(identifiers);
		foreach(types, level, fielduses, (Generic)0);
		setuses(types);
	}
	foreach(identifiers, GLOBAL, doglobal, (Generic)0);
	foreach(externals, GLOBAL, doextern, (Generic)0);
	foreach(identifiers, GLOBAL, checkref, (Generic)0);
	foreach(constants, CONSTANTS, doconst, (Generic)0);
}

dclproto(static void fillcallees,(Symbol, Generic));
static void fillcallees(Symbol p, Generic cl) {
	*(List *)cl = append(p, *(List *)cl);
}

/* funcdecl - ... ( ... ) decl* compound */
static void funcdecl(int sclass, char *id, Type ty, Coordinate pt) {
	int i, n;
	Code rp;
	Symbol *callee, *caller, p;
	List callees = 0;

	regcount = 0;
	if (isstruct(freturn(ty)) && freturn(ty)->size == 0)
		error("illegal use of incomplete type `%t'\n", freturn(ty));
	callees = 0;
	foreach(identifiers, PARAM, fillcallees, (Generic)&callees);
	n = length(callees);
	if (Aflag >= 2 && n > 31)
		warning("more than 31 parameters in function `%s'\n", id);
	caller = (Symbol *)list_to_a(callees, (Generic *)0);
	callee = (Symbol *)talloc((n + 1)*sizeof *caller);
	for (i = 0; p = caller[i]; i++) {
		callee[--n] = p;
		caller[i] = (Symbol)talloc(sizeof *caller[i]);
		if (*p->name >= '1' && *p->name <= '9')
			error("missing parameter name to function `%s'\n", id);
	}
	callee[i] = 0;
	if (ty->u.proto)
		ty = newstyle(ty, caller, callee);
	else
		ty = oldstyle(id, ty, caller, callee);
	if (Aflag >= 1 && !hasproto(ty))
		warning("missing prototype\n");
	for (i = 0; p = callee[i]; i++)
		if (p->type->size == 0) {
			error("undefined size for parameter `%t %s'\n", p->type, p->name);
			caller[i]->type = p->type = inttype;
		}
	if ((p = lookup(id, identifiers)) && isfunc(p->type)) {
		if (p->defined)
			error("redefinition of `%s' previously defined at %w\n",
				p->name, &p->src);
		if (xref)
			use(p, p->src);
	}
	cfunc = dclglobal(sclass, id, ty, &pt);
	cfunc->u.f.pt[0] = pt;
	if (JUMP_ON_RETURN || glevel > 1)
		cfunc->u.f.label = genlabel(1);
	cfunc->u.f.callee = callee;
	cfunc->defined = 1;
	if (Pflag)
		printproto(cfunc, cfunc->u.f.callee);
	labels[0] = table(0, LABELS);
	labels[1] = table(0, LABELS);
	refinc = 1000;
	bnumber = -1;
	codelist = &codehead;
	codelist->next = 0;
	if (ncalled >= 0)
		ncalled = findfunc(cfunc->name, pt.file);
	cfunc->u.f.pt[2] = definept(0)->u.point.src;
	compound(0, (struct swtch *)0, 0);
	for (rp = codelist; rp->kind < Label; rp = rp->prev)
		;
	if (rp->kind != Jump) {
		if (cfunc->u.f.label == 0)
			definept(0);
		if (freturn(cfunc->type) != voidtype
		&& (freturn(cfunc->type) != inttype || Aflag >= 1))
			warning("missing return value\n");
		retcode(0, 0);
	}
	if (cfunc->u.f.label) {
		definelab(cfunc->u.f.label);
		definept(0);
		walk(0, 0, 0);
	}
	exitscope();
	foreach(identifiers, level, checkref, (Generic)0);
	flushequ();
	swtoseg(CODE);
	if (cfunc->sclass != STATIC)
		export(cfunc);
	if (glevel) {
		stabsym(cfunc);
		swtoseg(CODE);
	}
	for (i = 0; caller[i]; i++) {
		if (glevel > 1)
			callee[i]->sclass = AUTO;
#ifdef NOARGB
		if (isstruct(caller[i]->type)) {
			caller[i]->type = ptr(caller[i]->type);
			callee[i]->type = ptr(callee[i]->type);
			caller[i]->structarg = callee[i]->structarg = 1;
		}
#endif
	}
	function(cfunc, caller, callee, cfunc->u.f.ncalls);
	if (glevel)
		stabfend(cfunc, lineno);
	outflush();
	cfunc->u.f.pt[1] = src;
	expect('}');
	setuses(labels[0]);
	foreach(labels[0], LABELS, checklab, (Generic)0);
	if (events.exit)
		apply(events.exit, (Generic)cfunc, (Generic)0);
	exitscope();
	retv = 0;
	tfree();
	cfunc = 0;
}

/* newstyle - process function arguments for new-style definition */
static Type newstyle(Type ty, Symbol caller[], Symbol callee[]) {
	int i;

	for (i = 0; callee[i]; i++) {
		*caller[i] = *callee[i];
		caller[i]->type = promote(callee[i]->type);
		if (callee[i]->sclass == REGISTER) {
			caller[i]->sclass = AUTO;
			++regcount;
		}
	}
	return ty;
}

/* oldparam - check that p is an old-style parameter, and patch callee[i] */
static void oldparam(Symbol p, Generic cl) {
	Symbol *callee = (Symbol *)cl;
	int i;

	for (i = 0; callee[i]; i++)
		if (p->name == callee[i]->name) {
			callee[i] = p;
			return;
		}
	error("declared parameter `%s' is missing\n", p->name);
}

/* oldstyle - process function arguments for old-style definition */
static Type oldstyle(char *name, Type ty, Symbol caller[], Symbol callee[]) {
	int i;
	Symbol p;

	while (kind[t] == CHAR || kind[t] == STATIC
	|| t == ID && tsym && tsym->sclass == TYPEDEF)
		decl(dclparam, 1);
	foreach(identifiers, PARAM, oldparam, (Generic)callee);
	for (i = 0; p = callee[i]; i++) {
		if (p->type == 0) {
			p->type = inttype;
			p->defined = 1;
		}
		*caller[i] = *p;
		if (p->sclass == REGISTER) {
			caller[i]->sclass = AUTO;
			++regcount;
		}
		if (unqual(p->type) == floattype)
			caller[i]->type = doubletype;
		else
			caller[i]->type = promote(p->type);
	}
	if ((p = lookup(name, identifiers)) && p->scope == GLOBAL
	&& isfunc(p->type) && p->type->u.proto) {
		Type *proto = p->type->u.proto;
		for (i = 0; caller[i] && *proto; proto++, i++)
			if (eqtype(unqual(*proto), unqual(caller[i]->type), 1) == 0)
				break;
		if (*proto && (*proto != voidtype || proto != p->type->u.proto) || caller[i])
			error("conflicting argument declarations for function `%s'\n", name);
		ty = func(freturn(ty), p->type->u.proto);
	} else
		ty = func(freturn(ty), 0);
	return ty;
}
/* parameters - [id ( , id )* | type dclr ( , type dclr )*] */
static Type *parameters(int lev) {
	Type *proto = 0;

	enterscope();
	if (kind[t] == CHAR || kind[t] == STATIC
	|| t == ID && tsym && tsym->sclass == TYPEDEF) {
		int sclass, n = 0;
		Type last = 0, ty;
		List list = 0;
		for (;;) {
			Symbol p;
			char *id = 0;
			n++;
			if (last && t == ELLIPSIS) {
				if (last == voidtype)
					error("illegal formal parameter types\n");
				list = append(voidtype, list);
				t = gettok();
				break;
			}
			if (t == ID && (tsym == 0 || tsym->sclass != TYPEDEF)
			||  t != ID && t != REGISTER && kind[t] != CHAR)
				error("missing parameter type\n");
			ty = dclr(type(PARAM, &sclass), &id, lev + 1);
			if (Aflag >= 1 && !hasproto(ty))
				warning("missing prototype\n");
			if (ty == voidtype && (last || id))
				error("illegal formal parameter types\n");
			if (id == 0)
				id = stringd(n);
			if (ty == voidtype)
				list = append(voidtype, list);
			else {
				p = dclparam(sclass, id, ty, &src);
				list = append(p->type, list);
			}
			last = ty;
			if (t != ',')
				break;
			t = gettok();
		}
		proto = (Type *)list_to_a(list, (Generic *)alloc((n + 1)*sizeof (Type)));
	} else if (t == ID) {
		for (;;) {
			if (t != ID) {
				error("expecting an identifier\n");
				break;
			}
			dclparam(0, token, (Type)0, &src);
			t = gettok();
			if (t != ',')
				break;
			t = gettok();
		}
	}
	if (t != ')') {
		static char follow[] = { CHAR, STATIC, IF, ')', 0 };
		expect(')');
		skipto('{', follow);
	}
	if (t == ')')
		t = gettok();
	return proto;
}
/* checkparam - check for old-style param list; called at ends of parameters */
static void checkparam(Symbol p, Generic cl) {
	if (p->type == 0)
		error("extraneous specification for formal parameter `%s'\n", p->name);
}
/* program - decl* */
void program() {
	int n;

	level = GLOBAL;
	for (n= 0; t != EOI; n++)
		if (kind[t] == CHAR || kind[t] == STATIC || t == ID)
			decl(dclglobal, 0);
		else {
			if (t == ';')
				warning("empty declaration\n");
			else
				error("unrecognized declaration\n");
			t = gettok();
		}
	if (n == 0)
		warning("empty input file\n");
}

/* structdcl - ( struct | union )  ( [ id ] { ( field; )+ } | id ) */
static Type structdcl(int op) {
	char *tag;
	Type ty;
	Symbol p;
	Coordinate pos;

	t = gettok();
	if (t == ID) {
		tag = token;
		pos = src;
		t = gettok();
	} else
		tag = string("");
	if (t == '{') {
		static char follow[] = { IF, ',', 0 };
		ty = newstruct(op, tag);
		if (*tag)
			ty->u.sym->src = pos;
		t = gettok();
		if (kind[t] == CHAR || t == ID && tsym
		&& tsym->sclass == TYPEDEF)
			fields(ty);
		else
			error("invalid %k field declarations\n", op);
		test('}', follow);
		ty->u.sym->defined = 1;
	} else if (*tag && (p = lookup(tag, types)) && p->type->op == op) {
		if (t == ';' && p->scope < level)
			ty = newstruct(op, tag);
		if (xref)
			use(p, pos);
		ty = p->type;
	} else {
		if (*tag == 0)
			error("missing %k tag\n", op);
		ty = newstruct(op, tag);
		if (*tag && xref)
			use(ty->u.sym, pos);
	}
	return ty;
}

/* tnode - allocate a type node */
static Type tnode(int op, Type type) {
	Type ty = (Type) talloc(sizeof *ty);

	ty->op = op;
	ty->type = type;
	return ty;
}

/* type - parse basic storage class and type specification */
static Type type(int lev, int *sclass) {
	int cls, cons, *p, sign, size, tt, type, vol;
	Type ty = 0;

	if (sclass == 0)
		cls = AUTO;
	else
		*sclass = 0;
	for (vol = cons = sign = size = type = 0;;) {
		p = &type;
		tt = t;
		switch (t) {
		case AUTO: case REGISTER: case STATIC:
		case EXTERN: case TYPEDEF:
			p = sclass ? sclass : &cls;
			break;
		case CONST:
			p = &cons;
			break;
		case VOLATILE:
			p = &vol;
			break;
		case SIGNED: case UNSIGNED:
			p = &sign;
			break;
		case LONG: case SHORT:
			p = &size;
			break;
		case VOID: case CHAR: case INT: case FLOAT: case DOUBLE:
			ty = tsym->type;
			break;
		case ENUM:
			ty = enumdecl();
			break;
		case STRUCT: case UNION:
			ty = structdcl(t);
			break;
		case ID:
			if (tsym && tsym->sclass == TYPEDEF
			&& type == 0 && size == 0 && sign == 0) {
				use(tsym, src);
				ty = tsym->type;
				t = tt = ty->op;
				break;
			}
			/* fall through */
		default:
			p = 0;
		}
		if (p == 0)
			break;
		if (*p)
			error("invalid use of `%k'\n", tt);
		*p = tt;
		if (t == tt)
			t = gettok();
	}
	if (sclass && *sclass
	&& (lev == 0
	||  lev == PARAM  && *sclass != REGISTER
	||  lev == GLOBAL && *sclass == REGISTER))
		error("invalid use of `%k'\n", *sclass);
	if (type == 0) {
		type = INT;
		ty = inttype;
	}
	if (size == SHORT && type != INT
	||  size == LONG  && type != INT && type != DOUBLE
	||  sign && type != INT && type != CHAR)
		error("invalid type specification\n");
	if (type == CHAR && sign)
		ty = sign == UNSIGNED ? unsignedchar : signedchar;
	else if (size == SHORT)
		ty = sign == UNSIGNED ? unsignedshort : shorttype;
	else if (size == LONG && type == DOUBLE)
		ty = longdouble;
	else if (size == LONG)
		ty = sign == UNSIGNED ? unsignedlong : longtype;
	else if (sign == UNSIGNED && type == INT)
		ty = unsignedtype;
	if (cons == CONST)
		ty = qual(CONST, ty);
	if (vol == VOLATILE)
		ty = qual(VOLATILE, ty);
	return ty;
}

/* typename - type dclr */
Type typename() {
	Type ty = type(0, (int *)0);

	if (t == '*' || t == '(' || t == '[') {
		ty = dclr(ty, (char **)0, 1);
		if (Aflag >= 1 && !hasproto(ty))
			warning("missing prototype\n");
	}
	return ty;
}
