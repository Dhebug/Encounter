;Wave_PageAllignedStuff.s
;These routines(pme) have calculated low addresses
;So are page alligned and spaced 16 bytes apart.
;To save space the gaps hold other subroutines,
;music vars and tables

;PageAllignedEffectCommands
; .dsb 256-(*&255)

pmeLoopOrEnd	;XX00
 	ldy #00		;2
 	lda (effect),y      ;2
 	bpl pmeLoop         ;2
 	jmp EndEffect       ;3
pmeLoop 	tay                 ;1
	rts                 ;1

prcEGPeriod
	sta ayw_EGPeriod
	rts
	
MusicTempoCount	.byt 0

pmeNoiseOff	;XX10
	lda ayw_Status	;3
	ora NoiseBit,x      ;3
	sta ayw_Status      ;3
	rts                 ;1
	
prcBar	inc BarFlag
	sec
	rts
	
PatternRow	.byt 0

pmeEGOff		;XX20
	lda ayw_Volume,x	;3
	and #15             ;2
	sta ayw_Volume,x    ;3
	lda #00             ;2
	sta EGActiveFlag,x	;3
	rts                 ;1
	
NewActivity	.byt 0
PatternRestCount	.byt 0

pmeToneOff	;XX30
	lda ayw_Status	;3
	ora ToneBit,x       ;3
	sta ayw_Status      ;3
	rts                 ;1
	
prcNoise
	sta ayw_Noise
	rts

ChannelID		.byt 0
ListIndex		.byt 0

pmeVolumeOFS	;XX40
	clc
	adc PatternVolume,x	;3
	cmp #16             ;2
	bcs EndEffect       ;2
	sta PatternVolume,x ;3
	sta ayw_Volume,x    ;3
	rts                 ;1
	
MusicActivity	.byt 0

pmeNoiseOFS	;XX50
	clc
	adc ayw_Noise	;3
	and #31             ;2
	sta ayw_Noise       ;3
	jsr NoiseOn	;3
	rts                 ;1
EffectBit
ToneBit
 .byt %00000001
 .byt %00000010
 .byt %00000100
	



pmeEGPerOFS	;XX60
	clc
	adc ayw_EGPeriod	;3
	sta ayw_EGPeriod    ;3
	jmp EGOn		;3
	

EffectMask
ToneMask
 .byt %11111110
 .byt %11111101
 .byt %11111011
OrnamentBit
NoiseBit
 .byt %00001000
 .byt %00010000
 .byt %00100000
	
	
pmePitchOFS	;XX70
.(
	;A pitch offset is always relative to the Intermediate Pitch
	sta Temp01
	clc
	adc IntermediatePitchLo
	sta IntermediatePitchLo
	bit Temp01
	bmi skip2
	bcc skip1
	inc IntermediatePitchHi
	jmp skip1
skip2	bcs skip1
	dec IntermediatePitchHi
skip1	lda ayw_Status
.)
	and ToneMask,x
	sta ayw_Status
	sec
	rts

EndEffect	lda MusicActivity
	and EffectMask,x
	sta MusicActivity
	clc
	rts

PatternNote
 .dsb 3,0
PatternVolume
 .dsb 3,0
EffectID
 .dsb 3,0
ayRealRegister
 .byt 0,2,4,1,3,5,6,7,8,9,10,11,12,13
EffectIndex
 .dsb 3,0

NoiseOn	lda ayw_Status        
	and NoiseMask,x   
	sta ayw_Status        
	rts

EGOn	lda ayw_Volume,x      
	ora #16             
	sta ayw_Volume,x      
	sta EGActiveFlag,x
	clc                 
	rts                 

prcCom_Tempo
	sta MusicTempoCount
	;Also store into compiled header
	ldy #01
	sta (header),y
	rts
