;Snow
;1)When rain, permit drips
;2)Extend history of particle to permit "strip" rain(Similar to Pulsoids pulse)
;3)At start drop one particle and after it overflows init it and a second(gradual)

ParticleColour	.byt 6
ParticleCount	.byt 63

InitParticle
	ldx ParticleCount
.(
loop1	jsr InitSingleParticle
	dex
	bpl loop1
.)
	rts
	
InitSingleParticle
	;Particle may start between 12-239,0 or 239,0-28(*2)
	lda #255
	jsr game_GetRNDRange
	cmp #220
.(
	bcs skip1
	;Particle is starting 6-233(X) and 0(Y)
	adc #12
	sta ParticleX,x
	lda #00
	sta ParticleY,x
	jmp skip2
skip1	;Particle is starting 239(X) and 0-55(Y)
	sbc #220
	sta ParticleY,x
	lda #232
	sta ParticleX,x
skip2	;Now disable visibility (until we are sure we can plot it)
.)
	sta ParticleVisible,x
	rts

ParticleDriver
	;First calculate Wind Frac (Placing Carry into 
	jsr ControlWind
	ldx ParticleCount
.(
loop1	lda ParticleVisible,x
	beq skip1
	jsr DeleteParticle
skip1	jsr NavigateParticle
	lda ParticleVisible,x
	beq skip2
	jsr PlotParticle
skip2	dex
	bpl loop1
.)
	rts

DeleteParticle
	ldy ParticleY,x
	lda Particle_sylocl,y
	sta screen
	lda Particle_syloch,y
	sta screen+1
	ldy ParticleX,x
	lda Particle_xloc,y
	tay
	iny
	lda #7
	sta (screen),y
	rts
	
NavigateParticle
	;Particle steadily descends but at varying frac left/right
	inc ParticleY,x
	lda ParticleX,x
	clc
	adc ParticleDirection
	sta ParticleX,x
	;Check Particle bounds
	cmp #6
	bcc InitSingleParticle
	cmp #240
	bcs InitSingleParticle
	lda ParticleY,x
	cmp #59
	bcs InitSingleParticle
	;Now check if Particle is visible
	ldy ParticleY,x
	lda Particle_vylocl,y
	sta screen
	lda Particle_vyloch,y
	sta screen+1
	ldy ParticleX,x
	lda Particle_xloc,y
	tay
	lda (screen),y	;First byte is colour
	cmp #127
	bne NotVisible
	iny
	lda (screen),y	;Second is where bit will go
	ldy ParticleX,x
	and Particle_bitpos,y
	and #%00111111
	beq NotVisible
	lda #1
	sta ParticleVisible,x
	rts
NotVisible
	lda #0
	sta ParticleVisible,x
	rts


PlotParticle
	ldy ParticleY,x
	lda Particle_sylocl,y
	sta screen
	lda Particle_syloch,y
	sta screen+1
	ldy ParticleX,x
	lda Particle_bitpos,y
	sta Particle_Temp01
	lda Particle_xloc,y
	tay
	lda ParticleColour
	sta (screen),y
	lda Particle_Temp01
	iny
	sta (screen),y
	rts

	

ControlWind
	lda #31
	jsr game_GetRNDRange
	adc SnowTemp
	sta SnowTemp
.(
	bcc skip1
	lda #3
	jsr game_GetRNDRange
	and #3
	beq skip2
;	sta ParticleCol+1
skip2	clc
	adc #252
	sta ParticleDirection
skip1	rts
.)

SnowTemp	.byt 0
ParticleDirection	.byt 0
Particle_Temp01	.byt 0
ParticleX
 .dsb 64,0
ParticleY
 .dsb 64,0
ParticleVisible
 .dsb 64,0
Particle_bitpos
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
 .byt %01100000,%01010000,%01001000,%01000100,%01000010,%01000001
Particle_xloc
 .dsb 6,0
 .dsb 6,1
 .dsb 6,2
 .dsb 6,3
 .dsb 6,4
 .dsb 6,5
 .dsb 6,6
 .dsb 6,7
 .dsb 6,8
 .dsb 6,9
 .dsb 6,10
 .dsb 6,11
 .dsb 6,12
 .dsb 6,13
 .dsb 6,14
 .dsb 6,15
 .dsb 6,16
 .dsb 6,17
 .dsb 6,18
 .dsb 6,19
 .dsb 6,20
 .dsb 6,21
 .dsb 6,22
 .dsb 6,23
 .dsb 6,24
 .dsb 6,25
 .dsb 6,26
 .dsb 6,27
 .dsb 6,28
 .dsb 6,29
 .dsb 6,30
 .dsb 6,31
 .dsb 6,32
 .dsb 6,33
 .dsb 6,34
 .dsb 6,35
 .dsb 6,36
 .dsb 6,37
 .dsb 6,38
 .dsb 6,39

Particle_sylocl
 .byt <$a780
 .byt <$a780+80*1
 .byt <$a780+80*2
 .byt <$a780+80*3
 .byt <$a780+80*4
 .byt <$a780+80*5
 .byt <$a780+80*6
 .byt <$a780+80*7
 .byt <$a780+80*8
 .byt <$a780+80*9
 .byt <$a780+80*10
 .byt <$a780+80*11
 .byt <$a780+80*12
 .byt <$a780+80*13
 .byt <$a780+80*14
 .byt <$a780+80*15
 .byt <$a780+80*16
 .byt <$a780+80*17
 .byt <$a780+80*18
 .byt <$a780+80*19
 .byt <$a780+80*20
 .byt <$a780+80*21
 .byt <$a780+80*22
 .byt <$a780+80*23
 .byt <$a780+80*24
 .byt <$a780+80*25
 .byt <$a780+80*26
 .byt <$a780+80*27
 .byt <$a780+80*28
 .byt <$a780+80*29
 .byt <$a780+80*30
 .byt <$a780+80*31
 .byt <$a780+80*32
 .byt <$a780+80*33
 .byt <$a780+80*34
 .byt <$a780+80*35
 .byt <$a780+80*36
 .byt <$a780+80*37
 .byt <$a780+80*38
 .byt <$a780+80*39
 .byt <$a780+80*40
 .byt <$a780+80*41
 .byt <$a780+80*42
 .byt <$a780+80*43
 .byt <$a780+80*44
 .byt <$a780+80*45
 .byt <$a780+80*46
 .byt <$a780+80*47
 .byt <$a780+80*48
 .byt <$a780+80*49
 .byt <$a780+80*50
 .byt <$a780+80*51
 .byt <$a780+80*52
 .byt <$a780+80*53
 .byt <$a780+80*54
 .byt <$a780+80*55
 .byt <$a780+80*56
 .byt <$a780+80*57
 .byt <$a780+80*58
 .byt <$a780+80*59
Particle_syloch
 .byt >$a780
 .byt >$a780+80*1
 .byt >$a780+80*2
 .byt >$a780+80*3
 .byt >$a780+80*4
 .byt >$a780+80*5
 .byt >$a780+80*6
 .byt >$a780+80*7
 .byt >$a780+80*8
 .byt >$a780+80*9
 .byt >$a780+80*10
 .byt >$a780+80*11
 .byt >$a780+80*12
 .byt >$a780+80*13
 .byt >$a780+80*14
 .byt >$a780+80*15
 .byt >$a780+80*16
 .byt >$a780+80*17
 .byt >$a780+80*18
 .byt >$a780+80*19
 .byt >$a780+80*20
 .byt >$a780+80*21
 .byt >$a780+80*22
 .byt >$a780+80*23
 .byt >$a780+80*24
 .byt >$a780+80*25
 .byt >$a780+80*26
 .byt >$a780+80*27
 .byt >$a780+80*28
 .byt >$a780+80*29
 .byt >$a780+80*30
 .byt >$a780+80*31
 .byt >$a780+80*32
 .byt >$a780+80*33
 .byt >$a780+80*34
 .byt >$a780+80*35
 .byt >$a780+80*36
 .byt >$a780+80*37
 .byt >$a780+80*38
 .byt >$a780+80*39
 .byt >$a780+80*40
 .byt >$a780+80*41
 .byt >$a780+80*42
 .byt >$a780+80*43
 .byt >$a780+80*44
 .byt >$a780+80*45
 .byt >$a780+80*46
 .byt >$a780+80*47
 .byt >$a780+80*48
 .byt >$a780+80*49
 .byt >$a780+80*50
 .byt >$a780+80*51
 .byt >$a780+80*52
 .byt >$a780+80*53
 .byt >$a780+80*54
 .byt >$a780+80*55
 .byt >$a780+80*56
 .byt >$a780+80*57
 .byt >$a780+80*58
 .byt >$a780+80*59

Particle_vylocl
 .byt <skybmask
 .byt <skybmask+40*1
 .byt <skybmask+40*2
 .byt <skybmask+40*3
 .byt <skybmask+40*4
 .byt <skybmask+40*5
 .byt <skybmask+40*6
 .byt <skybmask+40*7
 .byt <skybmask+40*8
 .byt <skybmask+40*9
 .byt <skybmask+40*10
 .byt <skybmask+40*11
 .byt <skybmask+40*12
 .byt <skybmask+40*13
 .byt <skybmask+40*14
 .byt <skybmask+40*15
 .byt <skybmask+40*16
 .byt <skybmask+40*17
 .byt <skybmask+40*18
 .byt <skybmask+40*19
 .byt <skybmask+40*20
 .byt <skybmask+40*21
 .byt <skybmask+40*22
 .byt <skybmask+40*23
 .byt <skybmask+40*24
 .byt <skybmask+40*25
 .byt <skybmask+40*26
 .byt <skybmask+40*27
 .byt <skybmask+40*28
 .byt <skybmask+40*29
 .byt <skybmask+40*30
 .byt <skybmask+40*31
 .byt <skybmask+40*32
 .byt <skybmask+40*33
 .byt <skybmask+40*34
 .byt <skybmask+40*35
 .byt <skybmask+40*36
 .byt <skybmask+40*37
 .byt <skybmask+40*38
 .byt <skybmask+40*39
 .byt <skybmask+40*40
 .byt <skybmask+40*41
 .byt <skybmask+40*42
 .byt <skybmask+40*43
 .byt <skybmask+40*44
 .byt <skybmask+40*45
 .byt <skybmask+40*46
 .byt <skybmask+40*47
 .byt <skybmask+40*48
 .byt <skybmask+40*49
 .byt <skybmask+40*50
 .byt <skybmask+40*51
 .byt <skybmask+40*52
 .byt <skybmask+40*53
 .byt <skybmask+40*54
 .byt <skybmask+40*55
 .byt <skybmask+40*56
 .byt <skybmask+40*57
 .byt <skybmask+40*58
 .byt <skybmask+40*59
Particle_vyloch
 .byt >skybmask
 .byt >skybmask+40*1
 .byt >skybmask+40*2
 .byt >skybmask+40*3
 .byt >skybmask+40*4
 .byt >skybmask+40*5
 .byt >skybmask+40*6
 .byt >skybmask+40*7
 .byt >skybmask+40*8
 .byt >skybmask+40*9
 .byt >skybmask+40*10
 .byt >skybmask+40*11
 .byt >skybmask+40*12
 .byt >skybmask+40*13
 .byt >skybmask+40*14
 .byt >skybmask+40*15
 .byt >skybmask+40*16
 .byt >skybmask+40*17
 .byt >skybmask+40*18
 .byt >skybmask+40*19
 .byt >skybmask+40*20
 .byt >skybmask+40*21
 .byt >skybmask+40*22
 .byt >skybmask+40*23
 .byt >skybmask+40*24
 .byt >skybmask+40*25
 .byt >skybmask+40*26
 .byt >skybmask+40*27
 .byt >skybmask+40*28
 .byt >skybmask+40*29
 .byt >skybmask+40*30
 .byt >skybmask+40*31
 .byt >skybmask+40*32
 .byt >skybmask+40*33
 .byt >skybmask+40*34
 .byt >skybmask+40*35
 .byt >skybmask+40*36
 .byt >skybmask+40*37
 .byt >skybmask+40*38
 .byt >skybmask+40*39
 .byt >skybmask+40*40
 .byt >skybmask+40*41
 .byt >skybmask+40*42
 .byt >skybmask+40*43
 .byt >skybmask+40*44
 .byt >skybmask+40*45
 .byt >skybmask+40*46
 .byt >skybmask+40*47
 .byt >skybmask+40*48
 .byt >skybmask+40*49
 .byt >skybmask+40*50
 .byt >skybmask+40*51
 .byt >skybmask+40*52
 .byt >skybmask+40*53
 .byt >skybmask+40*54
 .byt >skybmask+40*55
 .byt >skybmask+40*56
 .byt >skybmask+40*57
 .byt >skybmask+40*58
 .byt >skybmask+40*59

skybmask
 .byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7e,$40,$5f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$40,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$40,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7c,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7e,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$70,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7e,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $7f,$7f,$7f,$63,$7c,$40,$4f,$7f
	.byt $70,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$7f,$7f,$7f
	.byt $7f,$7e,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $7f,$71,$7f,$41,$7c,$40,$4f,$70
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7e,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $7f,$70,$5c,$40,$5e,$40,$5f,$70
	.byt $40,$40,$40,$40,$40,$40,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7e,$40,$40,$40,$40,$40,$40
	.byt $7f,$7c,$4c,$40,$5e,$40,$40,$40
	.byt $40,$40,$40,$40,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7e,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7e,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7e,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40
	.byt $47,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$43
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7e,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$5f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40
	.byt $40,$40,$40,$40,$40,$40,$41,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40
	.byt $40,$40,$40,$40,$40,$40,$47,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40
	.byt $40,$40,$40,$40,$40,$40,$5f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40
	.byt $40,$40,$40,$40,$40,$40,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7e,$40
	.byt $40,$40,$40,$40,$40,$43,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7e,$40
	.byt $40,$40,$40,$40,$40,$47,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70
	.byt $40,$40,$40,$40,$40,$4f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70
	.byt $40,$40,$40,$40,$40,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $40,$40,$40,$40,$41,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $40,$40,$40,$40,$43,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $40,$40,$40,$40,$47,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $40,$40,$40,$40,$47,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $40,$40,$40,$40,$4f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $40,$40,$40,$40,$4f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $40,$40,$40,$40,$4f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt $40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40

