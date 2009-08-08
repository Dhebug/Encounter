;FOUNTAIN.S
;Generate Water particles using fractional stepping to create realistic and multi-angled droplets

GenerateFountain
	ldx fountain_count
.(
loop1	lda Droplet_Activity,x
	beq skip1
	jsr DeleteDroplet
	jsr MoveDroplet
	jsr ValidateDroplet
skip1	lda Droplet_Activity,x
	beq skip2
	jsr PlotDroplet
rent1	dex
	bpl loop1
	rts
skip2	;Generate New Droplet
	jsr GenerateNewDroplet	
	jmp rent1
.)

	
DeleteDroplet
	ldy droplet_x,x
	lda droplet_xloc,y
	clc
	ldy droplet_y,x
	adc droplet_ylocl,y
	sta screen
	lda droplet_yloch,y
	adc #00
	sta screen+1
	ldy droplet_x,x
	lda #64	;droplet_bitpos,y
;	eor #63
	ldy #00
	sta (screen),y
	rts
	
MoveDroplet
	;Control X
	lda droplet_x,x
	clc
	adc droplet_xstep,x
	sta droplet_x,x
	
	;Control Y
	lda droplet_y,x
	clc
	adc droplet_ystep,x
	sta droplet_y,x
	
	;Control Gravity (Y)
	lda droplet_gravity_frac,x
	adc droplet_gravity_heightfrac,x	;This may be related to Gravity
	sta droplet_gravity_frac,x
	;ystep may initially be -2 and will then range -2 to +2 being held in memory as 254,255,0,1,2
	lda droplet_ystep,x
	adc #00
	sta droplet_ystep,x
	rts

	
ValidateDroplet
	lda droplet_y,x
	cmp fountain_ground
.(
	bcc skip1
	lda #0
	sta Droplet_Activity,x
skip1	rts
.)

PlotDroplet
	ldy droplet_x,x
	lda droplet_xloc,y
	clc
	ldy droplet_y,x
	adc droplet_ylocl,y
	sta screen
	lda droplet_yloch,y
	adc #00
	sta screen+1
	ldy #00
	lda (screen),y
	sta droplet_oldbg,x
	ldy droplet_x,x
	lda droplet_bitpos,y
	ldy #00
	sta (screen),y
	rts

GenerateNewDroplet
	lda #1
	sta Droplet_Activity,x
	;Reset position of droplet
	lda fountain_xorigin
	sta droplet_x,x
	lda fountain_yorigin
	sta droplet_y,x
	;Randomise Frac
	lda #255
	jsr game_GetRNDRange
	sta droplet_gravity_frac,x
	;Reset YStep to 254
	lda #254
	sta droplet_ystep,x
	;Randomise XStep to 255 or 1
	lda via_t1cl
	and #2
	sec
	sbc #1
	sta droplet_xstep,x
	;Randomise gravity additive between 48 and 63
	lda #15
	jsr game_GetRNDRange
	adc #48
	sta droplet_gravity_heightfrac,x
	rts

Droplet_Activity
 .dsb 32,0
	
droplet_y
 .dsb 32,0
droplet_ystep	;254,255,0,1,2
 .dsb 32,0
droplet_gravity_frac
 .dsb 32,0
droplet_gravity_heightfrac
 .dsb 32,0

droplet_x
 .dsb 32,0
droplet_xstep	;255 or 1
 .dsb 32,0

droplet_oldbg
 .dsb 32,64
 
droplet_bitpos
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 .byt %01100000
 .byt %01010000
 .byt %01001000
 .byt %01000100
 .byt %01000010
 .byt %01000001
 
droplet_xloc
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

droplet_ylocl
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
droplet_yloch
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
