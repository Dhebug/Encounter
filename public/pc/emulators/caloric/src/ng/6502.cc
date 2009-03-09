/*
 *	AYM 2003-08-22
 */

/*
This file is copyright André Majorel 2003.

This program is free software; you can redistribute it and/or modify it under
the terms of version 2 of the GNU General Public License as published by the
Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 59 Temple
Place, Suite 330, Boston, MA 02111-1307, USA.
*/


/*
 *	COMMODITY MACROS AND FUNCTIONS
 */


#define EA ((op2 << 8) | op1)
#define DEC
#define ASL
asl lsr rol ror
  value <<=		NZC
  value >>=		NZC
  value <<=; value |=	NZC
  value >>=; value |=	NZC
inc dec
  value++
  value--
adc sbc cmp cpx cpy
  value +=		NZCV
  value -=		NZCV
  temp = value +	NZCV
  temp = value -	NZCV
ora eor and
  a |= value		NZ
  a ^= value		NZ
  a &= value		NZ
lda
  a = value		NZ
sta


/*
 *	minz - update N and Z according to a value
 */
inline void X6502::minz (unsigned char value)
{
  if (value & 0x80)
    p |= STATUS_N;
  else
    p &= ~STATUS_N;

  if (value == 0)
    p |= STATUS_Z;
  else
    p &= ~STATUS_Z;
}


/*
 *	miload{a,x,y} - load a value into {A,X,Y}
 */
inline void X6502::miloada (unsigned char value) { a = value; minz (a); }
inline void X6502::miloadx (unsigned char value) { x = value; minz (x); }
inline void X6502::miloady (unsigned char value) { y = value; minz (y); }


/*
 *	Bitwise operations
 */
inline void X6502::miand (unsigned char value) { a &= value; minz (a); }
inline void X6502::mieor (unsigned char value) { a ^= value; minz (a); }
inline void X6502::miora (unsigned char value) { a |= value; minz (a); }


/*
 *
 */
inline void X6502::mirol (unsigned char *


/*
 *	Arithmetic operations
 */
inline void X6502::miadc (unsigned char value) { a ; }
inline void X6502::micmp (unsigned char value) { w = a - value; }
inline void X6502::misbc (unsigned char value) { a ; }

inline void X6502::


/*
 *	MICRO-INSTRUCTIONS
 *	Every function corresponds to a cycle of an instruction
 */


/*
 *	mifetch1 - fetch the low byte of the operand
 *
 *	Also works for immediate addressing zero-page addressing.
 */
static void X6502::mifetch1 ()
{
  op1 = mem[pc];
  pc++;
}


/*
 *	mifetch2 - fetch the high byte of the operand
 *
 *	Absolute addressing only.
 */
static void X6502::mifetch2 ()
{
  op2 = mem[pc];
  pc++;
}


/*
 *	mifetch2ax - fetch the high byte of the operand for abs,x
 *
 *	Absolute,x addressing only
 */
static void X6502::mifetch2ax ()
{
  op2 = mem[pc];
  pc++;
  eac = (op1 + x) > 0xff;
  op1 += x;
}


/*
 *	mifetch2ay - fetch the high byte of the operand for abs,y
 *
 *	Absolute,y addressing only
 */
static void X6502::mifetch2ay ()
{
  op2 = mem[pc];
  pc++;
  eac = (op1 + y) > 0xff;
  op1 += y;
}


/*
 *	miadjax - adjust the EA MSB for absolute,x addressing
 */
static void X6502::miadjax ()
{
  data = mem[EA];			// Dummy read
  if (eac)
    op2++;
}


/*
 *	miadjix - adjust the EA for (zp,x) addressing
 */
static void X6502::miadjix ()
{
  data = mem[EA];			// Dummy read
  op1 += x;				// Leave the MSB alone
}


/*
 *	mileaix - reload the EA LSB for (zp,x) addressing
 */
static void X6502::milop1 ()
{
  ptr = EA;
  op1 = mem[ptr];
}


/*
 *	mileaix - reload the EA LSB for (zp,x) addressing
 */
static void X6502::milop2 ()
{
  op2 = mem[ptr + 1];
}


/*
 *	miiy1 - (zp),y addressing, cycle 1
 */
static void X6502::miiy1
{
  ptr = mem[pc];
  pc++;
}


/*
 *	miiy2 - (zp),y addressing, cycle 2
 */
static void X6502::miiy2
{
  op1 = mem[ptr];
}


/*
 *	miiy3 - (zp),y addressing, cycle 3
 */
static void X6502::miiy3 ()
{
  op2 = mem[ptr + 1];
  eac = (op1 + y) > 0xff;
  op1 += y;
}


/*
 *	miiy4 - (zp),y addressing, cycle 4
 */
static void X6502::miiy4 ()
{
  data = mem[EA];			// Dummy read
  if (eac)
    op2++;
}


/*
 *	mii1 - indirect addressing, cycle 1
 */
static void X6502::mii1 ()
{
  ptrl = mem[pc];
  pc++;
}


/*
 *	mii2 - indirect addressing, cycle 2
 */
static void X6502::mii2 ()
{
  ptrh = mem[pc];
  pc++;
}


/*
 *	mii3 - indirect addressing, cycle 3
 */
static void X6502::mii3 ()
{
  op1 = mem[ptrh << 8 | ptrl];		// Use the EA for temporary storage
}


/*
 *	mii4 - indirect addressing, cycle 4
 */
static void X6502::mii4 ()
{
  ptrl++;				// Do NOT adjust the MSB
  pc = (mem[ptrh << 8 | ptrl] << 8) | op1;
}


/*
 *	miadjzx - adjust the EA for zero-page,x addressing
 */
static void X6502::miadjzx ()
{
  data = mem[EA];			// Dummy read
  EA = (ea & 0xff00) | ((ea + x) & 0xff)
  if (eac)

}


/*
 *	miread{a,x,y} - load (EA) into {A,X,Y}
 */
static void X6502::mireada () { miloada (mem[EA]); }
static void X6502::mireadx () { miloadx (mem[EA]); }
static void X6502::miready () { miloady (mem[EA]); }


/*
 *	miset{a,x,y} - load an immediate value into {A,X,Y}
 */
static void X6502::miseta () { miloada (op1); }
static void X6502::misetx () { miloadx (op1); }
static void X6502::misety () { miloady (op1); }


/*
 *	mistore{[axy] - write {A,X,Y} at the EA
 */
static void X6502::mistorea () { mem[EA] = a; }
static void X6502::mistorex () { mem[EA] = x; }
static void X6502::mistorey () { mem[EA] = y; }


static void X6502::miand ()
{
  a |= data;
  miupnz ();
}


#define ASL
template static void X6502::miasl ()
{
  if (data & 0x80)
    s |= STATUS_C;
  else
    s &= ~STATUS_C;
  data <<= 1;
}


static void X6502::milsr ()
{
  if (data & 0x01)
    s |= STATUS_C;
  else
    s &= ~STATUS_C;
  data 
}

