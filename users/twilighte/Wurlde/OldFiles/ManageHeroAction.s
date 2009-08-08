;ManageHeroAction.s

ManageHeroAction
	ldx HeroAction
.(
	bmi skip1
	lda HeroActionVectorLo,x
	sta vector1+1
	lda HeroActionVectorHi,x
	sta vector1+2
vector1	jsr $dead
skip1	rts
.)
havWalkLeft
	lda HeroIndex
	clc
	adc #28
	sta HeroSprite
	jsr DeleteHero
	ldx HeroIndex
	lda HeroX
	sec
	sbc WalkLeftSteps,x
	cmp #2
.(
	bcs skip1
	lda #hcStandLeft
	sta HeroAction
	jmp PlotHero
skip1	sta HeroX
.)
	jsr CalculateCorrectHeroYPOS
	lda HeroIndex
	clc
	adc #01
	cmp #8
.(
	bcc skip1
	lda #128
	sta HeroAction
	;This ensures hero returns to standing position, except if he keeps running it looks odd
	lda HeroStopped
	beq skip2
	lda #105
	sta HeroSprite
skip2	lda #00
skip1	sta HeroIndex
.)
	jsr PlotHero
	rts


havWalkRight
	lda HeroIndex
	clc
	adc #20
	sta HeroSprite
	jsr DeleteHero
	ldx HeroIndex
	lda HeroX
	clc
	adc WalkRightSteps,x
	cmp #37
.(
	bcc skip1
	lda #hcStandRight
	sta HeroAction
	jmp PlotHero
skip1	sta HeroX
.)
	jsr CalculateCorrectHeroYPOS
	lda HeroIndex
	clc
	adc #01
	cmp #8
.(
	bcc skip1
	lda #128
	sta HeroAction
	;This ensures hero returns to standing position, except if he keeps running it looks odd
	lda HeroStopped
	beq skip2
	lda #98
	sta HeroSprite
skip2	lda #00
skip1	sta HeroIndex
.)
	jsr PlotHero
	rts

havRunLeft
	lda HeroIndex
	clc
	adc #10
	sta HeroSprite
	jsr DeleteHero
	ldx HeroIndex
	lda HeroX
	sec
	sbc RunLeftSteps,x
	cmp #2
.(
	bcs skip1
	lda #hcStandLeft
	sta HeroAction
	jmp PlotHero
skip1	sta HeroX
.)
	jsr CalculateCorrectHeroYPOS
	lda HeroIndex
	clc
	adc #01
	cmp #10
.(
	bcc skip1
	lda #128
	sta HeroAction
	;This ensures hero returns to standing position, except if he keeps running it looks odd
	lda HeroStopped
	beq skip2
	lda #105
	sta HeroSprite
skip2	lda #00
skip1	sta HeroIndex
.)
	jsr PlotHero
	rts

havRunRight
	lda HeroIndex
	sta HeroSprite
	jsr DeleteHero
	ldx HeroIndex
	lda HeroX
	clc
	adc RunRightSteps,x
	cmp #37
.(
	bcc skip1
	lda #hcStandRight
	sta HeroAction
	jmp PlotHero
skip1	sta HeroX
.)
	jsr CalculateCorrectHeroYPOS
	lda HeroIndex
	clc
	adc #01
	cmp #10
.(
	bcc skip1
	;inc HeroX
	lda #128
	sta HeroAction
	lda HeroStopped
	beq skip2
	lda #98
	sta HeroSprite
skip2	lda #00
skip1	sta HeroIndex
.)
	jsr PlotHero
	rts


havRightTurnLeft
	lda HeroIndex
	clc
	adc #66
	sta HeroSprite

	;Whilst the single action of turning the hero to face left will not require any movment
	;steps, the sprites maybe different sizes and therefore the shift will change.
	cmp #67
.(
	bne skip2
	dec HeroX

skip2	jsr DeleteHero

	lda HeroIndex
	clc
	adc #01
	cmp #06
	bcc skip1
	lda #hcStandLeft
	sta HeroAction
	lda #00
	sta HeroFacing
	lda #00
skip1	sta HeroIndex
.)

	jsr PlotHero
	rts

havLeftTurnRight
	lda HeroIndex
	clc
	adc #60
	sta HeroSprite
	cmp #61
.(
	beq skip2
	cmp #64
	bne skip2
	inc HeroX
skip2	jsr DeleteHero
	lda HeroIndex
	clc
	adc #01
	cmp #06
	bcc skip1
	lda #hcStandRight
	sta HeroAction
	lda #01
	sta HeroFacing
	lda #00
skip1	sta HeroIndex
.)
	jsr PlotHero
	rts

havStandLeft
	jsr DeleteHero
	lda #105
	sta HeroSprite
	lda #128
	sta HeroAction
	jmp PlotHero
havStandRight
	jsr DeleteHero
	lda #98
	sta HeroSprite
	lda #128
	sta HeroAction
	jmp PlotHero

UseItem
	rts