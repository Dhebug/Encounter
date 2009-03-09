/*
 *	via2.S - VIA 6522 emulation
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

	.global	Dump_VIA2
	.global	Restart_VIA2
	.global	VIA2_Write
	.global	VIA2_Read

#define PAGE3	Oric_Mem+0x300
#define	ORB	Oric_Mem+0x320
#define ORA	Oric_Mem+0x321
#define DDRB	Oric_Mem+0x322
#define DDRA	Oric_Mem+0x323

	.data
VIA2_Write:	.long   Write_ORB2
		.long   Write_ORA2
		.long   Write_DDRB2
		.long   Write_DDRA2
		.long   Write_T1L_L2
		.long   Write_T1C_H2
		.long   Write_T1L_L2
		.long   Write_T1L_H2
		.long   Write_T2L_L2
		.long   Write_T2C_H2
		.long   Write_SR2
		.long   Write_ACR2
		.long   Write_PCR2
		.long   Write_IFR2
		.long   Write_IER2
		.long   Write_ORA_NoHandShake2

VIA2_Read:	.long   Read_IRB2
		.long   Read_IRA2
		.long   Read_DDRB2
		.long   Read_DDRA2
		.long   Read_T1C_L2
		.long   Read_T1C_H2
		.long   Read_T1L_L2
		.long   Read_T1L_H2
		.long   Read_T2C_L2
		.long   Read_T2C_H2
		.long   Read_SR2
		.long   Read_ACR2
		.long   Read_PCR2
		.long   Read_IFR2
		.long   Read_IER2
		.long   Read_IRA_NoHandShake2

format:	.asciz	"W %x=%x\n"
format2: .asciz	"R %x=%x\n"
	.text
Reset_VIA2:
	ret

Restart_VIA2:
	movl	$0x0321,%edx
	movb	Oric_Mem(%edx),%al
	jmp	Write_ORA2

Dump_VIA2:
	ret

trace:
	pushal
	andl $0xFF,%eax
	pushl %eax
	addw $0x300,%cx
	pushl %ecx
	pushl $format
	call MANGLE_SYM(printf)
	addl $12,%esp
	popal
	ret
trace2:
	pushal
	andl $0xFF,%eax
	pushl %eax
	addw $0x300,%cx
	pushl %ecx
	pushl $format2
	call MANGLE_SYM(printf)
	addl $12,%esp
	popal
	ret

Write_T1L_L2:
Write_T1L_H2:
Write_T1C_H2:
Write_T2L_L2:
Write_T2C_H2:
Write_SR2:
Write_ACR2:
Write_DDRA2:
Write_DDRB2:
Write_ORB2:
Write_PCR2:
	movb	%al,Oric_Mem(%edx)
	ret


Write_ORA2:
Write_ORA_NoHandShake2:
	movb	%al,Oric_Mem(%edx)
	andb	$7,%al
	jmp 	SelectBank


Write_IER2:
	testb   $0x80,%al
	jnz     Or_Bits
	notb    %al
	andb    %al,Oric_Mem(%edx)
	ret
Or_Bits:
	andb	$0x7F,%al
	orb     %al,Oric_Mem(%edx)
	ret

Write_IFR2:
	xorb    $0xFF,%al
	andb    %al,Oric_Mem(%edx)
	ret

Read_DDRB2:
Read_DDRA2:
Read_T1L_L2:
Read_T1L_H2:
Read_SR2:
Read_ACR2:
Read_PCR2:
Read_IFR2:
Read_T1C_H2:
Read_T1C_L2:
Read_T2C_H2:
Read_T2C_L2:
	movb Oric_Mem(%eax),%al
	ret

Read_IER2:
	movb Oric_Mem(%eax),%al
	orb $0x80,%al
	ret

Read_IRA2:
Read_IRA_NoHandShake2:
	movb    DDRA,%ah
	movb    ORA,%al
	andb    %ah,%al
	notb    %ah
	orb     %ah,%al
	ret

Read_IRB2:
	movb    DDRB,%ah
	movb    ORB,%al
	andb    %ah,%al
	cmpb	$1,joystickport
	je	0f
	notb	%ah
	orb	%ah,%al
	ret
0:	movb	%al,%ah
	call	MANGLE_SYM(Read_Joystick_on_VIA2)
	orb     %ah,%al
	ret
