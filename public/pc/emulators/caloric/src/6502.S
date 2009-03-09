/*
 *	6502.S - 6502 emulation
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
#include "6502.h"
	.global _Reset
	.global Reset
	.global _Restart
	.global Restart
	.global _State
	.global State
    .global Registers
    .global _Registers
    .global saveRegisters
    .global _saveRegisters
    .global MANGLE_SYM(debugStep)
    /*.global _debugStep*/

	.global MANGLE_SYM(Sys_Request)
	.global MANGLE_SYM(Flags)
	.global MANGLE_SYM(Carry)
	.global MANGLE_SYM(Overflow)
	.global MANGLE_SYM(S)
	.global _restart_flag
	.global	restart_flag
	.global MANGLE_SYM(quit_on_trap)
    .global asm_start
    .global showState
	.data

MANGLE_SYM(Sys_Request):    .word   0
MANGLE_SYM(S):              .byte   0x30
MANGLE_SYM(Flags):          .byte   0
MANGLE_SYM(Carry):          .byte   0
MANGLE_SYM(Overflow):       .byte   0

_restart_flag:
restart_flag:	.byte	0

	.align 4

OpCodeTable:
	.long OpCode00, OpCode01, OpCode02, OpCode03, OpCode04, OpCode05, OpCode06, OpCode07, OpCode08, OpCode09, OpCode0A, OpCode0B, OpCode0C, OpCode0D, OpCode0E, OpCode0F
	.long OpCode10, OpCode11, OpCode12, OpCode13, OpCode14, OpCode15, OpCode16, OpCode17, OpCode18, OpCode19, OpCode1A, OpCode1B, OpCode1C, OpCode1D, OpCode1E, OpCode1F
	.long OpCode20, OpCode21, OpCode22, OpCode23, OpCode24, OpCode25, OpCode26, OpCode27, OpCode28, OpCode29, OpCode2A, OpCode2B, OpCode2C, OpCode2D, OpCode2E, OpCode2F
	.long OpCode30, OpCode31, OpCode32, OpCode33, OpCode34, OpCode35, OpCode36, OpCode37, OpCode38, OpCode39, OpCode3A, OpCode3B, OpCode3C, OpCode3D, OpCode3E, OpCode3F
	.long OpCode40, OpCode41, OpCode42, OpCode43, OpCode44, OpCode45, OpCode46, OpCode47, OpCode48, OpCode49, OpCode4A, OpCode4B, OpCode4C, OpCode4D, OpCode4E, OpCode4F
	.long OpCode50, OpCode51, OpCode52, OpCode53, OpCode54, OpCode55, OpCode56, OpCode57, OpCode58, OpCode59, OpCode5A, OpCode5B, OpCode5C, OpCode5D, OpCode5E, OpCode5F
	.long OpCode60, OpCode61, OpCode62, OpCode63, OpCode64, OpCode65, OpCode66, OpCode67, OpCode68, OpCode69, OpCode6A, OpCode6B, OpCode6C, OpCode6D, OpCode6E, OpCode6F
	.long OpCode70, OpCode71, OpCode72, OpCode73, OpCode74, OpCode75, OpCode76, OpCode77, OpCode78, OpCode79, OpCode7A, OpCode7B, OpCode7C, OpCode7D, OpCode7E, OpCode7F
	.long OpCode80, OpCode81, OpCode82, OpCode83, OpCode84, OpCode85, OpCode86, OpCode87, OpCode88, OpCode89, OpCode8A, OpCode8B, OpCode8C, OpCode8D, OpCode8E, OpCode8F
	.long OpCode90, OpCode91, OpCode92, OpCode93, OpCode94, OpCode95, OpCode96, OpCode97, OpCode98, OpCode99, OpCode9A, OpCode9B, OpCode9C, OpCode9D, OpCode9E, OpCode9F
	.long OpCodeA0, OpCodeA1, OpCodeA2, OpCodeA3, OpCodeA4, OpCodeA5, OpCodeA6, OpCodeA7, OpCodeA8, OpCodeA9, OpCodeAA, OpCodeAB, OpCodeAC, OpCodeAD, OpCodeAE, OpCodeAF
	.long OpCodeB0, OpCodeB1, OpCodeB2, OpCodeB3, OpCodeB4, OpCodeB5, OpCodeB6, OpCodeB7, OpCodeB8, OpCodeB9, OpCodeBA, OpCodeBB, OpCodeBC, OpCodeBD, OpCodeBE, OpCodeBF
	.long OpCodeC0, OpCodeC1, OpCodeC2, OpCodeC3, OpCodeC4, OpCodeC5, OpCodeC6, OpCodeC7, OpCodeC8, OpCodeC9, OpCodeCA, OpCodeCB, OpCodeCC, OpCodeCD, OpCodeCE, OpCodeCF
	.long OpCodeD0, OpCodeD1, OpCodeD2, OpCodeD3, OpCodeD4, OpCodeD5, OpCodeD6, OpCodeD7, OpCodeD8, OpCodeD9, OpCodeDA, OpCodeDB, OpCodeDC, OpCodeDD, OpCodeDE, OpCodeDF
	.long OpCodeE0, OpCodeE1, OpCodeE2, OpCodeE3, OpCodeE4, OpCodeE5, OpCodeE6, OpCodeE7, OpCodeE8, OpCodeE9, OpCodeEA, OpCodeEB, OpCodeEC, OpCodeED, OpCodeEE, OpCodeEF
	.long OpCodeF0, OpCodeF1, OpCodeF2, OpCodeF3, OpCodeF4, OpCodeF5, OpCodeF6, OpCodeF7, OpCodeF8, OpCodeF9, OpCodeFA, OpCodeFB, OpCodeFC, OpCodeFD, OpCodeFE, OpCodeFF

_State:
State:        .fill   80
_Registers:
Registers:    .fill   16

	.text
6:
7:
8:
9:  hlt

	clk=0
.align  4
_saveRegisters:
saveRegisters:
	movb    A,Registers
	movb    X,Registers+1
	movb    Y,Registers+2
    movl    PC,Registers+4
    ret
.align  4
_Restart:
Restart:
	cmpb    $1,disk
	je      0f
	call    InitMemory
0:      call    Restart_VIA1
	cmpb    $1,telestrat
	jne     0f
	call    Restart_VIA2
	call    Reset_Time
0:      call    Reset_8912
	call    Restart_1793
	call    Reset_6551
	call	Reset_Time
	call	Restore_Clock
	movl    $0,%eax
	movl    %eax,%ebx
	movl    %eax,%ecx
	movl    %eax,%edx
	movb    $0,MANGLE_SYM(Flags)
	movb    $0,MANGLE_SYM(Carry)
	movb    $0,MANGLE_SYM(Overflow)
	movb    State,A
	movb    State+1,X
	movb    State+2,Y
	movb    State+3,%al
	movb    %al,MANGLE_SYM(S)
	movl    State+4,%ebp
	movw    State+8,%ax
	movw    %ax,MANGLE_SYM(Sys_Request)
	POPPC
	POPFLAG
	FETCH

_Reset:
Reset:
	call    Blank_ram
	call    InitMemory
	cmpb    $1,telestrat
	je      1f
	cmpb    $1,jasmin
	je      1f
	cmpb    $1,disk
	je      0f
1:
	call    MANGLE_SYM(Reset_Screen)
	call    MANGLE_SYM(display_frame)
0:
	cmpb	$1,jasmin
	je	2f
Reset_telestrat:
	call    Reset_1793
2:
    call    Reset_VIA1
	call    Reset_8912
	call    Reset_6551
	call    Reset_Time
	movl    $0,%eax
	movl    %eax,%ebx
	movl    %eax,%ecx
	movl    %eax,%edx
	movl    $20000,%ebp
	movb    $0x0FF,MANGLE_SYM(S)                /* la pile en haut */
	movb    $0,MANGLE_SYM(Flags)
	movb    $0,MANGLE_SYM(Carry)
	movb    $0,MANGLE_SYM(Overflow)
	movw    Oric_Mem+0xFFFC(%edi),%ax
	leal    Oric_Mem(%eax,%edi),%esi
	FETCH

Handle_IRQ:
	xorl    %eax,%eax
	PUSHPC
	PUSHFLAG_IRQ
	orb     $4,MANGLE_SYM(Flags)                /* Positionne Interrupt */
	movw    Oric_Mem+0xFFFE(%edi),%ax
	leal    Oric_Mem(%eax,%edi),%esi
	cmpw    $0xC000,%ax
	jae     0f
	leal    Oric_Mem(%eax),%esi
0:      clk=7
	FETCH

Handle_Sys_Req:
	testw   $0x0400,MANGLE_SYM(Sys_Request)
	jz      test_power_reset
	addl    $4,%esp
	movw    $0,MANGLE_SYM(Sys_Request)
	cmpb    $1,telestrat
	je      Reset_telestrat
	movw    Oric_Mem+0xFFFA(%edi),%ax
	leal    Oric_Mem(%eax,%edi),%esi
	cmpw    $0xC000,%ax
	jae     0f
	leal    Oric_Mem(%eax),%esi
0:      FETCH
test_power_reset:
	testw   $0x0800,MANGLE_SYM(Sys_Request)
	jz      test_jasmin_boot
	addl    $4,%esp
	movw    $0,MANGLE_SYM(Sys_Request)
	jmp     Reset
test_jasmin_boot:
	testw   $0x0200,MANGLE_SYM(Sys_Request)
	jz      test_dump_req
	andw	$~0x0200,MANGLE_SYM(Sys_Request)
	cmpb	$1,jasmin
	jne	retour
	addl    $4,%esp
	call    Reset_1793
	movw    Oric_Mem+0xFFFC(%edi),%ax
	leal    Oric_Mem(%eax,%edi),%esi
	FETCH
test_dump_req:
	testw   $0x1000,MANGLE_SYM(Sys_Request)
	jz      test_help_req
dump_req:
	andw    $~0x1000,MANGLE_SYM(Sys_Request)
	movl    $0,%eax
	PUSHFLAG
	PUSHPC
	movb    A,State
	movb    X,State+1
	movb    Y,State+2
	movb    MANGLE_SYM(S),%al
	movb    %al,State+3
	movl    %ebp,State+4
	movw    MANGLE_SYM(Sys_Request),%ax
	movw    %ax,State+8
	call    Dump_VIA1
	cmpb    $1,telestrat
	jne     0f
	call    Dump_VIA2
0:      call    Dump_1793
	call	Dump_Clock
	pushl   $Oric_Mem
	call    MANGLE_SYM(Dump)
	addl    $4,%esp
	jmp     MANGLE_SYM(Quit)
test_help_req:
	testw   $0x8000,MANGLE_SYM(Sys_Request)
	jz      test_quit_req
	pushal
	call    MANGLE_SYM(config_screen)
	popal
	andw    $~0x8000,MANGLE_SYM(Sys_Request)
	ret
test_quit_req:
	testw   $0x2000,MANGLE_SYM(Sys_Request)
	jz      test_hardcopy
	jmp     MANGLE_SYM(Quit)
test_hardcopy:
	testw   $0x4000,MANGLE_SYM(Sys_Request)
	jz      retour
hardcopy:
	andw    $~0x4000,MANGLE_SYM(Sys_Request)
retour: ret

Crash:  call	Trap
	jz	0f			/* trap executee ? */
	movl	MANGLE_SYM(quit_on_trap),%eax
	cmpl	$0,%eax
	jz	42f
	jmp	MANGLE_SYM(Quit)
42:	orb     $4,MANGLE_SYM(Flags)	/* non, masque IT et fait tourner en rond */
	clk=3
	decl    PC
0:
	FETCH

OpCode00:       OP_BRK
OpCode01:       OP_ORA(READ_INDX)
OpCode02:       HANGUP
OpCode03:       OP_ASLORA(INDX)
OpCode04:       OP_NOP2
OpCode05:       OP_ORA(READ_ZPAGE)
OpCode06:       OP_ASL(ZPAGE)
OpCode07:       OP_ASLORA(ZPAGE)
OpCode08:       OP_PHP
OpCode09:       OP_ORA(READ_IMM)
OpCode0A:       OP_ASL_A
OpCode0B:       OP_AND(READ_IMM)
OpCode0C:       OP_NOP3
OpCode0D:       OP_ORA(READ_ABS)
OpCode0E:       OP_ASL(ABS)
OpCode0F:       OP_ASLORA(ABS)

OpCode10:       OP_BPL
OpCode11:       OP_ORA(READ_INDY)
OpCode12:       HANGUP
OpCode13:       OP_ASLORA(INDY)
OpCode14:       OP_NOP2
OpCode15:       OP_ORA(READ_ZPAGEX)
OpCode16:       OP_ASL(ZPAGEX)
OpCode17:       OP_ASLORA(ZPAGEX)
OpCode18:       OP_CLC
OpCode19:       OP_ORA(READ_ABSY)
OpCode1A:       OP_NOP1
OpCode1B:       OP_ASLORA(ABSY)
OpCode1C:       OP_NOP3
OpCode1D:       OP_ORA(READ_ABSX)
OpCode1E:       OP_ASL(ABSX)
OpCode1F:       OP_ASLORA(ABSX)

OpCode20:       OP_JSR
OpCode21:       OP_AND(READ_INDX)
OpCode22:       HANGUP
OpCode23:       OP_ROLAND(INDX)
OpCode24:       OP_BIT(READ_ZPAGE)
OpCode25:       OP_AND(READ_ZPAGE)
OpCode26:       OP_ROL(ZPAGE)
OpCode27:       OP_ROLAND(ZPAGE)
OpCode28:       OP_PLP
OpCode29:       OP_AND(READ_IMM)
OpCode2A:       OP_ROL_A
OpCode2B:       OP_AND(READ_IMM)
OpCode2C:       OP_BIT(READ_ABS)
OpCode2D:       OP_AND(READ_ABS)
OpCode2E:       OP_ROL(ABS)
OpCode2F:       OP_ROLAND(ABS)

OpCode30:       OP_BMI
OpCode31:       OP_AND(READ_INDY)
OpCode32:       HANGUP
OpCode33:       OP_ROLAND(INDY)
OpCode34:       OP_NOP2
OpCode35:       OP_AND(READ_ZPAGEX)
OpCode36:       OP_ROL(ZPAGEX)
OpCode37:       OP_ROLAND(ZPAGEX)
OpCode38:       OP_SEC
OpCode39:       OP_AND(READ_ABSY)
OpCode3A:       OP_NOP1
OpCode3B:       OP_ROLAND(ABSY)
OpCode3C:       OP_NOP3
OpCode3D:       OP_AND(READ_ABSX)
OpCode3E:       OP_ROL(ABSX)
OpCode3F:       OP_ROLAND(ABSX)

OpCode40:       OP_RTI
OpCode41:       OP_EOR(READ_INDX)
OpCode42:       HANGUP
OpCode43:       OP_LSREOR(INDX)
OpCode44:       OP_NOP2
OpCode45:       OP_EOR(READ_ZPAGE)
OpCode46:       OP_LSR(ZPAGE)
OpCode47:       OP_LSREOR(ZPAGE)
OpCode48:       OP_PHA
OpCode49:       OP_EOR(READ_IMM)
OpCode4A:       OP_LSR_A
OpCode4B:       OP_LSA(READ_IMM)
OpCode4C:       OP_JMP
OpCode4D:       OP_EOR(READ_ABS)
OpCode4E:       OP_LSR(ABS)
OpCode4F:       OP_LSREOR(ABS)

OpCode50:       OP_BVC
OpCode51:       OP_EOR(READ_INDY)
OpCode52:       HANGUP
OpCode53:       OP_LSREOR(INDY)
OpCode54:       OP_NOP2
OpCode55:       OP_EOR(READ_ZPAGEX)
OpCode56:       OP_LSR(ZPAGEX)
OpCode57:       OP_LSREOR(ZPAGEX)
OpCode58:       OP_CLI
OpCode59:       OP_EOR(READ_ABSY)
OpCode5A:       OP_NOP1
OpCode5B:       OP_LSREOR(ABSY)
OpCode5C:       OP_NOP3
OpCode5D:       OP_EOR(READ_ABSX)
OpCode5E:       OP_LSR(ABSX)
OpCode5F:       OP_LSREOR(ABSX)

OpCode60:       OP_RTS
OpCode61:       OP_ADC(READ_INDX)
OpCode62:       HANGUP
OpCode63:       OP_RORADC(INDX)
OpCode64:       OP_NOP2
OpCode65:       OP_ADC(READ_ZPAGE)
OpCode66:       OP_ROR(ZPAGE)
OpCode67:       OP_RORADC(ZPAGE)
OpCode68:       OP_PLA
OpCode69:       OP_ADC(READ_IMM)
OpCode6A:       OP_ROR_A
OpCode6B:       OP_ROA(READ_IMM)
OpCode6C:       OP_JMP_IND
OpCode6D:       OP_ADC(READ_ABS)
OpCode6E:       OP_ROR(ABS)
OpCode6F:       OP_RORADC(ABS)

OpCode70:       OP_BVS
OpCode71:       OP_ADC(READ_INDY)
OpCode72:       HANGUP
OpCode73:       OP_RORADC(INDY)
OpCode74:       OP_NOP2
OpCode75:       OP_ADC(READ_ZPAGEX)
OpCode76:       OP_ROR(ZPAGEX)
OpCode77:       OP_RORADC(ZPAGEX)
OpCode78:       OP_SEI
OpCode79:       OP_ADC(READ_ABSY)
OpCode7A:       OP_NOP1
OpCode7B:       OP_RORADC(ABSY)
OpCode7C:       OP_NOP3
OpCode7D:       OP_ADC(READ_ABSX)
OpCode7E:       OP_ROR(ABSX)
OpCode7F:       OP_RORADC(ABSX)

OpCode80:       OP_NOP2
OpCode81:       OP_STA(WRITE_INDX)
OpCode82:       OP_NOP2
OpCode83:       OP_STXSTA(WRITE_INDX)
OpCode84:       OP_STY(WRITE_ZPAGE)
OpCode85:       OP_STA(WRITE_ZPAGE)
OpCode86:       OP_STX(WRITE_ZPAGE)
OpCode87:       OP_STXSTA(WRITE_ZPAGE)
OpCode88:       OP_DEY
OpCode89:       OP_NOP2
OpCode8A:       OP_TXA
OpCode8B:       OP_LXI(READ_IMM)
OpCode8C:       OP_STY(WRITE_ABS)
OpCode8D:       OP_STA(WRITE_ABS)
OpCode8E:       OP_STX(WRITE_ABS)
OpCode8F:       OP_STXSTA(WRITE_ABS)

OpCode90:       OP_BCC
OpCode91:       OP_STA(WRITE_INDY)
OpCode92:       HANGUP
OpCode93:       OP_BAX(WRITE_INDY)
OpCode94:       OP_STY(WRITE_ZPAGEX)
OpCode95:       OP_STA(WRITE_ZPAGEX)
OpCode96:       OP_STX(WRITE_ZPAGEY)
OpCode97:       OP_STXSTA(WRITE_ZPAGEY)
OpCode98:       OP_TYA
OpCode99:       OP_STA(WRITE_ABSY)
OpCode9A:       OP_TXS
OpCode9B:       OP_SAX
OpCode9C:       OP_SBY(WRITE_ABSX)
OpCode9D:       OP_STA(WRITE_ABSX)
OpCode9E:       OP_SHX(WRITE_ABS)
OpCode9F:       OP_HXA(WRITE_ABS)

OpCodeA0:       OP_LDY(READ_IMM)
OpCodeA1:       OP_LDA(READ_INDX)
OpCodeA2:       OP_LDX(READ_IMM)
OpCodeA3:       OP_LDXLDA(READ_INDX)
OpCodeA4:       OP_LDY(READ_ZPAGE)
OpCodeA5:       OP_LDA(READ_ZPAGE)
OpCodeA6:       OP_LDX(READ_ZPAGE)
OpCodeA7:       OP_LDXLDA(READ_ZPAGE)
OpCodeA8:       OP_TAY
OpCodeA9:       OP_LDA(READ_IMM)
OpCodeAA:       OP_TAX
OpCodeAB:       OP_LDXLDA(READ_IMM)
OpCodeAC:       OP_LDY(READ_ABS)
OpCodeAD:       OP_LDA(READ_ABS)
OpCodeAE:       OP_LDX(READ_ABS)
OpCodeAF:       OP_LDXLDA(READ_ABS)

OpCodeB0:       OP_BCS
OpCodeB1:       OP_LDA(READ_INDY)
OpCodeB2:       HANGUP
OpCodeB3:       OP_LDXLDA(READ_INDY)
OpCodeB4:       OP_LDY(READ_ZPAGEX)
OpCodeB5:       OP_LDA(READ_ZPAGEX)
OpCodeB6:       OP_LDX(READ_ZPAGEY)
OpCodeB7:       OP_LDXLDA(READ_ZPAGEY)
OpCodeB8:       OP_CLV
OpCodeB9:       OP_LDA(READ_ABSY)
OpCodeBA:       OP_TSX
OpCodeBB:       OP_AXS(READ_ABSY)
OpCodeBC:       OP_LDY(READ_ABSX)
OpCodeBD:       OP_LDA(READ_ABSX)
OpCodeBE:       OP_LDX(READ_ABSY)
OpCodeBF:       OP_LDXLDA(READ_ABSY)

OpCodeC0:       OP_CPY(READ_IMM)
OpCodeC1:       OP_CMP(READ_INDX)
OpCodeC2:       OP_NOP2
OpCodeC3:       OP_DECCMP(INDX)
OpCodeC4:       OP_CPY(READ_ZPAGE)
OpCodeC5:       OP_CMP(READ_ZPAGE)
OpCodeC6:       OP_DEC(ZPAGE)
OpCodeC7:       OP_DECCMP(ZPAGE)
OpCodeC8:       OP_INY
OpCodeC9:       OP_CMP(READ_IMM)
OpCodeCA:       OP_DEX
OpCodeCB:       OP_AXM(READ_IMM)
OpCodeCC:       OP_CPY(READ_ABS)
OpCodeCD:       OP_CMP(READ_ABS)
OpCodeCE:       OP_DEC(ABS)
OpCodeCF:       OP_DECCMP(ABS)

OpCodeD0:       OP_BNE
OpCodeD1:       OP_CMP(READ_INDY)
OpCodeD2:       HANGUP
OpCodeD3:       OP_DECCMP(INDY)
OpCodeD4:       OP_NOP2
OpCodeD5:       OP_CMP(READ_ZPAGEX)
OpCodeD6:       OP_DEC(ZPAGEX)
OpCodeD7:       OP_DECCMP(ZPAGEX)
OpCodeD8:       OP_CLD
OpCodeD9:       OP_CMP(READ_ABSY)
OpCodeDA:       OP_NOP1
OpCodeDB:       OP_DECCMP(ABSY)
OpCodeDC:       OP_NOP3
OpCodeDD:       OP_CMP(READ_ABSX)
OpCodeDE:       OP_DEC(ABSX)
OpCodeDF:       OP_DECCMP(ABSX)

OpCodeE0:       OP_CPX(READ_IMM)
OpCodeE1:       OP_SBC(READ_INDX)
OpCodeE2:       OP_NOP2
OpCodeE3:       OP_INCSBC(INDX)
OpCodeE4:       OP_CPX(READ_ZPAGE)
OpCodeE5:       OP_SBC(READ_ZPAGE)
OpCodeE6:       OP_INC(ZPAGE)
OpCodeE7:       OP_INCSBC(ZPAGE)
OpCodeE8:       OP_INX
OpCodeE9:       OP_SBC(READ_IMM)
OpCodeEA:       OP_NOP
OpCodeEB:       OP_SBC(READ_IMM)
OpCodeEC:       OP_CPX(READ_ABS)
OpCodeED:       OP_SBC(READ_ABS)
OpCodeEE:       OP_INC(ABS)
OpCodeEF:       OP_INCSBC(ABS)

OpCodeF0:       OP_BEQ
OpCodeF1:       OP_SBC(READ_INDY)
OpCodeF2:       HANGUP
OpCodeF3:       OP_INCSBC(INDY)
OpCodeF4:       OP_NOP2
OpCodeF5:       OP_SBC(READ_ZPAGEX)
OpCodeF6:       OP_INC(ZPAGEX)
OpCodeF7:       OP_INCSBC(ZPAGEX)
OpCodeF8:       OP_SED
OpCodeF9:       OP_SBC(READ_ABSY)
OpCodeFA:       OP_NOP1
OpCodeFB:       OP_INCSBC(ABSY)
OpCodeFC:       OP_NOP3
OpCodeFD:       OP_SBC(READ_ABSX)
OpCodeFE:       OP_INC(ABSX)
OpCodeFF:       OP_INCSBC(ABSX)

1:
2:
4:      hlt
