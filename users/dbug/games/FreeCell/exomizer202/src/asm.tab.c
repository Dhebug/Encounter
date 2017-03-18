/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.3"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INCLUDE = 258,
     IF = 259,
     DEFINED = 260,
     MACRO = 261,
     MACRO_STRING = 262,
     ORG = 263,
     ERROR = 264,
     ECHO = 265,
     INCBIN = 266,
     INCLEN = 267,
     INCWORD = 268,
     RES = 269,
     WORD = 270,
     BYTE = 271,
     LDA = 272,
     LDX = 273,
     LDY = 274,
     STA = 275,
     STX = 276,
     STY = 277,
     AND = 278,
     ORA = 279,
     EOR = 280,
     ADC = 281,
     SBC = 282,
     CMP = 283,
     CPX = 284,
     CPY = 285,
     TSX = 286,
     TXS = 287,
     PHA = 288,
     PLA = 289,
     PHP = 290,
     PLP = 291,
     SEI = 292,
     CLI = 293,
     NOP = 294,
     TYA = 295,
     TAY = 296,
     TXA = 297,
     TAX = 298,
     CLC = 299,
     SEC = 300,
     RTS = 301,
     JSR = 302,
     JMP = 303,
     BEQ = 304,
     BNE = 305,
     BCC = 306,
     BCS = 307,
     BPL = 308,
     BMI = 309,
     BVC = 310,
     BVS = 311,
     INX = 312,
     DEX = 313,
     INY = 314,
     DEY = 315,
     INC = 316,
     DEC = 317,
     LSR = 318,
     ASL = 319,
     ROR = 320,
     ROL = 321,
     BIT = 322,
     SYMBOL = 323,
     STRING = 324,
     LAND = 325,
     LOR = 326,
     LNOT = 327,
     LPAREN = 328,
     RPAREN = 329,
     COMMA = 330,
     COLON = 331,
     X = 332,
     Y = 333,
     HASH = 334,
     PLUS = 335,
     MINUS = 336,
     MULT = 337,
     DIV = 338,
     MOD = 339,
     LT = 340,
     GT = 341,
     EQ = 342,
     NEQ = 343,
     ASSIGN = 344,
     GUESS = 345,
     NUMBER = 346,
     vNEG = 347
   };
#endif
/* Tokens.  */
#define INCLUDE 258
#define IF 259
#define DEFINED 260
#define MACRO 261
#define MACRO_STRING 262
#define ORG 263
#define ERROR 264
#define ECHO 265
#define INCBIN 266
#define INCLEN 267
#define INCWORD 268
#define RES 269
#define WORD 270
#define BYTE 271
#define LDA 272
#define LDX 273
#define LDY 274
#define STA 275
#define STX 276
#define STY 277
#define AND 278
#define ORA 279
#define EOR 280
#define ADC 281
#define SBC 282
#define CMP 283
#define CPX 284
#define CPY 285
#define TSX 286
#define TXS 287
#define PHA 288
#define PLA 289
#define PHP 290
#define PLP 291
#define SEI 292
#define CLI 293
#define NOP 294
#define TYA 295
#define TAY 296
#define TXA 297
#define TAX 298
#define CLC 299
#define SEC 300
#define RTS 301
#define JSR 302
#define JMP 303
#define BEQ 304
#define BNE 305
#define BCC 306
#define BCS 307
#define BPL 308
#define BMI 309
#define BVC 310
#define BVS 311
#define INX 312
#define DEX 313
#define INY 314
#define DEY 315
#define INC 316
#define DEC 317
#define LSR 318
#define ASL 319
#define ROR 320
#define ROL 321
#define BIT 322
#define SYMBOL 323
#define STRING 324
#define LAND 325
#define LOR 326
#define LNOT 327
#define LPAREN 328
#define RPAREN 329
#define COMMA 330
#define COLON 331
#define X 332
#define Y 333
#define HASH 334
#define PLUS 335
#define MINUS 336
#define MULT 337
#define DIV 338
#define MOD 339
#define LT 340
#define GT 341
#define EQ 342
#define NEQ 343
#define ASSIGN 344
#define GUESS 345
#define NUMBER 346
#define vNEG 347




/* Copy the first part of user declarations.  */
#line 28 "asm.y"

#include "int.h"
#include "parse.h"
#include "vec.h"
#include "membuf.h"
#include "log.h"
#include <stdio.h>
#define YYERROR_VERBOSE

static struct vec asm_atoms[1];


/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif

#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 140 "asm.y"
{
    i32 num;
    char *str;
    struct atom *atom;
    struct expr *expr;
}
/* Line 187 of yacc.c.  */
#line 299 "asm.tab.c"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 312 "asm.tab.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int i)
#else
static int
YYID (i)
    int i;
#endif
{
  return i;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  217
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   613

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  93
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  17
/* YYNRULES -- Number of rules.  */
#define YYNRULES  198
/* YYNRULES -- Number of states.  */
#define YYNSTATES  319

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   347

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     6,     8,    11,    15,    19,    24,    29,
      34,    39,    46,    51,    56,    58,    60,    62,    69,    74,
      79,    84,    91,   100,   104,   106,   109,   112,   115,   118,
     121,   124,   127,   130,   133,   136,   139,   142,   145,   148,
     151,   154,   157,   160,   163,   166,   169,   172,   175,   178,
     181,   184,   187,   190,   193,   196,   199,   202,   205,   208,
     211,   214,   217,   220,   223,   226,   229,   232,   235,   238,
     241,   244,   247,   250,   253,   256,   259,   262,   265,   268,
     271,   274,   277,   280,   283,   286,   289,   292,   295,   298,
     301,   304,   307,   310,   313,   316,   319,   322,   325,   328,
     331,   334,   337,   340,   343,   346,   349,   352,   355,   358,
     361,   363,   365,   367,   369,   371,   373,   375,   377,   379,
     381,   383,   385,   387,   389,   391,   393,   396,   399,   402,
     405,   408,   411,   414,   417,   420,   423,   425,   427,   429,
     431,   434,   437,   440,   443,   446,   449,   452,   455,   457,
     460,   463,   466,   469,   471,   474,   477,   480,   483,   485,
     488,   491,   494,   497,   499,   502,   505,   508,   511,   514,
     517,   520,   522,   526,   530,   533,   538,   543,   549,   555,
     559,   563,   567,   571,   575,   578,   582,   587,   594,   596,
     598,   602,   606,   609,   613,   617,   621,   625,   629
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      94,     0,    -1,    94,    95,    -1,    95,    -1,    68,    76,
      -1,    68,    89,   108,    -1,    68,    90,   108,    -1,     4,
      73,   109,    74,    -1,     8,    73,   108,    74,    -1,     9,
      73,    69,    74,    -1,    10,    73,    69,    74,    -1,    10,
      73,    69,    75,    97,    74,    -1,     3,    73,    69,    74,
      -1,     6,    73,    69,    74,    -1,    96,    -1,     7,    -1,
      98,    -1,    14,    73,   108,    75,   108,    74,    -1,    15,
      73,    97,    74,    -1,    16,    73,    97,    74,    -1,    11,
      73,    69,    74,    -1,    11,    73,    69,    75,   108,    74,
      -1,    11,    73,    69,    75,   108,    75,   108,    74,    -1,
      97,    75,   108,    -1,   108,    -1,    17,    99,    -1,    17,
     103,    -1,    17,   104,    -1,    17,   100,    -1,    17,   101,
      -1,    17,   102,    -1,    17,   106,    -1,    17,   107,    -1,
      18,    99,    -1,    18,   103,    -1,    18,   105,    -1,    18,
     100,    -1,    18,   102,    -1,    19,    99,    -1,    19,   103,
      -1,    19,   104,    -1,    19,   100,    -1,    19,   102,    -1,
      20,   103,    -1,    20,   104,    -1,    20,   100,    -1,    20,
     101,    -1,    20,   102,    -1,    20,   106,    -1,    20,   107,
      -1,    21,   103,    -1,    21,   105,    -1,    21,   100,    -1,
      22,   103,    -1,    22,   104,    -1,    22,   100,    -1,    23,
      99,    -1,    23,   103,    -1,    23,   104,    -1,    23,   100,
      -1,    23,   101,    -1,    23,   102,    -1,    23,   106,    -1,
      23,   107,    -1,    24,    99,    -1,    24,   103,    -1,    24,
     104,    -1,    24,   100,    -1,    24,   101,    -1,    24,   102,
      -1,    24,   106,    -1,    24,   107,    -1,    25,    99,    -1,
      25,   103,    -1,    25,   104,    -1,    25,   100,    -1,    25,
     101,    -1,    25,   102,    -1,    25,   106,    -1,    25,   107,
      -1,    26,    99,    -1,    26,   103,    -1,    26,   104,    -1,
      26,   100,    -1,    26,   101,    -1,    26,   102,    -1,    26,
     106,    -1,    26,   107,    -1,    27,    99,    -1,    27,   103,
      -1,    27,   104,    -1,    27,   100,    -1,    27,   101,    -1,
      27,   102,    -1,    27,   106,    -1,    27,   107,    -1,    28,
      99,    -1,    28,   103,    -1,    28,   104,    -1,    28,   100,
      -1,    28,   101,    -1,    28,   102,    -1,    28,   106,    -1,
      28,   107,    -1,    29,    99,    -1,    29,   103,    -1,    29,
     100,    -1,    30,    99,    -1,    30,   103,    -1,    30,   100,
      -1,    32,    -1,    31,    -1,    33,    -1,    34,    -1,    35,
      -1,    36,    -1,    37,    -1,    38,    -1,    39,    -1,    40,
      -1,    41,    -1,    42,    -1,    43,    -1,    44,    -1,    45,
      -1,    46,    -1,    47,   100,    -1,    48,   100,    -1,    49,
     100,    -1,    50,   100,    -1,    51,   100,    -1,    52,   100,
      -1,    53,   100,    -1,    54,   100,    -1,    55,   100,    -1,
      56,   100,    -1,    57,    -1,    58,    -1,    59,    -1,    60,
      -1,    61,   103,    -1,    61,   104,    -1,    61,   100,    -1,
      61,   101,    -1,    62,   103,    -1,    62,   104,    -1,    62,
     100,    -1,    62,   101,    -1,    63,    -1,    63,   103,    -1,
      63,   104,    -1,    63,   100,    -1,    63,   101,    -1,    64,
      -1,    64,   103,    -1,    64,   104,    -1,    64,   100,    -1,
      64,   101,    -1,    65,    -1,    65,   103,    -1,    65,   104,
      -1,    65,   100,    -1,    65,   101,    -1,    66,    -1,    66,
     103,    -1,    66,   104,    -1,    66,   100,    -1,    66,   101,
      -1,    67,   103,    -1,    67,   100,    -1,    79,   108,    -1,
     108,    -1,   108,    75,    77,    -1,   108,    75,    78,    -1,
      85,   108,    -1,    85,   108,    75,    77,    -1,    85,   108,
      75,    78,    -1,    73,   108,    75,    77,    74,    -1,    73,
     108,    74,    75,    78,    -1,   108,    80,   108,    -1,   108,
      81,   108,    -1,   108,    82,   108,    -1,   108,    83,   108,
      -1,   108,    84,   108,    -1,    81,   108,    -1,    73,   108,
      74,    -1,    12,    73,    69,    74,    -1,    13,    73,    69,
      75,   108,    74,    -1,    91,    -1,    68,    -1,   109,    71,
     109,    -1,   109,    70,   109,    -1,    72,   109,    -1,    73,
     109,    74,    -1,   108,    85,   108,    -1,   108,    86,   108,
      -1,   108,    87,   108,    -1,   108,    88,   108,    -1,     5,
      73,    68,    74,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   175,   175,   175,   176,   177,   178,   179,   180,   181,
     182,   183,   184,   185,   186,   187,   189,   190,   191,   192,
     193,   195,   197,   200,   201,   203,   204,   205,   206,   207,
     208,   209,   210,   212,   213,   214,   215,   216,   218,   219,
     220,   221,   222,   224,   225,   226,   227,   228,   229,   230,
     232,   233,   234,   236,   237,   238,   240,   241,   242,   243,
     244,   245,   246,   247,   249,   250,   251,   252,   253,   254,
     255,   256,   258,   259,   260,   261,   262,   263,   264,   265,
     267,   268,   269,   270,   271,   272,   273,   274,   276,   277,
     278,   279,   280,   281,   282,   283,   285,   286,   287,   288,
     289,   290,   291,   292,   294,   295,   296,   297,   298,   299,
     301,   302,   303,   304,   305,   306,   307,   308,   309,   310,
     311,   312,   313,   314,   315,   316,   318,   319,   320,   321,
     322,   323,   324,   325,   326,   327,   329,   330,   331,   332,
     334,   335,   336,   337,   339,   340,   341,   342,   344,   345,
     346,   347,   348,   350,   351,   352,   353,   354,   356,   357,
     358,   359,   360,   362,   363,   364,   365,   366,   368,   369,
     371,   372,   373,   374,   375,   376,   377,   378,   379,   381,
     382,   383,   384,   385,   386,   387,   388,   389,   391,   392,
     394,   395,   396,   397,   398,   399,   400,   401,   403
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "INCLUDE", "IF", "DEFINED", "MACRO",
  "MACRO_STRING", "ORG", "ERROR", "ECHO", "INCBIN", "INCLEN", "INCWORD",
  "RES", "WORD", "BYTE", "LDA", "LDX", "LDY", "STA", "STX", "STY", "AND",
  "ORA", "EOR", "ADC", "SBC", "CMP", "CPX", "CPY", "TSX", "TXS", "PHA",
  "PLA", "PHP", "PLP", "SEI", "CLI", "NOP", "TYA", "TAY", "TXA", "TAX",
  "CLC", "SEC", "RTS", "JSR", "JMP", "BEQ", "BNE", "BCC", "BCS", "BPL",
  "BMI", "BVC", "BVS", "INX", "DEX", "INY", "DEY", "INC", "DEC", "LSR",
  "ASL", "ROR", "ROL", "BIT", "SYMBOL", "STRING", "LAND", "LOR", "LNOT",
  "LPAREN", "RPAREN", "COMMA", "COLON", "X", "Y", "HASH", "PLUS", "MINUS",
  "MULT", "DIV", "MOD", "LT", "GT", "EQ", "NEQ", "ASSIGN", "GUESS",
  "NUMBER", "vNEG", "$accept", "stmts", "stmt", "atom", "exprs", "op",
  "am_im", "am_a", "am_ax", "am_ay", "am_zp", "am_zpx", "am_zpy", "am_ix",
  "am_iy", "expr", "lexpr", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,   340,   341,   342,   343,   344,
     345,   346,   347
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    93,    94,    94,    95,    95,    95,    95,    95,    95,
      95,    95,    95,    95,    95,    95,    96,    96,    96,    96,
      96,    96,    96,    97,    97,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      98,    98,    98,    98,    98,    98,    98,    98,    98,    98,
      99,   100,   101,   102,   103,   104,   105,   106,   107,   108,
     108,   108,   108,   108,   108,   108,   108,   108,   108,   108,
     109,   109,   109,   109,   109,   109,   109,   109,   109
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     2,     1,     2,     3,     3,     4,     4,     4,
       4,     6,     4,     4,     1,     1,     1,     6,     4,     4,
       4,     6,     8,     3,     1,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     1,     1,     1,
       2,     2,     2,     2,     2,     2,     2,     2,     1,     2,
       2,     2,     2,     1,     2,     2,     2,     2,     1,     2,
       2,     2,     2,     1,     2,     2,     2,     2,     2,     2,
       2,     1,     3,     3,     2,     4,     4,     5,     5,     3,
       3,     3,     3,     3,     2,     3,     4,     6,     1,     1,
       3,     3,     2,     3,     3,     3,     3,     3,     4
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,     0,     0,     0,    15,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   111,   110,   112,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   136,   137,   138,   139,     0,     0,   148,   153,
     158,   163,     0,     0,     0,     3,    14,    16,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     189,     0,     0,     0,     0,   188,    25,    28,    29,    30,
      26,    27,    31,    32,   171,     0,     0,    33,    36,    37,
      34,    35,   171,    38,    41,    42,    39,    40,    45,    46,
      47,    43,    44,    48,    49,    52,    50,    51,   171,    55,
      53,    54,    56,    59,    60,    61,    57,    58,    62,    63,
      64,    67,    68,    69,    65,    66,    70,    71,    72,    75,
      76,    77,    73,    74,    78,    79,    80,    83,    84,    85,
      81,    82,    86,    87,    88,    91,    92,    93,    89,    90,
      94,    95,    96,    99,   100,   101,    97,    98,   102,   103,
       0,   104,   106,   105,   107,   109,   108,   126,   127,   128,
     129,   130,   131,   132,   133,   134,   135,   142,   143,   140,
     141,   171,   146,   147,   144,   145,   151,   152,   149,   150,
     156,   157,   154,   155,   161,   162,   159,   160,   166,   167,
     164,   165,   169,   168,     4,     0,     0,     1,     2,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    24,     0,     0,     0,     0,   170,   184,   174,
       0,     0,     0,     0,     0,     0,     0,   174,     0,   174,
       0,     5,     6,    12,     0,   192,     0,     0,     0,     0,
       0,     0,     0,     0,     7,    13,     8,     9,    10,     0,
      20,     0,     0,    18,     0,    19,     0,     0,   185,     0,
       0,   172,   173,   179,   180,   181,   182,   183,   185,     0,
       0,   193,   194,   195,   196,   197,   191,   190,     0,     0,
       0,    23,   186,     0,     0,     0,   175,   176,   198,    11,
      21,     0,    17,     0,   178,   177,     0,   187,    22
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    64,    65,    66,   231,    67,    86,    87,    88,    89,
      90,    91,   101,    92,    93,   118,   224
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -98
static const yytype_int16 yypact[] =
{
     352,   -68,   -55,   -15,   -98,   -13,     5,    19,    24,    35,
      38,    41,    14,    21,    28,    49,    64,    78,    14,    14,
      14,    14,    14,    14,    42,    42,   -98,   -98,   -98,   -98,
     -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,
     -98,   -98,   144,   144,   144,   144,   144,   144,   144,   144,
     144,   144,   -98,   -98,   -98,   -98,    78,    78,    78,    78,
      78,    78,   116,   -61,   286,   -98,   -98,   -98,    12,     7,
      47,   144,    51,    57,    62,   144,   144,   144,    45,    63,
     -98,   144,   144,   144,   144,   -98,   -98,   -98,   -98,   -98,
     -98,   -98,   -98,   -98,   -59,   144,   144,   -98,   -98,   -98,
     -98,   -98,   -45,   -98,   -98,   -98,   -98,   -98,   -98,   -98,
     -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,    99,   -98,
     -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,
     -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,
     -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,
     -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,
     -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,
     144,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,
     -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,
     -98,   472,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,
     -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,   -98,
     -98,   -98,   -98,   -98,   -98,   144,   144,   -98,   -98,    61,
      65,     7,     7,   507,   -57,    67,   424,    68,   -43,   -32,
     482,   -24,    99,    -1,    70,    74,   139,    99,   -98,   492,
       8,   144,   144,   144,   144,   144,   435,   502,    66,    99,
      71,    99,    99,   -98,    79,   -98,    90,   -18,   144,   144,
     144,   144,     7,     7,   -98,   -98,   -98,   -98,   -98,   144,
     -98,   144,   144,   -98,   144,   -98,    76,    77,    85,    84,
      91,   -98,   -98,   -16,   -16,   -98,   -98,   -98,   -98,    75,
      80,   -98,    99,    99,    99,    99,   -98,    92,    29,   419,
     440,    99,   -98,   144,    89,   114,   -98,   -98,   -98,   -98,
     -98,   144,   -98,   457,   -98,   -98,   462,   -98,   -98
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
     -98,   -98,   134,   -98,   -73,   -98,   250,   408,   469,   172,
     421,   222,   183,   581,   590,   -12,   -97
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint16 yytable[] =
{
      94,   102,   102,    94,   233,    68,    94,    94,    94,    94,
      94,    94,   220,   262,   263,   214,   240,   264,    69,    78,
      79,   241,   242,   243,   244,   245,    78,    79,   215,   216,
     248,   268,   269,    78,    79,   241,   242,   243,   244,   245,
      78,    79,   270,   271,   191,   191,   191,   191,   191,   191,
     273,   274,   262,   263,    78,    79,   291,   223,    70,   226,
      71,    78,    79,   230,   232,   232,   243,   244,   245,   236,
     237,   238,   239,   275,   274,    80,    78,    79,    72,   221,
     222,   219,    80,   246,   247,   281,   282,    81,    83,    80,
      78,    79,    73,    82,    95,    83,    80,    74,    85,    84,
      82,    95,    83,   309,   274,    85,    96,    82,    75,    83,
      80,    76,    85,    84,    77,    95,   225,    80,   234,    85,
     227,    82,    81,    83,   255,   257,   228,   170,    78,    79,
      83,   229,    80,    85,    84,   253,   235,    95,   254,   276,
      85,   265,   267,   277,   282,    83,    80,   290,   281,    96,
     302,    95,   303,   307,   308,    85,    78,    79,   249,    83,
     304,   305,   262,    84,   288,   296,   297,   314,   306,    85,
     241,   242,   243,   244,   245,   258,   259,   260,   261,   241,
     242,   243,   244,   245,    80,    99,   105,   110,   315,    95,
     125,   133,   141,   149,   157,   165,   298,    83,   218,   117,
       0,   170,     0,   251,   252,     0,     0,    85,     0,   223,
     256,     0,    80,   278,   279,     0,     0,    95,     0,   241,
     242,   243,   244,   245,     0,    83,     0,     0,     0,   283,
     284,   285,   286,   287,     0,    85,   107,   112,     0,   121,
     127,   135,   143,   151,   159,   167,   292,   293,   294,   295,
     223,   223,     0,     0,     0,     0,     0,   232,     0,   299,
     300,     0,   301,    97,   103,     0,     0,     0,   122,   130,
     138,   146,   154,   162,   171,   174,     0,     0,   190,   195,
     199,   203,   207,   211,     0,     0,   217,     0,     0,     1,
       2,   313,     3,     4,     5,     6,     7,     8,     0,   316,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,    20,    21,    22,    23,    24,    25,    26,    27,    28,
      29,    30,    31,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,    61,    62,    63,     1,     2,     0,     3,     4,
       5,     6,     7,     8,     0,     0,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,    20,    21,    22,
      23,    24,    25,    26,    27,    28,    29,    30,    31,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    57,    58,    59,    60,    61,    62,
      63,    98,   104,   108,   115,   119,   123,   131,   139,   147,
     155,   163,   172,   175,   100,   106,   111,   116,   120,   126,
     134,   142,   150,   158,   166,   173,   176,     0,     0,     0,
     177,   178,   179,   180,   181,   182,   183,   184,   185,   186,
       0,     0,     0,     0,   187,   192,   196,   200,   204,   208,
     212,     0,     0,     0,     0,     0,     0,   189,   194,   198,
     202,   206,   210,   213,   109,     0,     0,   124,   132,   140,
     148,   156,   164,   310,   311,     0,     0,     0,   266,   241,
     242,   243,   244,   245,   241,   242,   243,   244,   245,   288,
       0,     0,     0,     0,   312,   241,   242,   243,   244,   245,
     241,   242,   243,   244,   245,   188,   193,   197,   201,   205,
     209,   317,     0,     0,     0,     0,   318,   241,   242,   243,
     244,   245,   241,   242,   243,   244,   245,   250,     0,     0,
       0,     0,   241,   242,   243,   244,   245,   272,     0,     0,
       0,     0,   241,   242,   243,   244,   245,   280,     0,     0,
       0,     0,   241,   242,   243,   244,   245,   289,     0,     0,
       0,     0,   241,   242,   243,   244,   245,   241,   242,   243,
     244,   245,   258,   259,   260,   261,   113,     0,     0,   128,
     136,   144,   152,   160,   168,   114,     0,     0,   129,   137,
     145,   153,   161,   169
};

static const yytype_int16 yycheck[] =
{
      12,    13,    14,    15,    77,    73,    18,    19,    20,    21,
      22,    23,     5,    70,    71,    76,    75,    74,    73,    12,
      13,    80,    81,    82,    83,    84,    12,    13,    89,    90,
      75,    74,    75,    12,    13,    80,    81,    82,    83,    84,
      12,    13,    74,    75,    56,    57,    58,    59,    60,    61,
      74,    75,    70,    71,    12,    13,    74,    69,    73,    71,
      73,    12,    13,    75,    76,    77,    82,    83,    84,    81,
      82,    83,    84,    74,    75,    68,    12,    13,    73,    72,
      73,    69,    68,    95,    96,    77,    78,    73,    81,    68,
      12,    13,    73,    79,    73,    81,    68,    73,    91,    85,
      79,    73,    81,    74,    75,    91,    85,    79,    73,    81,
      68,    73,    91,    85,    73,    73,    69,    68,    73,    91,
      69,    79,    73,    81,   221,   222,    69,    85,    12,    13,
      81,    69,    68,    91,    85,    74,    73,    73,    73,    69,
      91,    74,    74,    69,    78,    81,    68,    68,    77,    85,
      74,    73,    75,    78,    74,    91,    12,    13,   170,    81,
      75,    77,    70,    85,    74,   262,   263,    78,    77,    91,
      80,    81,    82,    83,    84,    85,    86,    87,    88,    80,
      81,    82,    83,    84,    68,    13,    14,    15,    74,    73,
      18,    19,    20,    21,    22,    23,   269,    81,    64,    16,
      -1,    85,    -1,   215,   216,    -1,    -1,    91,    -1,   221,
     222,    -1,    68,    74,    75,    -1,    -1,    73,    -1,    80,
      81,    82,    83,    84,    -1,    81,    -1,    -1,    -1,   241,
     242,   243,   244,   245,    -1,    91,    14,    15,    -1,    17,
      18,    19,    20,    21,    22,    23,   258,   259,   260,   261,
     262,   263,    -1,    -1,    -1,    -1,    -1,   269,    -1,   271,
     272,    -1,   274,    13,    14,    -1,    -1,    -1,    18,    19,
      20,    21,    22,    23,    24,    25,    -1,    -1,    56,    57,
      58,    59,    60,    61,    -1,    -1,     0,    -1,    -1,     3,
       4,   303,     6,     7,     8,     9,    10,    11,    -1,   311,
      14,    15,    16,    17,    18,    19,    20,    21,    22,    23,
      24,    25,    26,    27,    28,    29,    30,    31,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
      64,    65,    66,    67,    68,     3,     4,    -1,     6,     7,
       8,     9,    10,    11,    -1,    -1,    14,    15,    16,    17,
      18,    19,    20,    21,    22,    23,    24,    25,    26,    27,
      28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    57,
      58,    59,    60,    61,    62,    63,    64,    65,    66,    67,
      68,    13,    14,    15,    16,    17,    18,    19,    20,    21,
      22,    23,    24,    25,    13,    14,    15,    16,    17,    18,
      19,    20,    21,    22,    23,    24,    25,    -1,    -1,    -1,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      -1,    -1,    -1,    -1,    56,    57,    58,    59,    60,    61,
      62,    -1,    -1,    -1,    -1,    -1,    -1,    56,    57,    58,
      59,    60,    61,    62,    15,    -1,    -1,    18,    19,    20,
      21,    22,    23,    74,    75,    -1,    -1,    -1,    74,    80,
      81,    82,    83,    84,    80,    81,    82,    83,    84,    74,
      -1,    -1,    -1,    -1,    74,    80,    81,    82,    83,    84,
      80,    81,    82,    83,    84,    56,    57,    58,    59,    60,
      61,    74,    -1,    -1,    -1,    -1,    74,    80,    81,    82,
      83,    84,    80,    81,    82,    83,    84,    75,    -1,    -1,
      -1,    -1,    80,    81,    82,    83,    84,    75,    -1,    -1,
      -1,    -1,    80,    81,    82,    83,    84,    75,    -1,    -1,
      -1,    -1,    80,    81,    82,    83,    84,    75,    -1,    -1,
      -1,    -1,    80,    81,    82,    83,    84,    80,    81,    82,
      83,    84,    85,    86,    87,    88,    15,    -1,    -1,    18,
      19,    20,    21,    22,    23,    15,    -1,    -1,    18,    19,
      20,    21,    22,    23
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     4,     6,     7,     8,     9,    10,    11,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    94,    95,    96,    98,    73,    73,
      73,    73,    73,    73,    73,    73,    73,    73,    12,    13,
      68,    73,    79,    81,    85,    91,    99,   100,   101,   102,
     103,   104,   106,   107,   108,    73,    85,    99,   100,   102,
     103,   105,   108,    99,   100,   102,   103,   104,   100,   101,
     102,   103,   104,   106,   107,   100,   103,   105,   108,   100,
     103,   104,    99,   100,   101,   102,   103,   104,   106,   107,
      99,   100,   101,   102,   103,   104,   106,   107,    99,   100,
     101,   102,   103,   104,   106,   107,    99,   100,   101,   102,
     103,   104,   106,   107,    99,   100,   101,   102,   103,   104,
     106,   107,    99,   100,   101,   102,   103,   104,   106,   107,
      85,    99,   100,   103,    99,   100,   103,   100,   100,   100,
     100,   100,   100,   100,   100,   100,   100,   100,   101,   103,
     104,   108,   100,   101,   103,   104,   100,   101,   103,   104,
     100,   101,   103,   104,   100,   101,   103,   104,   100,   101,
     103,   104,   100,   103,    76,    89,    90,     0,    95,    69,
       5,    72,    73,   108,   109,    69,   108,    69,    69,    69,
     108,    97,   108,    97,    73,    73,   108,   108,   108,   108,
      75,    80,    81,    82,    83,    84,   108,   108,    75,   108,
      75,   108,   108,    74,    73,   109,   108,   109,    85,    86,
      87,    88,    70,    71,    74,    74,    74,    74,    74,    75,
      74,    75,    75,    74,    75,    74,    69,    69,    74,    75,
      75,    77,    78,   108,   108,   108,   108,   108,    74,    75,
      68,    74,   108,   108,   108,   108,   109,   109,    97,   108,
     108,   108,    74,    75,    75,    77,    77,    78,    74,    74,
      74,    75,    74,   108,    78,    74,   108,    74,    74
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
#else
static void
yy_stack_print (bottom, top)
    yytype_int16 *bottom;
    yytype_int16 *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      fprintf (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      fprintf (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The look-ahead symbol.  */
int yychar;

/* The semantic value of the look-ahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  int yystate;
  int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Look-ahead token as an internal (translated) token number.  */
  int yytoken = 0;
#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  yytype_int16 yyssa[YYINITDEPTH];
  yytype_int16 *yyss = yyssa;
  yytype_int16 *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  YYSTYPE *yyvsp;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     look-ahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to look-ahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a look-ahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the look-ahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 4:
#line 176 "asm.y"
    { new_label((yyvsp[(1) - (2)].str)); ;}
    break;

  case 5:
#line 177 "asm.y"
    { new_symbol_expr((yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 6:
#line 178 "asm.y"
    { new_symbol_expr_guess((yyvsp[(1) - (3)].str), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 7:
#line 179 "asm.y"
    { push_if_state((yyvsp[(3) - (4)].expr)); ;}
    break;

  case 8:
#line 180 "asm.y"
    { set_org((yyvsp[(3) - (4)].expr)); ;}
    break;

  case 9:
#line 181 "asm.y"
    { asm_error((yyvsp[(3) - (4)].str)); ;}
    break;

  case 10:
#line 182 "asm.y"
    { asm_echo((yyvsp[(3) - (4)].str), NULL); ;}
    break;

  case 11:
#line 183 "asm.y"
    { asm_echo((yyvsp[(3) - (6)].str), (yyvsp[(5) - (6)].atom)); ;}
    break;

  case 12:
#line 184 "asm.y"
    { asm_include((yyvsp[(3) - (4)].str)); ;}
    break;

  case 13:
#line 185 "asm.y"
    { push_macro_state((yyvsp[(3) - (4)].str)); ;}
    break;

  case 14:
#line 186 "asm.y"
    { vec_push(asm_atoms, &(yyvsp[(1) - (1)].atom)); ;}
    break;

  case 15:
#line 187 "asm.y"
    { macro_append((yyvsp[(1) - (1)].str)) ;}
    break;

  case 16:
#line 189 "asm.y"
    { (yyval.atom) = (yyvsp[(1) - (1)].atom);}
    break;

  case 17:
#line 190 "asm.y"
    { (yyval.atom) = new_res((yyvsp[(3) - (6)].expr), (yyvsp[(5) - (6)].expr)); ;}
    break;

  case 18:
#line 191 "asm.y"
    { (yyval.atom) = exprs_to_word_exprs((yyvsp[(3) - (4)].atom)); ;}
    break;

  case 19:
#line 192 "asm.y"
    { (yyval.atom) = exprs_to_byte_exprs((yyvsp[(3) - (4)].atom)); ;}
    break;

  case 20:
#line 193 "asm.y"
    {
            (yyval.atom) = new_incbin((yyvsp[(3) - (4)].str), NULL, NULL); ;}
    break;

  case 21:
#line 195 "asm.y"
    {
            (yyval.atom) = new_incbin((yyvsp[(3) - (6)].str), (yyvsp[(5) - (6)].expr), NULL); ;}
    break;

  case 22:
#line 197 "asm.y"
    {
            (yyval.atom) = new_incbin((yyvsp[(3) - (8)].str), (yyvsp[(5) - (8)].expr), (yyvsp[(7) - (8)].expr)); ;}
    break;

  case 23:
#line 200 "asm.y"
    { (yyval.atom) = exprs_add((yyvsp[(1) - (3)].atom), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 24:
#line 201 "asm.y"
    { (yyval.atom) = new_exprs((yyvsp[(1) - (1)].expr)); ;}
    break;

  case 25:
#line 203 "asm.y"
    { (yyval.atom) = new_op(0xA9, ATOM_TYPE_OP_ARG_UI8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 26:
#line 204 "asm.y"
    { (yyval.atom) = new_op(0xA5, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 27:
#line 205 "asm.y"
    { (yyval.atom) = new_op(0xB5, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 28:
#line 206 "asm.y"
    { (yyval.atom) = new_op(0xAD, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 29:
#line 207 "asm.y"
    { (yyval.atom) = new_op(0xBD, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 30:
#line 208 "asm.y"
    { (yyval.atom) = new_op(0xB9, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 31:
#line 209 "asm.y"
    { (yyval.atom) = new_op(0xA1, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 32:
#line 210 "asm.y"
    { (yyval.atom) = new_op(0xB1, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 33:
#line 212 "asm.y"
    { (yyval.atom) = new_op(0xA2, ATOM_TYPE_OP_ARG_UI8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 34:
#line 213 "asm.y"
    { (yyval.atom) = new_op(0xA6, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 35:
#line 214 "asm.y"
    { (yyval.atom) = new_op(0xB6, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 36:
#line 215 "asm.y"
    { (yyval.atom) = new_op(0xAE, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 37:
#line 216 "asm.y"
    { (yyval.atom) = new_op(0xBE, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 38:
#line 218 "asm.y"
    { (yyval.atom) = new_op(0xA0, ATOM_TYPE_OP_ARG_UI8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 39:
#line 219 "asm.y"
    { (yyval.atom) = new_op(0xA4, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 40:
#line 220 "asm.y"
    { (yyval.atom) = new_op(0xB4, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 41:
#line 221 "asm.y"
    { (yyval.atom) = new_op(0xAC, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 42:
#line 222 "asm.y"
    { (yyval.atom) = new_op(0xBC, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 43:
#line 224 "asm.y"
    { (yyval.atom) = new_op(0x85, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 44:
#line 225 "asm.y"
    { (yyval.atom) = new_op(0x95, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 45:
#line 226 "asm.y"
    { (yyval.atom) = new_op(0x8D, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 46:
#line 227 "asm.y"
    { (yyval.atom) = new_op(0x9D, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 47:
#line 228 "asm.y"
    { (yyval.atom) = new_op(0x99, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 48:
#line 229 "asm.y"
    { (yyval.atom) = new_op(0x81, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 49:
#line 230 "asm.y"
    { (yyval.atom) = new_op(0x91, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 50:
#line 232 "asm.y"
    { (yyval.atom) = new_op(0x86, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 51:
#line 233 "asm.y"
    { (yyval.atom) = new_op(0x96, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 52:
#line 234 "asm.y"
    { (yyval.atom) = new_op(0x8e, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 53:
#line 236 "asm.y"
    { (yyval.atom) = new_op(0x84, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 54:
#line 237 "asm.y"
    { (yyval.atom) = new_op(0x94, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 55:
#line 238 "asm.y"
    { (yyval.atom) = new_op(0x8c, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 56:
#line 240 "asm.y"
    { (yyval.atom) = new_op(0x29, ATOM_TYPE_OP_ARG_UI8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 57:
#line 241 "asm.y"
    { (yyval.atom) = new_op(0x25, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 58:
#line 242 "asm.y"
    { (yyval.atom) = new_op(0x35, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 59:
#line 243 "asm.y"
    { (yyval.atom) = new_op(0x2d, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 60:
#line 244 "asm.y"
    { (yyval.atom) = new_op(0x3d, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 61:
#line 245 "asm.y"
    { (yyval.atom) = new_op(0x39, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 62:
#line 246 "asm.y"
    { (yyval.atom) = new_op(0x21, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 63:
#line 247 "asm.y"
    { (yyval.atom) = new_op(0x31, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 64:
#line 249 "asm.y"
    { (yyval.atom) = new_op(0x09, ATOM_TYPE_OP_ARG_UI8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 65:
#line 250 "asm.y"
    { (yyval.atom) = new_op(0x05, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 66:
#line 251 "asm.y"
    { (yyval.atom) = new_op(0x15, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 67:
#line 252 "asm.y"
    { (yyval.atom) = new_op(0x0d, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 68:
#line 253 "asm.y"
    { (yyval.atom) = new_op(0x1d, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 69:
#line 254 "asm.y"
    { (yyval.atom) = new_op(0x19, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 70:
#line 255 "asm.y"
    { (yyval.atom) = new_op(0x01, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 71:
#line 256 "asm.y"
    { (yyval.atom) = new_op(0x11, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 72:
#line 258 "asm.y"
    { (yyval.atom) = new_op(0x49, ATOM_TYPE_OP_ARG_UI8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 73:
#line 259 "asm.y"
    { (yyval.atom) = new_op(0x45, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 74:
#line 260 "asm.y"
    { (yyval.atom) = new_op(0x55, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 75:
#line 261 "asm.y"
    { (yyval.atom) = new_op(0x4d, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 76:
#line 262 "asm.y"
    { (yyval.atom) = new_op(0x5d, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 77:
#line 263 "asm.y"
    { (yyval.atom) = new_op(0x59, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 78:
#line 264 "asm.y"
    { (yyval.atom) = new_op(0x41, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 79:
#line 265 "asm.y"
    { (yyval.atom) = new_op(0x51, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 80:
#line 267 "asm.y"
    { (yyval.atom) = new_op(0x69, ATOM_TYPE_OP_ARG_UI8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 81:
#line 268 "asm.y"
    { (yyval.atom) = new_op(0x65, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 82:
#line 269 "asm.y"
    { (yyval.atom) = new_op(0x75, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 83:
#line 270 "asm.y"
    { (yyval.atom) = new_op(0x6D, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 84:
#line 271 "asm.y"
    { (yyval.atom) = new_op(0x7D, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 85:
#line 272 "asm.y"
    { (yyval.atom) = new_op(0x79, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 86:
#line 273 "asm.y"
    { (yyval.atom) = new_op(0x61, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 87:
#line 274 "asm.y"
    { (yyval.atom) = new_op(0x71, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 88:
#line 276 "asm.y"
    { (yyval.atom) = new_op(0xe9, ATOM_TYPE_OP_ARG_UI8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 89:
#line 277 "asm.y"
    { (yyval.atom) = new_op(0xe5, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 90:
#line 278 "asm.y"
    { (yyval.atom) = new_op(0xf5, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 91:
#line 279 "asm.y"
    { (yyval.atom) = new_op(0xeD, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 92:
#line 280 "asm.y"
    { (yyval.atom) = new_op(0xfD, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 93:
#line 281 "asm.y"
    { (yyval.atom) = new_op(0xf9, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 94:
#line 282 "asm.y"
    { (yyval.atom) = new_op(0xe1, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 95:
#line 283 "asm.y"
    { (yyval.atom) = new_op(0xf1, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 96:
#line 285 "asm.y"
    { (yyval.atom) = new_op(0xc9, ATOM_TYPE_OP_ARG_UI8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 97:
#line 286 "asm.y"
    { (yyval.atom) = new_op(0xc5, ATOM_TYPE_OP_ARG_U8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 98:
#line 287 "asm.y"
    { (yyval.atom) = new_op(0xd5, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 99:
#line 288 "asm.y"
    { (yyval.atom) = new_op(0xcD, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 100:
#line 289 "asm.y"
    { (yyval.atom) = new_op(0xdD, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 101:
#line 290 "asm.y"
    { (yyval.atom) = new_op(0xd9, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 102:
#line 291 "asm.y"
    { (yyval.atom) = new_op(0xc1, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 103:
#line 292 "asm.y"
    { (yyval.atom) = new_op(0xd1, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 104:
#line 294 "asm.y"
    { (yyval.atom) = new_op(0xe0, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 105:
#line 295 "asm.y"
    { (yyval.atom) = new_op(0xe4, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 106:
#line 296 "asm.y"
    { (yyval.atom) = new_op(0xec, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 107:
#line 297 "asm.y"
    { (yyval.atom) = new_op(0xc0, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 108:
#line 298 "asm.y"
    { (yyval.atom) = new_op(0xc4, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 109:
#line 299 "asm.y"
    { (yyval.atom) = new_op(0xcc, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 110:
#line 301 "asm.y"
    { (yyval.atom) = new_op0(0x9A); ;}
    break;

  case 111:
#line 302 "asm.y"
    { (yyval.atom) = new_op0(0xBA); ;}
    break;

  case 112:
#line 303 "asm.y"
    { (yyval.atom) = new_op0(0x48); ;}
    break;

  case 113:
#line 304 "asm.y"
    { (yyval.atom) = new_op0(0x68); ;}
    break;

  case 114:
#line 305 "asm.y"
    { (yyval.atom) = new_op0(0x08); ;}
    break;

  case 115:
#line 306 "asm.y"
    { (yyval.atom) = new_op0(0x28); ;}
    break;

  case 116:
#line 307 "asm.y"
    { (yyval.atom) = new_op0(0x78); ;}
    break;

  case 117:
#line 308 "asm.y"
    { (yyval.atom) = new_op0(0x58); ;}
    break;

  case 118:
#line 309 "asm.y"
    { (yyval.atom) = new_op0(0xea); ;}
    break;

  case 119:
#line 310 "asm.y"
    { (yyval.atom) = new_op0(0x98); ;}
    break;

  case 120:
#line 311 "asm.y"
    { (yyval.atom) = new_op0(0xa8); ;}
    break;

  case 121:
#line 312 "asm.y"
    { (yyval.atom) = new_op0(0x8a); ;}
    break;

  case 122:
#line 313 "asm.y"
    { (yyval.atom) = new_op0(0xaa); ;}
    break;

  case 123:
#line 314 "asm.y"
    { (yyval.atom) = new_op0(0x18); ;}
    break;

  case 124:
#line 315 "asm.y"
    { (yyval.atom) = new_op0(0x38); ;}
    break;

  case 125:
#line 316 "asm.y"
    { (yyval.atom) = new_op0(0x60); ;}
    break;

  case 126:
#line 318 "asm.y"
    { (yyval.atom) = new_op(0x20, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 127:
#line 319 "asm.y"
    { (yyval.atom) = new_op(0x4c, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 128:
#line 320 "asm.y"
    { (yyval.atom) = new_op(0xf0, ATOM_TYPE_OP_ARG_I8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 129:
#line 321 "asm.y"
    { (yyval.atom) = new_op(0xd0, ATOM_TYPE_OP_ARG_I8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 130:
#line 322 "asm.y"
    { (yyval.atom) = new_op(0x90, ATOM_TYPE_OP_ARG_I8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 131:
#line 323 "asm.y"
    { (yyval.atom) = new_op(0xb0, ATOM_TYPE_OP_ARG_I8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 132:
#line 324 "asm.y"
    { (yyval.atom) = new_op(0x10, ATOM_TYPE_OP_ARG_I8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 133:
#line 325 "asm.y"
    { (yyval.atom) = new_op(0x30, ATOM_TYPE_OP_ARG_I8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 134:
#line 326 "asm.y"
    { (yyval.atom) = new_op(0x50, ATOM_TYPE_OP_ARG_I8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 135:
#line 327 "asm.y"
    { (yyval.atom) = new_op(0x70, ATOM_TYPE_OP_ARG_I8,  (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 136:
#line 329 "asm.y"
    { (yyval.atom) = new_op0(0xe8); ;}
    break;

  case 137:
#line 330 "asm.y"
    { (yyval.atom) = new_op0(0xca); ;}
    break;

  case 138:
#line 331 "asm.y"
    { (yyval.atom) = new_op0(0xc8); ;}
    break;

  case 139:
#line 332 "asm.y"
    { (yyval.atom) = new_op0(0x88); ;}
    break;

  case 140:
#line 334 "asm.y"
    { (yyval.atom) = new_op(0xe6, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 141:
#line 335 "asm.y"
    { (yyval.atom) = new_op(0xf6, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 142:
#line 336 "asm.y"
    { (yyval.atom) = new_op(0xee, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 143:
#line 337 "asm.y"
    { (yyval.atom) = new_op(0xfe, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 144:
#line 339 "asm.y"
    { (yyval.atom) = new_op(0xc6, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 145:
#line 340 "asm.y"
    { (yyval.atom) = new_op(0xd6, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 146:
#line 341 "asm.y"
    { (yyval.atom) = new_op(0xce, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 147:
#line 342 "asm.y"
    { (yyval.atom) = new_op(0xde, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 148:
#line 344 "asm.y"
    { (yyval.atom) = new_op0(0x4a); ;}
    break;

  case 149:
#line 345 "asm.y"
    { (yyval.atom) = new_op(0x46, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 150:
#line 346 "asm.y"
    { (yyval.atom) = new_op(0x56, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 151:
#line 347 "asm.y"
    { (yyval.atom) = new_op(0x4e, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 152:
#line 348 "asm.y"
    { (yyval.atom) = new_op(0x5e, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 153:
#line 350 "asm.y"
    { (yyval.atom) = new_op0(0x0a); ;}
    break;

  case 154:
#line 351 "asm.y"
    { (yyval.atom) = new_op(0x06, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 155:
#line 352 "asm.y"
    { (yyval.atom) = new_op(0x16, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 156:
#line 353 "asm.y"
    { (yyval.atom) = new_op(0x0e, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 157:
#line 354 "asm.y"
    { (yyval.atom) = new_op(0x1e, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 158:
#line 356 "asm.y"
    { (yyval.atom) = new_op0(0x6a); ;}
    break;

  case 159:
#line 357 "asm.y"
    { (yyval.atom) = new_op(0x66, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 160:
#line 358 "asm.y"
    { (yyval.atom) = new_op(0x76, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 161:
#line 359 "asm.y"
    { (yyval.atom) = new_op(0x6e, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 162:
#line 360 "asm.y"
    { (yyval.atom) = new_op(0x7e, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 163:
#line 362 "asm.y"
    { (yyval.atom) = new_op0(0x2a); ;}
    break;

  case 164:
#line 363 "asm.y"
    { (yyval.atom) = new_op(0x26, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 165:
#line 364 "asm.y"
    { (yyval.atom) = new_op(0x36, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 166:
#line 365 "asm.y"
    { (yyval.atom) = new_op(0x2e, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 167:
#line 366 "asm.y"
    { (yyval.atom) = new_op(0x3e, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 168:
#line 368 "asm.y"
    { (yyval.atom) = new_op(0x24, ATOM_TYPE_OP_ARG_U8, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 169:
#line 369 "asm.y"
    { (yyval.atom) = new_op(0x2c, ATOM_TYPE_OP_ARG_U16, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 170:
#line 371 "asm.y"
    { (yyval.expr) = (yyvsp[(2) - (2)].expr); ;}
    break;

  case 171:
#line 372 "asm.y"
    { (yyval.expr) = (yyvsp[(1) - (1)].expr); ;}
    break;

  case 172:
#line 373 "asm.y"
    { (yyval.expr) = (yyvsp[(1) - (3)].expr); ;}
    break;

  case 173:
#line 374 "asm.y"
    { (yyval.expr) = (yyvsp[(1) - (3)].expr); ;}
    break;

  case 174:
#line 375 "asm.y"
    { (yyval.expr) = (yyvsp[(2) - (2)].expr); ;}
    break;

  case 175:
#line 376 "asm.y"
    { (yyval.expr) = (yyvsp[(2) - (4)].expr); ;}
    break;

  case 176:
#line 377 "asm.y"
    { (yyval.expr) = (yyvsp[(2) - (4)].expr); ;}
    break;

  case 177:
#line 378 "asm.y"
    { (yyval.expr) = (yyvsp[(2) - (5)].expr); ;}
    break;

  case 178:
#line 379 "asm.y"
    { (yyval.expr) = (yyvsp[(2) - (5)].expr); ;}
    break;

  case 179:
#line 381 "asm.y"
    { (yyval.expr) = new_expr_op2(PLUS, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 180:
#line 382 "asm.y"
    { (yyval.expr) = new_expr_op2(MINUS, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 181:
#line 383 "asm.y"
    { (yyval.expr) = new_expr_op2(MULT, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 182:
#line 384 "asm.y"
    { (yyval.expr) = new_expr_op2(DIV, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 183:
#line 385 "asm.y"
    { (yyval.expr) = new_expr_op2(MOD, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 184:
#line 386 "asm.y"
    { (yyval.expr) = new_expr_op1(vNEG, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 185:
#line 387 "asm.y"
    { (yyval.expr) = (yyvsp[(2) - (3)].expr); ;}
    break;

  case 186:
#line 388 "asm.y"
    { (yyval.expr) = new_expr_inclen((yyvsp[(3) - (4)].str)); ;}
    break;

  case 187:
#line 389 "asm.y"
    {
            (yyval.expr) = new_expr_incword((yyvsp[(3) - (6)].str), (yyvsp[(5) - (6)].expr)); ;}
    break;

  case 188:
#line 391 "asm.y"
    { (yyval.expr) = new_expr_number((yyvsp[(1) - (1)].num)); ;}
    break;

  case 189:
#line 392 "asm.y"
    { (yyval.expr) = new_expr_symref((yyvsp[(1) - (1)].str)); ;}
    break;

  case 190:
#line 394 "asm.y"
    { (yyval.expr) = new_expr_op2(LOR, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 191:
#line 395 "asm.y"
    { (yyval.expr) = new_expr_op2(LAND, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 192:
#line 396 "asm.y"
    { (yyval.expr) = new_expr_op1(LNOT, (yyvsp[(2) - (2)].expr)); ;}
    break;

  case 193:
#line 397 "asm.y"
    { (yyval.expr) = (yyvsp[(2) - (3)].expr); ;}
    break;

  case 194:
#line 398 "asm.y"
    { (yyval.expr) = new_expr_op2(LT, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 195:
#line 399 "asm.y"
    { (yyval.expr) = new_expr_op2(GT, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 196:
#line 400 "asm.y"
    { (yyval.expr) = new_expr_op2(EQ, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 197:
#line 401 "asm.y"
    { (yyval.expr) = new_expr_op2(NEQ, (yyvsp[(1) - (3)].expr), (yyvsp[(3) - (3)].expr)); ;}
    break;

  case 198:
#line 403 "asm.y"
    { (yyval.expr) = new_is_defined((yyvsp[(3) - (4)].str)); ;}
    break;


/* Line 1267 of yacc.c.  */
#line 2855 "asm.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse look-ahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse look-ahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEOF && yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}


#line 405 "asm.y"


int
yyerror (char *s)
{
    fprintf (stderr, "line %d, %s\n", num_lines, s);
    return 0;
}

void asm_set_source(struct membuf *buffer);

int assembleSinglePass(struct membuf *source, struct membuf *dest)
{
    int val;

    yydebug = 0;
    asm_src_buffer_push(source);
    vec_init(asm_atoms, sizeof(struct atom*));
    val = yyparse();
    if(val == 0)
    {
        output_atoms(dest, asm_atoms);
    }
    vec_free(asm_atoms, NULL);
    return val;
}

