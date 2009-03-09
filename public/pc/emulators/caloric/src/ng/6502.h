/*
 *	6502.h
 *	AYM 2003-08-04
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


#ifndef 6502_H
#define 6502_H


#define WORD(addr)	(mem[addr] | mem[addr + 1] << 8)

class X6502 : public Component
{
  public :
    reset ();

  protected :
    unsigned char a;
    unsigned char x;
    unsigned char y;
    unsigned short pc;
    unsigned char s;
    unsigned char p;			/* NV1BDIZC */

  private :
    typedef unsigned char micro_t;
    typedef struct
    {
      unsigned char cycles;
      micro_t todo[5];
    } opcode_t;
    static const opcode_t opcodes[0x100];

    unsigned char insn;
    int c;
    const micro_t *todo;		// Micro install

    unsigned char op1;			// First byte of the operand
    unsigned char op2;			// Second byte of the operand
};


void X6502::reset ()
{
  a  = 0;				// FIXME ?
  x  = 0;				// FIXME ?
  y  = 0;				// FIXME ?
  pc = WORD(0xfffc);
  s  = 0xff;
  p  = 0x20;
}


/*
 *	X6502::cycle - execute one clock cycle
 */
void X6502::cycle ()
{
  if (c == 0)
    fetch ();
  else
  {
    switch (todo[c])
    {
      case '\x00':			// NOP
	;
      case '\x

    }
    c--;
  }
}


void X6502::fetch ()
{
  insn = mem[pc++];

  // Decode the instruction
  todo = opcodes[insn].todo - 1;
  c    = opcodes[insn].cycles;
}


static const X6502::opcodes
{
  unsigned char cycles;
}


#endif
