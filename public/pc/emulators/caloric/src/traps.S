/*
 *	traps.S - guest traps
 *	FF sometime in 1994-1997
 */

/*
Parts of this file copyright 1994-1997 Fabrice Francès.
Parts of this file copyright 2000-2004 André Majorel.

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
	.global Trap
	.global _Patch_ROM
	.global Patch_ROM
	.global _Unpatch_ROM
	.global Unpatch_ROM
	.global Read_Synchro
	.global Read_Byte
	.global Write_Synchro
	.global Write_Byte
	.global MANGLE_SYM(Write_Handle)

#define Mem     Oric_Mem+16384

	.data
File_Name_Addr: .short  0
Name_Found_Addr: .short 0
Header_Addr:    .short  0
File_Handle:    .long   0
MANGLE_SYM(Write_Handle):   .long   0
result:         .long   0
message:        .asciz  "trap=%d\n"

	.text

_Patch_ROM:
Patch_ROM:
	pushal
	cmpw    $0xF88F,Mem+0xFFFC
	je      atmos
	cmpw    $0xF42D,Mem+0xFFFC
	je      oric1
other:
	popal
	ret
atmos:
	movw    $0x027F,File_Name_Addr
	movw    $0x0293,Name_Found_Addr
	movw    $0x02A7,Header_Addr

	movb    $2,Mem+0xE735               	/* Read_Synchro puis : */
	movl    $0xE74D4C,Mem+0xE736		/* JMP E74D */

	movb    $2,Mem+0xE6C9         		/* Read_Byte puis : */
	movw    $0x0009,Mem+0xE6CA		/* ORA #0 */
	movb    $0x18,Mem+0xE6CC		/* CLC    */
	movb    $0x60,Mem+0xE6CD		/* RTS    */

	movb    $2,Mem+0xE75E    		/* Write_Synchro puis : */
	movb    $0x60,Mem+0xE75F                /* RTS    */

	movb    $2,Mem+0xE65E        		/* Write_Byte puis : */
	movb    $0x60,Mem+0xE65F		/* RTS    */
	popal
	ret

oric1:  movw    $0x0035,File_Name_Addr
	movw    $0x0049,Name_Found_Addr
	movw    $0x005D,Header_Addr

	movb    $2,Mem+0xE696			/* Read_Synchro */
	movl    $0xE6AD4C,Mem+0xE697

	movb    $2,Mem+0xE630			/* Read_Byte */
	movw    $0x0009,Mem+0xE631
	movb    $0x18,Mem+0xE633
	movb    $0x60,Mem+0xE634

	movb    $2,Mem+0xE6BE               	/* Write_Synchro */
	movb    $0x60,Mem+0xE6BF

	movb    $2,Mem+0xE5C6			/* Write_Byte */
	movb    $0x60,Mem+0xE5C7
	popal
	ret

_Unpatch_ROM:
Unpatch_ROM:
	pushal
	cmpw    $0xF88F,Mem+0xFFFC
	je      1f
	cmpw    $0xF42D,Mem+0xFFFC
	je      0f
	popal
	ret
1:
	movl    $0xE6FC20,Mem+0xE735     	/* JSR E6FC */
	movw    $0x2F66,Mem+0xE738		/* ROR 2F   */

	movb    $0x98,Mem+0xE6C9		/* TYA      */
	movb    $0x48,Mem+0xE6CA		/* PHA      */
	movb    $0x8A,Mem+0xE6CB		/* TXA      */
	movb    $0x48,Mem+0xE6CC		/* PHA      */
	movb    $0x20,Mem+0xE6CD		/* JSR ...  */

	movw    $0x16A9,Mem+0xE75E		/* LDA #16  */

	movw    $0x2F85,Mem+0xE65E		/* STA 2F   */
	popal
	ret

0:      movl    $0xE65E20,Mem+0xE696		/* JSR E65E */
	movw    $0x2F66,Mem+0xE699		/* ROR 2F   */

	movb    $0x98,Mem+0xE630		/* TYA      */
	movb    $0x48,Mem+0xE631		/* PHA      */
	movb    $0x8A,Mem+0xE632		/* TXA      */
	movb    $0x48,Mem+0xE633		/* PHA      */
	movb    $0x20,Mem+0xE634		/* JSR ...  */

	movw    $0x16A9,Mem+0xE6BE              /* LDA #16  */

	movw    $0x2F85,Mem+0xE5C6		/* STA 2F   */
	popal
	ret


Trap:
	movl	%esi,%eax
	decl	%eax
	subl	$Oric_Mem,%eax
	andl	$0x3FFF,%eax
	addl	$0xC000,%eax
	cmpw	$0xE735,%ax
	je	Read_Synchro
	cmpw	$0xE696,%ax
	je	Read_Synchro
	cmpw	$0xE6C9,%ax
	je	Read_Byte
	cmpw	$0xE630,%ax
	je	Read_Byte
	cmpw	$0xE75E,%ax
	je	Write_Synchro
	cmpw	$0xE6BE,%ax
	je	Write_Synchro
	cmpw	$0xE65E,%ax
	je	Write_Byte
	cmpw	$0xE5C6,%ax
	je      Write_Byte
	ret


Read_Byte:
	pushal
	cmpl    $0,File_Handle
	je      dontread
	pushl   File_Handle
	call    MANGLE_SYM(fgetc)
	addl    $4,%esp
	movl    %eax,result
dontread:
	popal
	movb    result,%bl
	xorb	%al,%al
	ret


Read_Synchro:
	pushal
	cmpl    $0,MANGLE_SYM(Write_Handle)
	je      1f
	pushl   MANGLE_SYM(Write_Handle)
	call    MANGLE_SYM(fclose)
	addl    $4,%esp
	movl    $0,MANGLE_SYM(Write_Handle)
1:      cmpl    $0,File_Handle
	jz      open_file
	pushl	File_Handle
	call	MANGLE_SYM(feof)
	addl	$4,%esp
	cmpl	$0,%eax
	jz	sync_ok
open_file:
	movzwl  File_Name_Addr,%edx
	addl    $Oric_Mem,%edx
	pushl   %edx
	call    MANGLE_SYM(tap_open_read)
	addl    $4,%esp
	movl    %eax,File_Handle
	cmpl    $0,%eax
	jz      File_Not_Found
	movzwl  File_Name_Addr,%edx
	movb    $0,Oric_Mem(%edx)
File_Not_Found:
sync_ok:
	popal
	xorb	%al,%al
	ret

Write_Synchro:
	pushal
	movzwl  File_Name_Addr,%edx	// edx = Oric_Mem + File_Name_Addr;
	addl    $Oric_Mem,%edx
	pushl	%edx
	call	MANGLE_SYM(tap_open_write)
	addl	$4,%esp
	popal
	xorb	%al,%al
	ret

Write_Byte:
	pushal
	cmpl    $0,MANGLE_SYM(Write_Handle)		// if (Write_Handle != NULL)
	je      dontwrite		//   fputc (ebx & 0xff, Write_Handle);
	pushl   MANGLE_SYM(Write_Handle)		// return 0;
	andl    $0xFF,%ebx
	pushl   %ebx
	call    MANGLE_SYM(fputc)
	addl    $8,%esp

	/* Fix for Ian's CSAVE bug : flush after every byte. It's ugly,
	   but a proper fix is hard. FIXME should detect and report
	   errors. */
	pushl	MANGLE_SYM(Write_Handle)
	call	MANGLE_SYM(fflush)
	addl	$4,%esp
dontwrite:
	popal
	xorb	%al,%al
	ret

trace:
	pushal
	pushl   %eax
	pushl   $message
	call    MANGLE_SYM(printf)
	addl    $8,%esp
	popal
	ret
