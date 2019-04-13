/* C compiler: lexical analysis */

#include "c.h"
extern double strtod(const char *, char **);

char kind[] = {		/* token kind, i.e., classification */
#define xx(a,b,c,d,e,f,g) f,
#include "token.h"
};
Coordinate src;		/* current source coordinate */
#ifdef __STDC__
enum tokencode t;
#else
int t;
#endif
char *token;		/* current token */
Symbol tsym;		/* symbol table entry for current token */

static struct symbol tval;	/* symbol for constants */

#ifdef __STDC__
enum { BLANK=01, NEWLINE=02, LETTER=04, DIGIT=010, HEX=020, BAD=040 };
#else
#define BLANK	01
#define NEWLINE	02
#define	LETTER	04
#define DIGIT	010
#define HEX	020
#define	BAD	040	/* non-portable characters */
#endif

static unsigned char map[256] = {
/* 000 nul */	BAD,
/* 001 soh */	BAD,
/* 002 stx */	BAD,
/* 003 etx */	BAD,
/* 004 eot */	BAD,
/* 005 enq */	BAD,
/* 006 ack */	BAD,
/* 007 bel */	BAD,
/* 010 bs  */	BLANK|BAD,
/* 011 ht  */	BLANK,
/* 012 nl  */	NEWLINE,
/* 013 vt  */	BLANK,
/* 014 ff  */	BLANK,
/* 015 cr  */	BAD,
/* 016 so  */	BAD,
/* 017 si  */	BAD,
/* 020 dle */	BAD,
/* 021 dc1 */	BAD,
/* 022 dc2 */	BAD,
/* 023 dc3 */	BAD,
/* 024 dc4 */	BAD,
/* 025 nak */	BAD,
/* 026 syn */	BAD,
/* 027 etb */	BAD,
/* 030 can */	BAD,
/* 031 em  */	BAD,
/* 032 sub */	BAD,
/* 033 esc */	BAD,
/* 034 fs  */	BAD,
/* 035 gs  */	BAD,
/* 036 rs  */	BAD,
/* 037 us  */	BAD,
/* 040 sp  */	BLANK,
/* 041 !   */	0,
/* 042 "   */	0,
/* 043 #   */	0,
/* 044 $   */	BAD,
/* 045 %   */	0,
/* 046 &   */	0,
/* 047 '   */	0,
/* 050 (   */	0,
/* 051 )   */	0,
/* 052 *   */	0,
/* 053 +   */	0,
/* 054 ,   */	0,
/* 055 -   */	0,
/* 056 .   */	0,
/* 057 /   */	0,
/* 060 0   */	DIGIT,
/* 061 1   */	DIGIT,
/* 062 2   */	DIGIT,
/* 063 3   */	DIGIT,
/* 064 4   */	DIGIT,
/* 065 5   */	DIGIT,
/* 066 6   */	DIGIT,
/* 067 7   */	DIGIT,
/* 070 8   */	DIGIT,
/* 071 9   */	DIGIT,
/* 072 :   */	0,
/* 073 ;   */	0,
/* 074 <   */	0,
/* 075 =   */	0,
/* 076 >   */	0,
/* 077 ?   */	0,
/* 100 @   */	BAD,
/* 101 A   */	LETTER|HEX,
/* 102 B   */	LETTER|HEX,
/* 103 C   */	LETTER|HEX,
/* 104 D   */	LETTER|HEX,
/* 105 E   */	LETTER|HEX,
/* 106 F   */	LETTER|HEX,
/* 107 G   */	LETTER,
/* 110 H   */	LETTER,
/* 111 I   */	LETTER,
/* 112 J   */	LETTER,
/* 113 K   */	LETTER,
/* 114 L   */	LETTER,
/* 115 M   */	LETTER,
/* 116 N   */	LETTER,
/* 117 O   */	LETTER,
/* 120 P   */	LETTER,
/* 121 Q   */	LETTER,
/* 122 R   */	LETTER,
/* 123 S   */	LETTER,
/* 124 T   */	LETTER,
/* 125 U   */	LETTER,
/* 126 V   */	LETTER,
/* 127 W   */	LETTER,
/* 130 X   */	LETTER,
/* 131 Y   */	LETTER,
/* 132 Z   */	LETTER,
/* 133 [   */	0,
/* 134 \   */	0,
/* 135 ]   */	0,
/* 136 ^   */	0,
/* 137 _   */	LETTER,
/* 140 `   */	BAD,
/* 141 a   */	LETTER|HEX,
/* 142 b   */	LETTER|HEX,
/* 143 c   */	LETTER|HEX,
/* 144 d   */	LETTER|HEX,
/* 145 e   */	LETTER|HEX,
/* 146 f   */	LETTER|HEX,
/* 147 g   */	LETTER,
/* 150 h   */	LETTER,
/* 151 i   */	LETTER,
/* 152 j   */	LETTER,
/* 153 k   */	LETTER,
/* 154 l   */	LETTER,
/* 155 m   */	LETTER,
/* 156 n   */	LETTER,
/* 157 o   */	LETTER,
/* 160 p   */	LETTER,
/* 161 q   */	LETTER,
/* 162 r   */	LETTER,
/* 163 s   */	LETTER,
/* 164 t   */	LETTER,
/* 165 u   */	LETTER,
/* 166 v   */	LETTER,
/* 167 w   */	LETTER,
/* 170 x   */	LETTER,
/* 171 y   */	LETTER,
/* 172 z   */	LETTER,
/* 173 {   */	0,
/* 174 |   */	0,
/* 175 }   */	0,
/* 176 ~   */	0,
/* 177 del */	BAD,
/* 200     */	BAD,
/* 201     */	BAD,
/* 202     */	BAD,
/* 203     */	BAD,
/* 204     */	BAD,
/* 205     */	BAD,
/* 206     */	BAD,
/* 207     */	BAD,
/* 210     */	BAD,
/* 211     */	BAD,
/* 212     */	BAD,
/* 213     */	BAD,
/* 214     */	BAD,
/* 215     */	BAD,
/* 216     */	BAD,
/* 217     */	BAD,
/* 220     */	BAD,
/* 221     */	BAD,
/* 222     */	BAD,
/* 223     */	BAD,
/* 224     */	BAD,
/* 225     */	BAD,
/* 226     */	BAD,
/* 227     */	BAD,
/* 230     */	BAD,
/* 231     */	BAD,
/* 232     */	BAD,
/* 233     */	BAD,
/* 234     */	BAD,
/* 235     */	BAD,
/* 236     */	BAD,
/* 237     */	BAD,
/* 240     */	BAD,
/* 241     */	BAD,
/* 242     */	BAD,
/* 243     */	BAD,
/* 244     */	BAD,
/* 245     */	BAD,
/* 246     */	BAD,
/* 247     */	BAD,
/* 250     */	BAD,
/* 251     */	BAD,
/* 252     */	BAD,
/* 253     */	BAD,
/* 254     */	BAD,
/* 255     */	BAD,
/* 256     */	BAD,
/* 257     */	BAD,
/* 260     */	BAD,
/* 261     */	BAD,
/* 262     */	BAD,
/* 263     */	BAD,
/* 264     */	BAD,
/* 265     */	BAD,
/* 266     */	BAD,
/* 267     */	BAD,
/* 270     */	BAD,
/* 271     */	BAD,
/* 272     */	BAD,
/* 273     */	BAD,
/* 274     */	BAD,
/* 275     */	BAD,
/* 276     */	BAD,
/* 277     */	BAD,
/* 300     */	BAD,
/* 301     */	BAD,
/* 302     */	BAD,
/* 303     */	BAD,
/* 304     */	BAD,
/* 305     */	BAD,
/* 306     */	BAD,
/* 307     */	BAD,
/* 310     */	BAD,
/* 311     */	BAD,
/* 312     */	BAD,
/* 313     */	BAD,
/* 314     */	BAD,
/* 315     */	BAD,
/* 316     */	BAD,
/* 317     */	BAD,
/* 320     */	BAD,
/* 321     */	BAD,
/* 322     */	BAD,
/* 323     */	BAD,
/* 324     */	BAD,
/* 325     */	BAD,
/* 326     */	BAD,
/* 327     */	BAD,
/* 330     */	BAD,
/* 331     */	BAD,
/* 332     */	BAD,
/* 333     */	BAD,
/* 334     */	BAD,
/* 335     */	BAD,
/* 336     */	BAD,
/* 337     */	BAD,
/* 340     */	BAD,
/* 341     */	BAD,
/* 342     */	BAD,
/* 343     */	BAD,
/* 344     */	BAD,
/* 345     */	BAD,
/* 346     */	BAD,
/* 347     */	BAD,
/* 350     */	BAD,
/* 351     */	BAD,
/* 352     */	BAD,
/* 353     */	BAD,
/* 354     */	BAD,
/* 355     */	BAD,
/* 356     */	BAD,
/* 357     */	BAD,
/* 360     */	BAD,
/* 361     */	BAD,
/* 362     */	BAD,
/* 363     */	BAD,
/* 364     */	BAD,
/* 365     */	BAD,
/* 366     */	BAD,
/* 367     */	BAD,
/* 370     */	BAD,
/* 371     */	BAD,
/* 372     */	BAD,
/* 373     */	BAD,
/* 374     */	BAD,
/* 375     */	BAD,
/* 376     */	BAD,
/* 377     */	BAD,
};

dclproto(static char *asmargs,(Symbol, Symbol [], int));
dclproto(static void assem,(void));
dclproto(static int backslash,(int));
dclproto(static Symbol fcon,(void));
dclproto(static Symbol icon,(unsigned int, int));

/* asmargs - break out %name in string p, fill in argv, returned edited string */
static char *asmargs(p, argv, size) Symbol p, argv[]; int size; {
	int n = 0;
	char *s1, *s2, str[MAXLINE];

	if (p->type->size >= MAXLINE) {
		error("asm string too long\n");
		return "";
	}
	for (s2 = str, s1 = p->u.c.v.p; *s1; )
		if ((*s2++ = *s1++) == '%' && *s1 && map[(int)*s1]&LETTER) {
			char *t = s1;
			while (*t && map[(int)*t]&(LETTER|DIGIT))
				t++;
			if ((argv[n] = lookup(stringn(s1, t - s1), identifiers))
			&& argv[n]->sclass != TYPEDEF && argv[n]->sclass != ENUM) {
				argv[n]->ref += refinc;
				argv[n]->initialized = 1;	/* in case ref overflows */
				if (++n == size) {
					error("too many variable references in asm string\n");
					n = size - 1;
				} else {
					*s2++ = n - 1;
					s1 = t;
				}
			}
		}
	*s2 = 0;
	argv[n] = 0;
	return stringn(str, s2 - str);
}

/* assem - parse asm("assembly code") */
static void assem() {
	if (Aflag >= 2)
		warning("non-ANSI asm\n");
	t = gettok();
	expect('(');
	if (t == SCON) {
		char *s;
		Symbol *argv = (Symbol *)talloc(11*sizeof(Symbol *));
		s = asmargs(tsym, argv, 11);
		if (fname) {
			walk(0, 0, 0);
			code(Start);	/* prevent unreachable code message */
			code(Asm);
			codelist->u.acode.code = s;
			codelist->u.acode.argv = argv;
		} else
			asmcode(s, argv);
		t = gettok();
	} else
		error("missing string constant in asm\n");
	if (t != ')')
		expect(')');
}

/* backslash - get next character with \'s interpreted in q ... q */
static int backslash(int q) {
	int c;

	switch (*cp++) {
	case 'a': return 7;
	case 'b': return '\b';
	case 'f': return '\f';
	case 'n': return '\n';
	case 'r': return '\r';
	case 't': return '\t';
	case 'v': return '\v';
	case '\'': case '"': case '\\': case '\?': break;
	case 'x': {
		int overflow = 0;
		if ((map[*cp]&(DIGIT|HEX)) == 0) {
			if (*cp < ' ' || *cp == 0177)
				error("ill-formed hexadecimal escape sequence\n");
			else
				error("ill-formed hexadecimal escape sequence `\\x%c'\n", *cp);
			if (*cp != q)
				cp++;
			return 0;
		}
		for (c = 0; map[*cp]&(DIGIT|HEX); cp++) {
			if (c&~((unsigned)-1 >> 4))
				overflow++;
			if (map[*cp]&DIGIT)
				c = (c<<4) + *cp - '0';
			else
				c = (c<<4) + (*cp&~040) - 'A' + 10;
		}
		if (c&~0377 || overflow)
			warning("overflow in hexadecimal escape sequence\n");
		return c&0377;
		}
	case '0': case '1': case '2': case '3':
	case '4': case '5': case '6': case '7':
		c = *(cp-1) - '0';
		if (*cp >= '0' && *cp <= '7') {
			c = (c<<3) + *cp++ - '0';
			if (*cp >= '0' && *cp <= '7')
				c = (c<<3) + *cp++ - '0';
		}
		if (c&~0377)
			warning("overflow in octal escape sequence\n");
		return c&0377;
	default:
		if (cp[-1] < ' ' || cp[-1] >= 0177)
			warning("unrecognized character escape sequence\n");
		else
			warning("unrecognized character escape sequence `\\%c'\n", cp[-1]);
	}
	return cp[-1];
}

#ifdef strtod
#define ERANGE 1
static int errno;
#else
#include <errno.h>
#endif

/* fcon - scan for tail of a floating constant, set token, return symbol */
static Symbol fcon() {
	char *s = token;
	int n = 0;

	while (s < (char *)cp)
		n += *s++ - '0';
	if (*cp == '.')
		for (cp++; map[*cp]&DIGIT; cp++)
			n += *cp - '0';
	if (*cp == 'e' || *cp == 'E') {
		if (*++cp == '-' || *cp == '+')
			cp++;
		if (map[*cp]&DIGIT)
			do cp++; while (map[*cp]&DIGIT);
		else
			error("invalid floating constant\n");
	}
	if (n == 0)
		tval.u.c.v.d = 0.0;
	else {
		char c = *cp;
		*cp = 0;
		errno = 0;
		tval.u.c.v.d = strtod(token, (char **)0);
		if (errno == ERANGE)
			warning("overflow in floating constant `%s'\n", token);
		*cp = c;
	}
	if (*cp == 'f' || *cp == 'F') {
		char c = *++cp;
		*cp = 0;
		if (tval.u.c.v.d > FLT_MAX)
			warning("overflow in floating constant `%s'\n", token);
		tval.type = floattype;
		tval.u.c.v.f = tval.u.c.v.d;
		*cp = c;
	} else if (*cp == 'l' || *cp == 'L') {
		cp++;
		tval.type = longdouble;
	} else
		tval.type = doubletype;
	return &tval;
}

/* getchr - return next significant character */
int getchr() {
	while (*cp) {
		while (map[*cp]&BLANK)
			cp++;
		if (!(map[*cp]&NEWLINE))
			return *cp;
		cp++;
		nextline();
	}
	return EOI;
}

/* gettok - return next token */
int gettok() {
	static char cbuf[BUFSIZE+1];

	while (*cp) {
		register unsigned char *rcp = cp;
		while (map[*rcp]&BLANK)
			rcp++;
		if (limit - rcp < MAXTOKEN) {
			cp = rcp;
			fillbuf();
			rcp = cp;
		}
		src.file = file;			/* omit */
		src.x = (char *)rcp - line;
		src.y = lineno;
		switch (*rcp++) {
		case '\n': case '\v': case '\r': case '\f':
			cp = rcp;
			nextline();
			continue;
		case '/':
			if (*rcp == '*') {
				int c = 0;
				for (rcp++; *rcp && (*rcp != '/' || c != '*');)
					if (map[*rcp]&NEWLINE) {
						if (rcp < limit)
							c = *rcp;
						cp = rcp + 1;
						nextline();
						rcp = cp;
					} else
						c = *rcp++;
				if (*rcp)
					rcp++;
				else
					error("unclosed comment\n");
				cp = rcp;
				continue;
			}
			cp = rcp;
			return '/';
		case '.':
			if (rcp[0] == '.' && rcp[1] == '.') {
				cp = rcp + 2;
				return ELLIPSIS;
			}
			if (!(map[*rcp]&DIGIT)) {
				cp = rcp;
				return '.';
			}
			cp = rcp - 1;
			token = (char *)cp;
			tsym = fcon();
			return FCON;
		case '0': case '1': case '2': case '3': case '4':
		case '5': case '6': case '7': case '8': case '9': {
			int d, overflow = 0;
			unsigned int n = 0;
			token = (char *)rcp - 1;
			if (*token == '0' && (*rcp == 'x' || *rcp == 'X')) {
				while (*++rcp) {
					if (map[*rcp]&DIGIT)
						d = *rcp - '0';
					else if (*rcp >= 'a' && *rcp <= 'f')
						d = *rcp - 'a' + 10;
					else if (*rcp >= 'A' && *rcp <= 'F')
						d = *rcp - 'A' + 10;
					else
						break;
					if (n&~((unsigned)-1 >> 4))
						overflow++;
					else
						n = (n<<4) + d;
				}
				if ((char *)rcp - token <= 2)
					error("invalid hexadecimal constant\n");
				cp = rcp;
				tsym = icon(n, overflow);
				return ICON;
			} else if (*token == '0') {
				int err = 0;
				for ( ; map[*rcp]&DIGIT; rcp++) {
					if (*rcp == '8' || *rcp == '9')
						err = 1;
					if (n&~((unsigned)-1 >> 3))
						overflow++;
					else
						n = (n<<3) + (unsigned)(*rcp - '0');
				}
				if (*rcp != '.' && *rcp != 'e' && *rcp != 'E') {
					if (err)
						error("invalid octal constant\n");
					cp = rcp;
					tsym = icon(n, overflow);
					return ICON;
				}
			}
			for (n = *token - '0'; map[*rcp]&DIGIT; ) {
				d = *rcp++ - '0';
				if (n > ((unsigned)UINT_MAX - d)/10)
					overflow++;
				else
					n = 10*n + d;
			}
			if (*rcp != '.' && *rcp != 'e' && *rcp != 'E') {
				cp = rcp;
				tsym = icon(n, overflow);
				return ICON;
			}
			cp = rcp;
			tsym = fcon();
			return FCON;
			}
		case 'L':
			if (*rcp == '\'') {
				int t;
				cp = rcp;
				t = gettok();
				assert(t == ICON);
				src.x--;
				tval.type = unsignedchar;
				tval.u.c.v.uc = tval.u.c.v.i;
				return t;
			}
			if (*rcp != '"')
				goto id;
			rcp++;
			/* fall thru */
		case '\'': case '"': {
			char *s = cbuf;
			int nbad = 0;
			*s++ = *--rcp;
			cp = rcp;
			do {
				cp++;
				while (*cp && *cp != cbuf[0]) {
					int c = *cp++;
					if (map[c]&NEWLINE) {
						if (cp <= limit)
							break;
						nextline();
						continue;
					}
					if (c == '\\') {
						if (map[*cp]&NEWLINE) {
							if (cp < limit)
								break;
							cp++;
							nextline();
						}
						if (limit - cp < MAXTOKEN)
							fillbuf();
						c = backslash(cbuf[0]);
					} else if (map[c]&BAD)
						nbad++;
					if (s < &cbuf[sizeof cbuf] - 2)
                                                *s++ = c;
// FF: pour traduire vers un jeu de caractere cible:  *s++ = chartranslation[c] ;
				}
				if (*cp == cbuf[0])
					cp++;
				else
					error("missing %c\n", cbuf[0]);
			} while (cbuf[0] == '"' && getchr() == '"');
			*s++ = 0;
			if (s >= &cbuf[sizeof cbuf])
				error("%s literal too long\n",
					cbuf[0] == '"' ? "string" : "character");
			if (Aflag >= 2 && cbuf[0] == '"' && s - cbuf - 1 > 509)
				warning("more than 509 characters in a string literal\n");
			if (Aflag >= 2 && nbad)
				warning("%s literal contains non-portable characters\n",
					cbuf[0] == '"' ? "string" : "character");
			token = cbuf;
			tsym = &tval;
			if (cbuf[0] == '"') {
				tval.type = array(chartype, s - cbuf - 1, STRUCT_ALIGN);
				tval.u.c.v.p = cbuf + 1;
				return SCON;
			} else {
				if (s - cbuf > 3)
					warning("excess characters in multibyte character literal ignored\n");
				else if (s - cbuf <= 2)
					error("missing '\n");
				tval.type = inttype;
				tval.u.c.v.i = cbuf[1];
				return ICON;
			}
			}
		case '<':
			if (*rcp == '=') {
				cp = rcp + 1;
				return LEQ;
			}
			if (*rcp == '<') {
				cp = rcp + 1;
				return LSHIFT;
			}
			cp = rcp;
			return '<';
		case '>':
			if (*rcp == '=') {
				cp = rcp + 1;
				return GEQ;
			}
			if (*rcp == '>') {
				cp = rcp + 1;
				return RSHIFT;
			}
			cp = rcp;
			return '>';
		case '=':
			if (*rcp == '=') {
				cp = rcp + 1;
				return EQL;
			}
			cp = rcp;
			return '=';
		case '!':
			if (*rcp == '=') {
				cp = rcp + 1;
				return NEQ;
			}
			cp = rcp;
			return '!';
		case '|':
			if (*rcp == '|') {
				cp = rcp + 1;
				return OROR;
			}
			cp = rcp;
			return '|';
		case '&':
			if (*rcp == '&') {
				cp = rcp + 1;
				return ANDAND;
			}
			cp = rcp;
			return '&';
		case '+':
			if (*rcp == '+') {
				cp = rcp + 1;
				return INCR;
			}
			cp = rcp;
			return '+';
		case '-':
			if (*rcp == '>') {
				cp = rcp + 1;
				return DEREF;
			}
			if (*rcp == '-') {
				cp = rcp + 1;
				return DECR;
			}
			cp = rcp;
			return '-';
		case ';': case ',': case ':':
		case '*': case '~': case '%': case '^': case '?':
		case '[': case ']': case '{': case '}': case '(': case ')':
			cp = rcp;
			return *(rcp-1);
#include "keywords.h"
		id:
			token = (char *)rcp - 1;
			while (map[*rcp]&(DIGIT|LETTER))
				rcp++;
			if (rcp == limit) {
				char *s = cbuf;
				while (token < (char *)rcp)
					*s++ = *token++;
				while (rcp == limit && *rcp) {
					cp = rcp + 1;
					nextline();
					for (rcp = cp; map[*rcp]&(DIGIT|LETTER); rcp++)
						if (s < &cbuf[sizeof cbuf])
							*s++ = *rcp;
				}
				token = stringn(cbuf, s - cbuf);
				if (s == &cbuf[sizeof cbuf])
					error("identifier is too long\n");
			} else
				token = stringn(token, (char *)rcp - token);
			cp = rcp;
			tsym = lookup(token, identifiers);
			return ID;
		default:
			cp = rcp;
			if (map[cp[-1]]&BLANK)
				continue;
			if (cp[-1] < ' ' || cp[-1] >= 0177)
				error("illegal character `\\0%o'\n", cp[-1]);
			else
				error("illegal character `%c'\n", cp[-1]);
		}
	}
	return EOI;
}
/* icon - scan for tail of an integer constant n, set token, return symbol */
static Symbol icon(unsigned n, int overflow) {
	int u = 0;

	if (*cp == 'u' || *cp == 'U')
		u = *cp++;
	if (*cp == 'l' || *cp == 'L')
		cp++;
	if ((u == 0 && *cp == 'u') || *cp == 'U')
		u = *cp++;
	if (overflow) {
		char c = *cp;
		*cp = 0;
		warning("overflow in constant `%s'\n", token);
		*cp = c;
		n = INT_MAX;
	}
	if (u || n > (unsigned)INT_MAX) {
		tval.type = unsignedtype;
		tval.u.c.v.u = n;
	} else {
		tval.type = inttype;
		tval.u.c.v.i = n;
	}
	return &tval;
}
