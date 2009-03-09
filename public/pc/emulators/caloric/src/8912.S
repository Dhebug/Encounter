/*
 *	8912.S - PSG 8912 emulation
 *	FF sometime in 1994-1997
 */

/*
Parts of this file copyright 1994-1997 Fabrice Francès.
Parts of this file copyright 2000-2003 André Majorel.

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

	.global PSG_IO_PortA
	.global PSG_Action
	.global Reset_8912
	.global update_sound
	.global output_sound
	.global toggle_sound
	.global Registers
	.global Values
	.global sound_write

#define SAMPLES 512

	.bss
Dates:          .fill   5000,4
Events:         .fill   5000,2
sound_buffer:   .fill   512+2
randtable:	.fill	4096

	.data
randomptr:      .long   0
last_event:     .long   0
last_global_clock:
		.long   0
Event_ptr:      .long   0
Event_file:     .long   0
PSG_WriteTable: .long   WritePeriodA_Low,WritePeriodA_Hi
		.long   WritePeriodB_Low,WritePeriodB_Hi
		.long   WritePeriodC_Low,WritePeriodC_Hi
		.long   WritePeriodN,WriteControl
		.long   WriteAmplitudeA,WriteAmplitudeB,WriteAmplitudeC
		.long   WriteEnvPeriod_Low,WriteEnvPeriod_Hi
		.long   WriteEnvShape,WriteIO_Port,WriteIO_Port
PSG_Regs:
		.fill   14
PSG_IO_PortA:   .byte   0
		.byte   0       /* PSG_IO_PortB inexistant sur 8912 */
logscale:       .byte   0,2,3,4,6,8,11,16,23,32,45,64,90,128,180,255

.global timerA
.global timerB
.global timerC
.global  timerN
.global  timerE
.global  MANGLE_SYM(periodA)
.global  MANGLE_SYM(periodB)
.global  MANGLE_SYM(periodC)
.global  MANGLE_SYM(periodN)
.global  MANGLE_SYM(periodE)
.global  outputA
.global  outputB
.global  outputC
.global outputN
.global  MANGLE_SYM(controlA)
.global  MANGLE_SYM(controlB)
.global   MANGLE_SYM(controlC)
.global   MANGLE_SYM(controlNA)
.global   MANGLE_SYM(controlNB)
.global  MANGLE_SYM(controlNC)
.global  chanelA
.global  chanelB
.global  chanelC
.global  MANGLE_SYM(amplitudA)
.global  MANGLE_SYM(amplitudB)
.global  MANGLE_SYM(amplitudC)
.global  amplitudE
.global  envelopA
.global envelopB
.global  envelopC
.global   attack
.global    alternate
.global   hold
.global   timerP
.global   period_count
.global    first_period



timerA:         .long   0
timerB:         .long   0
timerC:         .long   0
timerN:         .long   0
timerE:         .long   0
MANGLE_SYM(periodA):        .long   0
MANGLE_SYM(periodB):        .long   0
MANGLE_SYM(periodC):        .long   0
MANGLE_SYM(periodN):        .long   0
MANGLE_SYM(periodE):        .long   0
outputA:        .byte   0
outputB:        .byte   0
outputC:        .byte   0
outputN:        .byte   0
MANGLE_SYM(controlA):       .byte   -1
MANGLE_SYM(controlB):       .byte   -1
MANGLE_SYM(controlC):       .byte   -1
MANGLE_SYM(controlNA):      .byte   -1
MANGLE_SYM(controlNB):      .byte   -1
MANGLE_SYM(controlNC):      .byte   -1
chanelA:        .byte   0
chanelB:        .byte   0
chanelC:        .byte   0
MANGLE_SYM(amplitudA):      .byte   0
MANGLE_SYM(amplitudB):      .byte   0
MANGLE_SYM(amplitudC):      .byte   0
amplitudE:      .byte   0
envelopA:       .byte   0
envelopB:       .byte   0
envelopC:       .byte   0
continue:       .byte   0
attack:         .byte   0
alternate:      .byte   0
hold:           .byte   0
timerP:         .byte   0
period_count:   .byte   0
first_period:   .byte   0

PSG_Reg:        .byte   0

format:         .asciz  "int:%d\n"
mode:           .asciz  "wb"
name:           .asciz  "events.out"

	.text
trace:
	pushal
        movl    last_event,%ebx
        movl    %eax,last_event
        subl    %ebx,%eax
	pushl %eax
	pushl $format
	call MANGLE_SYM(printf)
        addl $8,%esp
	popal
	ret

Reset_8912:
	pushal
	movl    $0,PSG_Regs
	movl    $0,PSG_Regs+4
	movl    $0,PSG_Regs+8
	movl    $0,PSG_Regs+12
	movl	$4096,%ecx
	movl	$randtable,%edi
	cld
1:	pushl	%ecx
	pushl	%edi
	call	MANGLE_SYM(rand)
	popl	%edi
	popl	%ecx
	stosb
	loop	1b
	popal
	ret

PSG_Action:
	cmpb    $0xCE,CA2_CB2
	je      PSG_Read
	cmpb    $0xEC,CA2_CB2
	je      PSG_Write
	cmpb    $0xEE,CA2_CB2
	je      PSG_RegSelect
	ret

PSG_Read:
	pushl   %eax
	movzbl  PSG_Reg,%eax
	movb    PSG_Regs(%eax),%al
	movb    %al,PortA
	popl    %eax
	ret

PSG_Write:
	movb    PSG_Reg,%al
	cmpb    $14,%al
	jne     1f
IO_Port:
	movb    PortA,%al
	movb    %al,PSG_IO_PortA
	jmp     Read_PortB

1:      cmpb	$0,MANGLE_SYM(sound)
	jz	2f
	pushl   %ebx
        pushl   %eax
	movl    Event_ptr,%ebx
	movb    %al,Events(,%ebx,2)
	movb    PortA,%al
	movb    %al,Events+1(,%ebx,2)
	movl    global_clock,%eax
	addl    countdown,%eax
	subl    %ebp,%eax
	movl    %eax,Dates(,%ebx,4)
	incl    Event_ptr
        popl    %eax
	popl    %ebx
2:	ret

PSG_RegSelect:
	movb    PortA,%al
	andb    $0x0F,%al
	movb    %al,PSG_Reg
	ret

WritePeriodA_Low:
	movb    %bl,MANGLE_SYM(periodA)
	ret

WritePeriodA_Hi:
	andb    $0x0F,%bl
	movb    %bl,MANGLE_SYM(periodA)+1
	ret

WritePeriodB_Low:
	movb    %bl,MANGLE_SYM(periodB)
	ret

WritePeriodB_Hi:
	andb    $0x0F,%bl
	movb    %bl,MANGLE_SYM(periodB)+1
	ret

WritePeriodC_Low:
	movb    %bl,MANGLE_SYM(periodC)
	ret

WritePeriodC_Hi:
	andb    $0x0F,%bl
	movb    %bl,MANGLE_SYM(periodC)+1
	ret

WriteAmplitudeA:
	movb    %bl,envelopA
	andb    $0x10,envelopA
	jnz     1f
	andb    $0x0F,%bl
	movb    %bl,MANGLE_SYM(amplitudA)
        ret
1:      movb    amplitudE,%al
        movb    %al,MANGLE_SYM(amplitudA)
        ret

WriteAmplitudeB:
	movb    %bl,envelopB
	andb    $0x10,envelopB
	jnz     1f
	andb    $0x0F,%bl
	movb    %bl,MANGLE_SYM(amplitudB)
        ret
1:      movb    amplitudE,%al
        movb    %al,MANGLE_SYM(amplitudB)
        ret

WriteAmplitudeC:
	movb    %bl,envelopC
	andb    $0x10,envelopC
	jnz     1f
	andb    $0x0F,%bl
	movb    %bl,MANGLE_SYM(amplitudC)
        ret
1:      movb    amplitudE,%al
        movb    %al,MANGLE_SYM(amplitudC)
        ret

WritePeriodN:
        andb    $0x1F,%bl
        movb    %bl,MANGLE_SYM(periodN)
	ret

WriteControl:
	shrb    $1,%bl
	setc    %al
	negb    %al
	movb    %al,MANGLE_SYM(controlA)

	shrb    $1,%bl
	setc    %al
	negb    %al
	movb    %al,MANGLE_SYM(controlB)

	shrb    $1,%bl
	setc    %al
	negb    %al
	movb    %al,MANGLE_SYM(controlC)

	shrb    $1,%bl
	setc    %al
	negb    %al
	movb    %al,MANGLE_SYM(controlNA)

	shrb    $1,%bl
	setc    %al
	negb    %al
	movb    %al,MANGLE_SYM(controlNB)

	shrb    $1,%bl
	setc    %al
	negb    %al
	movb    %al,MANGLE_SYM(controlNC)
	ret

WriteEnvPeriod_Low:
	movb    %bl,MANGLE_SYM(periodE)
	ret

WriteEnvPeriod_Hi:
	movb    %bl,MANGLE_SYM(periodE)+1
	ret

WriteEnvShape:
	movb    $0,period_count
	movb    $1,first_period
	movb    $15,timerP

	shrb    $1,%bl
	setc    %al
	negb    %al
	movb    %al,hold

	shrb    $1,%bl
	setc    %al
	negb    %al
	movb    %al,alternate

	shrb    $1,%bl
	setc    %al
	negb    %al
	movb    %al,attack

	shrb    $1,%bl
	setc    %al
	negb    %al
	movb    %al,continue

	movb    timerP,%al
	xorb    attack,%al
	andb    $0x0F,%al
	cmpb    $0,envelopA
	jz      1f
	movb    %al,MANGLE_SYM(amplitudA)
1:      cmpb    $0,envelopB
	jz      2f
	movb    %al,MANGLE_SYM(amplitudB)
2:      cmpb    $0,envelopC
	jz      3f
	movb    %al,MANGLE_SYM(amplitudC)
3:      ret

WriteIO_Port:
	ret



compute_output:
        subl    $1250,timerA	/* 256*20000*2/SAMPLES/16 */
        jns     timeB
	notb    outputA
	movl    MANGLE_SYM(periodA),%eax
	shll	$8,%eax
        addl    %eax,timerA
	jns	timeB
	movb	$0xFF,outputA
	movl	%eax,timerA

timeB:  subl    $1250,timerB
        jns     timeC
	notb    outputB
	movl    MANGLE_SYM(periodB),%eax
	shll	$8,%eax
        addl    %eax,timerB
	jns	timeC
	movb	$0xFF,outputB
	movl	%eax,timerB

timeC:  subl    $1250,timerC
        jns     timeN
	notb    outputC
	movl    MANGLE_SYM(periodC),%eax
	shll	$8,%eax
        addl    %eax,timerC
	jns	timeN
	movb	$0xFF,outputC
	movl	%eax,timerC

timeN:  subl    $1250,timerN
        jns     timeE
        movl    randomptr,%ebx
        movb    randtable(%ebx),%al
	incl	%ebx
	andl	$4095,%ebx
	movl	%ebx,randomptr
	shrb    $1,%al
	setc    %al
	negb    %al
	movb    %al,outputN
        movb    MANGLE_SYM(periodN),%al
	shll	$8,%eax
        movb    %al,timerN

timeE:  subl    $2500,timerE
        jns     enable_chanels
        movl    MANGLE_SYM(periodE),%eax
	shll	$8,%eax
        movl    %eax,timerE
0:      decb    timerP
	jns     0f
	movb    $15,timerP
	incb    period_count
	movb    $0,first_period
0:      movb    timerP,%al
	cmpb    $0,alternate
	jz      1f
	testb   $1,period_count
	jz      1f
	notb    %al
1:      cmpb    $0,hold
	jz      2f
	cmpb    $0,first_period
	jnz     2f
	movb    alternate,%al
2:      cmpb    $0,attack
	jz      3f
	notb    %al
3:      cmpb    $0,continue
	jnz     4f
	cmpb    $0,first_period
	jnz     4f
	movb    $0,%al
4:      andb    $0x0F,%al
        movb    %al,amplitudE
	cmpb    $0,envelopA
	jz      1f
	movb    %al,MANGLE_SYM(amplitudA)
1:      cmpb    $0,envelopB
	jz      2f
	movb    %al,MANGLE_SYM(amplitudB)
2:      cmpb    $0,envelopC
	jz      3f
	movb    %al,MANGLE_SYM(amplitudC)
3:

enable_chanels:
	movb    outputA,%al
	movb    outputN,%ah
	orb     MANGLE_SYM(controlA),%al
	orb     MANGLE_SYM(controlNA),%ah
	andb    %ah,%al
	movb    %al,chanelA

	movb    outputB,%al
	movb    outputN,%ah
	orb     MANGLE_SYM(controlB),%al
	orb     MANGLE_SYM(controlNB),%ah
	andb    %ah,%al
	movb    %al,chanelB

	movb    outputC,%al
	movb    outputN,%ah
	orb     MANGLE_SYM(controlC),%al
	orb     MANGLE_SYM(controlNC),%ah
	andb    %ah,%al
	movb    %al,chanelC

	movl	$0,%eax
	movl    $0,%ebx
	movb    chanelA,%bl
	andb    MANGLE_SYM(amplitudA),%bl
	movb    logscale(%ebx),%al

	movb    chanelB,%bl
	andb    MANGLE_SYM(amplitudB),%bl
	addb    logscale(%ebx),%al
	adcb	$0,%ah

	movb    chanelC,%bl
	andb    MANGLE_SYM(amplitudC),%bl
	addb    logscale(%ebx),%al
	adcb	$0,%ah
	shrl	$2,%eax
	stosb
	ret

update_sound:
	pushal
	movl    Event_ptr,%ebx
	movl    global_clock,%eax
        addl    $30000,%eax
	movl    %eax,Dates(,%ebx,4)     /* evenement fictif */
	movl    $0,%esi
	movl    $sound_buffer,%edi
	movl    last_global_clock,%edx
	movl    $SAMPLES+2,%ecx		/* pas beau: pour etre sur de traiter tous les events */
loopsound:
	call    compute_output
	addl    $39,%edx		/* 20000/SAMPLES */
1:      cmpl    Dates(,%esi,4),%edx
	jae     take_event
	loop    loopsound
	movl    global_clock,%eax
	movl    %eax,last_global_clock
	movl    $0,Event_ptr
	popal
	ret

take_event:
	movzbl  Events(,%esi,2),%eax
	andb    $0x0f,%al
	movb    Events+1(,%esi,2),%bl
	incl    %esi
	call    *PSG_WriteTable(,%eax,4)
	jmp     1b

output_sound:
	/* Don't write if there's only silence in the buffer.
	   AYM 2003-07-10: disabled this because it defeats the
	   buffering in OSS, and causes some very nasty 1/fps Hz buzz
	   when sound starts again after a period of silence. Should
	   probably keep it as an option for file output, though. */
#if 0
	movl	$sound_buffer,%esi
	movl	$sound_buffer,%edi
	lodsb
	movl	$SAMPLES-1,%ecx
	repe
	scasb
	je	1f
#endif
	pushl   $SAMPLES
	pushl   $sound_buffer
	call    *MANGLE_SYM(sound_write)(,1)
	addl    $8,%esp
1:	ret
