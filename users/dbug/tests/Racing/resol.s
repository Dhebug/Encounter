; We need to wait 1/50 of second here.
; Actually it means 20000 clock cycles.
; In the following table, the first value, is the clock
; cycle count, and the second value is the size in bytes.
; 2/1 => NOP, DEX,DEY,INX,INY
; 6/1 => RTS, RTI
; (2+1)/2 => Bxx
; 6/3 => jsr
;	=> jmp

_TempoVbl
	rts

; 0 for TEXT and 1 for HIRES
_ResolCurrent		.byt 0		



; Routine to clear the TEXT screen memory. It will
; be filled by the value 64 that is neutral
_ResolClearText
	lda #32
	ldx #0
ResolClearTextLoop
	sta $bb80+256*0,x
	sta $bb80+256*1,x
	sta $bb80+256*2,x
	sta $bb80+256*3,x
	sta $bb80+28*40-256,x
	dex
	bne ResolClearTextLoop
	rts



_ResolSwitchToText
	; If we are already in TEXT, we will simply
	; perform a CLS of the whole screen
	lda _ResolCurrent
	bne	_ResolClearText
	 
	jsr _ResolClearText

	lda #24	; Text 50hz attribute
	sta $bfdf
	
	jsr _TempoVbl

	lda #1
	sta _ResolCurrent
	rts



; 2048 bytes
_ResolClearTextCharacters
	lda #64
	ldx #0
ResolClearTextCharactersLoop
	sta $b400+256*0,x
	sta $b400+256*1,x
	sta $b400+256*2,x
	sta $b400+256*3,x
	dex
	bne ResolClearTextCharactersLoop
	rts



; 2048 bytes
_ResolClearHiresCharacters
	lda #64
	ldx #0
ResolClearHiresCharactersLoop
	sta $9800+256*0,x
	sta $9800+256*1,x
	sta $9800+256*2,x
	sta $9800+256*3,x
	sta $9800+256*4,x
	sta $9800+256*5,x
	sta $9800+256*6,x
	sta $9800+256*7,x
	dex
	bne ResolClearHiresCharactersLoop
	rts






; Routine to clear the HIRES screen memory. It will
; be filled by the value 64 that is neutral
; 8000 bytes = 256*31 + 64  
; From $a000 to $bfdf => 8160 bytes
_ResolClearHires
	lda #64
	ldx #0
ResolClearHiresLoop
	sta $a000+256*0,x
	sta $a000+256*1,x
	sta $a000+256*2,x
	sta $a000+256*3,x
	sta $a000+256*4,x
	sta $a000+256*5,x
	sta $a000+256*6,x
	sta $a000+256*7,x
	sta $a000+256*8,x
	sta $a000+256*9,x

	sta $a000+256*10,x
	sta $a000+256*11,x
	sta $a000+256*12,x
	sta $a000+256*13,x
	sta $a000+256*14,x
	sta $a000+256*15,x
	sta $a000+256*16,x
	sta $a000+256*17,x
	sta $a000+256*18,x
	sta $a000+256*19,x

	sta $a000+256*20,x
	sta $a000+256*21,x
	sta $a000+256*22,x
	sta $a000+256*23,x
	sta $a000+256*24,x
	sta $a000+256*25,x
	sta $a000+256*26,x
	sta $a000+256*27,x
	sta $a000+256*28,x
	sta $a000+256*29,x

	sta $a000+256*30,x

	sta $a000+8160-256,x

	dex
	bne ResolClearHiresLoop
	rts



_ResolSwitchToHires
	; If we are already in HIRES, we will simply
	; perform a CLS of the whole screen
	lda _ResolCurrent
	bne	_ResolClearHires
	 
	; Clear the characters zone
	jsr _ResolClearTextCharacters

	; Clear the screen
	jsr _ResolClearHires

	; Clear the characters zone
	jsr _ResolClearHiresCharacters

	lda #30	; Graphic 50hz attribute
	sta $bfdf
	
	jsr _TempoVbl

	lda #1
	sta _ResolCurrent
	rts




