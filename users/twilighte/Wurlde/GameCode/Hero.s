;Hero.s
;Each Hero Sprite frame is a different size!

HeroControl
;	lda #1
;	sta KeyRegister
	lda KeyRegister
.(
	beq skip2
	;Each action has a list of permitted key combinations
	ldx HeroAction
	lda PermittedKeysListLo,x
	sta vector1+1
	lda PermittedKeysListHi,x
	sta vector1+2
	ldy PermittedKeysListLength,x
	lda KeyRegister
vector1	cmp $dead,y
	beq skip1
	dey
	bpl vector1
skip2	jmp ContinueAction
skip1	;Valid key for action found
.)
	;Index vector table with current action
	lda KeyActionVectorLo,x
.(
	sta vector1+1
	lda KeyActionVectorHi,x
	sta vector1+2
	lda KeyRegister
	;Jump to specific action
vector1	jsr $dead
.)
	rts

CyclePocketLeft
	;Cycle Pocket Pointer left (0-9) but prohibit repeat
	lda CyclePocketRepeating
.(
	bne skip1
	inc CyclePocketRepeating

	lda HeroSelectedPocket
	cmp #00
	bne skip2
	lda #10
skip2	sec
	sbc #01
	sta HeroSelectedPocket
	jsr UpdateInventoryPointer
	jsr DisplayHeroItemText
skip1	rts
.)

CyclePocketRight
	;Cycle Pocket Pointer right (0-9) but prohibit repeat
	lda CyclePocketRepeating
.(
	bne skip1
	inc CyclePocketRepeating

	lda HeroSelectedPocket
	cmp #09
	bcc skip2
	lda #255
skip2	clc
	adc #01
	sta HeroSelectedPocket
	jsr UpdateInventoryPointer
	jsr DisplayHeroItemText
skip1	rts
.)

CyclePocketRepeating	.byt 0


haStandLeft	;Permit L R U UL A AI I IL IR IU ID
	;Look for Left
	cmp #kcL
.(
	bne skip1
	lda #hcRunLeft
	jmp InitAction

skip1	;Look for Right
	cmp #kcR
.)
.(
	bne skip1
	lda #hcLeftTurnRight
	jmp InitAction

skip1	;Look for Up Left (Jump)
	cmp #kcU+kcL
.)
.(
	bne skip1
	lda ssc_ScreenRules
	and #lsProhibitJump
	bne skip2
	lda #hcStandingJumpLeft
	jmp InitAction
skip2	rts

skip1	;Look for Item Up (Pickup)
	cmp #kcI+kcU
.)
.(
	bne skip1
	;Pick Up Item Left
	;Whilst there may be no item to pickup the actual move should
	;still be performed.
	lda #hcPickupLeft
	jsr InitAction
	;Check if this key is valid to trigger ProcAction
	lda ssc_RecognisedAction
	and #%00001000
	beq skip2
	jmp ssc_ProcAction
skip2	rts

skip1	;Look for Item Down (Drop)
	cmp #kcI+kcD
.)
.(
	bne skip1
	;Drop Item
	lda #hcDropLeft
	jmp InitAction

skip1	;Look for Item Action - Use currently selected item
	cmp #kcI+kcA
.)
.(
	bne skip1
	jmp UseItem
	
skip1	;Look for Action (Call SSC ProcAction)
	cmp #kcA
.)
.(
	bne skip1
	;Action Key - Check if this key is valid to trigger ProcAction
	lda ssc_RecognisedAction
	and #%00000001
	beq skip1
	jmp ssc_ProcAction

skip1	;Look for Item Left (Navigate pocket pointer left)
	cmp #kcI + kcL
.)
.(
	bne skip1
	;Cycle Pocket Pointer left (0-9)
	jmp CyclePocketLeft

skip1	;Look for Item Right (Navigate pocket pointer Right)
	cmp #kcI+kcR
.)
.(
	bne skip1
	;Cycle Pocket Pointer right (0-9)
	jmp CyclePocketRight

skip1	;Reset Repeat Flag for Cycle Pocket routine
	ldy #00
	sty CyclePocketRepeating

	;Look for Item (Call SSC ProcAction)
	cmp #kcI
.)
.(
	bne skip1
	lda ssc_RecognisedAction
	and #%00000010
	beq skip1
	jmp ssc_ProcAction

skip1	;Look for Action (Call SSC ProcAction)
	cmp #kcU
.)
.(
	bne skip1
	;Action Key - Check if this key is valid to trigger ProcAction
	lda ssc_RecognisedAction
	and #%00010000
	beq skip1
	jmp ssc_ProcAction

skip1	rts
.)

haStandRight	;LRU FU FD
	;Look for Right (Run)
	cmp #kcR
.(
	bne skip1
	lda #hcRunRight
	jmp InitAction

skip1	;Look for Left (Turn)
	cmp #kcL
.)
.(
	bne skip1
	lda #hcRightTurnLeft
	jmp InitAction

skip1	;Look for Up Right (Jump)
	cmp #kcU+kcR
.)
.(
	bne skip1
	lda ssc_ScreenRules
	and #lsProhibitJump
	bne skip2
	lda #hcStandingJumpRight
	jmp InitAction
skip2	rts

skip1	;Look for Item Up (Pickup)
	cmp #kcI+kcU
.)
.(
	bne skip1
	;Pick Up Item Left
	;Whilst there may be no item to pickup the actual move should
	;still be performed.
	lda #hcPickupRight
	jsr InitAction
	;Check if this key is valid to trigger ProcAction
	lda ssc_RecognisedAction
	and #%00001000
	beq skip2
	jmp ssc_ProcAction
skip2	rts

skip1	;Look for Item Down (Drop)
	cmp #kcI+kcD
.)
.(
	bne skip1
	;Drop Item
	lda #hcDropRight
	jmp InitAction

skip1	;Look for Item Action - Use currently selected item
	cmp #kcI+kcA
.)
.(
	bne skip1
	jmp UseItem
	
skip1	;Look for Action (Call SSC ProcAction)
	cmp #kcA
.)
.(
	bne skip1
	;Action Key - Check if this key is valid to trigger ProcAction
	lda ssc_RecognisedAction
	and #%00000001
	beq skip1
	jsr ssc_ProcAction

skip1	;Look for Item Left (Navigate pocket pointer left)
	cmp #kcI + kcL
.)
.(
	bne skip1
	jmp CyclePocketLeft

skip1	;Look for Item Right (Navigate pocket pointer Right)
	cmp #kcI+kcR
.)
.(
	bne skip1
	jmp CyclePocketRight

skip1	;Look for Up
	cmp #kcU
.)
.(
	bne skip1
	lda ssc_RecognisedAction
	and #%00010000
	beq skip1
	jsr ssc_ProcAction

skip1	;Reset Repeat Flag for Cycle Pocket routine
	ldy #00
	sty CyclePocketRepeating

	;Look for Item (Call SSC ProcAction)
	cmp #kcI
.)
.(
	bne skip1
	lda ssc_RecognisedAction
	and #%00000010
	beq skip1
	jsr ssc_ProcAction
skip1	rts

.)


haRunLeft
	;R (Add Quick turn right later)
	;FL Running Jump Left (Later)
	rts
haRunRight
	;R (Add Quick turn left later)
	;FL Running Jump Right (Later)

	;Check Screen Bounds
	rts


haTurnRight      	;hcLeftTurnRight
haTurnLeft      	;hcRightTurnLeft
	rts
haJumpUpFacingLeft   	;hcJumpUpFacingLeft
haJumpUpFacingRight  	;hcJumpUpFacingRight
haSwingFacingLeft    	;hcSwingFacingLeft
haSwingFacingRight   	;hcSwingFacingRight
haClamberFacingLeft  	;hcClamberFacingLeft
haClamberFacingRight 	;hcClamberFacingRight
haStandingJumpLeft   	;hcStandingJumpLeft
haStandingJumpRight  	;hcStandingJumpRight
haRunningJumpLeft    	;hcRunningJumpLeft
haRunningJumpRight   	;hcRunningJumpRight
	rts
haFallLeft           	;hcFallLeft
haFallRight          	;hcFallRight
	rts

haPickupLeft
haPickupRight
haDropLeft
haDropRight
	rts

HeroDoNothing
	rts
InitAction
	sta HeroAction
	tax
	lda HeroStartingIndex,x
	sta HeroIndex

ContinueAction
	;First check inactivity
	lda HeroAction
	cmp #hcStandLeft
.(
	beq skip2
	cmp #hcStandRight
	bne skip1
skip2	;Standing Left/Right so count inactivity
	lda InactivityFrac
	clc
	adc #01
	sta InactivityFrac
	bcc skip4

	;Inactivity timeout - Set Devil to Finger tapping
	lda #gf_Tapping
	sta LeftHandAction
	sta RightHandAction
	jmp skip4
skip1	;If currently doing something productive then restore Fingers
	jsr UpdateExitArrows
skip4	;Process current action
.)
	lda KeyRegister
.(
	bne skip1
	ldx HeroAction
	lda HeroAnimationProperty,x
	and #hap_ContKey
	beq skip1

	lda HeroAnimationEndAction,x
	sta HeroAction
	lda #00
	sta HeroIndex

skip1	ldx HeroAction
.)
	lda HeroSlowDownCount
	sec
	adc HeroSlowDownFrac,x
	sta HeroSlowDownCount
.(
	bcs skip1
	rts
skip1	;Delete Hero only after establishing validity of new position
.)
	ldx HeroAction
	lda HeroAnimationLength,x
.(
	beq skip1
	lda HeroIndex
	clc
	adc #01
	cmp HeroAnimationLength,x
	bcc skip1
	;Animation Completed
	;For run left (EG) cycle anim if kbd left still
	lda HeroAnimationProperty,x
	;B4(1) == Continue on same key
	and #%00010000
	beq skip3
	lda KeyRegister
	cmp ActionsAssociatedKey,x
	beq skip4
skip3	lda HeroAnimationProperty,x
	;B7(1) == Repeat
	bpl skip2
skip4	lda #00
	jmp skip1

skip2
;	lda #17
;	sta $bfdf
	lda HeroAction
	sta temp01
	lda HeroAnimationEndAction,x
	sta HeroAction
	lda #00
	sta HeroIndex

	lda HeroXStepsAfterAnimationEnd,x
	beq skip6
	jsr DeleteHero
	ldx temp01
	lda HeroX
	clc
	adc HeroXStepsAfterAnimationEnd,x
	sta HeroX

skip6	lda HeroCodeAfterActionVectorHi,x
	beq skip5
	sta vector1+2
	lda HeroCodeAfterActionVectorLo,x
	sta vector1+1
vector1	jsr $dead
skip5	rts

skip1	sta HeroIndex
.)
	lda HeroXStepsTableLo,x
	sta source
	lda HeroXStepsTableHi,x
	sta source+1
	ldy HeroIndex
	lda HeroX
	clc
	adc (source),y
	sta HeroTestX

	lda HeroYStepsTableLo,x
	sta source
	lda HeroYStepsTableHi,x
	sta source+1
	ldy HeroIndex
	lda HeroY
	clc
	adc (source),y
	sta HeroTestY	;Sprite Top of new pos

;	ldx HeroAction
	ldy HeroIndex

	lda HeroAnimationTableLo,x
.(
	sta vector1+1
	lda HeroAnimationTableHi,x
	sta vector1+2
vector1	lda $dead,y
.)
	sta HeroSprite

	jsr DetectFloorAndCollisions
	;Carry set when collision (or exit) detected
.(
	bcs Collision
	ldx HeroAction
	lda HeroAnimationProperty,x
	;B5(1) == Additional Checking(Also additional changes)
	and #%00100000
	beq skip1
	lda HeroAdditionalCheckingCodeVectorLo,x
	sta vector2+1
	lda HeroAdditionalCheckingCodeVectorHi,x
	sta vector2+2
vector2	jsr $dead
	bcc skip1
skip11	jmp Collision

skip1	lda HeroSprite
	cmp PreviousHeroSprite
	bne skip4
	ldx HeroAction
	lda HeroAnimationProperty,x
	and #hap_Still
	bne skip5
skip4	sta PreviousHeroSprite

	;If position unchanged, and hero dimensions the same then no del
	ldy #00
	lda (source),y
	cmp PreviousHeroWidth
	bne skip6
	iny
	lda (source),y
	cmp PreviousHeroHeight
	bne skip6
	lda HeroX
	cmp HeroTestX
	bne skip6
	lda HeroY
	cmp HeroTestY
	beq skip5

skip6	jsr DeleteHero

	lda HeroTestX
	sta HeroX
	lda HeroTestY
	sta HeroY

skip5	jsr PlotHero
.)
	;For testing purposes plot inverse
;	lda #17
;	sta $bfdf
;	ldy #40
;	lda (TestInverse),y
;	ora #128
;	sta (TestInverse),y
	rts


Collision
	;When a collision is reached we recede to last
	;good position and change the action.
	jsr DeleteHero
	ldx HeroAction
	lda HeroActionAfterCollision,x
	sta HeroAction
	lda #00
	sta HeroIndex
	lda HeroFrameAfterCollision,x
	sta HeroSprite
	;Adjust hero y by difference in height between
	;last known good frame and new action frame
	;otherwise hero may be seen to corrupt BG
	tax
	lda SpriteFrameVectorLo,x
	sta header
	lda SpriteFrameVectorHi,x
	sta header+1
	ldy #01
	lda (header),y
	sec
	sbc SpriteHeight
.(
	bcc skip1
	sta header
	lda HeroY
	sbc header
	sta HeroY
skip1	jmp PlotHero
.)


InitialiseSettings
	jsr DisplayScreenProse
	jsr UpdateExitArrows
	jsr UpdateMapPosition
	lda ssc_ScreenNameVectorLo
	ldx ssc_ScreenNameVectorHi
	jmp PlotPlace

DisplayScreenProse
	;Display Prose in bottom text window for current ssc
	lda ssc_ScreenProseVectorLo
	sta text
	lda ssc_ScreenProseVectorHi
	sta text+1
	ldx #8+128
	ldy #0
	jmp DisplayText



;X - HeroAction
;Y - HeroFrame
DetectFloorAndCollisions
	;This routine handles almost all collision types.
	;These include..
	;1) Left and Right Borders
	;2) Floor boundaries
	;3) Background Ceiling limits
	;4) Background object collisions

	;Because the left column of any sprite is used for setting the colour of the sprite
	;we have a number of aspect views of the sprite. these are..
	;1) The physical Sprite occupying the sprite width and height as set in the sprite data
	;2) The visible Sprite occupying only the bitmap columns (Not the first column)

	;There is a visual difference between the graphic held in memory and the sprite we
	;eventiually see on screen. This is because of the Ink attributes that define the sprite
	;colour.
	;Simply offsetting the Y position of the hero by the height of the land is not enough
	;and can give the appearence that the hero is several inches off the ground all the time or
	;the hero can corrupt a hill he is currently ascending!
	;The previous scheme has tables that define the offset from the sprites TL to the best
	;position to check the contour map with(based on the direction the hero is facing).
	;However this has its flaws. This does not protect against the corruption of the background
	;when the hero ascends or descends a steep hill.

	;The better technique is to observe the full width of the sprite and use the highest
	;position in the contour map.
	;However this alone can make the hero appear to be several inches off the ground.

	;So the ideal technique is to scan the full width based on an XByte (held in each frame)
	;where each bit represents a column to scan in the contour map.
	;The maximum columns is always 4 so only half the XByte is used.

	;Check Extreme Left/Right Borders
	lda HeroTestX
	cmp #37
.(
	bcc skip1
	;If hero facing right he may be trapped
	ldx HeroAction
	lda HeroAnimationProperty,x
	and #hap_FRight
	beq skip2
	lda #36
	sta HeroTestX
	jmp skip1
skip2	rts
skip1	;The floor Table should span the complete 40 columns
.)
	lda #99
	sta dfcMinimumY
	;Fetch the XByte for the sprite frame
	ldx HeroSprite
	lda SpriteFrameVectorLo,x
	sta header
	lda SpriteFrameVectorHi,x
	sta header+1
	ldy #02
	lda (header),y
	sta FrameXByte
	;Scan from left to right most column
	ldy #00
	sty ssc_CollisionType
	lda (header),y
	tax

.(
loop1
;	asl FrameXByte
;	bcc skip3
	;Fetch contour map index which is heroX + XByte Column
	txa
	clc
	adc HeroTestX
	tay
	;Fetch Contour Map Collision entry
	lda (ContourCollision),y
	; Unavoidable exit?
	beq skip1
	cmp #5
	bcs skip1
	jmp ProcessUnavoidableCollision
skip1	;Remember Register values
	sta PreservedA
	stx PreservedX
	sty PreservedY
	;Branch to process screen specific collisions
	jsr ssc_BackgroundCollision
	lda PreservedA
	ldx PreservedX
	ldy PreservedY
skip2	lda (ContourFloor),y
	;Now process Captured Y Position
	cmp dfcMinimumY
	bcs skip3
	sta dfcMinimumY
skip3	;Process next column
	dex
	bpl loop1
.)
	;Fetch Sprite Address(need it later to capture frame height)
	lda header
	clc
	adc #4
	sta source
	lda header+1
	adc #00
	sta source+1
	;No collision for this move but adjust YPOS if hero grounded
	ldx HeroAction
	lda HeroAnimationProperty,x
	;B6(1) == Hero Grounded
	and #%01000000
.(
	beq skip4
	;Hero is on ground so adjust height to minimum sampled
skip3	lda dfcMinimumY
	ldy #01
	sec
	sbc (header),y
	sta HeroTestY
	clc
	rts
skip4	;Hero is airbourne, which either means he is falling or leaping somewhere
skip2	;We must still ensure hero remains above ground level
	;Fetch test Y
	lda HeroTestY
	;Add hero height (of test frame)
	ldy #01
	clc
	adc (header),y
	;And compare against minimum ground height (highest point)
	cmp dfcMinimumY
	beq skip5	;Allow if equal
	bcc skip5
	;Set Hero Action to Standing
	lda HeroAnimationProperty,x
	ldx #hcStandRight
	and #hap_FRight
	bne skip1
	ldx #hcStandLeft
skip1	stx HeroAction
	jmp skip3
skip5	clc
.)
	rts


ProcessUnavoidableCollision
	;Acc..
	;01 Left Exit
	;02 Right Exit
	;03 Wall
	;04 Death
	cmp #3
.(
	beq Wall
	cmp #1
	beq ExitWest
	cmp #2
	beq ExitEast
InstantDeath
	nop
	jmp InstantDeath
Wall	;When hero hits a wall it is a collision, so just set carry and rts
	sec
	rts

ExitWest
	dec ScreenID
	lda #01
	jmp LoadSSC
ExitEast
.)
	inc ScreenID
	lda #00

LoadSSC	sta SideApproachFlag
;test	nop
;	jmp test
	;Fetch base address of SSC Filenumber table for the current map
	ldx MapID
	lda MapBasedSSCTableLo,x
	sta source
	lda MapBasedSSCTableHi,x
	sta source+1
	;Index this table by the screenid to get the filenumber
	ldy ScreenID
	lda (source),y
.(
	beq skip1
	;Load SSC Module into C000-FDFF
	tax
	lda #$C0
	;X File Number   A Load Address High
	jsr dsk_LoadFile

	;Display Screen Prose, Place name, Devil exits, Map Position
	jsr InitialiseSettings
	;We now copy and extract SSC inlay in main game code.
	jsr ScreenCopy
	;Initialise Hero position
	jsr ssc_ScreenInit
	;Instead of remembering the background behind the hero we remember the complete HIRES even
	;rows which also allows any sprite to have a permanent record of the original Background.
	;Fortunately this is only 40x59 or 2360 Bytes.
	;jsr CaptureBGB
	;Restore Stack to just before last ssc loaded
	ldx GameStackPointer
	txs
	;Jump back to game loop as if first SSC had just been loaded
	jmp SSCLoop

skip1	sec
.)
	rts


;We hold the background 40x59 which is the only element that will require restoration.
;We plot sprite directly to screen recording sprite width and height
;combine with BGB, but if inverse in BGB then avoid plotting both mask and bitmap
DeleteHero
	;Restore screen from BGB using previous SpriteWidth/SpriteHeight
	ldy HeroY
	lda game_bgbylocl,y	;BGBYlocl,y
	clc
	dec HeroX
	adc HeroX
	inc HeroX
	sta bgbuff
	lda game_bgbyloch,y	;BGBYloch,y
	adc #00
	sta bgbuff+1

	lda SYLocl,y
	clc
	adc HeroX
	sta screen
	lda SYLoch,y
	adc #00
	sta screen+1

	ldx SpriteHeight
.(
loop3	ldy SpriteWidth
	dey
loop1	lda (bgbuff),y
	sta (screen),y
	dey
	bpl loop1

	lda bgbuff
	adc #40
	sta bgbuff
	lda bgbuff+1
	adc #00
	sta bgbuff+1

	lda screen
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1

	ldy SpriteWidth
	dey
	lda #7
loop2	sta (screen),y
	dey
	bpl loop2

	lda screen
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1

	dex
	bne loop3
.)
	rts

;We plot the hero directly to the screen. However certain rules exist to prevent adverse behaviour
;between hero and background.
;If the background is inverse then avoid masking bg byte and don't plot bitmap byte immediately
;below. This makes it possible to have columns that the hero always runs behind.
;If the background is an attribute then avoid masking bg byte. This makes it possible for the
;hero to run infront of colourful backgrounds.
;I also want to only plot the sprite bitmap when it is not 64. This would make it possible for
;hero to lie as close to ground as possible (based on Xbyte to Contour map) but unsure if feasable.
PlotHero

	;Fetch Frame Header(header) and Sprite start(source) addresses
	ldx HeroSprite
	lda SpriteFrameVectorLo,x
	sta header
	clc
	adc #04
	sta source
	lda SpriteFrameVectorHi,x
	sta header+1
	adc #00
	sta source+1

	;Bitmap of sprite always starts one row beyond Sprite so add Width to get it
	ldy #00
	lda source
	adc (header),y
	sta bitmap
	lda source+1
	adc #00
	sta bitmap+1

	;Calculate location in BGBuffer
	ldy HeroY
	lda game_bgbylocl,y	;BGBYlocl,y
	clc
	dec HeroX
	adc HeroX
	inc HeroX
	sta bgbuff
	lda game_bgbyloch,y	;BGBYloch,y
	adc #00
	sta bgbuff+1

	;Calculate location in HIRES screen for Background
	lda SYLocl,y
	adc HeroX
	sta oddscn
	lda SYLoch,y
	adc #00
	sta oddscn+1

	;Calculate location in HIRES screen for Foreground
	lda oddscn
	adc #40
	sta evnscn
	lda oddscn+1
	adc #00
	sta evnscn+1

	;Fetch Sprite Width from Sprite Header
	ldy #00
	lda (header),y
	sta SpriteWidth
	;Fetch Sprite Height(Half Height) from Sprite Header
	iny
	lda (header),y
	sta SpriteHeight
	
	;Just before the main loop branch if any special Hero appearances..
	;0) Normal - 
	;1) Hurt Hero - Replace bitmap hero colours with 7(White) for one frame
	;2) Invincibility - Replace bitmap hero colours with 7(White)
	;3) Invisibility cloak - Only plot mask
	;4) Naked - Replace bitmap hero colours from shoulders down with 1(Red)
	ldx HeroSpecialAppearance
.(
	beq skip1
	jmp SpecialHeroAppearance
	
skip1	;X becomes row counter
.)
	ldx SpriteHeight
.(
	;Whilst Y becomes column counter and index for data
loop3	ldy SpriteWidth
	dey

loop1	;Fetch background byte
	lda (bgbuff),y
	bpl skip3	;Avoid Inverse
	;Inversed background - Fetch Sprite byte
	lda (bitmap),y
	;if the sprite byte is an attribute allow it otherwise
	;reset the byte to 64.
	cmp #64
	bcc skip4
	lda #64
	jmp skip4
skip3	;Avoid masking Attributes in BGB
	cmp #64
	bcc skip1
	;Mask Background with Sprite Background mask
	and (source),y
	;and store to odd lines
	sta (oddscn),y
	;Fetch the sprite foreground
skip1	lda (bitmap),y
	;and store directly to screen
skip4	sta (evnscn),y
skip2	dey
	bpl loop1

	;BGBuffer holds Background graphics only so is half height
	lda bgbuff
	clc
	adc #40
	sta bgbuff
	lda bgbuff+1
	adc #00
	sta bgbuff+1

	;source(Sprite Bitmap) is one Sprite width to next row
	lda SpriteWidth
	asl
	pha
	adc source
	sta source
	lda source+1
	adc #00
	sta source+1

	;Progress bitmap too
	pla
	adc bitmap
	sta bitmap
	lda bitmap+1
	adc #00
	sta bitmap+1

	;oddscn points to physical screen so progress 2 full 40 column rows
	lda oddscn
	adc #80
	sta oddscn
	lda oddscn+1
	adc #00
	sta oddscn+1

	;Do same for evnscn
	lda evnscn
	adc #80
	sta evnscn
	lda evnscn+1
	adc #00
	sta evnscn+1

	;Update row counter and control outer loop
	dex
	bne loop3
.)
	rts

SpecialHeroAppearance
	;Just before the main loop branch if any special Hero appearances(x)..
	;0) Normal - 
	;1) Hurt Hero - Replace bitmap hero colours with 7(White) for one frame
	;2) Invincibility - Replace bitmap hero colours with 7(White)
	;3) Invisibility cloak - Only plot mask
	;4) Naked - Replace bitmap hero colours from shoulders down with 1(Red)
	lda SpecialHeroAppearanceDisplayCodeLo-1,x
.(
	sta vector1+1
	lda SpecialHeroAppearanceDisplayCodeHi-1,x
	sta vector1+2
vector1	jmp $dead
.)

;0) Normal - 
;1) Hurt Hero - Replace bitmap hero colours with 7(White) for one frame
;2) Invincibility - Replace bitmap hero colours with 7(White)
;3) Invisibility cloak - Only plot mask
;4) Naked - Replace bitmap hero colours from shoulders down with 1(Red)
HeroSpecialAppearance	.byt 0

SpecialHeroAppearanceDisplayCodeLo
 .byt <PlotHero_Hurt
 .byt <PlotHero_Invincible
 .byt <PlotHero_Invisible
 .byt <PlotHero_Naked
SpecialHeroAppearanceDisplayCodeHi
 .byt >PlotHero_Hurt
 .byt >PlotHero_Invincible
 .byt >PlotHero_Invisible
 .byt >PlotHero_Naked

;1) Hurt Hero - Replace bitmap hero colours with 7(White) for one frame
PlotHero_Hurt
	jsr PlotHero_Invincible
	lda #0
	sta HeroSpecialAppearance 
	rts

;2) Invincibility - Replace bitmap hero colours with 7(White)
PlotHero_Invincible
	;X becomes row counter
	ldx SpriteHeight
.(
	;Whilst Y becomes column counter and index for data
loop3	ldy SpriteWidth
	dey

loop1	;Fetch background byte
	lda (bgbuff),y
	bpl skip3	;Avoid Inverse
	;Inversed background - Fetch Sprite byte
	lda (bitmap),y
	;if the sprite byte is an attribute allow it otherwise
	;reset the byte to 64.
	cmp #64
	bcc skip5
	lda #64
	jmp skip4
skip5	;Replace ink with 7
	lda #7
	jmp skip4
skip3	;Avoid masking Attributes in BGB
	cmp #64
	bcc skip1
	;Mask Background with Sprite Background mask
	and (source),y
	;and store to odd lines
	sta (oddscn),y
	;Fetch the sprite foreground
skip1	lda (bitmap),y
	cmp #64
	bcc skip5
	;and store directly to screen
skip4	sta (evnscn),y
skip2	dey
	bpl loop1
	jsr PlotHero_ProgressLocations
	;Update row counter and control outer loop
	dex
	bne loop3
.)
	rts

;3) Invisibility cloak - Only plot mask
PlotHero_Invisible
	;X becomes row counter
	ldx SpriteHeight
.(
	;Whilst Y becomes column counter and index for data
loop3	ldy SpriteWidth
	dey

loop1	;Fetch background byte
	lda (bgbuff),y
	;Avoid masking Attributes in BGB
	cmp #64
	bcc skip1
	;Mask Background with Sprite Background mask
	and (source),y
	;and store to odd lines
	sta (oddscn),y
	;Fetch the sprite foreground
skip1	dey
	bpl loop1
	
	jsr PlotHero_ProgressLocations
	;Update row counter and control outer loop
	dex
	bne loop3
.)
	rts 
;4) Naked - Replace bitmap hero colours from shoulders down with 1(Red)
PlotHero_Naked
	;X becomes row counter
	ldx SpriteHeight
.(
	;Whilst Y becomes column counter and index for data
loop3	ldy SpriteWidth
	dey

loop1	;Fetch background byte
	lda (bgbuff),y
	bpl skip3	;Avoid Inverse
	;Inversed background - Fetch Sprite byte
	lda (bitmap),y
	;if the sprite byte is an attribute allow it otherwise
	;reset the byte to 64.
	cmp #64
	bcc skip5
	lda #64
	jmp skip4
skip5	;Replace ink with 1 from row 1(Not 0)
	cpx SpriteHeight
	beq skip4
	lda #5
	jmp skip4
skip3	;Avoid masking Attributes in BGB
	cmp #64
	bcc skip1
	;Mask Background with Sprite Background mask
	and (source),y
	;and store to odd lines
	sta (oddscn),y
	;Fetch the sprite foreground
skip1	lda (bitmap),y
	cmp #64
	bcc skip5
	;and store directly to screen
skip4	sta (evnscn),y
skip2	dey
	bpl loop1
	jsr PlotHero_ProgressLocations
	;Update row counter and control outer loop
	dex
	bne loop3
.)
	rts


PlotHero_ProgressLocations
	;BGBuffer holds Background graphics only so is half height
	lda bgbuff
	clc
	adc #40
	sta bgbuff
	lda bgbuff+1
	adc #00
	sta bgbuff+1

	;source(Sprite Bitmap) is one Sprite width to next row
	lda SpriteWidth
	asl
	pha
	adc source
	sta source
	lda source+1
	adc #00
	sta source+1

	;Progress bitmap too
	pla
	adc bitmap
	sta bitmap
	lda bitmap+1
	adc #00
	sta bitmap+1

	;oddscn points to physical screen so progress 2 full 40 column rows
	lda oddscn
	adc #80
	sta oddscn
	lda oddscn+1
	adc #00
	sta oddscn+1

	;Do same for evnscn
	lda evnscn
	adc #80
	sta evnscn
	lda evnscn+1
	adc #00
	sta evnscn+1
	rts
