;MapCode.s
;3 types of NPC exist in Stormlord..
;1) NPC like Raindrops, Balls - Initialised at map draw at specific point/s from block
;2) NPC like Bees - Spawned at map draw to exist at specific x/y
;3) NPC like Dragons, Eggs - Spawned in realtime in NPC_Engine but flagged to do so here in map code

;DrawMap
; Draw Screen
; Draw Background buffer
; Draw Collision Map
; Initialise NPCs for Screen
DrawMap	lda #128
	sta ssnpc_Type
	
	;Silence all SFX
	ldx #2
	lda #0
.(
loop1	sta sfx_Status,x
	dex
	bpl loop1
.)
	;Silence sound
	sta ay_Volume
	sta ay_Volume+1
	sta ay_Volume+2

	lda #255
	sta ObjectIndex
	sta NPCUltimateIndex
	
	lda #5
	sta MapGrubCount
	
	lda #00
	sta Honeypot_Found
	sta BeesPresentHere
	
	jsr InitialiseScreenSpecificNPC

	lda #<Stormlord_Map
	sta map
	lda #>Stormlord_Map
	sta map+1
	
	lda #0
	sta dm_CursorY
.(	
loop2	lda #0
	sta dm_CursorX
	lda MapX
	sta dm_MapIndex
	
loop1	ldy dm_MapIndex
	lda (map),y
	
	sta MomentaryBlock
	
	jsr CheckBlock4NPC
	
	jsr CheckBlock4Object
	
	jsr PlotBlock2Screen
	
	jsr PlotBlock2BGBuff
	
	jsr PlotBlock2CMAP
	
;	lda NPCUltimateIndex
;	bmi skip777
;skip776	nop
;	jmp skip776
;skip777
	inc dm_CursorX
	inc dm_CursorX
	
	inc dm_MapIndex
	
	lda dm_CursorX
	cmp #38
	bcc loop1
	
	inc map+1
	
	inc dm_CursorY
	inc dm_CursorY
	
	lda dm_CursorY
	cmp #18
	bcc loop2
.)
	rts

;Some NPC are generated based on the Screen and level
; Eggwasp
; Dragon
InitialiseScreenSpecificNPC
	ldx #00
.(
loop1	lda NPCScreenSpecificLevelID,x
	bmi skip3
	cmp LevelID
	bne skip1
	lda MapX
	cmp NPCScreenSpecificMapX,x
	beq skip2
skip1	inx
	jmp loop1
skip3	rts
skip2	;Setup this NPC
	lda NPCScreenSpecificSetupVectorLo,x
	sta vector1+1
	lda NPCScreenSpecificSetupVectorHi,x
	sta vector1+2
vector1	jmp $dead
.)


NPCScreenSpecificLevelID
 .byt 0	;Level 1 Bonus screen

 .byt 1	;Level 2 Dragon
 .byt 1	;Level 2 Eggwasp
 .byt 1	;Level 2 Eggwasp
 .byt 1	;Level 2 Bonus screen
 
; .byt 2	;Level 3 Dragon
; .byt 2	;Level 3 Eggwasps
 .byt 2	;Level 3 Bonus screen
 .byt 128
 
NPCScreenSpecificMapX
 .byt 237
 
 .byt $9A
 .byt $62
 .byt $54
 .byt 237

; .byt $38
; .byt $70
 .byt 237
NPCScreenSpecificSetupVectorLo
 .byt <SetupFairies
 
 .byt <SetupDragon
 .byt <SetupEggwasp
 .byt <SetupEggwasp
 .byt <SetupFairies
 
; .byt <SetupDragon
; .byt <SetupEggwasp
 .byt <SetupFairies

NPCScreenSpecificSetupVectorHi
 .byt >SetupFairies
 
 .byt >SetupDragon
 .byt >SetupEggwasp
 .byt >SetupEggwasp
 .byt >SetupFairies
 
; .byt >SetupDragon
; .byt >SetupEggwasp
 .byt >SetupFairies


CheckBlock4NPC
	lda MomentaryBlock
	ldx #5
.(
loop1	cmp NPCBlockTrigger,x
	beq skip1
	dex
	bpl loop1
	rts
skip1	;Found Block - Branch to initialise
	lda NPCBlockInitialiseVectorLo,x
	sta vector1+1
	lda NPCBlockInitialiseVectorHi,x
	sta vector1+2
vector1	jmp $dead
.)	
	

NPCBlockTrigger
 .byt 1	;Web	- Spider
 .byt 4	;Launcher - Ball
 .byt 16	;Blue Vase- Bees
 .byt $5D	;Honeypot - Overides Bee Origin
 .byt 34	;Cloud	- Rain Drops
 .byt 8	;Ledge	- Grub
NPCBlockInitialiseVectorLo
 .byt <SetupSpider
 .byt <SetupBall
 .byt <SetupBees
 .byt <OverrideBeeOrigin
 .byt <SetupRaindrops
 .byt <SetupGrub
NPCBlockInitialiseVectorHi
 .byt >SetupSpider
 .byt >SetupBall
 .byt >SetupBees
 .byt >OverrideBeeOrigin
 .byt >SetupRaindrops
 .byt >SetupGrub

CheckBlock4Object
	lda MomentaryBlock
	ldx #6
.(
loop1	cmp ObjectBlockTrigger,x
	beq skip1
	dex
	bpl loop1
	rts
skip1	;Found Block - Branch to initialise
	lda ObjectBlockInitialiseVectorLo,x
	sta vector1+1
	lda ObjectBlockInitialiseVectorHi,x
	sta vector1+2
vector1	jmp $dead
.)

ObjectBlockTrigger
 .byt $28	;,$29,$34,$35	;Door
 .byt $41	;,$42		;Trampolene
 .byt $5B	;,$5C		;Key
 .byt $5D	;,$5E		;Honeypot
 .byt $68	;,$69		;Umbrella
 .byt $6A	;,$6B		;Shoes
 .byt $12	;,$13,$1E,$1F	;Fairy
ObjectBlockInitialiseVectorLo
 .byt <InitDoor		;,<InitDoor,<InitDoor,<InitDoor
 .byt <InitTrampolene	;,<InitTrampolene
 .byt <InitKey		;,<InitKey
 .byt <InitHoneypot		;,<InitHoneypot
 .byt <InitUmbrella		;,<InitUmbrella
 .byt <InitShoes		;,<InitShoes
 .byt <InitFairy		;,<InitFairy,<InitFairy,<InitFairy
ObjectBlockInitialiseVectorHi
 .byt >InitDoor		;,>InitDoor,>InitDoor,>InitDoor
 .byt >InitTrampolene	;,>InitTrampolene
 .byt >InitKey		;,>InitKey
 .byt >InitHoneypot		;,>InitHoneypot
 .byt >InitUmbrella		;,>InitUmbrella
 .byt >InitShoes		;,>InitShoes
 .byt >InitFairy		;,>InitFairy,>InitFairy,>InitFairy

;dm_CursorX
;dm_CursorY
;MomentaryBlock
PlotBlock2Screen
	lda dm_CursorX
	ldy dm_CursorY
	clc
	adc Mult240Lo,y
	sta screen
	lda #$A0
	adc Mult240Hi,y
	sta screen+1
	
	;Offset screen by 30 rows
	lda screen
	sec
	adc #<30*40
	sta screen
	lda screen+1
	adc #>30*40
	sta screen+1
	
	;multiply block by 24(x16 + x8)
	jsr CalcBlockAddress

	ldx #12
.(
loop2	ldy #1

loop1	lda (graphic),y
	sta (screen),y
	dey
	bpl loop1

	lda #2
	jsr AddGraphic
	jsr nl_screen
	
	dex
	bne loop2
.)
	rts

CalcBlockAddress
	ldx #00
	stx TempHi
	lda MomentaryBlock
	asl
	rol TempHi
	asl
	rol TempHi
	asl
	rol TempHi
	sta graphic
	ldx TempHi
	stx graphic+1
	asl
	rol TempHi
	adc graphic
	tax	;sta TempLo
	lda TempHi
	adc graphic+1
	sta graphic+1
	txa
	adc #<GraphicBlock00
	sta graphic
	lda graphic+1
	adc #>GraphicBlock00
	sta graphic+1
	rts

PlotBlock2BGBuff
	lda dm_CursorX
	ldy dm_CursorY
	clc
	adc Mult240Lo,y
	sta bgbuff
	lda #>BackgroundBuffer
	adc Mult240Hi,y
	sta bgbuff+1
	
	jsr CalcBlockAddress
	
	ldx #12
.(
loop2	ldy #1

loop1	lda (graphic),y
	sta (bgbuff),y
	dey
	bpl loop1

	lda #2
	jsr AddGraphic
	lda #40
	jsr AddBGBuff

	dex
	bne loop2
.)
	rts

PlotBlock2CMAP
	lda dm_CursorX
	ldy dm_CursorY
	sec
	adc Mult40Lo,y
	sta cmap
	lda #>CollisionMap
	adc Mult40Hi,y
	sta cmap+1

	ldx MomentaryBlock
	lda Block2CollisionValue,x

	;Each block consumes 2x2 cells
	ldx #3
.(
loop1	ldy Offset2x2,x
	sta (cmap),y
	dex
	bpl loop1
.)
	rts

;These require Object_ tables to be set up (indexed by ObjectIndex)
;Object_BlockID
;Object_MapLo
;Object_MapHi
;Object_X
;Object_Y

InitFairy
InitDoor
InitTrampolene
InitHoneypot
InitKey
InitUmbrella
InitShoes
	inc ObjectIndex
	ldx ObjectIndex
	lda MomentaryBlock
	sta Object_BlockID,x
	tay
	lda Block2CollisionValue,y
	sta Object_CollisionValue,x
	lda dm_CursorX
	sta Object_X,x
	lda dm_CursorY
	sta Object_Y,x
	lda map
	clc
	adc dm_MapIndex
	sta Object_MapLo,x
	lda map+1
	adc #00
	sta Object_MapHi,x
	rts

SetupSpider
	jsr FetchNewNPCIndex
.(
	bcs skip1

	lda #NPCA_SPIDER
	sta NPC_Activity,y

	;Progress indicates frame index
	lda #00
	sta NPC_Progress,y

	lda #2
	sta NPC_Direction,y

	lda dm_CursorX
	adc #1
	sta NPC_ScreenX,y
	sta NPC_ScreenXOrigin,y
	
	lda dm_CursorY
	jsr Mult6
	clc
	adc #30
	ora #1
	sta NPC_ScreenY,y
	sta NPC_ScreenYOrigin,y
skip1	rts
.)

Mult6	asl
.(
	sta vector1+1
	asl
vector1	adc #00
.)
	rts
	
SetupBall
	jsr FetchNewNPCIndex
.(
	bcs skip1
	;Record Launchers First Ball Screen Location and xy
	lda #NPCA_BALLRISING
	sta NPC_Activity,y
	lda #00
	sta NPC_Progress,y

	lda dm_CursorX
	clc
	adc #01
	sta NPC_ScreenX,y
	sta NPC_ScreenXOrigin,y
	lda dm_CursorY
	jsr Mult6
	clc
	adc #20
	sta NPC_ScreenY,y
	sta NPC_ScreenYOrigin,y
skip1	rts
.)

SetupBees	;Don't setup bees if on bonus screen
	lda MapX
	cmp #237
.(
	beq skip2
	
	;Set up SFX
;	lda #SFX_BEES
;	jsr KickSFX
	
	lda Honeypot_Found
	bne skip1
	
	; Honeypot not found (yet) so initialise Bee Origin as Vase position
	lda dm_CursorX
	jsr Mult6
	sta BeeOriginX
	lda dm_CursorY
	jsr Mult6
	clc
	adc #30
	sta BeeOriginY
skip1	;Now setup NPCs
	ldx #3
	stx BeesPresentHere

loop1	jsr FetchNewNPCIndex
	bcs skip2
	lda #NPCA_BEE
	sta NPC_Activity,y
	;Set progress to Random index in 256 SineTable
	jsr GetRandomNumber
	sta NPC_Progress,y
	;Set initial X and Y so that we don't fuck up screen at start
	lda BeeOriginX
	sta NPC_ScreenX,y
	lda BeeOriginY
	sta NPC_ScreenY,y
	dex
	bpl loop1
skip2	rts
.)	
	
	
OverrideBeeOrigin
	lda #1
	sta Honeypot_Found
	lda dm_CursorX
	jsr Mult6
	sta BeeOriginX
	lda dm_CursorY
	jsr Mult6
	clc
	adc #30
	sta BeeOriginY
	rts
SetupRaindrops
	;Generate 4 raindrops at 2 bytes apart
	ldx #1
.(
loop1	jsr FetchNewNPCIndex
	bcs skip1
	
	lda #NPCA_RAINDROP
	sta NPC_Activity,y
	
	tya
	ora #1
	asl
	sta NPC_Progress,y

	txa
	asl
	adc dm_CursorX
	sta NPC_ScreenX,y
;	lda dm_CursorX
	sta NPC_ScreenXOrigin,y
	
	lda dm_CursorY
	jsr Mult6
	clc
	adc #37
	ora #1
	sta NPC_ScreenY,y
	sta NPC_ScreenYOrigin,y
	
	dex
	bpl loop1
skip1	rts
.)

SetupGrub
	;Only mark the first 5 ledges
	lda MapGrubCount
.(
	beq skip1
	dec MapGrubCount
	;Use this ledge to launch a grub
	jsr FetchNewNPCIndex
	bcs skip1
	
	lda #NPCA_GRUBPEEP
	sta NPC_Activity,y
	lda #50	;Hesitancy level for grub
	sta NPC_Progress,y
	lda #2	;Face right
	sta NPC_Direction,y
	lda #4	;Speed of look
	sta NPC_Special,y

	lda dm_CursorX
	clc
	adc #01
	sta NPC_ScreenX,y
	sta NPC_ScreenXOrigin,y
	lda dm_CursorY
	jsr Mult6
	clc
	adc #25
	and #$FE
	sta NPC_ScreenY,y
	sta NPC_ScreenYOrigin,y
skip1	rts
.)

SetupDragon
	lda #00
	sta ssnpc_Type
	lda #1
	sta DelayBetweenRRNPC
	rts

SetupEggwasp
	lda #1
	sta DelayBetweenRRNPC
	sta ssnpc_Type
	rts
	
SetupFairies
	lda #02
	sta ssnpc_Type
	lda #1
	sta DelayBetweenRRNPC
	rts

ssnpc_Type .byt 0
 
FetchNewNPCIndex
	;We must limit the number of NPC to 12 or under
	ldy NPCUltimateIndex
.(
	bmi skip2
	cpy #11
	bcs skip1
skip2	inc NPCUltimateIndex
	ldy NPCUltimateIndex
	clc
skip1	rts
.)
