/*
 *	tape.S - tape emulation
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

        .global set_tape_output
        .global tape_output
        .global set_tape_input
        .global tape_motor
        .global set_tape_motor
        .global _record
        .global record
        .global _HardwareTape
        .global HardwareTape
	.global	_tape_handle
	.global tape_handle
	.global	_protected_tape
	.global	protected_tape

        .data
_tape_handle:
tape_handle:	.long	0
last_time:      .long   0
length:         .long   0
_protected_tape:
protected_tape:	.byte	0
_record:
record:         .byte   0
tape_motor:     .byte   0
shifter:        .byte   0
shift_count:    .byte   0
_HardwareTape:
HardwareTape:	.byte   0
blank_tape:     .asciz  "________"
format:         .asciz  "edge=%d\n"
format2:        .asciz  "readbyte=%x\n"

        .text
set_tape_motor:
        testb   $0x40,%al
        jz      motor_off

        movb    $0x40,tape_motor
        cmpb    $0,HardwareTape
        jz      2f
        cmpb    $1,record
        je      1f
        movl    $50000,special_timeout
        ret
1:      movl    global_clock,%eax
        movl    %eax,last_time
        cmpl    $0,tape_handle
        jnz     2f
        pushal
        call    MANGLE_SYM(Create_Tape)
        popal
2:      ret

motor_off:
        movb    $0,tape_motor
        cmpb    $0,HardwareTape
        jz      1f
        cmpb    $1,record
        jne     1f
        orb     $0x80,PortB
flush:  call    output_tape_level
        cmpb    $0,shift_count
        jnz     flush
1:      ret

set_tape_input:
        movb    $0x10,%al
        call    Set_VIA1_IRQ
        movl    $0,length
1:      addl    $208,length
        call    input_tape_level
        jc      1b
2:      addl    $208,length
        call    input_tape_level
        jnc     2b
set_pulse_duration:
        movl    length,%eax
        movl    %eax,special_timeout
        ret

input_tape_level:
        cmpb    $0,shift_count
        jnz     1f
        call    read_tape_byte
        movb    $8,shift_count
1:      decb    shift_count
        shlb    $1,shifter
        ret

read_tape_byte:
        pushal
        cmpl    $0,tape_handle
        jz      1f
        pushl   tape_handle
        call    MANGLE_SYM(fgetc)
        addl    $4,%esp
        cmpl    $-1,%eax
        je      1f
        movb    %al,shifter
        popal
        ret
1:      popal
        addl    $8,%esp         /* echappement */
        movl    $1000000,length
        jmp     set_pulse_duration

set_tape_output:
        cmpb    $1,record
        jne     1f
        pushl   %eax
        movl    global_clock,%eax
        subl    last_time,%eax

sample: subl    $200,%eax
        jc     2f
        call    output_tape_level
        jmp     sample
2:      movl    global_clock,%eax
        movl    %eax,last_time
        popl    %eax
1:      xorb    $0x80,PortB
        ret

output_tape_level:
        pushal
        movl    $0,%eax
        movb    PortB,%al
        shlb    $1,%al
        rclb    $1,shifter
        incb    shift_count
        cmpb    $8,shift_count
        je      output_byte
        popal
        ret

output_byte:
        movb    $0,shift_count
        cmpl    $0,tape_handle
        jz      1f
        cmpb    $0,protected_tape
        jnz     1f
        movb    shifter,%al
        pushl   tape_handle
        pushl   %eax
        call    MANGLE_SYM(fputc)
        addl    $8,%esp
1:      popal
        ret
