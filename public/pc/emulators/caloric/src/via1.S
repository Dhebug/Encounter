/*
 *	via1.S - VIA 6522 emulation
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

	.global Reset_VIA1
	.global Timer1
	.global Timer2
	.global Timer1_Countdown
	.global Timer2_Countdown
	.global PortA
	.global PortB
	.global CA2_CB2
	.global Dump_VIA1
	.global Restart_VIA1
	.global VIA1_Read
	.global VIA1_Write
	.global Read_PortB
	.global Set_VIA1_IRQ

#define PAGE3   Oric_Mem+0x300

#define IRB     Oric_Mem+0x300
#define IRA     Oric_Mem+0x301
#define DDRB    Oric_Mem+0x302
#define DDRA    Oric_Mem+0x303
#define T1C     Oric_Mem+0x304
#define T1L     Oric_Mem+0x306
#define T2      Oric_Mem+0x308
#define SR      Oric_Mem+0x30A
#define ACR     Oric_Mem+0x30B
#define PCR     Oric_Mem+0x30C
#define IFR     Oric_Mem+0x30D
#define IER     Oric_Mem+0x30E

#define clock   %ebp

	.data
Timer1:         .long   -1
Timer2:         .long   -1
PortA:          .byte   255
PortB:          .byte   255
CA2_CB2:        .byte   0
ORA:            .byte   0
ORB:            .byte   0
T2L_L:          .byte   0
T1_running:     .byte   0
T2_running:     .byte   0
mesg:           .asciz "argh\n"
format:         .asciz  "W %x=%x\n"
format1:        .asciz  "adr=%x, W %x = %x\n"
format2:        .asciz  "adr=%x, R %x \n"
		.align  4

VIA1_Write:     .long   Write_ORB
		.long   Write_ORA
		.long   Write_DDRB
		.long   Write_DDRA
		.long   Write_T1L_L
		.long   Write_T1C_H
		.long   Write_T1L_L
		.long   Write_T1L_H
		.long   Write_T2L_L
		.long   Write_T2C_H
		.long   Write_SR
		.long   Write_ACR
		.long   Write_PCR
		.long   Write_IFR
		.long   Write_IER
		.long   Write_ORA_NoHandShake

VIA1_Read:      .long   Read_IRB
		.long   Read_IRA
		.long   Read_DDRB
		.long   Read_DDRA
		.long   Read_T1C_L
		.long   Read_T1C_H
		.long   Read_T1L_L
		.long   Read_T1L_H
		.long   Read_T2C_L
		.long   Read_T2C_H
		.long   Read_SR
		.long   Read_ACR
		.long   Read_PCR
		.long   Read_IFR
		.long   Read_IER
		.long   Read_IRA_NoHandShake

	.text
Reset_VIA1:
	movl    $0,Oric_Mem+0x300
	movl    $0,Oric_Mem+0x304
	movl    $0,Oric_Mem+0x308
	movl    $0,Oric_Mem+0x30C
	movb    $255,PortA
	movb    $255,PortB
	movb    $0,CA2_CB2
	movb    $0,ORA
	movb    $0,ORB
	movb    $0,T2L_L
	movb    $0,T1_running
	movb    $0,T2_running
	movl    $-1,Timer1
	movl    $-1,Timer2
	ret

Restart_VIA1:
	pushal
	movl    $State+12,%esi
	movl    $Timer1,%edi
	movl    $16,%ecx
	rep
	movsb
	popal
	ret

Dump_VIA1:
	pushal
	movl    $State+12,%edi
	movl    $Timer1,%esi
	movl    $16,%ecx
	rep
	movsb
	popal
	ret

#define SET_IRQ \
	movb    IFR,%al; \
	andb    IER,%al; \
	setnzb  %al; \
	andb    $~1,MANGLE_SYM(Sys_Request); \
	orb     %al,MANGLE_SYM(Sys_Request)

trace:
	pushal
	andl $0xFF,%eax
	pushl %eax
	pushl %edx
	pushl $format
	call MANGLE_SYM(printf)
	addl $12,%esp
	popal
	ret

Write_T1L_H:
	movb    %al,T1L+1
	ret

Write_SR:
	movb    %al,SR
	ret

Write_ACR:
	movb    %al,ACR
	ret

Write_ORB:
	movb    %al,ORB
	movb    DDRB,%ah
	andb    %ah,%al
	notb    %ah
	andb    PortB,%ah
	orb     %ah,%al
	movb    %al,PortB
	andb    $~0x18,IFR
	SET_IRQ
Write_PortB:
	call    Read_PortB
	movb    PortB,%al
	testb   $0x10,%al
	jz      Strobe
	andb    $0x40,%al
	cmpb    tape_motor,%al
	jne     2f
	ret
Strobe:
	cmpb	$1,printer
	jne	3f
	pushal
	movzbl  PortA,%eax
	pushl   %eax
	call    MANGLE_SYM(Printer)
	addl    $4,%esp
	popal
	orb     $2,Oric_Mem+0x30D
3:	andb    $0x40,%al
	cmpb    tape_motor,%al
	jne     2f
	ret
2:      call    set_tape_motor
	ret

Write_DDRB:
	movb    %al,DDRB
	movb    ORB,%ah
	andb    %al,%ah
	notb    %al
	orb     %ah,%al
	movb    %al,PortB	/* les broches en entrees sont a 1 */
	jmp     Write_PortB

Write_DDRA:
	movb    %al,DDRA
	movb    ORA,%ah
	andb    %al,%ah
	notb    %al
#       andb    PortA,%al               # pour l instant, rien en entree sur A
	orb     %ah,%al
	movb    %al,PortA
	jmp     Write_PortA

Write_ORA:
	movb    %al,ORA
	movb    DDRA,%ah
	andb    %ah,%al
	notb    %ah
#       andb    PortA,%ah               # idem
	orb     %ah,%al
	movb    %al,PortA
	andb    $~3,IFR
	SET_IRQ
	jmp     Write_PortA

Write_ORA_NoHandShake:
	movb    %al,ORA
	movb    DDRA,%ah
	andb    %ah,%al
	notb    %ah
#       andb    PortA,%ah               # idem
	orb     %ah,%al
	movb    %al,PortA
Write_PortA:
	cmpb    $0xCC,CA2_CB2
	jne     PSG_Action
	ret


Write_PCR:
	movb    %al,PCR
	andb    $0xEE,%al
	movb    %al,CA2_CB2
Write_CA2_CB2:
	jmp     PSG_Action

Write_IER:
	testb   $0x80,%al
	jnz     Or_Bits
	notb    %al
	andb    %al,IER
	SET_IRQ
	ret
Or_Bits:
	andb    $0x7F,%al
	orb     %al,IER
	SET_IRQ
	ret

Write_IFR:
	xorb    $0xFF,%al
	andb    %al,IFR
	SET_IRQ
	ret

Write_T1L_L:
	movb    %al,T1L
	ret

Write_T1C_H:
	call    update_clock
	pushl   %eax
	movb    %al,T1L+1
	andb    $~0x40,IFR
	SET_IRQ
	movzwl  T1L,%eax
	movl    %eax,Timer1
	movb    $1,T1_running
	jmp     Init_countdown


Write_T2L_L:
	movb    %al,T2L_L
	ret


Write_T2C_H:
	call    update_clock
	pushl   %eax
	movb    %al,Timer2+1
	movb    T2L_L,%al
	movb    %al,Timer2
	movw    $0,Timer2+2
	movb    $1,T2_running
	andb    $~0x20,IFR
	SET_IRQ
	jmp     Init_countdown



Read_DDRB:
Read_DDRA:
Read_T1L_L:
Read_T1L_H:
Read_SR:
Read_ACR:
Read_PCR:
	andw    $0x30F,%ax
	movb    Oric_Mem(%eax),%al
	ret
Read_IER:
	movb    IER,%al
	orb     $0x80,%al
	ret

Read_IFR:
	movb    IFR,%al
	andb    IER,%al
	setnzb  %al
	shlb    $7,%al
	orb     IFR,%al
	ret

Read_IRA:
	andb    $~3,IFR
	SET_IRQ
Read_IRA_NoHandShake:
#       testb   $1,ACR                  # CA1 pas utilise pour le latching
#       jnz     1f
	cmpb    $1,joystick
	je      MANGLE_SYM(Read_Joystick_on_printer_port)
	movb    PortA,%al
	ret
1:      movb    IRA,%al
	ret

Read_IRB:
	andb    $~0x18,IFR
	SET_IRQ
	movb    DDRB,%ah
	movb    ORB,%al
	andb    %ah,%al
	notb    %ah
#       testb   $2,ACR
#       jne     1f      # on ne tient pas compte du latching dans IRB
#       call    Read_PortB      # pour accelerer le traitement
	andb    PortB,%ah
	orb     %ah,%al
	ret
1:      andb    IRB,%ah
	orb     %ah,%al
	ret

Read_PortB:
	pushl   %eax
	movzbl  PortB,%eax
	andb    $7,%al
	movb    MANGLE_SYM(Kbd_Matrix)(%eax),%al
	movb    PSG_IO_PortA,%ah
	notb    %ah
	andb    %ah,%al
	setnzb  %al
	shlb    $3,%al
	andb    $~8,PortB
	orb     %al,PortB               /* met a jour bit 3 du port B */
	orb     $0x20,PortB             /* la broche non connectee a 1 (?) */
	popl    %eax
	ret


Read_T1C_H:
	movl    Timer1,%eax
	subl    countdown,%eax
	addl    clock,%eax
	movb    %ah,%al
	ret


Read_T1C_L:
	andb    $~0x40,IFR
	SET_IRQ
	movl    Timer1,%eax
	subl    countdown,%eax
	addl    clock,%eax
	ret


Read_T2C_H:
	movl    Timer2,%eax
	subl    countdown,%eax
	addl    clock,%eax
	movb    %ah,%al
	ret


Read_T2C_L:
	andb    $~0x20,IFR
	SET_IRQ
	movl    Timer2,%eax
	subl    countdown,%eax
	addl    clock,%eax
	ret

Timer1_Countdown:
	movzwl  T1L,%eax
	movl    %eax,Timer1
	cmpb    $1,T1_running
	jne     0f
	orb     $0x40,IFR
	SET_IRQ
	testb   $0x40,ACR
	jnz     0f
	movb    $0,T1_running
	ret
0:      testb   $0x80,ACR
	jnz     1f
	ret
1:      jmp     set_tape_output

Timer2_Countdown:
	orb     $0x20,IFR
	SET_IRQ
	movb    $0,T2_running
	movl    $-1,Timer2
	ret

Set_VIA1_IRQ:
	orb     %al,IFR
	SET_IRQ
	ret
