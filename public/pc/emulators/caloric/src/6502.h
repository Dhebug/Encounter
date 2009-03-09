/*
 *	6502.h - 6502 emulation (opcodes)
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


/*****************************************************************************
******************************************************************************/

#define A %bl
#define X %cl
#define Y %ch
#define PC %esi
#define NZ %bh
#define Clock %ebp
#define HighMemRead %edi

#define PAGE0 Oric_Mem
#define PAGE1 Oric_Mem+0x100

#define SET_NZ lahf; movb %ah,%bh
#define SET_NZC SET_NZ; movb %bh,MANGLE_SYM(Carry)
#define SET_NZB cmc; SET_NZC
#define SET_NVZC setob MANGLE_SYM(Overflow); SET_NZC
#define SET_NVZB setob MANGLE_SYM(Overflow); SET_NZB

/*****************************************************************************
******************************************************************************/

#define FETCH FETCHW(A)
#define FETCHX FETCHW(X)
#define FETCHY FETCHW(Y)


#ifndef DEBUG
#define FETCHW(reg) \
	subl $clk,Clock; \
	js 6b; \
2:      testw $0xFFFF,MANGLE_SYM(Sys_Request); \
	jnz 8b; \
4:      xorl %eax,%eax; \
	lodsb; \
    pusha; \
    call saveRegisters; \
    call MANGLE_SYM(debugStep); \
    popa; \
	jmp *OpCodeTable(,%eax,4); \
6:      call *IO_Read-0x300*4(,%eax,4); \
	jmp 7b; \
8:      movl %eax,%edx; \
	movb reg,%al; \
	call *IO_Write-0x300*4(,%edx,4); \
	jmp 9b; \
	.align  4; \
1:      movb Oric_Mem(%eax,%edi),%al; \
	jmp 7b; \
	.align  4; \
3:      addl HighMemWrite,%eax; \
	movb reg,Oric_Mem(%eax); \
	jmp 9b; \
	.align  4; \
2:      decl Clock; \
	jmp 1f; \
6:      call Clock_countdown; \
	jmp 2f; \
5:      call Handle_Sys_Req; \
	jmp 4f; \
8:      testw $0xFF00,MANGLE_SYM(Sys_Request); \
	jnz 5b; \
	testb $4,MANGLE_SYM(Flags); \
	jnz 4f; \
	jmp Handle_IRQ; \
	.align 4
#else
#define FETCHW(reg) \
    call MANGLE_SYM(debugStep); \
    call saveRegisters; \
	subl $clk,Clock; \
	js 6b; \
2:      testw $0xFFFF,MANGLE_SYM(Sys_Request); \
	jnz 8b; \
4:      call debug;\
	xorl %eax,%eax; \
	lodsb; \
	jmp *OpCodeTable(,%eax,4); \
6:      call *IO_Read-0x300*4(,%eax,4); \
	jmp 7b; \
8:      movl %eax,%edx; \
	movb reg,%al; \
	call *IO_Write-0x300*4(,%edx,4); \
	jmp 9b; \
	.align  4; \
1:      movb Oric_Mem(%eax,%edi),%al; \
	jmp 7b; \
	.align  4; \
3:      addl HighMemWrite,%eax; \
	movb reg,Oric_Mem(%eax); \
	jmp 9b; \
	.align  4; \
2:      decl Clock; \
	jmp 1f; \
6:      call Clock_countdown; \
	jmp 2f; \
5:      call Handle_Sys_Req; \
	jmp 4f; \
8:      testw $0xFF00,MANGLE_SYM(Sys_Request); \
	jnz 5b; \
	testb $4,MANGLE_SYM(Flags); \
	jnz 4f; \
	jmp Handle_IRQ; \
	.align 4
#endif

#define READ_IMM(OP,reg)        lodsb; OP %al,reg; clk=2
#define READ_ZPAGE(OP,reg)      lodsb; OP PAGE0(%eax),reg; clk=3
#define READ_ZPAGEX(OP,reg)     lodsb; addb %cl,%al; OP PAGE0(%eax),reg; clk=4
#define READ_ZPAGEY(OP,reg)     lodsb; addb %ch,%al; OP PAGE0(%eax),reg; clk=4
#define READ_ABS(OP,reg)        \
	clk=4; \
	lodsw; \
	cmpb $3,%ah; \
	je 6f; \
	cmpb Bank_point+1,%ah; \
	jae 1f; \
	movb Oric_Mem(%eax),%al; \
7:      OP %al,reg
#define READ_ABSX(OP,reg)       \
	clk=4; \
	lodsw; \
	addb %cl,%al; \
	jc 2b; \
1:      adcb $0,%ah; \
	cmpb $3,%ah; \
	je 6f; \
	cmpb Bank_point+1,%ah; \
	jae 1f; \
	movb Oric_Mem(%eax),%al; \
7:      OP %al,reg
#define READ_ABSY(OP,reg)       \
	clk=4; \
	lodsw; \
	addb %ch,%al; \
	jc 2b; \
1:      adcb $0,%ah; \
	cmpb $3,%ah; \
	je 6f; \
	cmpb Bank_point+1,%ah; \
	jae 1f; \
	movb Oric_Mem(%eax),%al; \
7:      OP %al,reg
#define READ_INDX(OP,reg) \
	clk=6; \
	lodsb; \
	addb %cl,%al; \
	movw PAGE0(%eax),%ax; \
	cmpb $3,%ah; \
	je 6f; \
	cmpb Bank_point+1,%ah; \
	jae 1f; \
	movb Oric_Mem(%eax),%al; \
7:      OP %al,reg
#define READ_INDY(OP,reg) \
	clk=5; \
	lodsb; \
	movw PAGE0(%eax),%ax; \
	addb %ch,%al; \
	jc 2b; \
1:      adcb $0,%ah; \
	cmpb $3,%ah; \
	je 6f; \
	cmpb Bank_point+1,%ah; \
	jae 1f; \
	movb Oric_Mem(%eax),%al; \
7:      OP %al,reg

#define WRITE_ZPAGE(reg)        lodsb; movb reg,PAGE0(%eax); clk=3
#define WRITE_ZPAGEX(reg)       lodsb; addb %cl,%al; movb reg,PAGE0(%eax); clk=4
#define WRITE_ZPAGEY(reg)       lodsb; addb %ch,%al; movb reg,PAGE0(%eax); clk=4
#define WRITE_ABS(reg)  \
	clk=4; \
	lodsw; \
	cmpb $3,%ah; \
	je 8f; \
	cmpb Bank_point+1,%ah; \
	jae 3f; \
	movb reg,Oric_Mem(%eax); \
9:
#define WRITE_ABSX(reg) \
	clk=5; \
	lodsw; \
	addb %cl,%al; \
	adcb $0,%ah; \
	cmpb $3,%ah; \
	je 8f; \
	cmpb Bank_point+1,%ah; \
	jae 3f; \
	movb reg,Oric_Mem(%eax); \
9:
#define WRITE_ABSY(reg) \
	clk=5; \
	lodsw; \
	addb %ch,%al; \
	adcb $0,%ah; \
	cmpb $3,%ah; \
	je 8f; \
	cmpb Bank_point+1,%ah; \
	jae 3f; \
	movb reg,Oric_Mem(%eax); \
9:
#define WRITE_INDX(reg) \
	clk=6; \
	lodsb; \
	addb %cl,%al; \
	movw PAGE0(%eax),%ax; \
	cmpb $3,%ah; \
	je 8f; \
	cmpb Bank_point+1,%ah; \
	jae 3f; \
	movb reg,Oric_Mem(%eax); \
9:
#define WRITE_INDY(reg) \
	clk=6; \
	lodsb; \
	movw PAGE0(%eax),%ax; \
	addb %ch,%al; \
	adcb $0,%ah; \
	cmpb $3,%ah; \
	je 8f; \
	cmpb Bank_point+1,%ah; \
	jae 3f; \
	movb reg,Oric_Mem(%eax); \
9:

#define ZPAGE   lodsb; clk=5
#define ZPAGEX  lodsb; addb %cl,%al; clk=6
#define ZPAGEY  lodsb; addb %ch,%al; clk=6
#define ABS     lodsw; clk=6
#define ABSX    lodsw; addb %cl,%al; adcb $0,%ah; clk=7
#define ABSY    lodsw; addb %ch,%al; adcb $0,%ah; clk=7
#define INDX    lodsb; addb %cl,%al; movw PAGE0(%eax),%ax; clk=8
#define INDY    lodsb; movw PAGE0(%eax),%ax; addb %ch,%al; adcb $0,%ah; clk=8

/*****************************************************************************
******************************************************************************/

#define OP_LDA(ADR) ADR(movb,A); orb A,A; SET_NZ; FETCH
#define OP_STA(ADR) ADR(A); FETCH
#define OP_ORA(ADR) ADR(orb,A); SET_NZ; FETCH
#define OP_AND(ADR) ADR(andb,A); SET_NZ; FETCH
#define OP_EOR(ADR) ADR(xorb,A); SET_NZ; FETCH
#define OP_CMP(ADR) ADR(cmpb,A); SET_NZB; FETCH
#define OP_ADC(ADR) \
	ADR(movb,%al); \
	testb $8,MANGLE_SYM(Flags); \
	jnz 0f; \
	shrb $1,MANGLE_SYM(Carry); \
	adcb %al,A; \
	SET_NVZC; \
	FETCH; \
0:      shrb $1,MANGLE_SYM(Carry); \
	adcb A,%al; \
	daa; \
	movb %al,A; \
	SET_NVZC; \
	FETCH
#define OP_SBC(ADR) \
	ADR(movb,%al); \
	testb $8,MANGLE_SYM(Flags); \
	jnz 0f; \
	shrb $1,MANGLE_SYM(Carry); \
	cmc; \
	sbbb %al,A; \
	SET_NVZB; \
	FETCH; \
0:      shrb $1,MANGLE_SYM(Carry); \
	cmc; \
	sbbb %al,A; \
	movb A,%al; \
	das; \
	movb %al,A; \
	SET_NVZB; \
	FETCH

#define OP_LDX(ADR) ADR(movb,X); orb X,X; SET_NZ; FETCH
#define OP_LDY(ADR) ADR(movb,Y); orb Y,Y; SET_NZ; FETCH
#define OP_STX(ADR) ADR(X); FETCHX
#define OP_STY(ADR) ADR(Y); FETCHY
#define OP_CPX(ADR) ADR(cmpb,X); SET_NZB; FETCH
#define OP_CPY(ADR) ADR(cmpb,Y); SET_NZB; FETCH

#define OP_TXA movb X,A; orb A,A; SET_NZ; clk=2; FETCH
#define OP_TYA movb Y,A; orb A,A; SET_NZ; clk=2; FETCH
#define OP_TAX movb A,X; orb A,A; SET_NZ; clk=2; FETCH
#define OP_TAY movb A,Y; orb A,A; SET_NZ; clk=2; FETCH
#define OP_TSX movb MANGLE_SYM(S),%al; movb %al,X; orb %al,%al; SET_NZ; clk=2; FETCH
#define OP_TXS movb X,%al; movb %al,MANGLE_SYM(S); clk=2; FETCH

#define OP_DEX decb X; SET_NZ; clk=2; FETCH
#define OP_DEY decb Y; SET_NZ; clk=2; FETCH
#define OP_INX incb X; SET_NZ; clk=2; FETCH
#define OP_INY incb Y; SET_NZ; clk=2; FETCH

/*****************************************************************************
******************************************************************************/

#define OP_BIT(ADR) \
	ADR(movb,%al); \
	testb $0x40,%al; \
	setnzb MANGLE_SYM(Overflow); \
	testb A,%al; \
	SET_NZ; \
	andb $~0x80,%bh; \
	andb $0x80,%al; \
	orb %al,%bh; \
	FETCH

/*****************************************************************************
******************************************************************************/

#define OP_ASL_A shlb $1,A; SET_NZC; clk=2; FETCH
#define OP_LSR_A shrb $1,A; SET_NZC; clk=2; FETCH
#define OP_ROL_A shrb $1,MANGLE_SYM(Carry); rclb $1,A; setc MANGLE_SYM(Carry); orb A,A; SET_NZ; clk=2; FETCH
#define OP_ROR_A shrb $1,MANGLE_SYM(Carry); rcrb $1,A; setc MANGLE_SYM(Carry); orb A,A; SET_NZ; clk=2; FETCH

#define OP_ASL(ADR) \
	ADR; \
	cmpb Bank_point+1,%ah; \
	jb 0f; \
	movb Oric_Mem(%eax,%edi),%dl; \
	addl HighMemWrite,%eax; \
	shlb $1,%dl; \
	movb %dl,Oric_Mem(%eax); \
	SET_NZC; \
	FETCH; \
0:      cmpb $3,%ah; \
	je 0f; \
	shlb $1,Oric_Mem(%eax); \
	SET_NZC; \
	FETCH; \
0:      movl %eax,%edx; \
	call *IO_Read-0x300*4(,%eax,4); \
	shlb $1,%al; \
	SET_NZC; \
	call *IO_Write-0x300*4(,%edx,4); \
	FETCH

#define OP_LSR(ADR) \
	ADR; \
	cmpb Bank_point+1,%ah; \
	jb 0f; \
	movb Oric_Mem(%eax,%edi),%dl; \
	addl HighMemWrite,%eax; \
	shrb $1,%dl; \
	movb %dl,Oric_Mem(%eax); \
	SET_NZC; \
	FETCH; \
0:      cmpb $3,%ah; \
	je 0f; \
	shrb $1,Oric_Mem(%eax); \
	SET_NZC; \
	FETCH; \
0:      movl %eax,%edx; \
	call *IO_Read-0x300*4(,%eax,4); \
	shrb $1,%al; \
	SET_NZC; \
	call *IO_Write-0x300*4(,%edx,4); \
	FETCH

#define OP_ROL(ADR) \
	ADR; \
	cmpb Bank_point+1,%ah; \
	jb 0f; \
	movb Oric_Mem(%eax,%edi),%dl; \
	addl HighMemWrite,%eax; \
	shrb $1,MANGLE_SYM(Carry); \
	rclb $1,%dl; \
	setc MANGLE_SYM(Carry); \
	testb $0xFF,%dl; \
	movb %dl,Oric_Mem(%eax); \
	SET_NZ; \
	FETCH; \
0:      cmpb $3,%ah; \
	je 0f; \
	shrb $1,MANGLE_SYM(Carry); \
	rclb $1,Oric_Mem(%eax); \
	setc MANGLE_SYM(Carry); \
	testb $0xFF,Oric_Mem(%eax); \
	SET_NZ; \
	FETCH; \
0:      movl %eax,%edx; \
	call *IO_Read-0x300*4(,%eax,4); \
	shrb $1,MANGLE_SYM(Carry); \
	rclb $1,%al; \
	setc MANGLE_SYM(Carry); \
	testb $0xFF,%al; \
	SET_NZ; \
	call *IO_Write-0x300*4(,%edx,4); \
	FETCH

#define OP_ROR(ADR) \
	ADR; \
	cmpb Bank_point+1,%ah; \
	jb 0f; \
	movb Oric_Mem(%eax,%edi),%dl; \
	addl HighMemWrite,%eax; \
	shrb $1,MANGLE_SYM(Carry); \
	rcrb $1,%dl; \
	setc MANGLE_SYM(Carry); \
	testb $0xFF,%dl; \
	movb %dl,Oric_Mem(%eax); \
	SET_NZ; \
	FETCH; \
0:      cmpb $3,%ah; \
	je 0f; \
	shrb $1,MANGLE_SYM(Carry); \
	rcrb $1,Oric_Mem(%eax); \
	setc MANGLE_SYM(Carry); \
	testb $0xFF,Oric_Mem(%eax); \
	SET_NZ; \
	FETCH; \
0:      movl %eax,%edx; \
	call *IO_Read-0x300*4(,%eax,4); \
	shrb $1,MANGLE_SYM(Carry); \
	rcrb $1,%al; \
	setc MANGLE_SYM(Carry); \
	testb $0xFF,%al; \
	SET_NZ; \
	call *IO_Write-0x300*4(,%edx,4); \
	FETCH

#define OP_DEC(ADR) \
	ADR; \
	cmpb Bank_point+1,%ah; \
	jb 0f; \
	movb Oric_Mem(%eax,%edi),%dl; \
	addl HighMemWrite,%eax; \
	decb %dl; \
	movb %dl,Oric_Mem(%eax); \
	SET_NZ; \
	FETCH; \
0:      cmpb $3,%ah; \
	je 0f; \
	decb Oric_Mem(%eax); \
	SET_NZ; \
	FETCH; \
0:      movl %eax,%edx; \
	call *IO_Read-0x300*4(,%eax,4); \
	decb %al; \
	SET_NZ; \
	call *IO_Write-0x300*4(,%edx,4); \
	FETCH

#define OP_INC(ADR) \
	ADR; \
	cmpb Bank_point+1,%ah; \
	jb 0f; \
	movb Oric_Mem(%eax,%edi),%dl; \
	addl HighMemWrite,%eax; \
	incb %dl; \
	movb %dl,Oric_Mem(%eax); \
	SET_NZ; \
	FETCH; \
0:      cmpb $3,%ah; \
	je 0f; \
	incb Oric_Mem(%eax); \
	SET_NZ; \
	FETCH; \
0:      movl %eax,%edx; \
	call *IO_Read-0x300*4(,%eax,4); \
	incb %al; \
	SET_NZ; \
	call *IO_Write-0x300*4(,%edx,4); \
	FETCH

/*****************************************************************************
******************************************************************************/


#define SPOP(reg) movb MANGLE_SYM(S),%al; incb %al; movb %al,MANGLE_SYM(S); movb PAGE1(%eax),reg
#define SPUSH(reg) movb MANGLE_SYM(S),%al; movb reg,PAGE1(%eax); decb %al; movb %al,MANGLE_SYM(S)

#define POPPC \
	xorl %esi,%esi; \
	movb MANGLE_SYM(S),%al; \
	incb %al; \
	movw PAGE1(%eax),%si; \
	cmpw Bank_point,%si; \
	jb 0f; \
	addl %edi,%esi; \
0:      incb %al; \
	movb %al,MANGLE_SYM(S); \
	addl $Oric_Mem,%esi

#define PUSHPC \
	subl $Oric_Mem,%esi; \
	cmpl Bank_point,%esi; \
	jb 0f; \
	subl %edi,%esi; \
0:      movb MANGLE_SYM(S),%al; \
	decb %al; \
	movw %si,PAGE1(%eax); \
	decb %al; \
	movb %al,MANGLE_SYM(S)

#define POPFLAG \
	SPOP(%al); \
	orb $0x30,%al; \
	movb %al,MANGLE_SYM(Flags); \
	movb %al,MANGLE_SYM(Carry); \
	testb $0x40,%al; \
	setnzb MANGLE_SYM(Overflow); \
	andb $0b10000010,%al; \
	addb $0b00111110,%al; \
	movb %al,%bh

#define PUSHFLAG \
	movb    MANGLE_SYM(Flags),%dl; \
	andb    $0b00111100,%dl; \
	orb     $0b00010000,%dl; \
	movb    %bh,%al; \
	andb    $0x80,%al; \
	orb     %al,%dl; \
	movb    %bh,%al; \
	andb    $0x40,%al; \
	shrb    $5,%al; \
	orb     %al,%dl; \
	movb    MANGLE_SYM(Overflow),%al; \
	shlb    $6,%al; \
	orb     %al,%dl; \
	movb    MANGLE_SYM(Carry),%al; \
	andb    $1,%al; \
	orb     %al,%dl; \
	SPUSH(%dl)

#define PUSHFLAG_IRQ \
	movb    MANGLE_SYM(Flags),%dl; \
	andb    $0b00101100,%dl; \
	movb    %bh,%al; \
	andb    $0x80,%al; \
	orb     %al,%dl; \
	movb    %bh,%al; \
	andb    $0x40,%al; \
	shrb    $5,%al; \
	orb     %al,%dl; \
	movb    MANGLE_SYM(Overflow),%al; \
	shlb    $6,%al; \
	orb     %al,%dl; \
	movb    MANGLE_SYM(Carry),%al; \
	andb    $1,%al; \
	orb     %al,%dl; \
	SPUSH(%dl)

#define OP_PHP PUSHFLAG; clk=3; FETCH
#define OP_PLP POPFLAG; clk=4; FETCH
#define OP_PHA SPUSH(A); clk=3; FETCH
#define OP_PLA SPOP(A); orb A,A; SET_NZ; clk=4; FETCH


/*****************************************************************************
******************************************************************************/

#define OP_NOP clk=2; FETCH

#define OP_CLC movb $0,MANGLE_SYM(Carry); clk=2; FETCH
#define OP_SEC movb $1,MANGLE_SYM(Carry); clk=2; FETCH
#define OP_CLI andb $~4,MANGLE_SYM(Flags); clk=2; FETCH
#define OP_SEI orb $4,MANGLE_SYM(Flags); clk=2; FETCH
#define OP_CLV movb $0,MANGLE_SYM(Overflow); clk=2; FETCH
#define OP_CLD andb $~8,MANGLE_SYM(Flags); clk=2; FETCH
#define OP_SED orb $8,MANGLE_SYM(Flags); clk=2; FETCH

/*****************************************************************************
******************************************************************************/

#define BRANCH \
	lodsb; \
	jz 0f; \
	subl $Oric_Mem,%esi; \
	movsbl %al,%edx; \
	movl %esi,%eax; \
	addl %esi,%edx; \
	cmpb %ah,%dh; \
	jne 2b; \
1:      movl %edx,%esi; \
	addl $Oric_Mem,%esi; \
	clk=3; \
	FETCH; \
0:      clk=2; \
	FETCH

#define BRANCHNOT \
	lodsb; \
	jnz 0f; \
	subl $Oric_Mem,%esi; \
	movsbl %al,%edx; \
	movl %esi,%eax; \
	addl %esi,%edx; \
	cmpb %ah,%dh; \
	jne 2b; \
1:      movl %edx,%esi; \
	addl $Oric_Mem,%esi; \
	clk=3; \
	FETCH; \
0:      clk=2; \
	FETCH

#define OP_BPL testb $0x80,%bh; BRANCHNOT
#define OP_BMI testb $0x80,%bh; BRANCH
#define OP_BNE testb $0x40,%bh; BRANCHNOT
#define OP_BEQ testb $0x40,%bh; BRANCH
#define OP_BCC testb $1,MANGLE_SYM(Carry); BRANCHNOT
#define OP_BCS testb $1,MANGLE_SYM(Carry); BRANCH
#define OP_BVC testb $1,MANGLE_SYM(Overflow); BRANCHNOT
#define OP_BVS testb $1,MANGLE_SYM(Overflow); BRANCH


/*****************************************************************************
******************************************************************************/



#define OP_JMP \
	clk=3; \
	lodsw; \
	cmpb Bank_point+1,%ah; \
	jae 0f; \
	leal Oric_Mem(%eax),%esi; \
	FETCH; \
0:      leal Oric_Mem(%eax,%edi),%esi; \
	FETCH

#define OP_JMP_IND \
	clk=5; \
	lodsw; \
	cmpb Bank_point+1,%ah; \
	jae rom_ind; \
	movw Oric_Mem(%eax),%ax; \
	cmpb Bank_point+1,%ah; \
	jae 0f; \
	leal Oric_Mem(%eax),%esi; \
	FETCH; \
0:      leal Oric_Mem(%eax,%edi),%esi; \
	FETCH; \
rom_ind: movzwl Oric_Mem(%eax,%edi),%eax; \
	cmpb Bank_point+1,%ah; \
	jae 0f; \
	leal Oric_Mem(%eax),%esi; \
	FETCH; \
0:      leal Oric_Mem(%eax,%edi),%esi; \
	FETCH

#define OP_JSR \
	clk=6; \
	movl %esi,%edx; \
	incl %esi; \
	PUSHPC; \
	movl %edx,%esi; \
	lodsw; \
	cmpb Bank_point+1,%ah; \
	jae 0f; \
	leal Oric_Mem(%eax),%esi; \
	FETCH; \
0:      leal Oric_Mem(%eax,%edi),%esi; \
	FETCH

#define OP_RTS POPPC; incl %esi; clk=6; FETCH

#define OP_BRK \
	clk=7                                           ;\
	lodsb                                           ;\
        PUSHPC                                          ;\
	PUSHFLAG                                        ;\
	orb     $4,MANGLE_SYM(Flags)                                ;\
	movw    Oric_Mem+0xFFFE(%edi),%ax               ;\
	cmpb    Bank_point+1,%ah                               ;\
	jae 0f                                          ;\
	leal    Oric_Mem(%eax),%esi                     ;\
        FETCH                                           ;\
0:      leal    Oric_Mem(%eax,%edi),%esi                ;\
	FETCH


#define OP_RTI POPFLAG; POPPC; clk=6; FETCH

/*****************************************************************************
******************************************************************************/


#define HANGUP jmp Crash

#define OP_NOP1 clk=2; FETCH
#define OP_NOP2 incl PC; clk=2; FETCH
#define OP_NOP3 incl PC; incl PC; clk=2; FETCH

#define OP_ASLORA(ADR) \
	ADR; \
	clk=clk+2; \
	shlb $1,Oric_Mem(%eax); \
	setcb MANGLE_SYM(Carry); \
	orb Oric_Mem(%eax),A; \
	SET_NZ; \
	FETCH

#define OP_LSREOR(ADR) \
	ADR; \
	clk=clk+2; \
	shrb $1,Oric_Mem(%eax); \
	setcb MANGLE_SYM(Carry); \
	xorb Oric_Mem(%eax),A; \
	SET_NZ; \
	FETCH

#define OP_ROLAND(ADR) \
	ADR; \
	clk=clk+2; \
	shrb $1,MANGLE_SYM(Carry); \
	rclb $1,Oric_Mem(%eax); \
	setcb MANGLE_SYM(Carry); \
	andb Oric_Mem(%eax),A; \
	SET_NZ; \
	FETCH

#define OP_RORADC(ADR) \
	ADR; \
	shrb $1,MANGLE_SYM(Carry); \
	rcrb $1,Oric_Mem(%eax); \
	setcb MANGLE_SYM(Carry); \
	testb $8,MANGLE_SYM(Flags); \
	jnz 0f; \
	shrb $1,MANGLE_SYM(Carry); \
	adcb Oric_Mem(%eax),A; \
	SET_NVZC; \
	clk=clk+2; \
	FETCH; \
0:      shrb $1,MANGLE_SYM(Carry); \
	adcb Oric_Mem(%eax),A; \
	movb A,%al; \
	daa; \
	movb %al,A; \
	SET_NVZC; \
	FETCH

#define OP_STXSTA(ADR) movb X,%al; andb A,%al; ADR(%al); FETCH
#define OP_LDXLDA(ADR) ADR(movb,A); movb A,X; orb A,A; SET_NZ; FETCH

#define OP_DECCMP(ADR) \
	ADR; \
	clk=clk+2; \
	decb Oric_Mem(%eax); \
	cmpb Oric_Mem(%eax),A; \
	SET_NZB; \
	FETCH

#define OP_INCSBC(ADR) \
	ADR; \
	clk=clk+2; \
	incb Oric_Mem(%eax); \
	testb $8,MANGLE_SYM(Flags); \
	jnz 0f; \
	shrb $1,MANGLE_SYM(Carry); \
	cmc; \
	sbbb Oric_Mem(%eax),A; \
	SET_NVZB; \
	FETCH; \
0:      shrb $1,MANGLE_SYM(Carry); \
	cmc; \
	sbbb Oric_Mem(%eax),A; \
	movb A,%al; \
	das; \
	movb %al,A; \
	SET_NVZB; \
	FETCH

#define OP_BAX(ADR) movb X,%al; andb A,%al; andb $0x0F,%al; ADR(%al); FETCH
#define OP_LSA(ADR) ADR(andb,A); shrb $1,A; SET_NZC; FETCH
#define OP_ROA(ADR) ADR(andb,A); shrb $1,MANGLE_SYM(Carry); rcrb $1,A; setcb MANGLE_SYM(Carry); orb A,A; SET_NZ; FETCH
#define OP_LXI(ADR) ADR(movb,A); andb X,A; SET_NZ; FETCH
#define OP_SAX movb A,%al; andb X,%al; movb %al,MANGLE_SYM(S); incl PC; incl PC; clk=5; FETCH
#define OP_AXS(ADR) ADR(movb,%al); andb MANGLE_SYM(S),%al; movb %al,MANGLE_SYM(S); movb %al,A; movb %al,X; FETCH
#define OP_AXM(ADR) movb A,X; ADR(subb,X); setncb MANGLE_SYM(Carry); FETCH
#define OP_SBY(ADR) movb Y,%al; andb $0x0F,%al; ADR(%al); FETCH
#define OP_SHX(ADR) movb 1(PC),%al; andb X,%al; ADR(%al); FETCH
#define OP_HXA(ADR) movb 1(PC),%al; andb X,%al; andb A,%al; ADR(%al); FETCH
