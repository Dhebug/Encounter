_CopyFont
.(
	ldx #0
loop
	lda _Font_6x8_runic1_partial+256*0,x
	sta $b400+32*8+256*0,x
	
	lda _Font_6x8_runic1_partial+256*1,x
	sta $b400+32*8+256*1,x
	
	lda _Font_6x8_runic1_partial+256*2,x
	sta $b400+32*8+256*2,x
	
	inx 
	
	bne loop
	; call hires
	jmp $ec33
	;rts	
.)