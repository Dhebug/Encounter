;Frontend.s
#define	TAB1	1
#define	TAB2	2
#define	TAB3	3
#define	TAB4	4
#define	TAB5	5
#define	TAB6	6
#define	TAB7	7
#define	TAB8	8
#define	TAB9	9
#define	TAB10	10
#define	TAB11	11
#define	TAB12	12
#define	TAB13	13
#define	TAB14	14
#define	TAB15	15
#define	TAB16	16
#define	TAB17	17
#define	TAB18	18
#define	TAB19	19
#define	TAB20	20
#define	TAB21	21
#define	TAB22	22
#define	TAB23	23
#define	TAB24	24
#define	TAB25	25
#define	TAB26	26
#define	TAB27	27
#define	TAB28	28
#define	TAB29	29
#define	TAB30	30
#define	TAB31	31
#define	ENDOFROW	128
#define	ENDOFTEXT	0

FrontEnd
	;Start by using level 2 (classic) for display
	ldx #MAP_LEVEL2
	jsr UnpackData

	lda #FRONTEND_TITLE
	sta CurrentDisplay
	lda #10
	sta InactivityCountdown
	lda #00
	sta usm_SunMoonYPos
	lda #25
	sta SecondCounter
	lda #17
	sta MapX
.(
	jsr DrawMap	;And pop bgbuff
	ldx #OVERLAY_TITLE
	jsr DisplayOverlay
	

loop1	lda KeyRegister
	bne loop1
	;Add inactivity timer
	lda #200
	sta ProgrammableCountdown
loop2	;Strobe inactivity
	lda ProgrammableCountdown
	bne skip7
	; ProgrammableCountdown is not enough, so use additional counter
	lda #200
	sta ProgrammableCountdown
	dec InactivityCountdown
	beq InactivityTimeout
skip7	lda KeyRegister
	beq loop2

	ldx CurrentDisplay
	cpx #FRONTEND_OPTIONS
	bne skip2
	
	cmp #CTRL_UP
	bne skip3
	;Up pressed
	lda MenuOptionsY
	beq loop1
	jsr DeleteOptionHearts
	dec MenuOptionsY
	jmp skip4
skip3	cmp #CTRL_DOWN
	bne skip5
	;Down pressed
	lda MenuOptionsY
	cmp #4
	bcs loop1
	jsr DeleteOptionHearts
	inc MenuOptionsY
	jmp skip4
skip5	cmp #CTRL_LEFT
	bne skip6
	jsr DecOption
	jmp skip1
skip6	cmp #CTRL_RIGHT
	bne skip2
	jsr IncOption
	jmp skip1
skip2	;Check for fire
	cmp #CTRL_FIRE

	bne skip8
	rts
skip8	cmp #CTRL_FIRE2
	beq Switch2Title
skip1	;Assume options required
	lda #FRONTEND_OPTIONS
	sta CurrentDisplay
loop3	lda KeyRegister
	bne loop3
	jsr ClearScreen
	ldx #OVERLAY_OPTIONS
	jsr DisplayOverlay
	jsr DisplayOptionHearts
	jmp loop1

skip4	jsr DisplayOptionHearts
	jmp loop1
InactivityTimeout
	;On timeout
	; Title(0) 	- Stuff(2)
	; Options(1)	- Title(0)
	; Stuff(2)	- Title(0)
	lda #10
	sta InactivityCountdown
	lda CurrentDisplay
	beq Switch2Stuff
Switch2Title
	jmp FrontEnd
Switch2Stuff
	lda #FRONTEND_STUFF
	sta CurrentDisplay
	jsr DrawMap	;And pop bgbuff
	ldx #OVERLAY_STUFF
	jsr DisplayOverlay
	jsr DisplayHighscore
	jmp loop1
.)

DeleteOptionHearts
	lda #2
	clc
	adc MenuOptionsY
	tax
	lda #">"
	ldy #0
	jsr PlotCharAtXY
	ldy #27
	lda #">"
	jmp PlotCharAtXY
	


DisplayOptionHearts
	lda MenuOptionsY	;0-3
	clc
	adc #2
	tax
	lda #":"
	ldy #0
	jsr PlotCharAtXY
	lda #":"
	ldy #27
	jmp PlotCharAtXY
	
DecOption	ldy MenuOptionsY
	lda OptionValue,y
	sec
	sbc #01
.(
	bpl skip1
	lda OptionRange,y
skip1	sta OptionValue,y
.)
	jmp StoreOption
	
	
IncOption	ldy MenuOptionsY
	lda OptionValue,y
	clc
	adc #01
	cmp OptionRange,y
.(
	beq skip1
	bcc skip1
	lda #00
skip1	sta OptionValue,y
.)
	jmp StoreOption



StoreOption
	cpy #1
	bcc PlotOption1
	beq PlotOption2
	cpy #3
	bcc PlotOption3
	beq PlotOption4
	jmp PlotOption5
	
PlotOption1
	lda OptionValue
	asl
	asl
	tay
	ldx #3
.(
loop1	lda Option1Texts,y
	sta TextOverlay_SoundOption,x
	iny
	dex
	bpl loop1
.)
	rts
	
Option1Texts
 .byt "L"+128,"LUF"
 .byt "T"+128,"FOS"
 .byt " "+128,"FFO"

PlotOption2
	lda OptionValue+1
	asl
	asl
	adc OptionValue+1
	tay
	ldx #4
.(
loop1	lda Option2Texts,y
	sta TextOverlay_IngameOption,x
	iny
	dex
	bpl loop1
.)
	rts
	
Option2Texts
 .byt "C"+128,"ISUM"
 .byt " "+128," XFS"
 
PlotOption3
	lda OptionValue+2
	asl
	asl
	asl
	tay
	ldx #7
.(
loop1	lda Option3Texts,y
	sta TextOverlay_InputOption,x
	iny
	dex
	bpl loop1
.)
	rts
	
Option3Texts
 .byt "D"+128,"RAOBYEK"
 .byt "Y"+128,"OJ  KJI"
 .byt "Y"+128,"OJ ESAP"
 .byt "Y"+128,"OJ ELET"
 
PlotOption4
	lda OptionValue+3
	asl
.(
	sta vector1+1
	asl
	asl
vector1	adc #00
.)
	tay
	ldx #9
.(
loop1	lda Option4Texts,y
	sta TextOverlay_ScreenOption,x
	iny
	dex
	bpl loop1
.)
	rts
	
Option4Texts
 .byt " "+128,"   RUOLOC"
 .byt "E"+128,"MORHCONOM"
 
PlotOption5
	lda Option_Difficulty
	asl
.(
	sta vector1+1
	asl
vector1	adc #00
.)
	tay
	ldx #5
.(
loop1	lda Option5Texts,y
	sta TextOverlay_DifficultyOption,x
	iny
	dex
	bpl loop1
.)
	rts
Option5Texts
 .byt "E"+128,"CIVON"
 .byt "L"+128,"AMRON"
 .byt "E"+128,"NASNI"
	
	
	
OverlayTextScreenylocl
 .byt <$A006+480*3
 .byt <$A006+480*4
 .byt <$A006+480*5
 .byt <$A006+480*6
 .byt <$A006+480*7
 .byt <$A006+480*8
 .byt <$A006+480*9
 .byt <$A006+480*10
 .byt <$A006+480*11
 .byt <$A006+480*12
 .byt <$A006+480*13
 .byt <$A006+480*14
 .byt <$A002+40*138	;12
OverlayTextScreenyloch
 .byt >$A006+480*3
 .byt >$A006+480*4
 .byt >$A006+480*5
 .byt >$A006+480*6
 .byt >$A006+480*7
 .byt >$A006+480*8
 .byt >$A006+480*9
 .byt >$A006+480*10
 .byt >$A006+480*11
 .byt >$A006+480*12
 .byt >$A006+480*13
 .byt >$A006+480*14
 .byt >$A002+40*138


CursorX		.byt 0
CursorY		.byt 0
TextIndex		.byt 0
EndOfRowFlag	.byt 0

DisplayOverlay
	lda TextOverlay_VectorLo,x
	sta text
	lda TextOverlay_VectorHi,x
	sta text+1
	 
	lda #00
	sta CursorX
	sta CursorY
	sta TextIndex
.(	
loop1	;Fetch next character
	ldy TextIndex
	lda (text),y
	;End of Text?
	beq EndOfText
	
	;Save Bit7
	cmp #128
	ror EndOfRowFlag
	
	;End of Row?
	and #127
	beq EndOfRow
	
	;Space?
	cmp #32
	beq DoSpace
	
	;Tab?
	bcc DoTab
	
	;Plot Character
	ldy CursorX
	ldx CursorY
	jsr PlotCharAtXY
DoSpace	lda EndOfRowFlag
	bmi EndOfRow
	inc CursorX
	inc TextIndex
	jmp loop1
EndOfRow	lda #00
	sta CursorX
	inc CursorY
	jmp DoTab2
DoTab	adc CursorX
	sta CursorX
DoTab2	inc TextIndex
	jmp loop1
EndOfText	rts
.)

TextOverlay_VectorLo
 .byt <TextOverlay_Title		;0
 .byt <TextOverlay_redefine             ;1
 .byt <TextOverlay_Options		;2
 .byt <TextOverlay_Stuff                ;3
 .byt <TextOverlay_HighScoreEntry       ;4
 .byt <TextOverlay_Timeout              ;5
 .byt <TextOverlay_Gameover             ;6
 .byt <TextOverlay_LevelIntro1	;7
 .byt <TextOverlay_LevelIntro2	;8
 .byt <TextOverlay_LevelIntro3	;9
 .byt <TextOverlay_GameCompleted	;10
TextOverlay_VectorHi
 .byt >TextOverlay_Title
 .byt >TextOverlay_redefine
 .byt >TextOverlay_Options
 .byt >TextOverlay_Stuff
 .byt >TextOverlay_HighScoreEntry
 .byt >TextOverlay_Timeout
 .byt >TextOverlay_Gameover
 .byt >TextOverlay_LevelIntro1
 .byt >TextOverlay_LevelIntro2
 .byt >TextOverlay_LevelIntro3
 .byt >TextOverlay_GameCompleted
	
;0 	End of text
;1-31	Tab(1 to 31)
;32	Space (but not plotted)
;58     : Heart
;59     ; Separator
;60     < Back Symbol
;61     = Return Symbol
;62     > Real Space
;63     ? Question Mark
;64     @ Exclamation Mark
;65-80	Characters
;+128	Last character of row
;128	Last character of row
TextOverlay_Timeout
 .byt ENDOFROW
 .byt ENDOFROW
 .byt ENDOFROW
 .byt TAB8,"OUT OF TIM","E"+128
 .byt ENDOFTEXT
TextOverlay_Gameover
 .byt ENDOFROW
 .byt ENDOFROW
 .byt ENDOFROW
 .byt TAB7,"GAME OVE","R"+128
 .byt ENDOFTEXT
TextOverlay_LevelIntro1
 .byt ENDOFROW
 .byt ENDOFROW
 .byt ENDOFROW
 .byt TAB1,"LEVEL ONE ; UNDERWURLD","E"+128
 .byt ENDOFTEXT
TextOverlay_LevelIntro2
 .byt ENDOFROW
 .byt ENDOFROW
 .byt ENDOFROW
 .byt TAB2,"LEVEL TWO ; TOP SID","E"+128
 .byt ENDOFTEXT
TextOverlay_LevelIntro3
 .byt ENDOFROW
 .byt ENDOFROW
 .byt ENDOFROW
 .byt TAB1,"LEVEL THREE ; CLOUD SCAP","E"+128
 .byt ENDOFTEXT
TextOverlay_Options
 .byt TAB9,"GAME OPTION","S"+128
 .byt ENDOFROW
 .byt TAB6,"SOUND   ; "
TextOverlay_SoundOption
 .byt "FUL","L"+128		;Full/Soft/Off
 .byt TAB6,"IN GAME ; "
TextOverlay_IngameOption
 .byt "MUSI","C"+128	;SFX/MUSIC
 .byt TAB6,"INPUT   ; "
TextOverlay_InputOption
 .byt "KEYBOAR","D"+128	;IJK/PASE/KEYBOARD/TELESTRAT
 .byt TAB6,"SCREEN  ; "
TextOverlay_ScreenOption
 .byt "COLOUR   "," "+128	;COLOUR/MONOCHROME
 .byt TAB2,"DIFFICULTY  ; "
TextOverlay_DifficultyOption
 .byt "NORMA","L"+128
 .byt "MOVE TO MODIFY OR FIRE TO PLA","Y"+128
 .byt ENDOFTEXT

TextOverlay_GameCompleted
 .byt TAB6,"S T O R M L O R ","D"+128
 .byt ENDOFROW
 .byt TAB4,"WELL DONE STORMLORD@@"
 .byt ENDOFROW
 .byt "YOU HAVE FREED ALL THE FAIRIE","S"+128
 .byt TAB4,"AND SAVED THE KINGDOM","@"+128
 .byt ENDOFTEXT

TextOverlay_Title
 .byt TAB4,"TWILIGHTE  PRESENT","S"+128
 .byt TAB5,"S T O R M L O R ","D"+128
 .byt ENDOFROW
 .byt TAB6,"ORIGINAL GAME B","Y"+128
 .byt TAB7,"RAFFAELE CECC","O"+128
 .byt ENDOFROW
 .byt TAB6,"MOVE FOR OPTION","S"+128
 .byt TAB5,"PRESS FIRE TO STAR","T"+128
 .byt ENDOFTEXT
TextOverlay_redefine
; .byt TAB5,"STORMLORD KEYS ARE",0   
; .byt TAB8,"LEFT",TAB4,33+128
; .byt TAB8,"RIGHT",TAB3,34+128
; .byt TAB8,"JUMP",TAB4,35+128
; .byt TAB8,"FIRE",TAB4,36+128
; .byt TAB8,"RESTART",TAB1,37+128
; .byt TAB2,"REDEFINE KEYS YES NO","?"+128
; .byt ENDOFTEXT
TextOverlay_Stuff	;For Symoon, credits, Highscore
 .byt TAB5,"S>T>O>R>M>L>O>R>","D"+128
 .byt TAB8,"FOR SYMOO","N"+128
 .byt ENDOFROW
 .byt TAB10,"TESTER","S"+128
 .byt TAB3,"CHEMA;DBUG;SYMOON;YAN","N"+128
 .byt TAB10,"IBISU","M"+128
 .byt "HISCORE TODAY ;;;;; BY "
HiscoreEntryText
 .byt ";;;;",";"+128
 .byt ENDOFTEXT
 
TextOverlay_HighScoreEntry
 .byt "NEW HISCORE;CONGRATULATIONS","@"+128
 .byt "PLEASE GRACE YOUR NAME BELO","W"+128
 .byt ENDOFROW
 .byt "A  B  C  D  E  F  G  H  I  ","J"+128
 .byt ENDOFROW
 .byt "K  L  M  N  O  P  Q  R  S  ","T"+128
 .byt ENDOFROW
 .byt "U  V  W  X  Y  Z  :  @  <  ","="+128
 .byt TAB12,";;;;;"," "+128
 .byt ENDOFTEXT

HiscoreLocationsLo	;Indexed by letter 0-29
 .byt <$A000+5+69*40
 .byt <$A000+8+69*40
 .byt <$A000+11+69*40
 .byt <$A000+14+69*40
 .byt <$A000+17+69*40
 .byt <$A000+20+69*40
 .byt <$A000+23+69*40
 .byt <$A000+26+69*40
 .byt <$A000+29+69*40
 .byt <$A000+32+69*40

 .byt <$A000+5+93*40
 .byt <$A000+8+93*40
 .byt <$A000+11+93*40
 .byt <$A000+14+93*40
 .byt <$A000+17+93*40
 .byt <$A000+20+93*40
 .byt <$A000+23+93*40
 .byt <$A000+26+93*40
 .byt <$A000+29+93*40
 .byt <$A000+32+93*40

 .byt <$A000+5+117*40
 .byt <$A000+8+117*40
 .byt <$A000+11+117*40
 .byt <$A000+14+117*40
 .byt <$A000+17+117*40
 .byt <$A000+20+117*40
 .byt <$A000+23+117*40
 .byt <$A000+26+117*40
 .byt <$A000+29+117*40
 .byt <$A000+32+117*40
HiscoreLocationsHi	;Indexed by letter 0-29
 .byt >$A000+5+69*40
 .byt >$A000+8+69*40
 .byt >$A000+11+69*40
 .byt >$A000+14+69*40
 .byt >$A000+17+69*40
 .byt >$A000+20+69*40
 .byt >$A000+23+69*40
 .byt >$A000+26+69*40
 .byt >$A000+29+69*40
 .byt >$A000+32+69*40

 .byt >$A000+5+93*40
 .byt >$A000+8+93*40
 .byt >$A000+11+93*40
 .byt >$A000+14+93*40
 .byt >$A000+17+93*40
 .byt >$A000+20+93*40
 .byt >$A000+23+93*40
 .byt >$A000+26+93*40
 .byt >$A000+29+93*40
 .byt >$A000+32+93*40

 .byt >$A000+5+117*40
 .byt >$A000+8+117*40
 .byt >$A000+11+117*40
 .byt >$A000+14+117*40
 .byt >$A000+17+117*40
 .byt >$A000+20+117*40
 .byt >$A000+23+117*40
 .byt >$A000+26+117*40
 .byt >$A000+29+117*40
 .byt >$A000+32+117*40

HiscoreHighlight
 .byt $F4,$C0,$CB
HiscoreCursorX	.byt 0
HiscoreCursorY	.byt 0


CheckHiscore
	;Check score against Hiscore and branch to entry system if more
	sed
	ldx #0
.(
loop1	lda HeroScore,x
	cmp HighScore,x
	bcc NoHighscore
	bne NewHighscore
	inx
	cpx #3
	bcc loop1
.)
NoHighscore
	cld
	rts
NewHighscore
	cld
	ldx #2
.(
loop1	lda HeroScore,x
	sta HighScore,x
	dex
	bpl loop1
.)
	jsr ClearScreen
	ldx #OVERLAY_HISCOREENTRY
	jsr DisplayOverlay
	
HiscoreEntry
	ldx #4
	lda #";"
.(
loop1	sta HighscoreText,x
	dex
	bpl loop1
.)
	lda #00
	sta TextCursor
.(
loop2	jsr PlotHiscoreHighlight

loop1	lda KeyRegister
	bne loop1
loop3	lda KeyRegister
	beq loop3

	jsr DeleteHiscoreHighlight
	lda KeyRegister
	cmp #CTRL_LEFT
	bne skip1
	;Left
	lda HiscoreCursorX
	beq skip9
	dec HiscoreCursorX
	jmp skip9
skip1	cmp #CTRL_RIGHT
	bne skip2
	;Right
	lda HiscoreCursorX
	cmp #9
	beq skip9
	inc HiscoreCursorX
	jmp skip9
skip2	cmp #CTRL_UP
	bne skip3
	;Up
	lda HiscoreCursorY
	beq skip9
	dec HiscoreCursorY
	jmp skip9
skip3	cmp #CTRL_DOWN
	bne skip4
	;Down
	lda HiscoreCursorY
	cmp #2
	beq skip9
	inc HiscoreCursorY
	jmp skip9
skip4	cmp #CTRL_FIRE
	bne skip9
	;Fire
	jsr EnterCharacter
skip9	jmp loop2
.)

EnterCharacter
	;Convert Cursor to character
	lda HiscoreCursorY
	asl
.(
	sta vector1+1
	asl
	asl
vector1	adc #00
.)
	adc HiscoreCursorX
	tax
	lda Cursor2Character,x
	;Was Delete selected?
	beq hsDelete
	;Was Return selected?
	bmi hsReturn
	
	ldx TextCursor
	cpx #5
.(
	beq skip1

	;plot character
	sta vector2+1
	lda TextCursor
	clc
	adc #12
	tay
	ldx #8
vector2	lda #00
	jsr PlotCharAtXY
	ldy TextCursor
	lda vector2+1
	sta HighscoreText,y
skip1	;The cursor can move to a 6th character even though only 5 can be entered
.)
	cpy #5
.(
	bcs skip1
	inc TextCursor
skip1	rts
.)

hsDelete
	lda TextCursor
.(
	beq skip1
	dec TextCursor
	lda TextCursor
skip1	clc
.)
	adc #12
	tay
	ldx #8
	lda #";"
	jsr PlotCharAtXY
	ldy TextCursor
	lda #";"
	sta HighscoreText,y
	rts

hsReturn	;Transfer text to Stuff overlay screen
	ldx #4
.(
loop1	lda HighscoreText,x
	sta HiscoreEntryText,x
	dex
	bpl loop1
.)
	;Clear 4 rows below play area (Entered name overlaps)
	ldx #159
	lda #64
.(
loop1	sta $9FFF+40*138,x
	dex
	bne loop1
.)
	;Return to HiscoreEntry Caller
	pla
	pla
	rts

Cursor2Character
 .byt "ABCDEFGHIJKLMNOPQRSTUVWXYZ:@",0,128
HighscoreText
 .dsb 6,";"	;6 but only first 5 are stored to
CheatCode1
 .byt "ARE YOU TRYING TO FIND THE CHEAT?"

PlotHiscoreHighlight
	lda HiscoreCursorY
	;x10
	asl
.(
	sta vector1+1
	asl
	asl
vector1	adc #00
.)
	adc HiscoreCursorX
	tax
	lda HiscoreLocationsLo,x
	sta screen
	clc
	adc #<40*14
	sta screen2
	lda HiscoreLocationsHi,x
	sta screen+1
	adc #>40*14
	sta screen2+1
	ldy #2
.(
loop1	lda HiscoreHighlight,y
	sta (screen),y
	sta (screen2),y
	dey
	bpl loop1
.)
	rts

DeleteHiscoreHighlight
	ldy #2
	lda #64
.(
loop1	sta (screen),y
	sta (screen2),y
	dey
	bpl loop1
.)
	rts

;A Character(58-90)
;X Xpos(0-26)
;Y Ypos(0-15)
PlotCharAtXY
	;Reserve AXY
	sta ReservedA+1
	stx ReservedX+1
	sty ReservedY+1
	
	;Fetch Char Address
	ldx ReservedA+1
	lda CharacterAddressLo-58,x
	sta char
	lda CharacterAddressHi-58,x
	sta char+1
	
	;Transfer Char definition to centre 12 byte buffer
	ldy #9
.(
loop1	lda (char),y
	sta CharBuffer+1,y
	dey
	bpl loop1
.)
	;Calculate location 1 pixel above char
	ldy ReservedX+1
	lda ReservedY+1
	clc
	adc OverlayTextScreenylocl,y
	sta screen
	lda OverlayTextScreenyloch,y
	adc #00
	sta screen+1
	
	lda screen
	sec
	sbc #40
	sta screen
	lda screen+1
	sbc #00
	sta screen+1
	
	;Branch on plotting real space
	ldy #00
	ldx #00
	lda ReservedA+1
	cmp #">"
.(
	bne skip3
loop2	lda #64
	sta (screen),y
	jsr nlScreen
	inx
	cpx #12
	bcc loop2
	jmp skip4

skip3	;Fetch Background location
loop1	lda (screen),y
	bpl skip1
	;Background is inverse
	;Is it even or odd row?
	ldy EvenRowFlag,x
	beq skip5
	lda #$40
	ldy #00
	jmp skip1
	;however only attempt mask if blue(odd) otherwise delete(even lines)
skip5	eor #128+63
	and CharMask,x
	ora CharBuffer,x
	eor #63+128
	jmp skip2
skip1	;Background is normal
	and CharMask,x
	ora CharBuffer,x
skip2	sta (screen),y
	jsr nlScreen
	inx
	cpx #12
	bcc loop1
skip4
.)
ReservedA	lda #00
ReservedX	ldx #00
ReservedY	ldy #00
	rts
EvenRowFlag	;Cyan 0
 .byt 0,1,0,1,0,1,0,1,0,1,0,1
CharMask
 .byt %11100001
 .byt %11000000
 .byt %11000000
 .byt %11000000
 .byt %11000000
 .byt %11000000
 .byt %11000000
 .byt %11000000
 .byt %11000000
 .byt %11000000
 .byt %11000000
 .byt %11100001
CharBuffer
 .dsb 12,64

EscMenu
	;Display Menu in middle border
	;"esc to quit or fire to restart level"
	ldx #35
.(
loop1	lda EscText,x
	pha
	stx EscTemp
	txa
	tay
	ldx #12
	pla
	jsr PlotCharAtXY
	ldx EscTemp
	dex
	bpl loop1
.)
	lda #<$A001+40*138
	sta screen
	lda #>$A001+40*138
	sta screen+1
	ldy #00
	ldx #10
.(
loop1	lda #3
	sta (screen),y
	jsr nlScreen
	dex
	bne loop1
.)	
.(
loop1	lda KeyRegister
	bne loop1
loop2	lda KeyRegister
	and #32+64
	beq loop2
.)
	cmp #CTRL_FIRE2
	php
	jsr ClearScreen
	plp
	rts

EscTemp	.byt 0
EscText
 .byt "ESC>TO>QUIT>OR>FIRE>TO>RESTART>LEVEL"


	
	