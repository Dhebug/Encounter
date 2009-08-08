;LookupEditors.s
;On Returning from a lookup the selected entry is in A (And Y for Lists) and carry is Clear
;If the lookup was aborted or a selection was not made Carry is Set

LookupSFX
	ldx #12
	jmp BreakdownEntryInStatus
LookupPatternCommand
	lda PatternEntryByte0
	lsr
	lsr
	;Breakdown with threshhold to component ID
	ldx #10
.(
loop1	dex
	cmp prPatternCommandThreshhold,x
	bcc loop1
.)
	sbc prPatternCommandThreshhold,x
	sta PatternCommandRange
	jmp BreakdownEntryInStatus
LookupListMimic
	;10 or 01
	ldx #10
	jmp BreakdownEntryInStatus
LookupListSS
	ldx #11
	jmp BreakdownEntryInStatus
LookupNone	;Called to clear status line
	ldx #128
	jmp BreakdownEntryInStatus

;Parsed
;X 		Embedded Message ID (0-10)
BreakdownEntryInStatus
	lda #<$BB80+40*27
	sta screen
	lda #>$BB80+40*27
	sta screen+1
	ldy #01
	cpx #128
.(
	bcc skip1
	lda #9+128
loop1	sta (screen),y
	iny
	cpy #32
	bcc loop1
	rts
skip1	
.)
	lda EmbeddedMessageLo,x
.(
	sta vector1+1
	lda EmbeddedMessageHi,x
	sta vector1+2
vector1	lda $dead
	beq EndOfMessage
	bpl DisplayByteDirect
	and #127
	tax
	lda beisDisplayFormatLo,x
	sta vector2+1
	lda beisDisplayFormatHi,x
	sta vector2+2
vector2	jsr $dead
	jmp skip1
DisplayByteDirect
	ora #128
	sta (screen),y
	iny
skip1	inc vector1+1
	bne vector1
	inc vector1+2
	jmp vector1
EndOfMessage
.)
	;Clear to end of row
.(
loop1	cpy #32
	bcs skip1
	lda #9+128
	sta (screen),y
	iny
	jmp loop1
skip1	rts
.)

beisDisplayFormatLo
 .byt <DisplayType128
 .byt <DisplayType129
 .byt <DisplayType130
 .byt <DisplayType131
 .byt <DisplayType132
 .byt <DisplayType133
 .byt <DisplayType134
 .byt <DisplayType135
 .byt <DisplayType136
beisDisplayFormatHi
 .byt >DisplayType128
 .byt >DisplayType129
 .byt >DisplayType130
 .byt >DisplayType131
 .byt >DisplayType132
 .byt >DisplayType133
 .byt >DisplayType134
 .byt >DisplayType135
 .byt >DisplayType136

;128 peByte0 AND %11110000 displayed as Decimal
DisplayType128
	lda PatternCommandRange
	jmp AltPlotInversed2DD

;129 peByte1 displayed as decimal
DisplayType129
	lda PatternEntryByte1
	jmp AltPlotInversed3DD

;130 peByte1 displayed as ABCDEFGH
DisplayType130
	lda PatternEntryByte1
	;Exclude Track H
	sta Temp01
	ldx #0
.(
loop1	lsr Temp01
	bcc skip1
	txa
	adc #64+128
	sta (screen),y
	iny
skip1	inx
	cpx #7
	bcc loop1
.)
	rts

;131 peByte1 displayed as Hex
DisplayType131
	lda PatternEntryByte1
	jmp AltPlotInversed2DH

;132 eeByte0 AND %00000111 displayed as decimal
DisplayType132
	lda eeListByte0
dtRent1	and #7
	jmp AltPlotInversed1DD

;133 eeByte0 AND %00111000 displayed as decimal
DisplayType133
	lda eeListByte0
dtRent2	lsr
	lsr
	lsr
	jmp dtRent1

;134 eeByte0 AND %11000000 displayed as decimal
DisplayType134
	lda eeListByte0
	lsr
	lsr
	lsr
	jmp dtRent2	

;135 eeByte1 AND %00111111 displayed as SS Type
DisplayType135
	lda eeListByte1
	and #31
	tax
	lda SSTypeTextLo,x
.(
	sta vector1+1
	lda SSTypeTextHi,x
	sta vector1+2
	ldx #00
vector1	lda $dead,x
	pha
	ora #128
	sta (screen),y
	inx
	iny
	pla
	bpl vector1
.)
	rts
	
SSTypeTextLo
 .byt <SSTypeText0
 .byt <SSTypeText1
 .byt <SSTypeText2
 .byt <SSTypeText3
 .byt <SSTypeText4
 .byt <SSTypeText5
 .byt <SSTypeText6
 .byt <SSTypeText7
 .byt <SSTypeText8
 .byt <SSTypeText9
 .byt <SSTypeText10
 .byt <SSTypeText11
 .byt <SSTypeText12
 .byt <SSTypeText13
 .byt <SSTypeText14
 .byt <SSTypeText15
 .byt <SSTypeText16
 .byt <SSTypeText17
 .byt <SSTypeText18
 .byt <SSTypeText19
SSTypeTextHi
 .byt >SSTypeText0
 .byt >SSTypeText1
 .byt >SSTypeText2
 .byt >SSTypeText3
 .byt >SSTypeText4
 .byt >SSTypeText5
 .byt >SSTypeText6
 .byt >SSTypeText7
 .byt >SSTypeText8
 .byt >SSTypeText9
 .byt >SSTypeText10
 .byt >SSTypeText11
 .byt >SSTypeText12
 .byt >SSTypeText13
 .byt >SSTypeText14
 .byt >SSTypeText15
 .byt >SSTypeText16
 .byt >SSTypeText17
 .byt >SSTypeText18
 .byt >SSTypeText19

SSTypeText0
 .byt "CHP-A V-","A"+128
SSTypeText1
 .byt "CHP-B V-","B"+128
SSTypeText2
 .byt "CHP-C V-","C"+128
SSTypeText3
 .byt "CHP-A T-","A"+128
SSTypeText4
 .byt "CHP-B T-","B"+128
SSTypeText5
 .byt "CHP-C T-","C"+128
SSTypeText6
 .byt "EG E-","A"+128
SSTypeText7
 .byt "EG E-","B"+128
SSTypeText8
 .byt "EG E-A","B"+128
SSTypeText9
 .byt "EG E-","C"+128
SSTypeText10
 .byt "EG E-A","C"+128
SSTypeText11
 .byt "EG E-B","C"+128
SSTypeText12
 .byt "EG E-AB","C"+128
SSTypeText13
 .byt "NSE N-","A"+128
SSTypeText14
 .byt "NSE N-","B"+128
SSTypeText15
 .byt "NSE N-A","B"+128
SSTypeText16
 .byt "NSE N-","C"+128
SSTypeText17
 .byt "NSE N-A","C"+128
SSTypeText18
 .byt "NSE N-B","C"+128
SSTypeText19
 .byt "NSE N-AB","C"+128

;136 peByte1 AND %11111100 displayed as SFX Name
DisplayType136
	lda PatternEntrySFX
	;x8(16Bit)
	ldx #00
	stx source+1
	asl
	rol source+1
	asl
	rol source+1
	asl
	rol source+1
.(
	sta vector1+1
	lda source+1
	adc #>SFXNames
	sta vector1+2
	ldx #8
vector1	lda $dead
	ora #128
	sta (screen),y
	inc vector1+1
	iny
	dex
	bne vector1
.)
	rts

EmbeddedMessageLo
 .byt <EmbeddedMessage0
 .byt <EmbeddedMessage1
 .byt <EmbeddedMessage2
 .byt <EmbeddedMessage3
 .byt <EmbeddedMessage4
 .byt <EmbeddedMessage5
 .byt <EmbeddedMessage6
 .byt <EmbeddedMessage7
 .byt <EmbeddedMessage8
 .byt <EmbeddedMessage9
 .byt <EmbeddedMessage10
 .byt <EmbeddedMessage11
 .byt <EmbeddedMessage12
EmbeddedMessageHi
 .byt >EmbeddedMessage0
 .byt >EmbeddedMessage1
 .byt >EmbeddedMessage2
 .byt >EmbeddedMessage3
 .byt >EmbeddedMessage4
 .byt >EmbeddedMessage5
 .byt >EmbeddedMessage6
 .byt >EmbeddedMessage7
 .byt >EmbeddedMessage8
 .byt >EmbeddedMessage9
 .byt >EmbeddedMessage10
 .byt >EmbeddedMessage11
 .byt >EmbeddedMessage12

EmbeddedMessage0
 .byt "BEND AT RATE ",128," ON TRACKS ",130,0
EmbeddedMessage1
 .byt "TR-OUT WRITING ",131,0
EmbeddedMessage2
 .byt "TR-IN WAITING FOR ",131,0
EmbeddedMessage3
 .byt "TEMPO ",129,0
EmbeddedMessage4
 .byt "SET EG CYCLE ",128," ON TRACKS ",130,0
EmbeddedMessage5
 .byt "SET EG PERIOD HI ",128," AND LO ",131,0
EmbeddedMessage6
EmbeddedMessage8
 .byt "SPARE",0
EmbeddedMessage7
 .byt "REST",0
EmbeddedMessage9
 .byt "BAR",0
;For Mimic
EmbeddedMessage10
 .byt "MIMIC V(",132,"),P(",133,"),T(",134,"),",135,0
;For List SS Field
EmbeddedMessage11
 .byt "SOUND SOURCE(SS) - ",135,0
;For SFX Name
EmbeddedMessage12
 .byt "SFX ",34,136,34,0
