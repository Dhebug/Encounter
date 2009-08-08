;Hourglass.s
;The Hourglass gradually fills with sand dropping from the top
;The number of particles is up to 4 and sequenced with equal distance.
;They can optionally fill glass since a constant stream would fill too quickly


DropSand
	ldx #03
loop1	lda SandStatus,x
	bmi skip1
	jsr DeleteParticle
	jsr MoveParticle
	jsr PlotParticle
skip1	dex
	bpl loop1
	rts

DeleteParticle
	ldy SandY,x
	lda slocl,y
	sta screen
	lda sloch,y
	sta screen+1
	ldy SandX,x
	;Delete Particle
	lda Bitpos,y
	eor #63
	sta Temp01
	lda XOFS,y
	tay
	lda (screen),y
	and Temp01
	sta (screen),y
	rts

MoveParticle
	inc SandY,x

	ldy SandY,x
	lda slocl,y
	sta screen
	lda sloch,y
	sta screen+1
	ldy SandX,x
	;Delete Particle
	lda Bitpos,y
	sta Temp01
	lda XOFS,y
	tay
	lda (screen),y
	and Temp01




PlotParticle
	ldy SandY,x
	lda slocl,y
	sta screen
	lda sloch,y
	sta screen+1
	ldy SandX,x
	;Delete Particle
	lda Bitpos,y
	eor #63
	sta Temp01
	lda XOFS,y
	tay
	lda (screen),y
	and Temp01
	sta (screen),y
	rts

