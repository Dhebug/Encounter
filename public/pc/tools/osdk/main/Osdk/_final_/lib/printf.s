;
; printf(char *format,...)
;
_printf
	lda #<putchar
	sta printvect+1
	lda #>putchar
	sta printvect+2
	ldy #0
	jmp printf

printvect jmp $0238

storechar
	sta $1234
	inc storechar+1
	bne *+5
	inc storechar+2
	rts
	
;
; sprintf(char *format,...)
;
_sprintf
	lda #<storechar
	sta printvect+1
	lda #>storechar
	sta printvect+2
	
	ldy #0
	lda (sp),y
	sta storechar+1
	iny
	lda (sp),y
	sta storechar+2
	iny

printf
	lda (sp),y
	sta tmp
	iny
	lda (sp),y
	sta tmp+1
	iny
	sty saveptrarg

	ldy #0
formloop
	lda (tmp),y
	tax
	beq endform
    cmp #$25        ; '%'
	beq formfield
charput
        jsr printvect
	iny
	bne formloop	; size format string < 256
endform
	rts
printfloat
	iny
	sty saveptrform
        clc
        lda sp
        adc saveptrarg
        tax
        lda sp+1
        adc #0
        tay
        txa
        jsr load_acc1
        jsr $E0D5
        sta op2
        sty op2+1
        clc
        lda saveptrarg
        adc #5
        sta saveptrarg
	ldy #0
	jmp prtsloop
        
formfield
	iny
	lda (tmp),y
        cmp #$64        ; 'd'
	beq printint
        cmp #$66        ; 'f'
        beq printfloat
        cmp #$73        ; 's'
	beq printstr
        cmp #$63        ; 'c'
	beq printchar
        cmp #$78        ; 'x'
	beq printhex
        jmp charput
printchar
	sty saveptrform
	ldy saveptrarg
	lda (sp),y
	tax
	iny
	iny
	sty saveptrarg
	ldy saveptrform
	jmp charput
printstr
	iny
	sty saveptrform
	ldy saveptrarg
	lda (sp),y
	sta op2
	iny
	lda (sp),y
	sta op2+1
	iny
	sty saveptrarg
	ldy #0
prtsloop
	lda (op2),y
	tax
	beq endprts
        jsr printvect
	iny
	bne prtsloop
	inc op2+1
	jmp prtsloop
endprts
	ldy saveptrform
	jmp formloop
printint
	iny
	sty saveptrform
	jsr nextarg
	jsr itoa
	stx op2
	sta op2+1
	ldy #0
	jmp prtsloop

printhex
	iny
	sty saveptrform
	jsr nextarg
	lda op2+1
	jsr hexbyte
	lda op2
	jsr hexbyte
	ldy saveptrform
	jmp formloop

saveptrform
	.byt 0
saveform
	.byt 0,0
saveptrarg
	.byt 0

hexbyte
	tay 
	lsr 
	lsr 
	lsr 
	lsr 
	jsr nibble
	tya
	and #$0F
nibble
	cmp #10
	bcc chiffre
	adc #6
chiffre
	adc #$30
	tax
	jmp printvect

nextarg
	ldy saveptrarg
	lda (sp),y
	sta op2
	iny
	lda (sp),y
	sta op2+1
	iny
	sty saveptrarg
	rts
