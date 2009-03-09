/*
 *	banks.S - Telestrat memory banks emulation
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

	.global SelectBank
	.global Blank_ram
	.global	InitMemory
	.global	enable_overlay
	.global	enable_rom
	.global	_Banks
	.global	Banks
	.global _RomBank
	.global	RomBank
	.global	_Oric_Mem
	.global	Oric_Mem
	.global	_Eprom
	.global	Eprom
	.global	Ram_Overlay
	.global HighMemWrite
	.global _Bank_point
	.global Bank_point
	.global _Eprom_start
	.global Eprom_start
	.global	_ram_pattern
	.global	ram_pattern
	.global basic_in_ram

	.bss
_Oric_Mem:
Oric_Mem:	.fill	48*1024
_Banks:
Banks:
Ram_Overlay:
Bank0:		.fill	16384
Bank1:		.fill	16384
Bank2:		.fill	16384
Bank3:		.fill	16384
Bank4:		.fill	16384
Bank5:		.fill	16384
Bank6:		.fill	16384
Bank7:		.fill	16384
poubelle:	.fill	16384
_Eprom:
Eprom:		.fill	16384

#define	ROM	    16384
#define DUMMY	8*16384
#define RAM	0
#define	EPROM	9*16384

	.data
_RomBank:
RomBank:	.fill	8
_Eprom_start:
Eprom_start:	.long	0xC000
_Bank_point:
Bank_point:	.long	0xC000
HighMemWrite:	.long	0
_ram_pattern:
ram_pattern:	.byte	0
msg:		.asciz "%d\n"

	.text

trace:
	pushal
	pushl	%eax
	pushl	$msg
	call	MANGLE_SYM(printf)
	addl	$8,%esp
	popal
	ret

InitMemory:
	movl	$DUMMY,HighMemWrite
	cmpb	$1,telestrat
	je	1f
	cmpb	$1,jasmin
	je	0f
	cmpb	$1,disk
	je	2f
0:	movl	$ROM,%edi
	movl	$0xC000,Bank_point
	ret
1:	movl	$7*16384,%edi
	ret
2:	movl	$EPROM,%edi
	ret

basic_in_ram:
	pushal
	movl	$16384,%ecx
	movl	$Oric_Mem+0xC000+ROM,%esi
	movl	$Oric_Mem+0xC000,%edi
	rep
	movsb
	popal
	ret

Blank_ram:
	pushal
/* initialise la ram suivant une des deux polarites */
/* Ca tombe bien, sedoric n'aime pas que la ram overlay soit vide... */
	cmpb	$1,ram_pattern
	je	1f

	movl	$0x4000,%ecx
	movl	$0xFF00FF00,%eax
	movl	$Oric_Mem,%edi
	rep
	stosl
	jmp	blank_io

1:	movl	$2*256,%ebx
	movl	$Oric_Mem,%edi
	movl	$0,%eax
0:	movl	$0x20,%ecx
	rep
	stosl
	notl	%eax
	decl	%ebx
	jnz	0b

blank_io:
	movl	$256,%ecx
	movb	$0,%al
	movl	$Oric_Mem+0x300,%edi
	rep
	stosb

	popal
	ret

SelectBank:
	pushl	%eax
	andl	$7,%eax
	movl	%eax,%edi
	shll	$14,%edi
	movl	%edi,HighMemWrite
	cmpb	$1,RomBank(%eax)
	jne	1f
	movl	$DUMMY,HighMemWrite
1:	popl	%eax
	ret

enable_rom:
	movl	$ROM,%edi
	movl	$DUMMY,HighMemWrite
	ret

enable_overlay:
	movl	$RAM,%edi
	movl	%edi,HighMemWrite
	ret
