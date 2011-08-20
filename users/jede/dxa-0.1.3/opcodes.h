/*\
 *  dxa v0.1.1 -- symbolic 65xx disassembler
 *
 *  Copyright (C) 1993, 1994 Marko M\"akel\"a
 *  Changes for dxa (C) 2006 Cameron Kaiser
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Marko does not maintain dxa, so questions specific to dxa should be
 *  sent to me at ckaiser@floodgap.com . Otherwise,
 *
 *  Contacting the author:
 *
 *   Via Internet E-mail:
 *      <Marko.Makela@FTP.FUNET.FI>
 *
 *   Via Snail Mail:
 *      Marko M\"akel\"a
 *      Sillitie 10 A
 *      FIN-01480 VANTAA
 *      Finland
\*/

/* opcodes.h - opcodes for different microprocessors */

#ifndef _OPCODES_H_
#define _OPCODES_H_

#ifdef _DUMP_C_

static char *mne[] = { "???", "lda", "ldx", "ldy", "sta", "stx", "sty",
"stz", "adc", "sbc", "dec", "dex", "dey", "inc", "inx", "iny", "cmp",
"cpx", "cpy", "bit", "and", "ora", "eor", "asl", "lsr", "rol", "ror",
"tax", "tay", "tsx", "txs", "tya", "tad", "tas", "tda", "tsa", "txy",
"tyx", "pha", "phx", "phy", "php", "pea", "pei", "per", "phb", "phd",
"phk", "plb", "pld", "pla", "plx", "ply", "plp", "clc", "cld", "cli",
"clv", "sec", "sed", "sei", "rep", "sep", "xba", "xce", "bcc", "bcs",
"bne", "beq", "bra", "brl", "bpl", "bmi", "bvc", "bvs", "jmp", "jml",
"jsr", "jsl", "rts", "rtl", "rti", "brk", "nop", "trb", "tsb", "wai",
"bbr0", "bbr1", "bbr2", "bbr3", "bbr4", "bbr5", "bbr6", "bbr7",
"bbs0", "bbs1", "bbs2", "bbs3", "bbs4", "bbs5", "bbs6", "bbs7",
"rmb0", "rmb1", "rmb2", "rmb3", "rmb4", "rmb5", "rmb6", "rmb7",
"smb0", "smb1", "smb2", "smb3", "smb4", "smb5", "smb6", "smb7", "cop",
"mvn", "mvp", "laxs", "stax", "sha", "shx", "shy", "ane", "lxa", "lae",
"shs", "sbx", "usbc", "dcmp", "isbc", "rlan", "rrad", "slor", "sreo",
"arr", "asr", "anc", "noop", "stp", "txa", "ldax" };

#endif /* _DUMP_C_ */

enum
{
  S_ILLEGAL = 0, S_LDA, S_LDX, S_LDY, S_STA, S_STX, S_STY, S_STZ, S_ADC,
  S_SBC, S_DEC, S_DEX, S_DEY, S_INC, S_INX, S_INY, S_CMP, S_CPX, S_CPY,
  S_BIT, S_AND, S_ORA, S_EOR, S_ASL, S_LSR, S_ROL, S_ROR, S_TAX, S_TAY,
  S_TSX, S_TXS, S_TYA, S_TAD, S_TAS, S_TDA, S_TSA, S_TXY, S_TYX, S_PHA,
  S_PHX, S_PHY, S_PHP, S_PEA, S_PEI, S_PER, S_PHB, S_PHD, S_PHK, S_PLB,
  S_PLD, S_PLA, S_PLX, S_PLY, S_PLP, S_CLC, S_CLD, S_CLI, S_CLV, S_SEC,
  S_SED, S_SEI, S_REP, S_SEP, S_XBA, S_XCE, S_BCC, S_BCS, S_BNE, S_BEQ,
  S_BRA, S_BRL, S_BPL, S_BMI, S_BVC, S_BVS, S_JMP, S_JML, S_JSR, S_JSL,
  S_RTS, S_RTL, S_RTI, S_BRK, S_NOP, S_TRB, S_TSB, S_WAI,
  S_BBR0, S_BBR1, S_BBR2, S_BBR3, S_BBR4, S_BBR5, S_BBR6, S_BBR7,
  S_BBS0, S_BBS1, S_BBS2, S_BBS3, S_BBS4, S_BBS5, S_BBS6, S_BBS7,
  S_RMB0, S_RMB1, S_RMB2, S_RMB3, S_RMB4, S_RMB5, S_RMB6, S_RMB7,
  S_SMB0, S_SMB1, S_SMB2, S_SMB3, S_SMB4, S_SMB5, S_SMB6, S_SMB7,
  S_COP, S_MVN, S_MVP, S_LAXS, S_STAX, S_SHA, S_SHX, S_SHY, S_ANE, S_LXA,
  S_LAE, S_SHS, S_SBX, S_USBC, S_DCMP, S_ISBC, S_RLAN, S_RRAD, S_SLOR,
  S_SREO, S_ARR, S_ASR, S_ANC, S_NOOP, S_STP, S_TXA, S_LDAX
};

enum
{
  accu=0, imm, abso, zp, zpx, zpy, absx, absy,
  iabsx, impl, rel, zrel, indx, indy, iabs, ind
};

#ifdef _DUMP_C_
static char *prefix[] = { "", "#", "", "", "", "", "", "",
                          "(", "", "", "", "(", "(", "(", "(" };

/* static char *postfix[] = { " A", "", "", "", ",X", ",Y", ",X", ",Y", */
static char *postfix[] = { "", "", "", "", ",x", ",y", ",x", ",y", 
                           ",x)", "", "", "", ",x)", "),y", ")", ")" };
#endif /* _DUMP_C_ */

/* Adressing mode types. */
enum
{
  absindir, /* absolute parameter (8 or 16 bits) for indirection */
  absolute, /* absolute parameter (8 or 16 bits), not indexed */
  other,    /* something else (except impimm) */
  impimm    /* implied or immediate parameter */
};

#ifndef _SCAN_C_
extern unsigned int types[];
#else
unsigned int types[] = { impimm, impimm, absolute, absolute, other, other,
                         other, other, other, impimm, other, other,
                         other, absindir, absindir, absindir };
#endif

/* Number of bytes that instructions of different addressing modes occupy */
#ifndef _SCAN_C_
extern unsigned int sizes[];
#else
unsigned int sizes[] = { 1, 2, 3, 2, 2, 2, 3, 3, 3, 1, 2, 3, 2, 2, 3, 2 };
#endif

typedef struct opcodes
{
  int mnemonic; /* index to mnemonic instruction name table */
  int admode;   /* addressing mode */
} opcodes;

#ifndef _MAIN_C_
extern
#endif
opcodes *opset;

#ifdef _MAIN_C_
opcodes all_nmos6502[] =
{
  {S_BRK, impl}, {S_ORA, indx}, {S_STP, impl}, {S_SLOR,indx},
  {S_NOOP,  zp}, {S_ORA,   zp}, {S_ASL,   zp}, {S_SLOR,  zp},
  {S_PHP, impl}, {S_ORA,  imm}, {S_ASL, accu}, {S_ANC,  imm},
  {S_NOOP,abso}, {S_ORA, abso}, {S_ASL, abso}, {S_SLOR, abso},
  {S_BPL,  rel}, {S_ORA, indy}, {S_STP, impl}, {S_SLOR,indy},
  {S_NOOP, zpx}, {S_ORA,  zpx}, {S_ASL,  zpx}, {S_SLOR, zpx},
  {S_CLC, impl}, {S_ORA, absy}, {S_NOOP,impl}, {S_SLOR,absy},
  {S_NOOP,absx}, {S_ORA, absx}, {S_ASL, absx}, {S_SLOR,absx},

  {S_JSR, abso}, {S_AND, indx}, {S_STP, impl}, {S_RLAN,indx},
  {S_BIT,   zp}, {S_AND,   zp}, {S_ROL,   zp}, {S_RLAN,  zp},
  {S_PLP, impl}, {S_AND,  imm}, {S_ROL, accu}, {S_ANC,  imm},
  {S_BIT, abso}, {S_AND, abso}, {S_ROL, abso}, {S_RLAN,abso},
  {S_BMI,  rel}, {S_AND, indy}, {S_STP, impl}, {S_RLAN,indy},
  {S_NOOP, zpx}, {S_AND,  zpx}, {S_ROL,  zpx}, {S_RLAN, zpx},
  {S_SEC, impl}, {S_AND, absy}, {S_NOOP,impl}, {S_RLAN,absy},
  {S_NOOP,absx}, {S_AND, absx}, {S_ROL, absx}, {S_RLAN,absx},

  {S_RTI, impl}, {S_EOR, indx}, {S_STP, impl}, {S_SREO,indx},
  {S_NOOP,  zp}, {S_EOR,   zp}, {S_LSR,   zp}, {S_SREO,  zp},
  {S_PHA, impl}, {S_EOR,  imm}, {S_LSR, accu}, {S_ASR,  imm},
  {S_JMP, abso}, {S_EOR, abso}, {S_LSR, abso}, {S_SREO,abso},
  {S_BVC,  rel}, {S_EOR, indy}, {S_STP, impl}, {S_SREO,indy},
  {S_NOOP, zpx}, {S_EOR,  zpx}, {S_LSR,  zpx}, {S_SREO, zpx},
  {S_CLI, impl}, {S_EOR, absy}, {S_NOOP,impl}, {S_SREO,absy},
  {S_NOOP,absx}, {S_EOR, absx}, {S_LSR, absx}, {S_SREO,absx},

  {S_RTS, impl}, {S_ADC, indx}, {S_STP, impl}, {S_RRAD,indx},
  {S_NOOP,  zp}, {S_ADC,   zp}, {S_ROR,   zp}, {S_RRAD,  zp},
  {S_PLA, impl}, {S_ADC,  imm}, {S_ROR, accu}, {S_ARR,  imm},
  {S_JMP, iabs}, {S_ADC, abso}, {S_ROR, abso}, {S_RRAD,abso},
  {S_BVS,  rel}, {S_ADC, indy}, {S_STP, impl}, {S_RRAD,indy},
  {S_NOOP, zpx}, {S_ADC,  zpx}, {S_ROR,  zpx}, {S_RRAD, zpx},
  {S_SEI, impl}, {S_ADC, absy}, {S_NOOP,impl}, {S_RRAD,absy},
  {S_NOOP,absx}, {S_ADC, absx}, {S_ROR, absx}, {S_RRAD,absx},

  {S_NOOP, imm}, {S_STA, indx}, {S_NOOP, imm}, {S_STAX,indx},
  {S_STY,   zp}, {S_STA,   zp}, {S_STX,   zp}, {S_STAX,  zp},
  {S_DEY, impl}, {S_NOOP, imm}, {S_TXA, impl}, {S_ANE,  imm},
  {S_STY, abso}, {S_STA, abso}, {S_STX, abso}, {S_STAX,abso},
  {S_BCC,  rel}, {S_STA, indy}, {S_STP, impl}, {S_SHA, indy},
  {S_STY,  zpx}, {S_STA,  zpx}, {S_STX,  zpy}, {S_STAX, zpy},
  {S_TYA, impl}, {S_STA, absy}, {S_TXS, impl}, {S_SHS, absy},
  {S_SHY, absx}, {S_STA, absx}, {S_SHX, absx}, {S_SHA, absx},

  {S_LDY,  imm}, {S_LDA, indx}, {S_LDX,  imm}, {S_LDAX,indy},
  {S_LDY,   zp}, {S_LDA,   zp}, {S_LDX,   zp}, {S_LDAX,  zp},
  {S_TAY, impl}, {S_LDA,  imm}, {S_TAX, impl}, {S_LXA,  imm},
  {S_LDY, abso}, {S_LDA, abso}, {S_LDX, abso}, {S_LDAX,abso},
  {S_BCS,  rel}, {S_LDA, indy}, {S_STP, impl}, {S_LDAX,indy},
  {S_LDY,  zpx}, {S_LDA,  zpx}, {S_LDX,  zpy}, {S_LDAX, zpy},
  {S_CLV, impl}, {S_LDA, absy}, {S_TSX, impl}, {S_LAXS,absy},
  {S_LDY, absx}, {S_LDA, absx}, {S_LDX, absy}, {S_LDAX,absy},

  {S_CPY,  imm}, {S_CMP, indx}, {S_NOOP, imm}, {S_DCMP,indx},
  {S_CPY,   zp}, {S_CMP,   zp}, {S_DEC,   zp}, {S_DCMP,  zp},
  {S_INY, impl}, {S_CMP,  imm}, {S_DEX, impl}, {S_SBX,  imm},
  {S_CPY, abso}, {S_CMP, abso}, {S_DEC, abso}, {S_DCMP,abso},
  {S_BNE,  rel}, {S_CMP, indy}, {S_STP, impl}, {S_DCMP,indy},
  {S_NOOP, zpx}, {S_CMP,  zpx}, {S_DEC,  zpx}, {S_DCMP, zpx},
  {S_CLD, impl}, {S_CMP, absy}, {S_NOOP,impl}, {S_DCMP,absy},
  {S_NOOP,absx}, {S_CMP, absx}, {S_DEC, absx}, {S_DCMP,absx},

  {S_CPX,  imm}, {S_SBC, indx}, {S_NOOP, imm}, {S_ISBC,indx},
  {S_CPX,   zp}, {S_SBC,   zp}, {S_INC,   zp}, {S_ISBC,  zp},
  {S_INX, impl}, {S_SBC,  imm}, {S_NOP, impl}, {S_USBC, imm},
  {S_CPX, abso}, {S_SBC, abso}, {S_INC, abso}, {S_ISBC,abso},
  {S_BEQ,  rel}, {S_SBC, indy}, {S_STP, impl}, {S_ISBC,indy},
  {S_NOOP, zpx}, {S_SBC,  zpx}, {S_INC,  zpx}, {S_ISBC, zpx},
  {S_SED, impl}, {S_SBC, absy}, {S_NOOP,impl}, {S_ISBC,absy},
  {S_NOOP,absx}, {S_SBC, absx}, {S_INC, absx}, {S_ISBC,absx},
};

/*\
 * The following NMOS 6502 instructions are missing from the
 * rational_nmos6502 map:
 *
 *   ANE  SHA  SHS  SHY  SHX  LXA  LAXS
\*/

opcodes rational_nmos6502[] =
{
  {S_BRK, impl}, {S_ORA, indx}, {S_STP, impl}, {S_SLOR,indx},
  {S_NOOP,  zp}, {S_ORA,   zp}, {S_ASL,   zp}, {S_SLOR,  zp},
  {S_PHP, impl}, {S_ORA,  imm}, {S_ASL, accu}, {S_ANC,  imm},
  {S_NOOP,abso}, {S_ORA, abso}, {S_ASL, abso}, {S_SLOR, abso},
  {S_BPL,  rel}, {S_ORA, indy}, {S_STP, impl}, {S_SLOR,indy},
  {S_NOOP, zpx}, {S_ORA,  zpx}, {S_ASL,  zpx}, {S_SLOR, zpx},
  {S_CLC, impl}, {S_ORA, absy}, {S_NOOP,impl}, {S_SLOR,absy},
  {S_NOOP,absx}, {S_ORA, absx}, {S_ASL, absx}, {S_SLOR,absx},

  {S_JSR, abso}, {S_AND, indx}, {S_STP, impl}, {S_RLAN,indx},
  {S_BIT,   zp}, {S_AND,   zp}, {S_ROL,   zp}, {S_RLAN,  zp},
  {S_PLP, impl}, {S_AND,  imm}, {S_ROL, accu}, {S_ANC,  imm},
  {S_BIT, abso}, {S_AND, abso}, {S_ROL, abso}, {S_RLAN,abso},
  {S_BMI,  rel}, {S_AND, indy}, {S_STP, impl}, {S_RLAN,indy},
  {S_NOOP, zpx}, {S_AND,  zpx}, {S_ROL,  zpx}, {S_RLAN, zpx},
  {S_SEC, impl}, {S_AND, absy}, {S_NOOP,impl}, {S_RLAN,absy},
  {S_NOOP,absx}, {S_AND, absx}, {S_ROL, absx}, {S_RLAN,absx},

  {S_RTI, impl}, {S_EOR, indx}, {S_STP, impl}, {S_SREO,indx},
  {S_NOOP,  zp}, {S_EOR,   zp}, {S_LSR,   zp}, {S_SREO,  zp},
  {S_PHA, impl}, {S_EOR,  imm}, {S_LSR, accu}, {S_ASR,  imm},
  {S_JMP, abso}, {S_EOR, abso}, {S_LSR, abso}, {S_SREO,abso},
  {S_BVC,  rel}, {S_EOR, indy}, {S_STP, impl}, {S_SREO,indy},
  {S_NOOP, zpx}, {S_EOR,  zpx}, {S_LSR,  zpx}, {S_SREO, zpx},
  {S_CLI, impl}, {S_EOR, absy}, {S_NOOP,impl}, {S_SREO,absy},
  {S_NOOP,absx}, {S_EOR, absx}, {S_LSR, absx}, {S_SREO,absx},

  {S_RTS, impl}, {S_ADC, indx}, {S_STP, impl}, {S_RRAD,indx},
  {S_NOOP,  zp}, {S_ADC,   zp}, {S_ROR,   zp}, {S_RRAD,  zp},
  {S_PLA, impl}, {S_ADC,  imm}, {S_ROR, accu}, {S_ARR,  imm},
  {S_JMP, iabs}, {S_ADC, abso}, {S_ROR, abso}, {S_RRAD,abso},
  {S_BVS,  rel}, {S_ADC, indy}, {S_STP, impl}, {S_RRAD,indy},
  {S_NOOP, zpx}, {S_ADC,  zpx}, {S_ROR,  zpx}, {S_RRAD, zpx},
  {S_SEI, impl}, {S_ADC, absy}, {S_NOOP,impl}, {S_RRAD,absy},
  {S_NOOP,absx}, {S_ADC, absx}, {S_ROR, absx}, {S_RRAD,absx},

  {S_NOOP, imm}, {S_STA, indx}, {S_NOOP, imm}, {S_STAX,indx},
  {S_STY,   zp}, {S_STA,   zp}, {S_STX,   zp}, {S_STAX,  zp},
  {S_DEY, impl}, {S_NOOP, imm}, {S_TXA, impl}, {S_ILLEGAL,0},
  {S_STY, abso}, {S_STA, abso}, {S_STX, abso}, {S_STAX,abso},
  {S_BCC,  rel}, {S_STA, indy}, {S_STP, impl}, {S_ILLEGAL,0},
  {S_STY,  zpx}, {S_STA,  zpx}, {S_STX,  zpy}, {S_STAX, zpy},
  {S_TYA, impl}, {S_STA, absy}, {S_TXS, impl}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_STA, absx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},

  {S_LDY,  imm}, {S_LDA, indx}, {S_LDX,  imm}, {S_LDAX,indy},
  {S_LDY,   zp}, {S_LDA,   zp}, {S_LDX,   zp}, {S_LDAX,  zp},
  {S_TAY, impl}, {S_LDA,  imm}, {S_TAX, impl}, {S_ILLEGAL,0},
  {S_LDY, abso}, {S_LDA, abso}, {S_LDX, abso}, {S_LDAX,abso},
  {S_BCS,  rel}, {S_LDA, indy}, {S_STP, impl}, {S_LDAX,indy},
  {S_LDY,  zpx}, {S_LDA,  zpx}, {S_LDX,  zpy}, {S_LDAX, zpy},
  {S_CLV, impl}, {S_LDA, absy}, {S_TSX, impl}, {S_ILLEGAL,0},
  {S_LDY, absx}, {S_LDA, absx}, {S_LDX, absy}, {S_LDAX,absy},

  {S_CPY,  imm}, {S_CMP, indx}, {S_NOOP, imm}, {S_DCMP,indx},
  {S_CPY,   zp}, {S_CMP,   zp}, {S_DEC,   zp}, {S_DCMP,  zp},
  {S_INY, impl}, {S_CMP,  imm}, {S_DEX, impl}, {S_SBX,  imm},
  {S_CPY, abso}, {S_CMP, abso}, {S_DEC, abso}, {S_DCMP,abso},
  {S_BNE,  rel}, {S_CMP, indy}, {S_STP, impl}, {S_DCMP,indy},
  {S_NOOP, zpx}, {S_CMP,  zpx}, {S_DEC,  zpx}, {S_DCMP, zpx},
  {S_CLD, impl}, {S_CMP, absy}, {S_NOOP,impl}, {S_DCMP,absy},
  {S_NOOP,absx}, {S_CMP, absx}, {S_DEC, absx}, {S_DCMP,absx},

  {S_CPX,  imm}, {S_SBC, indx}, {S_NOOP, imm}, {S_ISBC,indx},
  {S_CPX,   zp}, {S_SBC,   zp}, {S_INC,   zp}, {S_ISBC,  zp},
  {S_INX, impl}, {S_SBC,  imm}, {S_NOP, impl}, {S_USBC, imm},
  {S_CPX, abso}, {S_SBC, abso}, {S_INC, abso}, {S_ISBC,abso},
  {S_BEQ,  rel}, {S_SBC, indy}, {S_STP, impl}, {S_ISBC,indy},
  {S_NOOP, zpx}, {S_SBC,  zpx}, {S_INC,  zpx}, {S_ISBC, zpx},
  {S_SED, impl}, {S_SBC, absy}, {S_NOOP,impl}, {S_ISBC,absy},
  {S_NOOP,absx}, {S_SBC, absx}, {S_INC, absx}, {S_ISBC,absx},
};

/*\
 * The following NMOS 6502 instructions are missing from the
 * useful_nmos6502 map:
 *
 *   ANE  SHA  SHS  SHY  SHX  LXA  LAXS  NOOP  STP
\*/

opcodes useful_nmos6502[] =
{
  {S_BRK, impl}, {S_ORA, indx}, {S_ILLEGAL,0}, {S_SLOR,indx},
  {S_ILLEGAL,0}, {S_ORA,   zp}, {S_ASL,   zp}, {S_SLOR,  zp},
  {S_PHP, impl}, {S_ORA,  imm}, {S_ASL, accu}, {S_ANC,  imm},
  {S_ILLEGAL,0}, {S_ORA, abso}, {S_ASL, abso}, {S_SLOR,abso},
  {S_BPL,  rel}, {S_ORA, indy}, {S_ILLEGAL,0}, {S_SLOR,indy},
  {S_ILLEGAL,0}, {S_ORA,  zpx}, {S_ASL,  zpx}, {S_SLOR, zpx},
  {S_CLC, impl}, {S_ORA, absy}, {S_ILLEGAL,0}, {S_SLOR,absy},
  {S_ILLEGAL,0}, {S_ORA, absx}, {S_ASL, absx}, {S_SLOR,absx},

  {S_JSR, abso}, {S_AND, indx}, {S_ILLEGAL,0}, {S_RLAN,indx},
  {S_BIT,   zp}, {S_AND,   zp}, {S_ROL,   zp}, {S_RLAN,  zp},
  {S_PLP, impl}, {S_AND,  imm}, {S_ROL, accu}, {S_ANC,  imm},
  {S_BIT, abso}, {S_AND, abso}, {S_ROL, abso}, {S_RLAN,abso},
  {S_BMI,  rel}, {S_AND, indy}, {S_ILLEGAL,0}, {S_RLAN,indy},
  {S_ILLEGAL,0}, {S_AND,  zpx}, {S_ROL,  zpx}, {S_RLAN, zpx},
  {S_SEC, impl}, {S_AND, absy}, {S_ILLEGAL,0}, {S_RLAN,absy},
  {S_ILLEGAL,0}, {S_AND, absx}, {S_ROL, absx}, {S_RLAN,absx},

  {S_RTI, impl}, {S_EOR, indx}, {S_ILLEGAL,0}, {S_SREO,indx},
  {S_ILLEGAL,0}, {S_EOR,   zp}, {S_LSR,   zp}, {S_SREO,  zp},
  {S_PHA, impl}, {S_EOR,  imm}, {S_LSR, accu}, {S_ASR,  imm},
  {S_JMP, abso}, {S_EOR, abso}, {S_LSR, abso}, {S_SREO,abso},
  {S_BVC,  rel}, {S_EOR, indy}, {S_ILLEGAL,0}, {S_SREO,indy},
  {S_ILLEGAL,0}, {S_EOR,  zpx}, {S_LSR,  zpx}, {S_SREO, zpx},
  {S_CLI, impl}, {S_EOR, absy}, {S_ILLEGAL,0}, {S_SREO,absy},
  {S_ILLEGAL,0}, {S_EOR, absx}, {S_LSR, absx}, {S_SREO,absx},

  {S_RTS, impl}, {S_ADC, indx}, {S_ILLEGAL,0}, {S_RRAD,indx},
  {S_ILLEGAL,0}, {S_ADC,   zp}, {S_ROR,   zp}, {S_RRAD,  zp},
  {S_PLA, impl}, {S_ADC,  imm}, {S_ROR, accu}, {S_ARR,  imm},
  {S_JMP, iabs}, {S_ADC, abso}, {S_ROR, abso}, {S_RRAD,abso},
  {S_BVS,  rel}, {S_ADC, indy}, {S_ILLEGAL,0}, {S_RRAD,indy},
  {S_ILLEGAL,0}, {S_ADC,  zpx}, {S_ROR,  zpx}, {S_RRAD, zpx},
  {S_SEI, impl}, {S_ADC, absy}, {S_ILLEGAL,0}, {S_RRAD,absy},
  {S_ILLEGAL,0}, {S_ADC, absx}, {S_ROR, absx}, {S_RRAD,absx},

  {S_ILLEGAL,0}, {S_STA, indx}, {S_ILLEGAL,0}, {S_STAX,indx},
  {S_STY,   zp}, {S_STA,   zp}, {S_STX,   zp}, {S_STAX,  zp},
  {S_DEY, impl}, {S_ILLEGAL,0}, {S_TXA, impl}, {S_ILLEGAL,0},
  {S_STY, abso}, {S_STA, abso}, {S_STX, abso}, {S_STAX,abso},
  {S_BCC,  rel}, {S_STA, indy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_STY,  zpx}, {S_STA,  zpx}, {S_STX,  zpy}, {S_STAX, zpy},
  {S_TYA, impl}, {S_STA, absy}, {S_TXS, impl}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_STA, absx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},

  {S_LDY,  imm}, {S_LDA, indx}, {S_LDX,  imm}, {S_LDAX,indy},
  {S_LDY,   zp}, {S_LDA,   zp}, {S_LDX,   zp}, {S_LDAX,  zp},
  {S_TAY, impl}, {S_LDA,  imm}, {S_TAX, impl}, {S_ILLEGAL,0},
  {S_LDY, abso}, {S_LDA, abso}, {S_LDX, abso}, {S_LDAX,abso},
  {S_BCS,  rel}, {S_LDA, indy}, {S_ILLEGAL,0}, {S_LDAX,indy},
  {S_LDY,  zpx}, {S_LDA,  zpx}, {S_LDX,  zpy}, {S_LDAX, zpy},
  {S_CLV, impl}, {S_LDA, absy}, {S_TSX, impl}, {S_ILLEGAL,0},
  {S_LDY, absx}, {S_LDA, absx}, {S_LDX, absy}, {S_LDAX,absy},

  {S_CPY,  imm}, {S_CMP, indx}, {S_ILLEGAL,0}, {S_DCMP,indx},
  {S_CPY,   zp}, {S_CMP,   zp}, {S_DEC,   zp}, {S_DCMP,  zp},
  {S_INY, impl}, {S_CMP,  imm}, {S_DEX, impl}, {S_SBX,  imm},
  {S_CPY, abso}, {S_CMP, abso}, {S_DEC, abso}, {S_DCMP,abso},
  {S_BNE,  rel}, {S_CMP, indy}, {S_ILLEGAL,0}, {S_DCMP,indy},
  {S_ILLEGAL,0}, {S_CMP,  zpx}, {S_DEC,  zpx}, {S_DCMP, zpx},
  {S_CLD, impl}, {S_CMP, absy}, {S_ILLEGAL,0}, {S_DCMP,absy},
  {S_ILLEGAL,0}, {S_CMP, absx}, {S_DEC, absx}, {S_DCMP,absx},

  {S_CPX,  imm}, {S_SBC, indx}, {S_ILLEGAL,0}, {S_ISBC,indx},
  {S_CPX,   zp}, {S_SBC,   zp}, {S_INC,   zp}, {S_ISBC,  zp},
  {S_INX, impl}, {S_SBC,  imm}, {S_NOP, impl}, {S_USBC, imm},
  {S_CPX, abso}, {S_SBC, abso}, {S_INC, abso}, {S_ISBC,abso},
  {S_BEQ,  rel}, {S_SBC, indy}, {S_ILLEGAL,0}, {S_ISBC,indy},
  {S_ILLEGAL,0}, {S_SBC,  zpx}, {S_INC,  zpx}, {S_ISBC, zpx},
  {S_SED, impl}, {S_SBC, absy}, {S_ILLEGAL,0}, {S_ISBC,absy},
  {S_ILLEGAL,0}, {S_SBC, absx}, {S_INC, absx}, {S_ISBC,absx},
};

/*\
 * The following NMOS 6502 instructions are missing from the
 * traditional_nmos6502 map:
 *
 *   ANE  SHA  SHS  SHY  SHX  LXA  LAXS  NOOP  STP
 *   ARR  ASR  ANC  SBX  USBC
\*/

opcodes traditional_nmos6502[] =
{
  {S_BRK, impl}, {S_ORA, indx}, {S_ILLEGAL,0}, {S_SLOR,indx},
  {S_ILLEGAL,0}, {S_ORA,   zp}, {S_ASL,   zp}, {S_SLOR,  zp},
  {S_PHP, impl}, {S_ORA,  imm}, {S_ASL, accu}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_ORA, abso}, {S_ASL, abso}, {S_SLOR,abso},
  {S_BPL,  rel}, {S_ORA, indy}, {S_ILLEGAL,0}, {S_SLOR,indy},
  {S_ILLEGAL,0}, {S_ORA,  zpx}, {S_ASL,  zpx}, {S_SLOR, zpx},
  {S_CLC, impl}, {S_ORA, absy}, {S_ILLEGAL,0}, {S_SLOR,absy},
  {S_ILLEGAL,0}, {S_ORA, absx}, {S_ASL, absx}, {S_SLOR,absx},

  {S_JSR, abso}, {S_AND, indx}, {S_ILLEGAL,0}, {S_RLAN,indx},
  {S_BIT,   zp}, {S_AND,   zp}, {S_ROL,   zp}, {S_RLAN,  zp},
  {S_PLP, impl}, {S_AND,  imm}, {S_ROL, accu}, {S_ILLEGAL,0},
  {S_BIT, abso}, {S_AND, abso}, {S_ROL, abso}, {S_RLAN,abso},
  {S_BMI,  rel}, {S_AND, indy}, {S_ILLEGAL,0}, {S_RLAN,indy},
  {S_ILLEGAL,0}, {S_AND,  zpx}, {S_ROL,  zpx}, {S_RLAN, zpx},
  {S_SEC, impl}, {S_AND, absy}, {S_ILLEGAL,0}, {S_RLAN,absy},
  {S_ILLEGAL,0}, {S_AND, absx}, {S_ROL, absx}, {S_RLAN,absx},

  {S_RTI, impl}, {S_EOR, indx}, {S_ILLEGAL,0}, {S_SREO,indx},
  {S_ILLEGAL,0}, {S_EOR,   zp}, {S_LSR,   zp}, {S_SREO,  zp},
  {S_PHA, impl}, {S_EOR,  imm}, {S_LSR, accu}, {S_ILLEGAL,0},
  {S_JMP, abso}, {S_EOR, abso}, {S_LSR, abso}, {S_SREO,abso},
  {S_BVC,  rel}, {S_EOR, indy}, {S_ILLEGAL,0}, {S_SREO,indy},
  {S_ILLEGAL,0}, {S_EOR,  zpx}, {S_LSR,  zpx}, {S_SREO, zpx},
  {S_CLI, impl}, {S_EOR, absy}, {S_ILLEGAL,0}, {S_SREO,absy},
  {S_ILLEGAL,0}, {S_EOR, absx}, {S_LSR, absx}, {S_SREO,absx},

  {S_RTS, impl}, {S_ADC, indx}, {S_ILLEGAL,0}, {S_RRAD,indx},
  {S_ILLEGAL,0}, {S_ADC,   zp}, {S_ROR,   zp}, {S_RRAD,  zp},
  {S_PLA, impl}, {S_ADC,  imm}, {S_ROR, accu}, {S_ILLEGAL,0},
  {S_JMP, iabs}, {S_ADC, abso}, {S_ROR, abso}, {S_RRAD,abso},
  {S_BVS,  rel}, {S_ADC, indy}, {S_ILLEGAL,0}, {S_RRAD,indy},
  {S_ILLEGAL,0}, {S_ADC,  zpx}, {S_ROR,  zpx}, {S_RRAD, zpx},
  {S_SEI, impl}, {S_ADC, absy}, {S_ILLEGAL,0}, {S_RRAD,absy},
  {S_ILLEGAL,0}, {S_ADC, absx}, {S_ROR, absx}, {S_RRAD,absx},

  {S_ILLEGAL,0}, {S_STA, indx}, {S_ILLEGAL,0}, {S_STAX,indx},
  {S_STY,   zp}, {S_STA,   zp}, {S_STX,   zp}, {S_STAX,  zp},
  {S_DEY, impl}, {S_ILLEGAL,0}, {S_TXA, impl}, {S_ILLEGAL,0},
  {S_STY, abso}, {S_STA, abso}, {S_STX, abso}, {S_STAX,abso},
  {S_BCC,  rel}, {S_STA, indy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_STY,  zpx}, {S_STA,  zpx}, {S_STX,  zpy}, {S_STAX, zpy},
  {S_TYA, impl}, {S_STA, absy}, {S_TXS, impl}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_STA, absx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},

  {S_LDY,  imm}, {S_LDA, indx}, {S_LDX,  imm}, {S_LDAX,indy},
  {S_LDY,   zp}, {S_LDA,   zp}, {S_LDX,   zp}, {S_LDAX,  zp},
  {S_TAY, impl}, {S_LDA,  imm}, {S_TAX, impl}, {S_ILLEGAL,0},
  {S_LDY, abso}, {S_LDA, abso}, {S_LDX, abso}, {S_LDAX,abso},
  {S_BCS,  rel}, {S_LDA, indy}, {S_ILLEGAL,0}, {S_LDAX,indy},
  {S_LDY,  zpx}, {S_LDA,  zpx}, {S_LDX,  zpy}, {S_LDAX, zpy},
  {S_CLV, impl}, {S_LDA, absy}, {S_TSX, impl}, {S_ILLEGAL,0},
  {S_LDY, absx}, {S_LDA, absx}, {S_LDX, absy}, {S_LDAX,absy},

  {S_CPY,  imm}, {S_CMP, indx}, {S_ILLEGAL,0}, {S_DCMP,indx},
  {S_CPY,   zp}, {S_CMP,   zp}, {S_DEC,   zp}, {S_DCMP,  zp},
  {S_INY, impl}, {S_CMP,  imm}, {S_DEX, impl}, {S_ILLEGAL,0},
  {S_CPY, abso}, {S_CMP, abso}, {S_DEC, abso}, {S_DCMP,abso},
  {S_BNE,  rel}, {S_CMP, indy}, {S_ILLEGAL,0}, {S_DCMP,indy},
  {S_ILLEGAL,0}, {S_CMP,  zpx}, {S_DEC,  zpx}, {S_DCMP, zpx},
  {S_CLD, impl}, {S_CMP, absy}, {S_ILLEGAL,0}, {S_DCMP,absy},
  {S_ILLEGAL,0}, {S_CMP, absx}, {S_DEC, absx}, {S_DCMP,absx},

  {S_CPX,  imm}, {S_SBC, indx}, {S_ILLEGAL,0}, {S_ISBC,indx},
  {S_CPX,   zp}, {S_SBC,   zp}, {S_INC,   zp}, {S_ISBC,  zp},
  {S_INX, impl}, {S_SBC,  imm}, {S_NOP, impl}, {S_ILLEGAL,0},
  {S_CPX, abso}, {S_SBC, abso}, {S_INC, abso}, {S_ISBC,abso},
  {S_BEQ,  rel}, {S_SBC, indy}, {S_ILLEGAL,0}, {S_ISBC,indy},
  {S_ILLEGAL,0}, {S_SBC,  zpx}, {S_INC,  zpx}, {S_ISBC, zpx},
  {S_SED, impl}, {S_SBC, absy}, {S_ILLEGAL,0}, {S_ISBC,absy},
  {S_ILLEGAL,0}, {S_SBC, absx}, {S_INC, absx}, {S_ISBC,absx},
};

/*\
 * The following is the officially documented
 * MOS 6502 instruction set.
\*/

opcodes standard_nmos6502[] =
{
  {S_BRK, impl}, {S_ORA, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_ORA,   zp}, {S_ASL,   zp}, {S_ILLEGAL,0},
  {S_PHP, impl}, {S_ORA,  imm}, {S_ASL, accu}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_ORA, abso}, {S_ASL, abso}, {S_ILLEGAL,0},
  {S_BPL,  rel}, {S_ORA, indy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_ORA,  zpx}, {S_ASL,  zpx}, {S_ILLEGAL,0},
  {S_CLC, impl}, {S_ORA, absy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_ORA, absx}, {S_ASL, absx}, {S_ILLEGAL,0},

  {S_JSR, abso}, {S_AND, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_BIT,   zp}, {S_AND,   zp}, {S_ROL,   zp}, {S_ILLEGAL,0},
  {S_PLP, impl}, {S_AND,  imm}, {S_ROL, accu}, {S_ILLEGAL,0},
  {S_BIT, abso}, {S_AND, abso}, {S_ROL, abso}, {S_ILLEGAL,0},
  {S_BMI,  rel}, {S_AND, indy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_AND,  zpx}, {S_ROL,  zpx}, {S_ILLEGAL,0},
  {S_SEC, impl}, {S_AND, absy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_AND, absx}, {S_ROL, absx}, {S_ILLEGAL,0},

  {S_RTI, impl}, {S_EOR, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_EOR,   zp}, {S_LSR,   zp}, {S_ILLEGAL,0},
  {S_PHA, impl}, {S_EOR,  imm}, {S_LSR, accu}, {S_ILLEGAL,0},
  {S_JMP, abso}, {S_EOR, abso}, {S_LSR, abso}, {S_ILLEGAL,0},
  {S_BVC,  rel}, {S_EOR, indy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_EOR,  zpx}, {S_LSR,  zpx}, {S_ILLEGAL,0},
  {S_CLI, impl}, {S_EOR, absy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_EOR, absx}, {S_LSR, absx}, {S_ILLEGAL,0},

  {S_RTS, impl}, {S_ADC, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_ADC,   zp}, {S_ROR,   zp}, {S_ILLEGAL,0},
  {S_PLA, impl}, {S_ADC,  imm}, {S_ROR, accu}, {S_ILLEGAL,0},
  {S_JMP, iabs}, {S_ADC, abso}, {S_ROR, abso}, {S_ILLEGAL,0},
  {S_BVS,  rel}, {S_ADC, indy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_ADC,  zpx}, {S_ROR,  zpx}, {S_ILLEGAL,0},
  {S_SEI, impl}, {S_ADC, absy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_ADC, absx}, {S_ROR, absx}, {S_ILLEGAL,0},

  {S_ILLEGAL,0}, {S_STA, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_STY,   zp}, {S_STA,   zp}, {S_STX,   zp}, {S_ILLEGAL,0},
  {S_DEY, impl}, {S_ILLEGAL,0}, {S_TXA, impl}, {S_ILLEGAL,0},
  {S_STY, abso}, {S_STA, abso}, {S_STX, abso}, {S_ILLEGAL,0},
  {S_BCC,  rel}, {S_STA, indy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_STY,  zpx}, {S_STA,  zpx}, {S_STX,  zpy}, {S_ILLEGAL,0},
  {S_TYA, impl}, {S_STA, absy}, {S_TXS, impl}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_STA, absx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},

  {S_LDY,  imm}, {S_LDA, indx}, {S_LDX,  imm}, {S_ILLEGAL,0},
  {S_LDY,   zp}, {S_LDA,   zp}, {S_LDX,   zp}, {S_ILLEGAL,0},
  {S_TAY, impl}, {S_LDA,  imm}, {S_TAX, impl}, {S_ILLEGAL,0},
  {S_LDY, abso}, {S_LDA, abso}, {S_LDX, abso}, {S_ILLEGAL,0},
  {S_BCS,  rel}, {S_LDA, indy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_LDY,  zpx}, {S_LDA,  zpx}, {S_LDX,  zpy}, {S_ILLEGAL,0},
  {S_CLV, impl}, {S_LDA, absy}, {S_TSX, impl}, {S_ILLEGAL,0},
  {S_LDY, absx}, {S_LDA, absx}, {S_LDX, absy}, {S_ILLEGAL,0},

  {S_CPY,  imm}, {S_CMP, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_CPY,   zp}, {S_CMP,   zp}, {S_DEC,   zp}, {S_ILLEGAL,0},
  {S_INY, impl}, {S_CMP,  imm}, {S_DEX, impl}, {S_ILLEGAL,0},
  {S_CPY, abso}, {S_CMP, abso}, {S_DEC, abso}, {S_ILLEGAL,0},
  {S_BNE,  rel}, {S_CMP, indy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_CMP,  zpx}, {S_DEC,  zpx}, {S_ILLEGAL,0},
  {S_CLD, impl}, {S_CMP, absy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_CMP, absx}, {S_DEC, absx}, {S_ILLEGAL,0},

  {S_CPX,  imm}, {S_SBC, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_CPX,   zp}, {S_SBC,   zp}, {S_INC,   zp}, {S_ILLEGAL,0},
  {S_INX, impl}, {S_SBC,  imm}, {S_NOP, impl}, {S_ILLEGAL,0},
  {S_CPX, abso}, {S_SBC, abso}, {S_INC, abso}, {S_ILLEGAL,0},
  {S_BEQ,  rel}, {S_SBC, indy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_SBC,  zpx}, {S_INC,  zpx}, {S_ILLEGAL,0},
  {S_SED, impl}, {S_SBC, absy}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_SBC, absx}, {S_INC, absx}, {S_ILLEGAL,0},
};


/*\
 * The following is the officially documented
 * Rockwell R65C02 instruction set.
\*/

opcodes r65c02[] =
{
  {S_BRK, impl}, {S_ORA, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_TSB,   zp}, {S_ORA,   zp}, {S_ASL,   zp}, {S_RMB0,  zp},
  {S_PHP, impl}, {S_ORA,  imm}, {S_ASL, accu}, {S_ILLEGAL,0},
  {S_TSB, abso}, {S_ORA, abso}, {S_ASL, abso}, {S_BBR0,zrel},
  {S_BPL,  rel}, {S_ORA, indy}, {S_ORA,  ind}, {S_ILLEGAL,0},
  {S_TRB,   zp}, {S_ORA,  zpx}, {S_ASL,  zpx}, {S_RMB1,  zp},
  {S_CLC, impl}, {S_ORA, absy}, {S_INC, accu}, {S_ILLEGAL,0},
  {S_TRB, abso}, {S_ORA, absx}, {S_ASL, absx}, {S_BBR1,zrel},

  {S_JSR, abso}, {S_AND, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_BIT,   zp}, {S_AND,   zp}, {S_ROL,   zp}, {S_RMB2,  zp},
  {S_PLP, impl}, {S_AND,  imm}, {S_ROL, accu}, {S_ILLEGAL,0},
  {S_BIT, abso}, {S_AND, abso}, {S_ROL, abso}, {S_BBR2,zrel},
  {S_BMI,  rel}, {S_AND, indy}, {S_AND,  ind}, {S_ILLEGAL,0},
  {S_BIT,  zpx}, {S_AND,  zpx}, {S_ROL,  zpx}, {S_RMB3,  zp},
  {S_SEC, impl}, {S_AND, absy}, {S_DEC, accu}, {S_ILLEGAL,0},
  {S_BIT, absx}, {S_AND, absx}, {S_ROL, absx}, {S_BBR3,zrel},

  {S_RTI, impl}, {S_EOR, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_EOR,   zp}, {S_LSR,   zp}, {S_RMB4,  zp},
  {S_PHA, impl}, {S_EOR,  imm}, {S_LSR, accu}, {S_ILLEGAL,0},
  {S_JMP, abso}, {S_EOR, abso}, {S_LSR, abso}, {S_BBR4,zrel},
  {S_BVC,  rel}, {S_EOR, indy}, {S_EOR,  ind}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_EOR,  zpx}, {S_LSR,  zpx}, {S_RMB5,  zp},
  {S_CLI, impl}, {S_EOR, absy}, {S_PHY, impl}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_EOR, absx}, {S_LSR, absx}, {S_BBR5,zrel},

  {S_RTS, impl}, {S_ADC, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_STZ,   zp}, {S_ADC,   zp}, {S_ROR,   zp}, {S_RMB6,  zp},
  {S_PLA, impl}, {S_ADC,  imm}, {S_ROR, accu}, {S_ILLEGAL,0},
  {S_JMP, iabs}, {S_ADC, abso}, {S_ROR, abso}, {S_BBR6,zrel},
  {S_BVS,  rel}, {S_ADC, indy}, {S_ADC,  ind}, {S_ILLEGAL,0},
  {S_STZ,  zpx}, {S_ADC,  zpx}, {S_ROR,  zpx}, {S_RMB7,  zp},
  {S_SEI, impl}, {S_ADC, absy}, {S_PLY, impl}, {S_ILLEGAL,0},
  {S_JMP,iabsx}, {S_ADC, absx}, {S_ROR, absx}, {S_BBR7,zrel},

  {S_BRA,  rel}, {S_STA, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_STY,   zp}, {S_STA,   zp}, {S_STX,   zp}, {S_SMB0,  zp},
  {S_DEY, impl}, {S_BIT,  imm}, {S_TXA, impl}, {S_ILLEGAL,0},
  {S_STY, abso}, {S_STA, abso}, {S_STX, abso}, {S_BBS0,zrel},
  {S_BCC,  rel}, {S_STA, indy}, {S_STA,  ind}, {S_ILLEGAL,0},
  {S_STY,  zpx}, {S_STA,  zpx}, {S_STX,  zpy}, {S_SMB1,  zp},
  {S_TYA, impl}, {S_STA, absy}, {S_TXS, impl}, {S_ILLEGAL,0},
  {S_STZ, abso}, {S_STA, absx}, {S_STZ, absx}, {S_BBS1,zrel},

  {S_LDY,  imm}, {S_LDA, indx}, {S_LDX,  imm}, {S_ILLEGAL,0},
  {S_LDY,   zp}, {S_LDA,   zp}, {S_LDX,   zp}, {S_SMB2,  zp},
  {S_TAY, impl}, {S_LDA,  imm}, {S_TAX, impl}, {S_ILLEGAL,0},
  {S_LDY, abso}, {S_LDA, abso}, {S_LDX, abso}, {S_BBS2,zrel},
  {S_BCS,  rel}, {S_LDA, indy}, {S_LDA,  ind}, {S_ILLEGAL,0},
  {S_LDY,  zpx}, {S_LDA,  zpx}, {S_LDX,  zpy}, {S_SMB3,  zp},
  {S_CLV, impl}, {S_LDA, absy}, {S_TSX, impl}, {S_ILLEGAL,0},
  {S_LDY, absx}, {S_LDA, absx}, {S_LDX, absy}, {S_BBS3,zrel},

  {S_CPY,  imm}, {S_CMP, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_CPY,   zp}, {S_CMP,   zp}, {S_DEC,   zp}, {S_SMB4,  zp},
  {S_INY, impl}, {S_CMP,  imm}, {S_DEX, impl}, {S_ILLEGAL,0},
  {S_CPY, abso}, {S_CMP, abso}, {S_DEC, abso}, {S_BBS4,zrel},
  {S_BNE,  rel}, {S_CMP, indy}, {S_CMP,  ind}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_CMP,  zpx}, {S_DEC,  zpx}, {S_SMB5,  zp},
  {S_CLD, impl}, {S_CMP, absy}, {S_PHX, impl}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_CMP, absx}, {S_DEC, absx}, {S_BBS5,zrel},

  {S_CPX,  imm}, {S_SBC, indx}, {S_ILLEGAL,0}, {S_ILLEGAL,0},
  {S_CPX,   zp}, {S_SBC,   zp}, {S_INC,   zp}, {S_SMB6,  zp},
  {S_INX, impl}, {S_SBC,  imm}, {S_NOP, impl}, {S_ILLEGAL,0},
  {S_CPX, abso}, {S_SBC, abso}, {S_INC, abso}, {S_BBS6,zrel},
  {S_BEQ,  rel}, {S_SBC, indy}, {S_SBC,  ind}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_SBC,  zpx}, {S_INC,  zpx}, {S_SMB7,  zp},
  {S_SED, impl}, {S_SBC, absy}, {S_PLX, impl}, {S_ILLEGAL,0},
  {S_ILLEGAL,0}, {S_SBC, absx}, {S_INC, absx}, {S_BBS7,zrel},
};
#endif /* _MAIN_C_ */

#endif /* _OPCODES_H_ */
