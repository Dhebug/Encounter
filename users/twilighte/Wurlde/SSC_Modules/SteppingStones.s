;Stepping Stones - For SSCM-OM2S4.S
;Got the graphics now but needs a rewrite in places
;1)xRise and fall anim of individual Stones
;3)xRise and fall hero on stones (to death)
;4)xStone down one frame when hero steps on it
;5) Raise objects from ground (graphically showing object rising with stone)

;Each Stone is treated as a separate sprite with tempered rise and sink animated sequences.
;Each time the hero steps onto a stone and it sinks slightly it will trigger an event called
;SA_TRIGGER.
;SA_TRIGGER will fetch the appropriate table containing a list of triggers to perform on selected
;stones. These triggers include raising stones, sinking stones, raising items on stones and
;ultimately sinking stones with items. Items are always shown in the same manner as other items
;found on the ground.

;Defines for Stone Activities
#define	SA_WAITING	0
#define	SA_RISING		1
#define	SA_DEPRESSING	2
#define	SA_TRIGGER	3
#define	SA_SINKING	4

;Defines for Triggers
#define	SS_END		0
#define	SS_RISE_A		1
#define	SS_RISE_B		1+4*1
#define	SS_RISE_C		1+4*2
#define	SS_RISE_D		1+4*3
#define	SS_RISE_E		1+4*4
#define	SS_RISE_F		1+4*5
#define	SS_RISE_G		1+4*6
#define	SS_RISE_H		1+4*7
#define	SS_RISE_I		1+4*8
#define	SS_RISE_J		1+4*9
#define	SS_RISE_K		1+4*10
#define	SS_RISE_L		1+4*11
#define	SS_RISE_M		1+4*12
#define	SS_RISE_N		1+4*13
#define	SS_RISE_O		1+4*14

#define	SS_SINK_A		2
#define	SS_SINK_B		2+4*1
#define	SS_SINK_C		2+4*2
#define	SS_SINK_D		2+4*3
#define	SS_SINK_E		2+4*4
#define	SS_SINK_F		2+4*5
#define	SS_SINK_G		2+4*6
#define	SS_SINK_H		2+4*7
#define	SS_SINK_I		2+4*8
#define	SS_SINK_J		2+4*9
#define	SS_SINK_K		2+4*10
#define	SS_SINK_L		2+4*11
#define	SS_SINK_M		2+4*12
#define	SS_SINK_N		2+4*13
#define	SS_SINK_O		2+4*14

;Any item can be raised from the Quagmire
#define	SS_ITEM_0		3
#define	SS_ITEM_1		3+4*1 
#define	SS_ITEM_2		3+4*2 
#define	SS_ITEM_3		3+4*3 
#define	SS_ITEM_4		3+4*4 
#define	SS_ITEM_5		3+4*5 
#define	SS_ITEM_6		3+4*6 
#define	SS_ITEM_7		3+4*7 
#define	SS_ITEM_8		3+4*8 
#define	SS_ITEM_9		3+4*9 
#define	SS_ITEM_10	3+4*10
#define	SS_ITEM_11	3+4*11
#define	SS_ITEM_12	3+4*12
#define	SS_ITEM_13	3+4*13
#define	SS_ITEM_14	3+4*14
#define	SS_ITEM_15	3+4*15
#define	SS_ITEM_16	3+4*16
#define	SS_ITEM_17	3+4*17
#define	SS_ITEM_18	3+4*18
#define	SS_ITEM_19	3+4*19
#define	SS_ITEM_20	3+4*20
#define	SS_ITEM_21	3+4*21
#define	SS_ITEM_22	3+4*22
#define	SS_ITEM_23	3+4*23
#define	SS_ITEM_24	3+4*24
#define	SS_ITEM_25	3+4*25
#define	SS_ITEM_26	3+4*26
#define	SS_ITEM_27	3+4*27
#define	SS_ITEM_28	3+4*28
#define	SS_ITEM_29	3+4*29
#define	SS_ITEM_30	3+4*30
#define	SS_ITEM_31	3+4*31

;In addition to stone activity tables there is also a hero foot activity flag table for each stone
#define	SA_STEPUP		0
#define	SA_STEPDOWN	1

InitialiseStones
	; Initialise which stone should immiately rise 3(0)/34(11)
	lda #SA_RISING
	sta StoneActivity
	sta StoneActivity+14
	; Set all ct_FloorLevel to $39
	ldx #39
	lda #$39
.(
loop1	sta ct_FloorLevel,x
	dex
	bpl loop1
.)
	;Set BG Collision to 5 from 7 to 32
	ldx #24
	lda #5
.(
loop1	sta ct_BGCollisions+7,x
	dex
	bpl loop1
.)	

	;Set 3 and 34 to $38
	lda #$38
	sta ct_FloorLevel+3
	sta ct_FloorLevel+34
	rts
	

ProcessSteppingStones
	;Delay Stones
	lda GeneralStoneDelayFrac
	clc
	adc #96
	sta GeneralStoneDelayFrac
.(
	bcc skip1
	;Update each individual Stone as if it was a sprite
;	nop
;	jmp ProcessSteppingStones
	ldx #14
loop1	ldy StoneActivity,x
	lda StoneActivityVectorLo,y
	sta vector1+1
	lda StoneActivityVectorHi,y
	sta vector1+2
vector1	jsr $dead
	dex
	bpl loop1
skip1	rts
.)

GeneralStoneDelayFrac	.byt 0

saRising		;Called when a stone is rising up from the quagmire
	lda StoneFrame,x
	;0 Stone Not present
	;1 Rising Stone 0
	;2 Rising Stone 1
	;3 Rising Stone 2
	;4 Rising Stone 3 - Desired Index
	;5 Sinking Stone 0 (Depressed level)
	;6 Sinking Stone 1
	;7 Sinking Stone 2
	;Note stone may be sinking at the moment it is requested to rise
	cmp #4
.(
	beq Done
	bcc skip2	;StoneRising
	dec StoneFrame,x
	jmp skip1
skip2	inc StoneFrame,x
skip1	jmp PlotStoneAndUpdateCTTables
Done	;The maximum height has now been reached
.)
	lda #SA_WAITING
	sta StoneActivity,x
	rts
	
saSinking		;Called when a stone is sinking back into the Quagmire
	;If the stone is already sunk then progress to next stage
	lda StoneFrame,x
.(
	beq skip1
	
	;Otherwise sink stone
	dec StoneFrame,x
	jmp PlotStoneAndUpdateCTTables
skip1
.)
	lda #SA_WAITING
	sta StoneActivity,x
	rts
;	jmp PlotStoneAndUpdateCTTables
		
saDepressing	;Called when hero stands on the stone that has already risen
	lda #5
	sta StoneFrame,x
	lda #SA_TRIGGER
	sta StoneActivity,x
	jmp PlotStoneAndUpdateCTTables
	
saTrigger		;Called once stone has depressed - trigger other stones to rise or fall and items to rise
	;Fetch the address of the Stone Set
	lda StoneSetAddressLo,x
	sta source
	lda StoneSetAddressHi,x
	sta source+1
	stx StoneTempX
	ldy #00
.(
loop1	lda (source),y
	;B0-1 Trigger Type
	;     0 End of Triggers
	;     1 Trigger Stone Rise
	;     2 Trigger Stone Sink
	;     3 Trigger Object to last stone triggered
	;B2-6 Trigger Data(0-31)
	;B7   -
	and #03
	;Branch if end of triggers
	beq skip1
	;Branch to routine to handle each type of trigger
	tax
	lda TriggerVectorLo-1,x
	sta vector1+1
	lda TriggerVectorHi-1,x
	sta vector1+2
	;Fetch data part
	lda (source),y
	lsr
	lsr
vector1	jsr $dead
	;Progress to next trigger item
	iny
	jmp loop1
skip1	;Then set activity for this stone to sa_Waiting
.)
	ldx StoneTempX
	lda #SA_WAITING
	sta StoneActivity,x
	rts

saWaiting		;Called when stone has sunk or risen - Detect Hero Tread(But prevent Repeats)
	;If hero is airbourne then continue waiting
	ldy HeroAction
	lda game_HAPVector
	sta source
	lda game_HAPVector+1
	sta source+1
	lda (source),y
	and #%00000100
.(
	beq skip1

	;If the Hero is facing Right then only add 1 to HeroX
	lda (source),y
	and #%00001000
	
	;The actual xpos of the feet depends on whether the hero faces left or right.
	beq skip2

	lda HeroX
	clc
	adc #1
	jmp skip3
skip2	lda HeroX
	clc
	adc #2
skip3	tay
	lda HeroX2StoneIndex,y
	; If the evaluated index is 128 then the hero is on the ground either side of the quagmire
	bmi HeroBeyondStones

	; If the same stone as the hero was previously on then we don't want to trigger other stones again!
	cmp CurrentHeroStone
	beq skip5
	
	; Only process stone if this is the one the hero is on
	stx StoneTempX
	cmp StoneTempX
	bne skip5
	
	; Raise the old stone since we're not on it anymore
	ldy CurrentHeroStone
	lda #SA_RISING
	sta StoneActivity,y
	
	; Is the hero standing on a stone?
	lda StoneFrame,x
	beq skip4
	
	; And depress the stone the hero is now on(This stone)
	lda #SA_DEPRESSING
	sta StoneActivity,x
	stx CurrentHeroStone 
skip1	rts
skip5	; Is hero standing on sodden earth?
	lda ct_BGCollisions,y
	cmp #5
	bne skip1
skip4	; The hero now stands on the sodden earth - Decrease health gradually
.)
	lda HealthDecayFrac
	clc
	adc #16
	sta HealthDecayFrac
.(
	bcc skip1
	lda #1
	jsr game_DecreaseHealth
skip1	rts
.)

HealthDecayFrac	.byt 0

HeroBeyondStones
	;When the hero is beyond the stones, reset stones to start again
	lda #128
	sta CurrentHeroStone
	ldy #13
	lda #SA_SINKING
.(
loop1	sta StoneActivity,y
	dey
	bne loop1
.)
	jmp InitialiseStones

StoneStoodUpon
 .dsb 15,SA_STEPUP
CurrentHeroStone	.byt 0

	
;Trigger Routines
TriggerRise
	tax
	lda #SA_RISING
	sta StoneActivity,x
	stx LastStoneIndex
	rts
TriggerSink
	tax
	lda #SA_SINKING
	sta StoneActivity,x
	stx LastStoneIndex
	rts
TriggerItem
	;Fetch Last Stone Index
	ldx LastStoneIndex
	;A contains ObjectID to raise
	;Not sure how to do this yet
	rts
	
StoneActivity
 .dsb 15,0
StoneActivityVectorLo
 .byt <saWaiting
 .byt <saRising
 .byt <saDepressing
 .byt <saTrigger
 .byt <saSinking
StoneActivityVectorHi
 .byt >saWaiting
 .byt >saRising
 .byt >saDepressing
 .byt >saTrigger
 .byt >saSinking
StoneFrame
 .dsb 15,0
StoneTempX	.byt 0
LastStoneIndex	.byt 0
TriggerVectorLo
 .byt <TriggerRise
 .byt <TriggerSink
 .byt <TriggerItem
TriggerVectorHi
 .byt >TriggerRise
 .byt >TriggerSink
 .byt >TriggerItem
;0123456789012345678901234567890123456789
;XXXXX--..--..--..--..--..--..--..--XXXXX
;Hero|                               |
;Whilst this is visually true in reality because the Hero is offset by the display it is..
;   |                              |      <<Real HeroX
;And is also dependant on whether the hero is facing left or right which adds further confusion!
;    
HeroX2StoneIndex
 .byt 128,128,128,128,128
 .byt 0,0
 .byt 1,1
 .byt 2,2
 .byt 3,3
 .byt 4,4
 .byt 5,5
 .byt 6,6
 .byt 7,7
 .byt 8,8
 .byt 9,9
 .byt 10,10
 .byt 11,11
 .byt 12,12
 .byt 13,13
 .byt 14,14
 .byt 128,128,128,128,128
	
PlotStoneAndUpdateCTTables
	;Plot Stone Frame
	txa
	asl
	asl
	asl
	ora StoneFrame,x
	tay
	lda StoneGraphicFrameAddressLo,y
.(
	sta StoneGFX+1
	lda StoneGraphicFrameAddressHi,y
	sta StoneGFX+2
	lda StoneScreenLocLo,x
	sta screen
	lda StoneScreenLocHi,x
	sta screen+1
	stx StoneTempX
	ldx #7
loop1	ldy StoneGraphicScreenOffset,x
StoneGFX	lda $dead,x
	sta (screen),y
	dex
	bpl loop1
.)	
	ldx StoneTempX
;	rts
	;Fetch the left byte index for CT tables where we'll put the collision data
	ldy Stone2XPOS,x
	;Fetch the ct_FloorLevel appropriate to this stone
	lda StoneFrame,x
	tax
	lda StoneFrame2CTFloorLevel,x
	sta ct_FloorLevel,y
	sta ct_FloorLevel+1,y
	lda StoneFrame2CTCollision,x
	sta ct_BGCollisions,y
	sta ct_BGCollisions+1,y
	ldx StoneTempX
	rts

;0 Stone Not present
;1 Rising Stone 0
;2 Rising Stone 1
;3 Rising Stone 2
;4 Rising Stone 3 - Desired Index
;5 Sinking Stone 0 (Depressed level)
;6 Sinking Stone 1
;7 Sinking Stone 2

;The level may either be $38(High) or $39(Low)
StoneFrame2CTFloorLevel
 .byt $39
 .byt $39
 .byt $39
 .byt $38
 .byt $38
 .byt $38
 .byt $38
 .byt $39

;The collision may either be 0(No Collision) or 5(Hurt)
StoneFrame2CTCollision
 .byt 5
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 5

Stone2XPOS
 .byt 5,7,9,11,13,15,17,19,21,23,25,27,29,31,33

StoneScreenLocLo
 .byt <$B8DD
 .byt <$B8DD+2*1
 .byt <$B8DD+2*2
 .byt <$B8DD+2*3
 .byt <$B8DD+2*4
 .byt <$B8DD+2*5
 .byt <$B8DD+2*6
 .byt <$B8DD+2*7
 .byt <$B8DD+2*8
 .byt <$B8DD+2*9
 .byt <$B8DD+2*10
 .byt <$B8DD+2*11
 .byt <$B8DD+2*12
 .byt <$B8DD+2*13
 .byt <$B8DD+2*14
StoneScreenLocHi
 .byt >$B8DD
 .byt >$B8DD+2*1
 .byt >$B8DD+2*2
 .byt >$B8DD+2*3
 .byt >$B8DD+2*4
 .byt >$B8DD+2*5
 .byt >$B8DD+2*6
 .byt >$B8DD+2*7
 .byt >$B8DD+2*8
 .byt >$B8DD+2*9
 .byt >$B8DD+2*10
 .byt >$B8DD+2*11
 .byt >$B8DD+2*12
 .byt >$B8DD+2*13
 .byt >$B8DD+2*14

StoneGraphicScreenOffset
 .byt 0,1
 .byt 40,41
 .byt 80,81
 .byt 120,121
;Indexed by (SteppingStoneIndex x 8) ORA Frame
StoneGraphicFrameAddressLo
 .byt <SteppingStoneGraphic0_Frame0	;Normal Background
 .byt <SteppingStoneGraphic0_Frame1	;Rising frames
 .byt <SteppingStoneGraphic0_Frame2
 .byt <SteppingStoneGraphic0_Frame3
 .byt <SteppingStoneGraphic0_Frame4	;Stones Highest
 .byt <SteppingStoneGraphic0_Frame3	;Falling frames & Once Hero stands on it
 .byt <SteppingStoneGraphic0_Frame2
 .byt <SteppingStoneGraphic0_Frame1


 .byt <SteppingStoneGraphic1_Frame0
 .byt <SteppingStoneGraphic1_Frame1
 .byt <SteppingStoneGraphic1_Frame2
 .byt <SteppingStoneGraphic1_Frame3
 .byt <SteppingStoneGraphic1_Frame4
 .byt <SteppingStoneGraphic1_Frame3
 .byt <SteppingStoneGraphic1_Frame2
 .byt <SteppingStoneGraphic1_Frame1

 .byt <SteppingStoneGraphic2_Frame0 
 .byt <SteppingStoneGraphic2_Frame1 
 .byt <SteppingStoneGraphic2_Frame2 
 .byt <SteppingStoneGraphic2_Frame3 
 .byt <SteppingStoneGraphic2_Frame4 
 .byt <SteppingStoneGraphic2_Frame3 
 .byt <SteppingStoneGraphic2_Frame2 
 .byt <SteppingStoneGraphic2_Frame1 
                                    
 .byt <SteppingStoneGraphic3_Frame0 
 .byt <SteppingStoneGraphic3_Frame1 
 .byt <SteppingStoneGraphic3_Frame2 
 .byt <SteppingStoneGraphic3_Frame3 
 .byt <SteppingStoneGraphic3_Frame4 
 .byt <SteppingStoneGraphic3_Frame3 
 .byt <SteppingStoneGraphic3_Frame2 
 .byt <SteppingStoneGraphic3_Frame1 
                                    
 .byt <SteppingStoneGraphic4_Frame0 
 .byt <SteppingStoneGraphic4_Frame1 
 .byt <SteppingStoneGraphic4_Frame2 
 .byt <SteppingStoneGraphic4_Frame3 
 .byt <SteppingStoneGraphic4_Frame4 
 .byt <SteppingStoneGraphic4_Frame3 
 .byt <SteppingStoneGraphic4_Frame2 
 .byt <SteppingStoneGraphic4_Frame1 
                                    
 .byt <SteppingStoneGraphic5_Frame0 
 .byt <SteppingStoneGraphic5_Frame1 
 .byt <SteppingStoneGraphic5_Frame2 
 .byt <SteppingStoneGraphic5_Frame3 
 .byt <SteppingStoneGraphic5_Frame4 
 .byt <SteppingStoneGraphic5_Frame3 
 .byt <SteppingStoneGraphic5_Frame2 
 .byt <SteppingStoneGraphic5_Frame1 
                                    
 .byt <SteppingStoneGraphic6_Frame0 
 .byt <SteppingStoneGraphic6_Frame1 
 .byt <SteppingStoneGraphic6_Frame2 
 .byt <SteppingStoneGraphic6_Frame3 
 .byt <SteppingStoneGraphic6_Frame4 
 .byt <SteppingStoneGraphic6_Frame3 
 .byt <SteppingStoneGraphic6_Frame2 
 .byt <SteppingStoneGraphic6_Frame1 
                                    
 .byt <SteppingStoneGraphic7_Frame0 
 .byt <SteppingStoneGraphic7_Frame1 
 .byt <SteppingStoneGraphic7_Frame2 
 .byt <SteppingStoneGraphic7_Frame3 
 .byt <SteppingStoneGraphic7_Frame4 
 .byt <SteppingStoneGraphic7_Frame3 
 .byt <SteppingStoneGraphic7_Frame2 
 .byt <SteppingStoneGraphic7_Frame1 
                                    
 .byt <SteppingStoneGraphic8_Frame0 
 .byt <SteppingStoneGraphic8_Frame1 
 .byt <SteppingStoneGraphic8_Frame2 
 .byt <SteppingStoneGraphic8_Frame3 
 .byt <SteppingStoneGraphic8_Frame4 
 .byt <SteppingStoneGraphic8_Frame3 
 .byt <SteppingStoneGraphic8_Frame2 
 .byt <SteppingStoneGraphic8_Frame1 
                                    
 .byt <SteppingStoneGraphic9_Frame0 
 .byt <SteppingStoneGraphic9_Frame1 
 .byt <SteppingStoneGraphic9_Frame2 
 .byt <SteppingStoneGraphic9_Frame3 
 .byt <SteppingStoneGraphic9_Frame4 
 .byt <SteppingStoneGraphic9_Frame3 
 .byt <SteppingStoneGraphic9_Frame2 
 .byt <SteppingStoneGraphic9_Frame1 
                                    
 .byt <SteppingStoneGraphicA_Frame0 
 .byt <SteppingStoneGraphicA_Frame1 
 .byt <SteppingStoneGraphicA_Frame2 
 .byt <SteppingStoneGraphicA_Frame3 
 .byt <SteppingStoneGraphicA_Frame4 
 .byt <SteppingStoneGraphicA_Frame3 
 .byt <SteppingStoneGraphicA_Frame2 
 .byt <SteppingStoneGraphicA_Frame1 
                                    
 .byt <SteppingStoneGraphicB_Frame0 
 .byt <SteppingStoneGraphicB_Frame1 
 .byt <SteppingStoneGraphicB_Frame2 
 .byt <SteppingStoneGraphicB_Frame3 
 .byt <SteppingStoneGraphicB_Frame4 
 .byt <SteppingStoneGraphicB_Frame3 
 .byt <SteppingStoneGraphicB_Frame2 
 .byt <SteppingStoneGraphicB_Frame1 
                                    
 .byt <SteppingStoneGraphicC_Frame0 
 .byt <SteppingStoneGraphicC_Frame1 
 .byt <SteppingStoneGraphicC_Frame2 
 .byt <SteppingStoneGraphicC_Frame3 
 .byt <SteppingStoneGraphicC_Frame4 
 .byt <SteppingStoneGraphicC_Frame3 
 .byt <SteppingStoneGraphicC_Frame2 
 .byt <SteppingStoneGraphicC_Frame1 
                                    
 .byt <SteppingStoneGraphicD_Frame0 
 .byt <SteppingStoneGraphicD_Frame1 
 .byt <SteppingStoneGraphicD_Frame2 
 .byt <SteppingStoneGraphicD_Frame3 
 .byt <SteppingStoneGraphicD_Frame4 
 .byt <SteppingStoneGraphicD_Frame3 
 .byt <SteppingStoneGraphicD_Frame2 
 .byt <SteppingStoneGraphicD_Frame1 
                                    
 .byt <SteppingStoneGraphicE_Frame0 
 .byt <SteppingStoneGraphicE_Frame1 
 .byt <SteppingStoneGraphicE_Frame2 
 .byt <SteppingStoneGraphicE_Frame3 
 .byt <SteppingStoneGraphicE_Frame4 
 .byt <SteppingStoneGraphicE_Frame3 
 .byt <SteppingStoneGraphicE_Frame2 
 .byt <SteppingStoneGraphicE_Frame1 
                                    
StoneGraphicFrameAddressHi
 .byt >SteppingStoneGraphic0_Frame0
 .byt >SteppingStoneGraphic0_Frame1
 .byt >SteppingStoneGraphic0_Frame2
 .byt >SteppingStoneGraphic0_Frame3
 .byt >SteppingStoneGraphic0_Frame4
 .byt >SteppingStoneGraphic0_Frame3
 .byt >SteppingStoneGraphic0_Frame2
 .byt >SteppingStoneGraphic0_Frame1

 .byt >SteppingStoneGraphic1_Frame0
 .byt >SteppingStoneGraphic1_Frame1
 .byt >SteppingStoneGraphic1_Frame2
 .byt >SteppingStoneGraphic1_Frame3
 .byt >SteppingStoneGraphic1_Frame4
 .byt >SteppingStoneGraphic1_Frame3
 .byt >SteppingStoneGraphic1_Frame2
 .byt >SteppingStoneGraphic1_Frame1

 .byt >SteppingStoneGraphic2_Frame0 
 .byt >SteppingStoneGraphic2_Frame1 
 .byt >SteppingStoneGraphic2_Frame2 
 .byt >SteppingStoneGraphic2_Frame3 
 .byt >SteppingStoneGraphic2_Frame4 
 .byt >SteppingStoneGraphic2_Frame3 
 .byt >SteppingStoneGraphic2_Frame2 
 .byt >SteppingStoneGraphic2_Frame1 
                                    
 .byt >SteppingStoneGraphic3_Frame0 
 .byt >SteppingStoneGraphic3_Frame1 
 .byt >SteppingStoneGraphic3_Frame2 
 .byt >SteppingStoneGraphic3_Frame3 
 .byt >SteppingStoneGraphic3_Frame4 
 .byt >SteppingStoneGraphic3_Frame3 
 .byt >SteppingStoneGraphic3_Frame2 
 .byt >SteppingStoneGraphic3_Frame1 
                                    
 .byt >SteppingStoneGraphic4_Frame0 
 .byt >SteppingStoneGraphic4_Frame1 
 .byt >SteppingStoneGraphic4_Frame2 
 .byt >SteppingStoneGraphic4_Frame3 
 .byt >SteppingStoneGraphic4_Frame4 
 .byt >SteppingStoneGraphic4_Frame3 
 .byt >SteppingStoneGraphic4_Frame2 
 .byt >SteppingStoneGraphic4_Frame1 
                                    
 .byt >SteppingStoneGraphic5_Frame0 
 .byt >SteppingStoneGraphic5_Frame1 
 .byt >SteppingStoneGraphic5_Frame2 
 .byt >SteppingStoneGraphic5_Frame3 
 .byt >SteppingStoneGraphic5_Frame4 
 .byt >SteppingStoneGraphic5_Frame3 
 .byt >SteppingStoneGraphic5_Frame2 
 .byt >SteppingStoneGraphic5_Frame1 
                                    
 .byt >SteppingStoneGraphic6_Frame0 
 .byt >SteppingStoneGraphic6_Frame1 
 .byt >SteppingStoneGraphic6_Frame2 
 .byt >SteppingStoneGraphic6_Frame3 
 .byt >SteppingStoneGraphic6_Frame4 
 .byt >SteppingStoneGraphic6_Frame3 
 .byt >SteppingStoneGraphic6_Frame2 
 .byt >SteppingStoneGraphic6_Frame1 
                                    
 .byt >SteppingStoneGraphic7_Frame0 
 .byt >SteppingStoneGraphic7_Frame1 
 .byt >SteppingStoneGraphic7_Frame2 
 .byt >SteppingStoneGraphic7_Frame3 
 .byt >SteppingStoneGraphic7_Frame4 
 .byt >SteppingStoneGraphic7_Frame3 
 .byt >SteppingStoneGraphic7_Frame2 
 .byt >SteppingStoneGraphic7_Frame1 
                                    
 .byt >SteppingStoneGraphic8_Frame0 
 .byt >SteppingStoneGraphic8_Frame1 
 .byt >SteppingStoneGraphic8_Frame2 
 .byt >SteppingStoneGraphic8_Frame3 
 .byt >SteppingStoneGraphic8_Frame4 
 .byt >SteppingStoneGraphic8_Frame3 
 .byt >SteppingStoneGraphic8_Frame2 
 .byt >SteppingStoneGraphic8_Frame1 
                                    
 .byt >SteppingStoneGraphic9_Frame0 
 .byt >SteppingStoneGraphic9_Frame1 
 .byt >SteppingStoneGraphic9_Frame2 
 .byt >SteppingStoneGraphic9_Frame3 
 .byt >SteppingStoneGraphic9_Frame4 
 .byt >SteppingStoneGraphic9_Frame3 
 .byt >SteppingStoneGraphic9_Frame2 
 .byt >SteppingStoneGraphic9_Frame1 
                                    
 .byt >SteppingStoneGraphicA_Frame0 
 .byt >SteppingStoneGraphicA_Frame1 
 .byt >SteppingStoneGraphicA_Frame2 
 .byt >SteppingStoneGraphicA_Frame3 
 .byt >SteppingStoneGraphicA_Frame4 
 .byt >SteppingStoneGraphicA_Frame3 
 .byt >SteppingStoneGraphicA_Frame2 
 .byt >SteppingStoneGraphicA_Frame1 

 .byt >SteppingStoneGraphicB_Frame0 
 .byt >SteppingStoneGraphicB_Frame1 
 .byt >SteppingStoneGraphicB_Frame2 
 .byt >SteppingStoneGraphicB_Frame3 
 .byt >SteppingStoneGraphicB_Frame4 
 .byt >SteppingStoneGraphicB_Frame3 
 .byt >SteppingStoneGraphicB_Frame2 
 .byt >SteppingStoneGraphicB_Frame1 

 .byt >SteppingStoneGraphicC_Frame0 
 .byt >SteppingStoneGraphicC_Frame1 
 .byt >SteppingStoneGraphicC_Frame2 
 .byt >SteppingStoneGraphicC_Frame3 
 .byt >SteppingStoneGraphicC_Frame4 
 .byt >SteppingStoneGraphicC_Frame3 
 .byt >SteppingStoneGraphicC_Frame2 
 .byt >SteppingStoneGraphicC_Frame1 

 .byt >SteppingStoneGraphicD_Frame0 
 .byt >SteppingStoneGraphicD_Frame1 
 .byt >SteppingStoneGraphicD_Frame2 
 .byt >SteppingStoneGraphicD_Frame3 
 .byt >SteppingStoneGraphicD_Frame4 
 .byt >SteppingStoneGraphicD_Frame3 
 .byt >SteppingStoneGraphicD_Frame2 
 .byt >SteppingStoneGraphicD_Frame1 

 .byt >SteppingStoneGraphicE_Frame0 
 .byt >SteppingStoneGraphicE_Frame1 
 .byt >SteppingStoneGraphicE_Frame2 
 .byt >SteppingStoneGraphicE_Frame3 
 .byt >SteppingStoneGraphicE_Frame4 
 .byt >SteppingStoneGraphicE_Frame3 
 .byt >SteppingStoneGraphicE_Frame2 
 .byt >SteppingStoneGraphicE_Frame1 

;Graphics run for each stepping stone (11)
;Frames run for each height 0(Not Present) - 4(Full height) (5x8x15==600 Bytes)
SteppingStoneGraphic0_Frame4
 .byt $5F,$5C
 .byt $7E,$7E
 .byt $D5,$D5
 .byt $91,$C1
SteppingStoneGraphic1_Frame4
 .byt $5F,$5C
 .byt $7E,$6E
 .byt $D5,$D5
 .byt $C0,$16
SteppingStoneGraphic2_Frame4
 .byt $5F,$5C
 .byt $7F,$7E
 .byt $D5,$D5
 .byt $16,$7F
SteppingStoneGraphic3_Frame4
 .byt $5D,$5C
 .byt $7F,$7E
 .byt $D5,$D5
 .byt $7F,$16
SteppingStoneGraphic4_Frame4
 .byt $5F,$5C
 .byt $7F,$6E
 .byt $D5,$F5
 .byt $16,$7F
SteppingStoneGraphic5_Frame4
 .byt $5F,$5C
 .byt $7E,$6E
 .byt $D5,$D1
 .byt $91,$C3
SteppingStoneGraphic6_Frame4
 .byt $5F,$7C
 .byt $7F,$7E
 .byt $D5,$D5
 .byt $C0,$C1
SteppingStoneGraphic7_Frame4
 .byt $5E,$7C
 .byt $7F,$7E
 .byt $D5,$D5
 .byt $C0,$C1
SteppingStoneGraphic8_Frame4
 .byt $5F,$5C
 .byt $7F,$7E
 .byt $D5,$D5
 .byt $C0,$C1
SteppingStoneGraphic9_Frame4
 .byt $5F,$5C
 .byt $7E,$6E
 .byt $D4,$EB
 .byt $7F,$91
SteppingStoneGraphicA_Frame4
 .byt $5F,$5C
 .byt $7F,$6E
 .byt $E2,$E9
 .byt $C0,$C1
SteppingStoneGraphicB_Frame4
 .byt $5F,$5C
 .byt $7F,$7E
 .byt $D5,$D5
 .byt $7F,$7E
SteppingStoneGraphicC_Frame4
 .byt $5B,$5C
 .byt $7F,$7E
 .byt $81,$E9
 .byt $7F,$D5
SteppingStoneGraphicD_Frame4
 .byt $5F,$5C
 .byt $7E,$6E
 .byt $D5,$D5
 .byt $7F,$91
SteppingStoneGraphicE_Frame4
 .byt $5F,$5C
 .byt $7E,$7E
 .byt $D5,$91
 .byt $16,$40

SteppingStoneGraphic0_Frame3
 .byt $40,$40
 .byt $5F,$5C
 .byt $D5,$D5
 .byt $91,$C1
SteppingStoneGraphic1_Frame3
 .byt $40,$40
 .byt $5F,$5C
 .byt $D5,$D5
 .byt $C0,$16
SteppingStoneGraphic2_Frame3
 .byt $40,$40
 .byt $5F,$5C
 .byt $D5,$D5
 .byt $16,$7F
SteppingStoneGraphic3_Frame3
 .byt $40,$40
 .byt $5D,$5C
 .byt $D5,$D5
 .byt $7F,$16
SteppingStoneGraphic4_Frame3
 .byt $40,$40
 .byt $5F,$5C
 .byt $D5,$F5
 .byt $16,$7F
SteppingStoneGraphic5_Frame3
 .byt $40,$40
 .byt $5F,$5C
 .byt $D5,$D1
 .byt $91,$C3
SteppingStoneGraphic6_Frame3
 .byt $40,$40
 .byt $5F,$7C
 .byt $D5,$D5
 .byt $C0,$C1
SteppingStoneGraphic7_Frame3
 .byt $40,$40
 .byt $5E,$7C
 .byt $D5,$D5
 .byt $C0,$C1
SteppingStoneGraphic8_Frame3
 .byt $40,$40
 .byt $5F,$5C
 .byt $D5,$D5
 .byt $C0,$C1
SteppingStoneGraphic9_Frame3
 .byt $40,$40
 .byt $5F,$5C
 .byt $D4,$EB
 .byt $7F,$91
SteppingStoneGraphicA_Frame3
 .byt $40,$40
 .byt $5F,$5C
 .byt $E2,$E9
 .byt $C0,$C1
SteppingStoneGraphicB_Frame3
 .byt $40,$40
 .byt $5F,$5C
 .byt $D5,$D5
 .byt $7F,$7E
SteppingStoneGraphicC_Frame3
 .byt $40,$40
 .byt $5B,$5C
 .byt $81,$E9
 .byt $7F,$D5
SteppingStoneGraphicD_Frame3
 .byt $40,$40
 .byt $5F,$5C
 .byt $D5,$D5
 .byt $7F,$91
SteppingStoneGraphicE_Frame3
 .byt $40,$40
 .byt $5F,$5C
 .byt $D5,$91
 .byt $16,$40

SteppingStoneGraphic0_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$D5
 .byt $91,$C1
SteppingStoneGraphic1_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$D5
 .byt $C0,$16
SteppingStoneGraphic2_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$D5
 .byt $16,$7F
SteppingStoneGraphic3_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$D5
 .byt $7F,$16
SteppingStoneGraphic4_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$F5
 .byt $16,$7F
SteppingStoneGraphic5_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$D1
 .byt $91,$C3
SteppingStoneGraphic6_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$D5
 .byt $C0,$C1
SteppingStoneGraphic7_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$D5
 .byt $C0,$C1
SteppingStoneGraphic8_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$D5
 .byt $C0,$C1
SteppingStoneGraphic9_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D4,$EB
 .byt $7F,$91
SteppingStoneGraphicA_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $E2,$E9
 .byt $C0,$C1
SteppingStoneGraphicB_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$D5
 .byt $7F,$7E
SteppingStoneGraphicC_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $81,$E9
 .byt $7F,$D5
SteppingStoneGraphicD_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$D5
 .byt $7F,$91
SteppingStoneGraphicE_Frame2
 .byt $40,$40
 .byt $40,$40
 .byt $D5,$91
 .byt $16,$40

SteppingStoneGraphic0_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $91,$C1
SteppingStoneGraphic1_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $C0,$16
SteppingStoneGraphic2_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $16,$7F
SteppingStoneGraphic3_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $7F,$16
SteppingStoneGraphic4_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $75,$55
 .byt $16,$7F
SteppingStoneGraphic5_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $50,$55
 .byt $91,$C3
SteppingStoneGraphic6_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $C0,$C1
SteppingStoneGraphic7_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $C0,$C1
SteppingStoneGraphic8_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $55,$54
 .byt $C0,$C1
SteppingStoneGraphic9_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $6A,$62
 .byt $7F,$91
SteppingStoneGraphicA_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $69,$55
 .byt $C0,$C1
SteppingStoneGraphicB_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $54,$01
 .byt $7F,$7E
SteppingStoneGraphicC_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $69,$55
 .byt $7F,$D5
SteppingStoneGraphicD_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $7F,$91
SteppingStoneGraphicE_Frame1
 .byt $40,$40
 .byt $40,$40
 .byt $11,$4A
 .byt $16,$40
 
SteppingStoneGraphic0_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $7F,$7F
SteppingStoneGraphic1_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $16,$16
SteppingStoneGraphic2_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $7F,$7F
SteppingStoneGraphic3_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $16,$16
SteppingStoneGraphic4_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $75,$55
 .byt $7F,$11
SteppingStoneGraphic5_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $50,$55
 .byt $43,$7F
SteppingStoneGraphic6_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $7F,$7F
SteppingStoneGraphic7_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $7F,$7F
SteppingStoneGraphic8_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $55,$54
 .byt $7F,$7F
SteppingStoneGraphic9_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $6A,$62
 .byt $11,$7F
SteppingStoneGraphicA_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $69,$55
 .byt $7F,$7F
SteppingStoneGraphicB_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $54,$01
 .byt $7F,$7F
SteppingStoneGraphicC_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $69,$55
 .byt $6A,$7F
SteppingStoneGraphicD_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $55,$55
 .byt $11,$16
SteppingStoneGraphicE_Frame0
 .byt $40,$40
 .byt $40,$40
 .byt $11,$4A
 .byt $40,$7F

;>>>>>>******************

;Each time the hero steps onto a stone and sinks slightly it will trigger a special
;event called SA_TRIGGER.
;SA_TRIGGER indexes a table that triggers one or more other stones to rise or sink.
;Note - The hero must pick up the parchment found just beyond the stones to know
;       the correct sequence of steps and leeps to perform.

;B0-1 Trigger Type
;     0 End of Triggers
;     1 Trigger Stone Rise
;     2 Trigger Stone Fall
;     3 Trigger Object to last stone triggered
;B2-6 Trigger Data(0-31)
;B7   Raise stone/Item only if Pergas Subgame active

StoneSetAddressLo
 .byt <StoneSetA
 .byt <StoneSetB
 .byt <StoneSetC
 .byt <StoneSetD
 .byt <StoneSetE
 .byt <StoneSetF
 .byt <StoneSetG
 .byt <StoneSetH
 .byt <StoneSetI
 .byt <StoneSetJ
 .byt <StoneSetK
 .byt <StoneSetL
 .byt <StoneSetM
 .byt <StoneSetN
 .byt <StoneSetO
 
StoneSetAddressHi
 .byt >StoneSetA
 .byt >StoneSetB
 .byt >StoneSetC
 .byt >StoneSetD
 .byt >StoneSetE
 .byt >StoneSetF
 .byt >StoneSetG
 .byt >StoneSetH
 .byt >StoneSetI
 .byt >StoneSetJ
 .byt >StoneSetK
 .byt >StoneSetL
 .byt >StoneSetM
 .byt >StoneSetN
 .byt >StoneSetO

;Right to Left
;LKGHIEA
;      Rising in silvery
;      ink,the note says
;      Like King Galdwine
;      Hide In Every Area

;Do everything with just one stone set since the rising stones are always
;based on the last stone stood upon, and for any given stone the raised stones are always
;the same.
;So whilst stepping on A will raise Stones B and E, stepping on E will raise a different path
;than stepping on B and because stepping on a stone later in path may raise a 'familiar path'
;it won't sink other stones around it so the stone that triggered the 'familiar path' may also
;trigger a stone not associated to the 'familiar path' and thereby lead the hero to another
;path.
;Stepping on A or O will always raise the path stone and sink all other stones. This is the
;reset mechanism.
;ABCDEFGHIJKLMNO
;2   3         1
; 2      3 1
;     21  2  3
;       12    3
;   1        2

;Passage Left
;OKGHD
;ABCDEFGHIJKLMNO
;              -
;          -
;      -
;       -   
;   -       -
;
;Passage Right
;AEIJN
;ABCxEFxxIJxxMNx
;-
;    -
;        -
;         -   
;     -       -
;Pergas Pipe(AEIJFBCGHLN) is just an extension of this where F raises B..
;
; -
;  v   -
;       -
;           v=
StoneSetA
 .byt SS_RISE_E	;Normal Passage Right
 .byt SS_SINK_B	;Normal Passage Right
 .byt SS_SINK_C	;Normal Passage Right
 .byt SS_SINK_D	;Normal Passage Right
 .byt SS_SINK_F	;Normal Passage Right
 .byt SS_SINK_G	;Normal Passage Right
 .byt SS_SINK_H	;Normal Passage Right
 .byt SS_SINK_I	;Normal Passage Right
 .byt SS_SINK_J	;Normal Passage Right
 .byt SS_SINK_K	;Normal Passage Right
 .byt SS_SINK_L	;Normal Passage Right
 .byt SS_SINK_M	;Normal Passage Right
 .byt SS_SINK_N	;Normal Passage Right
 .byt SS_SINK_O	;Normal Passage Right
 .byt SS_END
StoneSetB
 .byt SS_RISE_C	;Pergas Pipe Path
 .byt SS_SINK_F	;Pergas Pipe Path
 .byt SS_END
StoneSetC
 .byt SS_SINK_C	;Pergas Pipe Path(Collapsing platform)
 .byt SS_RISE_G	;Pergas Pipe Path
 .byt SS_RISE_L	;Pergas Pipe Path
 .byt SS_RISE_M	;Pergas Pipe Path
; .byt SS_ITEM_?	;Pergas Pipe Path
 .byt SS_SINK_B	;Pergas Pipe Path
 .byt SS_END
StoneSetD
 .byt SS_SINK_H	;Normal Passage Left
 .byt SS_END
StoneSetE
 .BYT SS_RISE_I	;Normal Passage Right
 .byt SS_SINK_A	;Normal Passage Right
 .byt SS_END
StoneSetF
 .byt SS_RISE_B	;Pergas Pipe Path
 .byt SS_SINK_J	;Pergas Pipe Path
 .byt SS_END
StoneSetG
 .byt SS_RISE_H	;Normal Passage Left
 .byt SS_RISE_L	;Red Herring on Passage Left
 .byt SS_SINK_K	;Normal Passage Left
 .byt SS_END
StoneSetH
 .byt SS_RISE_D	;Normal Passage Left
 .byt SS_SINK_G	;Normal Passage Left
 .byt SS_END
StoneSetI
 .byt SS_RISE_J	;Normal Passage Right
 .byt SS_SINK_E	;Normal Passage Right
 .byt SS_END
StoneSetJ
 .byt SS_RISE_N	;Normal Passage Right
 .byt SS_RISE_F	;Split from passage right to Pergas Pipe Path
 .byt SS_SINK_I	;Normal Passage Right
 .byt SS_END
StoneSetK
 .byt SS_RISE_G	;Normal Passage Left
 .byt SS_SINK_O	;Normal Passage Left
 .byt SS_END
StoneSetL
 .byt SS_END
StoneSetM
 .byt SS_END
StoneSetN
 .byt SS_SINK_J	;Normal Passage Right
 .byt SS_END
StoneSetO
 .byt SS_RISE_K	;Normal Passage Left
 .byt SS_SINK_A	;Normal Passage Left
 .byt SS_SINK_B	;Normal Passage Left
 .byt SS_SINK_C	;Normal Passage Left
 .byt SS_SINK_D	;Normal Passage Left
 .byt SS_SINK_E	;Normal Passage Left
 .byt SS_SINK_F	;Normal Passage Left
 .byt SS_SINK_G	;Normal Passage Left
 .byt SS_SINK_H	;Normal Passage Left
 .byt SS_SINK_I	;Normal Passage Left
 .byt SS_SINK_J	;Normal Passage Left
 .byt SS_SINK_L	;Normal Passage Left
 .byt SS_SINK_M	;Normal Passage Left
 .byt SS_SINK_N	;Normal Passage Left
 .byt SS_END

 .bss
#include "C:\OSDK\Projects\Wurlde\PlayerFile\PlayerFile.s"
