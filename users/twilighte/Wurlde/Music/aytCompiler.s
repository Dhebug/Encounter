;AYT Compiler

;The Compiler expects tune to already be in memory
;The Compiler begins by loading the Compiler program into $A000-$B4FF
#define LISTMEMORY			$0600
#define PATTERNMEMORY		$0E00
#define SFXMEMORY			$4E00

#define PATTERNREST			61
#define ENDSFX_CODE			221

#define PATTERNLOADDRESSOFFSETTABLELO   $5E00
#define PATTERNLOADDRESSOFFSETTABLEHI   $5E01
#define PATTERNHIADDRESSOFFSETTABLELO   $5E02
#define PATTERNHIADDRESSOFFSETTABLEHI   $5E03
#define SFXLOADDRESSOFFSETTABLELO       $5E04
#define SFXLOADDRESSOFFSETTABLEHI       $5E05
#define SFXHIADDRESSOFFSETTABLELO       $5E06
#define SFXHIADDRESSOFFSETTABLEHI       $5E07
#define SONGLOADDRESSOFFSETTABLELO      $5E08
#define SONGLOADDRESSOFFSETTABLEHI      $5E09
#define SONGHIADDRESSOFFSETTABLELO      $5E0A
#define SONGHIADDRESSOFFSETTABLEHI      $5E0B
#define FEATUREBYTE			$5E0C
#define TOPFREQUENCY		$5E0D

#define BIT0			1
#define BIT1                            2
#define BIT2                            4
#define BIT3                            8
#define BIT4                            16
#define BIT5                            32
#define BIT6                            64
#define BIT7                            128

 .zero
*=$00
UltimateSong		.dsb 1
ListRowStart		.dsb 1
ListRowEnd		.dsb 1
list			.dsb 2
RecordedCompileByte		.dsb 2
ListCommandByte1		.dsb 1
ListCommandByte1Flag	.dsb 1
ListCommandByte2		.dsb 1
ListCommandByte2Flag	.dsb 1
TrackRowUsed		.dsb 1

pattern			.dsb 2
UltimatePattern		.dsb 1
TempNote			.dsb 1
TempVolume		.dsb 1
TempSFX             	.dsb 1
TempCommand         	.dsb 1
TempParam1          	.dsb 1
TempParam2          	.dsb 1
PrevSFX			.dsb 1
PrevVolume		.dsb 1
RestRows			.dsb 1
                    	
sfx			.dsb 2
UltimateSFX		.dsb 1
                    	
BackupY			.dsb 1
BackupY2			.dsb 1
temp01			.dsb 1
 
 .text

;Memory..
;0600-5DFF Flat File
;5E00-9FFF Compiled Area
;	Header (Vector Offsets for Address Tables, All offset are relative to $5E00)
;	 +00 Pattern Lo Address Offset Table Lo
;	 +01 Pattern Lo Address Offset Table Hi
;	 +02 Pattern Hi Address Offset Table Lo
;	 +03 Pattern Hi Address Offset Table Hi
;	 +04 SFX Lo Address Offset Table Lo
;	 +05 SFX Lo Address Offset Table Hi
;	 +06 SFX Hi Address Offset Table Lo
;	 +07 SFX Hi Address Offset Table Hi
;	 +08 Song Lo Address Offset Table Lo
;	 +09 Song Lo Address Offset Table Hi
;	 +10 Song Hi Address Offset Table Lo
;	 +11 Song Hi Address Offset Table Hi
;	 +12 Default Song
;	 +13 Features Byte
;		0 -
;		1 -
;		2 Uses Resolutions
;		3 Uses Sharing
;		4 Uses Triggers
;		5 Uses Mimic
;		6 Uses Pitchbend
;		7 Uses Command Track H
;	 +14 Top Frequency (Bits 0-1)
;		0 25Hz
;		1 50Hz
;		2 100Hz
;		3 200Hz
;	 +15 -
;	List
;	Patterns
;	SFX
;	Pattern Address Tables
;	SFX Address Tables
;	Song Address Tables

;A000-B4FF Compiler MC and Tables

;Compile..
; 1 - Analyse music for stats and used Features(Pitchbend,Resolutions,Sharing,etc)
;Compile List..
; 1 - Compile all songs in list
; 2 - Reformatted to save bytes in RWC
; 3 - Compile only used tracks - Use format that avoids Track Rests
; 4 - Provide option to accelerate or optimise memory
;Compile Patterns..
; 1 - Compile Patterns using same method as SFX
; 2 - Provide option to accelerate or optimise memory
; 3 - Only compile used Patterns
;Compile SFX
; 1 - Compile only up to length of each SFX
; 2 - Only compile used SFX

*=$A000

Driver	jsr AnalyseMusic
	jsr CompileList
	jsr CompilePatterns
	jsr CompileSFX
	jsr CompileAddressTables
	rts
	
NoListEventsFound
	;Needs some warning message here
	rts

;Find ListRowStart
;Find ListRowEnd
;Find UltimatePattern
;Erase unused patterns so that if we do compile them they'll only use one Period byte
AnalyseMusic
	ldy #00
.(
loop2	jsr IsListRWC
	bcs skip1
	ldx #07
loop1	jsr IsTrackRest
	bcc skip1
	dex
	bpl loop1
	iny
	bpl loop2
	jmp NoListEventsFound
skip1	sty ListRowStart
.)
	ldy #127
.(
loop2	jsr IsListRWC
	bcs skip1
	ldx #07
loop1	jsr IsTrackRest
	bcc skip1
	dex
	bpl loop1
	dey
	bpl loop2
skip1	sty ListRowEnd
.)
	ldy ListRowStart
.(
loop2	jsr IsListRWC
	bcs skip2
	ldx #07
loop1	jsr IsTrackRest
	bcs skip1
	jsr IsTrackMimic
	bcc skip6
	lda FEATUREBYTE
	ora #BIT5
	sta FEATUREBYTE	
	jmp skip1
skip6	jsr ListFetchPattern
	cmp UltimatePattern
	bcc skip3
	sta UltimatePattern
skip3	sty BackupY
	tay
	;Is this a command Pattern?
	cpx #7
	bne skip4
	sty BackupY2
	ldy #15
	lda (list),y
	and #63
	ldy BackupY2
	cmp #63
	beq skip5
skip4	lda #1
skip5	sta PatternUsageTable,y	;0(Not used) 1(Used) 63(Command Pattern)
	
	ldy BackupY
skip1	dex
	bpl loop1
skip2	iny
	cpy ListRowEnd
	beq loop2
	bcc loop2
.)
	ldy UltimatePattern
.(
loop1	lda PatternUsageTable,y
	bne skip1
	;Erase this Pattern
	jsr CalcPatternAddress
	sty BackupY
	ldy #127
	lda #PATTERNREST
loop2	sta (pattern),y
	dey
	bpl loop2
	ldy BackupY
skip1	dey
	bpl loop1
.)
	rts	

	


;Compiled List Format
;Byte0 - Bits 0-3 - 00-07 Track Pattern(Track)
;        Bits 4-5 - -
;        Bits 6-7 - 0 Normal
;                   1 Mimic Left Flag(Pattern byte becomes Mimic Parameters)
;                   2 Mimic Right Flag(Pattern byte becomes Mimic Parameters)
;		3 -
;Byte1 - Bits 0-6 -	Pattern(0-127)
;        Bits 7-7 - Last Track Definition before Play(128)
;Byte2 - Bits 0-5 - SS(0-63)
;        Bits 6-7 - -

;Byte0 - Bits 0-3 - 08-08 RWC New Song
;        Bits 4-7 - -
;Byte1 - Bits 0-7 - Tempo

;Byte0 - Bits 0-3 - 09-09 RWC End Song
;        Bits 4-7 - -
;Byte1 - Bits 0-6 - Loop(0(End)-127)
;        Bits 7-7 - Silence(128)

;Byte0 - Bits 0-3 - 10-10 RWC Fade Music (Reserved)
;        Bits 4-7 - -

;Byte0 - Bits 0-3 - 11-11 RWC IRQ Rates
;        Bits 4-5 - SFX IRQ
;        Bits 4-7 - Music IRQ


;Byte0 - Bits 0-3 - 12-12 RWC Sharing Behaviour
;        Bits 4-6 - Share Ticks(0-7)
;        Bits 7-7 - SFX Behaviour

;Byte0 - Bits 0-3 - 13-13 Note Offset
;        Bits 4-7 - -
;Byte1 - Bits 0-6 - Note Offset(0-95)
;        Bits 7-7 - -
;Byte2 - Bits 0-7 - Channels

;Byte0 - Bits 0-3 - 14-14 Resolutions
;        Bits 4-5 - -
;        Bits 6-6 - Noise Resolution
;        Bits 7-7 - Volume Resolution

;Byte0 - Bits 0-3 - 15-15 Spare
;        Bits 4-7 - -

CompileList
	lda #<$5E10
	sta CompileByte+1
	lda #>$5E10
	sta CompileByte+2
	ldy ListRowStart
.(
loop2	jsr IsListRWC
	bcs skip4
	;Tracks
	ldx #00
	stx TrackRowUsed
	
loop1	jsr IsTrackRest
	bcs skip1
	inc TrackRowUsed
	jsr GetTrackCommand
	stx temp01
	ora temp01
skip2	jsr CompileByte
	jsr RecordCompileByte
	jsr ListFetchPattern
	jsr CompileByte
	jsr ListFetchSS
	jsr CompileByte
skip1	inx
	cpx #8
	bcc loop1

	lda TrackRowUsed
	beq skip3
	jsr MarkLastTrackAsUltimate
	jmp skip3
skip4	jsr ListFetchCommand	;16-23
	jsr CompileByte
	jsr ListFetchParam1
	bcc skip3	;No byte1
	jsr CompileByte
	jsr ListFetchParam2
	bcc skip3	;No byte2
	jsr CompileByte
skip3	iny
	cpy ListRowEnd
	bcc loop2
.)
	rts	

IsListRWC
	sty BackupY
	jsr CalcListAddress	;From Y(Row) to list
	ldy #01
	lda (list),y
	cmp #%11000000
	ldy BackupY
	rts
	
IsTrackRest
	sty BackupY
	jsr CalcListAddress	;From Y(Row) to list
	txa
	asl
	tay
	lda (list),y
	and #127
	cmp #127
	ldy BackupY
	rts
	
IsTrackMimic
	sty BackupY
	txa
	asl
	tay
	iny
	lda (list),y
	cmp #%11000000
.(
	bcs skip1
	cmp #%01000000
	rts
skip1	clc
.)
	rts
	
	
;Get Track Command into Acc(B6-7)
GetTrackCommand
	sty BackupY
	jsr CalcListAddress	;From Y(Row) to list
	txa
	asl
	tay
	iny
	lda (list),y
	and #%11000000
	ldy BackupY
	rts

	
ListFetchPattern
	sty BackupY
	jsr CalcListAddress	;From Y(Row) to list
	txa
	asl
	tay
	lda (list),y
	and #127
	ldy BackupY
	rts
	
ListFetchSS
	sty BackupY
	jsr CalcListAddress	;From Y(Row) to list
	txa
	asl
	tay
	iny
	lda (list),y
	and #63
	ldy BackupY
	rts

MarkLastTrackAsUltimate
	sty BackupY
	ldy #00
	lda (RecordedCompileByte),y
	ora #128
	sta (RecordedCompileByte),y
	ldy BackupY
	rts

;Return Command byte and master parameters in A
ListFetchCommand
	sty BackupY
	jsr CalcListAddress	;From Y(Row) to list
	ldy #00
	lda (list),y
	and #7
	tay
	;Branch to routines to handle each Commands Parameters
	lda ListCommandCompileVectorLo,y
.(
	sta vector1+1
	lda ListCommandCompileVectorHi,y
	sta vector1+2
vector1	jmp $dead
.)

;AYT format..
;0 New Music (Always set on Track A)
;  C0-7 Music Frac(0-255)
;Compiled format..
;Byte0 - Bits 0-3 - 08-08 RWC New Song
;        Bits 4-7 - -
;Byte1 - Bits 0-7 - Tempo
ListCommandCompileNewSong
	;Capture Compiled Song Start Location
	ldy UltimateSong
	lda CompileByte+1
	sta CompiledSongAddressLo,y
	lda CompileByte+2
	sta CompiledSongAddressHi,y
	inc UltimateSong
	ldy #2
	lda (list),y
	sta ListCommandByte1
	lda #128
	sta ListCommandByte1Flag
	lda #00
	sta ListCommandByte2Flag
	lda #8
	ldy BackupY
	rts


;AYT format..
;1 End of Song
;  A3   Silence(1)
;  C0-6 Jump back(Loop) to Row (If 128 the no loop)
;Compiled format..
;Byte0 - Bits 0-3 - 09-09 RWC End Song
;        Bits 4-7 - -
;Byte1 - Bits 0-6 - Loop(0(End)-127)
;        Bits 7-7 - Silence(128)
ListCommandCompileEndSong
	ldy #00
	lda (list),y
	and #%00001000
	asl
	asl
	asl
	asl
	ldy #2
	ora (list),y
	sta ListCommandByte1
	lda #128
	sta ListCommandByte1Flag
	lda #00
	sta ListCommandByte2Flag
	lda #9
	ldy BackupY
	rts
	

;AYT format..
;3 IRQ Rates
;   B0-1 SFX Rate (25Hz(0) 50Hz(1) 100Hz(2) 200Hz(3))
;   C0-1 Digidrum Rate (500Hz,1Khz,2Khz,3Khz)
;Compiled format..
;Byte0 - Bits 0-3 - 11-11 RWC IRQ Rates
;        Bits 4-5 - SFX IRQ
;        Bits 4-7 - Music IRQ
ListCommandCompileIRQRates
	lda #00
	sta ListCommandByte1Flag
	sta ListCommandByte2Flag
	;Check Top Frequency
	ldy #2
	lda (list),y
	and #3
	cmp TOPFREQUENCY
.(
	bcc skip1
	sta TOPFREQUENCY
skip1	dey
	lda (list),y
	and #3
	cmp TOPFREQUENCY
	bcc skip2
	sta TOPFREQUENCY
skip2	ldy #02
.)
	lda (list),y
	and #3
	asl
	asl
	dey
	ora (list),y
	asl
	asl
	asl
	asl
	ora #11
	ldy BackupY
	rts
	
;AYT format..
;4 Sharing Behaviour
;   A5    Sharing Behaviour(PROCSFX(0) or WAITSFX(1))
;   C0-7  Sharing Ticks (000 for maximum speed)
;Compiled format..
;Byte0 - Bits 0-3 - 12-12 RWC Sharing Behaviour
;        Bits 4-6 - Share Ticks(0-7)
;        Bits 7-7 - SFX Behaviour
ListCommandCompileSharing
	lda FEATUREBYTE
	ora #BIT3
	sta FEATUREBYTE
	lda #00
	sta ListCommandByte1Flag
	sta ListCommandByte2Flag
	ldy #02
	lda (list),y
	and #7
	asl
	asl
	sta temp01
	ldy #00
	lda (list),y
	and #%00100000
	ora temp01
	asl
	asl
	ora #12
	ldy BackupY
	rts

	
;AYT format..
;5 Note Offset Settings
;   C0-7 Channel Spread
;   D0-5 Note Offset C-0(C-0-C-4) to B-5(B-5 to B-9)
;Compiled format..
;Byte0 - Bits 0-3 - 13-13 Note Offset
;        Bits 4-7 - -
;Byte1 - Bits 0-6 - Note Offset(0-95)
;        Bits 7-7 - -
;Byte2 - Bits 0-7 - Channels
ListCommandCompileOffsets
	ldy #02
	lda (list),y
	sta ListCommandByte2
	lda #128
	sta ListCommandByte2Flag
	sta ListCommandByte1Flag
	ldy #3
	lda (list),y
	and #127
	sta ListCommandByte1
	lda #13
	ldy BackupY
	rts

;AYT format..
;6 Resolution Settings
;   A3    Use 5 Bit Noise Resolution(0) or 7 Bit(1)
;   A4    Use 4 Bit Volume Resolution(0) or 6 Bit(1)
;Compiled format..
;Byte0 - Bits 0-3 - 14-14 Resolutions
;        Bits 4-5 - -
;        Bits 6-6 - Noise Resolution
;        Bits 7-7 - Volume Resolution
ListCommandCompileResolutions
	lda FEATUREBYTE
	ora #BIT2
	sta FEATUREBYTE
	lda #00
	sta ListCommandByte1Flag
	sta ListCommandByte2Flag
	ldy #00
	lda (list),y
	and #%00011000
.(
	beq skip1
	pha
	lda #3
	sta TOPFREQUENCY
	pla
skip1	asl
.)
	asl
	asl
	ora #14
	ldy BackupY
	rts

;Compiled format..
;Byte0 - Bits 0-3 - 15-15 Spare
;        Bits 4-7 - -
ListCommandCompileSpare
	lda #00
	sta ListCommandByte1Flag
	sta ListCommandByte2Flag
	lda #15
	ldy BackupY
	rts


ListCommandCompileVectorLo
 .byt <ListCommandCompileNewSong
 .byt <ListCommandCompileEndSong
 .byt <ListCommandCompileSpare
 .byt <ListCommandCompileIRQRates
 .byt <ListCommandCompileSharing
 .byt <ListCommandCompileOffsets
 .byt <ListCommandCompileResolutions
 .byt <ListCommandCompileSpare
   
ListCommandCompileVectorHi
 .byt >ListCommandCompileNewSong
 .byt >ListCommandCompileEndSong
 .byt >ListCommandCompileSpare
 .byt >ListCommandCompileIRQRates
 .byt >ListCommandCompileSharing
 .byt >ListCommandCompileOffsets
 .byt >ListCommandCompileResolutions
 .byt >ListCommandCompileSpare
	


;Return C when byte is to be stored
;Return byte in A
ListFetchParam1
	lda ListCommandByte1
	asl ListCommandByte1Flag
	rts
	
;Return C when byte is to be stored
;Return byte in A
ListFetchParam2
	lda ListCommandByte2
	asl ListCommandByte2Flag
	rts

CompileByte
	sta $dead
	inc CompileByte+1
.(
	bne skip1
	inc CompileByte+2
skip1	rts
.)
	
RecordCompileByte
	lda CompileByte+1
	sta RecordedCompileByte
	lda CompileByte+2
	sta RecordedCompileByte+1
	rts

;Compiled Pattern Format..
;Byte 0 - 000-060 Note
;	061-061 -
;	062-063 Volume Rest
;	063-063 Bar
;	064-079 Volume(0-15)
;	080-143 SFX(0-63)
;	144-207 Period(0-63)

;	208-208 Trigger In Command(H Only)
;		+1 Location
;		+2 Value
;	209-209 Trigger Out Command(H Only) ?
;		+1 Location
;		+2 Value
;	210-225 Pitchbend Command(H Only) (Range is Rate)
;		+1 Tracks
;	226-226 Tempo Long Command(H Only)
;		+1 Tempo
;	227-255 Tempo Short Command(H Only) (Range is Tempo(0-27)
	
;To reduce bytes further, Volume is only supplied if different to last
;		      SFX is only supplied if different to last
;Period measures Rests between notes. If no rest then no period and notes are adjacent.
;Note is final element of row.

;So an example Pattern may look like this..
;RST
;C-0 15/00
;C-2 15/01
;RST
;RST
;RST
;C-4 12/01
;RST
;BAR
;18 Bytes

;And Compiled to..
;144	Period 1 Row
;079	Volume 15
;080	SFX 00
;000	Note C-0
;082	SFX 01
;024	Note C-0
;146	Period 3 Rows
;076	Volume 12
;048	Note C-4
;144	Period 1 Row
;063	Bar
;11 Bytes

;Compile Patterns..
; 1 - Compile Patterns using same method as SFX
; 2 - Provide option to accelerate or optimise memory
; 3 - Only compile used Patterns

;Compiles single Note Pattern starting at 'pattern'
;Also Updates FirstSFX and UltimateSFX
CompileSinglePattern
	sty BackupY2
	ldy #128
	sty PrevSFX
	sty PrevVolume
	ldy #00
	sty RestRows
.(	
loop1	jsr PatternFetchNVS
	lda TempNote
	cmp #61
	bne skip1
	inc RestRows
	jmp skip5
skip1	lda RestRows
	beq skip2
	clc
	adc #144
	jsr CompileByte
	lda #00
	sta RestRows
skip2	lda TempNote
	cmp #63
	beq skip4
	;VRST or NOTE - compile Volume if different
	lda TempVolume
	cmp PrevVolume
	beq skip3
	sta PrevVolume
	ora #64
	jsr CompileByte
skip3	lda TempNote
	cmp #61
	bcs skip4
	;NOTE - compile sfx if different
	lda TempSFX
	cmp PrevSFX
	beq skip4
	sta PrevSFX
	cmp UltimateSFX
	bcc skip7
	sta UltimateSFX
skip7	clc
	adc #80
	jsr CompileByte
skip4	;Finally compile NOTE,VRST or BAR
	lda TempNote
	jsr CompileByte
	cmp #63
	bcs skip6
skip5	iny
	cpy #64
	bcc loop1
skip6	ldy BackupY2
.)
	rts
	
CompileCommandPattern
	sty BackupY2
	ldy #128
	sty PrevSFX
	sty PrevVolume
	ldy #00
	sty RestRows
.(	
loop1	jsr PatternFetchCPP
	lda TempCommand
	cmp #4
	bne skip1
	inc RestRows
	jmp skip5
skip1	lda RestRows
	beq skip2
	clc
	adc #144
	jsr CompileByte
	lda #00
	sta RestRows
skip2	lda TempCommand
	cmp #12
	beq skip4
	;Compile Command
	ora #208
	jsr CompileByte
	cmp #210
	bcs skip7
	lda FEATUREBYTE
	ora #BIT4
	sta FEATUREBYTE
	jmp skip3
skip7	bne skip3
	lda FEATUREBYTE
	ora #BIT6
	sta FEATUREBYTE
skip3	;Compile Param1
	lda TempParam1
	jsr CompileByte
	;Compile Param2
	lda TempParam1
	jsr CompileByte
	jmp skip5
skip4	;Compile Bar
	lda #63
	jsr CompileByte
	jmp skip6
skip5	iny
	cpy #64
	bcc loop1
skip6	ldy BackupY2
.)
	rts

PatternFetchCPP
	sty BackupY
	tya
	asl
	tay
	lda (pattern),y
	and #15
	sta TempCommand
	lda (pattern),y
	lsr
	lsr
	lsr
	lsr
	sta TempParam1
	iny
	lda (pattern),y
	sta TempParam2
	ldy BackupY
	rts

PatternFetchNVS
	sty BackupY
	tya
	asl
	tay
	lda #00
	sta TempVolume
	lda (pattern),y
	lsr
	rol TempVolume
	lsr
	rol TempVolume
	sta TempNote
	iny
	lda (pattern),y
	lsr
	rol TempVolume
	lsr
	rol TempVolume
	sta TempSFX
	ldy BackupY
	rts

;Run through all patterns to 'UltimatePattern'
CompilePatterns
	ldx #00
	stx UltimateSFX
	ldy #00
.(
loop1	lda CompileByte+1
	sta CompiledPatternAddressLo,x
	lda CompileByte+2
	sta CompiledPatternAddressHi,x
	jsr CalcPatternAddress
	
	;Is H Command Track?
	lda PatternUsageTable,y	;0(Not used) 1(Used) 63(Command Pattern)
	cmp #63
	bne skip1
	jsr CompileCommandPattern
	lda FEATUREBYTE
	ora #BIT7
	sta FEATUREBYTE
	jmp skip2
skip1	jsr CompileSinglePattern
skip2	inx
	iny
	cpy UltimatePattern
	beq loop1
	bcc loop1
.)
	rts
	

CompileSFX
	ldx #00
.(
loop1	lda CompileByte+1
	sta CompiledSFXAddressLo,x
	lda CompileByte+2
	sta CompiledSFXAddressHi,x
	
	jsr CalcSFXAddress
	ldy #00
loop2	lda (sfx),y
	jsr CompileByte
	iny
	cmp #ENDSFX_CODE
	bne loop2

	inx
	cpx UltimateSFX
	beq loop1
	bcc loop1
.)
	rts

CompileAddressTables
	;Compile Pattern Tables
	lda CompileByte+1
	sta PATTERNLOADDRESSOFFSETTABLELO
	lda CompileByte+2
	sec
	sbc #$5E
	sta PATTERNLOADDRESSOFFSETTABLEHI
	ldy #00
.(
loop1	lda CompiledPatternAddressLo,y
	jsr CompileByte
	iny
	cpy UltimatePattern
	beq loop1
	bcc loop1
.)
	lda CompileByte+1
	sta PATTERNHIADDRESSOFFSETTABLELO
	lda CompileByte+2
	sec
	sbc #$5E
	sta PATTERNHIADDRESSOFFSETTABLEHI
	ldy #00
.(
loop1	lda CompiledPatternAddressHi,y
	jsr CompileByte
	iny
	cpy UltimatePattern
	beq loop1
	bcc loop1
.)	
	;Compile SFX Tables
	lda CompileByte+1
	sta SFXLOADDRESSOFFSETTABLELO
	lda CompileByte+2
	sec
	sbc #$5E
	sta SFXLOADDRESSOFFSETTABLEHI
	ldy #00
.(
loop1	lda CompiledSFXAddressLo,y
	jsr CompileByte
	iny
	cpy UltimateSFX
	beq loop1
	bcc loop1
.)
	lda CompileByte+1
	sta SFXHIADDRESSOFFSETTABLELO
	lda CompileByte+2
	sec
	sbc #$5E
	sta SFXHIADDRESSOFFSETTABLEHI
	ldy #00
.(
loop1	lda CompiledSFXAddressHi,y
	jsr CompileByte
	iny
	cpy UltimateSFX
	beq loop1
	bcc loop1
.)	
	;Compile Song Tables
	lda CompileByte+1
	sta SONGLOADDRESSOFFSETTABLELO
	lda CompileByte+2
	sec
	sbc #$5E
	sta SONGLOADDRESSOFFSETTABLEHI
	ldy #00
.(
loop1	lda CompiledSongAddressLo,y
	jsr CompileByte
	iny
	cpy UltimateSong
	beq loop1
	bcc loop1
.)
	lda CompileByte+1
	sta SONGHIADDRESSOFFSETTABLELO
	lda CompileByte+2
	sec
	sbc #$5E
	sta SONGHIADDRESSOFFSETTABLEHI
	ldy #00
.(
loop1	lda CompiledSongAddressHi,y
	jsr CompileByte
	iny
	cpy UltimateSong
	beq loop1
	bcc loop1
.)	
	rts

;Calculate Pattern Address (Y==Pattern) into 'pattern'
;A corrupted, XY Not corrupted
CalcPatternAddress
	tya
	lsr
	pha
	lda #00
	ror
	sta pattern
	pla
	adc #>PATTERNMEMORY
	sta pattern+1
	rts

;Calculate List Address (Y==Row) into 'list'
;A corrupted, XY Not corrupted
CalcListAddress
	tya
	sta list
	lda #00
	sta list+1
	asl list
	rol list+1
	asl list
	rol list+1
	asl list
	rol list+1
	asl list
	rol list+1
	;+Base Address
	lda list+1
	adc #>LISTMEMORY
	sta list+1
	rts


;Calculate SFX Address (Y==SFX) into 'sfx'
;A corrupted, XY Not corrupted
CalcSFXAddress
	lda #00
	sta sfx
	txa
	lsr
	ror sfx
	lsr
	ror sfx
	adc #>SFXMEMORY
	sta sfx+1
	rts 


CompiledSongAddressLo
 .dsb 64,0
CompiledSongAddressHi
 .dsb 64,0
CompiledPatternAddressLo
 .dsb 128,0
CompiledPatternAddressHi
 .dsb 128,0
CompiledSFXAddressLo
 .dsb 64,0
CompiledSFXAddressHi
 .dsb 64,0
PatternUsageTable
 .dsb 128,0
