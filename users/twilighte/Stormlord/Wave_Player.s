;Wave_Player.s - Play Compiled tune
#define	VIA_PORTB		$0300
#define	VIA_PCR		$030C
#define	VIA_PORTA		$030F

#define	SYS_IRQPATCH	$24A

#define	MUSICTRIGGERLOC	$BFE0



;+00 Wave Version ID(00)
;+01 Music Tempo
;+02-03 Offset to Pattern Address Table
;+04-05 Offset to Effect Address Table
;+06-07 Offset to Ornament Address Table
;+08-09 Offset to Sample Address Table
;+0A List Loop Position, List
;+?? Pattern Address Table (lo,hi,lo)
;+?? Patterns
;     000-005	Sample(6)
;     006-068	EGPeriod(63)
;     069-071	Cycle(3)
;     072-102	Noise(31)
;     103-164	Note(62)
;     165-165	Rest(1)
;     166-166	Bar(1)
;     167-170	Volume(4)
;     171-185	Effect(15)
;     186-200	Ornament(15)
;     201-207	Command(7)
;     208-239	Parameter(31)
;     240-240	Long Row Rest(Second byte holds period)
;     241-255	Short Row Rest(15)
;If a row contains at least 1 change then all three channel rests are written
;+?? Effect Address Table (lo,hi,lo)
;+?? Loop Position, Effect,
;
;+?? Ornament Address Table (lo,hi,lo)
;+?? Loop Position, Ornaments,
;+?? Sample Address Table (lo,hi,llo,lhi,pro)
;+?? Samples
;PageAlligning
; .dsb 256-(*&255)
;Ensure this is kept page alligned

InitMusic	lda #<Stormlord_Music
	sta header
	lda #>Stormlord_Music
	sta header+1
	lda #11
	sta ListIndex
	
	;Set up pat
	ldy #2
	lda (header),y
	clc
	adc header
	sta pat
	iny
	lda (header),y
	adc header+1
	sta pat+1
	
	;Set up eat
	ldy #4
	lda (header),y
	clc
	adc header
	sta eat
	iny
	lda (header),y
	adc header+1
	sta eat+1
	
	;Set up oat
	ldy #6
	lda (header),y
	clc
	adc header
	sta oat
	iny
	lda (header),y
	adc header+1
	sta oat+1
	
	jsr ProcList
	
	lda #%11000000
	sta MusicActivity
	
	;Set up Music Tempo as 1 so that first irq call pattern
	lda #01
	sta MusicTempoCount
	
	lda #8
	sta ayw_Volume+2
	
	cli	
	rts
	
MusicIRQ
	jsr ProcMusic

SendAY	;Control Option_Sound
	ldx #13
.(
loop1	lda ayw_Bank,x

	ldy ayVolumeFlag,x
	beq skip2
	ldy Option_Sound
	beq skip2
	dey
	bne skip3
	and #15
	sbc #6
	bcs skip2
skip3	lda #00
skip2	cmp ayr_Bank,x
	beq skip1
	sta ayr_Bank,x
	ldy ayRealRegister,x
	sty VIA_PORTA
	ldy #$FF
	sty VIA_PCR
	ldy #$DD
	sty VIA_PCR
	sta VIA_PORTA
	lda #$FD
	sta VIA_PCR
	sty VIA_PCR
skip1	dex
	bpl loop1
.)
	rts

ayVolumeFlag
 .byt 0,0,0,0,0,0,0,0,1,1,1,0,0,0


ProcMusic
	dec MusicTempoCount
	bne ProcSound
	lda #12	;MusicTempoRef
	sta MusicTempoCount

	jsr ProcPattern

ProcSound
	ldx #2
.(
loop1	lda MusicActivity
	and NoiseBit,x	;B3 B4 B5
	cmp #1
	lda PatternNote,x
	bcc skip1
	
	;ProcOrnament
	ldy OrnamentID,x
	lda header
	clc
	adc (oat),y
	sta ornament
	lda header+1
	iny
	adc (oat),y
	sta ornament+1
loop2	ldy OrnamentIndex,x
	lda (ornament),y
	bne skip2
	ldy #00
	lda (ornament),y
	bmi skip6
	sta OrnamentIndex,x
	jmp loop2
skip6	lda MusicActivity
	and NoiseMask,x
	sta MusicActivity
	lda #00
skip2	clc
	adc PatternNote,x
	and #127
	inc OrnamentIndex,x

	;Convert to Pitch
skip1	tay
	lda PitchTableLo,y
	sta IntermediatePitchLo
	lda PitchTableHi,y
	sta IntermediatePitchHi

	;Check Effect
	lda MusicActivity
	and EffectBit,x
	beq skip3
	
	;Process Effect
	ldy EffectID,x
	lda header
	clc
	adc (eat),y
	sta effect
	lda header+1
	iny
	adc (eat),y
	sta effect+1
	ldy EffectIndex,x
loop3	lda (effect),y
	and #%11100000
	lsr
	sta vector1+1
	lda (effect),y
	iny
	and #31
	adc #255-15
	sec
vector1	jsr pmeLoopOrEnd
	bcs loop3
	tya
	sta EffectIndex,x

skip3	;Transfer Intermediate Pitch to AY Registers
	lda IntermediatePitchLo
	sta ayw_PitchLo,x
	lda IntermediatePitchHi
	sta ayw_PitchHi,x
	
	;Progress to next Effect/Ornament
	dex
	bmi skip4
	jmp loop1
skip4	rts
.)



ProcPattern
	lda PatternRestCount
.(
	beq skip4
	dec PatternRestCount
	jmp skip3

skip4	lda #00
	sta BarFlag
	sta ChannelID
	;We don't want any new note to adopt the previous effect/ornament if not specified
	sta NewActivity
;	;Reset Music Activity for ornaments and Effects
;	lda MusicActivity
;	and #%11000000
;	sta MusicActivity
	ldy #00
	lda (pattern),y
	cmp #166
	bne loop1
	jsr ProcList
loop1	ldy #00
	lda (pattern),y
	inc pattern
	bne skip2
	inc pattern+1
skip2	ldx #12
loop2	cmp PatternRangeThreshhold-1,x
	bcs skip1
	dex
	bne loop2
	sec
skip1	sbc PatternRangeThreshhold-1,x
	ldy PatternRangeCommandLo,x
	sty vector1+1
	ldy PatternRangeCommandHi,x
	sty vector1+2
	clc
vector1	jsr $dead
	bcc loop1

skip3	dec PatternRow
.)
	bne AvoidList
	
ProcList	;Get next List PatternID
	ldy ListIndex	;Offset by $0B
	cpy #36
.(
	bcc skip1
	ldy #11
	sty ListIndex
skip1
.)
ProcList2	ldy ListIndex
	lda (header),y
	
	;Calculate address of Pattern
	asl
	tay
	lda header
	adc (pat),y
	sta pattern
	lda header+1
	iny
	adc (pat),y
	sta pattern+1
	
	;Progress List Index
	inc ListIndex
	
	;Reset Pattern Stuff
	lda #64
	sta PatternRow
	lda #00
	sta PatternRestCount

AvoidList	rts

PatternRangeThreshhold
;The above loop searches and exits on 0 defaulting to Sample so we can save
;a massive one byte here!
; .byt 0	;00 prcSample      
 .byt 6   ;06 01 prcEGPeriod    
 .byt 69  ;45 02 prcCycle       
 .byt 72  ;48 03 prcNoise       
 .byt 103 ;67 04 prcNote        
 .byt 165 ;A5 05 prcRest        
 .byt 166 ;A6 06 prcBar         
 .byt 167 ;A7 07 prcVolume      
 .byt 171 ;AB 08 prcEffect      
 .byt 186 ;BA 09 prcOrnament    
 .byt 201 ;C9 10 prcCommand     
 .byt 208 ;D0 11 prcLongRowRest 
 .byt 209 ;D1 12 prcShortRowRest

PatternRangeCommandLo
 .byt <prcSample
 .byt <prcEGPeriod
 .byt <prcCycle
 .byt <prcNoise
 .byt <prcNote
 .byt <prcRest
 .byt <prcBar
 .byt <prcVolume
 .byt <prcEffect
 .byt <prcOrnament
 .byt <prcCommand
 .byt <prcLongRowRest	;(Second byte holds period)
 .byt <prcShortRowRest



prcCycle	tax
	lda CycleCode,x
	sta ayw_Cycle
	lda #128
	sta ayr_Cycle
	rts


prcNote	ldx ChannelID
	adc #11
	sta PatternNote,x
	;If Note specified always default to Noise Off, Tone On
	lda ayw_Status
	and ToneMask,x
	ora NoiseBit,x
	sta ayw_Status
	inc ChannelID
	lda ChannelID
	cmp #3	;If end of Row then indicate with Carry
	;If effect/Ornament not set and note then reset in musicactivity	
	lda NewActivity
	and EffectBit,x
	beq NoteDisableEffect 
	lda NewActivity
	and OrnamentBit,x
	beq NoteDisableOrnament
	rts

prcRest	ldx ChannelID
	inx
	stx ChannelID
	cpx #3
	rts

NoteDisableEffect
	lda MusicActivity
	and ToneMask,x
	sta MusicActivity
	;If no effect (And EG not set) ensure Pattern Volume gets into AY
	lda EGActiveFlag,x
.(
	bne skip1
	lda PatternVolume,x
	sta ayw_Volume,x
skip1	rts
.)

NoteDisableOrnament
	lda MusicActivity
	and NoiseMask,x
	sta MusicActivity
	rts


prcVolume
	tax
	lda RealVolume,x
	ldx ChannelID
	sta PatternVolume,x
	rts

prcEffect
	ldx ChannelID
	;Shift left so it can directly index eat
	asl
	sta EffectID,x
	lda #01
	sta EffectIndex,x
	lda NewActivity
	ora ToneBit,x
	sta NewActivity
	lda MusicActivity
	ora ToneBit,x
	sta MusicActivity
	rts
	
prcOrnament
	ldx ChannelID
	;Shift left so it can directly index oat
	asl
	sta OrnamentID,x
	lda #01
	sta OrnamentIndex,x
	lda NewActivity
	ora NoiseBit,x
	sta NewActivity
	lda MusicActivity
	ora NoiseBit,x
	sta MusicActivity
	rts

prcCommand
	tax
	ldy #00
	lda (pattern),y
	inc pattern
.(
	bne skip1
	inc pattern+1
skip1	ldy CommandVectorLo,x
.)
	sty vector1+1
	ldy CommandVectorHi,x
	sty vector1+2
vector1	jmp $DEAD


prcLongRowRest	;(Second byte holds period)
	ldy #00
	lda (pattern),y
	inc pattern
	bne prcShortRowRest
	inc pattern+1
prcShortRowRest
	sta PatternRestCount
	sec
	rts

CommandVectorLo
 .byt <prcCom_Tempo
 .byt <prcCom_TriggerOut
 .byt <prcCom_Pitchbend
 .byt <prcCom_SlideUp
 .byt <prcCom_SlideDown
 .byt <prcCom_SampleType
 .byt <prcCom_CopyLeftSibling

CommandVectorHi
 .byt >prcCom_Tempo
 .byt >prcCom_TriggerOut
 .byt >prcCom_Pitchbend
 .byt >prcCom_SlideUp
 .byt >prcCom_SlideDown
 .byt >prcCom_SampleType
 .byt >prcCom_CopyLeftSibling


	
prcCom_TriggerOut
	sta MUSICTRIGGERLOC
	rts

ayw_Bank
ayw_PitchLo	.byt 0,0,0
ayw_PitchHi	.byt 0,0,0
ayw_Noise		.byt 0
ayw_Status	.byt %01111000
ayw_Volume	.byt 0,0,0
ayw_EGPeriod	.byt 0,0
ayw_Cycle		.byt 0

BarFlag		.byt 0
Temp01		.byt 0

;Page alligned stuff was here but its been moved to start of driver.s
CycleCode
 .byt 8,10,0
OrnamentMask
NoiseMask
 .byt %11110111
 .byt %11101111
 .byt %11011111
OrnamentID
 .dsb 3,0
OrnamentIndex
 .dsb 3,0
RealVolume
 .byt 0,4,8,15
EGActiveFlag
 .byt 0,0,0
IntermediatePitchLo	.byt 0
IntermediatePitchHi	.byt 0
;The following Commands are not supported
prcSample
prcCom_Pitchbend
prcCom_SlideUp
prcCom_SlideDown
prcCom_SampleType
prcCom_CopyLeftSibling
	rts
PatternRangeCommandHi
 .byt >prcSample
 .byt >prcEGPeriod
 .byt >prcCycle
 .byt >prcNoise
 .byt >prcNote
 .byt >prcRest
 .byt >prcBar
 .byt >prcVolume
 .byt >prcEffect
 .byt >prcOrnament
 .byt >prcCommand
 .byt >prcLongRowRest	;(Second byte holds period)
 .byt >prcShortRowRest

PitchTableLo
 .byt <3822,<3606,<3404,<3214,<3032,<2862,<2702,<2550,<2406,<2272,<2144,<2024
 .byt <1911,<1803,<1702,<1607,<1516,<1431,<1351,<1275,<1203,<1136,<1072,<1012
 .byt <955,<901,<851,<803,<758,<715,<675,<637,<601,<568,<536,<506
 .byt <477,<450,<425,<401,<379,<357,<337,<318,<300,<284,<268,<253
 .byt <238,<225,<212,<200,<189,<178,<168,<159,<150,<142,<134,<126
 .byt <119,<112,<106,<100,<94,<89,<84,<79,<75,<71,<67,<63
 .byt <59,<56,<53,<50,<47,<44,<42,<39,<37,<35,<33,<31
 .byt <29,<28,<26,<25,<23,<22,<21,<19,<18,<17,<16,<15
 .byt <14,<14,<13,<12,<11,<11,<10,<9,<9,<8,<8,<7
 .byt 7,7,6,6,5,5,5,4,4,4,4,3
 .byt 3,3,3,3,2,2,2,2
PitchTableHi
 .byt >3822,>3606,>3404,>3214,>3032,>2862,>2702,>2550,>2406,>2272,>2144,>2024
 .byt >1911,>1803,>1702,>1607,>1516,>1431,>1351,>1275,>1203,>1136,>1072,>1012
 .byt >955,>901,>851,>803,>758,>715,>675,>637,>601,>568,>536,>506
 .byt >477,>450,>425,>401,>379,>357,>337,>318,>300,>284,>268,>253
 .byt >238,>225,>212,>200,>189,>178,>168,>159,>150,>142,>134,>126
 .byt >119,>112,>106,>100,>94,>89,>84,>79,>75,>71,>67,>63
 .byt >59,>56,>53,>50,>47,>44,>42,>39,>37,>35,>33,>31
 .byt >29,>28,>26,>25,>23,>22,>21,>19,>18,>17,>16,>15
 .byt >14,>14,>13,>12,>11,>11,>10,>9,>9,>8,>8,>7
 .byt 0,0,0,0,0,0,0,0,0,0,0,0
 .byt 0,0,0,0,0,0,0,0
EndOfPlayer
 .byt 0



