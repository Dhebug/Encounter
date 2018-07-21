;
; sscanf(char buf[],const char *format,...)
;
numberscan .word 0
signscan   .byt 0
fieldcount .byt 0

_sscanf 
	ldy #0
	lda (sp),y
	sta loadchar+1
	iny
	lda (sp),y
	sta loadchar+2
	iny

scanf
	lda (sp),y
	sta tmp
	iny
	lda (sp),y
	sta tmp+1
	iny
	sty saveptrarg

	ldy #0
	sty fieldcount
scanform
	lda (tmp),y
	beq endscan
	cmp #$25        ; '%'
	beq scanformfield
match
	tax
	lda ctype,x
	and #8
	bne matchwhitespace
        jsr loadchar    ; non-white space char : match exactly one char
        txa
        cmp (tmp),y     
        bne endscan
	iny
	bne scanform	; size format string < 256
endscan
	ldx fieldcount
	lda #0
	rts

matchwhitespace
	jsr skipwhitespace
	cpx #0
	beq endscan
	iny
	jmp scanform

scanfloat
	iny
	sty saveptrform
	jsr skipwhitespace
	cpx #0
	beq endscan
        lda loadchar+1
        sta $E9
        lda loadchar+2
        sta $EA
        jsr $00E8
        jsr $DFE7
        lda $CC
        beq endscan
        lda $E9
        sta loadchar+1
        lda $EA
        sta loadchar+2
	jsr nextarg
        ldx op2
        ldy op2+1
        jsr $DEAD
        jmp incfieldcount

scanchar
	iny
	sty saveptrform
	jsr nextarg
	ldy saveptrform
	jsr loadchar
	txa
        beq endscan2
	ldy #0
	sta (op2),y
	jmp incfieldcount


scanformfield
	iny
	lda (tmp),y
        cmp #$64        ; 'd'
	beq scanint
        cmp #$66        ; 'f'
        beq scanfloat
        cmp #$73        ; 's'
	beq scanstr
        cmp #$63        ; 'c'
	beq scanchar
        cmp #$78        ; 'x'
        beq scanhex
        jmp match


scanhex
        iny
        sty saveptrform
        jsr nextarg
	jsr skipwhitespace
	cpx #0
        beq endscan2
        lda ctype,x
        and #$44
        beq endscan2

        ldx loadchar+2
        ldy loadchar+1
        bne *+3
        dex
        dey
        sty $E9
        stx $EA
        jsr $E94C
        tax
        tya
        ldy #0
        sta (op2),y
        iny
        txa
        sta (op2),y
        lda $E9
        sta loadchar+1
        lda $EA
        sta loadchar+2
        jmp incfieldcount


endscan2 jmp endscan

scanstr
	iny
	sty saveptrform
	jsr nextarg
	jsr skipwhitespace
	cpx #0
        beq endscan2
	ldy #0
scanstrloop
	jsr loadchar
	cpx #0
	beq endscanstr
	and #8
	bne endscanstr
        txa
	sta (op2),y
	iny
	bne scanstrloop
endscanstr
	lda #0
	sta (op2),y
	jmp incfieldcount

scanint
	iny
	sty saveptrform
	jsr nextarg
	ldy #0
	sty numberscan
	sty numberscan+1
	sty signscan

	jsr skipwhitespace
	jsr loadchar

	cpx #$2C
	bne *+8
	jsr loadchar
	jmp scanfirstdigit

	cpx #$2D
	bne *+8
        dec signscan
	jsr loadchar

scanfirstdigit
	cpx #0
        beq endscan2
	lda ctype,x
	and #4
        beq endscan2
        txa
        sec
        sbc #$30
        sta numberscan
scanintloop
	jsr loadchar
	cpx #0
	beq endscanint
	and #4
        beq endscanint
	jsr shiftdigit
	jmp scanintloop
endscanint
        jsr unloadchar
        bit signscan
        bpl endscanint2
	sec
	lda #0
	sbc numberscan
	sta numberscan
	lda #0
	sbc numberscan+1
	sta numberscan+1
endscanint2
	lda numberscan
	sta (op2),y
	iny
	lda numberscan+1
	sta (op2),y
incfieldcount
    inc fieldcount
    ldy saveptrform
    jmp scanform

shiftdigit
	lda numberscan+1
	pha
	lda numberscan
	asl
    rol numberscan+1
	asl 
    rol numberscan+1
	clc
	adc numberscan
	sta numberscan
	pla
	adc numberscan+1
	asl numberscan
	rol 
	sta numberscan+1
    sec
	txa
    sbc #$30
    clc
	adc numberscan
	sta numberscan
	bcc *+5
	inc numberscan+1
	rts

skipwhitespace
	jsr loadchar
	cpx #0
	beq endskip
	and #8
	bne skipwhitespace
endskip
unloadchar
	lda loadchar+1
        bne *+5
	dec loadchar+2
	dec loadchar+1
	rts

loadchar
	lda $1234
	inc loadchar+1
	bne *+5
	inc loadchar+2
	tax
	lda ctype,x
	rts

	


