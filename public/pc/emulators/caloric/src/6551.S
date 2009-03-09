/*
 *	6551.S - UART 6551 emulation
 *	FF sometime in 1994-1997
 */

/*
Parts of this file copyright 1994-1997 Fabrice Francès.
Parts of this file copyright 2003 André Majorel.

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
#include "support.h"

	.global Reset_6551
	.global _Com_port,_Com_Addr,_serial_desc,_serial,_rs232
	.global  Com_port, Com_Addr,serial_desc, serial, rs232
	.global ACIA_Write
	.global ACIA_Read
	.global	poll_serial

	.bss
Rcv_Buffer:     .fill   256
tempbuf:	.fill	256
	.data
ACIA_Write:     .long   Write_ACIA_Data
		.long   Write_ACIA_Reset
		.long   Write_ACIA_Command
		.long   Write_ACIA_Control

ACIA_Read:      .long   Read_ACIA_Data
		.long   Read_ACIA_Status
		.long   Read_ACIA_Command
		.long   Read_ACIA_Control

#if 0
Int_Functions:  .long   Modem_Status_Int, Transmit_Data_Int, Receive_Data_Int, Line_Status_Int
#endif

_serial:
serial:		.long	0
_Com_port:
Com_port:       .long   0
_Com_Addr:
Com_Addr:       .long   0x03F8
_serial_desc:
serial_desc:	.long	0

get_ptr:        .long   0
put_ptr:        .long   0

DivisorTab:
	.word   0, 2304,1536,1047,857,768,384,192,96,64,48,32,24,16,12,6
LCR:    .byte   0
Errors: .byte   0b0000,0b1000,0b0100,0b1100
	.byte   0b0001,0b1001,0b0101,0b1101
	.byte   0b0010,0b1010,0b0110,0b1110
	.byte   0b0011,0b1011,0b0111,0b1111

DataReg:        .byte   0
StatusReg:      .byte   0
CommandReg:     .byte   0
ControlReg:     .byte   0

Int_Status:     .byte   0
Int_LSR:        .byte   0

Enable_Receive_IRQ:	.byte	0
Enable_Transmit_IRQ:	.byte	0
Data_Ready:		.byte	0

_rs232:
rs232:		.long	0

mesg1:  .asciz  "W%x : %x\n"
mesg2:  .asciz  "R%d\n"

	.text
trace1:
	pushal
	andl    $0xFF,%eax
	pushl   %eax
	pushl   %edx
	pushl   $mesg1
	call    MANGLE_SYM(printf)
	addl    $12,%esp
	popal
	ret
trace2:
	pushal
	andl    $0xFF,%eax
	pushl   %eax
	pushl   $mesg2
	call    MANGLE_SYM(printf)
	addl    $8,%esp
	popal
	ret

traceout:
	pushal
	andl    $0xFF,%eax
	pushl   %eax
	pushl   %edx
	pushl   $mesg1
	call    MANGLE_SYM(printf)
	addl    $12,%esp
	popal
	ret

tracein:
	pushal
	andl    $0xFF,%eax
	pushl   %eax
	pushl   %edx
	pushl   $mesg2
	call    MANGLE_SYM(printf)
	addl    $12,%esp
	popal
	ret

Reset_6551:
Write_ACIA_Reset:
	movl	rs232,%eax
	cmpl	$0,%eax
	je	1f
	movl    Com_Addr,%edx
	addb    $4,%dl
	movb    $0,%al
	outb    %al,%dx         /* modem control : DTR, RTS, OUT1 & OUT2 */
1:	movb	$0,Enable_Receive_IRQ
	movb	$0,Enable_Transmit_IRQ
	movb	$0,Data_Ready
	ret

Write_ACIA_Command:

/* Command Register : bits

765 : parity check controls
        xx0 : no parity
        001 : odd
        011 : even
        101 : mark
        111 : space
4 : normal/echo mode for receiver (0 : normal, 1 : echo (bits 2&3 should be 0))
32 : transmitter control
        00 : transmit interrupt disabled, RTS=0, transmitter off
        01 :    "         "     enabled,  RTS=1,       "     on
        10 :    "         "     disabled, RTS=1,       "     on
        11 :    "         "     disabled, RTS=1, transmit BRK
1 : receiver interrupt enable
        0 : IRQ interrupt enabled from bit 3 of Status Register
        1 : IRQ      "    disabled
0 : data terminal ready
        0 : DTR=0, receiver inactive, all interrupts disabled
        1 : DTR=1,   "      active,   "       "      enabled

*/
	movb    %al,CommandReg

	movl	rs232,%eax
	cmpl	$0,%eax
	jne	1f
	ret
1:
	pushl   %ecx
	movl    Com_Addr,%edx
	addb    $4,%dl
	movb    %al,%cl
	andb    $0x10,%al               /* garde bit loopback mode */
dtr:
	testb   $1,%cl
	jz      rts
	orb     $0x0D,%al               /* ajoute DTR, OUT1 et OUT2 */
rts:
	testb   $12,%cl
	jz      0f
	orb     $2,%al                  /* ajoute RTS */
0:
	outb    %al,%dx                 /* pour le modem status */
	movb	%cl,%al
	andb	$2,%al
	shlb	$6,%al
	xorb	$0x80,%al
	movb	%al,Enable_Receive_IRQ
	movb	%cl,%al
	andb	$4,%al
	shlb	$5,%al
	movb	%al,Enable_Transmit_IRQ
	jmp     SetControl

Write_ACIA_Control:
/*
7 : stop bits (0 -> 1 stop bit, 1 -> 2 stop bits)
65 : word length ( 00 : 8 bits, 01 : 7, 10 : 6, 11 : 5)
4 : receiver clock source ( 0 : external receiver clock, 1 : baud rate generator)
        should be 1 on the oric
3210 : baud rate generator
        0000 : 16x external clock
        0001 : 50 baud
        0010 : 110
        0100 : 135
        0101 : 150
        0110 : 300
        0111 : 600
        1000 : 1200
        1001 : 1800
        1010 : 2400
        1011 : 3600
        1100 : 4800
        1101 : 7200
        1110 : 9600
        1111 : 19200

*/
	movb    %al,ControlReg

	movl	rs232,%eax
	cmpl	$0,%eax
	jne	1f
	ret
1:
	pushl   %ecx
	movl	$0,%ecx
	movl    Com_Addr,%edx
	movb    %al,%cl
	andb    $0x0F,%cl               /* baud rate dans %cl */
	movb    LCR,%al                 /* last LCR */
	orb     $0x80,%al
	addb    $3,%dl
	outb    %al,%dx                 /* access divisor latch */
	movb    DivisorTab(,%ecx,2),%al
	subb    $3,%dl
	outb    %al,%dx                 /* write divisor latch LSB */
	incb    %dl
	movb    DivisorTab+1(,%ecx,2),%al
	outb    %al,%dx                 /* write divisor latch MSB */
	movb    LCR,%al
	addb    $2,%dl
	outb    %al,%dx                 /* restores LCR */

SetControl:
	movl    Com_Addr,%edx
	movb    ControlReg,%al
	shrb    $5,%al
	xorb    $3,%al                  /* stop bit & word length dans %al */
	movb    CommandReg,%cl
	andb    $0xE0,%cl
	shrb    $2,%cl                  /* parity control dans %cl */
	orb     %cl,%al
	addb    $3,%dl
	outb    %al,%dx                 /* write LCR */
	movb    %al,LCR
clear:  movl    Com_Addr,%edx
	addb    $2,%dl
	inb     %dx,%al                 /* read IIR */
	shrb    $1,%al
	jc      ok
	addb    $3,%dl
	inb     %dx,%al
	incb    %dl
	inb     %dx,%al
	subb    $6,%dl
	inb     %dx,%al
	jmp     clear
ok:     popl    %ecx
	ret

Write_ACIA_Data:
	movl	rs232,%eax
	cmpl	$0,%eax
	je	1f
	movl    Com_Addr,%edx
	outb    %al,%dx
1:	ret

Read_ACIA_Status:

/*
bit     status
7       IRQ  (1=Interrupt)      read status register to clear
6       DSR  (reflects inversed DSR state, 1: data set NOT ready)
5       DCD  ( "          "     DCD  "   , 1: NO carrier)
4       TDRE ( 1: transmit data register empty) write transmit data reg to clear
3       RDRF ( 1: receive data register full) read receive register to clear
2       overrun (1=error)       read receiver to clear
1       framing (1=error)         "       "    "  "
0       parity  (1=error)         "       "    "  "

IRQs (bit 7) are generated in 4 conditions :
        receive data register full (if enabled by bit 1 of Command Reg.)
        transmit data register empty (if enabled by bits 32 of Command Reg.)
        change on DCD state (bit 5 reflects the state of inversed DCD)
        change on DSR state (bit 6  "          "            "     DSR)
provided that interrupts are enabled with bit 0 of Command Reg.

*/
	movl	rs232,%eax	/* If RS-232 emulation is disabled, */
	cmpl	$0,%eax		/* make it look like it's busy. */
	jne	1f
	movb	$0x70,%al
	ret
1:	pushl   %edx
	pushl   %ecx
	movl	$0,%ecx
	movl    Com_Addr,%edx
	addb    $5,%dl
	inb     %dx,%al         /* read LSR */
	movb    %al,%cl
	incb    %dl
	inb     %dx,%al         /* read MSR */
	shlb    $2,%cl
	shlb    $1,%al
	rcrb    $1,%cl
	shlb    $2,%al
	rcrb    $1,%cl          /* rajoute DCD et DSR dans %cl */
	movb    %cl,%al
	shrb    $1,%al
	andb    $0x70,%al       /* garde DSR, DCD et THRE */
	xorb    $0x60,%al       /* inverse DCD et DSR */
	andb	$0x0E,%cl
	orb	Data_Ready,%cl
	movb    Errors(%ecx),%cl
	orb	Int_Status,%cl
	movb    $0,Int_Status
	andb    $0x7F,MANGLE_SYM(Sys_Request)
	orb     %cl,%al
	popl    %ecx
	popl    %edx
	ret
1:
	inb     %dx,%al         /* read LSR */
	andb    $0x20,%al       /* seulement le bit THRE */
	shlb    $2,%al          /* THRE en bit 7 */
	movb    %al,%cl
	incb    %dl
	inb     %dx,%al         /* read MSR */
	shlb    $1,%al          /* sort DCD */
	rcrb    $1,%cl          /* et le fait rentrer a gauche de THRE */
	shlb    $2,%al          /* sort DSR */
	rcrb    $2,%cl          /* et le fait rentrer a gauche de DCD */
	movb    %cl,%al
	xorb    $0x60,%al       /* inverse DSR et DCD */
	orb     Int_Status,%al  /* ajoute la raison de l'interruption */
	popl    %ecx
	popl    %edx
	andb    $0x7F,MANGLE_SYM(Sys_Request)
	movb    $0,Int_Status
	ret

Read_ACIA_Command:
	movb    CommandReg,%al
	ret

Read_ACIA_Control:
	movb    ControlReg,%al
	ret

Read_ACIA_Data:
	movb    put_ptr,%al
	cmpb    get_ptr,%al
	jne     1f
	movb	DataReg,%al
	ret
1:	pushl   %ebx
	movl    get_ptr,%ebx
	movb    Rcv_Buffer(%ebx),%al
	incb    %bl
	movb    %bl,get_ptr
	cmpb    put_ptr,%bl
	popl	%ebx
	movb	%al,DataReg
	je	2f
	andb	$~0x80,MANGLE_SYM(Sys_Request)
	movb	Enable_Receive_IRQ,%al
	orb	%al,MANGLE_SYM(Sys_Request)
	movb	$1,Data_Ready
	movb    $0x80,Int_Status
	movb	DataReg,%al
	ret
2:	andb	$~0x80,MANGLE_SYM(Sys_Request)
	movb	$0,Data_Ready
	ret



poll_serial:
	pushal
	cmpl	$-1,serial_desc
	je	dontread
	movb	get_ptr,%al
	subb	put_ptr,%al
	decb	%al		/* evite le debordement du buffer */
	jz	dontread
	andl	$0xFF,%eax
	pushl	%eax
	pushl	$tempbuf
	pushl	serial_desc
	call	MANGLE_SYM(read)
	addl	$12,%esp
	cmpl	$-1,%eax
	je	dontread
	movl	%eax,%ecx
	jecxz	dontread
	movb	put_ptr,%bl
	andl	$0xFF,%ebx
	movl	$tempbuf,%esi
1:	lodsb
	movb	%al,Rcv_Buffer(%ebx)
	incb	%bl
	loop	1b
	movb	%bl,put_ptr
	movb	$1,Data_Ready
	movb	$0x80,Int_Status
	movb	Enable_Receive_IRQ,%al
	orb	%al,MANGLE_SYM(Sys_Request)
dontread:
	movb	Enable_Transmit_IRQ,%al
	orb	%al,MANGLE_SYM(Sys_Request)
	popal
	ret
