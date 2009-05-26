;;;;

;System Defines
#define	sys_IRQJump	$0244
#define	sys_IRQVectorLo	$0245
#define sys_IRQVectorHi	$0246
;Music Defines
#define	pcr_Disabled	$DD
#define	pcr_Register	$FF
#define	pcr_Value	$FD

#define	via_portb	$0300
#define via_t1cl	$0304
#define	via_pcr		$030C
#define	via_porta	$030F
;Effect Defines
#define	NoteC	0
#define	NoteD	2
#define	NoteE	4
#define	NoteF	5
#define	NoteG	7
#define	NoteA	9
#define	NoteB	11

#define	hEffectD 0
#define hEffectE	4
#define hEffectF 8
#define hEffectG 12
#define hEffectH 16
#define hEffectI 20
#define hEffectJ 24
#define hEffectK 28
#define hEffectL 32
#define hEffectM 36
#define hEffectN 40
#define hEffectO 44
#define hEffectP 48
#define hEffectQ 52
#define hEffectR 56
#define hEffectS 60
#define hEffectT 64
#define hEffectU 68
#define hEffectV 72

#define EG20	1
#define EG09    2

#define efx_End             	0
#define efx_ToneOn	        	1
#define efx_ToneOff         	2
#define efx_NoiseOn         	3
#define efx_NoiseOff        	4
#define efx_EnvelopeOn      	5
#define efx_EnvelopeOff     	6
#define efx_SetAbsoluteMode 	7
#define efx_IncPitch        	8
#define efx_DecPitch        	40
#define efx_IncNote         	72
#define efx_DecNote         	104
#define efx_SetRelativeMode 	136
#define efx_IncVolume       	137
#define efx_DecVolume       	138
#define efx_SkipZeroVolume  	139
#define efx_SkipZeroCount   	140
#define efx_Volume          	141
#define efx_SetEnvTriangle  	157
#define efx_SetEnvSawtooth  	158
#define efx_FilterFrequency 	159
#define efx_LoopRow 		163
#define efx_SetCounter 		185
#define efx_Pause 		205
#define	efx_SkipZeroPitch	255


_Music_data_start

;**** Generic Routine Tables and Variables go here *****
paTemp01	.byt 0
EventStart
 .byt 0		;Title Tune (Start Event 0) (ABC)
 .byt 10	;Reggae Track               (AB)
 .byt 11        ;Repeating Drum Pattern     (A)
 .byt 12	;Pool Music                 (AB)
 .byt 13	;Hifi Music                 (AB)
EventEnd
 .byt 10	;Title Tune (End on Event 10)
 .byt 11
 .byt 12
 .byt 13
 .byt 14
TrackProperty
 .byt 128+13	;Title Tune (Loop and tempo 13)
 .byt 128+16
 .byt 128+14
 .byt 128+30
 .byt 128+12
TrackChannels
 .byt 1+2+4
 .byt 2+4
 .byt 4
 .byt 2+4
 .byt 2+4
TracksChannelsUsed
 .byt 0



;************** Music Data Starts Here *****************

PatternRest
 .byt 0,0,0
Event_A_Pats    ;Event A Patterns
 ;     00  01  02  03  04  05  06  07  08  09  10  11  12  13
 .byt $00,$01,$02,$03,$04,$05,$06,$03,$04,$07,$04,$04,$06,$03
Event_A_NOFS	;Event A Note Offsets
 .byt $40,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34
Event_B_Pats	;Event B Patterns
 .byt $00,$01,$02,$03,$04,$05,$06,$03,$04,$07,$03,$80,$04,$04	;$80 is pattern rest
Event_B_NOFS	;Event B Note Offsets
 .byt $40,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34
Event_C_Pats	;Event C Patterns
 .byt $00,$01,$02,$03,$04,$05,$06,$03,$04,$07,$80,$80,$80,$80
Event_C_NOFS    ;Event C Note Offsets
 .byt $40,$40,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34,$34

;Pattern Memory
Pattern2B60
 .byt $39,$0,$FE,$3,$3F,$0,$FE,$3,$3E,$0,$FE,$7,$BE,$0,$FE,$3,$38,$0
 .byt $FE,$1,$3A,$0,$BA,$0,$3C,$0,$FE,$9,$BC,$0,$FE,$1,$37,$0,$FE,$B
 .byt $3C,$0,$FE,$2,$BC,$0,$3C,$0,$FE,$1,$BC,$0,$FE,$4,$F8,$0,$FE,$4,$FF
Pattern2B97
 .byt $30,$0,$FE,$1,$B0,$0,$FE,$1,$30,$0,$FE,$1,$B0,$0,$FE,$1,$2E,$0
 .byt $FE,$1,$AE,$0,$FE,$1,$2E,$0,$FE,$1,$AE,$0,$FE,$1,$2D,$0,$FE,$1
 .byt $AD,$0,$FE,$1,$2D,$0,$FE,$1,$AD,$0,$FE,$1,$2C,$0,$FE,$1,$AC,$0
 .byt $FE,$1,$2C,$0,$FE,$1,$AC,$0,$FE,$1,$2B,$0,$FE,$C,$AB,$0,$FE,$5
 .byt $37,$0,$43,$0,$37,$0,$43,$0,$37,$0,$43,$0,$37,$0,$43,$0,$37,$0
 .byt $43,$0,$37,$0,$43,$0,$37,$0,$FF
Pattern2BFA
 .byt $FE,$3,$29,$11,$29,$11,$A9,$0,$29,$11,$FE,$1,$29,$11,$A9,$0,$FE,$9
 .byt $29,$11,$29,$11,$A9,$0,$29,$11,$FE,$1,$29,$11,$FE,$1,$A9,$0,$FE,$9
 .byt $29,$11,$A9,$0,$FE,$2,$29,$11,$A9,$0,$FE,$16,$FF
Pattern2C2B
 .byt $41,$22,$C1,$0,$79,$3,$30,$14,$3C,$14,$FE,$1,$30,$14,$B0,$0,$30
 .byt $14,$B0,$0,$79,$3,$30,$14,$3C,$14,$FE,$1,$30,$14,$B0,$0,$30,$14
 .byt $B0,$0,$79,$3,$30,$14,$3C,$14,$BC,$0,$30,$14,$B0,$0,$30,$14,$B0
 .byt $0,$30,$14,$B0,$0,$41,$22,$C1,$0,$30,$14,$30,$14,$41,$22,$C1,$0
 .byt $79,$3,$30,$14,$3C,$14,$FE,$1,$30,$14,$B0,$0,$30,$14,$B0,$0,$79
 .byt $3,$30,$14,$3C,$14,$FE,$1,$30,$14,$B0,$0,$41,$22,$C1,$0,$78,$3
 .byt $F8,$0,$78,$2,$F8,$0,$78,$3,$30,$14,$78,$2,$F8,$0,$FE,$2,$48,$0
 .byt $4B,$0,$4F,$0,$C3,$0,$FF
Pattern2CAA
 .byt $41,$22,$C1,$0,$79,$3,$30,$14,$3C,$14,$FE,$1,$30,$14,$B0,$0,$30
 .byt $14,$B0,$0,$79,$3,$30,$14,$3C,$14,$FE,$1,$30,$14,$B0,$0,$30,$14
 .byt $B0,$0,$79,$3,$30,$14,$3C,$14,$BC,$0,$30,$14,$B0,$0,$30,$14,$B0
 .byt $0,$30,$14,$B0,$0,$41,$22,$C1,$0,$30,$14,$30,$14,$41,$22,$C1,$0
 .byt $79,$3,$30,$14,$3C,$14,$FE,$1,$30,$14,$B0,$0,$30,$14,$B0,$0,$79
 .byt $3,$30,$14,$3C,$14,$FE,$1,$30,$14,$B0,$0,$30,$14,$B0,$0,$79,$3
 .byt $30,$14,$3C,$14,$BC,$0,$30,$14,$B0,$0,$30,$14,$B0,$0,$30,$14,$B0
 .byt $0,$41,$22,$C1,$0,$30,$14,$B0,$0,$FF
Pattern2D2B
 .byt $2B,$11,$FE,$F,$2B,$11,$FE,$F,$41,$22,$C1,$0,$79,$3,$30,$14,$3C
 .byt $14,$FE,$1,$30,$14,$B0,$0,$30,$14,$B0,$0,$79,$3,$30,$14,$3C,$14
 .byt $FE,$1,$30,$14,$B0,$0,$30,$14,$B0,$0,$79,$3,$30,$14,$3C,$14,$BC
 .byt $0,$30,$14,$B0,$0,$30,$14,$B0,$0,$30,$14,$B0,$0,$41,$22,$C1,$0
 .byt $30,$14,$B0,$0,$FF
Pattern2D74
 .byt $2E,$11,$FE,$17,$2B,$11,$FE,$1,$2B,$11,$FE,$1,$2B,$11,$FE,$1,$2B
 .byt $11,$FE,$1,$2B,$11,$FE,$3,$BA,$A,$FE,$2,$BA,$0,$BE,$A,$FE,$1,$2B
 .byt $11,$FE,$1,$2B,$11,$FE,$1,$2B,$11,$FE,$1,$2B,$11,$FE,$3,$BC,$A,$FE
 .byt $2,$C0,$0,$C0,$A,$FE,$1,$2B,$11,$FE,$1,$2B,$11,$FE,$1,$2B,$11,$FE
 .byt $1,$FF
Pattern2DBD
 .byt $F8,$0,$FE,$23,$2B,$11,$FE,$1,$2B,$11,$FE,$1,$2B,$11,$FE,$B,$2B
 .byt $11,$FE,$1,$2B,$11,$FE,$1,$2B,$11,$FE,$3,$2B,$11,$35,$0,$39,$0
 .byt $3C,$0,$FF
Pattern8A
Pattern8B
Pattern8C
 .byt $F8,$0,$FE,63
 .byt $FF

Pattern2DE2
 .byt $23,$0,$FE,$1,$A3,$0,$FE,$1,$23,$0,$FE,$1,$A3,$0,$FE,$1,$22,$0
 .byt $FE,$1,$A2,$0,$FE,$1,$22,$0,$FE,$1,$A2,$0,$FE,$1,$27,$0,$FE,$1
 .byt $A7,$0,$FE,$1,$27,$0,$FE,$1,$A7,$0,$FE,$1,$25,$0,$FE,$1,$A5,$0
 .byt $FE,$1,$25,$0,$FE,$1,$A5,$0,$24,$0,$FE,$2,$A4,$0,$FE,$1,$24,$0
 .byt $A4,$0,$FE,$1,$24,$0,$27,$0,$FE,$1,$A7,$0,$FE,$1,$25,$0,$FE,$1
 .byt $A5,$0,$FE,$1,$24,$0,$FE,$1,$A4,$0,$FE,$1,$24,$0,$FE,$1,$A4,$0
 .byt $FE,$4,$F8,$0,$FE,$4,$FF
Pattern2E55
 .byt $3F,$0,$FE,$A,$3E,$0,$FE,$3,$41,$0,$41,$0,$FE,$9,$C1,$0,$3F,$0
 .byt $3E,$0,$FE,$1,$3C,$0,$FE,$1,$3E,$0,$FE,$F,$BE,$0,$FE,$2,$43,$0
 .byt $FE,$9,$C3,$0,$FE,$2,$FF
Pattern2E80
 .byt $FE,$3,$41,$0,$41,$0,$43,$0,$FE,$1,$40,$0,$FE,$8,$C0,$0,$FE,$2
 .byt $40,$0,$3F,$0,$BF,$0,$3E,$0,$BE,$0,$3D,$0,$FE,$7,$BD,$0,$FE,$2
 .byt $3D,$0,$3C,$0,$FE,$1,$3B,$0,$FE,$1,$3C,$0,$FE,$8,$BC,$0,$FE,$2
 .byt $3B,$0,$FE,$3,$3C,$0,$BC,$0,$FE,$1,$48,$0,$3C,$0,$FE,$1,$3E,$0
 .byt $FE,$1,$FF
Pattern2ECB
 .byt $24,$0,$A4,$0,$FE,$1,$22,$0,$1F,$0,$FE,$1,$22,$0,$A2,$0,$24,$0
 .byt $A4,$0,$22,$0,$FE,$1,$1F,$0,$FE,$1,$22,$0,$A2,$0,$20,$0,$FE,$1
 .byt $A0,$0,$FE,$1,$27,$0,$A7,$0,$FE,$1,$2C,$0,$AC,$0,$2C,$0,$AC,$0
 .byt $2C,$0,$27,$0,$A7,$0,$FE,$2,$24,$0,$A4,$0,$FE,$1,$22,$0,$1F,$0
 .byt $FE,$1,$22,$0,$A2,$0,$24,$0,$A4,$0,$22,$0,$FE,$1,$1F,$0,$FE,$1
 .byt $22,$0,$A2,$0,$20,$0,$FE,$1,$A0,$0,$FE,$1,$1F,$0,$FE,$1,$9F,$0
 .byt $FE,$1,$24,$0,$FE,$1,$A4,$0,$FE,$1,$3C,$35,$FE,$3,$FF
Pattern2F46
 .byt $24,$0,$A4,$0,$FE,$1,$22,$0,$1F,$0,$FE,$1,$22,$0,$A2,$0,$24,$0
 .byt $A4,$0,$22,$0,$FE,$1,$1F,$0,$FE,$1,$22,$0,$A2,$0,$20,$0,$FE,$1
 .byt $A0,$0,$FE,$1,$27,$0,$A7,$0,$FE,$1,$2C,$0,$AC,$0,$2C,$0,$AC,$0
 .byt $2C,$0,$27,$0,$A7,$0,$FE,$2,$24,$0,$A4,$0,$FE,$1,$22,$0,$1F,$0
 .byt $FE,$1,$22,$0,$A2,$0,$24,$0,$A4,$0,$22,$0,$FE,$1,$1F,$0,$FE,$1
 .byt $22,$0,$A2,$0,$24,$0,$A4,$0,$FE,$1,$22,$0,$1F,$0,$FE,$1,$22,$0
 .byt $A2,$0,$24,$0,$A4,$0,$22,$0,$FE,$1,$1F,$0,$FE,$1,$22,$0,$A2,$0,$FF
Pattern2FC5
 .byt $4A,$0,$FE,$3,$4F,$0,$FE,$9,$CF,$0,$FE,$9,$56,$0,$51,$0,$4D,$0
 .byt $4A,$0,$47,$0,$43,$0,$3B,$0,$35,$0,$24,$0,$A4,$0,$FE,$1,$22,$0
 .byt $1F,$0,$FE,$1,$22,$0,$A2,$0,$24,$0,$A4,$0,$22,$0,$FE,$1,$1F,$0
 .byt $FE,$1,$22,$0,$A2,$0,$24,$0,$A4,$0,$FE,$1,$22,$0,$1F,$0,$FE,$1
 .byt $22,$0,$A2,$0,$24,$0,$A4,$0,$22,$0,$FE,$1,$1F,$0,$FE,$1,$22,$0
 .byt $A2,$0,$FF
Pattern3022
 .byt $4B,$0,$FE,$1B,$4A,$0,$FE,$3,$4F,$0,$FE,$F,$4C,$0,$FE,$F,$FF
Pattern3033
 .byt $A9,$11,$FE,$1,$A9,$12,$FE,$1,$A9,$13,$FE,$1,$A9,$14,$FE,$1
 .byt $A9,$15,$FE,$1,$A9,$16,$FE,$1,$A9,$17,$FE,$1,$A9,$18,$FE,$1
 .byt $A9,$19,$FE,$1,$A9,$1A,$FE,$1,$A9,$1B,$FE,$1,$A9,$1C,$FE,$1
 .byt $A9,$1D,$FE,$1,$29,$11,$FE,$1,$29,$11,$29,$11,$29,$11,$29,$11
 .byt $3E,$0,$FE,$1B,$33,$0,$34,$0,$3B,$0,$3E,$0,$FF

Pattern3080
 .byt $39,$0,$FE,$9,$38,$0,$FE,$1,$37,$0,$B7,$0,$35,$0,$FE,$1,$37,$0
 .byt $FE,$8,$B7,$0,$FE,$1,$37,$0,$35,$0,$FE,$1,$33,$0,$FE,$1,$30,$0
 .byt $FE,$5,$B0,$0,$FE,$5,$37,$0,$FE,$3,$3C,$0,$FE,$2,$BC,$0,$3C,$0
 .byt $FE,$6,$F8,$0,$FE,$4,$FF
Pattern30BD
 .byt $4B,$0,$FE,$2,$46,$0,$4A,$0,$4B,$0,$4D,$0,$CD,$0,$4F,$0,$FE,$5
 .byt $CF,$0,$FE,$2,$43,$0,$FE,$1,$45,$0,$FE,$1,$46,$0,$FE,$1,$48,$0
 .byt $FE,$6,$C8,$0,$FE,$4,$3B,$0,$BB,$0,$3B,$0,$BB,$0,$3C,$0,$BC,$0
 .byt $3C,$0,$FE,$1,$BC,$0,$FE,$1,$3C,$0,$3C,$0,$3C,$0,$3B,$0,$BB,$0
 .byt $FE,$5,$37,$0,$3A,$0,$3B,$0,$3C,$0,$3E,$0,$40,$0,$41,$0,$44,$0
 .byt $50,$0,$FF
Pattern311A
 .byt $55,$0,$FE,$B,$54,$0,$FE,$3,$4E,$0,$FE,$B,$4F,$0,$FE,$3,$52,$0
 .byt $FE,$3,$2E,$0,$FE,$1,$AE,$0,$FE,$1,$2C,$0,$FE,$1,$AC,$0,$FE,$1
 .byt $50,$0,$FE,$3,$47,$0,$FE,$2,$2F,$0,$2F,$0,$FE,$2,$48,$0,$30,$0
 .byt $FE,$1,$B0,$0,$FE,$1,$48,$0,$C8,$0,$4A,$0,$FE,$1,$FF
Pattern315F
 .byt $39,$0,$FE,$A,$38,$0,$37,$0,$FE,$1,$35,$0,$FE,$1,$37,$0,$FE,$8
 .byt $B7,$0,$FE,$1,$37,$0,$35,$0,$FE,$1,$33,$0,$FE,$1,$3C,$0,$FE,$F
 .byt $BC,$0,$FE,$F,$FF
Pattern3188
 .byt $37,$0,$FE,$F,$38,$0,$FE,$B,$37,$0,$FE,$3,$3C,$0,$FE,$D,$BC,$0
 .byt $FE,$1,$3A,$0,$FE,$F,$FF
Pattern31A1
 .byt $46,$0,$FE,$F,$50,$0,$4D,$0,$4A,$0,$47,$0,$4D,$0,$4A,$0,$47,$0
 .byt $44,$0,$4A,$0,$47,$0,$44,$0,$41,$0,$47,$0,$44,$0,$41,$0,$3E,$0
 .byt $48,$4,$FE,$1,$3C,$4,$BC,$0,$48,$4,$C8,$0,$FE,$2,$48,$4,$C8,$0
 .byt $3C,$4,$BC,$0,$48,$4,$C8,$0,$FE,$2,$48,$4,$C8,$0,$3C,$4,$BC,$0
 .byt $48,$4,$C8,$0,$FE,$2,$48,$4,$FE,$1,$3C,$4,$BC,$0,$48,$4,$C8,$0
 .byt $FE,$2,$FF
Pattern31FE
 .byt $2F,$0,$FE,$7,$2E,$0,$FE,$7,$2D,$0,$FE,$7,$2C,$0,$FE,$7,$2B,$0
 .byt $FE,$F,$30,$0,$FE,$F,$FF
Pattern3217
 .byt $F8,$0,$A9,$11,$FE,$1,$A9,$12,$FE,$1,$A9,$13,$FE,$1,$A9,$14,$FE
 .byt $1,$A9,$15,$FE,$1,$A9,$16,$FE,$1,$A9,$17,$FE,$1,$A9,$18,$FE,$1
 .byt $A9,$19,$FE,$1,$A9,$1A,$FE,$1,$A9,$1B,$FE,$1,$A9,$1C,$FE,$1,$A9
 .byt $1D,$FE,$1,$29,$11,$FE,$1,$29,$11,$29,$11,$29,$11,$32,$0,$FE,$F
 .byt $31,$0,$FE,$7,$30,$0,$FE,$7,$FF

OrnamentAddressTableLo
 .byt <Ornament0
 .byt <Ornament1
 .byt <Ornament2
 .byt <Ornament3
OrnamentAddressTableHi
 .byt >Ornament0
 .byt >Ornament1
 .byt >Ornament2
 .byt >Ornament3

OrnamentData
Ornament0	;Repeat
 .byt $01,$05,$01,$07,$03	;$03 is flag to loop to start
Ornament1
 .byt $01,$0E,$16,$22,$32,$3E,$4A,$62,$6E,$76,$82,$8E,$00
Ornament2
 .byt $01,$0E,$16,$22,$32,$3E,$4A,$62,$6E,$76,$82,$8E,$FE,$00
Ornament3
 .byt $01,$01,$04,$04,$0C,$0C,$14,$14,$20,$20,$30,$30,$30,$3C,$3C,$3C	;3
 .byt $44,$44,$44,$50,$50,$50,$60,$60,$60,$6C,$6C,$6C,$74,$74,$74,$00

SampleAddressTableLo
 .byt <Sample0
 .byt <Sample1
 .byt <Sample2
 .byt <Sample3
 .byt <Sample4
 .byt <Sample5
SampleAddressTableHi
 .byt >Sample0
 .byt >Sample1
 .byt >Sample2
 .byt >Sample3
 .byt >Sample4
 .byt >Sample5

SampleData
Sample0
 .byt $1E,$0D,$00
Sample1
 .byt $0B,$0C,$0B,$0A,$0A,$09,$09,$08,$08,$07,$07,$06,$06,$05,$05,$04	;1
 .byt $04,$04,$00
Sample2
 .byt $1F,$2E,$1E,$2D,$1D,$2C,$1C,$2B,$1B,$2A,$1A,$29,$19,$28,$18,$27	;2
 .byt $17,$26,$16,$25,$15,$24,$14,$23,$13,$22,$12,$21,$11,$10,$00
Sample3
 .byt $0F,$17,$14,$01,$10,$00
Sample4
 .byt $0F,$0E,$0D,$0C,$0B,$09,$07,$05,$03,$01,$10,$00
Sample5
 .byt $0F,$0F,$0E,$0E,$0D,$0D,$0C,$0C,$0B,$0B,$0A,$0A,$09,$09,$08,$08	;5
 .byt $07,$07,$06,$06,$05,$05,$04,$04,$03,$03,$02,$02,$01,$01,$10,$00

Table33A4	;Pattern Address Table A Lo
 .byt <Pattern2DBD
 .byt <Pattern2D74
 .byt <Pattern2D2B
 .byt <Pattern2CAA
 .byt <Pattern2C2B
 .byt <Pattern2BFA
 .byt <Pattern2B97
 .byt <Pattern2B60
Table33AC	;Pattern Address Table A Hi
 .byt >Pattern2DBD
 .byt >Pattern2D74
 .byt >Pattern2D2B
 .byt >Pattern2CAA
 .byt >Pattern2C2B
 .byt >Pattern2BFA
 .byt >Pattern2B97
 .byt >Pattern2B60
Table33B4	;Pattern Address Table B Lo
 .byt <Pattern3033
 .byt <Pattern3022
 .byt <Pattern2FC5
 .byt <Pattern2F46
 .byt <Pattern2ECB
 .byt <Pattern2E80
 .byt <Pattern2E55
 .byt <Pattern2DE2
Table33BC	;Pattern Address Table B Hi
 .byt >Pattern3033
 .byt >Pattern3022
 .byt >Pattern2FC5
 .byt >Pattern2F46
 .byt >Pattern2ECB
 .byt >Pattern2E80
 .byt >Pattern2E55
 .byt >Pattern2DE2
Table33C4	;Pattern Address Table C Lo
 .byt <Pattern3217
 .byt <Pattern31FE
 .byt <Pattern31A1
 .byt <Pattern3188
 .byt <Pattern315F
 .byt <Pattern311A
 .byt <Pattern30BD
 .byt <Pattern3080
Table33CC	;Pattern Address Table C Hi
 .byt >Pattern3217
 .byt >Pattern31FE
 .byt >Pattern31A1
 .byt >Pattern3188
 .byt >Pattern315F
 .byt >Pattern311A
 .byt >Pattern30BD
 .byt >Pattern3080

RegisterBank
AY_PitchLo
 .byt 0
 .byt 0
 .byt 0
AY_PitchHi
 .byt 0
 .byt 0
 .byt 0
AY_Noise
 .byt 0
AY_Status
 .byt $78
AY_Volume
 .byt 0
 .byt 0
 .byt 0
AY_EGPeriodLo	.byt 0
AY_EGPeriodHi	.byt 0
AY_EGCycle	.byt 0
RegisterPointer
 .byt 0,3
 .byt 1,4
 .byt 2,5
 .byt 6
 .byt 7
 .byt 8,9,10
 .byt 11,12
 .byt 13
ReferenceBank
 .byt 0,0,0,0,0,0
 .byt 0,0
 .byt 0,0,0
 .byt 0,0,0

BasePitchLo	;Base Note Pitches Lo
 .byt $EE,$16,$4C
 .byt $8E,$D8,$2E
 .byt $8E,$F6,$66
 .byt $E0,$60,$E8
BasePitchHi	;Base Note Pitches Hi
 .byt $0E,$0E,$0D
 .byt $0C,$0B,$0B
 .byt $0A,$09,$09
 .byt $08,$08,$07
EventIndex		.byt 0
EndEvent		.byt 0
TrackLoop		.byt 0
MusicTempoReference	.byt 0
MusicStatus		.byt 0

SampleProperty
 .byt 128,128,128
SampleIndex
 .byt 0,0,0
OrnamentProperty
 .byt 128,128,128
OrnamentIndex
 .byt 0,0,0
RuntimePatternBaseLo
 .byt 0,0,0
RuntimePatternBaseHi
 .byt 0,0,0
RuntimePatternIndex
 .byt 0,0,0
RuntimePatternNoteOffset
 .byt 0,0,0
RuntimeNote
 .byt 0,0,0
EndOfMusic

;************************ Effect Data starts here **********************


Channel_SFX_NoteHeaders
 .byt NoteG+12*7    ;A  00
 .byt NoteC+12*1    ;   01
 .byt NoteC+12*2    ;   02
 .byt NoteC+12*6    ;   03
 .byt NoteC+12*3    ;   04
 .byt NoteF+12*3    ;   05
 .byt NoteC+12*1    ;   06
 .byt NoteD+12*2    ;   07
 .byt NoteG+12*3    ;   08

 .byt NoteC+12*6    ;B  09
 .byt NoteF+12*6    ;   10
 .byt NoteC+12*3    ;   11
 .byt NoteC+12*4    ;   12
 .byt NoteC+12*4    ;   13
 .byt NoteF+12*7    ;   14
 .byt NoteG+12*3    ;   15
 .byt NoteG+12*7    ;   16

 .byt NoteC+12*5    ;C  17
 .byt NoteC+12*7    ;   18
 .byt NoteC+12*5    ;   19
 .byt NoteG+12*7    ;   20
 .byt NoteG+12*7    ;   21
 .byt NoteG+12*3    ;   22

Channel_SFX_EffectAndEGHeaders
 .byt hEffectV		 ;A  00  Switch
 .byt hEffectU           ;   01 Door Opening/Closing
 .byt hEffectT           ;   02 Pick up
 .byt hEffectS           ;   03 Drop
 .byt hEffectR           ;   04 Step #1
 .byt hEffectR           ;   05 Step #2
 .byt hEffectH+EG20      ;   06 Lift Start
 .byt hEffectG+EG20      ;   07 Lift End
 .byt hEffectE+EG09      ;   08 Alarm #1

 .byt hEffectQ           ;B  09 Effect #1 (InfoPost)
 .byt hEffectP           ;   10 New Msg through Commlink
 .byt hEffectO           ;   11 Effect #2 (InfoPost)
 .byt hEffectN           ;   12 Computer Room #1
 .byt hEffectM           ;   13 Computer Room #2
 .byt hEffectP           ;   14 Beep for Info Messages in Text Area
 .byt hEffectE+EG20      ;   15 -
 .byt hEffectD+EG20      ;   16 Alarm #2

 .byt hEffectL           ;C  17 Alarm #3
 .byt hEffectL           ;   18 Alarm #4 (Low Power of 17)
 .byt hEffectK           ;   19 Alarm #5 (Receding low power)
 .byt hEffectJ           ;   20 Alarm #6
 .byt hEffectI           ;   21 Alarm #6 End
 .byt hEffectF           ;   22 -

;Nice effect of mixing Effect 0F on A whilst playing Track 02 on A
;Effects(19)

EffectBaseAddressLo
 .byt <EffectD
 .byt <EffectE
 .byt <EffectF
 .byt <EffectG
 .byt <EffectH
 .byt <EffectI
 .byt <EffectJ
 .byt <EffectK
 .byt <EffectL
 .byt <EffectM
 .byt <EffectN
 .byt <EffectO
 .byt <EffectP
 .byt <EffectQ
 .byt <EffectR
 .byt <EffectS
 .byt <EffectT
 .byt <EffectU
 .byt <EffectV
EffectBaseAddressHi
 .byt >EffectD
 .byt >EffectE
 .byt >EffectF
 .byt >EffectG
 .byt >EffectH
 .byt >EffectI
 .byt >EffectJ
 .byt >EffectK
 .byt >EffectL
 .byt >EffectM
 .byt >EffectN
 .byt >EffectO
 .byt >EffectP
 .byt >EffectQ
 .byt >EffectR
 .byt >EffectS
 .byt >EffectT
 .byt >EffectU
 .byt >EffectV

EffectD	;16
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOff
 .byt efx_Volume+6
 .byt efx_Pause+27
; .byt Pause9
; .byt Pause9
 .byt efx_EnvelopeOn
 .byt efx_Pause+18
; .byt Pause9
 .byt efx_EnvelopeOff
 .byt efx_Pause+7
 .byt efx_EnvelopeOn
 .byt efx_Pause+9
 .byt efx_EnvelopeOff
 .byt efx_Pause+36
; .byt Pause9
; .byt Pause9
; .byt Pause9
 .byt efx_EnvelopeOn
 .byt efx_Pause+18
; .byt Pause9
 .byt efx_LoopRow+13	;Row 2
EffectE	;16
 .byt efx_ToneOn
 .byt efx_EnvelopeOn
 .byt efx_NoiseOff
 .byt efx_SetAbsoluteMode
 .byt efx_IncPitch+1
 .byt efx_Volume+0
 .byt efx_Pause+3
 .byt efx_DecPitch+2
 .byt efx_IncVolume
 .byt efx_SkipZeroVolume
 .byt efx_LoopRow+4	;To row 6
 .byt efx_Volume+12
 .byt efx_Pause+9
 .byt efx_IncPitch+31
 .byt efx_Pause+18
; .byt Pause9
 .byt efx_LoopRow+11	;To row 4
EffectF	;16
 .byt efx_ToneOn
 .byt efx_EnvelopeOff
 .byt efx_NoiseOff
 .byt efx_SetAbsoluteMode
 .byt efx_IncPitch+1
 .byt efx_Volume+0
 .byt efx_Pause+3
 .byt efx_DecPitch+2
 .byt efx_IncVolume
 .byt efx_SkipZeroVolume
 .byt efx_LoopRow+4	;6
 .byt efx_Volume+12
 .byt efx_Pause+9
 .byt efx_IncPitch+31
 .byt efx_Pause+18
; .byt Pause9
 .byt efx_LoopRow+11	;4
EffectG	;19
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOn
 .byt efx_SetEnvTriangle
 .byt efx_SetAbsoluteMode
 .byt efx_SetCounter+8
 .byt efx_Pause+9
 .byt efx_DecNote+2
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+3	;6
 .byt efx_EnvelopeOff
 .byt efx_Pause+18
; .byt Pause9
 .byt efx_Volume+13
 .byt efx_IncNote+31
 .byt efx_IncNote+24
 .byt efx_Pause+4
 .byt efx_DecVolume
 .byt efx_SkipZeroVolume
 .byt efx_LoopRow+3	;?16
 .byt efx_End
EffectH	;10
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOn
 .byt efx_SetEnvTriangle
 .byt efx_SetAbsoluteMode
 .byt efx_SetCounter+8
 .byt efx_Pause+4
 .byt efx_IncNote+2
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+3	;6
 .byt efx_End
EffectI	;11
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOff
 .byt efx_Volume+15
 .byt efx_Pause+4
 .byt efx_Volume+0
 .byt efx_Pause+7
 .byt efx_Volume+9
 .byt efx_Pause+5
 .byt efx_Volume+0
 .byt efx_End
EffectJ	;8
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOff
 .byt efx_Volume+15
 .byt efx_Pause+4
 .byt efx_Volume+0
 .byt efx_Pause+7
 .byt efx_LoopRow+4	;3
EffectK	;19
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOff
 .byt efx_Volume+7
 .byt efx_SetAbsoluteMode
 .byt efx_SetCounter+8
 .byt efx_Pause+3
 .byt efx_DecPitch+3
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+3	;6
 .byt efx_SetCounter+8
 .byt efx_Pause+3
 .byt efx_IncPitch+4
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+3	;11
 .byt efx_SkipZeroPitch
 .byt efx_LoopRow+11	;5
 .byt efx_Volume+0
 .byt efx_End
EffectL	;16
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOff
 .byt efx_Volume+7
 .byt efx_SetAbsoluteMode
 .byt efx_SetCounter+8
 .byt efx_Pause+2
 .byt efx_DecPitch+4
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+3	;6
 .byt efx_SetCounter+8
 .byt efx_Pause+2
 .byt efx_IncPitch+4
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+3	;11
 .byt efx_LoopRow+10	;5
EffectM	;9
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOff
 .byt efx_Volume+7
 .byt efx_SetAbsoluteMode
 .byt efx_FilterFrequency+2
 .byt efx_Pause+3
 .byt efx_DecNote+26
 .byt efx_LoopRow+2	;6
EffectN	;9
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOff
 .byt efx_Volume+7
 .byt efx_SetAbsoluteMode
 .byt efx_FilterFrequency+2
 .byt efx_Pause+1
 .byt efx_DecNote+27
 .byt efx_LoopRow+2	;+6
EffectO	;11
 .byt efx_ToneOn
 .byt efx_NoiseOn
 .byt efx_EnvelopeOff
 .byt efx_Volume+15
 .byt efx_Pause+1
 .byt efx_NoiseOff
 .byt efx_DecVolume
 .byt efx_Pause+3
 .byt efx_SkipZeroVolume
 .byt efx_LoopRow+3	;6
 .byt efx_End
EffectP	;11
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOff
 .byt efx_SetCounter+3
 .byt efx_Volume+15
 .byt efx_Pause+9
 .byt efx_Volume+0
 .byt efx_Pause+9
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+5	;4
 .byt efx_End
EffectQ	;9
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOff
 .byt efx_Volume+15
 .byt efx_Pause+6
 .byt efx_DecNote+9
 .byt efx_Pause+9
 .byt efx_Volume+0
 .byt efx_End
EffectR	;8
 .byt efx_NoiseOn
 .byt efx_ToneOn
 .byt efx_EnvelopeOff
 .byt efx_Volume+12
; .byt efx_SetAbsoluteMode
 .byt efx_Pause+0
 .byt efx_Volume+0
 .byt efx_End
EffectS	;13
 .byt efx_NoiseOff
 .byt efx_ToneOn
 .byt efx_EnvelopeOff
 .byt efx_Volume+10
 .byt efx_SetCounter+4
 .byt efx_SetAbsoluteMode
 .byt efx_DecNote+10
 .byt efx_Pause+3
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+3	;6
 .byt efx_Pause+1
 .byt efx_Volume+0
 .byt efx_End
EffectT	;13
 .byt efx_NoiseOff
 .byt efx_ToneOn
 .byt efx_EnvelopeOff
 .byt efx_Volume+10
 .byt efx_SetCounter+4
 .byt efx_SetAbsoluteMode
 .byt efx_IncNote+10
 .byt efx_Pause+3
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+3	;6
 .byt efx_Pause+1
 .byt efx_Volume+0
 .byt efx_End
EffectU	;14
 .byt efx_NoiseOn
 .byt efx_ToneOff
 .byt efx_EnvelopeOff
 .byt efx_Volume+0
 .byt efx_SetCounter+8
 .byt efx_Pause+2
 .byt efx_IncVolume
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+3	;5
 .byt efx_Volume+0
; .byt efx_Pause+1
; .byt efx_DecVolume
; .byt efx_SkipZeroVolume
; .byt efx_LoopRow+3	;9
 .byt efx_End
EffectV	;15
 .byt efx_NoiseOff
 .byt efx_EnvelopeOff
 .byt efx_ToneOn
 .byt efx_Volume+15
 .byt efx_Pause+1
 .byt efx_Volume+12
 .byt efx_Pause+1
 .byt efx_Volume+9
 .byt efx_Pause+1
 .byt efx_Volume+6
 .byt efx_Pause+1
 .byt efx_Volume+3
 .byt efx_Pause+1
 .byt efx_Volume+0
 .byt efx_End
;All Effects == 243 Bytes

ToneMask
 .byt %11111110,%11111101,%11111011
ToneBit
 .byt %00000001,%00000010,%00000100
NoiseMask
 .byt %11110111,%11101111,%11011111
NoiseBit
 .byt %00001000,%00010000,%00100000
AbsoluteMode
 .byt 0,0,0
EffectCounter
 .byt 0,0,0
PauseDelay
 .byt 0,0,0
EffectPitchLo
 .byt 0,0,0
EffectPitchHi
 .byt 0,0,0
EffectNote
 .byt 0,0,0
EffectIndex
 .byt 0,0,0
EffectNumber
 .byt 128,128,128
SkipLoopFlag
 .byt 0,0,0
PitchOffset
NoteOffset	.byt 0
TempPitchLo	.byt 0
TempPitchHi	.byt 0
EGValue
 .byt 20,9,0
EffectCodeThreshhold
 .byt 000	;00
 .byt 001       ;01
 .byt 002       ;02
 .byt 003       ;03
 .byt 004       ;04
 .byt 005       ;05
 .byt 006       ;06
 .byt 007       ;07
 .byt 008       ;08
 .byt 040       ;09
 .byt 072       ;10
 .byt 104       ;11
 .byt 136       ;12
 .byt 137       ;13
 .byt 138       ;14
 .byt 139       ;15
 .byt 140       ;16
 .byt 141       ;17
 .byt 157       ;18
 .byt 158       ;19
 .byt 159       ;20
 .byt 163       ;21
 .byt 185       ;22
 .byt 205       ;23
 .byt 255       ;24
/*EffectCodeVectorLo
 .byt <efxc_End
 .byt <efxc_ToneOn
 .byt <efxc_ToneOff
 .byt <efxc_NoiseOn
 .byt <efxc_NoiseOff
 .byt <efxc_EnvelopeOn
 .byt <efxc_EnvelopeOff
 .byt <efxc_SetAbsoluteMode
 .byt <efxc_IncPitch
 .byt <efxc_DecPitch
 .byt <efxc_IncNote
 .byt <efxc_DecNote
 .byt <efxc_SetRelativeMode
 .byt <efxc_IncVolume
 .byt <efxc_DecVolume
 .byt <efxc_SkipZeroVolume
 .byt <efxc_SkipZeroCount
 .byt <efxc_Volume
 .byt <efxc_SetEnvTriangle
 .byt <efxc_SetEnvSawtooth
 .byt <efxc_FilterFrequency
 .byt <efxc_LoopRow
 .byt <efxc_SetCounter
 .byt <efxc_Pause
 .byt <efxc_SkipZeroPitch
EffectCodeVectorHi
 .byt >efxc_End
 .byt >efxc_ToneOn
 .byt >efxc_ToneOff
 .byt >efxc_NoiseOn
 .byt >efxc_NoiseOff
 .byt >efxc_EnvelopeOn
 .byt >efxc_EnvelopeOff
 .byt >efxc_SetAbsoluteMode
 .byt >efxc_IncPitch
 .byt >efxc_DecPitch
 .byt >efxc_IncNote
 .byt >efxc_DecNote
 .byt >efxc_SetRelativeMode
 .byt >efxc_IncVolume
 .byt >efxc_DecVolume
 .byt >efxc_SkipZeroVolume
 .byt >efxc_SkipZeroCount
 .byt >efxc_Volume
 .byt >efxc_SetEnvTriangle
 .byt >efxc_SetEnvSawtooth
 .byt >efxc_FilterFrequency
 .byt >efxc_LoopRow
 .byt >efxc_SetCounter
 .byt >efxc_Pause
 .byt >efxc_SkipZeroPitch*/
FilterIndex
 .byt 0,0,0
FilterMask
 .byt 7         ;1
 .byt 15        ;2
 .byt 31        ;3
 .byt 127       ;4
EndOfAll

_Music_data_end


#echo Available music size :
#print (_Music_data_end - _Music_data_start)
#echo



