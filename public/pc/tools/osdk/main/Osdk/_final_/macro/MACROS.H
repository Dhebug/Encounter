/* macros for the 16 bit code generator (version 1.29) F.Frances */

#define DB(n)\
	.byt n ;\

#define DW(n)\
	.word n ;\

#define SPACE(n)\
	.dsb n ;\

#define ZERO(n)\
	.dsb n ;\

#define ENTER(r,n)\
	ldx #n ;\
	lda #r ;\
	jsr enter ;\

#define LEAVE\
	jmp leave ;\

#define LEAVEW_C(cte1)\
	ldx #<(cte1) ;\
	lda #>(cte1) ;\
	jmp leave ;\

#define LEAVEW_A(ptr1,y1)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	jmp leave ;\

#define LEAVEW_D(tmp1)\
	ldx tmp1 ;\
	lda tmp1+1 ;\
	jmp leave ;\

#define LEAVEW_I(ptr1,y1)\
	ldy #y1 ;\
	lda ptr1,y ;\
	tax ;\
	iny ;\
	lda ptr1,y ;\
	jmp leave ;\

#define RET\
	rts ;\

#define RETW_C(cte1)\
	ldx #<(cte1) ;\
	lda #>(cte1) ;\
	rts ;\

#define	RETW_A(ptr1,y1)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	rts ;\

#define RETW_D(tmp1)\
	ldx tmp1 ;\
	lda tmp1+1 ;\
	rts ;\

#define CNST_CD(cte1,tmp)\
	ldx #<(cte1) ;\
	stx tmp ;\
	lda #>(cte1) ;\
	sta tmp+1 ;\

#define ADDR_CD(adr1,tmp)\
	ldx #<(adr1) ;\
	stx tmp ;\
	lda #>(adr1) ;\
	sta tmp+1 ;\

#define ADDR_AD(ptr1,y1,tmp2)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	sta tmp2 ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta tmp2+1 ;\

#define CZBW_CD(cte1,tmp2)\
	lda #cte1 ;\
	sta tmp2 ;\
	lda #0 ;\
	sta tmp2+1 ;\

#define CZBW_CI(cte1,ptr2,y2)\
	ldy #y2 ;\
	lda #cte1 ;\
	sta ptr2,y ;\
	iny ;\
	lda #0 ;\
	sta ptr2,y ;\

#define CZBW_DD(tmp1,tmp2)\
	lda tmp1 ;\
	sta tmp2 ;\
	lda #0 ;\
	sta tmp2+1 ;\

#define CZBW_DI(tmp1,ptr2,y2)\
	ldy #y2 ;\
	lda tmp1 ;\
	sta ptr2,y ;\
	iny ;\
	lda #0 ;\
	sta ptr2,y ;\

#define CZBW_ID(ptr1,y1,tmp2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp2 ;\
	lda #0 ;\
	sta tmp2+1 ;\

#define CZBW_II(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	iny ;\
	lda #0 ;\
	sta ptr2,y ;\

#define CWB_CD(cte1,tmp2)\
	lda #< cte1 ;\
	sta tmp2 ;\

#define CWB_CI(cte1,ptr2,y2)\
	ldy #y2 ;\
	lda #< cte1 ;\
	sta ptr2,y ;\

#define CWB_DD(tmp1,tmp2)\
	lda tmp1 ;\
	sta tmp2 ;\

#define CWB_DI(tmp1,ptr2,y2)\
	ldy #y2 ;\
	lda tmp1 ;\
	sta ptr2,y ;\

#define CWB_ID(ptr1,y1,tmp2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp2 ;\

#define CWB_II(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	sta ptr2,y ;\

#define MOVW_DD(tmp1,tmp2)\
	lda tmp1 ;\
	sta tmp2 ;\
	lda tmp1+1 ;\
	sta tmp2+1 ;\

#define MOVW_DI(tmp1,ptr2,y2)\
	ldy #y2 ;\
	lda tmp1 ;\
	sta ptr2,y ;\
	iny ;\
	lda tmp1+1 ;\
	sta ptr2,y ;\

#define MOVW_ID(ptr1,y1,tmp2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp2 ;\
	iny ;\
	lda ptr1,y ;\
	sta tmp2+1 ;\

#define MOVW_II(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	sta ptr2,y ;\

#define MOVW_CD(cte1,tmp2)\
	lda #<(cte1) ;\
	sta tmp2 ;\
	lda #>(cte1) ;\
	sta tmp2+1 ;\

#define MOVW_CI(cte1,ptr2,y2)\
	ldy #y2 ;\
	lda #<(cte1) ;\
	sta ptr2,y ;\
	iny ;\
	lda #>(cte1)+1 ;\
	sta ptr2,y ;\

#define MOVW_AD(ptr1,y1,tmp2)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	sta tmp2 ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta tmp2+1 ;\

#define MOVW_AI(ptr1,y1,ptr2,y2)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	iny ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta ptr2,y ;\

#define CSBW_CD(cte1,tmp2)\
	lda #0 ;\
	ldx #cte1 ;\
	stx tmp2 ;\
	.( ;\
	bpl skip ;\
	lda #$FF ;\
skip ;\
	.)		;\
	sta tmp2+1 ;\

#define CSBW_CI(cte1,ptr2,y2)\
	ldy #y2 ;\
	ldx #0 ;\
	lda #cte1 ;\
	sta ptr2,y ;\
	.( ;\
	bpl skip ;\
	ldx #$FF ;\
skip ;\
	.)		;\
	txa ;\
	iny ;\
	sta ptr2,y ;\

#define CSBW_DD(tmp1,tmp2)\
	lda #0 ;\
	ldx tmp1 ;\
	stx tmp2 ;\
	.( ;\
	bpl skip ;\
	lda #$FF ;\
skip ;\
	.)		;\
	sta tmp2+1 ;\

#define CSBW_DI(tmp1,ptr2,y2)\
	ldy #y2 ;\
	ldx #0 ;\
	lda tmp1 ;\
	sta ptr2,y ;\
	.( ;\
	bpl skip ;\
	ldx #$FF ;\
skip ;\
	.)		;\
	txa ;\
	iny ;\
	sta ptr2,y ;\

#define CSBW_ID(ptr1,y1,tmp2)\
	ldy #y1 ;\
	ldx #0 ;\
	lda ptr1,y ;\
	sta tmp2 ;\
	.( ;\
	bpl skip ;\
	ldx #$FF ;\
skip ;\
	.)		;\
	txa ;\
	sta tmp2+1 ;\

#define CSBW_II(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	ldx #0 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	.( ;\
	bpl skip ;\
	ldx #$FF ;\
skip ;\
	.)		;\
	txa ;\
	iny ;\
	sta ptr2,y ;\

#define INDIRB_CD(var1,tmp2)\
	lda var1 ;\
	sta tmp2 ;\

#define INDIRB_ZD(ptr1,tmp2)\
	ldy #0 ;\
	lda (ptr1),y ;\
	sta tmp2 ;\

#define INDIRB_DD(var1,tmp2)\
	ldx var1 ;\
	lda var1+1 ;\
	stx tmp ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda (tmp),y ;\
	sta tmp2 ;\

#define INDIRB_AD(ptr1,y1,tmp2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp2 ;\

#define INDIRB_ID(ptr1,y1,tmp2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda (tmp),y ;\
	sta tmp2 ;\

#define INDIRB_CI(var1,ptr2,y2)\
	ldy #y2 ;\
	lda var1 ;\
	sta ptr2,y ;\

#define INDIRB_ZI(ptr1,ptr2,y2)\
	ldy #0 ;\
	lda (ptr1),y ;\
	ldy #y2 ;\
	sta ptr2,y ;\

#define INDIRB_DI(var1,ptr2,y2)\
	ldx var1 ;\
	lda var1+1 ;\
	stx tmp ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda (tmp),y ;\
	ldy #y2 ;\
	sta ptr2,y ;\

#define INDIRB_AI(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	sta ptr2,y ;\

#define INDIRB_II(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda (tmp),y ;\
	ldy #y2 ;\
	sta ptr2,y ;\

#define INDIRW_CD(var1,tmp2)\
	lda var1 ;\
	sta tmp2 ;\
	lda var1+1 ;\
	sta tmp2+1 ;\

#define INDIRW_ZD(ptr1,tmp2)\
	ldy #0 ;\
	lda (ptr1),y ;\
	tax ;\
	iny ;\
	lda (ptr1),y ;\
	stx tmp2 ;\
	sta tmp2+1 ;\

#define INDIRW_DD(var1,tmp2)\
	ldx var1 ;\
	lda var1+1 ;\
	stx tmp ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda (tmp),y ;\
	sta tmp2 ;\
	iny ;\
	lda (tmp),y ;\
	sta tmp2+1 ;\

#define INDIRW_AD(ptr1,y1,tmp2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp2 ;\
	iny ;\
	lda ptr1,y ;\
	sta tmp2+1 ;\

#define INDIRW_ID(ptr1,y1,tmp2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda (tmp),y ;\
	sta tmp2 ;\
	iny ;\
	lda (tmp),y ;\
	sta tmp2+1 ;\

#define INDIRW_CI(var1,ptr2,y2)\
	ldy #y2 ;\
	lda var1 ;\
	sta ptr2,y ;\
	iny ;\
	lda var1+1 ;\
	sta ptr2,y ;\

#define INDIRW_ZI(ptr1,ptr2,y2)\
	ldy #0 ;\
	lda (ptr1),y ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	ldy #1 ;\
	lda (ptr1),y ;\
	ldy #y2+1 ;\
	sta ptr2,y ;\

#define INDIRW_DI(var1,ptr2,y2)\
	ldx var1 ;\
	lda var1+1 ;\
	stx tmp ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda (tmp),y ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	ldy #1 ;\
	lda (tmp),y ;\
	ldy #y2+1 ;\
	sta ptr2,y ;\

#define INDIRW_AI(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	sta ptr2,y ;\

#define INDIRW_II(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda (tmp),y ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	ldy #1 ;\
	lda (tmp),y ;\
	ldy #y2+1 ;\
	sta ptr2,y ;\

#define INDIRS_CD(var1,tmp2)\
	lda #<(var1) ;\
	sta tmp2 ;\
	lda #>(var1) ;\
	sta tmp2+1 ;\

#define INDIRS_DD(var1,tmp2)\
	lda var1 ;\
	sta tmp2 ;\
	lda var1+1 ;\
	sta tmp2+1 ;\

#define NEGI_DD(tmp1,tmp2)\
	lda #0 ;\
	sec ;\
	sbc tmp1 ;\
	sta tmp2 ;\
	lda #0 ;\
	sbc tmp1+1 ;\
	sta tmp2+1 ;\

#define NEGI_DI(tmp1,ptr2,y2)\
	ldy #y2 ;\
	lda #0 ;\
	sec ;\
	sbc tmp1 ;\
	sta ptr2,y ;\
	iny ;\
	lda #0 ;\
	sbc tmp1+1 ;\
	sta ptr2,y ;\

#define NEGI_ID(ptr1,y1,tmp2)\
	ldy #y1 ;\
	lda #0 ;\
	sec ;\
	sbc ptr1,y ;\
	sta tmp2 ;\
	iny ;\
	lda #0 ;\
	sbc ptr1,y ;\
	sta tmp2+1 ;\

#define NEGI_II(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda #0 ;\
	sec ;\
	sbc ptr1,y ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	ldy #y1+1 ;\
	lda #0 ;\
	sbc ptr1,y ;\
	ldy #y2+1 ;\
	sta ptr2,y ;\

/* 16 bits increment - Zero page variant */
#define INCW_Z(tmp1)\
	inc tmp1 ;\
	.( ;\
	bne skip ;\
	inc tmp1+1 ;\
skip ;\
	.)		;\

/* 16 bits increment - Memory variant */
#define INCW_D(var1)\
	inc var1 ;\
	.( ;\
	bne skip ;\
	inc var1+1 ;\
skip ;\
	.)		;\

/* 16 bits decrement - Zero page variant */
#define DECW_Z(tmp1)\
	lda tmp1 ;\
	.( ;\
	bne skip ;\
	dec tmp1+1 ;\
skip ;\
	.)		;\
	dec tmp1 ;\

/* 16 bits decrement - Memory variant */
#define DECW_D(var1)\
	lda var1 ;\
	.( ;\
	bne skip ;\
	dec var1+1 ;\
skip ;\
	.)		;\
	dec var1 ;\

#define ADDW_DDD(tmp1,tmp2,tmp3)\
	clc ;\
	lda tmp1 ;\
	adc tmp2 ;\
	sta tmp3 ;\
	lda tmp1+1 ;\
	adc tmp2+1 ;\
	sta tmp3+1 ;\

#define ADDW_IDD(ptr1,y1,tmp2,tmp3)\
	clc ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	adc tmp2 ;\
	sta tmp3 ;\
	iny ;\
	lda ptr1,y ;\
	adc tmp2+1 ;\
	sta tmp3+1 ;\

#define ADDW_DID(tmp1,ptr2,y2,tmp3)\
	clc ;\
	lda tmp1 ;\
	ldy #y2 ;\
	adc ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda tmp1+1 ;\
	adc ptr2,y ;\
	sta tmp3+1 ;\

#define ADDW_IID(ptr1,y1,ptr2,y2,tmp3)\
	clc ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	adc ptr2,y ;\
	sta tmp3 ;\
	lda #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	adc ptr2,y ;\
	sta tmp3+1 ;\

#define ADDW_DDI(tmp1,tmp2,ptr3,y3)\
	clc ;\
	lda tmp1 ;\
	adc tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	iny ;\
	lda tmp1+1 ;\
	adc tmp2+1 ;\
	sta ptr3,y ;\

#define ADDW_IDI(ptr1,y1,tmp2,ptr3,y3)\
	clc ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	adc tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	adc tmp2+1 ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define ADDW_DII(tmp1,ptr2,y2,ptr3,y3)\
	clc ;\
	lda tmp1 ;\
	ldy #y2 ;\
	adc ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda tmp1+1 ;\
	ldy #y2+1 ;\
	adc ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define ADDW_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	clc ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	adc ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	adc ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define ADDW_DCD(tmp2,cte1,tmp3)\
	clc ;\
	lda #<(cte1) ;\
	adc tmp2 ;\
	sta tmp3 ;\
	lda #>(cte1) ;\
	adc tmp2+1 ;\
	sta tmp3+1 ;\

#define ADDW_DAD(tmp2,ptr1,y1,tmp3)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta tmp+1 ;\
	txa ;\
	adc tmp2 ;\
	sta tmp3 ;\
	lda tmp+1 ;\
	adc tmp2+1 ;\
	sta tmp3+1 ;\

#define ADDW_ICD(ptr2,y2,cte1,tmp3)\
	clc ;\
	lda #<(cte1) ;\
	ldy #y2 ;\
	adc ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda #>(cte1) ;\
	adc ptr2,y ;\
	sta tmp3+1 ;\

#define ADDW_IAD(ptr2,y2,ptr1,y1,tmp3)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta tmp+1 ;\
	txa ;\
	ldy #y2 ;\
	adc ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda tmp+1 ;\
	adc ptr2,y ;\
	sta tmp3+1 ;\

#define ADDW_DCI(tmp2,cte1,ptr3,y3)\
	clc ;\
	lda #<(cte1) ;\
	adc tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	iny ;\
	lda #>(cte1) ;\
	adc tmp2+1 ;\
	sta ptr3,y ;\

#define ADDW_DAI(tmp2,ptr1,y1,ptr3,y3)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta tmp+1 ;\
	txa ;\
	adc tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	iny ;\
	lda tmp+1 ;\
	adc tmp2+1 ;\
	sta ptr3,y ;\

#define ADDW_ICI(ptr2,y2,cte1,ptr3,y3)\
	clc ;\
	lda #<(cte1) ;\
	ldy #y2 ;\
	adc ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda #>(cte1) ;\
	ldy #y2+1 ;\
	adc ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define ADDW_IAI(ptr2,y2,ptr1,y1,ptr3,y3)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta tmp+1 ;\
	txa ;\
	ldy #y2 ;\
	adc ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda tmp+1 ;\
	ldy #y2+1 ;\
	adc ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define SUBW_DCD(tmp1,cte2,tmp3)\
	sec ;\
	lda tmp1 ;\
	sbc #<(cte2) ;\
	sta tmp3 ;\
	lda tmp1+1 ;\
	sbc #>(cte2) ;\
	sta tmp3+1 ;\

#define SUBW_CDD(cte1,tmp2,tmp3)\
	sec ;\
	lda #<(cte1) ;\
	sbc tmp2 ;\
	sta tmp3 ;\
	lda #>(cte1) ;\
	sbc tmp2+1 ;\
	sta tmp3+1 ;\

#define SUBW_ADD(ptr1,y1,tmp2,tmp3)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta tmp+1 ;\
	sec ;\
	txa ;\
	sbc tmp2 ;\
	sta tmp3 ;\
	lda tmp+1 ;\
	sbc tmp2+1 ;\
	sta tmp3+1 ;\

#define SUBW_ICD(ptr1,y1,cte2,tmp3)\
	sec ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sbc #<(cte2) ;\
	sta tmp3 ;\
	iny ;\
	lda ptr1,y ;\
	sbc #>(cte2) ;\
	sta tmp3+1 ;\

#define SUBW_CID(cte1,ptr2,y2,tmp3)\
	sec ;\
	ldy #y2 ;\
	lda #<(cte1) ;\
	sbc ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda #>(cte1) ;\
	sbc ptr2,y ;\
	sta tmp3+1 ;\

#define SUBW_AID(ptr1,y1,ptr2,y2,tmp3)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta tmp+1 ;\
	sec ;\
	ldy #y2 ;\
	txa ;\
	sbc ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda tmp+1 ;\
	sbc ptr2,y ;\
	sta tmp3+1 ;\

#define SUBW_DCI(tmp1,cte2,ptr3,y3)\
	sec ;\
	ldy #y3 ;\
	lda tmp1 ;\
	sbc #<(cte2) ;\
	sta ptr3,y ;\
	iny ;\
	lda tmp1+1 ;\
	sbc #>(cte2) ;\
	sta ptr3,y ;\

#define SUBW_CDI(cte1,tmp2,ptr3,y3)\
	sec ;\
	ldy #y3 ;\
	lda #<(cte1) ;\
	sbc tmp2 ;\
	sta ptr3,y ;\
	iny ;\
	lda #>(cte1) ;\
	sbc tmp2+1 ;\
	sta ptr3,y ;\

#define SUBW_ADI(ptr1,y1,tmp2,ptr3,y3)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta tmp+1 ;\
	sec ;\
	ldy #y3 ;\
	txa ;\
	sbc tmp2 ;\
	sta ptr3,y ;\
	iny ;\
	lda tmp+1 ;\
	sbc tmp2+1 ;\
	sta ptr3,y ;\

#define SUBW_ICI(ptr1,y1,cte2,ptr3,y3)\
	sec ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sbc #<(cte2) ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	sbc #>(cte2) ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define SUBW_CII(cte1,ptr2,y2,ptr3,y3)\
	sec ;\
	lda #<(cte1) ;\
	ldy #y2 ;\
	sbc ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda #>(cte1) ;\
	ldy #y2+1 ;\
	sbc ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define SUBW_AII(ptr1,y1,ptr2,y2,ptr3,y3)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta tmp+1 ;\
	sec ;\
	txa ;\
	ldy #y2 ;\
	sbc ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda tmp+1 ;\
	ldy #y2+1 ;\
	sbc ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define SUBW_DDD(tmp1,tmp2,tmp3)\
	sec ;\
	lda tmp1 ;\
	sbc tmp2 ;\
	sta tmp3 ;\
	lda tmp1+1 ;\
	sbc tmp2+1 ;\
	sta tmp3+1 ;\

#define SUBW_IDD(ptr1,y1,tmp2,tmp3)\
	sec ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sbc tmp2 ;\
	sta tmp3 ;\
	iny ;\
	lda ptr1,y ;\
	sbc tmp2+1 ;\
	sta tmp3+1 ;\

#define SUBW_DID(tmp1,ptr2,y2,tmp3)\
	sec ;\
	lda tmp1 ;\
	ldy #y2 ;\
	sbc ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda tmp1+1 ;\
	sbc ptr2,y ;\
	sta tmp3+1 ;\

#define SUBW_IID(ptr1,y1,ptr2,y2,tmp3)\
	sec ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	sbc ptr2,y ;\
	sta tmp3 ;\
	lda #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	sbc ptr2,y ;\
	sta tmp3+1 ;\

#define SUBW_DDI(tmp1,tmp2,ptr3,y3)\
	sec ;\
	lda tmp1 ;\
	sbc tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	iny ;\
	lda tmp1+1 ;\
	sbc tmp2+1 ;\
	sta ptr3,y ;\

#define SUBW_IDI(ptr1,y1,tmp2,ptr3,y3)\
	sec ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sbc tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	sbc tmp2+1 ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define SUBW_DII(tmp1,ptr2,y2,ptr3,y3)\
	sec ;\
	lda tmp1 ;\
	ldy #y2 ;\
	sbc ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda tmp1+1 ;\
	ldy #y2+1 ;\
	sbc ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define SUBW_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	sec ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	sbc ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	sbc ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3+1 ;\

#define COMW_DD(tmp1,tmp2)\
	lda tmp1 ;\
	eor #$FF ;\
	sta tmp2 ;\
	lda tmp1+1 ;\
	eor #$FF ;\
	sta tmp2+1 ;\

#define COMW_DI(tmp1,ptr2,y2)\
	ldy #y2 ;\
	lda tmp1 ;\
	eor #$FF ;\
	sta ptr2,y ;\
	iny ;\
	lda tmp1+1 ;\
	eor #$FF ;\
	sta ptr2,y ;\

#define COMW_ID(ptr1,y1,tmp2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	eor #$FF ;\
	sta tmp2 ;\
	iny ;\
	lda ptr1,y ;\
	eor #$FF ;\
	sta tmp2+1 ;\

#define COMW_II(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	eor #$FF ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	eor #$FF ;\
	ldy #y2+1 ;\
	sta ptr2+1 ;\

#define ANDW_DDD(tmp1,tmp2,tmp3)\
	lda tmp1 ;\
	and tmp2 ;\
	sta tmp3 ;\
	lda tmp1+1 ;\
	and tmp2+1 ;\
	sta tmp3+1 ;\

#define ANDW_IDD(ptr1,y1,tmp2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	and tmp2 ;\
	sta tmp3 ;\
	iny ;\
	lda ptr1,y ;\
	and tmp2+1 ;\
	sta tmp3+1 ;\

#define ANDW_DID(tmp1,ptr2,y2,tmp3)\
	lda tmp1 ;\
	ldy #y2 ;\
	and ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda tmp1+1 ;\
	and ptr2,y ;\
	sta tmp3+1 ;\

#define ANDW_IID(ptr1,y1,ptr2,y2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	and ptr2,y ;\
	sta tmp3 ;\
	lda #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	and ptr2,y ;\
	sta tmp3+1 ;\

#define ANDW_DDI(tmp1,tmp2,ptr3,y3)\
	lda tmp1 ;\
	and tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	iny ;\
	lda tmp1+1 ;\
	and tmp2+1 ;\
	sta ptr3,y ;\

#define ANDW_IDI(ptr1,y1,tmp2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	and tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	and tmp2+1 ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define ANDW_DII(tmp1,ptr2,y2,ptr3,y3)\
	lda tmp1 ;\
	ldy #y2 ;\
	and ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda tmp1+1 ;\
	ldy #y2+1 ;\
	and ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define ANDW_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	and ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	and ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3+1 ;\

#define ANDW_DCD(tmp2,cte1,tmp3)\
	lda #<(cte1) ;\
	and tmp2 ;\
	sta tmp3 ;\
	lda #>(cte1) ;\
	and tmp2+1 ;\
	sta tmp3+1 ;\

#define ANDW_ICD(ptr2,y2,cte1,tmp3)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	and ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda #>(cte1) ;\
	and ptr2,y ;\
	sta tmp3+1 ;\

#define ANDW_DCI(tmp2,cte1,ptr3,y3)\
	lda #<(cte1) ;\
	and tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	iny ;\
	lda #>(cte1) ;\
	and tmp2+1 ;\
	sta ptr3,y ;\

#define ANDW_ICI(ptr2,y2,cte1,ptr3,y3)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	and ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda #>(cte1) ;\
	ldy #y2+1 ;\
	and ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define XORW_DDD(tmp1,tmp2,tmp3)\
	lda tmp1 ;\
	eor tmp2 ;\
	sta tmp3 ;\
	lda tmp1+1 ;\
	eor tmp2+1 ;\
	sta tmp3+1 ;\

#define XORW_IDD(ptr1,y1,tmp2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	eor tmp2 ;\
	sta tmp3 ;\
	iny ;\
	lda ptr1,y ;\
	eor tmp2+1 ;\
	sta tmp3+1 ;\

#define XORW_DID(tmp1,ptr2,y2,tmp3)\
	lda tmp1 ;\
	ldy #y2 ;\
	eor ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda tmp1+1 ;\
	eor ptr2,y ;\
	sta tmp3+1 ;\

#define XORW_IID(ptr1,y1,ptr2,y2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	eor ptr2,y ;\
	sta tmp3 ;\
	lda #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	eor ptr2,y ;\
	sta tmp3+1 ;\

#define XORW_DDI(tmp1,tmp2,ptr3,y3)\
	lda tmp1 ;\
	eor tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	iny ;\
	lda tmp1+1 ;\
	eor tmp2+1 ;\
	sta ptr3,y ;\

#define XORW_IDI(ptr1,y1,tmp2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	eor tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	eor tmp2+1 ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define XORW_DII(tmp1,ptr2,y2,ptr3,y3)\
	lda tmp1 ;\
	ldy #y2 ;\
	eor ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda tmp1+1 ;\
	ldy #y2+1 ;\
	eor ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define XORW_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	eor ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	eor ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3+1 ;\

#define XORW_DCD(tmp2,cte1,tmp3)\
	lda #<(cte1) ;\
	eor tmp2 ;\
	sta tmp3 ;\
	lda #>(cte1) ;\
	eor tmp2+1 ;\
	sta tmp3+1 ;\

#define XORW_ICD(ptr2,y2,cte1,tmp3)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	eor ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda #>(cte1) ;\
	eor ptr2,y ;\
	sta tmp3+1 ;\

#define XORW_DCI(tmp2,cte1,ptr3,y3)\
	lda #<(cte1) ;\
	eor tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	iny ;\
	lda #>(cte1) ;\
	eor tmp2+1 ;\
	sta ptr3,y ;\

#define XORW_ICI(ptr2,y2,cte1,ptr3,y3)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	eor ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda #>(cte1) ;\
	ldy #y2+1 ;\
	eor ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define ORW_DDD(tmp1,tmp2,tmp3)\
	lda tmp1 ;\
	ora tmp2 ;\
	sta tmp3 ;\
	lda tmp1+1 ;\
	ora tmp2+1 ;\
	sta tmp3+1 ;\

#define ORW_IDD(ptr1,y1,tmp2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ora tmp2 ;\
	sta tmp3 ;\
	iny ;\
	lda ptr1,y ;\
	ora tmp2+1 ;\
	sta tmp3+1 ;\

#define ORW_DID(tmp1,ptr2,y2,tmp3)\
	lda tmp1 ;\
	ldy #y2 ;\
	ora ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda tmp1+1 ;\
	ora ptr2,y ;\
	sta tmp3+1 ;\

#define ORW_IID(ptr1,y1,ptr2,y2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	ora ptr2,y ;\
	sta tmp3 ;\
	lda #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	ora ptr2,y ;\
	sta tmp3+1 ;\

#define ORW_DDI(tmp1,tmp2,ptr3,y3)\
	lda tmp1 ;\
	ora tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	iny ;\
	lda tmp1+1 ;\
	ora tmp2+1 ;\
	sta ptr3,y ;\

#define ORW_IDI(ptr1,y1,tmp2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ora tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ora tmp2+1 ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define ORW_DII(tmp1,ptr2,y2,ptr3,y3)\
	lda tmp1 ;\
	ldy #y2 ;\
	ora ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda tmp1+1 ;\
	ldy #y2+1 ;\
	ora ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define ORW_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	ora ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	ora ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3+1 ;\

#define ORW_DCD(tmp2,cte1,tmp3)\
	lda #<(cte1) ;\
	ora tmp2 ;\
	sta tmp3 ;\
	lda #>(cte1) ;\
	ora tmp2+1 ;\
	sta tmp3+1 ;\

#define ORW_ICD(ptr2,y2,cte1,tmp3)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	ora ptr2,y ;\
	sta tmp3 ;\
	iny ;\
	lda #>(cte1) ;\
	ora ptr2,y ;\
	sta tmp3+1 ;\

#define ORW_DCI(tmp2,cte1,ptr3,y3)\
	lda #<(cte1) ;\
	ora tmp2 ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	iny ;\
	lda #>(cte1) ;\
	ora tmp2+1 ;\
	sta ptr3,y ;\

#define ORW_ICI(ptr2,y2,cte1,ptr3,y3)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	ora ptr2,y ;\
	ldy #y3 ;\
	sta ptr3,y ;\
	lda #>(cte1) ;\
	ldy #y2+1 ;\
	ora ptr2,y ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\

#define DIVI_DDD(tmp1,tmp2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVI_IDD(ptr1,y1,tmp2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVI_DID(tmp1,ptr2,y2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVI_IID(ptr1,y1,ptr2,y2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVI_DDI(tmp1,tmp2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVI_IDI(ptr1,y1,tmp2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVI_DII(tmp1,ptr2,y2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVI_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVI_CDD(cte1,tmp2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVI_CID(cte1,ptr2,y2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVI_CDI(cte1,tmp2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVI_CII(cte1,ptr2,y2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVI_DCD(tmp1,cte2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr div16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVI_ICD(ptr1,y1,cte2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr div16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVI_DCI(tmp1,cte2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr div16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVI_ICI(ptr1,y1,cte2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr div16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVU_DDD(tmp1,tmp2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVU_IDD(ptr1,y1,tmp2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVU_DID(tmp1,ptr2,y2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVU_IID(ptr1,y1,ptr2,y2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVU_DDI(tmp1,tmp2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVU_IDI(ptr1,y1,tmp2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVU_DII(tmp1,ptr2,y2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVU_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVU_CDD(cte1,tmp2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVU_CID(cte1,ptr2,y2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVU_CDI(cte1,tmp2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr div16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVU_CII(cte1,ptr2,y2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr div16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVU_DCD(tmp1,cte2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr div16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVU_ICD(ptr1,y1,cte2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr div16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define DIVU_DCI(tmp1,cte2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr div16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define DIVU_ICI(ptr1,y1,cte2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr div16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODU_DDD(tmp1,tmp2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODU_IDD(ptr1,y1,tmp2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODU_DID(tmp1,ptr2,y2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODU_IID(ptr1,y1,ptr2,y2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODU_DDI(tmp1,tmp2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODU_IDI(ptr1,y1,tmp2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODU_DII(tmp1,ptr2,y2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODU_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODU_CDD(cte1,tmp2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODU_CID(cte1,ptr2,y2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODU_CDI(cte1,tmp2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODU_CII(cte1,ptr2,y2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODU_DCD(tmp1,cte2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mod16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODU_ICD(ptr1,y1,cte2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mod16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODU_DCI(tmp1,cte2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mod16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODU_ICI(ptr1,y1,cte2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mod16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODI_DDD(tmp1,tmp2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODI_IDD(ptr1,y1,tmp2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODI_DID(tmp1,ptr2,y2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODI_IID(ptr1,y1,ptr2,y2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODI_DDI(tmp1,tmp2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODI_IDI(ptr1,y1,tmp2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODI_DII(tmp1,ptr2,y2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODI_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODI_CDD(cte1,tmp2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODI_CID(cte1,ptr2,y2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODI_CDI(cte1,tmp2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mod16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODI_CII(cte1,ptr2,y2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mod16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODI_DCD(tmp1,cte2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mod16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODI_ICD(ptr1,y1,cte2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mod16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MODI_DCI(tmp1,cte2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mod16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MODI_ICI(ptr1,y1,cte2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mod16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULU_DDD(tmp1,tmp2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULU_IDD(ptr1,y1,tmp2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULU_DID(tmp1,ptr2,y2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULU_IID(ptr1,y1,ptr2,y2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULU_DDI(tmp1,tmp2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULU_IDI(ptr1,y1,tmp2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULU_DII(tmp1,ptr2,y2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULU_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULU_CDD(cte1,tmp2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULU_CID(cte1,ptr2,y2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULU_CDI(cte1,tmp2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULU_CII(cte1,ptr2,y2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULU_DCD(tmp1,cte2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mul16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULU_ICD(ptr1,y1,cte2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mul16u ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULU_DCI(tmp1,cte2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mul16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULU_ICI(ptr1,y1,cte2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mul16u ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULI_DDD(tmp1,tmp2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULI_IDD(ptr1,y1,tmp2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULI_DID(tmp1,ptr2,y2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULI_IID(ptr1,y1,ptr2,y2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULI_DDI(tmp1,tmp2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULI_IDI(ptr1,y1,tmp2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULI_DII(tmp1,ptr2,y2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULI_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULI_CDD(cte1,tmp2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULI_CID(cte1,ptr2,y2,tmp3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULI_CDI(cte1,tmp2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	lda tmp2 ;\
	sta op2 ;\
	lda tmp2+1 ;\
	sta op2+1 ;\
	jsr mul16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULI_CII(cte1,ptr2,y2,ptr3,y3)\
	lda #<(cte1) ;\
	sta op1 ;\
	lda #>(cte1) ;\
	sta op1+1 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta op2 ;\
	iny ;\
	lda ptr2,y ;\
	sta op2+1 ;\
	jsr mul16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULI_DCD(tmp1,cte2,tmp3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mul16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULI_ICD(ptr1,y1,cte2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mul16i ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define MULI_DCI(tmp1,cte2,ptr3,y3)\
	lda tmp1 ;\
	sta op1 ;\
	lda tmp1+1 ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mul16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define MULI_ICI(ptr1,y1,cte2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta op1 ;\
	iny ;\
	lda ptr1,y ;\
	sta op1+1 ;\
	lda #<(cte2) ;\
	sta op2 ;\
	lda #>(cte2) ;\
	sta op2+1 ;\
	jsr mul16i ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define LSH1W_DD(tmp1,tmp2)\
	lda tmp1 ;\
	asl ;\
	sta tmp2 ;\
	lda tmp1+1 ;\
	rol ;\
	sta tmp2+1 ;\

#define LSH1W_ID(ptr1,y1,tmp2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	asl ;\
	sta tmp2 ;\
	iny ;\
	lda ptr1,y ;\
	rol ;\
	sta tmp2+1 ;\

#define LSH1W_DI(tmp1,ptr2,y2)\
	ldy #y2 ;\
	lda tmp1 ;\
	asl ;\
	sta ptr2,y ;\
	iny ;\
	lda tmp1+1 ;\
	rol ;\
	sta ptr2,y ;\

#define LSH1W_II(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	asl ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	rol ;\
	ldy #y2+1 ;\
	sta ptr2,y ;\

#define LSHW\
	beq *+8 ;\
	asl tmp ;\
	rol ;\
	dex ;\
	bne *-4 ;\
	ldx tmp ;\

#define LSHW_DDD(tmp1,tmp2,tmp3)\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	ldx tmp2 ;\
	LSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define LSHW_DCD(tmp1,cte2,tmp3)\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	ldx #cte2 ;\
	LSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define LSHW_DID(tmp1,ptr2,y2,tmp3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	LSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define LSHW_CDD(cte1,tmp2,tmp3)\
	lda #<(cte1) ;\
	sta tmp ;\
	lda #>(cte1) ;\
	ldx tmp2 ;\
	LSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define LSHW_CID(cte1,ptr2,y2,tmp3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	lda #<(cte1) ;\
	sta tmp ;\
	lda #>(cte1)+1 ;\
	LSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define LSHW_IDD(ptr1,y1,tmp2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	ldx tmp2 ;\
	LSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define LSHW_ICD(ptr1,y1,cte2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	ldx #cte2 ;\
	LSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define LSHW_IID(ptr1,y1,ptr2,y2,tmp3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	LSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define LSHW_DDI(tmp1,tmp2,ptr3,y3)\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	ldx tmp2 ;\
	LSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define LSHW_DCI(tmp1,cte2,ptr3,y3)\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	ldx #cte2 ;\
	LSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define LSHW_DII(tmp1,ptr2,y2,ptr3,y3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	LSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define LSHW_CDI(cte1,tmp2,ptr3,y3)\
	lda #<(cte1) ;\
	sta tmp ;\
	lda #>(cte1) ;\
	ldx tmp2 ;\
	LSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define LSHW_CII(cte1,ptr2,y2,ptr3,y3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	lda #<(cte1) ;\
	sta tmp ;\
	lda #>(cte1)+1 ;\
	LSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define LSHW_IDI(ptr1,y1,tmp2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	ldx tmp2 ;\
	LSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define LSHW_ICI(ptr1,y1,cte2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	ldx #cte2 ;\
	LSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define LSHW_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	LSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define RSHW\
	beq *+8 ;\
	lsr ;\
	ror tmp ;\
	dex ;\
	bne *-4 ;\
	ldx tmp ;\

#define RSHW_DDD(tmp1,tmp2,tmp3)\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	ldx tmp2 ;\
	RSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define RSHW_DCD(tmp1,cte2,tmp3)\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	ldx #cte2 ;\
	RSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define RSHW_DID(tmp1,ptr2,y2,tmp3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	RSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define RSHW_CDD(cte1,tmp2,tmp3)\
	lda #<(cte1) ;\
	sta tmp ;\
	lda #>(cte1) ;\
	ldx tmp2 ;\
	RSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define RSHW_CID(cte1,ptr2,y2,tmp3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	lda #<(cte1) ;\
	sta tmp ;\
	lda #>(cte1)+1 ;\
	RSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define RSHW_IDD(ptr1,y1,tmp2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	ldx tmp2 ;\
	RSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define RSHW_ICD(ptr1,y1,cte2,tmp3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	ldx #cte2 ;\
	RSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define RSHW_IID(ptr1,y1,ptr2,y2,tmp3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	RSHW ;\
	stx tmp3 ;\
	sta tmp3+1 ;\

#define RSHW_DDI(tmp1,tmp2,ptr3,y3)\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	ldx tmp2 ;\
	RSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define RSHW_DCI(tmp1,cte2,ptr3,y3)\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	ldx #cte2 ;\
	RSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define RSHW_DII(tmp1,ptr2,y2,ptr3,y3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	lda tmp1 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	RSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define RSHW_CDI(cte1,tmp2,ptr3,y3)\
	lda #<(cte1) ;\
	sta tmp ;\
	lda #>(cte1) ;\
	ldx tmp2 ;\
	RSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define RSHW_CII(cte1,ptr2,y2,ptr3,y3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	lda #<(cte1) ;\
	sta tmp ;\
	lda #>(cte1)+1 ;\
	RSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define RSHW_IDI(ptr1,y1,tmp2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	ldx tmp2 ;\
	RSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define RSHW_ICI(ptr1,y1,cte2,ptr3,y3)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	ldx #cte2 ;\
	RSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define RSHW_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	ldy #y2 ;\
	lda ptr2,y ;\
	tax ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	RSHW ;\
	ldy #y3+1 ;\
	sta ptr3,y ;\
	dey ;\
	txa ;\
	sta ptr3,y ;\

#define ASGNB_CC(cte1,var2)\
	lda #<(cte1) ;\
	sta var2 ;\

#define ASGNB_CZ(cte1,ptr2)\
	ldy #0 ;\
	lda #<(cte1) ;\
	sta (ptr2),y ;\

#define ASGNB_CD(cte1,var2)\
	lda var2 ;\
	sta tmp ;\
	lda var2+1 ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda #<(cte1) ;\
	sta (tmp),y ;\

#define ASGNB_CA(cte1,ptr2,y2)\
	ldy #y2 ;\
	lda #<(cte1) ;\
	sta ptr2,y ;\

#define ASGNB_CI(cte1,ptr2,y2)\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta tmp ;\
	iny ;\
	lda ptr2,y ;\
	sta tmp+1 ;\
	lda #<(cte1) ;\
	ldy #0 ;\
	sta (tmp),y ;\

#define ASGNB_DC(tmp1,var2)\
	lda tmp1 ;\
	sta var2 ;\

#define ASGNB_DZ(tmp1,ptr2)\
	ldy #0 ;\
	lda tmp1 ;\
	sta (ptr2),y ;\

#define ASGNB_DD(tmp1,var2)\
	lda var2 ;\
	sta tmp ;\
	lda var2+1 ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda tmp1 ;\
	sta (tmp),y ;\

#define ASGNB_DA(tmp1,ptr2,y2)\
	ldy #y2 ;\
	lda tmp1 ;\
	sta ptr2,y ;\

#define ASGNB_DI(tmp1,ptr2,y2)\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta tmp ;\
	iny ;\
	lda ptr2,y ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda tmp1 ;\
	sta (tmp),y ;\

#define ASGNB_IC(ptr1,y1,var2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta var2 ;\

#define ASGNB_IZ(ptr1,y1,ptr2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #0 ;\
	sta (ptr2),y ;\

#define ASGNB_ID(ptr1,y1,var2)\
	lda var2 ;\
	sta tmp ;\
	lda var2+1 ;\
	sta tmp+1 ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #0 ;\
	sta (tmp),y ;\

#define ASGNB_IA(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	sta ptr2,y ;\

#define ASGNB_II(ptr1,y1,ptr2,y2)\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta tmp ;\
	iny ;\
	lda ptr2,y ;\
	sta tmp+1 ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #0 ;\
	sta (tmp),y ;\

#define ASGNW_CC(cte1,var2)\
	lda #<(cte1) ;\
	sta var2 ;\
	lda #>(cte1) ;\
	sta var2+1 ;\

#define ASGNW_CZ(cte1,ptr2)\
	ldy #0 ;\
	lda #<(cte1) ;\
	sta (ptr2),y ;\
	iny ;\
	lda #>(cte1) ;\
	sta (ptr2),y ;\

#define ASGNW_CD(cte1,var2)\
	lda var2 ;\
	sta tmp ;\
	lda var2+1 ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda #<(cte1) ;\
	sta (tmp),y ;\
	iny ;\
	lda #>(cte1) ;\
	sta (tmp),y ;\

#define ASGNW_CA(cte1,ptr2,y2)\
	ldy #y2 ;\
	lda #<(cte1) ;\
	sta ptr2,y ;\
	iny ;\
	lda #>(cte1) ;\
	sta ptr2,y ;\

#define ASGNW_CI(cte1,ptr2,y2)\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta tmp ;\
	iny ;\
	lda ptr2,y ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda #<(cte1) ;\
	sta (tmp),y ;\
	iny ;\
	lda #>(cte1) ;\
	sta (tmp),y ;\

#define ASGNW_DC(tmp1,var2)\
	lda tmp1 ;\
	sta var2 ;\
	lda tmp1+1 ;\
	sta var2+1 ;\

#define ASGNW_DZ(tmp1,ptr2)\
	ldy #0 ;\
	lda tmp1 ;\
	sta (ptr2),y ;\
	iny ;\
	lda tmp1+1 ;\
	sta (ptr2),y ;\

#define ASGNW_DD(tmp1,var2)\
	lda var2 ;\
	sta tmp ;\
	lda var2+1 ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda tmp1 ;\
	sta (tmp),y ;\
	iny ;\
	lda tmp1+1 ;\
	sta (tmp),y ;\

#define ASGNW_DA(tmp1,ptr2,y2)\
	ldy #y2 ;\
	lda tmp1 ;\
	sta ptr2,y ;\
	iny ;\
	lda tmp1+1 ;\
	sta ptr2,y ;\

#define ASGNW_DI(tmp1,ptr2,y2)\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta tmp ;\
	iny ;\
	lda ptr2,y ;\
	sta tmp+1 ;\
	ldy #0 ;\
	lda tmp1 ;\
	sta (tmp),y ;\
	iny ;\
	lda tmp1+1 ;\
	sta (tmp),y ;\

#define ASGNW_AC(ptr1,y1,var2)\
        clc ;\
        lda 0+ptr1 ;\
        adc #y1 ;\
        sta var2 ;\
        lda 1+ptr1 ;\
        adc #0 ;\
	sta var2+1 ;\

#define ASGNW_AZ(ptr1,y1,ptr2)\
        clc ;\
        lda 0+ptr1 ;\
        adc #y1 ;\
	ldy #0 ;\
	sta (ptr2),y ;\
        iny ;\
        lda 1+ptr1 ;\
        adc #0 ;\
	sta (ptr2),y ;\

#define ASGNW_AD(ptr1,y1,var2)\
	lda var2 ;\
	sta tmp ;\
	lda var2+1 ;\
	sta tmp+1 ;\
        clc ;\
        lda 0+ptr1 ;\
        adc #y1 ;\
	ldy #0 ;\
	sta (tmp),y ;\
        iny ;\
        lda 1+ptr1 ;\
        adc #0 ;\
	sta (tmp),y ;\

#define ASGNW_AA(ptr1,y1,ptr2,y2)\
        clc ;\
        lda 0+ptr1 ;\
        adc #y1 ;\
        ldy #y2 ;\
	sta ptr2,y ;\
        iny ;\
        lda 1+ptr1 ;\
        adc #0 ;\
	sta ptr2,y ;\

#define ASGNW_AI(ptr1,y1,ptr2,y2)\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta tmp ;\
	iny ;\
	lda ptr2,y ;\
	sta tmp+1 ;\
        clc ;\
        lda 0+ptr1 ;\
        adc #y1 ;\
	ldy #0 ;\
	sta (tmp),y ;\
        iny ;\
        lda 1+ptr1 ;\
        adc #0 ;\
	sta (tmp),y ;\

#define ASGNW_IC(ptr1,y1,var2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta var2 ;\
	iny ;\
	lda ptr1,y ;\
	sta var2+1 ;\

#define ASGNW_IZ(ptr1,y1,ptr2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #0 ;\
	sta (ptr2),y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #1 ;\
	sta (ptr2),y ;\

#define ASGNW_ID(ptr1,y1,var2)\
	lda var2 ;\
	sta tmp ;\
	lda var2+1 ;\
	sta tmp+1 ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #0 ;\
	sta (tmp),y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #1 ;\
	sta (tmp),y ;\

#define ASGNW_IA(ptr1,y1,ptr2,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	sta ptr2,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	sta ptr2,y ;\

#define ASGNW_II(ptr1,y1,ptr2,y2)\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta tmp ;\
	iny ;\
	lda ptr2,y ;\
	sta tmp+1 ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #0 ;\
	sta (tmp),y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #1 ;\
	sta (tmp),y ;\

#define ASGNS_CC(adr1,adr2,length) \
	ldx #0 ;\
	lda adr1,x ;\
	sta adr2,x ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_DC(adr1,adr2,length) \
	ldx adr1 ;\
	lda adr1+1 ;\
	stx *+9 ;\
	sta *+7 ;\
	ldx #0 ;\
	lda $1234,x ;\
	sta adr2,x ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_AC(ptr1,y1,adr2,length) \
	ldx #0 ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta adr2,x ;\
	iny ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_IC(ptr1,y1,adr2,length) \
	ldy #y1 ;\
	lda ptr1,y ;\
	sta *+12 ;\
	iny ;\
	lda ptr1,y ;\
	sta *+7 ;\
	ldx #0 ;\
	lda $1234,x ;\
	sta adr2,x ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_CD(adr1,adr2,length) \
	ldx adr2 ;\
	lda adr2+1 ;\
	stx *+12 ;\
	sta *+10 ;\ 
	ldx #0 ;\
	lda adr1,x ;\
	sta $1234,x ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_DD(adr1,adr2,length) \
	ldy adr2 ;\
	lda adr2+1 ;\
	pha ;\
	ldx adr1 ;\
	lda adr1+1 ;\
	stx *+16 ;\
	sta *+14 ;\
	pla ;\
	sty *+12 ;\
	sta *+10 ;\
	ldx #0 ;\
	lda $1234,x ;\
	sta $5678,x ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_AD(ptr1,y1,adr2,length) \
	ldx adr2 ;\
	lda adr2+1 ;\
	stx *+13 ;\
	sta *+11 ;\
	ldx #0 ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta $1234,x ;\
	iny ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_ID(ptr1,y1,adr2,length) \
	ldx adr2 ;\
	lda adr2+1 ;\
	stx *+25 ;\
	sta *+23 ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta *+12 ;\
	iny ;\
	lda ptr1,y ;\
	sta *+7 ;\
	ldx #0 ;\
	lda $1234,x ;\
	sta $5678,x ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_CA(adr1,ptr2,y2,length)\
	ldx #0 ;\
	ldy #y2 ;\
	lda adr1,x ;\
	sta ptr2,y ;\
	inx ;\
	iny ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_DA(adr1,ptr2,y2,length) \
	ldx adr1 ;\
	lda adr1+1 ;\
	stx *+11 ;\
	sta *+9 ;\
	ldx #0 ;\
	ldy #y2 ;\
	lda $1234,x ;\
	sta ptr2,y ;\
	inx ;\
	iny ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_AA(ptr1,y1,ptr2,y2,length)\
	ldy #y1 ;\
	sty tmp ;\
	ldy #y2 ;\
	sty tmp+1 ;\
	ldx #length ;\
	ldy tmp ;\
	lda ptr1,y ;\
	iny ;\
	sty tmp ;\
	ldy tmp+1 ;\
	sta ptr2,y ;\
	iny ;\
	sty tmp+1 ;\
	dex ;\
	bne *-15 ;\

#define ASGNS_IA(ptr1,y1,ptr2,y2,length)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta *+14 ;\
	iny ;\
	lda ptr1,y ;\
	sta *+9 ;\
	ldx #0 ;\
	ldy #y2 ;\
	lda $1234,x ;\
	sta ptr2,y ;\
	inx ;\
	iny ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_CI(adr1,ptr2,y2,length) \
	ldy #y2 ;\
	lda ptr2,y ;\
	sta *+15 ;\
	iny ;\
	lda ptr2,y ;\
	sta *+10 ;\ 
	ldx #0 ;\
	lda adr1,x ;\
	sta $1234,x ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_DI(adr1,ptr2,y2,length) \
	ldx adr1 ;\
	lda adr1+1 ;\
	stx *+22 ;\
	sta *+20 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta *+15 ;\
	iny ;\
	lda ptr2,y ;\
	sta *+10 ;\
	ldx #0 ;\
	lda $1234,x ;\
	sta $5678,x ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_AI(ptr1,y1,ptr2,y2,length) \
	ldy #y2 ;\
	lda ptr2,y ;\
	sta *+16 ;\
	iny ;\
	lda ptr2,y ;\
	sta *+11 ;\
	ldx #0 ;\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta $1234,x ;\
	iny ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\

#define ASGNS_II(ptr1,y1,ptr2,y2,length) \
	ldy #y1 ;\
	lda ptr1,y ;\
	sta *+25 ;\
	iny ;\
	lda ptr1,y ;\
	sta *+20 ;\
	ldy #y2 ;\
	lda ptr2,y ;\
	sta *+15 ;\
	iny ;\
	lda ptr2,y ;\
	sta *+10 ;\
	ldx #0 ;\
	lda $1234,x ;\
	sta $5678,x ;\
	inx ;\
	cpx #length ;\
	bne *-9 ;\
	
#define EQ0W_D(tmp,label)\
	lda tmp ;\
	ora tmp+1 ;\
	bne *+5 ;\
	jmp label ;\

#define EQ0W_I(ptr,y2,label)\
	ldy #y2 ;\
	lda ptr,y ;\
	iny ;\
	ora ptr,y ;\
	bne *+5 ;\
	jmp label ;\

#define EQW_DC(tmp2,cte1,label)\
	lda #<(cte1) ;\
	eor tmp2 ;\
	sta tmp ;\
	lda #>(cte1) ;\
	eor tmp2+1 ;\
	ora tmp ;\
	bne *+5 ;\
	jmp label ;\

#define EQW_DA(tmp2,ptr1,y1,label)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	eor tmp2 ;\
	sta tmp ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	eor tmp2+1 ;\
	ora tmp ;\
	bne *+5 ;\
	jmp label ;\

#define EQW_IC(ptr2,y2,cte1,label)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	bne *+12 ;\
	iny ;\
	lda #>(cte1) ;\
	cmp ptr2,y ;\
	bne *+5 ;\
	jmp label ;\

#define EQW_IA(ptr2,y2,ptr1,y1,label)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	ldy #y2 ;\
	eor ptr2,y ;\
	sta tmp ;\
	iny ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	eor ptr2,y ;\
	ora tmp ;\
	bne *+5 ;\
	jmp label ;\

#define EQW_DD(tmp1,tmp2,label)\
	lda tmp1 ;\
	eor tmp2 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	eor tmp2+1 ;\
	ora tmp ;\
	bne *+5 ;\
	jmp label ;\

#define EQW_DI(tmp1,ptr2,y2,label)\
	lda tmp1 ;\
	ldy #y2 ;\
	eor ptr2,y ;\
	sta tmp ;\
	iny ;\
	lda tmp1+1 ;\
	eor ptr2,y ;\
	ora tmp ;\
	bne *+5 ;\
	jmp label ;\

#define EQW_ID(ptr1,y1,tmp2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	eor tmp2 ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	eor tmp2+1 ;\
	ora tmp ;\
	bne *+5 ;\
	jmp label ;\

#define EQW_II(ptr1,y1,ptr2,y2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	bne *+15 ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	cmp ptr2,y ;\
	bne *+5 ;\
	jmp label ;\

#define NE0W_D(tmp,label)\
	lda tmp ;\
	ora tmp+1 ;\
	beq *+5 ;\
	jmp label ;\

#define NE0W_I(ptr,y2,label)\
	ldy #y2 ;\
	lda ptr,y ;\
	iny ;\
	ora ptr,y ;\
	beq *+5 ;\
	jmp label ;\

#define NEW_DC(tmp2,cte1,label)\
	lda #<(cte1) ;\
	eor tmp2 ;\
	sta tmp ;\
	lda #>(cte1) ;\
	eor tmp2+1 ;\
	ora tmp ;\
	beq *+5 ;\
	jmp label ;\

#define NEW_DA(tmp2,ptr1,y1,label)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	eor tmp2 ;\
	sta tmp ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	eor tmp2+1 ;\
	ora tmp ;\
	beq *+5 ;\
	jmp label ;\

#define NEW_IC(ptr2,y2,cte1,label)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	beq *+5 ;\
	jmp label ;\
	iny ;\
	lda #>(cte1) ;\
	cmp ptr2,y ;\
	beq *+5 ;\
	jmp label ;\

#define NEW_IA(ptr2,y2,ptr1,y1,label)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	ldy #y2 ;\
	eor ptr2,y ;\
	sta tmp ;\
	iny ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	eor ptr2,y ;\
	ora tmp ;\
	beq *+5 ;\
	jmp label ;\

#define NEW_DD(tmp1,tmp2,label)\
	lda tmp1 ;\
	eor tmp2 ;\
	sta tmp ;\
	lda tmp1+1 ;\
	eor tmp2+1 ;\
	ora tmp ;\
	beq *+5 ;\
	jmp label ;\

#define NEW_DI(tmp1,ptr2,y2,label)\
	lda tmp1 ;\
	ldy #y2 ;\
	eor ptr2,y ;\
	sta tmp ;\
	iny ;\
	lda tmp1+1 ;\
	eor ptr2,y ;\
	ora tmp ;\
	beq *+5 ;\
	jmp label ;\

#define NEW_ID(ptr1,y1,tmp2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	eor tmp2 ;\
	sta tmp ;\
	iny ;\
	lda ptr1,y ;\
	eor tmp2+1 ;\
	ora tmp ;\
	beq *+5 ;\
	jmp label ;\

#define NEW_II(ptr1,y1,ptr2,y2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	beq *+5 ;\
	jmp label ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	cmp ptr2,y ;\
	beq *+5 ;\
	jmp label ;\

#define GEI(label)\
	bvc *+4 ;\
	eor #$80 ;\
	bmi *+5 ;\
	jmp label ;\

#define GEU(label)\
	bcc *+5 ;\
	jmp label ;\

#define GEI_DC(tmp1,cte2,label)\
	lda tmp1 ;\
	cmp #<(cte2) ;\
	lda tmp1+1 ;\
	sbc #>(cte2) ;\
	GEI(label) ;\

#define GEI_DD(tmp1,tmp2,label)\
	lda tmp1 ;\
	cmp tmp2 ;\
	lda tmp1+1 ;\
	sbc tmp2+1 ;\
	GEI(label) ;\

#define GEI_DI(tmp1,ptr2,y2,label)\
	lda tmp1 ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	iny ;\
	lda tmp1+1 ;\
	sbc ptr2,y ;\
	GEI(label) ;\

#define GEI_IC(ptr1,y1,cte2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	cmp #<(cte2) ;\
	iny ;\
	lda ptr1,y ;\
	sbc #>(cte2) ;\
	GEI(label) ;\

#define GEI_ID(ptr1,y1,tmp2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	cmp tmp2 ;\
	iny ;\
	lda ptr1,y ;\
	sbc tmp2+1 ;\
	GEI(label) ;\

#define GEI_II(ptr1,y1,ptr2,y2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	sbc ptr2,y ;\
	GEI(label) ;\

#define GEI_CD(cte1,tmp2,label)\
	lda #<(cte1) ;\
	cmp tmp2 ;\
	lda #>(cte1) ;\
	sbc tmp2+1 ;\
	GEI(label) ;\

#define GEI_CI(cte1,ptr2,y2,label)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	iny ;\
	lda #>(cte1) ;\
	sbc ptr2,y ;\
	GEI(label) ;\

#define GEU_DC(tmp1,cte2,label)\
	lda tmp1 ;\
	cmp #<(cte2) ;\
	lda tmp1+1 ;\
	sbc #>(cte2) ;\
	GEU(label) ;\

#define GEU_DD(tmp1,tmp2,label)\
	lda tmp1 ;\
	cmp tmp2 ;\
	lda tmp1+1 ;\
	sbc tmp2+1 ;\
	GEU(label) ;\

#define GEU_DI(tmp1,ptr2,y2,label)\
	lda tmp1 ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	iny ;\
	lda tmp1+1 ;\
	sbc ptr2,y ;\
	GEU(label) ;\

#define GEU_IC(ptr1,y1,cte2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	cmp #<(cte2) ;\
	iny ;\
	lda ptr1,y ;\
	sbc #>(cte2) ;\
	GEU(label) ;\

#define GEU_ID(ptr1,y1,tmp2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	cmp tmp2 ;\
	iny ;\
	lda ptr1,y ;\
	sbc tmp2+1 ;\
	GEU(label) ;\

#define GEU_II(ptr1,y1,ptr2,y2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	sbc ptr2,y ;\
	GEU(label) ;\

#define GEU_CD(cte1,tmp2,label)\
	lda #<(cte1) ;\
	cmp tmp2 ;\
	lda #>(cte1) ;\
	sbc tmp2+1 ;\
	GEU(label) ;\

#define GEU_CI(cte1,ptr2,y2,label)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	iny ;\
	lda #>(cte1) ;\
	sbc ptr2,y ;\
	GEU(label) ;\

#define LTI(label)\
	.( ;\
	bvc *+4 ;\
	eor #$80 ;\
	bpl skip ;\
	jmp label ;\
skip ;\
	.) ;\

#define LTU(label)\
	bcs *+5 ;\
	jmp label ;\

#define LTI_DC(tmp1,cte2,label)\
	lda tmp1 ;\
	cmp #<(cte2) ;\
	lda tmp1+1 ;\
	sbc #>(cte2) ;\
	LTI(label) ;\

#define LTI_DD(tmp1,tmp2,label)\
	lda tmp1 ;\
	cmp tmp2 ;\
	lda tmp1+1 ;\
	sbc tmp2+1 ;\
	LTI(label) ;\

#define LTI_DI(tmp1,ptr2,y2,label)\
	lda tmp1 ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	iny ;\
	lda tmp1+1 ;\
	sbc ptr2,y ;\
	LTI(label) ;\

#define LTI_IC(ptr1,y1,cte2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	cmp #<(cte2) ;\
	iny ;\
	lda ptr1,y ;\
	sbc #>(cte2) ;\
	LTI(label) ;\

#define LTI_ID(ptr1,y1,tmp2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	cmp tmp2 ;\
	iny ;\
	lda ptr1,y ;\
	sbc tmp2+1 ;\
	LTI(label) ;\

#define LTI_II(ptr1,y1,ptr2,y2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	sbc ptr2,y ;\
	LTI(label) ;\

#define LTI_CD(cte1,tmp2,label)\
	lda #<(cte1) ;\
	cmp tmp2 ;\
	lda #>(cte1) ;\
	sbc tmp2+1 ;\
	LTI(label) ;\

#define LTI_CI(cte1,ptr2,y2,label)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	iny ;\
	lda #>(cte1) ;\
	sbc ptr2,y ;\
	LTI(label) ;\

#define LTU_DC(tmp1,cte2,label)\
	lda tmp1 ;\
	cmp #<(cte2) ;\
	lda tmp1+1 ;\
	sbc #>(cte2) ;\
	LTU(label) ;\

#define LTU_DD(tmp1,tmp2,label)\
	lda tmp1 ;\
	cmp tmp2 ;\
	lda tmp1+1 ;\
	sbc tmp2+1 ;\
	LTU(label) ;\

#define LTU_DI(tmp1,ptr2,y2,label)\
	lda tmp1 ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	iny ;\
	lda tmp1+1 ;\
	sbc ptr2,y ;\
	LTU(label) ;\

#define LTU_IC(ptr1,y1,cte2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	cmp #<(cte2) ;\
	iny ;\
	lda ptr1,y ;\
	sbc #>(cte2) ;\
	LTU(label) ;\

#define LTU_ID(ptr1,y1,tmp2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	cmp tmp2 ;\
	iny ;\
	lda ptr1,y ;\
	sbc tmp2+1 ;\
	LTU(label) ;\

#define LTU_II(ptr1,y1,ptr2,y2,label)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	sbc ptr2,y ;\
	LTU(label) ;\

#define LTU_CD(cte1,tmp2,label)\
	lda #<(cte1) ;\
	cmp tmp2 ;\
	lda #>(cte1) ;\
	sbc tmp2+1 ;\
	LTU(label) ;\

#define LTU_CI(cte1,ptr2,y2,label)\
	lda #<(cte1) ;\
	ldy #y2 ;\
	cmp ptr2,y ;\
	iny ;\
	lda #>(cte1) ;\
	sbc ptr2,y ;\
	LTU(label) ;\

#define GTI_DC(tmp1,cte2,label)\
	LTI_CD(cte2,tmp1,label) ;\

#define GTI_DD(tmp1,tmp2,label)\
	LTI_DD(tmp2,tmp1,label) ;\

#define GTI_DI(tmp1,ptr2,y2,label)\
	LTI_ID(tmp2,y2,tmp1,label) ;\

#define GTI_IC(ptr1,y1,cte2,label)\
	LTI_CI(cte2,ptr1,y1,label) ;\

#define GTI_ID(ptr1,y1,tmp2,label)\
	LTI_DI(tmp2,ptr1,y1,label) ;\

#define GTI_II(ptr1,y1,ptr2,y2,label)\
	LTI_II(ptr2,y2,ptr1,y1,label) ;\

#define GTI_CD(cte1,tmp2,label)\
	LTI_DC(tmp2,cte1,label) ;\

#define GTI_CI(cte1,ptr2,y2,label)\
	LTI_IC(ptr2,y2,cte1,label) ;\

#define LEI_DC(tmp1,cte2,label)\
	GEI_CD(cte2,tmp1,label) ;\

#define LEI_DD(tmp1,tmp2,label)\
	GEI_DD(tmp2,tmp1,label) ;\

#define LEI_DI(tmp1,ptr2,y2,label)\
	GEI_ID(tmp2,y2,tmp1,label) ;\

#define LEI_IC(ptr1,y1,cte2,label)\
	GEI_CI(cte2,ptr1,y1,label) ;\

#define LEI_ID(ptr1,y1,tmp2,label)\
	GEI_DI(tmp2,ptr1,y1,label) ;\

#define LEI_II(ptr1,y1,ptr2,y2,label)\
	GEI_II(ptr2,y2,ptr1,y1,label) ;\

#define LEI_CD(cte1,tmp2,label)\
	GEI_DC(tmp2,cte1,label) ;\

#define LEI_CI(cte1,ptr2,y2,label)\
	GEI_IC(ptr2,y2,cte1,label) ;\

#define GTU_DC(tmp1,cte2,label)\
	LTU_CD(cte2,tmp1,label) ;\

#define GTU_DD(tmp1,tmp2,label)\
	LTU_DD(tmp2,tmp1,label) ;\

#define GTU_DI(tmp1,ptr2,y2,label)\
	LTU_ID(tmp2,y2,tmp1,label) ;\

#define GTU_IC(ptr1,y1,cte2,label)\
	LTU_CI(cte2,ptr1,y1,label) ;\

#define GTU_ID(ptr1,y1,tmp2,label)\
	LTU_DI(tmp2,ptr1,y1,label) ;\

#define GTU_II(ptr1,y1,ptr2,y2,label)\
	LTU_II(ptr2,y2,ptr1,y1,label) ;\

#define GTU_CD(cte1,tmp2,label)\
	LTU_DC(tmp2,cte1,label) ;\

#define GTU_CI(cte1,ptr2,y2,label)\
	LTU_IC(ptr2,y2,cte1,label) ;\

#define LEU_DC(tmp1,cte2,label)\
	GEU_CD(cte2,tmp1,label) ;\

#define LEU_DD(tmp1,tmp2,label)\
	GEU_DD(tmp2,tmp1,label) ;\

#define LEU_DI(tmp1,ptr2,y2,label)\
	GEU_ID(tmp2,y2,tmp1,label) ;\

#define LEU_IC(ptr1,y1,cte2,label)\
	GEU_CI(cte2,ptr1,y1,label) ;\

#define LEU_ID(ptr1,y1,tmp2,label)\
	GEU_DI(tmp2,ptr1,y1,label) ;\

#define LEU_II(ptr1,y1,ptr2,y2,label)\
	GEU_II(ptr2,y2,ptr1,y1,label) ;\

#define LEU_CD(cte1,tmp2,label)\
	GEU_DC(tmp2,cte1,label) ;\

#define LEU_CI(cte1,ptr2,y2,label)\
	GEU_IC(ptr2,y2,cte1,label) ;\

#define ARGW_C(cte,ptr,y2)\
	lda #<(cte) ;\
	ldy #y2 ;\
	sta ptr,y ;\
	iny ;\
	lda #>(cte) ;\
	sta ptr,y ;\

#define ARGW_D(tmp,ptr,y2)\
	lda tmp ;\
	ldy #y2 ;\
	sta ptr,y ;\
	iny ;\
	lda tmp+1 ;\
	sta ptr,y ;\

#define ARGW_A(ptr1,y1,ptr,y2)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	ldy #y2 ;\
	sta ptr,y ;\
	iny ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	sta ptr,y ;\

#define ARGW_I(ptr1,y1,ptr,y2)\
	ldy #y1 ;\
	lda ptr1,y ;\
	ldy #y2 ;\
	sta ptr,y ;\
	ldy #y1+1 ;\
	lda ptr1,y ;\
	ldy #y2+1 ;\
	sta ptr,y ;\

#define CALLV_C(adr,size)\
	ldy #size ;\
	jsr adr ;\

#define CALLV_D(tmp,size)\
	lda tmp ;\
	sta *+11 ;\
	lda tmp+1 ;\
	sta *+7 ;\
	ldy #size ;\
	jsr 0000 ;\

#define CALLV_I(ptr,y2,size)\
	ldy #y2 ;\
	lda ptr,y ;\
	sta *+12 ;\
	iny ;\
	lda ptr,y ;\
	sta *+7 ;\
	ldy #size ;\
	jsr 0000 ;\

#define CALLW_CD(adr,size,tmp)\
	ldy #size ;\
	jsr adr ;\
	stx tmp ;\
	sta tmp+1 ;\

#define CALLW_DD(tmp1,size,tmp)\
	CALLV_D(tmp1,size) \
	stx tmp ;\
	sta tmp+1 ;\

#define CALLW_ID(ptr,y2,size,tmp)\
	CALLV_I(ptr,y2,size) \
	stx tmp ;\
	sta tmp+1 ;\

#define CALLW_CI(adr,size,ptr,y2)\
	ldy #size ;\
	jsr adr ;\
	ldy #y2+1 ;\
	sta ptr,y ;\
	dey ;\
	txa ;\
	sta ptr,y ;\

#define CALLW_II(ptr,y0,size,ptr2,y2)\
	CALLV_I(ptr,y0,size) \
	ldy #y2+1 ;\
	sta ptr2,y ;\
	dey ;\
	txa ;\
	sta ptr2,y ;\


#define JUMP_C(label)\
	jmp label ;\

#define JUMP_D(tmp)\
	lda tmp ;\
	sta *+9 ;\
	lda tmp+1 ;\
	sta *+5 ;\
	jmp 0000 ;\

#define JUMP_I(ptr1,y1)\
	ldy #y1 ;\
	lda ptr1,y ;\
	sta *+10 ;\
	iny ;\
	lda ptr1,y ;\
	sta *+5 ;\
	jmp 0000 ;\

#define FLOAD1_C(tmp)\
	lda #<(tmp) ;\
	ldy #>(tmp) ;\
	jsr load_acc1 ;\

#define FLOAD1_D(tmp)\
	lda tmp ;\
	ldy tmp+1 ;\
	jsr load_acc1 ;\

#define FLOAD1_A(ptr1,y1)\
	clc ;\
        lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
        lda 1+ptr1 ;\
	adc #0 ;\
	tay ;\
	txa ;\
	jsr load_acc1 ;\

#define FLOAD1_I(ptr1,y1)\
	ldy #y1 ;\
        lda ptr1,y ;\
	tax ;\
	iny ;\
        lda ptr1,y ;\
	tay ;\
	txa ;\
	jsr load_acc1 ;\

#define FLOAD2_C(tmp)\
	lda #<(tmp) ;\
	ldy #>(tmp) ;\
	jsr load_acc2 ;\

#define FLOAD2_D(tmp)\
	lda tmp ;\
	ldy tmp+1 ;\
	jsr load_acc2 ;\

#define FLOAD2_A(ptr1,y1)\
	clc ;\
        lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
        lda 1+ptr1 ;\
	adc #0 ;\
	tay ;\
	txa ;\
	jsr load_acc2 ;\

#define FLOAD2_I(ptr1,y1)\
	ldy #y1 ;\
        lda ptr1,y ;\
	tax ;\
	iny ;\
        lda ptr1,y ;\
	tay ;\
	txa ;\
	jsr load_acc2 ;\

#define FSTORE_C(tmp)\
	ldx #<(tmp) ;\
	ldy #>(tmp) ;\
	jsr store_acc ;\

#define FSTORE_D(tmp)\
	ldx tmp ;\
	ldy tmp+1 ;\
	jsr store_acc ;\

#define FSTORE_A(ptr1,y1)\
	clc ;\
        lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
        lda 1+ptr1 ;\
	adc #0 ;\
	tay ;\
	jsr store_acc ;\

#define FSTORE_I(ptr1,y1)\
	ldy #y1 ;\
        lda ptr1,y ;\
	tax ;\
	iny ;\
        lda ptr1,y ;\
	tay ;\
	jsr store_acc ;\

#define FADD\
	jsr fadd ;\

#define ADDF_DDD(tmp1,tmp2,tmp3)\
	FLOAD1_C(tmp1) ;\
	FLOAD2_C(tmp2) ;\
	FADD ;\
	FSTORE_C(tmp3) ;\

#define ADDF_IDD(ptr1,y1,tmp2,tmp3)\
	FLOAD1_A(ptr1,y1) ;\
	FLOAD2_C(tmp2) ;\
	FADD ;\
	FSTORE_C(tmp3) ;\

#define ADDF_DID(tmp1,ptr2,y2,tmp3)\
	FLOAD1_C(tmp1) ;\
	FLOAD2_A(ptr2,y2) ;\
	FADD ;\
	FSTORE_C(tmp3) ;\

#define ADDF_IID(ptr1,y1,ptr2,y2,tmp3)\
	FLOAD1_A(ptr1,y1) ;\
	FLOAD2_A(ptr2,y2) ;\
	FADD ;\
	FSTORE_C(tmp3) ;\

#define ADDF_DDI(tmp1,tmp2,ptr3,y3)\
	FLOAD1_C(tmp1) ;\
	FLOAD2_C(tmp2) ;\
	FADD ;\
	FSTORE_A(ptr3,y3) ;\

#define ADDF_IDI(ptr1,y1,tmp2,ptr3,y3)\
	FLOAD1_A(ptr1,y1) ;\
	FLOAD2_C(tmp2) ;\
	FADD ;\
	FSTORE_A(ptr3,y3) ;\

#define ADDF_DII(tmp1,ptr2,y2,ptr3,y3)\
	FLOAD1_C(tmp1) ;\
	FLOAD2_A(ptr2,y2) ;\
	FADD ;\
	FSTORE_A(ptr3,y3) ;\

#define ADDF_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	FLOAD1_A(ptr1,y1) ;\
	FLOAD2_A(ptr2,y2) ;\
	FADD ;\
	FSTORE_A(ptr3,y3) ;\

#define FSUB\
	jsr fsub ;\

#define SUBF_DDD(tmp1,tmp2,tmp3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_C(tmp1) ;\
	FSUB ;\
	FSTORE_C(tmp3) ;\

#define SUBF_IDD(ptr1,y1,tmp2,tmp3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FSUB ;\
	FSTORE_C(tmp3) ;\

#define SUBF_DID(tmp1,ptr2,y2,tmp3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_C(tmp1) ;\
	FSUB ;\
	FSTORE_C(tmp3) ;\

#define SUBF_IID(ptr1,y1,ptr2,y2,tmp3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FSUB ;\
	FSTORE_C(tmp3) ;\

#define SUBF_DDI(tmp1,tmp2,ptr3,y3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_C(tmp1) ;\
	FSUB ;\
	FSTORE_A(ptr3,y3) ;\

#define SUBF_IDI(ptr1,y1,tmp2,ptr3,y3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FSUB ;\
	FSTORE_A(ptr3,y3) ;\

#define SUBF_DII(tmp1,ptr2,y2,ptr3,y3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_C(tmp1) ;\
	FSUB ;\
	FSTORE_A(ptr3,y3) ;\

#define SUBF_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FSUB ;\
	FSTORE_A(ptr3,y3) ;\

#define FMUL\
	jsr fmul ;\

#define MULF_DDD(tmp1,tmp2,tmp3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_C(tmp1) ;\
	FMUL ;\
	FSTORE_C(tmp3) ;\

#define MULF_IDD(ptr1,y1,tmp2,tmp3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FMUL ;\
	FSTORE_C(tmp3) ;\

#define MULF_DID(tmp1,ptr2,y2,tmp3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_C(tmp1) ;\
	FMUL ;\
	FSTORE_C(tmp3) ;\

#define MULF_IID(ptr1,y1,ptr2,y2,tmp3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FMUL ;\
	FSTORE_C(tmp3) ;\

#define MULF_DDI(tmp1,tmp2,ptr3,y3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_C(tmp1) ;\
	FMUL ;\
	FSTORE_A(ptr3,y3) ;\

#define MULF_IDI(ptr1,y1,tmp2,ptr3,y3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FMUL ;\
	FSTORE_A(ptr3,y3) ;\

#define MULF_DII(tmp1,ptr2,y2,ptr3,y3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_C(tmp1) ;\
	FMUL ;\
	FSTORE_A(ptr3,y3) ;\

#define MULF_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FMUL ;\
	FSTORE_A(ptr3,y3) ;\

#define FDIV\
	jsr fdiv ;\

#define DIVF_DDD(tmp1,tmp2,tmp3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_C(tmp1) ;\
	FDIV ;\
	FSTORE_C(tmp3) ;\

#define DIVF_IDD(ptr1,y1,tmp2,tmp3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FDIV ;\
	FSTORE_C(tmp3) ;\

#define DIVF_DID(tmp1,ptr2,y2,tmp3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_C(tmp1) ;\
	FDIV ;\
	FSTORE_C(tmp3) ;\

#define DIVF_IID(ptr1,y1,ptr2,y2,tmp3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FDIV ;\
	FSTORE_C(tmp3) ;\

#define DIVF_DDI(tmp1,tmp2,ptr3,y3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_C(tmp1) ;\
	FDIV ;\
	FSTORE_A(ptr3,y3) ;\

#define DIVF_IDI(ptr1,y1,tmp2,ptr3,y3)\
	FLOAD1_C(tmp2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FDIV ;\
	FSTORE_A(ptr3,y3) ;\

#define DIVF_DII(tmp1,ptr2,y2,ptr3,y3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_C(tmp1) ;\
	FDIV ;\
	FSTORE_A(ptr3,y3) ;\

#define DIVF_III(ptr1,y1,ptr2,y2,ptr3,y3)\
	FLOAD1_A(ptr2,y2) ;\
	FLOAD2_A(ptr1,y1) ;\
	FDIV ;\
	FSTORE_A(ptr3,y3) ;\

#define FNEG\
	jsr fneg ;\

#define NEGF_DD(tmp1,tmp2)\
	FLOAD1_C(tmp1) ;\
	FNEG ;\
	FSTORE_C(tmp2) ;\

#define NEGF_ID(ptr1,y1,tmp2)\
	FLOAD1_A(ptr1,y1) ;\
	FNEG ;\
	FSTORE_C(tmp2) ;\

#define NEGF_DI(tmp1,ptr2,y2)\
	FLOAD1_C(tmp1) ;\
	FNEG ;\
	FSTORE_A(ptr2,y2) ;\

#define NEGF_II(ptr1,y1,ptr2,y2)\
	FLOAD1_A(ptr1,y1) ;\
	FNEG ;\
	FSTORE_A(ptr2,y2) ;\

#define INDIRF_CD(tmp1,tmp2)\
	FLOAD1_C(tmp1) ;\
	FSTORE_C(tmp2) ;\

#define INDIRF_CI(tmp1,ptr2,y2)\
	FLOAD1_C(tmp1) ;\
	FSTORE_A(ptr2,y2) ;\

#define INDIRF_DD(tmp1,tmp2)\
	FLOAD1_D(tmp1) ;\
	FSTORE_C(tmp2) ;\

#define INDIRF_DI(tmp1,ptr2,y2)\
	FLOAD1_D(tmp1) ;\
	FSTORE_A(ptr2,y2) ;\

#define INDIRF_AD(ptr1,y1,tmp2)\
	FLOAD1_A(ptr1,y1) ;\
	FSTORE_C(tmp2) ;\

#define INDIRF_AI(ptr1,y1,ptr2,y2)\
	FLOAD1_A(ptr1,y1) ;\
	FSTORE_A(ptr2,y2) ;\

#define INDIRF_ID(ptr1,y1,tmp2)\
	FLOAD1_I(ptr1,y1) ;\
	FSTORE_C(tmp2) ;\

#define INDIRF_II(ptr1,y1,ptr2,y2)\
	FLOAD1_I(ptr1,y1) ;\
	FSTORE_A(ptr2,y2) ;\

#define MOVF_DD(tmp1,tmp2)\
	INDIRF_CD(tmp1,tmp2) ;\

#define MOVF_DI(tmp1,ptr2,y2)\
	INDIRF_CI(tmp1,ptr2,y2) ;\

#define MOVF_ID(ptr1,y1,tmp2)\
	INDIRF_AD(ptr1,y1,tmp2) ;\

#define MOVF_II(ptr1,y1,ptr2,y2)\
	INDIRF_AI(ptr1,y1,ptr2,y2) ;\

#define CFI_D(tmp1)\
	jsr cfi ;\
        sta tmp1 ;\
        stx tmp1+1 ;\

#define CFI_I(ptr1,y1)\
	jsr cfi ;\
	ldy #y1 ;\
        sta ptr1,y ;\
	iny ;\
	txa ;\
        sta ptr1,y ;\

#define CFI_DD(tmp1,tmp2)\
	FLOAD1_C(tmp1) ;\
	CFI_D(tmp2) ;\

#define CFI_DI(tmp1,ptr2,y2)\
	FLOAD1_C(tmp1) ;\
	CFI_I(ptr2,y2) ;\

#define CFI_ID(ptr1,y1,tmp2)\
	FLOAD1_A(ptr1,y1) ;\
	CFI_D(tmp2) ;\

#define CFI_II(ptr1,y1,ptr2,y2)\
	FLOAD1_A(ptr1,y1) ;\
	CFI_I(ptr2,y2) ;\

#define CIF_C(cte)\
	ldy #<(cte) ;\
	lda #>(cte) ;\
	jsr cif ;\

#define CIF_D(tmp1)\
	ldy tmp1 ;\
	lda tmp1+1 ;\
	jsr cif ;\

#define CIF_I(ptr1,y1)\
	ldy #y1 ;\
	iny ;\
        lda ptr1,y ;\
	tax ;\
	dey ;\
        lda ptr1,y ;\
	tay ;\
	txa ;\
	jsr cif ;\

#define CIF_CD(cte,tmp) \
	CIF_C(cte) ;\
	FSTORE_C(tmp) ;\

#define CIF_CI(cte,ptr1,y1) \
	CIF_C(cte) ;\
	FSTORE_A(ptr1,y1) ;\

#define CIF_DD(tmp1,tmp2)\
	CIF_D(tmp1) ;\
	FSTORE_C(tmp2) ;\

#define CIF_DI(tmp1,ptr2,y2)\
	CIF_D(tmp1) ;\
	FSTORE_A(ptr2,y2) ;\

#define CIF_ID(ptr1,y1,tmp2)\
	CIF_I(ptr1,y1) ;\
	FSTORE_C(tmp2) ;\

#define CIF_II(ptr1,y1,ptr2,y2)\
	CIF_I(ptr1,y1) ;\
	FSTORE_A(ptr2,y2) ;\

#define RETF_D(tmp1)\
	FLOAD1_C(tmp1) ;\
	rts ;\

#define RETF_I(ptr1,y1)\
	FLOAD1_A(ptr1,y1) ;\
	rts ;\

#define LEAVEF_D(tmp1)\
	FLOAD1_C(tmp1) ;\
	jmp leave ;\

#define LEAVEF_I(ptr1,y1)\
	FLOAD1_A(ptr1,y1) ;\
	jmp leave ;\

#define ASGNF_DC(tmp1,tmp2)\
	FLOAD1_C(tmp1) ;\
	FSTORE_C(tmp2) ;\

#define ASGNF_DA(tmp1,ptr2,y2)\
	FLOAD1_C(tmp1) ;\
	FSTORE_A(ptr2,y2) ;\

#define ASGNF_DZ(tmp1,tmp2)\
	FLOAD1_C(tmp1) ;\
	FSTORE_D(tmp2) ;\

#define ASGNF_DD(tmp1,tmp2)\
	FLOAD1_C(tmp1) ;\
	FSTORE_D(tmp2) ;\

#define ASGNF_DI(tmp1,ptr2,y2)\
	FLOAD1_C(tmp1) ;\
	FSTORE_I(ptr2,y2) ;\

#define ASGNF_IC(ptr1,y1,tmp2)\
	FLOAD1_A(ptr1,y1) ;\
	FSTORE_C(tmp2) ;\

#define ASGNF_IZ(ptr1,y1,tmp2)\
	FLOAD1_A(ptr1,y1) ;\
	FSTORE_D(tmp2) ;\

#define ASGNF_ID(ptr1,y1,tmp2)\
	FLOAD1_A(ptr1,y1) ;\
	FSTORE_D(tmp2) ;\

#define ASGNF_IA(ptr1,y1,ptr2,y2)\
	FLOAD1_A(ptr1,y1) ;\
	FSTORE_A(ptr2,y2) ;\

#define ASGNF_II(ptr1,y1,ptr2,y2)\
	FLOAD1_A(ptr1,y1) ;\
	FSTORE_I(ptr2,y2) ;\

#define ARGF_D(tmp1,ptr2,y2)\
	FLOAD1_C(tmp1) ;\
	FSTORE_A(ptr2,y2) ;\

#define ARGF_I(ptr1,y1,ptr2,y2)\
	FLOAD1_A(ptr1,y1) ;\
	FSTORE_A(ptr2,y2) ;\

#define ARGS_C(adr,ptr2,y2,size) \
	ASGNS_CA(adr,ptr2,y2,size) ;\

#define ARGS_D(tmp1,ptr2,y2,size)\
	ASGNS_DA(tmp1,ptr2,y2,size) ;\

#define ARGS_A(ptr1,y1,ptr2,y2,size) \
	ASGNS_AA(ptr1,y1,ptr2,y2,size) ;\

#define ARGS_I(ptr1,y1,ptr2,y2,size)\
	ASGNS_IA(ptr1,y1,ptr2,y2,size) ;\

#define CALLF_CD(adr,size,tmp)\
	ldy #size ;\
	jsr adr ;\
	FSTORE_C(tmp) ;\

#define CALLF_DD(tmp1,size,tmp)\
	lda tmp1 ;\
	sta *+11 ;\
	lda tmp1+1 ;\
	sta *+7 ;\
	ldy #size ;\
	jsr 0000 ;\
	FSTORE_C(tmp) ;\

#define CALLF_ID(ptr,y2,size,tmp)\
	ldy #y2 ;\
	lda ptr,y ;\
	sta jsrvect+1 ;\
	iny ;\
	lda ptr,y ;\
	sta jsrvect+2 ;\
	ldy #size ;\
	jsr jsrvect ;\
	FSTORE_C(tmp) ;\

#define CALLF_CI(adr,size,ptr2,y2)\
	ldy #size ;\
	jsr adr ;\
	FSTORE_A(ptr2,y2) ;\

#define CALLF_II(ptr,y0,size,ptr2,y2)\
	ldy #y0 ;\
	lda ptr,y ;\
	sta jsrvect+1 ;\
	iny ;\
	lda ptr,y ;\
	sta jsrvect+2 ;\
	ldy #size ;\
	jsr jsrvect ;\
	FSTORE_A(ptr2,y2) ;\

#define FCOMP_D(tmp1)\
	lda #<(tmp1) ;\
	ldy #>(tmp1) ;\
	jsr fcomp ;\

#define FCOMP_I(ptr1,y1)\
	clc ;\
	lda 0+ptr1 ;\
	adc #y1 ;\
	tax ;\
	lda 1+ptr1 ;\
	adc #0 ;\
	tay ;\
	txa ;\
	jsr fcomp ;\

#define EQF_DD(tmp1,tmp2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_D(tmp2) ;\
	bne *+5 ;\
	jmp label ;\

#define EQF_DI(tmp1,ptr2,y2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_I(ptr2,y2) ;\
	bne *+5 ;\
	jmp label ;\

#define EQF_ID(ptr1,y1,tmp2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_D(tmp2) ;\
	bne *+5 ;\
	jmp label ;\

#define EQF_II(ptr1,y1,ptr2,y2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_I(ptr2,y2) ;\
	bne *+5 ;\
	jmp label ;\

#define NEF_DD(tmp1,tmp2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_D(tmp2) ;\
	beq *+5 ;\
	jmp label ;\

#define NEF_DI(tmp1,ptr2,y2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_I(ptr2,y2) ;\
	beq *+5 ;\
	jmp label ;\

#define NEF_ID(ptr1,y1,tmp2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_D(tmp2) ;\
	beq *+5 ;\
	jmp label ;\

#define NEF_II(ptr1,y1,ptr2,y2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_I(ptr2,y2) ;\
	beq *+5 ;\
	jmp label ;\

#define GEF_DD(tmp1,tmp2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_D(tmp2) ;\
	bmi *+5 ;\
	jmp label ;\

#define GEF_DI(tmp1,ptr2,y2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_I(ptr2,y2) ;\
	bmi *+5 ;\
	jmp label ;\

#define GEF_ID(ptr1,y1,tmp2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_D(tmp2) ;\
	bmi *+5 ;\
	jmp label ;\

#define GEF_II(ptr1,y1,ptr2,y2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_I(ptr2,y2) ;\
	bmi *+5 ;\
	jmp label ;\

#define LTF_DD(tmp1,tmp2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_D(tmp2) ;\
	bpl *+5 ;\
	jmp label ;\

#define LTF_DI(tmp1,ptr2,y2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_I(ptr2,y2) ;\
	bpl *+5 ;\
	jmp label ;\

#define LTF_ID(ptr1,y1,tmp2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_D(tmp2) ;\
	bpl *+5 ;\
	jmp label ;\

#define LTF_II(ptr1,y1,ptr2,y2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_I(ptr2,y2) ;\
	bpl *+5 ;\
	jmp label ;\

#define GTF_DD(tmp1,tmp2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_D(tmp2) ;\
	beq *+7 ;\
	bmi *+5 ;\
	jmp label ;\

#define GTF_DI(tmp1,ptr2,y2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_I(ptr2,y2) ;\
	beq *+7 ;\
	bmi *+5 ;\
	jmp label ;\

#define GTF_ID(ptr1,y1,tmp2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_D(tmp2) ;\
	beq *+7 ;\
	bmi *+5 ;\
	jmp label ;\

#define GTF_II(ptr1,y1,ptr2,y2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_I(ptr2,y2) ;\
	beq *+7 ;\
	bmi *+5 ;\
	jmp label ;\

#define LEF_DD(tmp1,tmp2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_D(tmp2) ;\
	beq *+4 ;\
	bpl *+5 ;\
	jmp label ;\

#define LEF_DI(tmp1,ptr2,y2,label)\
	FLOAD1_C(tmp1) ;\
	FCOMP_I(ptr2,y2) ;\
	beq *+4 ;\
	bpl *+5 ;\
	jmp label ;\

#define LEF_ID(ptr1,y1,tmp2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_D(tmp2) ;\
	beq *+4 ;\
	bpl *+5 ;\
	jmp label ;\

#define LEF_II(ptr1,y1,ptr2,y2,label)\
	FLOAD1_A(ptr1,y1) ;\
	FCOMP_I(ptr2,y2) ;\
	beq *+4 ;\
	bpl *+5 ;\
	jmp label ;\

