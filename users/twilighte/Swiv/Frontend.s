;Frontend.s - Give control to menu, and run occasional level script
;BackgroundBuffer should hold Title and menu



gfxTitle
 .byt $FF,$FF,$FF,$FF,$C0,$FF,$FF,$FF,$FF
 .byt $40,$40,$40,$47,$C0,$78,$40,$40,$40
 .byt $FF,$FF,$FF,$E0,$C0,$C1,$FF,$FF,$FF
 .byt $40,$40,$40,$C0,$61,$C0,$40,$40,$40
 .byt $FF,$FF,$FE,$C3,$FF,$F0,$DF,$FF,$FF
 .byt $40,$40,$43,$70,$40,$43,$70,$40,$40
 .byt $FF,$FF,$F8,$DF,$FF,$FE,$C7,$FF,$FF
 .byt $40,$40,$47,$40,$40,$40,$78,$40,$40
 .byt $FF,$FF,$F0,$FF,$FF,$FF,$C3,$FF,$FF
 .byt $40,$40,$4E,$40,$40,$40,$5C,$40,$40
 .byt $FF,$FF,$F1,$FF,$FF,$FF,$E3,$FF,$FF
 .byt $40,$C0,$5D,$61,$60,$C0,$5E,$C1,$40
 .byt $FF,$4C,$E3,$73,$FF,$71,$D1,$70,$FF
 .byt $FF,$F3,$E3,$E1,$FF,$CE,$D1,$70,$40
 .byt $FF,$4C,$E3,$4C,$FF,$71,$D1,$7C,$FF
 .byt $40,$F3,$E3,$F3,$FF,$C0,$F1,$CF,$FF
 .byt $FF,$4C,$E1,$4C,$FF,$CF,$E1,$CF,$FF
 .byt $40,$4C,$4E,$4C,$40,$70,$5C,$70,$40
 .byt $FF,$4C,$F1,$4C,$FF,$70,$E3,$7F,$FF
 .byt $40,$40,$4F,$40,$40,$40,$7C,$40,$40
 .byt $FF,$FF,$F8,$FF,$FF,$FF,$C7,$FF,$FF
 .byt $40,$40,$47,$60,$40,$41,$78,$40,$40
 .byt $FF,$FF,$FC,$CF,$FF,$FC,$CF,$FF,$FF
 .byt $40,$40,$41,$7C,$40,$4F,$60,$40,$40
 .byt $FF,$FF,$FF,$C0,$DE,$C0,$FF,$FF,$FF
 .byt $40,$40,$40,$E0,$C0,$C1,$40,$40,$40
 .byt $FF,$FF,$FF,$F8,$C0,$C7,$FF,$FF,$FF
 .byt $40,$40,$40,$40,$C0,$40,$40,$40,$40
 .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byt $40,$40,$40,$40,$40,$40,$40,$40,$40
 .byt $C2,$DF,$C8,$D3,$F0,$F3,$F3,$C8,$D0
 .byt $58,$75,$63,$4C,$46,$59,$6F,$73,$4E
 .byt $E7,$E0,$FC,$F3,$F9,$E6,$D3,$CC,$F7
 .byt $58,$4A,$47,$6F,$6F,$4F,$4C,$73,$4F

; 32-93 TriRight TriLeft LeftShift RightShift LeftCtrl RightCtrl
; SpaceBar Escape Funct Del LeftCrsr DownCrsr UpCrsr RightCrsr Return
CharacterSet	;40x5 Character Set
 .byt $FF,$E7,$ED,$EB,$E3,$CD,$E7,$F7,$F7,$EF,$FB,$F7,$FF,$FF,$FF,$FD,$E3,$F7,$E3
 .byt $C3,$F3,$C1,$E3,$E1,$E3,$E3,$FF,$FF,$F7,$FF,$DF,$E3,$E3,$E3,$C3,$E1,$C7,$C1
 .byt $C1,$E3,$DD,$C1,$C1,$DD,$DF,$DD,$DD,$E3,$C3,$E3,$C3,$E1,$C1,$DD,$DD,$DD,$DD
 .byt $DD,$C1,$C7,$DF,$C7,$DF,$F7,$DC,$CC,$DC,$CC,$FF,$C9,$C8,$F7,$F7,$E3,$F7,$F7,$C8
 .byt $40,$58,$76,$7E,$68,$74,$64,$58,$50,$48,$68,$48,$40,$40,$40,$44,$62,$58,$66
 .byt $46,$54,$60,$70,$46,$76,$76,$48,$48,$50,$5C,$50,$66,$62,$62,$66,$70,$6C,$60
 .byt $60,$60,$62,$48,$42,$64,$60,$76,$72,$62,$66,$62,$66,$70,$48,$62,$62,$62,$54
 .byt $54,$44,$60,$50,$48,$70,$58,$62,$6A,$62,$6A,$40,$64,$65,$5E,$5E,$5C,$5C,$7C,$6A
 .byt $FF,$E7,$FF,$EB,$E3,$F7,$E5,$FF,$EF,$F7,$E3,$C1,$FF,$C1,$FF,$F7,$DD,$F7,$F3
 .byt $E3,$C1,$C3,$C3,$F3,$E3,$E1,$FF,$FF,$DF,$FF,$F7,$F3,$D1,$C1,$C3,$DF,$D9,$C3
 .byt $C3,$D1,$C1,$F7,$FD,$C7,$DF,$D5,$D5,$DD,$C3,$D5,$C3,$E3,$F7,$DD,$EB,$D5,$F7
 .byt $F7,$F7,$DF,$F7,$F7,$C7,$C7,$DC,$CC,$DD,$CD,$FF,$C9,$CA,$C7,$C1,$C1,$C1,$C1,$CD
 .byt $40,$40,$40,$7E,$4A,$56,$64,$40,$50,$48,$4A,$48,$44,$40,$58,$50,$62,$48,$58
 .byt $46,$4C,$46,$76,$4C,$76,$46,$48,$48,$50,$5C,$50,$40,$60,$62,$66,$70,$66,$60
 .byt $60,$66,$62,$48,$72,$64,$60,$62,$66,$62,$60,$64,$66,$46,$48,$62,$54,$76,$54
 .byt $48,$50,$60,$44,$48,$70,$58,$61,$69,$62,$6A,$40,$62,$65,$5E,$5E,$5C,$5C,$7C,$6A
 .byt $FF,$E7,$FF,$EB,$C3,$D9,$E5,$FF,$F7,$EF,$EF,$F7,$F3,$FF,$E7,$DF,$E3,$E3,$C1
 .byt $C3,$F3,$C3,$E3,$F3,$E3,$E3,$FF,$E7,$F7,$FF,$DF,$F7,$E1,$DD,$C3,$E1,$C3,$C1
 .byt $DF,$E3,$DD,$C1,$E3,$DD,$C1,$DD,$DD,$E3,$DF,$E5,$DD,$C3,$F7,$E3,$F7,$DD,$DD
 .byt $F7,$C1,$C7,$FD,$C7,$DF,$F7,$C4,$D4,$C4,$D4,$C1,$C9,$DA,$F7,$F7,$F7,$E3,$F7,$D5

P1_Device
 .byt 0
P2_Device 
 .byt 0
P1_DeviceSide
 .byt 0
 .byt 0
; 32-93 TriRight(94) TriLeft(95) LeftShift(96) RightShift(97) LeftCtrl(98) RightCtrl(99)
; SpaceBar(100) Escape(101) Funct(102) Del(103) LeftCrsr(104) DownCrsr(105) UpCrsr(106)
; RightCrsr(107) Return(108)
KeyFire
 .byt 99
 .byt 98
KeyLeft
 .byt 104
 .byt "Z"
KeyRight
 .byt 107
 .byt "X"
KeyUp
 .byt 106
 .byt "Q"
KeyDown
 .byt 105
 .byt "A"
MenuCurrentPlayer
 .byt 0
AudioTitleVolume
 .byt 1
AudioIngameVolume
 .byt 1
AudioEffectsVolume
 .byt 1
MenuID
 .byt 0
MenuY
 .dsb 6,0

ClearScreen	;Clear screen with Inversed Yellow Bitmap
	lda #<BGBuffer
	sta screen
	lda #>BGBuffer
	sta screen+1
	ldx #63
.(
loop3	ldy #19
	lda #$FF
	
loop1	sta (screen),y
	dey
	bpl loop1
	
;	lda #3
;	sta (screen),y
	
	lda #20
	jsr AddScreen
	ldy #19
	lda #64
	
loop2	sta (screen),y
	dey
	bpl loop2
	
;	lda #6
;	sta (screen),y
	
	lda #20
	jsr AddScreen
	dex
	bne loop3
.)
	rts

	
	

DisplayTitle
	lda #<BGBuffer+6+40*4
	sta screen
	lda #>BGBuffer+6+40*4
	sta screen+1
	lda #<gfxTitle
	sta source
	lda #>gfxTitle
	sta source+1
	ldx #34
.(
loop2	ldy #8
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #20
	jsr AddScreen
	lda #9
	jsr AddSource
	dex
	bne loop2
.)
	rts

RefreshTitleMenus
	jsr ClearScreen
	jsr DisplayTitle
	jsr Display_Menu
	jmp DisplayMenuCursor

FrontEnd
;	nop
;	jmp FrontEnd
	sta bgbRowStart
	lda #0
	sta WaitingOnKeyup
	jsr RefreshTitleMenus
	lda #255
	sta UltimateSprite
MainMenuLoop
.(
loop1	jsr CopyBGBuffer
	jsr ossScript_Driver
	jsr ZoomScreen
	lda UltimateSprite
	bpl skip1
	jsr SetupRandomScript
	;Check for a key
skip1	jsr ReadAllKeys
	ldy WaitingOnKeyup
	bne skip2
	bcc loop1
	pha
	;loop until key up
	lda #1
	sta WaitingOnKeyup
	jmp loop1
skip2	bcs loop1
	lda #00
	sta WaitingOnKeyup
	pla
.)
; 32-93 TriRight(94) TriLeft(95) LeftShift(96) RightShift(97) LeftCtrl(98) RightCtrl(99)
; SpaceBar(100) Escape(101) Funct(102) Del(103) LeftCrsr(104) DownCrsr(105) UpCrsr(106)
; RightCrsr(107) Return(108)
	ldy #5
.(
loop1	cmp GeneralKeys,y
	beq skip1
	dey
	bpl loop1
	jmp MainMenuLoop
skip1	ldx KeyVectorLo,y
	stx vector1+1
	ldx KeyVectorHi,y
	stx vector1+2
vector1	jsr $dead
.)
	jmp MainMenuLoop

SetupRandomScript
	lda #00
	sta SpawnGroupFlag
	;S ScriptID
	jsr GetRand
	and #3
	tay
	lda SuitableTitleScripts,y
	pha
	;Y YPOS to Spawn Script Sprite to
	ldy #00
	;A XPOS to Spawn Script Sprite to
	jsr GetRand
	and #15
	clc
	adc #4
	jmp SpawnScript
SuitableTitleScripts
 .byt 5,6,7,7
rndRandom
 .byt 0,0
rndTemp
 .byt 0

GetRand
         lda rndRandom+1
         sta rndTemp
         lda rndRandom
         asl
         rol rndTemp
         asl
         rol rndTemp
         clc
         adc rndRandom
         pha
         lda rndTemp
         adc rndRandom+1
         sta rndRandom+1
         pla
         adc #$11
         sta rndRandom
         lda rndRandom+1
         adc #$36
         sta rndRandom+1
         rts
	

GeneralKeys
 .byt 106,105," -=",101
KeyVectorLo
 .byt <MenuCursorUp
 .byt <MenuCursorDown
 .byt <MenuSelect
 .byt <MenuDecrement
 .byt <MenuIncrement
 .byt <MenuEscape
KeyVectorHi
 .byt >MenuCursorUp
 .byt >MenuCursorDown
 .byt >MenuSelect
 .byt >MenuDecrement
 .byt >MenuIncrement
 .byt >MenuEscape
;Text_TitleMenu
;Text_AudioMenu
;Text_Controllers
;Text_HighScores
;Text_Credits
;Text_KeyConfig
MenuMaximumY
 .byt 5
 .byt 5
 .byt 3
 .byt 0
 .byt 0
 .byt 4

MenuCursorUp
	jsr DeleteMenuCursor
	ldx MenuID
	lda MenuY,x
.(
	beq skip1
	dec MenuY,x
skip1	jmp DisplayMenuCursor
.)

MenuCursorDown
	jsr DeleteMenuCursor
	ldx MenuID
	lda MenuY,x
	cmp MenuMaximumY,x
.(
	beq skip1
	inc MenuY,x
skip1	jmp DisplayMenuCursor
.)
MenuEscape
	;0 Text_TitleMenu	-
	;1 Text_AudioMenu	0
	;2 Text_Controllers	0
	;3 Text_HighScores	0
	;4 Text_Credits	0
	;5 Text_KeyConfig	2
	ldx MenuID
	lda EscapeMenuID,x
	sta MenuID
	;Redisplay Menu
	jmp RefreshTitleMenus
EscapeMenuID
 .byt 0,0,0,0,0,2
	
	
MenuSelect
MenuDecrement
MenuIncrement
	;Convert actual key into 0(Decrement) 1(Increment) 128(Select)
	ldy #0
	cmp #"-"
.(
	beq skip1
	ldy #1
	cmp #"="
	beq skip1
	ldy #128
	jmp skip1
skip1	;Depends on MenuY(0-7) and MenuID(0-4)
	lda MenuID
	tax
	asl
	asl
	asl
	ora MenuY,x
	tax
	lda MenuOptionVectorLo,x
	sta vector1+1
	lda MenuOptionVectorHi,x
	sta vector1+2
	tya
vector1	jmp $dead
.)

MenuOptionVectorLo
 .byt <mmBegin	;0 Main Menu - BEGIN
 .byt <mmPlayers	;1 Main Menu - 2 PLAYERS
 .byt <mmAudio	;2 Main Menu - AUDIO
 .byt <mmControls	;3 Main Menu - CONTROLLERS
 .byt <mmHiScores	;4 Main Menu - HIGH SCORES
 .byt <mmCredits	;5 Main Menu - CREDITS
 .byt <mmReturn	;6
 .byt <mmReturn	;7
 .byt <mmReturn	;0 Audio Menu - TITLE
 .byt <amTitle	;1 Audio Menu - ON
 .byt <mmReturn	;2 Audio Menu - IN-GAME
 .byt <amIngame	;3 Audio Menu - ON
 .byt <mmReturn	;4 Audio Menu - EFFECTS
 .byt <amEffects	;5 Audio Menu - ON
 .byt <mmReturn	;6 Audio Menu - PRESS SPACE
 .byt <mmReturn	;7
 .byt <cmP1Device	;0 Controllers Menu - P1-IJK JOY 
 .byt <cmP1Controls	;1 Controllers Menu - LEFT    
 .byt <cmP2Device	;2 Controllers Menu - P2-KEYBOARD
 .byt <cmP2Controls	;3 Controllers Menu - <>^v
 .byt <mmReturn	;4 Controllers Menu - PRESS SPACE
 .byt <mmReturn	;5 
 .byt <mmReturn	;6 
 .byt <mmReturn	;7
 .byt <mmReturn	;0 High Scores Menu - TOP 5   
 .byt <mmReturn	;1 High Scores Menu - -0000000
 .byt <mmReturn	;2 High Scores Menu - -0000000
 .byt <mmReturn	;3 High Scores Menu - -0000000
 .byt <mmReturn	;4 High Scores Menu - -0000000
 .byt <mmReturn	;5 High Scores Menu - -0000000
 .byt <mmReturn	;6 High Scores Menu -           
 .byt <mmReturn	;7 High Scores Menu - PRESS SPACE
 .byt <mmReturn	;0 Credits Menu - PROGRAM    
 .byt <mmReturn	;1 Credits Menu -   TWILIGHTE 
 .byt <mmReturn	;2 Credits Menu - MAPS        
 .byt <mmReturn	;3 Credits Menu -   DBUG      
 .byt <mmReturn	;4 Credits Menu - HELP        
 .byt <mmReturn	;5 Credits Menu -   DBUG     
 .byt <mmReturn	;6 Credits Menu - INSPIRATION 
 .byt <mmReturn	;7 Credits Menu -   CHEVRON   
 .byt <kcLeft	;0 Key Config Menu - LEFT   -
 .byt <kcRight	;1 Key Config Menu - RIGHT  -
 .byt <kcUp	;2 Key Config Menu - UP     -
 .byt <kcDown	;3 Key Config Menu - DOWN   -
 .byt <kcFire1	;4 Key Config Menu - FIRE 1 -
 .byt <kcFire2	;5 Key Config Menu - FIRE 2 -
 .byt <mmReturn	;6 
 .byt <mmReturn	;7 
MenuOptionVectorHi
 .byt >mmBegin	;0 Main Menu - BEGIN
 .byt >mmPlayers	;1 Main Menu - 2 PLAYERS
 .byt >mmAudio	;2 Main Menu - AUDIO
 .byt >mmControls	;3 Main Menu - CONTROLLERS
 .byt >mmHiScores	;4 Main Menu - HIGH SCORES
 .byt >mmCredits	;5 Main Menu - CREDITS
 .byt >mmReturn	;6
 .byt >mmReturn	;7
 .byt >mmReturn	;0 Audio Menu - TITLE
 .byt >amTitle	;1 Audio Menu - ON
 .byt >mmReturn	;2 Audio Menu - IN-GAME
 .byt >amIngame	;3 Audio Menu - ON
 .byt >mmReturn	;4 Audio Menu - EFFECTS
 .byt >amEffects	;5 Audio Menu - ON
 .byt >mmReturn	;6 Audio Menu - PRESS SPACE
 .byt >mmReturn	;7
 .byt >cmP1Device	;0 Controllers Menu - P1-IJK JOY 
 .byt >cmP1Controls	;1 Controllers Menu - LEFT    
 .byt >cmP2Device	;2 Controllers Menu - P2-KEYBOARD
 .byt >cmP2Controls	;3 Controllers Menu - <>^v
 .byt >mmReturn	;4 Controllers Menu - PRESS SPACE
 .byt >mmReturn	;5 
 .byt >mmReturn	;6 
 .byt >mmReturn	;7
 .byt >mmReturn	;0 High Scores Menu - TOP 5   
 .byt >mmReturn	;1 High Scores Menu - -0000000
 .byt >mmReturn	;2 High Scores Menu - -0000000
 .byt >mmReturn	;3 High Scores Menu - -0000000
 .byt >mmReturn	;4 High Scores Menu - -0000000
 .byt >mmReturn	;5 High Scores Menu - -0000000
 .byt >mmReturn	;6 High Scores Menu -           
 .byt >mmReturn	;7 High Scores Menu - PRESS SPACE
 .byt >mmReturn	;0 Credits Menu - PROGRAM    
 .byt >mmReturn	;1 Credits Menu -   TWILIGHTE 
 .byt >mmReturn	;2 Credits Menu - MAPS        
 .byt >mmReturn	;3 Credits Menu -   DBUG      
 .byt >mmReturn	;4 Credits Menu - HELP        
 .byt >mmReturn	;5 Credits Menu -   DBUG     
 .byt >mmReturn	;6 Credits Menu - INSPIRATION 
 .byt >mmReturn	;7 Credits Menu -   CHEVRON   
 .byt >kcLeft	;0 Key Config Menu - LEFT   -
 .byt >kcRight	;1 Key Config Menu - RIGHT  -
 .byt >kcUp	;2 Key Config Menu - UP     -
 .byt >kcDown	;3 Key Config Menu - DOWN   -
 .byt >kcFire1	;4 Key Config Menu - FIRE 1 -
 .byt >kcFire2	;5 Key Config Menu - FIRE 2 -
 .byt >mmReturn	;6 
 .byt >mmReturn	;7 

mmBegin	;0 Main Menu - BEGIN
.(
	bpl skip1
	pla
	pla
skip1	rts
.)

GamePlayers	.byt 2

mmPlayers	;1 Main Menu - 2 PLAYERS
.(
	bmi skip1
	beq skip2	;Decrement
	;0 A Players
	;1 B Players
	;2 2 Players
	lda GamePlayers
	cmp #2
	bcs skip1
	inc GamePlayers
	jmp skip3
skip2	lda GamePlayers
	beq skip1
	dec GamePlayers
skip3	;Display Players
	ldx GamePlayers
	lda PlayersCharacter,x
	sta Text_TitleMenu+12
	jmp Display_Menu
skip1	rts
.)
PlayersCharacter
 .byt "AB2"
mmAudio	;2 Main Menu - AUDIO
.(
	bpl skip1
	;Select Audio menu
	lda #1
	sta MenuID
	jsr RefreshTitleMenus
skip1	rts
.)	
mmControls	;3 Main Menu - CONTROLLERS
.(
	bpl skip1
	;Select Controllers menu
	lda #2
	sta MenuID
	jsr RefreshTitleMenus
skip1	rts
.)	
	
mmHiScores	;4 Main Menu - HIGH SCORES
.(
	bpl skip1
	;Select High Scores menu
	lda #3
	sta MenuID
	jsr RefreshTitleMenus
skip1	rts
.)	
mmCredits	;5 Main Menu - CREDITS
.(
	bpl skip1
	;Select Credits menu
	lda #4
	sta MenuID
	jsr RefreshTitleMenus
skip1	rts
.)	

amTitle	;1 Audio Menu - ON
	lda AudioTitleVolume
	eor #1
	sta AudioTitleVolume
	ldy #14
	jmp DisplayAudioOnOff

amIngame	;3 Audio Menu - ON
	lda AudioIngameVolume
	eor #1
	sta AudioIngameVolume
	ldy #36
	jmp DisplayAudioOnOff
amEffects	;5 Audio Menu - ON
	lda AudioEffectsVolume
	eor #1
	sta AudioEffectsVolume
	ldy #58
DisplayAudioOnOff
	;Multiply option by 3
	sta Temp01
	asl
	adc Temp01
	tax
	lda OnOffText,x
	sta Text_AudioMenu,y
	lda OnOffText+1,x
	sta Text_AudioMenu+1,y
	lda OnOffText+2,x
	sta Text_AudioMenu+2,y
	jmp RefreshTitleMenus
OnOffText
 .byt "OFF"
 .byt "ON "
cmP2Device	;2 Controllers Menu - P2-KEYBOARD	
	ldx #1
	jmp cmP1DeviceRent
cmP1Device	;0 Controllers Menu - P1-IJK JOY 
	ldx #0
cmP1DeviceRent
	tay
.(
	bmi skip1
	beq DecrementJoy
	;Devices are..
	;0 KEYBOARD
	;1 IJK JOY
	;2 PASE JOY
	;3 TELE JOY
	lda P1_Device,x
	clc
	adc #1
	jmp skip2
DecrementJoy
	lda P1_Device,x
	sec
	sbc #1
skip2	and #3
	sta P1_Device,x
	;Locate other player
	txa
	eor #1
	tay
	;Compare Devices
	lda P1_Device,x
	beq skip3
	cmp P1_Device,y
	bne skip3
	;Choose other Joy Control
	lda P1_DeviceSide,y
	eor #1
	sta P1_DeviceSide,x
skip3	stx Temp01
	;Update text in menu
	jsr RefreshMenuDeviceName
	;Update text in Controls
	ldx Temp01
	stx Temp02
	jsr RefreshMenuControls
	;Update Controller Graphic
	ldx Temp02
	jsr ConstructDeviceAndSide	
	;Update screen
	jsr RefreshTitleMenus
skip1	rts
.)	



RefreshMenuDeviceName
	lda TextControllerLocationLo,x
	sta source
	lda TextControllerLocationHi,x
	sta source+1
	lda P1_Device,x
	asl
	asl
	asl
	tax
	ldy #00
.(
loop1	lda DeviceName,x
	sta (source),y
	inx
	iny
	cpy #8
	bcc loop1
.)
	rts
TextControllerLocationLo
 .byt <Text_Controllers+3
 .byt <Text_Controllers+25
TextControllerLocationHi
 .byt >Text_Controllers+3
 .byt >Text_Controllers+25
DeviceName
 .byt "KEYBOARD"
 .byt "IJK JOY "
 .byt "PASE JOY"
 .byt "TELE JOY"
RefreshMenuControls
	lda P1_Device,x
	beq DisplayControllerKeys 
DisplayControllerSide
	lda TextControlLocationLo,x
	sta source
	lda TextControlLocationHi,x
	sta source+1
	ldy #00
	;0 Left
	;1 Right
	lda P1_DeviceSide,x
	asl
	sta Temp01
	asl
	adc Temp01
	tax
.(
loop1	lda ControllerSideText,x
	sta (source),y
	inx
	iny
	cpy #06
	bcc loop1
.)
	rts
DisplayControllerKeys 
	;Display Keys used for Keyboard
	lda TextControlLocationLo,x
	sta source
	lda TextControlLocationHi,x
	sta source+1
	ldy #00
	lda KeyFire,x
	sta (source),y
	iny
	lda #32
	sta (source),y
	iny
	lda KeyLeft,x
	sta (source),y
	lda KeyRight,x
	iny
	sta (source),y
	lda KeyUp,x
	iny
	sta (source),y
	lda KeyDown,x
	iny
	sta (source),y
	rts

	
	
TextControlLocationLo
 .byt <Text_Controllers+14
 .byt <Text_Controllers+36
TextControlLocationHi
 .byt >Text_Controllers+14
 .byt >Text_Controllers+36
	
	
	
	
ControllerSideText
 .byt "LEFT  "
 .byt "RIGHT "

cmP1Controls	;1 Controllers Menu - LEFT    
	ldx #0
	jmp cmP2ControlsRent
cmP2Controls	;3 Controllers Menu - <>^v
	ldx #1
cmP2ControlsRent
	tay
.(
	bmi skip2
	;Device must be joy to mod
	lda P1_Device,x
	beq skip1
	;Don't allow selection if other players joy is the same
	txa
	eor #1
	tay
	lda P1_Device,x
	cmp P1_Device,y
	beq skip1
	lda P1_DeviceSide,x
	eor #1
	sta P1_DeviceSide,x
	stx Temp02
	jsr RefreshMenuControls
	;Update Controller Graphic
	ldx Temp02
	jsr ConstructDeviceAndSide	
	;Update screen
	jsr RefreshTitleMenus
skip1	rts
skip2	;Device must be keyboard to select
	lda P1_Device,x
	bne skip1
.)
	;Select and display Key config menu
	lda #5
	sta MenuID
	;Store Player so we'll know what keys to change
	stx MenuCurrentPlayer

	;Display current players keys in key config menu
	
	
	;Convert the current player to an index for the game key tables
	txa
	asl
	asl
	asl
	asl
	tay
UpdateKeyConfigMenu	
	;Work out each Key character and store both in key-config menu and controller menu
	jsr WorkOutKey
	sta Text_KeyConfig+9
	ldx ControllerScreenOffset,y
	sta Text_Controller_Keys,x
	iny
	jsr WorkOutKey
	sta Text_KeyConfig+9+11*1
	ldx ControllerScreenOffset,y
	sta Text_Controller_Keys,x
	iny
	jsr WorkOutKey
	sta Text_KeyConfig+9+11*2
	ldx ControllerScreenOffset,y
	sta Text_Controller_Keys,x
	iny
	jsr WorkOutKey
	sta Text_KeyConfig+9+11*3
	ldx ControllerScreenOffset,y
	sta Text_Controller_Keys,x
	iny
	jsr WorkOutKey
	sta Text_KeyConfig+9+11*4
	ldx ControllerScreenOffset,y
	sta Text_Controller_Keys,x

	jmp RefreshTitleMenus

ControllerScreenOffset
 .byt 5,6,3,7,8,0,0,0,0,0,0,0,0,0,0,0
 .byt 22+5,22+6,22+3,22+7,22+8

WorkOutKey
	lda PlayerA_KeyboardColumn,y
	jsr LocateKeyColumnIndex
	lda PlayerA_KeyboardRow,y
	sta MenuKeyRow
	jmp KeyRowColumn2Ascii
	
LocateKeyColumnIndex
	ldx #8
.(
loop1	dex
	cmp KeyColumn,x
	bne loop1
.)
	rts
	
MenuOriginalKeyColumn	.byt 0
MenuOriginalKeyRow		.byt 0

kcLeft	;0 Key Config Menu - LEFT   -
	jsr PlotPressKey
	jsr WaitOnKeyCode	;Returns Column in A and Row in Y
	lda MenuCurrentPlayer	;0/1
	asl
	asl
	asl
	asl
	tay
	;Store Key row and column to Game key tables
	lda MenuOriginalKeyColumn
	sta PlayerA_KeyboardColumn,y
	lda MenuOriginalKeyRow
	sta PlayerA_KeyboardRow,y
	jsr WipePressKey
	jmp UpdateKeyConfigMenu
	
	
	
kcRight	;1 Key Config Menu - RIGHT  -
	jsr PlotPressKey
	jsr WaitOnKeyCode	;Returns Column in A and Row in Y
	lda MenuCurrentPlayer	;0/1
	asl
	asl
	asl
	asl
	tay
	;Store Key row and column to Game key tables
	lda MenuOriginalKeyColumn
	sta PlayerA_KeyboardColumn+1,y
	lda MenuOriginalKeyRow
	sta PlayerA_KeyboardRow+1,y
	jsr WipePressKey
	jmp UpdateKeyConfigMenu
kcUp	;2 Key Config Menu - UP     -
	jsr PlotPressKey
	jsr WaitOnKeyCode	;Returns Column in A and Row in Y
	lda MenuCurrentPlayer	;0/1
	asl
	asl
	asl
	asl
	tay
	;Store Key row and column to Game key tables
	lda MenuOriginalKeyColumn
	sta PlayerA_KeyboardColumn+2,y
	lda MenuOriginalKeyRow
	sta PlayerA_KeyboardRow+2,y
	jsr WipePressKey
	jmp UpdateKeyConfigMenu
kcDown	;3 Key Config Menu - DOWN   -
	jsr PlotPressKey
	jsr WaitOnKeyCode	;Returns Column in A and Row in Y
	lda MenuCurrentPlayer	;0/1
	asl
	asl
	asl
	asl
	tay
	;Store Key row and column to Game key tables
	lda MenuOriginalKeyColumn
	sta PlayerA_KeyboardColumn+3,y
	lda MenuOriginalKeyRow
	sta PlayerA_KeyboardRow+3,y
	jsr WipePressKey
	jmp UpdateKeyConfigMenu
kcFire1	;4 Key Config Menu - FIRE 1 -
	jsr PlotPressKey
	jsr WaitOnKeyCode	;Returns Column in A and Row in Y
	lda MenuCurrentPlayer	;0/1
	asl
	asl
	asl
	asl
	tay
	;Store Key row and column to Game key tables
	lda MenuOriginalKeyColumn
	sta PlayerA_KeyboardColumn+4,y
	lda MenuOriginalKeyRow
	sta PlayerA_KeyboardRow+4,y
	jsr WipePressKey
	jmp UpdateKeyConfigMenu
kcFire2	;5 Key Config Menu - FIRE 2 -
	rts

WipePressKey
	ldx #10
	lda #32
.(
loop1	sta PressKeyEntryPoint,x
	dex
	bne loop1
.)
	rts
	
PlotPressKey
	ldx #10
.(
loop1	lda PressKeyText,x
	sta PressKeyEntryPoint,x
	dex
	bne loop1
.)
	;Update bgbuffer
	jmp RefreshTitleMenus

WaitOnKeyCode	;Returns Column in A and Row in Y
	;Also process screen whilst we wait for key
.(
loop1	jsr CopyBGBuffer
	jsr ossScript_Driver
	jsr ZoomScreen
	lda UltimateSprite
	bpl skip1
	jsr SetupRandomScript
	;Check for a key
skip1	jsr ReadAllKeys
	ldy WaitingOnKeyup
	bne skip2
	bcc loop1
	;loop until key up
	lda #1
	sta WaitingOnKeyup
	;Remember Key Row and Column found
	lda MenuKeyRow
	sta MenuOriginalKeyRow
	lda MenuKeyColumn
	sta MenuOriginalKeyColumn
	jmp loop1
skip2	bcs loop1
	lda #00
	sta WaitingOnKeyup
.)
	rts
	

	

CopyBGBuffer
	;Same as cyclic except simple direct copy
	lda #<BGBuffer
	sta source
	lda #>BGBuffer
	sta source+1
	lda #<ScreenBuffer+2+12*24
	sta screen
	lda #>ScreenBuffer+2+12*24
	sta screen+1
	ldx #134
.(
loop2	ldy #19
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #20
	jsr AddSource
	lda #24
	jsr AddScreen
	dex
	bne loop2
.)
mmReturn	;6
	rts
	
	
DisplayMenuCursor
	ldx MenuID
	ldy MenuY,x
	lda ScreenTextRowAddressLo,y
	sta screen
	lda ScreenTextRowAddressHi,y
	sta screen+1
	ldy #00
	lda #%11111110
	sta (screen),y
	ldy #14
	lda #%11011111
	sta (screen),y
	
	lda #%01000011
	ldy #20
	sta (screen),y
	ldy #20+14
	lda #%01110000
	sta (screen),y
	
	lda #%11111000
	ldy #40
	sta (screen),y
	ldy #40+14
	lda #%11000111
	sta (screen),y
	
	lda #%01000011
	ldy #60
	sta (screen),y
	ldy #60+14
	lda #%01110000
	sta (screen),y
	
	lda #%11111110
	ldy #80
	sta (screen),y
	ldy #80+14
	lda #%11011111
	sta (screen),y
	rts
	
DeleteMenuCursor
	ldx MenuID
	ldy MenuY,x
	lda ScreenTextRowAddressLo,y
	sta screen
	lda ScreenTextRowAddressHi,y
	sta screen+1
	ldy #00
	lda #$FF
	sta (screen),y
	ldy #14
	sta (screen),y
	
	lda #$40
	ldy #20
	sta (screen),y
	ldy #20+14
	sta (screen),y
	
	lda #$FF
	ldy #40
	sta (screen),y
	ldy #40+14
	sta (screen),y
	
	lda #$40
	ldy #60
	sta (screen),y
	ldy #60+14
	sta (screen),y
	
	lda #$FF
	ldy #80
	sta (screen),y
	ldy #80+14
	sta (screen),y
	rts

Display_Menu
	ldx MenuID
	lda MenuAddressLo,x
	sta source
	lda MenuAddressHi,x
	sta source+1
	lda #<BGBuffer+5+54*20
	sta screen
	lda #>BGBuffer+5+54*20
	sta screen+1
.(	
loop2	ldy #00
	
loop1	lda (source),y
	beq EndOfMenu
	tax
	lda CharacterSet-32,x
	sta (screen),y		;Row 1
	tya
	clc
	adc #20
	tay
	lda CharacterSet-32+77*1,x	;Row 2
	sta (screen),y
	tya
	adc #20
	tay
	lda CharacterSet-32+77*2,x	;Row 3
	sta (screen),y
	tya
	adc #20
	tay
	lda CharacterSet-32+77*3,x	;Row 4
	sta (screen),y
	tya
	adc #20
	tay
	lda CharacterSet-32+77*4,x	;Row 5
	sta (screen),y

	tya
	sec
	sbc #80
	tay
	iny
	cpy #11
	bcc loop1
	
	lda #11
	jsr AddSource
	
	lda #200
	jsr AddScreen
	jmp loop2
EndOfMenu	rts
.)
	
	
	
	

MenuAddressLo
 .byt <Text_TitleMenu
 .byt <Text_AudioMenu
 .byt <Text_Controllers
 .byt <Text_HighScores
 .byt <Text_Credits
 .byt <Text_KeyConfig
MenuAddressHi
 .byt >Text_TitleMenu
 .byt >Text_AudioMenu
 .byt >Text_Controllers
 .byt >Text_HighScores
 .byt >Text_Credits
 .byt >Text_KeyConfig

ScreenTextRowAddressLo
 .byt <BGBuffer+3+54*20
 .byt <BGBuffer+3+64*20
 .byt <BGBuffer+3+74*20
 .byt <BGBuffer+3+84*20
 .byt <BGBuffer+3+94*20
 .byt <BGBuffer+3+104*20
 .byt <BGBuffer+3+114*20
 .byt <BGBuffer+3+124*20
 
ScreenTextRowAddressHi
 .byt >BGBuffer+3+54*20
 .byt >BGBuffer+3+64*20
 .byt >BGBuffer+3+74*20
 .byt >BGBuffer+3+84*20
 .byt >BGBuffer+3+94*20
 .byt >BGBuffer+3+104*20
 .byt >BGBuffer+3+114*20
 .byt >BGBuffer+3+124*20

Text_TitleMenu
 .byt "   BEGIN   "
 .byt " 2 PLAYERS "
 .byt "   AUDIO   "
 .byt "CONTROLLERS"
 .byt "HIGH SCORES"
 .byt "  CREDITS  "
 .byt 0

Text_AudioMenu
 .byt "TITLE      "
 .byt "   ON      "
 .byt "IN-GAME    "
 .byt "   ON      "
 .byt "EFFECTS    "
 .byt "   ON      "
 .byt 0

Text_Controllers
; .byt "01234567890123456789"
 .byt "P1-KEYBOARD"
Text_Controller_Keys
 .byt "   ",99," ",104,105,106,107,"  "
 .byt "P2-KEYBOARD"
 .byt "   ",98," ZAQX  "
 .byt 0
; 32-93 TriRight(94) TriLeft(95) LeftShift(96) RightShift(97) LeftCtrl(98) RightCtrl(99)
; SpaceBar(100) Escape(101) Funct(102) Del(103) LeftCrsr(104) DownCrsr(105) UpCrsr(106)
; RightCrsr(107) Return(108)

Text_KeyConfig
 .byt "LEFT   -   "
 .byt "RIGHT  -   "
 .byt "FIRE   -   "
 .byt "UP     -   "
 .byt "DOWN   -   "
 .byt "           "
PressKeyEntryPoint
 .byt "           "
 .byt 0
PressKeyText
 .byt " PRESS KEY "

Text_HighScores
 .byt "   TOP 5   "
 .byt "   -0000000"
 .byt "   -0000000"
 .byt "   -0000000"
 .byt "   -0000000"
 .byt "   -0000000"
 .byt 0

Text_Credits
 .byt "PROGRAM    "
 .byt "  TWILIGHTE"
 .byt "ADDITIONAL "
 .byt "  DBUG     "
 .byt "  CHEVRON  "
 .byt 0


ReadAllKeys
	; Setup Key Column Register
	lda #$0E
	sta VIA_PORTA
	lda #$FF
	sta VIA_PCR
	lda #$DD
	sta VIA_PCR
	; Read all keys
	ldx #7
.(
loop2	lda KeyColumn,x
	sta MenuKeyColumn
	sta VIA_PORTA
	lda #$FD
	sta VIA_PCR
	lda #$DD
	sta VIA_PCR
	ldy #7
loop1	sty VIA_PORTB
	nop
	nop
	nop
	lda VIA_PORTB
	and #8
	bne skip1
	dey
	bpl loop1
	dex
	bpl loop2
	clc
	rts
skip1	sty MenuKeyRow
.)
KeyRowColumn2Ascii
	txa
	asl
	asl
	asl
	ora MenuKeyRow
	tax
	lda KeyMatrix2ASCII,x
	sec
	rts
KeyColumn
 .byt $FE,$FD,$FB,$F7,$EF,$DF,$BF,$7F
MenuKeyRow
 .byt 0	
; 32-93 TriRight(94) TriLeft(95) LeftShift(96) RightShift(97) LeftCtrl(98) RightCtrl(99)
; SpaceBar(100) Escape(101) Funct(102) Del(103) LeftCrsr(104) DownCrsr(105) UpCrsr(106)
; RightCrsr(107) Return(108)
;B0-2 Key Row
;B3-5 Key Column
KeyMatrix2ASCII
 .byt "7JMK UY8"
 .byt "NT69,IHL"
 .byt "5RB;,OG0"
 .byt "VF4-",106,"PE/"
 .byt 99,0,98,0,96,102,0,97
 .byt "1",101,"Z\",104,103,"A",108
 .byt "XQ2",0,105,"]S",0
 .byt "3DC'",107,"]W="

;X Player - Dictates which scorepanel the controller is constructed on
ConstructDeviceAndSide
	;Display main device
	lda DeviceScreenLocLo,x
	sta screen
	lda DeviceScreenLocHi,x
	sta screen+1
	stx Temp01
	lda P1_Device,x
.(
	bne skip1
	lda #<gfxKeyboard
	sta source
	lda #>gfxKeyboard
	sta source+1
	jmp skip2
skip1	lda #<gfxJoystick
	sta source
	lda #>gfxJoystick
	sta source+1
skip2	ldx #19
loop2	ldy #5
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	lda #40
	jsr AddScreen
	lda #6
	jsr AddSource
	dex
	bne loop2
.)
	;Is Joystick?
	ldx Temp01
.(
	lda P1_Device,x
	beq skip1
	;Which Side?
	lda P1_DeviceSide,x
	beq LeftSide
	lda #<gfxJoystickRight
	sta source
	lda #>gfxJoystickRight
	jmp skip2
LeftSide	lda #<gfxJoystickLeft
	sta source	
	lda #>gfxJoystickLeft
skip2	sta source+1
	lda DeviceLetterScreenLocLo,x
	sta vector1+1
	lda DeviceLetterScreenLocHi,x
	sta vector1+2
	ldy #4
loop1	ldx ScreenOffset,y
	lda (source),y
vector1	sta $dead,x
	dey
	bpl loop1
skip1	rts
.)
DeviceLetterScreenLocLo
 .byt <$B774
 .byt <$B792
DeviceLetterScreenLocHi
 .byt >$B774
 .byt >$B792
DeviceScreenLocLo
 .byt <$B720
 .byt <$B73E
DeviceScreenLocHi
 .byt >$B720
 .byt >$B73E

gfxJoystick
 .byt $06,$7F,$7F,$7F,$7F,$79
 .byt $06,$60,$40,$40,$40,$49
 .byt $06,$6A,$6A,$6A,$6A,$69
 .byt $06,$60,$40,$40,$40,$49
 .byt $06,$6A,$69,$72,$6A,$68
 .byt $06,$60,$43,$78,$40,$48
 .byt $06,$6A,$69,$72,$6A,$68
 .byt $06,$60,$44,$44,$40,$48
 .byt $06,$6A,$60,$60,$6A,$6B
 .byt $06,$60,$03,$60,$06,$48
 .byt $06,$6A,$40,$40,$4A,$68
 .byt $01,$60,$5C,$47,$06,$48
 .byt $06,$6A,$40,$40,$4A,$6B
 .byt $06,$60,$40,$03,$45,$48
 .byt $06,$6A,$40,$40,$4A,$68
 .byt $06,$60,$41,$50,$40,$48
 .byt $06,$6A,$6A,$4A,$6A,$6B
 .byt $06,$60,$40,$40,$40,$48
 .byt $06,$7F,$7F,$7F,$7F,$78
gfxKeyboard	;5x19 
 .byt $06,$7F,$7F,$7F,$7F,$79
 .byt $06,$60,$40,$40,$40,$49
 .byt $06,$6A,$6A,$6A,$6A,$69
 .byt $06,$60,$40,$40,$40,$49
 .byt $06,$69,$54,$40,$ED,$68
 .byt $06,$60,$68,$40,$40,$48
 .byt $06,$69,$55,$55,$54,$68
 .byt $06,$60,$40,$40,$40,$48
 .byt $06,$6A,$6A,$6A,$6A,$6B
 .byt $06,$60,$40,$40,$40,$48
 .byt $06,$69,$55,$55,$54,$68
 .byt $06,$60,$6A,$6A,$68,$48
 .byt $06,$69,$55,$55,$54,$6B
 .byt $06,$60,$6A,$6A,$68,$48
 .byt $06,$68,$55,$7D,$50,$68
 .byt $06,$60,$40,$40,$40,$48
 .byt $06,$6A,$6A,$6A,$6A,$6B
 .byt $06,$60,$40,$40,$40,$48
 .byt $06,$7F,$7F,$7F,$7F,$78
gfxJoystickLeft
 .byt $68
 .byt $48
 .byt $68
 .byt $48
 .byt $6E
gfxJoystickRight
 .byt $6C
 .byt $4A
 .byt $6C
 .byt $4A
 .byt $6A
