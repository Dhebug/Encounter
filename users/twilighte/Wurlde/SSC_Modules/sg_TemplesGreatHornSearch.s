;sg_TemplesGreatHornSearch.s
;Requires wln_FirstLineWaterlineGraphic and therefore must always include Waterline.s in ssc

;Temple swims to reach Lucien and will then dive when lucien crouches(or tread water).
;If he dives at the exact xpos of the horn Temple will reappear holding the object
;otherwise he will reappear without.

;Called by SSC when the hero crouches - If Temple below hero then he must dive
SubGame_Interact
	;Is Temple directly below hero yet?
	lda TempleX
	cmp HeroX
.(
	bne skip1
	;Trigger Temple to Dive
	lda #1
	sta TempleSwimMode
	;Set Frame to one below start dive frame
	lda #5
	sta TempleFrame
skip1	rts
.)

SubGame_Run
	lda TempleFrac
	clc
	adc #48
	sta TempleFrac
.(
	bcc skip1
	;Is Temple beneath the waves searching?
	lda TempleSwimMode
	cmp #2
	bne skip2
	;Has Temple found horn?
	lda LocationID
	bne skip3
	lda TempleX
	cmp #23
	bne skip3
	;Temple has found horn - Eventually nice melody but for now move Temple off screen
	lda #1
	sta SubGameResult
	
skip3	;Temple did not find Horn - Reset Mode to treading again
	lda #00
	sta TempleSwimMode
	sta TempleFrame
	
skip2	lda TempleX
	bmi TempleInit
	jsr ControlTempleFrame
	jsr DeleteTemple
	jsr ControlTempleX
	jsr PlotTemple
skip1	rts
.)
TempleFrac	.byt 0
TempleInit
	lda SideApproachFlag
	bne ApproachFromRight
	beq ApproachFromLeft
	rts
	
ApproachFromRight
	lda #36
	sta TempleX
	rts
	
ApproachFromLeft
	lda #1
	sta TempleX
	rts

ControlTempleX
	;Has Temple got Horn?
	lda SubGameResult
	;0 Not got horn
	;1 found horn (move temple right till off screen)
	;2 found horn and off right
.(
	cmp #1
	beq skip3
	bcc skip2
	rts
skip3	;Move Temple Right until off screen
	inc TempleX
	lda TempleX
	cmp #36
	bcc skip1
	;Now flag Sub Game Result
	lda #02
	sta SubGameResult
	;And set Temple Swim mode to 2
	lda #2
	sta TempleSwimMode
	lda #16
	sta TempleFrame
	rts
		
skip2	lda TempleX
	cmp HeroX

	beq skip1
	bcc TempleRight
	bcs TempleLeft
skip1	rts

TempleRight
	inc TempleX
	rts
	
TempleLeft
	dec TempleX
	rts
.)
	
TempleSearchFrac	.byt 0	

ControlTempleFrame
	inc TempleFrame
	lda TempleFrame
	ldx TempleSwimMode
	cmp TempleSwimFrameHi,x
.(
	beq skip1
	bcc skip1
	;If Temple is at the end of diving, we must increment mode here
	lda TempleSwimMode
	cmp #1
	bne skip2
	inc TempleSwimMode
skip2	lda TempleSwimFrameLo,x
	sta TempleFrame
skip1	rts
.)	

TempleX		.byt 128
TempleFrame	.byt 0

DeleteTemple
	lda #<SeaGraphic
	sta source
	lda #>SeaGraphic
	sta source+1
	
	lda TempleX
	clc
	adc #<wln_WaterlineGraphic
	sta screen
	lda #>wln_WaterlineGraphic
	adc #00
	sta screen+1
	ldx #5
.(	
loop2	ldy #3
	
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	
	lda #4
	jsr ssc_AddSource
	jsr ssc_nl_screen
	
	dex
	bne loop2
.)
	rts

SeaGraphic
 .byt 64,64,64,64
 .byt 127,127,127,127
 .byt 64,64,64,64
 .byt 127,127,127,127
 .byt 64,64,64,64

PlotTemple
	ldx TempleFrame
	lda TempleFrameAddressLo,x
	sta source
	lda TempleFrameAddressHi,x
	sta source+1
	
	lda TempleX
	clc
	adc #<wln_WaterlineGraphic
	sta screen
	lda #>wln_WaterlineGraphic
	adc #00
	sta screen+1
	ldx #5
.(	
loop2	ldy #3
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	
	lda #4
	jsr ssc_AddSource
	jsr ssc_nl_screen
	
	dex
	bne loop2
.)
	rts
	
TempleSwimMode	.byt 0
TempleSwimFrameLo
 .byt 0	;Treading water
 .byt 6	;Diving
 .byt 16	;Searching
; .byt 15	;Found Horn
TempleSwimFrameHi
 .byt 5
 .byt 14
 .byt 16
; .byt 15

TempleFrameAddressLo
 .byt <TreadingWaterFrame0
 .byt <TreadingWaterFrame1
 .byt <TreadingWaterFrame2
 .byt <TreadingWaterFrame3
 .byt <TreadingWaterFrame4
 .byt <TreadingWaterFrame5
 .byt <TreadingWaterFrame5
 
 .byt <DiveFrame0
 .byt <DiveFrame1
 .byt <DiveFrame2
 .byt <DiveFrame3
 .byt <DiveFrame4
 .byt <DiveFrame5
 .byt <DiveFrame6
 .byt <DiveFrame7
 
 .byt <TempleWithAHornFrame
 .byt <SeaGraphic
TempleFrameAddressHi
 .byt >TreadingWaterFrame0	;0
 .byt >TreadingWaterFrame1
 .byt >TreadingWaterFrame2
 .byt >TreadingWaterFrame3
 .byt >TreadingWaterFrame4
 .byt >TreadingWaterFrame5
 .byt >TreadingWaterFrame5	;6
 
 .byt >DiveFrame0		;7
 .byt >DiveFrame1
 .byt >DiveFrame2
 .byt >DiveFrame3
 .byt >DiveFrame4
 .byt >DiveFrame5
 .byt >DiveFrame6
 .byt >DiveFrame7		;14
 
 .byt >TempleWithAHornFrame	;15
 .byt >SeaGraphic
;When Temple is waiting 4x5
TreadingWaterFrame0
 .byt $05,$46,$40,$40
 .byt $7F,$78,$7F,$7F
 .byt $40,$46,$40,$40
 .byt $7F,$7F,$7F,$7F
 .byt $40,$58,$70,$40
TreadingWaterFrame1
 .byt $05,$46,$40,$40
 .byt $7F,$78,$7F,$7F
 .byt $40,$46,$40,$40
 .byt $7F,$7F,$7F,$7F
 .byt $40,$68,$58,$40
TreadingWaterFrame2
 .byt $05,$46,$40,$40
 .byt $7F,$78,$7F,$7F
 .byt $40,$66,$48,$40
 .byt $7F,$7F,$7F,$7F
 .byt $41,$50,$46,$40
TreadingWaterFrame3
 .byt $05,$46,$40,$40
 .byt $7F,$78,$7F,$7F
 .byt $45,$46,$45,$60
 .byt $7F,$7F,$7F,$7F
 .byt $42,$60,$42,$40
TreadingWaterFrame4
 .byt $05,$46,$40,$40
 .byt $7F,$78,$7F,$7F
 .byt $48,$46,$41,$50
 .byt $7F,$7F,$7F,$7F
 .byt $44,$40,$40,$40
TreadingWaterFrame5
 .byt $05,$46,$40,$40
 .byt $7F,$78,$7F,$7F
 .byt $50,$46,$40,$40
 .byt $7F,$7F,$7F,$7F
 .byt $40,$40,$40,$40

DiveFrame0
 .byt $40,$40,$40,$40
 .byt $7F,$70,$7F,$7F
 .byt $01,$46,$40,$40
 .byt $7F,$66,$5F,$7F
 .byt $40,$50,$60,$40
DiveFrame1
 .byt $40,$40,$40,$40
 .byt $7F,$70,$7F,$7F
 .byt $01,$4B,$40,$40
 .byt $7F,$70,$7F,$7F
 .byt $01,$46,$40,$40
DiveFrame2
 .byt $01,$45,$40,$40
 .byt $7F,$78,$7F,$7F
 .byt $01,$42,$40,$40
 .byt $7F,$78,$7F,$7F
 .byt $01,$47,$40,$40
DiveFrame3
 .byt $07,$48,$40,$40
 .byt $7F,$78,$7F,$7F
 .byt $01,$45,$40,$40
 .byt $7F,$78,$7F,$7F
 .byt $01,$42,$40,$40
DiveFrame4
 .byt $40,$40,$40,$40
 .byt $7F,$7F,$7F,$7F
 .byt $07,$45,$40,$40
 .byt $7F,$7A,$7F,$7F
 .byt $01,$45,$40,$40
DiveFrame5
 .byt $40,$40,$40,$40
 .byt $7F,$7F,$7F,$7F
 .byt $07,$4A,$60,$40
 .byt $7F,$7A,$7F,$7F
 .byt $07,$45,$40,$40
DiveFrame6
 .byt $40,$40,$40,$40
 .byt $7F,$7F,$7F,$7F
 .byt $07,$51,$48,$40
 .byt $7F,$7A,$7F,$7F
 .byt $07,$48,$60,$40
DiveFrame7
 .byt $40,$40,$40,$40
 .byt $7F,$7F,$7F,$7F
 .byt $07,$60,$44,$40
 .byt $7F,$7F,$7F,$7F
 .byt $07,$40,$40,$40

TempleWithAHornFrame
 .byt $7F,$7F,$7F,$7F
 .byt $02,$78,$40,$40
 .byt $7F,$66,$5F,$7F
 .byt $01,$49,$40,$40
 .byt $7F,$70,$7F,$7F
 .byt $07,$56,$50,$40
