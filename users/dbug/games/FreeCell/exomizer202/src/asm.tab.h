/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

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




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 140 "asm.y"
{
    i32 num;
    char *str;
    struct atom *atom;
    struct expr *expr;
}
/* Line 1489 of yacc.c.  */
#line 240 "asm.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

