;MainShaftLift.s - Routines for the main shaft lift

;01)Ethan exits the room.
;02)eye closes room
;03)complete shaft map is written to BGBuffer
;    bgbuffer is 6000(40x150)
;    Shaft map is 33x(25x8) == 6600 (So bgbuffer is expanded by 600 bytes)
;04)Shaft Map is rendered starting at 0,(ComplexY-9)
;05)Collision Map for current view is generated
;06)Ethan can now run around corridor and into lift
;07)Lift can move up or down shaft map freely! only stopping when reaching next corridor

DrawMap
;	nop
;	jmp DrawMap
	lda ComplexX
	sta RoomsMapIndex
	lda #0
	sta RoomsMapRowCounter
	lda #4
	sta LiftBrickStyle
.(
loop1	;Branch to plot map on each levels type
	ldx RoomsMapIndex
	lda RoomsMap,x
	cmp #$FF
	beq skip1
	and #127
	tay
	lda PlotMapCodeVectorLo-57,y
	sta vector1+1
	lda PlotMapCodeVectorHi-57,y
	sta vector1+2
	ldx RoomsMapRowCounter
	lda RoomsMapRowInBGBufferAddressLo,x
	sta source
	lda RoomsMapRowInBGBufferAddressHi,x
	sta source+1
vector1	jsr $dead
	lda RoomsMapIndex
	clc
	adc #13
	sta RoomsMapIndex
	inc RoomsMapRowCounter
	lda RoomsMapRowCounter
	cmp #8
	bcc loop1
skip1	rts
.)

RoomsMapRowInBGBufferAddressLo
 .byt <BGBuffer
 .byt <BGBuffer+825*1
 .byt <BGBuffer+825*2
 .byt <BGBuffer+825*3
 .byt <BGBuffer+825*4
 .byt <BGBuffer+825*5
 .byt <BGBuffer+825*6
 .byt <BGBuffer+825*7
RoomsMapRowInBGBufferAddressHi
 .byt >BGBuffer
 .byt >BGBuffer+825*1
 .byt >BGBuffer+825*2
 .byt >BGBuffer+825*3
 .byt >BGBuffer+825*4
 .byt >BGBuffer+825*5
 .byt >BGBuffer+825*6
 .byt >BGBuffer+825*7
	
PlotMapCodeVectorLo
 .byt <PlotCodeShaft    	;57 shm_Shaft
 .byt <PlotCodeShaftTL  	;58 shm_ShaftTL
 .byt <PlotCodeShaftTR  	;59 shm_ShaftTR
 .byt <PlotCodeShaftBL  	;60 shm_ShaftBL
 .byt <PlotCodeShaftBR  	;61 shm_ShaftBR
 .byt <PlotCodeShaftTLTR	;62 shm_ShaftTLTR
 .byt <PlotCodeShaftTLBR	;63 shm_ShaftTLBR
 .byt <PlotCodeShaftBLTR	;64 shm_ShaftBLTR
 .byt <PlotCodeShaftBLBR	;65 shm_ShaftBLBR
PlotMapCodeVectorHi
 .byt >PlotCodeShaft    	;57 shm_Shaft
 .byt >PlotCodeShaftTL  	;58 shm_ShaftTL
 .byt >PlotCodeShaftTR  	;59 shm_ShaftTR
 .byt >PlotCodeShaftBL  	;60 shm_ShaftBL
 .byt >PlotCodeShaftBR  	;61 shm_ShaftBR
 .byt >PlotCodeShaftTLTR	;62 shm_ShaftTLTR
 .byt >PlotCodeShaftTLBR	;63 shm_ShaftTLBR
 .byt >PlotCodeShaftBLTR	;64 shm_ShaftBLTR
 .byt >PlotCodeShaftBLBR	;65 shm_ShaftBLBR
	
PlotCodeShaft    	;57 shm_Shaft
	;Plot 25 Rows of Shaft
	lda #25
	jmp PlotRowsOfShaft
PlotCodeShaftTL  	;58 shm_ShaftTL
	;Plot 4 Rows of shaft
	lda #4
	jsr PlotRowsOfShaft
	;Plot Left Corridor (6 rows)
	jsr PlotLeftCorridor
	;Plot 15 Rows of shaft
	lda #15
	jmp PlotRowsOfShaft
PlotCodeShaftTR  	;59 shm_ShaftTR
	;Plot 4 Rows of shaft
	lda #4
	jsr PlotRowsOfShaft
	;Plot Right Corridor (6 rows)
	jsr PlotRightCorridor
	;Plot 15 Rows of shaft
	lda #15
	jmp PlotRowsOfShaft
PlotCodeShaftBL  	;60 shm_ShaftBL
	;Plot 15 Rows of shaft
	lda #15
	jsr PlotRowsOfShaft
	;Plot Left Corridor (6 rows)
	jsr PlotLeftCorridor
	;Plot 4 Rows of shaft
	lda #4
	jmp PlotRowsOfShaft
PlotCodeShaftBR  	;61 shm_ShaftBR
	;Plot 15 Rows of shaft
	lda #15
	jsr PlotRowsOfShaft
	;Plot Right Corridor (6 rows)
	jsr PlotRightCorridor
	;Plot 4 Rows of shaft
	lda #4
	jmp PlotRowsOfShaft
PlotCodeShaftTLTR	;62 shm_ShaftTLTR
	;Plot 4 Rows of shaft
	lda #4
	jsr PlotRowsOfShaft
	;Plot Left&Right Corridor (6 rows)
	jsr PlotLeftAndRightCorridor
	;Plot 15 Rows of shaft
	lda #15
	jmp PlotRowsOfShaft
PlotCodeShaftTLBR	;63 shm_ShaftTLBR
	;Plot 4 Rows of shaft
	lda #4
	jsr PlotRowsOfShaft
	;Plot Left Corridor (6 rows)
	jsr PlotLeftCorridor
	;Plot 5 Rows of shaft
	lda #5
	jsr PlotRowsOfShaft
	;Plot Right Corridor (6 rows)
	jsr PlotRightCorridor
	;Plot 4 Rows of shaft
	lda #4
	jmp PlotRowsOfShaft
PlotCodeShaftBLTR	;64 shm_ShaftBLTR
	;Plot 4 Rows of shaft
	lda #4
	jsr PlotRowsOfShaft
	;Plot Right Corridor (6 rows)
	jsr PlotRightCorridor
	;Plot 5 Rows of shaft
	lda #5
	jsr PlotRowsOfShaft
	;Plot Left Corridor (6 rows)
	jsr PlotLeftCorridor
	;Plot 4 Rows of shaft
	lda #4
	jmp PlotRowsOfShaft
PlotCodeShaftBLBR	;65 shm_ShaftBLBR
	;Plot 15 Rows of shaft
	lda #15
	jsr PlotRowsOfShaft
	;Plot Left&Right Corridor (6 rows)
	jsr PlotLeftAndRightCorridor
	;Plot 4 Rows of shaft
	lda #4
	jmp PlotRowsOfShaft
	
PlotRowsOfShaft	;to source(33xA) then add 165 to source
	sta RowCounter
	
.(	
loop2	ldy #32
	lda LiftBrickStyle
	eor #1
	sta LiftBrickStyle
loop1	lda LiftBrickStyle
	ldx LiftShaftRowTemplate,y
	bpl skip1
	;Generate random earth
	jsr GetRandomNumber
	and #3
skip1	sta (source),y
	dey
	bpl loop1
	
	lda #33
	jsr AddSource
	
	dec RowCounter
	bne loop2
.)
	rts

;128==Earth
;0  ==Brick
LiftShaftRowTemplate
 .dsb 16,128
 .byt 0,0
 .dsb 15,128
PlotLeftCorridor
	lda #<LeftCorridorMap
	sta screen
	lda #>LeftCorridorMap
plcRent1	sta screen+1
	
	ldx #6
.(	
loop2	ldy #32
loop1	lda (screen),y
	sta (source),y
	dey
	bpl loop1
	
	lda #33
	jsr AddSource
	lda #33
	jsr AddScreen
	
	dex
	bne loop2
.)
	rts
PlotRightCorridor
	lda #<RightCorridorMap
	sta screen
	lda #>RightCorridorMap
	jmp plcRent1
PlotLeftAndRightCorridor
	lda #<BothCorridorMap
	sta screen
	lda #>BothCorridorMap
	jmp plcRent1

RenderLiftShaftScreen
	;Also generate Collision map
;	nop
;	jmp RenderLiftShaftScreen
	lda ComplexY
	sec
	sbc #9
.(
	bcs skip1
	lda #0
skip1	tay
.)
	lda BGBuffer_LiftShaftRowAddressLo,y	;0-199
.(
	sta vector1+1
	lda BGBuffer_LiftShaftRowAddressHi,y
	sta vector1+2
	
	lda #<$A000
	sta screen
	lda #>$A000
	sta screen+1

	lda #25
	sta RowCounter
;	lda #>MainShaftCharacters
;	sta chars+1
	clc
loop2	ldx #32
	
loop1	;Fetch character Code
vector1	lda $dead,x
	
	;Fetch character code Address (Characters are organised into 40 column format) and on a page boundary
	sta chars
	
	tay
	lda MainShaftCharacters00,y
	ldy ScreenOffset000,x
	sta (screen),y
	ldy chars
	lda MainShaftCharacters01,y
	ldy ScreenOffset040,x
	sta (screen),y
	ldy chars
	lda MainShaftCharacters02,y
	ldy ScreenOffset080,x
	sta (screen),y
	ldy chars
	lda MainShaftCharacters03,y
	ldy ScreenOffset120,x
	sta (screen),y
	ldy chars
	lda MainShaftCharacters04,y
	ldy ScreenOffset160,x
	sta (screen),y
	ldy chars
	lda MainShaftCharacters05,y
	ldy ScreenOffset200,x
	sta (screen),y
	
	dex
	bpl loop1
	
	lda #240
	adc screen
	sta screen
	bcc skip1
	inc screen+1
	clc
skip1	lda vector1+1
	adc #33
	sta vector1+1
	bcc skip2
	inc vector1+2
	clc
skip2	dec RowCounter
	bne loop2
.)	
	rts	
ScreenOffset000
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
 .byt 24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39	
ScreenOffset040
 .byt 41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57
 .byt 64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79
ScreenOffset080
 .byt 81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97
 .byt 104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119
ScreenOffset120
 .byt 121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137
 .byt 144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159	
ScreenOffset160
 .byt 161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177
 .byt 184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199	
ScreenOffset200
 .byt 201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217
 .byt 224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239	


;25 in all
;|   4
;-   6
;|   5
;-   6
;|   4

;03)StrongholdEthanX/Y reads from score screen map the corridors (or refreshes when in new area).
;04)Shaft, lift and corridors drawn to bgb.
;05)eye opens shaft (from bgb to screen)
;06)Ethan now navigates corridor to lift or another room
;07)Ethan moves down in lift
;08)SCREEN SCROLLS TO NEXT LEVEL!

ExitRoom
	;02)Eye Close Room
	jsr EyeCloseRoom
	;03)StrongholdEthanX/Y reads from score screen map the corridors (or refreshes when in new area).
	
	;For the moment, position ethan in corridor
	lda #62
	sta EthanY
	lda #20
	sta EthanX
	lda #4
	sta EthansCurrentLevel

	
	
	
	;04)Shaft, lift and corridors drawn to bgb.
;	jsr DrawMap
	jsr DisplayLift
	jsr DrawLiftShaftCollisionMap
	jsr UpdateBlob
	;05)eye opens shaft (from bgb to screen)
;	jsr EyeOpenRoom
	jsr RenderLiftShaftScreen

;	jsr TestOverlayCollisionMapOnScreen
;twi99	nop
;	jmp twi99

	jsr PlotEthanUsingLocalBGB
MainLiftShaftStart
.(
loop1	;06)Ethan now navigates corridor to lift or another room
	lda EthanDelay
	bne loop1
	lda #3
	sta EthanDelay
	jsr ControlEthan
	jsr GlowBlob
	lda InputRegister
	;07)Ethan moves up/down in lift
	cmp #CONTROLLER_UP
	beq MoveLiftUp
	cmp #CONTROLLER_DOWN
	bne loop1
.)
MoveLiftDown	;Which means scroll up
	;Move lift down until it reaches end or another corridor
.(
loop1	;Check for selected change in direction
	lda InputRegister
	cmp #CONTROLLER_UP
	beq MainLiftShaftStart
	lda ComplexY
	clc
	adc #1
	;Check for absolute end of shaft (row 9)
	cmp #199-15
	bcs skip1
	sta ComplexY
	jsr RenderLiftShaftScreen
	jsr UpdateBlob
	;Check for Corridor Intersection
	ldy ComplexY
	lda BGBuffer_LiftShaftRowAddressLo,y
	sta source
	lda BGBuffer_LiftShaftRowAddressHi,y
	sta source+1
	;Check for Left intersection
	ldy #00
	lda (source),y
	cmp #6
	beq skip1
	;Check for right intersection
	ldy #32
	lda (source),y
	cmp #6
	bne loop1
skip1	;Draw collision map for current view
	jsr DrawLiftShaftCollisionMap
	jmp MainLiftShaftStart
.)	

MoveLiftUp
	;
.(
loop1	;Check for selected change in direction
	lda InputRegister
	cmp #CONTROLLER_DOWN
	beq MainLiftShaftStart
	lda ComplexY
	sec
	sbc #1
	cmp #9
	bcc skip1
	sta ComplexY
	jsr RenderLiftShaftScreen
	jsr UpdateBlob
	;Check for Corridor Intersection
	ldy ComplexY
	lda BGBuffer_LiftShaftRowAddressLo,y
	sta source
	lda BGBuffer_LiftShaftRowAddressHi,y
	sta source+1
	;Check for Left intersection
	ldy #00
	lda (source),y
	cmp #6
	beq skip1
	;Check for right intersection
	ldy #32
	lda (source),y
	cmp #6
	bne loop1
skip1	jsr DrawLiftShaftCollisionMap
	jmp MainLiftShaftStart
.)	

;
DrawLiftShaftCollisionMap
	;1) The lift has reached the end of the shaft (No corridors but ground and ceiling)
	;2) Left corridor only
	;3) Right corridor only
	;4) Both Corridors

;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;R                                     R
;R                                     R
;R                                     R
;R                                     R
;R                                     R
;pppppppppppppppppppllpppppppppppppppppp
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000
;000000000000000000000000000000000000000

	;It would be really cool if we could also store the room id in the map at the end of each corridor
	
	;Draw default map(Fill with Wall)
	lda #0
	sta Object_X
	sta Object_Y
	lda #COL_WALL
	sta Object_V
	lda #40
	sta Object_W
	lda #25
	sta Object_H
	jsr PlotCollisionObject
	
	;Examine Lift map to establish what corridors exist here
	ldy ComplexY
	lda BGBuffer_LiftShaftRowAddressLo,y
	sta source
	lda BGBuffer_LiftShaftRowAddressHi,y
	sta source+1
	;Check for Left intersection
	ldy #00
	lda (source),y
	cmp #6
.(
	bne skip1
	jsr PlotLeftCorridorInCollisionMap
skip1	;Check for right intersection
.)
	ldy #32
	lda (source),y
	cmp #6
.(
	bne skip1
	jsr PlotRightCorridorInCollisionMap
skip1	;Always draw Lift Compartment in collision map too
.)
DrawLiftCompartment
	;Draw Lift space
	lda #17
	sta Object_X
	lda #10*6
	sta Object_Y
	lda #6
	sta Object_W
	lda #5
	sta Object_H
	lda #00
	sta Object_V
	jsr PlotCollisionObject
	
	;Draw Lift floor
	lda #COL_PLATFORM
	sta CollisionMap+19+40*15
	sta CollisionMap+22+40*15
	lda #COL_MAINFOYERLIFT
	sta CollisionMap+20+40*15
	sta CollisionMap+21+40*15
	rts
PlotLeftCorridorInCollisionMap
	;Empty Corridor
	lda #1
	sta Object_X
	lda #60
	sta Object_Y
	lda #COL_BACKGROUND
	sta Object_V
	lda #18
	sta Object_W
	lda #5
	sta Object_H
	jsr PlotCollisionObject
	
	;Plot Floor(platform)
	lda #90
	sta Object_Y
	lda #1
	sta Object_H
	lda #COL_PLATFORM
	sta Object_V
	jsr PlotCollisionObject
	
	;Plot Room Column
	lda #1
	sta Object_X
	lda #60
	sta Object_Y
	lda #1
	sta Object_W
	lda #5
	sta Object_H
	lda #COL_ENTRANCE	;Left Room here
	sta Object_V
	jmp PlotCollisionObject
		
PlotRightCorridorInCollisionMap
	;Empty Corridor
	lda #23
	sta Object_X
	lda #60
	sta Object_Y
	lda #COL_BACKGROUND
	sta Object_V
	lda #17
	sta Object_W
	lda #5
	sta Object_H
	jsr PlotCollisionObject
	
	;Plot Floor(platform)
	lda #90
	sta Object_Y
	lda #1
	sta Object_H
	lda #COL_PLATFORM
	sta Object_V
	jsr PlotCollisionObject
	
	;Plot Room Column
	lda #39
	sta Object_X
	lda #60
	sta Object_Y
	lda #1
	sta Object_W
	lda #5
	sta Object_H
	lda #COL_ENTRANCE	;Right room here
	sta Object_V
	jmp PlotCollisionObject

DisplayLift
	;Display Lift
	lda #54
	sta Object_Y
	lda #18
	sta Object_X
	lda #MAINSHAFTLIFTGFX
	sta Object_V
	jsr DisplayGraphicObject
	
	;Display Lifts Cable
	lda #26
	sta Object_R
	lda #00
	sta Object_Y
	lda #MAINSHAFTLIFTCABLES
	sta Object_V
	lda #REPEATOBJECTDOWN
	sta Object_D
	jmp RepeatDisplayGraphicObject

UpdateBlob
	;Remove previous blob

	;blob points to Room to the left of blob
	ldy #00
	ldx #$C0
	lda (blob),y
	;If room contains inverse attribute the write $C0
.(
	bmi skip1
	ldx #$40
skip1	txa
.)
	sta (blob),y
	iny
	;Now look at junction
	lda (blob),y
	;This is a tad more work..
	;			Change to
	;FC - Left Corridor		43
	;CC - Shaft		-
	;CF - Right Corridor	70
	;4C - Both Corridors	40
	ldx #$43
	cmp #$FC
.(
	beq skip2
	ldx #$70
	cmp #$CF
	beq skip2
	ldx #$40
	cmp #$4C
	bne skip3
skip2	txa
	sta (blob),y
skip3	iny
.)
	;Restore attribute to right of blob
	ldx #$C0
	lda (blob),y
	;If room contains inverse attribute the write $C0
.(
	bmi skip1
	ldx #$40
skip1	txa
.)
	sta (blob),y
	
	;Now calculate new position of Blob
	ldy ComplexY
	ldx BlobScreenY,y
	;Offset by shaft ethan is in
	lda ComplexX
	;Add screen x position of map (-1 to point at room to the left)
	clc
	adc #5
	adc screen_ylocl,x
	sta blob
	lda screen_yloch,x
	sta blob+1
	
	;We'll leave it to the main Ethan control loop above to deal with glowing the blob but
	;for the moment we'll plot the right stuff here(based on the bg)
	ldy #00
	;Fetch room to left byte
	ldx #1+128
	lda (blob),y
.(
	bmi skip1
	ldx #1
skip1	txa
.)
	sta (blob),y
	;Now convert Junction to format that allows us to just change colour of corridor
	;43 - Left Corridor		FC
	;CC - Shaft		-
	;70 - Right Corridor	CF
	;40 - Both Corridors	4C
	iny
	ldx #$FC
	lda (blob),y
	cmp #$43
.(
	beq skip1
	ldx #$CF
	cmp #$70
	beq skip1
	ldx #$4C
	cmp #$40
	bne skip2
skip1	txa
	sta (blob),y
skip2	;Work out correct colour to be stored in byte to right of blob
.)
	ldy ComplexY
	ldx #6+128
	lda BlobScreenY,y
	lsr
.(
	bcc skip1
	ldx #3+128
skip1	;Fetch room to left byte
.)
	ldy #2
	lda (blob),y
.(
	bmi skip1
	txa
	and #127
	tax
skip1	txa
.)
	sta (blob),y
	rts
	
GlowBlob
	;Wait on delay
	lda BlobDelay
.(
	bne skip1
	
	;Reset delay
	lda #1
	sta BlobDelay
	
	;update colour index
	ldy #00
	lda BlobColourIndex
	clc
	adc #1
	and #15
	sta BlobColourIndex
	tax
	
	;Fetch colour
	lda GlowInk,x
	tax
	
	;Fetch bg (it could be no room (inversed) or a room(normal) and we need to respect this
	lda (blob),y
	bpl skip2
	txa
	ora #128
	tax
skip2	;And store it
	txa
	sta (blob),y
skip1	rts
.)
	
GlowInk
 .byt 4,1,5,2,6,3,3,7,7,7,3,3,6,2,5,1

;Holds the real Screen y co-ordinate of the glowing blob in the score map for each of the lift(ComplexY) position
BlobScreenY
 .dsb 4,155
 .dsb 6,156
 .dsb 5,157
 .dsb 6,158
 .dsb 4,159
 .dsb 4,160
 .dsb 6,161
 .dsb 5,162
 .dsb 6,163
 .dsb 4,164
 .dsb 4,165
 .dsb 6,166
 .dsb 5,167
 .dsb 6,168
 .dsb 4,169
 .dsb 4,170
 .dsb 6,171
 .dsb 5,172
 .dsb 6,173
 .dsb 4,174
 .dsb 4,175
 .dsb 6,176
 .dsb 5,177
 .dsb 6,178
 .dsb 4,179
 .dsb 4,180
 .dsb 6,181
 .dsb 5,182
 .dsb 6,183
 .dsb 4,184
 .dsb 4,185
 .dsb 6,186
 .dsb 5,187
 .dsb 6,188
 .dsb 4,189
 .dsb 4,190
 .dsb 6,191
 .dsb 5,192
 .dsb 6,193
 .dsb 4,194




