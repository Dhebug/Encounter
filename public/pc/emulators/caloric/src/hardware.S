/*
 *	hardware.S
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

	.global HARDWARE_PAGE
	.global IO_Write
	.global IO_Read
	.global _Init_Hard
	.global Init_Hard
	.global Hardware_synchro
	.global	_cycles,_initial_cycles
	.global	 cycles, initial_cycles
	.global _telestrat,_jasmin,_disk,_joystick,_joystickport,_acia,_rtclock
	.global  telestrat, jasmin, disk, joystick, joystickport, acia, rtclock
	.global	_printer
	.global	 printer
	.bss
IO_Write:       .fill   256,4
IO_Read:        .fill   256,4
	.data
_cycles:
cycles:		.long	20000
_initial_cycles:
initial_cycles:	.long	20000
_telestrat:
telestrat:	.byte	0
_jasmin:
jasmin:		.byte	0
_disk:
disk:		.byte	0
_joystick:
joystick:	.byte	0
_joystickport:
joystickport:	.byte	0
_acia:
acia:		.byte	0
_rtclock:
rtclock:	.byte	0
_printer:
printer:	.byte	0
HARDWARE_PAGE:  .byte   3
	.text
_Init_Hard:
Init_Hard:
	pushal
	movb    $16,%al
	movl    $IO_Write,%edi
1:      movl    $VIA1_Write,%esi
	movl    $16,%ecx
	rep
	movsl
	decb    %al
	jnz     1b
	movb    $16,%al
	movl    $IO_Read,%edi
2:      movl    $VIA1_Read,%esi
	movl    $16,%ecx
	rep
	movsl
	decb    %al
	jnz     2b

	cmpb    $1,telestrat
	je      telestrat_hardware
	cmpb    $1,jasmin
	je      jasmin_hardware
	cmpb    $1,disk
	je      microdisc_hardware
	popal
	ret

telestrat_hardware:
	movl    $VIA2_Write,%esi
	movl    $IO_Write+4*0x20,%edi
	movl    $16,%ecx
	rep
	movsl
	movl    $VIA2_Read,%esi
	movl    $IO_Read+4*0x20,%edi
	movl    $16,%ecx
	rep
	movsl
	jmp     microdisc_hardware

jasmin_hardware:
	movl    $Oric_Mem+0x3F4,FDC_adr
	movb    $1,Oric_Mem+0x314       /* pour autoriser les interruptions */
	movl    $Jasmin_Write,%esi
	movl    $IO_Write+4*0xF4,%edi
	movl    $12,%ecx
	rep
	movsl
	movl    $Jasmin_Read,%esi
	movl    $IO_Read+4*0xF4,%edi
	movl    $12,%ecx
	rep
	movsl
	jmp     acia_hardware

microdisc_hardware:
	movl    $Oric_Mem+0x310,FDC_adr
	movl    $Microdisc_Write,%esi
	movl    $IO_Write+4*0x10,%edi
	movl    $12,%ecx
	rep
	movsl
	movl    $Microdisc_Read,%esi
	movl    $IO_Read+4*0x10,%edi
	movl    $12,%ecx
	rep
	movsl
acia_hardware:
	cmpb	$0,acia
	je	rtclock_hardware
	movl    $ACIA_Write,%esi
	movl    $IO_Write+4*0x1C,%edi
	movl    $4,%ecx
	rep
	movsl
	movl    $ACIA_Read,%esi
	movl    $IO_Read+4*0x1C,%edi
	movl    $4,%ecx
	rep
	movsl
rtclock_hardware:
	cmpb	$1,rtclock
	jne	end_hardware
	movl    $RTClock_Write,%esi
	movl    $IO_Write+4*0x60,%edi
	movl    $32,%ecx
	rep
	movsl
	movl    $RTClock_Read,%esi
	movl    $IO_Read+4*0x60,%edi
	movl    $32,%ecx
	rep
	movsl
end_hardware:
	popal
	ret

Hardware_synchro:
	pushal
	cmpb    $0,MANGLE_SYM(sound)
	jz      1f
	call    update_sound
1:
	#cmpb    $0,disk
	cmpb    $0,rs232
	jz      0f
	call    poll_serial
0:
	call    MANGLE_SYM(display_frame)
	movb    $0,Tick
	cmpb    $0,MANGLE_SYM(sound)
	jz      1f
	call	output_sound
1:
	popal
	ret
