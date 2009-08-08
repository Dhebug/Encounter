;GraphicEngine.s



;Cyclic Copy BGBuffer to ScreenBuffer
;Populate 2 Rows of BGBuffer
;Update bgb Pointers
;Hero Control
;Plot Sprites (Masking against BackgroundBuffer) onto ScreenBuffer
;Copy ScreenBuffer to Display

;Populating rows of BG buffer means knowing the map offset
;then capturing the graphic and extracting specific row data.
UpdateBackground
	ldx #00
	lda GraphicBlockRowOffset
	sec
	sbc #8
.(
	bcs skip1
	inx
	dec CurrentMapRow
	lda #88
skip1	sta GraphicBlockRowOffset
.)
	stx NextMapRowFlag
	;Fetch Map Entry
	ldx CurrentMapRow
	lda MapRowAddressLo,x
	sta source
	lda MapRowAddressHi,x
	sta source+1
	ldy #4
.(
loop3	;Extract Special Code
	lda (source),y
	and #3
	sta EmbeddedObjective
	

	lda (source),y

	;Preserve Y
	sty TempY
	
	lsr
	lsr

	;Locate Graphic Address
	tax
	;Multiply Map column by 4
	tya
	asl
	asl
	ldy bgbPlotRow
	adc BGBufferRowAddressLo,y
	sta screen
	lda BGBufferRowAddressHi,y
	adc #00
	sta screen+1
	lda GraphicBlockRowOffset
	adc GraphicBlockAddressLo,x
	sta block
	lda GraphicBlockAddressHi,x
	adc #00
	sta block+1
	
	lda NextMapRowFlag
	beq skip1
	
	;On reaching the next row up, detect a BGObject, new Wave or EOL
	ldx EmbeddedObjective
	beq skip1
	
	;Process the new objective
	jsr InitialiseEmbeddedObjective
	
skip1	;Fetch 2 Block Rows and store to BgBuffer
	ldy #3
loop1	lda (block),y
	sta (screen),y
	dey
	bpl loop1
	
	lda block
	adc #4
	sta block
	lda block+1
	adc #00
	sta block+1
	
	lda #20
	jsr AddScreen
	
	ldy #3
loop2	lda (block),y
	sta (screen),y
	dey
	bpl loop2
	
	;Proceed to next Map column
	ldy TempY
	dey
	bpl loop3
.)
	rts

Objective_EOL
	;Generate EOL baddy
	rts

InitialiseEmbeddedObjective
	;X=Object BGObject(1) Wave(2) EOL(3) 
	;(source)+5 Object Data
;	nop
;	jmp InitialiseEmbeddedObjective
;	rts
	cpx #2
.(
	beq ProcSkySprite
	bcs Objective_EOL

ProcGndSprite
	;Data Byte..
	;B0-1 Not Used (On-Delay and spawning for Railway Gates now happens in script)
	;B2-7 Script ID
	lda #01
	sta WaveQuantity
	jmp skip1
	
ProcSkySprite
	;An initial delay can be used
	; 1 - 
	;Data Byte..
	;B0-1 Quantity Count
	;B2-7 Script ID
	ldy #5
	lda (source),y
	and #3
	adc #00
	sta WaveQuantity
	lda #00
	sta Temp_OnDelay

skip1	ldy #5
	lda (source),y
	lsr
	lsr
	sta Temp_ScriptID
	;Set up scripts for all craft in wave (just set increasing on-delay)
	lda #00
	sta Temp_OnDelay
	
loop1	inc UltimateSprite
	ldx UltimateSprite
	
	lda #SCRIPT_EXPLODE
	sta Sprite_ExplosionScript,x
	lda #00
	sta Sprite_ScriptIndex,x
	sta Sprite_CurrentDir,x
	sta Sprite_Y,x
	sta Sprite_ConditionID,x
	sta Sprite_Counter,x
	ldy TempY
	lda SpriteStartX,y
	sta Sprite_X,x
	lda Temp_ScriptID
	sta Sprite_ScriptID,x
	;The first row of any map triggered script must always specify the default frame(ID)
	jsr FetchDefaultScriptFrame
;	sta Sprite_ID,x	;Though should be the first thing set in script
	tay
;	lda LevelFrameAttributes,y
;	sta Sprite_Attributes,x
	lda LevelFrameWidth,y
	sta Sprite_Width,x
	lda LevelFrameHeight,y
	sta Sprite_Height,x
	lda LevelFrameUltimateByte,y
	sta Sprite_UltimateByte,x
	lda LevelFrameCollisionBytes,y
	sta Sprite_CollisionBytes,x


	;B0-1 Sprite Type
      	;	0 Reserved for No Collision
      	;	1 Player A Craft
      	;	2 Player B Craft
      	;	3 Sprite (Data is UniqueID 0-63)
	;B2-7 Data for Type
	jsr FetchUniqueSequenceID	;A == 0-63
	asl
	asl
	ora #3
	sta Sprite_UniqueID,x
	

skip2	lda Temp_OnDelay
	sta Sprite_PausePeriod,x

	clc
	ldy Temp_ScriptID
	adc DistanceBetweenWaveSprites,y
	sta Temp_OnDelay
	
	lda LevelFrameHitpoints,y
	sta Sprite_HitPoints,x
	lda LevelFrameHealth,y
	sta Sprite_Health,x
	;Reset other sprite bonuses to zero(overwrite any previous defs)
	lda #00
	sta Sprite_Bonuses,x
	
	dec WaveQuantity
	bne loop1
.)
	;Only provide a bonus for the last sprite
	;if not wave we can still avoid bonuses by setting LevelBonuses to 0)
	lda LevelBonuses,y
	sta Sprite_Bonuses,x
	
	rts

	
	
;Parsed..	
;A==ScriptID
;Returned..
;A==SpriteID
;Corruption..
;A,Y
FetchDefaultScriptFrame
	sty gfxTemp01
	tay
	lda SpriteScriptAddressLo,y
.(
	sta vector1+1
	lda SpriteScriptAddressHi,y
	sta vector1+2
	ldy #1
vector1	lda $dead,y
.)
	ldy gfxTemp01
	rts
	
	
FetchUniqueSequenceID
	dec UniqueID_SequenceNumber
	lda UniqueID_SequenceNumber
	rts	








	
	
	
	

;;A cyclic copy is one whereby the copy begins at the first row.
;;The next time it is called it will copy 2 rows down. When it
;;hits the end it will start at the beginning again.
;CyclicCopyBGBuffer
;	lda #134
;	sta RowCount
;	;Offset within screenbuffer
;	lda #<ScreenBuffer+2+24*12
;	sta screen
;	lda #>ScreenBuffer+2+24*12
;	sta screen+1
;	
;	;Fetch Row Address
;	ldx bgbRowStart
;.(
;loop2	lda BGBufferRowAddressLo,x
;	sta source
;	lda BGBufferRowAddressHi,x
;	sta source+1
;	
;	;Cycle Row
;	inx
;	cpx #138
;	bcc skip1
;	ldx #0
;	clc
;skip1	;Copy Row
;	ldy #19
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	dey
;	lda (source),y
;	sta (screen),y
;	
;	lda screen
;	adc #24
;	sta screen
;	bcc skip2
;	inc screen+1
;;	clc
;	
;skip2	dec RowCount
;	beq skip3
;	jmp loop2
;skip3	rts
;.)



UpdateBGBPointers
	;Cycle within 0-135
	lda bgbRowStart
	sec
	sbc #2
.(
	bcs skip1
	;254 to 255
	sbc #117	;117
skip1	sta bgbRowStart

	lda bgbPlotRow
	sec
	sbc #2

	bcs skip2
	;254 to 255
	sbc #117	;117
skip2	sta bgbPlotRow

skip3	rts
.)
	
ZoomScreen
	ldx #19
.(
loop1	lda ScreenBuffer+2+24*12,x
	sta $A00A+40*32,x
	lda ScreenBuffer+2+24*13,x
	sta $A00A+40*33,x
	lda ScreenBuffer+2+24*14,x
	sta $A00A+40*34,x
	lda ScreenBuffer+2+24*15,x
	sta $A00A+40*35,x
	lda ScreenBuffer+2+24*16,x
	sta $A00A+40*36,x
	lda ScreenBuffer+2+24*17,x
	sta $A00A+40*37,x
	lda ScreenBuffer+2+24*18,x
	sta $A00A+40*38,x
	lda ScreenBuffer+2+24*19,x
	sta $A00A+40*39,x
	lda ScreenBuffer+2+24*20,x
	sta $A00A+40*40,x
	lda ScreenBuffer+2+24*21,x
	sta $A00A+40*41,x
	lda ScreenBuffer+2+24*22,x
	sta $A00A+40*42,x
	lda ScreenBuffer+2+24*23,x
	sta $A00A+40*43,x
	lda ScreenBuffer+2+24*24,x
	sta $A00A+40*44,x
	lda ScreenBuffer+2+24*25,x
	sta $A00A+40*45,x
	lda ScreenBuffer+2+24*26,x
	sta $A00A+40*46,x
	lda ScreenBuffer+2+24*27,x
	sta $A00A+40*47,x
	lda ScreenBuffer+2+24*28,x
	sta $A00A+40*48,x
	lda ScreenBuffer+2+24*29,x
	sta $A00A+40*49,x
	lda ScreenBuffer+2+24*30,x
	sta $A00A+40*50,x    
	lda ScreenBuffer+2+24*31,x
	sta $A00A+40*51,x    
	lda ScreenBuffer+2+24*32,x
	sta $A00A+40*52,x    
	lda ScreenBuffer+2+24*33,x
	sta $A00A+40*53,x    
	lda ScreenBuffer+2+24*34,x
	sta $A00A+40*54,x    
	lda ScreenBuffer+2+24*35,x
	sta $A00A+40*55,x    
	lda ScreenBuffer+2+24*36,x
	sta $A00A+40*56,x    
	lda ScreenBuffer+2+24*37,x
	sta $A00A+40*57,x    
	lda ScreenBuffer+2+24*38,x
	sta $A00A+40*58,x    
	lda ScreenBuffer+2+24*39,x
	sta $A00A+40*59,x
	lda ScreenBuffer+2+24*40,x
	sta $A00A+40*60,x    
	lda ScreenBuffer+2+24*41,x
	sta $A00A+40*61,x    
	lda ScreenBuffer+2+24*42,x
	sta $A00A+40*62,x    
	lda ScreenBuffer+2+24*43,x
	sta $A00A+40*63,x    
	lda ScreenBuffer+2+24*44,x
	sta $A00A+40*64,x    
	lda ScreenBuffer+2+24*45,x
	sta $A00A+40*65,x    
	lda ScreenBuffer+2+24*46,x
	sta $A00A+40*66,x    
	lda ScreenBuffer+2+24*47,x
	sta $A00A+40*67,x    
	lda ScreenBuffer+2+24*48,x
	sta $A00A+40*68,x    
	lda ScreenBuffer+2+24*49,x
	sta $A00A+40*69,x
	lda ScreenBuffer+2+24*50,x
	sta $A00A+40*70,x    
	lda ScreenBuffer+2+24*51,x
	sta $A00A+40*71,x    
	lda ScreenBuffer+2+24*52,x
	sta $A00A+40*72,x    
	lda ScreenBuffer+2+24*53,x
	sta $A00A+40*73,x    
	lda ScreenBuffer+2+24*54,x
	sta $A00A+40*74,x    
	lda ScreenBuffer+2+24*55,x
	sta $A00A+40*75,x    
	lda ScreenBuffer+2+24*56,x
	sta $A00A+40*76,x    
	lda ScreenBuffer+2+24*57,x
	sta $A00A+40*77,x    
	lda ScreenBuffer+2+24*58,x
	sta $A00A+40*78,x    
	lda ScreenBuffer+2+24*59,x
	sta $A00A+40*79,x
	lda ScreenBuffer+2+24*60,x
	sta $A00A+40*80,x    
	lda ScreenBuffer+2+24*61,x
	sta $A00A+40*81,x    
	lda ScreenBuffer+2+24*62,x
	sta $A00A+40*82,x    
	lda ScreenBuffer+2+24*63,x
	sta $A00A+40*83,x    
	lda ScreenBuffer+2+24*64,x
	sta $A00A+40*84,x    
	lda ScreenBuffer+2+24*65,x
	sta $A00A+40*85,x    
	lda ScreenBuffer+2+24*66,x
	sta $A00A+40*86,x    
	lda ScreenBuffer+2+24*67,x
	sta $A00A+40*87,x    
	lda ScreenBuffer+2+24*68,x
	sta $A00A+40*88,x    
	lda ScreenBuffer+2+24*69,x
	sta $A00A+40*89,x
	lda ScreenBuffer+2+24*70,x
	sta $A00A+40*90,x    
	lda ScreenBuffer+2+24*71,x
	sta $A00A+40*91,x    
	lda ScreenBuffer+2+24*72,x
	sta $A00A+40*92,x    
	lda ScreenBuffer+2+24*73,x
	sta $A00A+40*93,x    
	lda ScreenBuffer+2+24*74,x
	sta $A00A+40*94,x    
	lda ScreenBuffer+2+24*75,x
	sta $A00A+40*95,x    
	lda ScreenBuffer+2+24*76,x
	sta $A00A+40*96,x    
	lda ScreenBuffer+2+24*77,x
	sta $A00A+40*97,x    
	lda ScreenBuffer+2+24*78,x
	sta $A00A+40*98,x    
	lda ScreenBuffer+2+24*79,x
	sta $A00A+40*99,x
	lda ScreenBuffer+2+24*80,x
	sta $A00A+40*100,x    
	lda ScreenBuffer+2+24*81,x
	sta $A00A+40*101,x    
	lda ScreenBuffer+2+24*82,x
	sta $A00A+40*102,x    
	lda ScreenBuffer+2+24*83,x
	sta $A00A+40*103,x    
	lda ScreenBuffer+2+24*84,x
	sta $A00A+40*104,x    
	lda ScreenBuffer+2+24*85,x
	sta $A00A+40*105,x    
	lda ScreenBuffer+2+24*86,x
	sta $A00A+40*106,x    
	lda ScreenBuffer+2+24*87,x
	sta $A00A+40*107,x    
	lda ScreenBuffer+2+24*88,x
	sta $A00A+40*108,x    
	lda ScreenBuffer+2+24*89,x
	sta $A00A+40*109,x
	lda ScreenBuffer+2+24*90,x
	sta $A00A+40*110,x    
	lda ScreenBuffer+2+24*91,x
	sta $A00A+40*111,x    
	lda ScreenBuffer+2+24*92,x
	sta $A00A+40*112,x    
	lda ScreenBuffer+2+24*93,x
	sta $A00A+40*113,x    
	lda ScreenBuffer+2+24*94,x
	sta $A00A+40*114,x    
	lda ScreenBuffer+2+24*95,x
	sta $A00A+40*115,x    
	lda ScreenBuffer+2+24*96,x
	sta $A00A+40*116,x    
	lda ScreenBuffer+2+24*97,x
	sta $A00A+40*117,x    
	lda ScreenBuffer+2+24*98,x
	sta $A00A+40*118,x    
	lda ScreenBuffer+2+24*99,x
	sta $A00A+40*119,x
	lda ScreenBuffer+2+24*100,x
	sta $A00A+40*120,x    
	lda ScreenBuffer+2+24*101,x
	sta $A00A+40*121,x    
	lda ScreenBuffer+2+24*102,x
	sta $A00A+40*122,x    
	lda ScreenBuffer+2+24*103,x
	sta $A00A+40*123,x    
	lda ScreenBuffer+2+24*104,x
	sta $A00A+40*124,x    
	lda ScreenBuffer+2+24*105,x
	sta $A00A+40*125,x    
	lda ScreenBuffer+2+24*106,x
	sta $A00A+40*126,x    
	lda ScreenBuffer+2+24*107,x
	sta $A00A+40*127,x    
	lda ScreenBuffer+2+24*108,x
	sta $A00A+40*128,x    
	lda ScreenBuffer+2+24*109,x
	sta $A00A+40*129,x
	lda ScreenBuffer+2+24*110,x
	sta $A00A+40*130,x    
	lda ScreenBuffer+2+24*111,x
	sta $A00A+40*131,x    
	lda ScreenBuffer+2+24*112,x
	sta $A00A+40*132,x    
	lda ScreenBuffer+2+24*113,x
	sta $A00A+40*133,x    
	lda ScreenBuffer+2+24*114,x
	sta $A00A+40*134,x    
	lda ScreenBuffer+2+24*115,x
	sta $A00A+40*135,x    
	lda ScreenBuffer+2+24*116,x
	sta $A00A+40*136,x    
	lda ScreenBuffer+2+24*117,x
	sta $A00A+40*137,x    
	lda ScreenBuffer+2+24*118,x
	sta $A00A+40*138,x    
	lda ScreenBuffer+2+24*119,x
	sta $A00A+40*139,x
	lda ScreenBuffer+2+24*120,x
	sta $A00A+40*140,x    
	lda ScreenBuffer+2+24*121,x
	sta $A00A+40*141,x    
	lda ScreenBuffer+2+24*122,x
	sta $A00A+40*142,x    
	lda ScreenBuffer+2+24*123,x
	sta $A00A+40*143,x    
	lda ScreenBuffer+2+24*124,x
	sta $A00A+40*144,x    
	lda ScreenBuffer+2+24*125,x
	sta $A00A+40*145,x    
	lda ScreenBuffer+2+24*126,x
	sta $A00A+40*146,x    
	lda ScreenBuffer+2+24*127,x
	sta $A00A+40*147,x    
	lda ScreenBuffer+2+24*128,x
	sta $A00A+40*148,x    
	lda ScreenBuffer+2+24*129,x
	sta $A00A+40*149,x
	lda ScreenBuffer+2+24*130,x
	sta $A00A+40*150,x    
	lda ScreenBuffer+2+24*131,x
	sta $A00A+40*151,x    
	lda ScreenBuffer+2+24*132,x
	sta $A00A+40*152,x    
	lda ScreenBuffer+2+24*133,x
	sta $A00A+40*153,x    
	lda ScreenBuffer+2+24*134,x
	sta $A00A+40*154,x    
	lda ScreenBuffer+2+24*135,x
	sta $A00A+40*155,x    
	lda ScreenBuffer+2+24*136,x
	sta $A00A+40*156,x    
	lda ScreenBuffer+2+24*137,x
	sta $A00A+40*157,x    
	lda ScreenBuffer+2+24*138,x
	sta $A00A+40*158,x    
	lda ScreenBuffer+2+24*139,x
	sta $A00A+40*159,x
	lda ScreenBuffer+2+24*140,x
	sta $A00A+40*160,x    
	lda ScreenBuffer+2+24*141,x
	sta $A00A+40*161,x    
	lda ScreenBuffer+2+24*142,x
	sta $A00A+40*162,x    
	lda ScreenBuffer+2+24*143,x
	sta $A00A+40*163,x    
	lda ScreenBuffer+2+24*144,x
	sta $A00A+40*164,x    
	lda ScreenBuffer+2+24*145,x
	sta $A00A+40*165,x    
	dex                    
	bmi skip1               
	jmp loop1              
skip1	rts                     
.)	                       

;This uses a long list (134) of LDA/STA ,x structures which resides in a 20 loop.
;Before hand the cyclic screen addresses are written into all the 134 STAs.
;The setup costs about 7504 Cycles, the big loop costs about 16,320 cycles.
;But 23,824 is almost twice as fast as 41,138 cycles used in previous code.
CyclicCopyBGBuffer
	clc
	ldy #134
	ldx bgbRowStart
.(
loop1	lda CodeVectorAddressLo,y
	sta vector2+1
	adc #01
	sta vector3+1
	lda CodeVectorAddressHi,y
	sta vector2+2
	adc #00
	sta vector3+2
	lda BGBufferRowAddressLo,x	;BackgroundBufferRowAddressLo,x
vector2	sta $dead
	lda BGBufferRowAddressHi,x	;BackgroundBufferRowAddressHi,x
vector3	sta $dead
	inx
	cpx #138	;135
	bcc skip1
	ldx #00
	clc
skip1	dey
	bne loop1
.)
	ldx #19
BBGVloop1
BBGV001	lda $dead,x
       	sta ScreenBuffer+2+24*12,x
BBGV002	lda $dead,x
       	sta ScreenBuffer+2+24*13,x
BBGV003	lda $dead,x
       	sta ScreenBuffer+2+24*14,x
BBGV004	lda $dead,x
       	sta ScreenBuffer+2+24*15,x
BBGV005	lda $dead,x
       	sta ScreenBuffer+2+24*16,x
BBGV006	lda $dead,x
       	sta ScreenBuffer+2+24*17,x
BBGV007	lda $dead,x
       	sta ScreenBuffer+2+24*18,x
BBGV008	lda $dead,x
       	sta ScreenBuffer+2+24*19,x
BBGV009	lda $dead,x
       	sta ScreenBuffer+2+24*20,x
BBGV010	lda $dead,x
       	sta ScreenBuffer+2+24*21,x
BBGV011	lda $dead,x
       	sta ScreenBuffer+2+24*22,x
BBGV012	lda $dead,x
       	sta ScreenBuffer+2+24*23,x
BBGV013	lda $dead,x
       	sta ScreenBuffer+2+24*24,x
BBGV014	lda $dead,x
       	sta ScreenBuffer+2+24*25,x
BBGV015	lda $dead,x
       	sta ScreenBuffer+2+24*26,x
BBGV016	lda $dead,x
       	sta ScreenBuffer+2+24*27,x
BBGV017	lda $dead,x
       	sta ScreenBuffer+2+24*28,x
BBGV018	lda $dead,x
       	sta ScreenBuffer+2+24*29,x
BBGV019	lda $dead,x
       	sta ScreenBuffer+2+24*30,x
BBGV020	lda $dead,x            
       	sta ScreenBuffer+2+24*31,x
BBGV021	lda $dead,x            
       	sta ScreenBuffer+2+24*32,x      
BBGV022	lda $dead,x            
       	sta ScreenBuffer+2+24*33,x      
BBGV023	lda $dead,x            
       	sta ScreenBuffer+2+24*34,x      
BBGV024	lda $dead,x            
       	sta ScreenBuffer+2+24*35,x      
BBGV025	lda $dead,x            
       	sta ScreenBuffer+2+24*36,x      
BBGV026	lda $dead,x            
       	sta ScreenBuffer+2+24*37,x      
BBGV027	lda $dead,x            
       	sta ScreenBuffer+2+24*38,x      
BBGV028	lda $dead,x            
       	sta ScreenBuffer+2+24*39,x      
BBGV029	lda $dead,x
       	sta ScreenBuffer+2+24*40,x      
BBGV030	lda $dead,x            
       	sta ScreenBuffer+2+24*41,x
BBGV031	lda $dead,x            
       	sta ScreenBuffer+2+24*42,x      
BBGV032	lda $dead,x            
       	sta ScreenBuffer+2+24*43,x      
BBGV033	lda $dead,x            
       	sta ScreenBuffer+2+24*44,x      
BBGV034	lda $dead,x            
       	sta ScreenBuffer+2+24*45,x      
BBGV035	lda $dead,x            
       	sta ScreenBuffer+2+24*46,x      
BBGV036	lda $dead,x            
       	sta ScreenBuffer+2+24*47,x      
BBGV037	lda $dead,x            
       	sta ScreenBuffer+2+24*48,x      
BBGV038	lda $dead,x            
       	sta ScreenBuffer+2+24*49,x      
BBGV039	lda $dead,x
       	sta ScreenBuffer+2+24*50,x      
BBGV040	lda $dead,x            
       	sta ScreenBuffer+2+24*51,x
BBGV041	lda $dead,x            
       	sta ScreenBuffer+2+24*52,x      
BBGV042	lda $dead,x            
       	sta ScreenBuffer+2+24*53,x      
BBGV043	lda $dead,x            
       	sta ScreenBuffer+2+24*54,x      
BBGV044	lda $dead,x            
       	sta ScreenBuffer+2+24*55,x      
BBGV045	lda $dead,x            
       	sta ScreenBuffer+2+24*56,x      
BBGV046	lda $dead,x            
       	sta ScreenBuffer+2+24*57,x      
BBGV047	lda $dead,x            
       	sta ScreenBuffer+2+24*58,x      
BBGV048	lda $dead,x            
       	sta ScreenBuffer+2+24*59,x      
BBGV049	lda $dead,x
       	sta ScreenBuffer+2+24*60,x      
BBGV050	lda $dead,x            
       	sta ScreenBuffer+2+24*61,x
BBGV051	lda $dead,x            
       	sta ScreenBuffer+2+24*62,x      
BBGV052	lda $dead,x            
       	sta ScreenBuffer+2+24*63,x      
BBGV053	lda $dead,x            
       	sta ScreenBuffer+2+24*64,x      
BBGV054	lda $dead,x            
       	sta ScreenBuffer+2+24*65,x      
BBGV055	lda $dead,x            
       	sta ScreenBuffer+2+24*66,x      
BBGV056	lda $dead,x            
       	sta ScreenBuffer+2+24*67,x      
BBGV057	lda $dead,x            
       	sta ScreenBuffer+2+24*68,x      
BBGV058	lda $dead,x            
       	sta ScreenBuffer+2+24*69,x      
BBGV059	lda $dead,x
       	sta ScreenBuffer+2+24*70,x      
BBGV060	lda $dead,x            
       	sta ScreenBuffer+2+24*71,x
BBGV061	lda $dead,x            
       	sta ScreenBuffer+2+24*72,x      
BBGV062	lda $dead,x            
       	sta ScreenBuffer+2+24*73,x      
BBGV063	lda $dead,x            
       	sta ScreenBuffer+2+24*74,x      
BBGV064	lda $dead,x            
       	sta ScreenBuffer+2+24*75,x      
BBGV065	lda $dead,x            
       	sta ScreenBuffer+2+24*76,x      
BBGV066	lda $dead,x            
       	sta ScreenBuffer+2+24*77,x      
BBGV067	lda $dead,x            
       	sta ScreenBuffer+2+24*78,x      
BBGV068	lda $dead,x            
       	sta ScreenBuffer+2+24*79,x      
BBGV069	lda $dead,x
       	sta ScreenBuffer+2+24*80,x      
BBGV070	lda $dead,x            
       	sta ScreenBuffer+2+24*81,x
BBGV071	lda $dead,x            
       	sta ScreenBuffer+2+24*82,x      
BBGV072	lda $dead,x            
       	sta ScreenBuffer+2+24*83,x      
BBGV073	lda $dead,x            
       	sta ScreenBuffer+2+24*84,x      
BBGV074	lda $dead,x            
       	sta ScreenBuffer+2+24*85,x      
BBGV075	lda $dead,x            
       	sta ScreenBuffer+2+24*86,x      
BBGV076	lda $dead,x            
       	sta ScreenBuffer+2+24*87,x      
BBGV077	lda $dead,x            
       	sta ScreenBuffer+2+24*88,x      
BBGV078	lda $dead,x            
       	sta ScreenBuffer+2+24*89,x      
BBGV079	lda $dead,x
       	sta ScreenBuffer+2+24*90,x      
BBGV080	lda $dead,x            
       	sta ScreenBuffer+2+24*91,x
BBGV081	lda $dead,x            
       	sta ScreenBuffer+2+24*92,x      
BBGV082	lda $dead,x            
       	sta ScreenBuffer+2+24*93,x      
BBGV083	lda $dead,x            
       	sta ScreenBuffer+2+24*94,x      
BBGV084	lda $dead,x            
       	sta ScreenBuffer+2+24*95,x      
BBGV085	lda $dead,x            
       	sta ScreenBuffer+2+24*96,x      
BBGV086	lda $dead,x            
       	sta ScreenBuffer+2+24*97,x      
BBGV087	lda $dead,x            
       	sta ScreenBuffer+2+24*98,x      
BBGV088	lda $dead,x            
       	sta ScreenBuffer+2+24*99,x      
BBGV089	lda $dead,x
       	sta ScreenBuffer+2+24*100,x      
BBGV090	lda $dead,x            
       	sta ScreenBuffer+2+24*101,x
BBGV091	lda $dead,x            
       	sta ScreenBuffer+2+24*102,x      
BBGV092	lda $dead,x            
       	sta ScreenBuffer+2+24*103,x      
BBGV093	lda $dead,x            
       	sta ScreenBuffer+2+24*104,x      
BBGV094	lda $dead,x            
       	sta ScreenBuffer+2+24*105,x      
BBGV095	lda $dead,x            
       	sta ScreenBuffer+2+24*106,x      
BBGV096	lda $dead,x            
       	sta ScreenBuffer+2+24*107,x      
BBGV097	lda $dead,x            
       	sta ScreenBuffer+2+24*108,x      
BBGV098	lda $dead,x            
       	sta ScreenBuffer+2+24*109,x      
BBGV099	lda $dead,x
       	sta ScreenBuffer+2+24*110,x      
BBGV100	lda $dead,x            
       	sta ScreenBuffer+2+24*111,x
BBGV101	lda $dead,x            
       	sta ScreenBuffer+2+24*112,x      
BBGV102	lda $dead,x            
       	sta ScreenBuffer+2+24*113,x      
BBGV103	lda $dead,x            
       	sta ScreenBuffer+2+24*114,x      
BBGV104	lda $dead,x            
       	sta ScreenBuffer+2+24*115,x      
BBGV105	lda $dead,x            
       	sta ScreenBuffer+2+24*116,x      
BBGV106	lda $dead,x            
       	sta ScreenBuffer+2+24*117,x      
BBGV107	lda $dead,x            
       	sta ScreenBuffer+2+24*118,x      
BBGV108	lda $dead,x            
       	sta ScreenBuffer+2+24*119,x      
BBGV109	lda $dead,x
       	sta ScreenBuffer+2+24*120,x      
BBGV110	lda $dead,x            
       	sta ScreenBuffer+2+24*121,x
BBGV111	lda $dead,x            
       	sta ScreenBuffer+2+24*122,x      
BBGV112	lda $dead,x            
       	sta ScreenBuffer+2+24*123,x      
BBGV113	lda $dead,x            
       	sta ScreenBuffer+2+24*124,x      
BBGV114	lda $dead,x            
       	sta ScreenBuffer+2+24*125,x      
BBGV115	lda $dead,x            
       	sta ScreenBuffer+2+24*126,x      
BBGV116	lda $dead,x            
       	sta ScreenBuffer+2+24*127,x      
BBGV117	lda $dead,x            
       	sta ScreenBuffer+2+24*128,x      
BBGV118	lda $dead,x            
       	sta ScreenBuffer+2+24*129,x      
BBGV119	lda $dead,x
       	sta ScreenBuffer+2+24*130,x      
BBGV120	lda $dead,x            
       	sta ScreenBuffer+2+24*131,x
BBGV121	lda $dead,x            
       	sta ScreenBuffer+2+24*132,x      
BBGV122	lda $dead,x            
       	sta ScreenBuffer+2+24*133,x      
BBGV123	lda $dead,x            
       	sta ScreenBuffer+2+24*134,x      
BBGV124	lda $dead,x            
       	sta ScreenBuffer+2+24*135,x      
BBGV125	lda $dead,x            
       	sta ScreenBuffer+2+24*136,x      
BBGV126	lda $dead,x            
       	sta ScreenBuffer+2+24*137,x      
BBGV127	lda $dead,x            
       	sta ScreenBuffer+2+24*138,x      
BBGV128	lda $dead,x            
       	sta ScreenBuffer+2+24*139,x      
BBGV129	lda $dead,x
       	sta ScreenBuffer+2+24*140,x      
BBGV130	lda $dead,x
       	sta ScreenBuffer+2+24*141,x
BBGV131	lda $dead,x
       	sta ScreenBuffer+2+24*142,x
BBGV132	lda $dead,x
       	sta ScreenBuffer+2+24*143,x
BBGV133	lda $dead,x
       	sta ScreenBuffer+2+24*144,x
BBGV134	lda $dead,x
       	sta ScreenBuffer+2+24*145,x
BBGV135	lda $dead,x
	sta ScreenBuffer+2+24*146,x
	
	dex
	bmi BBGVskip1
	jmp BBGVloop1
BBGVskip1	rts

CodeVectorAddressLo
 .byt <BBGV135+1
 .byt <BBGV134+1
 .byt <BBGV133+1
 .byt <BBGV132+1
 .byt <BBGV131+1
 .byt <BBGV130+1
 .byt <BBGV129+1
 .byt <BBGV128+1
 .byt <BBGV127+1
 .byt <BBGV126+1
 .byt <BBGV125+1
 .byt <BBGV124+1
 .byt <BBGV123+1
 .byt <BBGV122+1
 .byt <BBGV121+1
 .byt <BBGV120+1
 .byt <BBGV119+1
 .byt <BBGV118+1
 .byt <BBGV117+1
 .byt <BBGV116+1
 .byt <BBGV115+1
 .byt <BBGV114+1
 .byt <BBGV113+1
 .byt <BBGV112+1
 .byt <BBGV111+1
 .byt <BBGV110+1
 .byt <BBGV109+1
 .byt <BBGV108+1
 .byt <BBGV107+1
 .byt <BBGV106+1
 .byt <BBGV105+1
 .byt <BBGV104+1
 .byt <BBGV103+1
 .byt <BBGV102+1
 .byt <BBGV101+1
 .byt <BBGV100+1
 .byt <BBGV099+1
 .byt <BBGV098+1
 .byt <BBGV097+1
 .byt <BBGV096+1
 .byt <BBGV095+1
 .byt <BBGV094+1
 .byt <BBGV093+1
 .byt <BBGV092+1
 .byt <BBGV091+1
 .byt <BBGV090+1
 .byt <BBGV089+1
 .byt <BBGV088+1
 .byt <BBGV087+1
 .byt <BBGV086+1
 .byt <BBGV085+1
 .byt <BBGV084+1
 .byt <BBGV083+1
 .byt <BBGV082+1
 .byt <BBGV081+1
 .byt <BBGV080+1
 .byt <BBGV079+1
 .byt <BBGV078+1
 .byt <BBGV077+1
 .byt <BBGV076+1
 .byt <BBGV075+1
 .byt <BBGV074+1
 .byt <BBGV073+1
 .byt <BBGV072+1
 .byt <BBGV071+1
 .byt <BBGV070+1
 .byt <BBGV069+1
 .byt <BBGV068+1
 .byt <BBGV067+1
 .byt <BBGV066+1
 .byt <BBGV065+1
 .byt <BBGV064+1
 .byt <BBGV063+1
 .byt <BBGV062+1
 .byt <BBGV061+1
 .byt <BBGV060+1
 .byt <BBGV059+1
 .byt <BBGV058+1
 .byt <BBGV057+1
 .byt <BBGV056+1
 .byt <BBGV055+1
 .byt <BBGV054+1
 .byt <BBGV053+1
 .byt <BBGV052+1
 .byt <BBGV051+1
 .byt <BBGV050+1
 .byt <BBGV049+1
 .byt <BBGV048+1
 .byt <BBGV047+1
 .byt <BBGV046+1
 .byt <BBGV045+1
 .byt <BBGV044+1
 .byt <BBGV043+1
 .byt <BBGV042+1
 .byt <BBGV041+1
 .byt <BBGV040+1
 .byt <BBGV039+1
 .byt <BBGV038+1
 .byt <BBGV037+1
 .byt <BBGV036+1
 .byt <BBGV035+1
 .byt <BBGV034+1
 .byt <BBGV033+1
 .byt <BBGV032+1
 .byt <BBGV031+1
 .byt <BBGV030+1
 .byt <BBGV029+1
 .byt <BBGV028+1
 .byt <BBGV027+1
 .byt <BBGV026+1
 .byt <BBGV025+1
 .byt <BBGV024+1
 .byt <BBGV023+1
 .byt <BBGV022+1
 .byt <BBGV021+1
 .byt <BBGV020+1
 .byt <BBGV019+1
 .byt <BBGV018+1
 .byt <BBGV017+1
 .byt <BBGV016+1
 .byt <BBGV015+1
 .byt <BBGV014+1
 .byt <BBGV013+1
 .byt <BBGV012+1
 .byt <BBGV011+1
 .byt <BBGV010+1
 .byt <BBGV009+1
 .byt <BBGV008+1
 .byt <BBGV007+1
 .byt <BBGV006+1
 .byt <BBGV005+1
 .byt <BBGV004+1
 .byt <BBGV003+1
 .byt <BBGV002+1
 .byt <BBGV001+1

CodeVectorAddressHi
 .byt >BBGV135+1
 .byt >BBGV134+1
 .byt >BBGV133+1
 .byt >BBGV132+1
 .byt >BBGV131+1
 .byt >BBGV130+1
 .byt >BBGV129+1
 .byt >BBGV128+1
 .byt >BBGV127+1
 .byt >BBGV126+1
 .byt >BBGV125+1
 .byt >BBGV124+1
 .byt >BBGV123+1
 .byt >BBGV122+1
 .byt >BBGV121+1
 .byt >BBGV120+1
 .byt >BBGV119+1
 .byt >BBGV118+1
 .byt >BBGV117+1
 .byt >BBGV116+1
 .byt >BBGV115+1
 .byt >BBGV114+1
 .byt >BBGV113+1
 .byt >BBGV112+1
 .byt >BBGV111+1
 .byt >BBGV110+1
 .byt >BBGV109+1
 .byt >BBGV108+1
 .byt >BBGV107+1
 .byt >BBGV106+1
 .byt >BBGV105+1
 .byt >BBGV104+1
 .byt >BBGV103+1
 .byt >BBGV102+1
 .byt >BBGV101+1
 .byt >BBGV100+1
 .byt >BBGV099+1
 .byt >BBGV098+1
 .byt >BBGV097+1
 .byt >BBGV096+1
 .byt >BBGV095+1
 .byt >BBGV094+1
 .byt >BBGV093+1
 .byt >BBGV092+1
 .byt >BBGV091+1
 .byt >BBGV090+1
 .byt >BBGV089+1
 .byt >BBGV088+1
 .byt >BBGV087+1
 .byt >BBGV086+1
 .byt >BBGV085+1
 .byt >BBGV084+1
 .byt >BBGV083+1
 .byt >BBGV082+1
 .byt >BBGV081+1
 .byt >BBGV080+1
 .byt >BBGV079+1
 .byt >BBGV078+1
 .byt >BBGV077+1
 .byt >BBGV076+1
 .byt >BBGV075+1
 .byt >BBGV074+1
 .byt >BBGV073+1
 .byt >BBGV072+1
 .byt >BBGV071+1
 .byt >BBGV070+1
 .byt >BBGV069+1
 .byt >BBGV068+1
 .byt >BBGV067+1
 .byt >BBGV066+1
 .byt >BBGV065+1
 .byt >BBGV064+1
 .byt >BBGV063+1
 .byt >BBGV062+1
 .byt >BBGV061+1
 .byt >BBGV060+1
 .byt >BBGV059+1
 .byt >BBGV058+1
 .byt >BBGV057+1
 .byt >BBGV056+1
 .byt >BBGV055+1
 .byt >BBGV054+1
 .byt >BBGV053+1
 .byt >BBGV052+1
 .byt >BBGV051+1
 .byt >BBGV050+1
 .byt >BBGV049+1
 .byt >BBGV048+1
 .byt >BBGV047+1
 .byt >BBGV046+1
 .byt >BBGV045+1
 .byt >BBGV044+1
 .byt >BBGV043+1
 .byt >BBGV042+1
 .byt >BBGV041+1
 .byt >BBGV040+1
 .byt >BBGV039+1
 .byt >BBGV038+1
 .byt >BBGV037+1
 .byt >BBGV036+1
 .byt >BBGV035+1
 .byt >BBGV034+1
 .byt >BBGV033+1
 .byt >BBGV032+1
 .byt >BBGV031+1
 .byt >BBGV030+1
 .byt >BBGV029+1
 .byt >BBGV028+1
 .byt >BBGV027+1
 .byt >BBGV026+1
 .byt >BBGV025+1
 .byt >BBGV024+1
 .byt >BBGV023+1
 .byt >BBGV022+1
 .byt >BBGV021+1
 .byt >BBGV020+1
 .byt >BBGV019+1
 .byt >BBGV018+1
 .byt >BBGV017+1
 .byt >BBGV016+1
 .byt >BBGV015+1
 .byt >BBGV014+1
 .byt >BBGV013+1
 .byt >BBGV012+1
 .byt >BBGV011+1
 .byt >BBGV010+1
 .byt >BBGV009+1
 .byt >BBGV008+1
 .byt >BBGV007+1
 .byt >BBGV006+1
 .byt >BBGV005+1
 .byt >BBGV004+1
 .byt >BBGV003+1
 .byt >BBGV002+1
 .byt >BBGV001+1




 