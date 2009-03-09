/*
 *	time.S
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

	.global _synchronize
	.global synchronize
	.global _Timer_Int
	.global Timer_Int
	.global _init_time
	.global init_time
	.global _restore_time
	.global restore_time
	.global Reset_Time
	.global RTClock_Write
	.global RTClock_Read
	.global _Tick
	.global Tick

#define PAGE3   Oric_Mem+0x300
	.data
RTClock_Write:  .long   Write_HTRCT
		.long   Write_HTRH
		.long   Write_HTRM
		.long   Write_HTRS
		.long   Write_HTRMOI
		.long   Write_HTRQ
		.long   Write_HTRA
		.long   Write_HTRJ
		.long   Write_HTRRCT
		.long   Write_HTRRH
		.long   Write_HTRRM
		.long   Write_HTRRS
		.long   Write_HTRRMO
		.long   Write_HTRRQ
		.long   Write_HTRRA
		.long   Write_HTRRJ

		.long   Write_HTRIFR
		.long   Write_HTRCR
		.long   Write_dummy
		.long   Write_dummy
		.long   Write_dummy, Write_dummy, Write_dummy, Write_dummy
		.long   Write_dummy, Write_dummy, Write_dummy, Write_dummy
		.long   Write_dummy, Write_dummy, Write_dummy, Write_dummy

RTClock_Read:   .long   Read_HTRCT
		.long   Read_HTRH
		.long   Read_HTRM
		.long   Read_HTRS
		.long   Read_HTRMOI
		.long   Read_HTRQ
		.long   Read_HTRA
		.long   Read_HTRJ
		.long   Read_HTRRCT
		.long   Read_HTRRH
		.long   Read_HTRRM
		.long   Read_HTRRS
		.long   Read_HTRRMO
		.long   Read_HTRRQ
		.long   Read_HTRRA
		.long   Read_HTRRJ

		.long   Read_HTRIFR
		.long   Read_HTRCR
		.long   Read_dummy
		.long   Read_dummy
		.long   Read_dummy, Read_dummy, Read_dummy, Read_dummy
		.long   Read_dummy, Read_dummy, Read_dummy, Read_dummy
		.long   Read_dummy, Read_dummy, Read_dummy, Read_dummy

previous_ticks: .long   0
ticks:          .long   0
timebuf:        .long   0
centiemes:      .byte   0
heures:         .byte   0
minutes:        .byte   0
secondes:       .byte   0
mois:           .byte   0
quantieme:      .byte   0
annee:          .byte   0
jour:           .byte   0

_Tick:
Tick:           .byte   0

msg:            .asciz  "W%x=%x\n"
msg2:           .asciz  "R%x=%x\n"

	.text
trace:
	pushal
	andl    $0xFF,%eax
	pushl   %eax
	pushl   %ecx
	pushl   $msg
	call    MANGLE_SYM(printf)
	addl    $12,%esp
	popal
	ret
trace2:
	pushal
	andl    $0xFF,%eax
	pushl   %eax
	pushl   %ecx
	pushl   $msg2
	call    MANGLE_SYM(printf)
	addl    $12,%esp
	popal
	ret

_synchronize:
synchronize:
	movb    $1,Tick
	incl    ticks
	movb    centiemes,%al
	addb    $2,%al
	cmpb    $100,%al
	jge     1f
	movb    %al,centiemes
	ret

1:      subb    $100,%al
	movb    %al,centiemes
	incb    secondes
	cmpb    $60,secondes
	je      2f
	ret

2:      movb    $0,secondes
	incb    minutes
	cmpb    $60,minutes
	je      3f
	ret

3:      movb    $0,minutes
	incb    heures
	cmpb    $24,heures
	je      4f
	ret

4:      movb    $0,heures
	incb    jour
	cmpb    $7,jour
	jne     5f
	movb    $0,jour
5:      movb    $30,%al
	movb    mois,%ah
	cmpb    $2,%ah
	jne     6f
	movb    $28,%al
	testb   $3,annee
	jnz     6f
	movb    $29,%al
6:      cmpb    $8,%ah
	jl      7f
	subb    $8,%ah
7:      shrb    $1,%ah
	jc      8f
	movb    $31,%al
8:      cmpb    quantieme,%al
	je      9f
	incb    quantieme
	ret

9:      movb    $1,quantieme
	cmpb    $12,mois
	je      0f
	incb    mois
	ret
0:      movb    $1,mois
	incb    annee
	cmpb    $100,annee
	je      1f
	ret
1:      movb    $0,annee
	ret

_Timer_Int:
Timer_Int:
	inb     $0x61,%al
	orb     $0x80,%al
	outb    %al,$0x61       /* ack pour le PS2 */

	movb    $0x20,%al
	outb    %al,$0x20
	call    synchronize
	pushal
	call    MANGLE_SYM(poll_keyboard)
	popal
	ret

init_timer:
	movw    $23800,%ax      # 1,19 MHz / 50
	jmp     set_timer

restore_timer:
	movw    $0,%ax
	jmp     set_timer

set_timer:
	outb    %al,$0x40
	movb    %ah,%al
	outb    %al,$0x40
	ret

Reset_Time:
	pushal
	movl    centiemes,%eax
	movl    %eax,Oric_Mem+0x360
	movl    mois,%eax
	movl    %eax,Oric_Mem+0x364
	movb    $8,Oric_Mem+0x371
	popal
	ret

_init_time:
init_time:
	pushal
	pushl   $timebuf
	call    MANGLE_SYM(time)
	addl    $4,%esp
	pushl   $timebuf
	call    MANGLE_SYM(localtime)
	addl    $4,%esp
	movb    (%eax),%bl
	movb    %bl,secondes
	movb    4(%eax),%bl
	movb    %bl,minutes
	movb    8(%eax),%bl
	movb    %bl,heures
	movb    12(%eax),%bl
	movb    %bl,quantieme
	movb    16(%eax),%bl
	incb    %bl
	movb    %bl,mois
	movw    20(%eax),%bx
1:      subw    $100,%bx
	jnc     1b
	addw    $100,%bx
	movb    %bl,annee
	movb    24(%eax),%bl
	decb    %bl
	jns     2f
	movb    $6,%bl
2:      movb    %bl,jour
	popal
	ret

_restore_time:
restore_time:
	pushal
	popal
	ret

Write_HTRCT:
	movb    %al,Oric_Mem(%edx)
	pushl   %eax
	movl    Oric_Mem+0x360,%eax
	movl    %eax,centiemes
	movl    Oric_Mem+0x364,%eax
	movl    %eax,mois
	testb   $0x80,heures
	jz      1f
	andb    $0x7F,heures
	addb    $12,heures
1:      popl    %eax
	ret

Write_HTRH:
Write_HTRM:
Write_HTRS:
Write_HTRMOI:
Write_HTRQ:
Write_HTRA:
Write_HTRJ:
Write_HTRRCT:
Write_HTRRH:
Write_HTRRM:
Write_HTRRS:
Write_HTRRMO:
Write_HTRRQ:
Write_HTRRA:
Write_HTRRJ:
Write_HTRIFR:
Write_HTRCR:
Write_dummy:
	movb    %al,Oric_Mem(%edx)
	ret

Read_HTRCT:
	pushl   %eax
	movl    centiemes,%eax
	movl    %eax,Oric_Mem+0x360
	movl    mois,%eax
	movl    %eax,Oric_Mem+0x364
	testb   $4,Oric_Mem+0x371
	jz      1f
	cmpb    $12,Oric_Mem+0x361
	jl      1f
	subb    $12,Oric_Mem+0x361
	orb     $0x80,Oric_Mem+0x361
1:      popl    %eax
	movb    Oric_Mem+0x360,%al
	ret
Read_HTRH:
Read_HTRM:
Read_HTRS:
Read_HTRMOI:
Read_HTRQ:
Read_HTRA:
Read_HTRJ:
Read_HTRRCT:
Read_HTRRH:
Read_HTRRM:
Read_HTRRS:
Read_HTRRMO:
Read_HTRRQ:
Read_HTRRA:
Read_HTRRJ:
Read_HTRIFR:
Read_HTRCR:
Read_dummy:
	movb    Oric_Mem(%eax),%al
	ret
