
	.text

_DescriptionBuffer 			.dsb 40

_ColumnOffsetBuffer			.dsb 40	

; This table needs to be aligned on an even address, or at least no element should overlap a page boundary
ScrollerJumpTable
	.word _ScrollerPhase1
	.word _ScrollerPhase2
	.word _ScrollerPhase3
	.word _ScrollerPhase4
	.word _ScrollerPhase5
	.word _ScrollerPhase6

ScrollerEffectJumpTable
	.word ScrollerEffectRestart
	.word ScrollerEffectDisplayTable
	.word ScrollerEffectSetColors
	.word ScrollerEffectSetColumnOffset
	.word ScrollerEffectSetFont
	.word ScrollerEffectDistortTable


ScrollerBuffer1 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer2		.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer3 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer4 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer5 	.dsb SCROLLER_BUFFER_WIDTH*16
ScrollerBuffer6 	.dsb SCROLLER_BUFFER_WIDTH*16

	
_FontBuffer					.dsb 3040

_PictureLoadBuffer			.dsb 8000


	.dsb 256-(*&255)
	
;
; All the stuff that needs to be aligned on a page boundary
;

; Non signed values, from 0 to 255
_BaseCosTable
	.byt	254
	.byt	253
	.byt	253
	.byt	253
	.byt	253
	.byt	253
	.byt	252
	.byt	252
	.byt	251
	.byt	250
	.byt	250
	.byt	249
	.byt	248
	.byt	247
	.byt	246
	.byt	245
	.byt	244
	.byt	243
	.byt	241
	.byt	240
	.byt	239
	.byt	237
	.byt	235
	.byt	234
	.byt	232
	.byt	230
	.byt	229
	.byt	227
	.byt	225
	.byt	223
	.byt	221
	.byt	218
	.byt	216
	.byt	214
	.byt	212
	.byt	209
	.byt	207
	.byt	205
	.byt	202
	.byt	200
	.byt	197
	.byt	194
	.byt	192
	.byt	189
	.byt	186
	.byt	184
	.byt	181
	.byt	178
	.byt	175
	.byt	172
	.byt	169
	.byt	166
	.byt	163
	.byt	160
	.byt	157
	.byt	154
	.byt	151
	.byt	148
	.byt	145
	.byt	142
	.byt	139
	.byt	136
	.byt	133
	.byt	130
	.byt	127
	.byt	124
	.byt	121
	.byt	118
	.byt	115
	.byt	112
	.byt	109
	.byt	106
	.byt	103
	.byt	100
	.byt	97
	.byt	94
	.byt	91
	.byt	88
	.byt	85
	.byt	82
	.byt	79
	.byt	76
	.byt	73
	.byt	70
	.byt	68
	.byt	65
	.byt	62
	.byt	60
	.byt	57
	.byt	54
	.byt	52
	.byt	49
	.byt	47
	.byt	45
	.byt	42
	.byt	40
	.byt	38
	.byt	36
	.byt	33
	.byt	31
	.byt	29
	.byt	27
	.byt	25
	.byt	24
	.byt	22
	.byt	20
	.byt	19
	.byt	17
	.byt	15
	.byt	14
	.byt	13
	.byt	11
	.byt	10
	.byt	9
	.byt	8
	.byt	7
	.byt	6
	.byt	5
	.byt	4
	.byt	4
	.byt	3
	.byt	2
	.byt	2
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	0
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	1
	.byt	2
	.byt	2
	.byt	3
	.byt	4
	.byt	4
	.byt	5
	.byt	6
	.byt	7
	.byt	8
	.byt	9
	.byt	10
	.byt	11
	.byt	13
	.byt	14
	.byt	15
	.byt	17
	.byt	19
	.byt	20
	.byt	22
	.byt	24
	.byt	25
	.byt	27
	.byt	29
	.byt	31
	.byt	33
	.byt	36
	.byt	38
	.byt	40
	.byt	42
	.byt	45
	.byt	47
	.byt	49
	.byt	52
	.byt	54
	.byt	57
	.byt	60
	.byt	62
	.byt	65
	.byt	68
	.byt	70
	.byt	73
	.byt	76
	.byt	79
	.byt	82
	.byt	85
	.byt	88
	.byt	91
	.byt	94
	.byt	97
	.byt	100
	.byt	103
	.byt	106
	.byt	109
	.byt	112
	.byt	115
	.byt	118
	.byt	121
	.byt	124
	.byt	127
	.byt	130
	.byt	133
	.byt	136
	.byt	139
	.byt	142
	.byt	145
	.byt	148
	.byt	151
	.byt	154
	.byt	157
	.byt	160
	.byt	163
	.byt	166
	.byt	169
	.byt	172
	.byt	175
	.byt	178
	.byt	181
	.byt	184
	.byt	186
	.byt	189
	.byt	192
	.byt	194
	.byt	197
	.byt	200
	.byt	202
	.byt	205
	.byt	207
	.byt	209
	.byt	212
	.byt	214
	.byt	216
	.byt	218
	.byt	221
	.byt	223
	.byt	225
	.byt	227
	.byt	229
	.byt	230
	.byt	232
	.byt	234
	.byt	235
	.byt	237
	.byt	239
	.byt	240
	.byt	241
	.byt	243
	.byt	244
	.byt	245
	.byt	246
	.byt	247
	.byt	248
	.byt	249
	.byt	250
	.byt	250
	.byt	251
	.byt	252
	.byt	252
	.byt	253
	.byt	253
	.byt	253
	.byt	253
	.byt	253

_CosTable8				.dsb 256
_CosTable4				.dsb 256
_CosTableDistorter		.dsb 256

TableModulo6
	.byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
	.byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
	.byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
	.byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
	.byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
	.byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3

TableDivBy6
	.byt 0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9,9,9,9
	.byt 10,10,10,10,10,10,11,11,11,11,11,11,12,12,12,12,12,12,13,13,13,13,13,13,14,14,14,14,14,14,15,15,15,15,15,15,16,16,16,16,16,16,17,17,17,17,17,17,18,18,18,18,18,18,19,19,19,19,19,19
	.byt 20,20,20,20,20,20,21,21,21,21,21,21,22,22,22,22,22,22,23,23,23,23,23,23,24,24,24,24,24,24,25,25,25,25,25,25,26,26,26,26,26,26,27,27,27,27,27,27,28,28,28,28,28,28,29,29,29,29,29,29
	.byt 30,30,30,30,30,30,31,31,31,31,31,31,32,32,32,32,32,32,33,33,33,33,33,33,34,34,34,34,34,34,35,35,35,35,35,35,36,36,36,36,36,36,37,37,37,37,37,37,38,38,38,38,38,38,39,39,39,39,39,39
	.byt 40,40,40,40,40,40,41,41,41,41,41,41,42,42,42,42
	;,42,42,43,43,43,43,43,43,44,44,44,44,44,44,45,45,45,45,45,45,46,46,46,46,46,46,47,47,47,47,47,47,48,48,48,48,48,48,49,49,49,49,49,49


_PlayerBuffer		.dsb 256*14			; About 3.5 kilobytes somewhere in memory, we put the music file in overlay memory
_PlayerBufferEnd

_ScreenAddrLow				.dsb 256
_ScreenAddrHigh  			.dsb 256
	
_PictureLoadBufferAddrLow	.dsb 256
_PictureLoadBufferAddrHigh  .dsb 256

_EmptySourceScanLine 		.dsb 256			; Only zeroes, can be used for special effects
_EmptyDestinationScanLine 	.dsb 256			; Only zeroes, can be used for special effects

ScrollTableLeft  	.dsb 256
ScrollTableRight 	.dsb 256
_FontAddrLow		.dsb 128
_FontAddrHigh		.dsb 128	
_FontCharacterWidth .dsb 128


_EndDemoData

#echo Remaining space in the demo code:
#print ($9800 - _EndDemoData) 

	.bss 

;	*=$200
;_SectorBuffer

	*=$c000
_MusicLength

;	*=$fc00
;_LoaderCode
