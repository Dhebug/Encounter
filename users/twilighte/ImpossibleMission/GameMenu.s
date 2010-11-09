;GameMenu - Use Puzzle area for game menu (15*45(5))
GameMenu
	inc GamePaused
GameMenu2
	jsr CLS
	lda #128	;Menu ID +128
	jsr DisplayMenuScreen
.(
loop1	lda InputRegister
	bne loop1
loop2	lda InputRegister
	beq loop2
	and #CONTROLLER_FIRE1
	beq skip3
skip1	jmp CLS
skip3	;Display Title Menu
	jsr CLS
	lda #4+128
	jsr DisplayMenuScreen
	lda #4
	sta ModemMenuOption
loop3	lda #128
	sta MenuType
	jsr ControlMenu
	;Act on Title menu option 0-2
	lda ModemMenuOption
	beq AdjustDifficulty
	cmp #2
	bcc AdjustColour
	beq AdjustAudio
	cmp #3
	bne GameMenu2
	;Load Game from Title Menu
	jmp LoadGame
AdjustAudio
	lda AudioFlag
	eor #128
	sta AudioFlag
	asl
	rol
	adc #5
	ldx #18+16
	jsr PlotTitleOptions10Text
	jsr DisplayAudioState
	jmp loop3
AdjustDifficulty
	ldx GameDifficulty
	inx
	cpx #3
	bcc skip2
	ldx #00
skip2	stx GameDifficulty
	jsr DisplayDifficulty
	ldx #02
	lda GameDifficulty
	jsr PlotTitleOptions10Text
	
	;Also display hours in time window
	jsr SetTime2Difficulty
	jsr DisplayHours
	jsr DisplayMinutes
	jsr DisplaySeconds
	
	jmp loop3
AdjustColour
	jsr AdjustColourVariables
	adc #3
	ldx #18
	jsr PlotTitleOptions10Text
	jmp loop3
.)

CLS	lda #<$B815
	sta screen
	lda #>$B815
	sta screen+1
	ldx #44
.(
loop2	ldy #14
	lda #64
loop1	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	dex
	bne loop2
.)
	rts

RightBorderColour1
 .byt 7
 .byt 3
RightBorderColour2
 .byt 7
 .byt 6
RightBorderColour3
 .byt 7
 .byt 2


PlotTitleOptions10Text
	;Ax10
	asl
.(
	sta vector1+1
	asl
	asl
vector1	adc #00
.)
	;Use as index in text
	tay
	lda #10
	sta Temp01
.(
loop1	lda TitleMenuDifficultyOptionTexts,y
	sta TitleMenuOptionText,x
	iny
	inx
	dec Temp01
	bne loop1
.)
	;Redisplay Menu
	lda CurrentMenuScreen
	ora #128
	jmp DisplayMenuScreen
	
	
AdjustColourVariables
	lda GameScreenColouring
	eor #1
	sta GameScreenColouring
SetScreenColours	
	ldy GameScreenColouring
	ldx RightBorderColour1,y
	stx MainShaftLiftCables+3
	stx MainShaftLiftGFX+5
	stx MainShaftLiftGFX2+4
	ldx RightBorderColour2,y
	stx MainShaftLiftCables+7
	ldx RightBorderColour3,y
	stx MainShaftLiftGFX2+1
	rts
	
;A Menu Screen Number (+128 for inv alt line)
DisplayMenuScreen
	cmp #128
	and #127
	sta CurrentMenuScreen
	tax
	lda #00
	adc #00
	sta MenuBGType
	lda MenuTextVectorLo,x
	sta line
	lda MenuTextVectorHi,x
	sta line+1
	jsr CLS
	
	ldx #00
.(
loop1	stx Temp01

	;Calculate x/y
	txa
	sta dt_Temp01
	asl
	asl
	asl
	adc #156
	tay
	ldx #5
	lda MenuBGType
	jsr DisplayTextLine
	;skip Nul
	iny
	tya
	clc
	adc line
	sta line
	bcc skip1
	inc line+1
skip1	ldx Temp01
	inx
	cpx #5
	bcc loop1
.)
	rts

MenuTextVectorLo
 .byt <GameMenuText		;0
 .byt <PhoneDirectoryText     ;1
 .byt <DiskMenuText           ;2
 .byt <StatsText              ;3
 .byt <TitleMenuText          ;4
 .byt <TapeLoadText           ;5
 .byt <TapeSaveText           ;6
MenuTextVectorHi
 .byt >GameMenuText
 .byt >PhoneDirectoryText
 .byt >DiskMenuText
 .byt >StatsText
 .byt >TitleMenuText
 .byt >TapeLoadText
 .byt >TapeSaveText
 	
PhoneDirectoryText
 .byt "  ENOUGH PIECES",0
 .byt "  FOR PUNCHCRD?",0
 .byt "  LOCATE SIMON ",0
 .byt "  AND CTRL ROOM",0
 .byt "  HANG UP      ",0
GameMenuText
;      012345678901234
 .byt "  IMPOSSIBLE   ",0
 .byt "    MISSION    ",0
 .byt 0
 .byt 32,32,32,77,79,86,69," FOR    ",0	;For no apparent reason xa was changing move to 1
 .byt "OPTIONS OR FIRE",0
TapeLoadText
 .byt " PRESS ",80,76,65,89," ON ",0
 .byt "     TAPE      ",0
 .byt 0
 .byt "  SEARCHING.. '",0
 .byt "+  LOADING..  '",0
TapeSaveText
 .byt "PRESS RECORD ON",0
 .byt "TAPE THEN PRESS",0
 .byt "     SPACE     ",0
 .byt 0
 .byt "+SAVING GAME..'",0
TitleMenuText
TitleMenuOptionText
 .byt "  EASY         ",0
 .byt "  COLOUR       ",0
 .byt "  AUDIO ON     ",0
 .byt "  LOAD GAME    ",0
 .byt "  BACK TO TITLE",0
DiskMenuText
 .byt "  SAVE GAME    ",0
 .byt "  LOAD GAME    ",0
 .byt "  QUIT TO TITLE",0
 .byt "  MONOCHROME   ",0
 .byt "  BACK         ",0
 
TitleMenuDifficultyOptionTexts
 .byt "EASY      "
 .byt "DIFFICULT "
 .byt "IMPOSSIBLE"
TitleMenuScreenModeOptionTexts
 .byt "MONOCHROME"
 .byt "COLOUR    "
TitleMenuKeysOptionTexts
 .byt "AUDIO OFF "
 .byt "AUDIO ON  "
StatsText	;First part is graphic of FURNITURE crunched into 7 characters
 .byt 91,92,93,94,95,60,59," "
 .byt "000)133",0
 .byt "ROOMS     00)31",0
 .byt "PUZZLES   00)28",0
 .byt "PUNCHCARDS  0)7",0
 .byt "SIMON STEPS  00",0

StatsFormatDigits	;0(1)/1(2)/128(3)
 .byt 128,1,1,0,1
OffsetInStatsText4Hundreds
 .byt 8,0,0,0,0
OffsetInStatsText4Tens
 .byt 9,26,42,0,77
OffsetInStatsText4Units
 .byt 10,27,43,60,78

SecurityTerminalMenuText	;28x7
 .byt "*** SECURITY TERMINAL "
SecurityTerminalNumberText
 .byt "99 ***",0
 .byt "      SELECT FUNCTION",0
 .byt 0
 .byt "    RESET LIFTING PLATFORMS",0
 .byt "      IN THIS ROOM.        ",0
 .byt "                           ",0
 .byt "    TEMPORARILY DISABLE    ",0
 .byt "      ROBOTS IN THIS ROOM. ",0
 .byt "                           ",0
 .byt 0
 .byt 0
 .byt 0
 .byt "    LOG OFF.",0

DisplaySecurityTerminalMenu
	;Set Security terminal ID to RoomID
	lda Old_RoomID
	jsr CalcTensAndUnits
	sta SecurityTerminalNumberText+1
	stx SecurityTerminalNumberText
	lda #<SecurityTerminalMenuText
	sta line
	lda #>SecurityTerminalMenuText
	sta line+1
DisplayBlockOfText
	ldx #00
.(
loop1	stx Temp01
	;Calculate Y (24+Xx7)
	txa
	asl
	sta Temp02
	asl
	adc Temp02
	adc Temp01
	adc #24
	tay
	
	ldx #6
	lda #0
	jsr DisplayTextLine
	;skip Nul
	iny
	tya
	clc
	adc line
	sta line
	bcc skip1
	inc line+1
skip1	ldx Temp01
	inx
	cpx #13
	bcc loop1
.)
	rts


 
 
