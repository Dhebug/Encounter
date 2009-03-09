/*
 *	debug. - guest debugging support
 *	FF sometime in 1994-1997
 */

/*
This file is copyright 1994-1997 Fabrice Francès.

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

#include "support.h"

	.global	debug
	.global	Debug
	.data
#define	A	%bl
#define X	%cl
#define	Y	%ch

MnemoTable:
	.asciz	"BRK","ORA","???","???","???","ORA","ASL","???","PHP","ORA","ASL","AND","???","ORA","ASL","???"
	.asciz	"BPL","ORA","???","???","???","ORA","ASL","???","CLC","ORA","???","???","???","ORA","ASL","???"
	.asciz	"JSR","AND","???","???","BIT","AND","ROL","???","PLP","AND","ROL","AND","BIT","AND","ROL","???"
	.asciz	"BMI","AND","???","???","???","AND","ROL","???","SEC","AND","???","???","???","AND","ROL","???"
	.asciz	"RTI","EOR","???","???","???","EOR","LSR","???","PHA","EOR","LSR","???","JMP","EOR","LSR","???"
	.asciz	"BVC","EOR","???","???","???","EOR","LSR","???","CLI","EOR","???","???","???","EOR","LSR","???"
	.asciz	"RTS","ADC","???","???","???","ADC","ROR","???","PLA","ADC","ROR","???","JMP","ADC","ROR","???"
	.asciz	"BVS","ADC","???","???","???","ADC","ROR","???","SEI","ADC","???","???","???","ADC","ROR","???"


	.asciz	"???","STA","???","???","STY","STA","STX","???","DEY","???","TXA","???","STY","STA","STX","???"
	.asciz	"BCC","STA","???","???","STY","STA","STX","???","TYA","STA","TXS","???","???","STA","???","???"
	.asciz	"LDY","LDA","LDX","???","LDY","LDA","LDX","???","TAY","LDA","TAX","???","LDY","LDA","LDX","???"
	.asciz	"BCS","LDA","???","???","LDY","LDA","LDX","???","CLV","LDA","TSX","???","LDY","LDA","LDX","???"
	.asciz	"CPY","CMP","???","???","CPY","CMP","DEC","???","INY","CMP","DEX","???","CPY","CMP","DEC","???"
	.asciz	"BNE","CMP","???","???","???","CMP","DEC","???","CLD","CMP","???","???","???","CMP","DEC","???"
	.asciz	"CPX","SBC","???","???","CPX","SBC","INC","???","INX","SBC","NOP","SBC","CPX","SBC","INC","???"
	.asciz	"BEQ","SBC","???","???","???","SBC","INC","???","SED","SBC","???","???","???","SBC","INC","???"

opcode:	.byte	0

#define ___ 0
#define IMM 1
#define ZER 2
#define ZIX 3
#define ZIY 4
#define ABS 5
#define ABX 6
#define ABY 7
#define IND 8
#define IIX 9
#define IIY 10
#define REL 11
#define IMP 12

format:         .asciz  "\t\t\tA=%x\tX=%x\tY=%x\tS=%x\t%c%c-%c%c%c%c%c  %x\t%d\n[%c] %04X: "

format0:	.asciz "%s\n"
format1:	.asciz "%s #%x\n"
format2:	.asciz "%s %02x\n"
format3:	.asciz "%s %02x,X\n"
format4:	.asciz "%s %02x,Y\n"
format5:	.asciz "%s %04x\n"
format6:	.asciz "%s %04x,X\n"
format7:	.asciz "%s %04x,Y\n"
format8:	.asciz "%s (%04x)\n"
format9:	.asciz "%s (%02x,X)\n"
format10:	.asciz "%s (%02x),Y\n"
format11:	.asciz "%s %04x\n"

AdrModeTable:
	.byte	IMM,IIX,___,___,___,ZER,ZER,___,IMP,IMM,IMP,___,___,ABS,ABS,___
	.byte	REL,IIY,___,___,___,ZIX,ZIX,___,IMP,ABY,___,___,___,ABX,ABX,___
	.byte	ABS,IIX,___,___,ZER,ZER,ZER,___,IMP,IMM,IMP,___,ABS,ABS,ABS,___
	.byte	REL,IIY,___,___,___,ZIX,ZIX,___,IMP,ABY,___,___,___,ABX,ABX,___
	.byte	IMP,IIX,___,___,___,ZER,ZER,___,IMP,IMM,IMP,___,ABS,ABS,ABS,___
	.byte	REL,IIY,___,___,___,ZIX,ZIX,___,IMP,ABY,___,___,___,ABX,ABX,___
	.byte	IMP,IIX,___,___,___,ZER,ZER,___,IMP,IMM,IMP,___,IND,ABS,ABS,___
	.byte	REL,IIY,___,___,___,ZIX,ZIX,___,IMP,ABY,___,___,___,ABX,ABX,___

	.byte	___,IIX,___,___,ZER,ZER,ZER,___,IMP,___,IMP,___,ABS,ABS,ABS,___
	.byte	REL,IIY,___,___,ZIX,ZIX,ZIY,___,IMP,ABY,IMP,___,___,ABX,___,___
	.byte	IMM,IIX,IMM,___,ZER,ZER,ZER,___,IMP,IMM,IMP,___,ABS,ABS,ABS,___
	.byte	REL,IIY,___,___,ZIX,ZIX,ZIY,___,IMP,ABY,IMP,___,ABX,ABX,ABY,___
	.byte	IMM,IIX,___,___,ZER,ZER,ZER,___,IMP,IMM,IMP,___,ABS,ABS,ABS,___
	.byte	REL,IIY,___,___,___,ZIX,ZIX,___,IMP,ABY,___,___,___,ABX,ABX,___
	.byte	IMM,IIX,___,___,ZER,ZER,ZER,___,IMP,IMM,IMP,___,ABS,ABS,ABS,___
	.byte	REL,IIY,___,___,___,ZIX,ZIX,___,IMP,ABY,___,___,___,ABX,ABX,___

Debug:	.byte	0

	.text


debug:
        cmpb    $1,Debug
        je      0f
        cmpl    $Oric_Mem+0x28127,%esi
/*
	cmpw	$0x040C,1(%esi)
*/
	je      0f
	ret

0:	movb	$1,Debug
	pushal
	xorl    %eax,%eax
	movb	$0x30,%al
	subl	$Oric_Mem,%esi
	cmpl	Bank_point,%esi
	jb	1f
	subl	%edi,%esi
1:	shrl	$14,%edi
	addl	%edi,%eax
	pushl	%esi
	pushl   %eax
	pushl	%ebp
	movb	MANGLE_SYM(Sys_Request),%al
	pushl	%eax
	movb    $'C',%al
	testb   $1,MANGLE_SYM(Carry)
	jnz     1f
	movb    $'-',%al
1:      pushl   %eax
	movb    $'Z',%al
	testb   $0x40,%bh
	jnz     1f
	movb    $'-',%al
1:      pushl   %eax
	movb    $'I',%al
	testb   $4,MANGLE_SYM(Flags)
	jnz     1f
	movb    $'-',%al
1:      pushl   %eax
	movb    $'D',%al
	testb   $8,MANGLE_SYM(Flags)
	jnz     1f
	movb    $'-',%al
1:      pushl   %eax
	movb    $'B',%al
	testb   $0x10,MANGLE_SYM(Flags)
	jnz     1f
	movb    $'-',%al
1:      pushl   %eax
	movb    $'V',%al
	testb   $1,MANGLE_SYM(Overflow)
	jnz     1f
	movb    $'-',%al
1:      pushl   %eax
	movb    $'N',%al
	testb   $0x80,%bh
	jnz     1f
	movb    $'-',%al
1:      pushl   %eax
	movb    MANGLE_SYM(S),%al
	pushl   %eax
	movb    Y,%al
	pushl   %eax
	movb    X,%al
	pushl   %eax
	movb    A,%al
	pushl   %eax
	pushl   $format
	call    MANGLE_SYM(printf)
	addl    $64,%esp
	popal

	pushal
	xorl	%eax,%eax
	xorl	%ebx,%ebx
	lodsw
	movb	%ah,%bl
	movb	$0,%ah
	movb	%al,opcode
	movb	AdrModeTable(%eax),%al
	cmpb	$0,%al
	jne	1f
	pushl	%ebx
	movl	$format0,%esi
	jmp	printadrmode
1:	cmpb	$1,%al
	jne	1f
	pushl	%ebx
	movl	$format1,%esi
	jmp	printadrmode
1:	cmpb	$2,%al
	jne	1f
	pushl	%ebx
	movl	$format2,%esi
	jmp	printadrmode
1:	cmpb	$3,%al
	jne	1f
	pushl	%ebx
	movl	$format3,%esi
	jmp	printadrmode
1:	cmpb	$4,%al
	jne	1f
	pushl	%ebx
	movl	$format4,%esi
	jmp	printadrmode
1:	cmpb	$5,%al
	jne	1f
	lodsb
	movb	%al,%bh
	pushl	%ebx
	movl	$format5,%esi
	jmp	printadrmode
1:	cmpb	$6,%al
	jne	1f
	lodsb
	movb	%al,%bh
	pushl	%ebx
	movl	$format6,%esi
	jmp	printadrmode
1:	cmpb	$7,%al
	jne	1f
	lodsb
	movb	%al,%bh
	pushl	%ebx
	movl	$format7,%esi
	jmp	printadrmode
1:	cmpb	$8,%al
	jne	1f
	lodsb
	movb	%al,%bh
	pushl	%ebx
	movl	$format8,%esi
	jmp	printadrmode
1:	cmpb	$9,%al
	jne	1f
	pushl	%ebx
	movl	$format9,%esi
	jmp	printadrmode
1:	cmpb	$10,%al
	jne	1f
	pushl	%ebx
	movl	$format10,%esi
	jmp	printadrmode
1:	cmpb	$11,%al
	jne	1f
	movsbl	%bl,%ebx
	addl	%esi,%ebx
	subl	$Oric_Mem,%ebx
	subl	$0xC000,%ebx
	js	2f
	andl	$0x3FFF,%ebx
2:	addl	$0xC000,%ebx
	pushl	%ebx
	movl	$format11,%esi
	jmp	printadrmode
1:
	pushl	%ebx
	movl	$format0,%esi
printadrmode:
	movb	opcode,%al
	leal	MnemoTable(,%eax,4),%eax
	pushl	%eax
	pushl	%esi
	call	MANGLE_SYM(printf)
	addl	$12,%esp
	popal
	ret

