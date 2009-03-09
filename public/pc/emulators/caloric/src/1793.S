/*
 *	1793.S - FDC 1793 emulation
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
	.global Reset_1793
	.global Restart_1793
	.global Dump_1793
	.global Microdisc_Read
	.global Microdisc_Write
	.global Jasmin_Read
	.global Jasmin_Write
	.global FDC_adr
	.global set_intrq
	.global delayed_intrq
	.global _read_track,_reinvoke_fdc_command
	.global  read_track, reinvoke_fdc_command
	.global	_diskbuf
	.global	diskbuf
	.global _fd,_write_only,_nbdisks,_drives
	.global  fd, write_only, nbdisks, drives


#define STATUS          0(%ecx)
#define TRACK_REG       1(%ecx)
#define SECT_REG        2(%ecx)
#define DATA_REG        3(%ecx)

#define MICRODISC_SELECT        Oric_Mem+0x314
#define MICRODISC_READY         Oric_Mem+0x318

#define JASMIN_ORMA             Oric_Mem+0x3FA
#define JASMIN_ROMDIS           Oric_Mem+0x3FB

#define RAM     0
#define ROM     16384
#define DUMMY   8*16384
#define EPROM   9*16384
	.bss
_diskbuf:
diskbuf:	.fill	8192
	.data
crctab:
	.word   0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50A5, 0x60C6, 0x70E7
	.word   0x8108, 0x9129, 0xA14A, 0xB16B, 0xC18C, 0xD1AD, 0xE1CE, 0xF1EF
	.word   0x1231, 0x0210, 0x3273, 0x2252, 0x52B5, 0x4294, 0x72F7, 0x62D6
	.word   0x9339, 0x8318, 0xB37B, 0xA35A, 0xD3BD, 0xC39C, 0xF3FF, 0xE3DE
	.word   0x2462, 0x3443, 0x0420, 0x1401, 0x64E6, 0x74C7, 0x44A4, 0x5485
	.word   0xA56A, 0xB54B, 0x8528, 0x9509, 0xE5EE, 0xF5CF, 0xC5AC, 0xD58D
	.word   0x3653, 0x2672, 0x1611, 0x0630, 0x76D7, 0x66F6, 0x5695, 0x46B4
	.word   0xB75B, 0xA77A, 0x9719, 0x8738, 0xF7DF, 0xE7FE, 0xD79D, 0xC7BC
	.word   0x48C4, 0x58E5, 0x6886, 0x78A7, 0x0840, 0x1861, 0x2802, 0x3823
	.word   0xC9CC, 0xD9ED, 0xE98E, 0xF9AF, 0x8948, 0x9969, 0xA90A, 0xB92B
	.word   0x5AF5, 0x4AD4, 0x7AB7, 0x6A96, 0x1A71, 0x0A50, 0x3A33, 0x2A12
	.word   0xDBFD, 0xCBDC, 0xFBBF, 0xEB9E, 0x9B79, 0x8B58, 0xBB3B, 0xAB1A
	.word   0x6CA6, 0x7C87, 0x4CE4, 0x5CC5, 0x2C22, 0x3C03, 0x0C60, 0x1C41
	.word   0xEDAE, 0xFD8F, 0xCDEC, 0xDDCD, 0xAD2A, 0xBD0B, 0x8D68, 0x9D49
	.word   0x7E97, 0x6EB6, 0x5ED5, 0x4EF4, 0x3E13, 0x2E32, 0x1E51, 0x0E70
	.word   0xFF9F, 0xEFBE, 0xDFDD, 0xCFFC, 0xBF1B, 0xAF3A, 0x9F59, 0x8F78
	.word   0x9188, 0x81A9, 0xB1CA, 0xA1EB, 0xD10C, 0xC12D, 0xF14E, 0xE16F
	.word   0x1080, 0x00A1, 0x30C2, 0x20E3, 0x5004, 0x4025, 0x7046, 0x6067
	.word   0x83B9, 0x9398, 0xA3FB, 0xB3DA, 0xC33D, 0xD31C, 0xE37F, 0xF35E
	.word   0x02B1, 0x1290, 0x22F3, 0x32D2, 0x4235, 0x5214, 0x6277, 0x7256
	.word   0xB5EA, 0xA5CB, 0x95A8, 0x8589, 0xF56E, 0xE54F, 0xD52C, 0xC50D
	.word   0x34E2, 0x24C3, 0x14A0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405
	.word   0xA7DB, 0xB7FA, 0x8799, 0x97B8, 0xE75F, 0xF77E, 0xC71D, 0xD73C
	.word   0x26D3, 0x36F2, 0x0691, 0x16B0, 0x6657, 0x7676, 0x4615, 0x5634
	.word   0xD94C, 0xC96D, 0xF90E, 0xE92F, 0x99C8, 0x89E9, 0xB98A, 0xA9AB
	.word   0x5844, 0x4865, 0x7806, 0x6827, 0x18C0, 0x08E1, 0x3882, 0x28A3
	.word   0xCB7D, 0xDB5C, 0xEB3F, 0xFB1E, 0x8BF9, 0x9BD8, 0xABBB, 0xBB9A
	.word   0x4A75, 0x5A54, 0x6A37, 0x7A16, 0x0AF1, 0x1AD0, 0x2AB3, 0x3A92
	.word   0xFD2E, 0xED0F, 0xDD6C, 0xCD4D, 0xBDAA, 0xAD8B, 0x9DE8, 0x8DC9
	.word   0x7C26, 0x6C07, 0x5C64, 0x4C45, 0x3CA2, 0x2C83, 0x1CE0, 0x0CC1
	.word   0xEF1F, 0xFF3E, 0xCF5D, 0xDF7C, 0xAF9B, 0xBFBA, 0x8FD9, 0x9FF8
	.word   0x6E17, 0x7E36, 0x4E55, 0x5E74, 0x2E93, 0x3EB2, 0x0ED1, 0x1EF0

Microdisc_Write:
		.long   Write_FDC_Command
		.long   Write_FDC_Seek
		.long   Write_FDC_Sector
		.long   Write_FDC_Data
		.long   Write_Microdisc_Select
		.long   Write_dummy
		.long   Write_dummy
		.long   Write_dummy
		.long   Write_dummy
		.long   Write_dummy
		.long   Write_dummy
		.long   Write_dummy
Jasmin_Write:
		.long   Write_FDC_Command
		.long   Write_FDC_Seek
		.long   Write_FDC_Sector
		.long   Write_FDC_Data
		.long   Write_Jasmin_Side_Select
		.long   Write_Jasmin_DCR
		.long   Write_Jasmin_ORMA
		.long   Write_Jasmin_ROMDIS
		.long   Write_Jasmin_disk1
		.long   Write_Jasmin_disk2
		.long   Write_Jasmin_disk3
		.long   Write_Jasmin_disk4
Microdisc_Read:
		.long   Read_FDC_Status
		.long   Read_FDC_Seek
		.long   Read_FDC_Sector
		.long   Read_FDC_Data
		.long   Read_Microdisc_Select
		.long   Read_dummy
		.long   Read_dummy
		.long   Read_dummy
		.long   Read_Microdisc_Ready
		.long   Read_dummy
		.long   Read_dummy
		.long   Read_dummy
Jasmin_Read:
		.long   Read_FDC_Status
		.long   Read_FDC_Seek
		.long   Read_FDC_Sector
		.long   Read_FDC_Data
		.long   Read_Jasmin_Side_Select
		.long   Read_Jasmin_DCR
		.long   Read_Jasmin_ORMA
		.long   Read_Jasmin_ROMDIS
		.long   Read_Jasmin_disk1
		.long   Read_Jasmin_disk2
		.long   Read_Jasmin_disk3
		.long   Read_Jasmin_disk4

_fd:
fd:		.fill	4,4
_write_only:
write_only:	.fill	4
_drives:
drives:		.fill	4
_nbdisks:
nbdisks:	.long	0
id_contents:    .long   0
id_mask:        .long   0

FDC_adr:        .long   0
disk_select:    .long   0
side_select:    .long   0
count:          .long   0
bufptr:         .long   0
transfer:       .byte   0
xfer_complete:  .byte   0
delayed_intrq:  .byte   0
INTRQ:          .byte   0
formatting:     .byte   0
command:        .byte   0
revolutions:    .byte   0
last_step_in:	.byte	0

id_search:      .byte   0
compute_crc:	.byte	0
crc:            .word   0xFFFF
stuck_command:	.byte	0

format:         .asciz  "com:%x\n"
format1:        .asciz  "track : %x, sect: %x\n"
format2:        .asciz  "ROMDIS: %x\n"
format3:        .asciz  "bufptr: %x\n"
format4:        .asciz  "314= %x, Int=%x\n"

	.text

trace:
	pushal
/*
	cmpb    $4,TRACK_REG
	jne     0f
	cmpb    $10,SECT_REG
	jne     0f
*/
	movb    $1,Debug
0:
	andl    $0xFF,%eax
	movb    SECT_REG,%al
	pushl   %eax
	movb    TRACK_REG,%al
	pushl   %eax
	pushl   $format1
	call    MANGLE_SYM(printf)
	addl    $12,%esp
	popal
	ret

trace1:
	pushal
	pushl   %ebx
	pushl   $format3
	call    MANGLE_SYM(printf)
	addl    $8,%esp
	pushl   $0
	call    MANGLE_SYM(fflush)
	addl    $4,%esp
	popal
	ret

trace2:
	pushal
	movb    STATUS,%al
	andl    $0xFF,%eax
	pushl   %eax
	pushl   $format3
	call    MANGLE_SYM(printf)
	addl    $8,%esp
	popal
	ret

Reset_1793:
	cmpb    $1,disk
	jne     1f
	pushl   %ecx
	movl    FDC_adr,%ecx
	movb    $0,STATUS
	movb    $0,TRACK_REG
	movb    $0,SECT_REG
	movb    $0,DATA_REG
	popl    %ecx
	movb	$0,disk_select
	movb	$0,side_select
	call	read_buf
	cmpb    $1,jasmin
	je      2f
	movb    $0xFF,MICRODISC_READY
	movb    $0,INTRQ
	movb    $0,%al
	call    Write_Microdisc_Select
1:      ret
2:      movb    $0,JASMIN_ORMA
	movb    $1,%al
	movl    $0x3FB,%edx
	call    Write_Jasmin_ROMDIS
	ret

Restart_1793:
	cmpb    $1,disk
	jne     1f
	pushal
	movl	$_State+44,%esi
	movl	$FDC_adr,%edi
	movl	$27,%ecx
	rep
	movsb
	popal
	call	read_buf
	cmpb    $1,jasmin
	je      1f
	movb    MICRODISC_SELECT,%al
	call    Write_Microdisc_Select
1:      ret

Dump_1793:
	pushal
	movl	$_State+44,%edi
	movl	$FDC_adr,%esi
	movl	$27,%ecx
	rep
	movsb
	popal
	ret

#define RESET_DRQ\
	cmpb    $1,jasmin ;\
	je      0f ;\
	movb    $0xFF,MICRODISC_READY ;\
	jmp     1f ;\
0:      andb    $~2,MANGLE_SYM(Sys_Request) ;\
1:

#define SET_DRQ\
	cmpb    $1,jasmin ;\
	je      0f ;\
	movb    $0x7F,MICRODISC_READY ;\
	jmp     1f ;\
0:      movb    $1,delayed_intrq ;\
	pushl   %eax ;\
	movl    $28,%eax ;\
	call    init_special_timeout ;\
	popl    %eax ;\
1:

#define SET_INTRQ(val)\
	cmpb    $1,jasmin ;\
	je      0f ;\
	movb    val,%al ;\
	movb    %al,INTRQ ;\
	andb    MICRODISC_SELECT,%al ;\
	shlb    $1,%al ;\
	andb    $~2,MANGLE_SYM(Sys_Request) ;\
	orb     %al,MANGLE_SYM(Sys_Request) ;\
0:

#define SET_DELAYED_INTRQ\
	cmpb    $1,jasmin ;\
	je      1f ;\
	movb    $1,INTRQ ;\
	testb   $1,MICRODISC_SELECT ;\
	jz      0f ;\
	movb    $0,INTRQ ;\
1:      movb    $1,delayed_intrq ;\
	pushl   %eax ;\
	movl    $28,%eax ;\
	call    init_special_timeout ;\
	popl    %eax ;\
0:

Write_FDC_Sector:
Write_FDC_Seek:
Write_dummy:
	movb    %al,Oric_Mem(%edx)
	ret

Read_FDC_Status:
	pushl   %ecx
	movl    FDC_adr,%ecx
	SET_INTRQ($0)
	movb    STATUS,%al
	cmpb    $0x81,%al       /* lecture/ecriture secteurs multiples */
	je      1f
	popl    %ecx
	ret

1:      cmpb    $1,transfer
	jne     2f
	movb    $0,transfer     /* attend la prochaine lecture de STATUS */
	popl    %ecx
	ret
2:      movb    command,%al
	incb    SECT_REG        /* relance la commande sur le secteur suivant */
	call    Write_FDC_Command
	movb    STATUS,%al
	popl    %ecx
	ret

Read_FDC_Seek:
Read_FDC_Sector:
	movb    Oric_Mem(%eax),%al
	ret

Read_dummy:
	movb    $0xFF,%al
	ret

Write_FDC_Command:
	movb    %al,command
	andb    $0xF0,%al
	cmpb    $0,%al
	je      Command_Restore_Track0
	cmpb    $0x10,%al
	je      Command_Seek_Track
	cmpb    $0xE0,%al
	je      Command_Read_Track
	cmpb    $0xF0,%al
	je      Command_Write_Track
	cmpb    $0xC0,%al
	je      Command_Read_Address
	cmpb    $0xD0,%al
	je      Command_Force_Interrupt
	andb    $0xE0,%al
        cmpb    $0x20,%al
	je      Command_Step_Track
	cmpb    $0x40,%al
	je      Command_StepIn_Track
	cmpb    $0x60,%al
	je      Command_StepOut_Track
	cmpb    $0x80,%al
	je      Command_Read_Sector
	cmpb    $0xA0,%al
	je      Command_Write_Sector

	pushl   %ecx
	movl    FDC_adr,%ecx
	movb    $0,INTRQ
	SET_INTRQ($0)
	RESET_DRQ
	movb    $0,STATUS
	popl    %ecx
	ret

/***************************************************************************/
/*                                                                         */
/*        les differentes commandes                                        */
/*                                                                         */
/***************************************************************************/

Command_Force_Interrupt:
	pushl   %ecx
	movl    FDC_adr,%ecx
	movb    $0,INTRQ
	movb    $0,STATUS
	movb	$0,stuck_command
	SET_INTRQ($1)
	popl    %ecx
	ret

Command_Restore_Track0:
	pushl   %ecx
	movl    FDC_adr,%ecx
	movb    $0,INTRQ
	movb    $0,TRACK_REG
	jmp     Seek_Track

Command_Step_Track:
	cmpb	$0,last_step_in
	jz	Command_StepOut_Track

Command_StepIn_Track:
	pushl   %ecx
	movl    FDC_adr,%ecx
	movb    $0,INTRQ
	movb	$1,last_step_in
	incb    TRACK_REG
	jmp     Seek_Track

Command_StepOut_Track:
	pushl   %ecx
	movl    FDC_adr,%ecx
	movb    $0,INTRQ
	movb	$0,last_step_in
	decb    TRACK_REG
	jmp     Seek_Track

Command_Seek_Track:
	pushl   %ecx
	movl    FDC_adr,%ecx
	movb    $0,INTRQ
	movb    DATA_REG,%al
	movb    %al,TRACK_REG

Seek_Track:
	pushl	%ebx
	movb    $0,STATUS
	andb	$8,command
	jz	3f
	orb	$0x24,STATUS
	movl	disk_select,%ebx
	cmpb	$0,drives(%ebx)
	jz	5f
	cmpl	$0,fd(,%ebx,4)
	jz	2f
	cmpb	$0,write_only(%ebx)
	jz	4f
	orb	$0x40,STATUS
4:	cmpb    $0,TRACK_REG
	jnz     3f
	orb     $4,STATUS
3:      SET_INTRQ($1)
	call    read_buf
	popl	%ebx
	popl    %ecx
	ret
2:      SET_INTRQ($1)
	orb	$0x40,STATUS
	popl	%ebx
	popl    %ecx
	ret
5:	cmpb	$1,telestrat
	je	6f
	SET_INTRQ($1)
	movb	$0x20,STATUS
	popl	%ebx
	popl    %ecx
	ret
6:	movb	$1,STATUS
	movb	$1,stuck_command
	popl	%ebx
	popl    %ecx
	ret


Command_Write_Track:
	pushl   %ecx
	movl    FDC_adr,%ecx
	movb    $0,INTRQ
	movl    $0,bufptr
	movb    $1,formatting
	movb    $3,STATUS
	SET_DRQ
	movl    $6400,count
	popl    %ecx
	ret

Command_Read_Track:
	pushl   %ecx
	movl    FDC_adr,%ecx
	movb    $0,INTRQ
	movl    $0,bufptr
	movl    $6400,count
	movb    $1,transfer
	movb    $0x83,STATUS    /* drive in use, DRQ, FDC busy */
	SET_INTRQ($0)
	SET_DRQ
	popl    %ecx
	ret

Command_Read_Sector:
Command_Write_Sector:
Command_Read_Address:
	pushl   %ecx
	movl    FDC_adr,%ecx
	movb    $0,INTRQ
	pushl	%ebx
	movl	disk_select,%ebx
	cmpl	$0,fd(,%ebx,4)
	jz	3f
	movb    $1,transfer
	movb    $1,id_search
	movb    $0x83,STATUS    /* drive in use, DRQ, FDC busy */
	SET_DRQ
	SET_INTRQ($0)
				/* attend avant de chercher le prochain id */
				/* parce que sedoric selectionne le lecteur */
				/* apres la commande */
	movw	$0xE295,crc	/* crc en cours apres A1 A1 A1 FB */
	popl	%ebx
	popl    %ecx
	ret
3:	movb	$1,stuck_command
	movb	$1,STATUS
	popl	%ebx
	popl    %ecx
	ret

/********************************************************************/
/*                                                                  */
/*        l'ecriture disque                                         */
/*                                                                  */
/********************************************************************/

Write_FDC_Data:
	pushl   %ecx
	movl    FDC_adr,%ecx
	movb    %al,DATA_REG
	RESET_DRQ
	cmpb    $1,transfer
	je      1f
	cmpb    $1,formatting
	je      send_data_for_format
	popl    %ecx
	ret

1:      cmpb    $1,id_search
	jne     write_byte
	movb    $0,id_search
	movl    disk_select,%eax
	cmpb    $1,write_only(%eax)
	je      write_protected
	call    search_sector
	jc      sector_not_found
	call    find_data

write_byte:
	movb    DATA_REG,%al
	call	send_byte_to_disk
	decl    count
	jz      end_write
	SET_DRQ
	popl    %ecx
	ret

end_write:
	movw	crc,%ax
	pushl	%eax
	movb	%ah,%al
	call	send_byte_to_disk
	popl	%eax
	call	send_byte_to_disk
	movb	$0,compute_crc
	pushal
	call    MANGLE_SYM(disk_flushbuf)
	popal
	testb   $0x10,command
	jnz     multiple_write
	movb    $0,transfer
	movb    $0,STATUS
	RESET_DRQ
	SET_DELAYED_INTRQ
	popl    %ecx
	ret
multiple_write:
	RESET_DRQ                       /* pause entre les secteurs */
					/* attend que le STATUS soit lu */
	movb    $0x81,STATUS
	popl    %ecx
	ret

write_protected:
	movb    $0x40,STATUS
	jmp     transfer_error

track_not_found:
sector_not_found:
	movb    $0x10,STATUS

transfer_error:
	movb    $0,transfer
	SET_INTRQ($1)
	RESET_DRQ
	popl    %ecx
	ret

send_data_for_format:
	cmpb    $0xF5,%al
	je	transform_byte_F5
        cmpb    $0xF6,%al
	je	transform_byte_F6
        cmpb    $0xF7,%al
	je	generate_crc
byte_transformed:
	call	send_byte_to_disk
	decl    count
	jz      normal_end_format
	SET_DRQ
	popl    %ecx
	ret
normal_end_format:
	pushal
	movb    TRACK_REG,%al
	andl    $0xFF,%eax
	pushl   %eax
	pushl   side_select
	pushl   disk_select
	call    MANGLE_SYM(disk_format)
	addl    $12,%esp
	movl    FDC_adr,%ecx
	movb    $0,STATUS
	cmpl    $0,%eax
	jz      0f
	movb    $0x40,STATUS
0:      popal
	movb    $0,formatting
	movl    $0,bufptr
	SET_INTRQ($1)
	RESET_DRQ
	popl    %ecx
	ret

transform_byte_F5:
	movb    $0xA1,%al
	cmpb	$0,compute_crc
	jnz	byte_transformed
	movb	$1,compute_crc
	movw    $0xFFFF,crc
	jmp	byte_transformed

transform_byte_F6:
	movb    $0xC2,%al
	jmp	byte_transformed

generate_crc:
	movw	crc,%ax
	pushl	%eax
	movb	%ah,%al
	call	send_byte_to_disk
	popl	%eax
	decl    count
	movb	$0,compute_crc
	jmp	byte_transformed

send_byte_to_disk:
	pushl   %ebx
	movl    bufptr,%ebx
        movb    %al,diskbuf(%ebx)
	incl    %ebx
	movl    %ebx,bufptr
        popl    %ebx

	xorb    crc+1,%al
	andl    $0xFF,%eax
	movw    crctab(,%eax,2),%ax
	xorb    crc,%ah
	movw    %ax,crc
	ret

_reinvoke_fdc_command:
reinvoke_fdc_command:
	pushal
	cmpb	$1,stuck_command
	jne	1f
	movl    FDC_adr,%ecx
	testb	$1,STATUS
	jz	1f
	movb	$0,stuck_command
	call	read_track
	movb	command,%al
	call	Write_FDC_Command
1:	popal
	ret

_read_track:
read_track:
read_buf:
	pushal
	movl    $0,%eax
	movl    FDC_adr,%ecx
	movb    TRACK_REG,%al
	pushl   %eax
	pushl   side_select
	pushl   disk_select
	call    MANGLE_SYM(disk_read_track)
	addl    $12,%esp
	popal
	ret

search_sector:
	movb    command,%al
	andb    $0xE0,%al
	cmpb    $0xC0,%al
	je      0f
	movb    TRACK_REG,%al
	movb    %al,id_contents
	movb    side_select,%al
	movb    %al,id_contents+1
	movb    SECT_REG,%al
	movb    %al,id_contents+2
	movl    $0x00FFFFFF,id_mask
	jmp     search_id
0:      movl    $0,id_mask
	movl    $0,id_contents
	movl    $6,count
search_id:
	pushal
	movb    $2,revolutions
	movl    bufptr,%ebx
	movl    $6400,%ecx
	subl    %ebx,%ecx
0:      cmpl    $0,diskbuf(%ebx)
	je      1f
	incl    %ebx
	loop    0b
	jmp     id_not_found
1:      cmpb    $0,diskbuf(%ebx)
	jne     2f
	incl    %ebx
	loop    1b
	jmp     id_not_found
2:      cmpl    $0xFEA1A1A1,diskbuf(%ebx)
	jne     0b
	subl    $4,%ecx
	addl    $4,%ebx
	movl    diskbuf(%ebx),%eax
	andl    id_mask,%eax
	cmpl    id_contents,%eax
	jne     0b
	movl    %ebx,bufptr
	popal
	clc
	ret
id_not_found:
	movl    $6400,%ecx
	movl    $0,%ebx
	decb    revolutions
	jnz     0b
	popal
	stc
	ret

find_data:
	pushal
	movl    bufptr,%ebx
	movb    diskbuf+3(%ebx),%cl
	movl    $128,count
	shll    %cl,count
	addl    $5,%ebx
0:      incl    %ebx
	cmpb    $0xFB,diskbuf(%ebx)
	jne     0b
	incl    %ebx
	movl    %ebx,bufptr
	popal
	ret

/********************************************************************/
/*                                                                  */
/*        la lecture disque                                         */
/*                                                                  */
/********************************************************************/

Read_FDC_Data:
	pushl   %ecx
	movl    FDC_adr,%ecx
	RESET_DRQ
	cmpb    $0,transfer
	jnz     1f
	movb    DATA_REG,%al
	popl    %ecx
	ret

1:      movb    command,%al
	andb    $0xE0,%al
	cmpb    $0xE0,%al
	je      read_track_command
	cmpb    $1,id_search
	jne     read_byte
	movb    $0,id_search
	call    search_sector
	jc      sector_not_found
	movb    command,%al
	andb    $0xE0,%al
	cmpb    $0xC0,%al
	jne     2f
	pushl   %ebx
	movl    bufptr,%ebx
	movb    diskbuf(%ebx),%al
	movb    %al,DATA_REG
	movb    %al,SECT_REG
	incl    %ebx
	movl    %ebx,bufptr
	popl    %ebx
	decl    count
	jz      3f
	SET_DRQ
3:      popl    %ecx
	ret

2:
	call    find_data

read_byte:
	pushl   %ebx
	movl    bufptr,%ebx
	movb    diskbuf(%ebx),%al
	movb    %al,DATA_REG
	incl    %ebx
	movl    %ebx,bufptr
	popl    %ebx
	decl    count
	jz      end_read
	SET_DRQ
	popl    %ecx
	ret

end_read:
	cmpb    $1,jasmin
	je      2f
normal_end_read:
	movb    $0,transfer
	movb    $0,STATUS
	RESET_DRQ
	SET_DELAYED_INTRQ
				/* ne positionne pas IRQ de suite parce que */
				/* la routine de lecture d'un secteur serait */
				/* interrompue avant l'ecriture du dernier */
				/* octet en memoire */
	movb    DATA_REG,%al
	popl    %ecx
	ret

2:      testb   $0x10,command
	jnz     multiple_read
	movb    $0,transfer
	movb    $0,STATUS
	SET_INTRQ($1)
	RESET_DRQ
	movb    DATA_REG,%al
	popl    %ecx
	ret
multiple_read:
	SET_INTRQ($1)
	RESET_DRQ                       /* pause entre les secteurs */
					/* attend que le STATUS soit lu */
	movb    DATA_REG,%al
	movb    $0x81,STATUS
	popl    %ecx
	ret

read_track_command:
	pushl   %ebx
	movl    bufptr,%ebx
	movb    diskbuf(%ebx),%al
	movb    %al,DATA_REG
	incl    %ebx
	movl    %ebx,bufptr
	popl    %ebx
	decl    count
	jz      2f
	SET_DRQ
	popl    %ecx
	ret
2:      movl    $0,bufptr
	jmp     normal_end_read

/********************************************************************/
/*       L'electronique Microdisc                                   */
/********************************************************************/

Write_Microdisc_Select:
	movb    MICRODISC_SELECT,%ah
	movb    %al,MICRODISC_SELECT
	xorb    %al,%ah
	andb    $0x70,%ah
	jz      no_disk_change
	andb    $0x60,%al
	shrb    $5,%al
	movb    %al,disk_select
	movb    MICRODISC_SELECT,%al
	andb    $0x10,%al
	shrb    $4,%al
	movb    %al,side_select
	call    read_buf
no_disk_change:
	SET_INTRQ(INTRQ)                /* reactiver IRQ si autorise' */
	cmpb    $1,telestrat
	je      1f
	testb   $2,MICRODISC_SELECT
	jnz     0f
	movl    $RAM,%edi
	movl    %edi,HighMemWrite
	movl	$0xC000,Bank_point
	testb   $0x80,MICRODISC_SELECT
	jnz     1f
	movl	$EPROM,%edi
	movl	$DUMMY,HighMemWrite
	movl	Eprom_start,%eax
	movl	%eax,Bank_point
1:      ret
0:      movl    $ROM,%edi
	movl    $DUMMY,HighMemWrite
	ret

Read_Microdisc_Select:
	movb    INTRQ,%al
	shlb    $7,%al
	xorb    $0x80,%al
	orb     $0x7F,%al
	ret

Write_Microdisc_Ready:
	ret

Read_Microdisc_Ready:
	movb    MICRODISC_READY,%al
	ret

set_intrq:
	pushl   %eax
	movb    $1,%al
	cmpb    $1,jasmin
	je      1f
	movb    $1,INTRQ
	movb    MICRODISC_SELECT,%al
	andb    $1,%al
1:      shlb    $1,%al
	andb    $~2,MANGLE_SYM(Sys_Request)
	orb     %al,MANGLE_SYM(Sys_Request)
	movb    $0,delayed_intrq
	popl    %eax
	ret

/********************************************************************/
/*       L'electronique Jasmin                                      */
/********************************************************************/

Write_Jasmin_Side_Select:
	movb    %al,Oric_Mem(%edx)
	andb    $1,%al
	movb    %al,side_select
	call    read_buf
	ret

Write_Jasmin_DCR:
	movb    %al,Oric_Mem(%edx)
	ret

Write_Jasmin_ORMA:
Write_Jasmin_ROMDIS:
	movb    %al,Oric_Mem(%edx)
	movl    $RAM,%edi
	movl    %edi,HighMemWrite
	movl	$0xC000,Bank_point
	andb    $1,JASMIN_ORMA
	jnz     1f
	testb   $1,JASMIN_ROMDIS
	jnz     2f
	movl    $ROM,%edi
	movl    $DUMMY,HighMemWrite
1:      ret
2:      movl    $EPROM,%edi
	movl    $DUMMY,HighMemWrite
	movl	Eprom_start,%eax
	movl	%eax,Bank_point
	ret

Write_Jasmin_disk1:
	movb    %al,Oric_Mem(%edx)
	movb    $0,disk_select
	call    read_buf
	ret

Write_Jasmin_disk2:
	movb    %al,Oric_Mem(%edx)
	movb    $1,disk_select
	call    read_buf
	ret

Write_Jasmin_disk3:
	movb    %al,Oric_Mem(%edx)
	movb    $2,disk_select
	call    read_buf
	ret

Write_Jasmin_disk4:
	movb    %al,Oric_Mem(%edx)
	movb    $3,disk_select
	call    read_buf
	ret


Read_Jasmin_Side_Select:
Read_Jasmin_DCR:
Read_Jasmin_ORMA:
Read_Jasmin_ROMDIS:
Read_Jasmin_disk1:
Read_Jasmin_disk2:
Read_Jasmin_disk3:
Read_Jasmin_disk4:
	movb    Oric_Mem(%eax),%al
	ret


