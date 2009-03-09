/*
 *	clock.S
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


	.global Init_countdown
	.global Clock_countdown
	.global update_clock
	.global init_special_timeout
	.global special_timeout
	.global countdown
	.global global_clock
	.global	Dump_Clock
	.global Restore_Clock

#define CLOCK   %ebp

	.data
special_timeout: .long  -1
Synchro:        .long   20000
countdown:      .long   20000
global_clock:   .long   0

	.text

Dump_Clock:
	movl	special_timeout,%eax
	movl	%eax,State+28
	movl	Synchro,%eax
	movl	%eax,State+32
	movl	countdown,%eax
	movl	%eax,State+36
	movl	global_clock,%eax
	movl	%eax,State+40
	ret

Restore_Clock:
	movl	State+28,%eax
	movl	%eax,special_timeout
	movl	State+32,%eax
	movl	%eax,Synchro
	movl	State+36,%eax
	movl	%eax,countdown
	movl	State+40,%eax
	movl	%eax,global_clock
	ret

Clock_countdown:
	push    %eax
	movl    countdown,%eax
	addl    %eax,global_clock
	subl    %eax,Timer1
	jnz     0f
	call    Timer1_Countdown
0:      movl    countdown,%eax
	subl    %eax,Timer2
	jnz     0f
	call    Timer2_Countdown
0:      movl    countdown,%eax
	subl    %eax,special_timeout
	jnz     0f

	movl    $-1,special_timeout
	cmpb    $1,delayed_intrq
	jne     1f
	movb    $0,delayed_intrq
	call    set_intrq
	jmp     0f
1:      cmpb    $0x40,tape_motor
	jne     0f
	call    set_tape_input

0:      movl    countdown,%eax
	subl    %eax,Synchro
	jnz     Init_countdown

	call    Hardware_synchro
	movl    cycles,%eax
	movl    %eax,Synchro

Init_countdown:
	movl    Synchro,%eax
	cmpl    special_timeout,%eax
	jb      1f
	movl    special_timeout,%eax
1:      cmpl    Timer1,%eax
	jb      1f
	movl    Timer1,%eax
1:      cmpl    Timer2,%eax
	jb      1f
	movl    Timer2,%eax
1:      movl    %eax,countdown
	movl    %eax,CLOCK
	popl    %eax
	ret

update_clock:
	pushl   %eax
	movl    countdown,%eax
	addl    %eax,global_clock
	subl    %eax,Timer1
	subl    %eax,Timer2
	subl    %eax,Synchro
	subl    %eax,special_timeout
	movl    CLOCK,%eax
	movl    %eax,countdown
	subl    %eax,global_clock
	addl    %eax,Timer1
	addl    %eax,Timer2
	addl    %eax,Synchro
	addl    %eax,special_timeout
	popl    %eax
	ret

init_special_timeout:
	pushl   %eax
	call    update_clock
	movl    %eax,special_timeout
	jmp     Init_countdown
