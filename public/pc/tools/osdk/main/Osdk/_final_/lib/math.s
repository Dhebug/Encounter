getfarg1
	lda sp
	ldy sp+1
	jmp load_acc1

_log	jsr getfarg1
	jmp $DCAF

_log10	jsr getfarg1
	jmp $DDD4

_exp	jsr getfarg1
	jmp $E2AA

_fabs	jsr getfarg1
	jmp $DF49

_cos	jsr getfarg1
	jmp $E38B

_sin	jsr getfarg1
	jmp $E392

_tan	jsr getfarg1
	jmp $E3DB

_atn	jsr getfarg1
	jmp $E43F

_sqrt	jsr getfarg1
	jmp $E22E

_pow	clc
	lda sp
	adc #5
	tax
	lda sp+1
	adc #0
	tay
	txa
	jsr load_acc1
	lda sp
	ldy sp+1
	jsr load_acc2
	jmp $E238

_modf	jsr getfarg1
	jsr $DFBD	; get integral part
	ldy #5
	lda (sp),y
	tax
	iny
	lda (sp),y
	tay
	txa
        jsr store_acc   ; store integral part
	lda sp
	ldy sp+1
	jsr load_acc2	; reload number
	jmp fsub	; and substract to return fractional part

_horner lda sp
        ldy sp+1
        jsr load_acc1
        jsr $DEA0
        ldy #5
        lda (sp),y
        sta $D6
        ldy #7
        lda (sp),y
        sta $E0
        tax
        iny
        lda (sp),y
        sta $E1
        tay
        txa
        jmp $E32A
