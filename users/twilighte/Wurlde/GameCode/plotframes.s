;Attempt to plot all hero frames

tstPlotAllHeroFrames
	;attempt to fill inlay to show mask through
	lda #<HIRESInlayLocation
	sta screen
	lda #>HIRESInlayLocation
	sta screen+1
.(
	ldx #118
loop2	ldy #39
loop1	lda #127
	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	dex
	bne loop2
.)
	;Also fill bgb
	ldx #58
.(
loop2	lda BGBYlocl,x
	sta screen
	lda BGBYloch,x
	sta screen+1
	ldy #39
	lda #127
loop1	sta (screen),y
	dey
	bpl loop1
	dex
	bne loop2
.)		

	lda #49
	sta tstIndex
	
	;Preload stuff for plotting
.(
loop1	ldx tstIndex
	txa
	clc
	adc #50
	sta HeroSprite
	lda tstHeroY,x
	sta HeroY
	lda txtHeroX,x
	sta HeroX
	jsr PlotHero
	dec tstIndex
	bpl loop1

	;Just loop indefinately
loop2	nop
	jmp loop2
.)
	
tstIndex	.byt 0

tstHeroY
 .dsb 10,0
 .dsb 10,12
 .dsb 10,24
 .dsb 10,36
 .dsb 10,48
txtHeroX
 .byt 0,4,8,12,16,20,24,28,32,36
 .byt 0,4,8,12,16,20,24,28,32,36
 .byt 0,4,8,12,16,20,24,28,32,36
 .byt 0,4,8,12,16,20,24,28,32,36
 .byt 0,4,8,12,16,20,24,28,32,36
 


