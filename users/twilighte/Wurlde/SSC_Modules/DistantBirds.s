;Distant Birds
;Masked against BGB


	 
ProcDBird
	ldx dbird_count
dbird_loop
	lda dbird_active,x
	beq dbird_CheckForNew
	;Delete dbird
	jsr dbird_Delete
	;Move dbird
	jsr Navigatedbird
	;Check if bird still active
	lda dbird_active,x
	beq dbird_skip1
	;calculate screen location (can use xloc in y) and record it
	ldy dbird_x,x
	lda dbird_xloc,y
	pha
	ldy dbird_y,x
	clc
	adc dbird_SYLocl,y
	sta screen
	sta old_slocl,x
	lda dbird_SYLoch,y
	adc #00
	sta screen+1
	sta old_sloch,x
	;record bitmap in bgbuffer for this location
	pla
	sbc #00
	clc
	adc game_bgbylocl,y
	sta dbird_bgb+1
	lda game_bgbyloch,y
	adc #00
	sta dbird_bgb+2
dbird_bgb	lda $dead
	sta old_bg,x
	;Check that screen loc is a bitmap
	ldy #00
	lda (screen),y
	bmi dbird_skip1
	cmp #64
	bcc dbird_skip1
	;mask screen with dbird's bitpos
	ldy dbird_x,x
	lda dbirdmask_xbit,y
	ldy #00
	and (screen),y
	sta (screen),y
dbird_skip1
	;proceed to next dbird
	dex
	bpl dbird_loop
	rts

dbird_CheckForNew
	;We also need a random event to stall the generation of new birds for a random period (up to minute)
	dec dbird_StallOffPeriodLo
	bne dbird_skip4
	dec dbird_StallOffPeriodHi
	bne dbird_skip4

	lda #255
	jsr game_GetRNDRange
	sta dbird_StallOffPeriodLo
	lda #31
	jsr game_GetRNDRange
	adc #05
	sta dbird_StallOffPeriodHi
	lda dbird_StallingFlag
	eor #1
	sta dbird_StallingFlag
	
dbird_skip4	
	lda dbird_StallingFlag
	beq dbird_skip1
	
	;
	lda #63
	jsr game_GetRNDRange
	cmp #60
	bcc dbird_skip2
	;Initialise new bird here - Some birds may fly west, others east.
	cmp #63
	bne dbird_skip6
	lda dbird_LeftStartX
	sta dbird_x,x
	lda #2
	sta dbird_stepx,x
	;Reset old BG
	lda dbird_DefaultLeftBG
	sta old_bg,x
	jmp dbird_skip5
dbird_skip6
	lda dbird_RightStartX
	sta dbird_x,x
	lda #254
	sta dbird_stepx,x
	;Reset old BG
	lda dbird_DefaultRightBG
	sta old_bg,x
dbird_skip5
	lda dbird_ycount
	clc
	adc #1
	cmp dbird_HeightRange
	bcc dbird_skip3
	lda #00
dbird_skip3
	sta dbird_ycount
	clc
	adc dbird_StartY
	sta dbird_y,x

	;Activate dbird
	lda #1
	sta dbird_active,x
dbird_skip2
	jmp dbird_skip1


dbird_Delete
	ldy dbird_y,x
	lda dbird_SYLocl,y
	sta screen
	lda dbird_SYLoch,y
	sta screen+1
	ldy dbird_x,x
	lda dbird_xloc,y
	tay
	lda old_bg,x
	sta (screen),y
	rts


Navigatedbird
	;Move Bird
	lda dbird_x,x
	adc dbird_stepx,x
	sta dbird_x,x
	
	;Check on borders
	lda dbird_x,x
	cmp #6
	bcc dbird_Stop
	cmp dbird_RightStartX
	bcs dbird_Stop
	
	rts

dbird_Stop
	lda #00
	sta dbird_active,x
	rts
	
dbird_StallOffPeriodLo
 .byt 0
dbird_StallOffPeriodHi
 .byt 3
dbird_StallingFlag
 .byt 0
dbird_ycount
 .byt 0
dbird_active
 .dsb 16,0
dbird_x
 .dsb 16,0
dbird_stepx
 .dsb 16,0
dbird_y
 .dsb 16,0
old_slocl
 .dsb 16,<$BFE0
old_sloch
 .dsb 16,>$BFE0
old_bg
 .dsb 16,255

dbirdmask_xbit
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
dbird_xloc
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

dbird_SYLocl
 .byt <$a758
 .byt <$a758+80*1
 .byt <$a758+80*2
 .byt <$a758+80*3
 .byt <$a758+80*4
 .byt <$a758+80*5
 .byt <$a758+80*6
 .byt <$a758+80*7
 .byt <$a758+80*8
 .byt <$a758+80*9
 .byt <$a758+80*10
 .byt <$a758+80*11
 .byt <$a758+80*12
 .byt <$a758+80*13
 .byt <$a758+80*14
 .byt <$a758+80*15
 .byt <$a758+80*16
 .byt <$a758+80*17
 .byt <$a758+80*18
 .byt <$a758+80*19
 .byt <$a758+80*20
 .byt <$a758+80*21
 .byt <$a758+80*22
 .byt <$a758+80*23
 .byt <$a758+80*24
 .byt <$a758+80*25
 .byt <$a758+80*26
 .byt <$a758+80*27
 .byt <$a758+80*28
 .byt <$a758+80*29
 .byt <$a758+80*30
 .byt <$a758+80*31
 .byt <$a758+80*32
 .byt <$a758+80*33
 .byt <$a758+80*34
 .byt <$a758+80*35
 .byt <$a758+80*36
 .byt <$a758+80*37
 .byt <$a758+80*38
 .byt <$a758+80*39
 .byt <$a758+80*40
 .byt <$a758+80*41
 .byt <$a758+80*42
 .byt <$a758+80*43
 .byt <$a758+80*44
 .byt <$a758+80*45
 .byt <$a758+80*46
 .byt <$a758+80*47
 .byt <$a758+80*48
 .byt <$a758+80*49
 .byt <$a758+80*50
 .byt <$a758+80*51
 .byt <$a758+80*52
 .byt <$a758+80*53
 .byt <$a758+80*54
 .byt <$a758+80*55
 .byt <$a758+80*56
 .byt <$a758+80*57
 .byt <$a758+80*58
 .byt <$a758+80*59
dbird_SYLoch
 .byt >$a758
 .byt >$a758+80*1
 .byt >$a758+80*2
 .byt >$a758+80*3
 .byt >$a758+80*4
 .byt >$a758+80*5
 .byt >$a758+80*6
 .byt >$a758+80*7
 .byt >$a758+80*8
 .byt >$a758+80*9
 .byt >$a758+80*10
 .byt >$a758+80*11
 .byt >$a758+80*12
 .byt >$a758+80*13
 .byt >$a758+80*14
 .byt >$a758+80*15
 .byt >$a758+80*16
 .byt >$a758+80*17
 .byt >$a758+80*18
 .byt >$a758+80*19
 .byt >$a758+80*20
 .byt >$a758+80*21
 .byt >$a758+80*22
 .byt >$a758+80*23
 .byt >$a758+80*24
 .byt >$a758+80*25
 .byt >$a758+80*26
 .byt >$a758+80*27
 .byt >$a758+80*28
 .byt >$a758+80*29
 .byt >$a758+80*30
 .byt >$a758+80*31
 .byt >$a758+80*32
 .byt >$a758+80*33
 .byt >$a758+80*34
 .byt >$a758+80*35
 .byt >$a758+80*36
 .byt >$a758+80*37
 .byt >$a758+80*38
 .byt >$a758+80*39
 .byt >$a758+80*40
 .byt >$a758+80*41
 .byt >$a758+80*42
 .byt >$a758+80*43
 .byt >$a758+80*44
 .byt >$a758+80*45
 .byt >$a758+80*46
 .byt >$a758+80*47
 .byt >$a758+80*48
 .byt >$a758+80*49
 .byt >$a758+80*50
 .byt >$a758+80*51
 .byt >$a758+80*52
 .byt >$a758+80*53
 .byt >$a758+80*54
 .byt >$a758+80*55
 .byt >$a758+80*56
 .byt >$a758+80*57
 .byt >$a758+80*58
 .byt >$a758+80*59
