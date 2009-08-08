;prTables.s

;B0 SFX Only Active(Play Note)
;B1 -
;B2 -
;B3 7 Bit Noise(1)
;B4 6 Bit Volume(1)
;B5 Sharing Behaviour (Process SFX only when given timeslot(1))
;B6 Pattern is Command on Track H
;B7 Music Active(1)
prGlobalProperty		.byt 0

SinglePatternPlayFlag	.byt 0

;When an SFX is inactive(ended) then the TSB rule may decide to silence slot.
prActiveTracks_Pattern	.byt 0
prActiveTracks_SFX		.byt 0
prActiveTracks_Pitch	.byt 0
prActiveTracks_Sharing	.byt 0
prActiveTracks_Mimicking	.byt 0
prActiveTracks_NotMuted	.byt 255
prActiveTracks_Pitchbend	.byt 0

;Breakdown param1(0-15) into delays and steps proportional to value(15 fastest)
;The maximum pitch distance apart is C-0 to C#1 which is 108 values apart.
;The minimum pitch distance apart is A#7 to B-7 which is 1 value apart
;Allowing for maximum step of 30 and minimum of .5
;the range should also be logarythmic..
;   .5  .5  .5  1 1 1 1 2 2  2  3  3  4  5  6
;0.5 1.0 1.5 2.0 3 4 5 6 8 10 12 15 18 22 27 33  <<
;0   1   2   3   4 5 6 7 8 9  A  B  C  D  E  F
pbDelayTable
 .byt 1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0
pbStepTable
 .byt 1,1,2,2,3,4,5,6,8,10,12,15,18,22,27,33


prMimicTrack
 .dsb 8,0
prMimicVolumeOffset
 .dsb 8,0
prMimicPitchOffset
 .dsb 8,0
prMimicTimeOffset
 .dsb 8,0
prMimicHistoryPointer
 .dsb 8,0
prMimicHistoryData
 .dsb 256,0

SharingGroup
 .dsb 8,0
SharingIndex
 .dsb 4,0
SharingCount
 .dsb 4,0
SharingEntry
 .dsb 8,0	
prResourceUsageCount
 .byt 0,0,0,0,0
AbsoluteVolume
 .byt 0,0,0
AbsoluteNoise
 .byt 0
prGroupIndex
 .byt 0

Dither4StepCount		.byt 0

DitherNoisePattern
 .byt 0
DitherVolumePattern
 .byt 0,0,0
DitherPattern
 .byt %00000001	;0   00%
 .byt %00010001	;1/4 25%
 .byt %01010101	;1/2 50%
 .byt %01110111	;3/4 75%
prSS2PitchResourceIndex
 .byt 0	;Chip A with Channel A Volume
 .byt 1   ;Chip B with channel B Volume
 .byt 2   ;Chip C with channel C Volume

 .byt 0   ;Chip A with Channel A Status
 .byt 1   ;Chip B with channel B Status
 .byt 2   ;Chip C with channel C Status

 .byt 11  ;EG on A         
 .byt 11  ;EG on B         
 .byt 11  ;EG on A and B   
 .byt 11  ;EG on C         
 .byt 11  ;EG on A and C   
 .byt 11  ;EG on B and C   
 .byt 11  ;EG on A, B and C

 .byt 128 ;Noise on A         
 .byt 128 ;Noise on B         
 .byt 128 ;Noise on A and B   
 .byt 128 ;Noise on C         
 .byt 128 ;Noise on A and C   
 .byt 128 ;Noise on B and C   
 .byt 128 ;Noise on A, B and C
 
prSS2StatusFlag
 .byt 0	;Chip A with Channel A Volume
 .byt 0   ;Chip B with channel B Volume
 .byt 0   ;Chip C with channel C Volume

 .byt 128 ;Chip A with Channel A Status
 .byt 128 ;Chip B with channel B Status
 .byt 128 ;Chip C with channel C Status

 .byt 1   ;EG on A         
 .byt 1   ;EG on B         
 .byt 1   ;EG on A and B   
 .byt 1   ;EG on C         
 .byt 1   ;EG on A and C   
 .byt 1   ;EG on B and C   
 .byt 1   ;EG on A, B and C

 .byt 128 ;Noise on A         
 .byt 128 ;Noise on B         
 .byt 128 ;Noise on A and B   
 .byt 128 ;Noise on C         
 .byt 128 ;Noise on A and C   
 .byt 128 ;Noise on B and C   
 .byt 128 ;Noise on A, B and C
 
 .byt 2,2,2
 .byt 4,4,4,4
 .byt 8,8,8,8
prSS2Register4DVS
prSS2StatusBits
 .byt 0	;Chip A with Channel A Volume
 .byt 0   ;Chip B with channel B Volume
 .byt 0   ;Chip C with channel C Volume

 .byt 1   ;Chip A with Channel A Status
 .byt 2   ;Chip B with channel B Status
 .byt 4   ;Chip C with channel C Status

 .byt 4   ;EG on A         
 .byt 2   ;EG on B         
 .byt 6   ;EG on A and B   
 .byt 1   ;EG on C         
 .byt 5   ;EG on A and C   
 .byt 3   ;EG on B and C   
 .byt 7   ;EG on A, B and C

 .byt 8   ;Noise on A         
 .byt 16  ;Noise on B         
 .byt 24  ;Noise on A and B   
 .byt 32  ;Noise on C         
 .byt 40  ;Noise on A and C   
 .byt 48  ;Noise on B and C   
 .byt 56  ;Noise on A, B and C


;For extraction, we could use a rotating bit. When the bit hits an empty slot it advances
;but when it hits it sets that as the timeslot, on the next interval the bit continues to rotate.
;Optimise by pre-reading byte and if void then proceed to next.

;For compiling, it will be easy to determine the source (ABCEN) and we'll know the track (ABCDEFGH)
;Initialise matrix with zeroes.
;so just set that bit in matrix.

;To ease channel index addressing we reorganise the AY Registers using this table
RegisterNumber
 .byt 0,2,4,1,3,5,6,7,8,9,10,11,12,13

AYRegisterBase
AY_PitchALo	.byt 0
AY_PitchBLo	.byt 0
AY_PitchCLo	.byt 0
AY_PitchAHi	.byt 0
AY_PitchBHi	.byt 0
AY_PitchCHi	.byt 0
AY_Noise 		.byt 0
AY_Status 	.byt %01111000
AY_VolumeA	.byt 0
AY_VolumeB	.byt 0
AY_VolumeC	.byt 0
AY_PeriodLo	.byt 0
AY_PeriodHi	.byt 0
AY_Cycle 		.byt 0
AY_Dummy		.byt 0

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

rndRandom
 .dsb 2,0
rndTemp	.byt 0

;********************************** Lists ******************************
ListRowWideCommandLo
 .byt <erwcNewSong
 .byt <erwcEndSong
 .byt <erwcFadeSong
 .byt <erwcSFXSettings
 .byt <erwcTimeSlotBehaviour
 .byt <erwcSongSettings
 .byt <erwcResolutionSettings
 .byt <erwcSpare
ListRowWideCommandHi
 .byt >erwcNewSong
 .byt >erwcEndSong
 .byt >erwcFadeSong
 .byt >erwcSFXSettings
 .byt >erwcTimeSlotBehaviour
 .byt >erwcSongSettings
 .byt >erwcResolutionSettings
 .byt >erwcSpare

;*********************************** Patterns ********************************
prPatternIndex	.byt 0
prTrackPattern
 .dsb 8,128
prTrackSFX
 .dsb 8,0
prTrackNote
 .dsb 8,0
prTrackPitchLo
 .dsb 8,0
prTrackPitchHi
 .dsb 8,0
prTrackVolume
 .dsb 8,0
prBaseOctave
 .dsb 8,0
prNextEntryIsBarFlag	.byt 0
;00-15 Pitchbend		Rate	Track		00-15
;16    Trigger Out		-	Value(0-63)	01
;17    Trigger In		-	Value(0-63)	02
;18    Note Tempo		-	Tempo(0-63)	03
;19-34 EG Cycle		-	Cycle		04
;35-50 EG Period		Hi	Lo		05
;51-60 -                                                    06-60
;61    Rest					----
;62    Rest					62
;63    Bar					----
prPatternCommandThreshhold
 .byt 0	;0 Pitchbend
 .byt 16  ;1 Trigger Out
 .byt 17  ;2 Trigger In
 .byt 18  ;3 Note Tempo
 .byt 19  ;4 EG Cycle
 .byt 35  ;5 EG Period
 .byt 51  ;6 -
 .byt 61  ;7 Rest
 .byt 62  ;8 -
 .byt 63  ;9 Bar
prPatternCommandVectorLo
 .byt <prpc_PitchBend	;0 Pitchbend
 .byt <prpc_TriggerOut  	;1 Trigger Out
 .byt <prpc_TriggerIn  	;2 Trigger In
 .byt <prpc_NoteTempo  	;3 Note Tempo
 .byt <prpc_EGCycle  	;4 EG Cycle
 .byt <prpc_EGPeriod  	;5 EG Period
 .byt <prpc_Spare  		;6 -
 .byt <prpc_Spare  		;7 Rest
 .byt <prpc_Spare  		;8 -
 .byt <prpc_Spare  		;9 Bar
prPatternCommandVectorHi
 .byt >prpc_PitchBend	;0 Pitchbend
 .byt >prpc_TriggerOut  	;1 Trigger Out
 .byt >prpc_TriggerIn  	;2 Trigger In
 .byt >prpc_NoteTempo  	;3 Note Tempo
 .byt >prpc_EGCycle  	;4 EG Cycle
 .byt >prpc_EGPeriod  	;5 EG Period
 .byt >prpc_Spare  		;6 -
 .byt >prpc_Spare  		;7 Rest
 .byt >prpc_Spare  		;8 -
 .byt >prpc_Spare  		;9 Bar

;************************* SFX Tables and Variables *************************
prSFXIndex
 .dsb 8,0
;0   Volume Condition
;1   Counter Condition
;128 No Condition
prTrackSFXSkipCondition
 .dsb 8,0
prTrackSFXDelay	;0-127
 .dsb 8,0
prTrackSFXCounter
 .dsb 8,0
;0 Triangle
;1 Sawtooth
;2 Attack
;3 Decay
prWaveCode
 .byt %1110 + 128
 .byt %1000 + 128
 .byt %1101 + 128
 .byt %0011 + 128
FilterMaskLo
 .byt %01111111
 .byt %00111111
 .byt %00011111
 .byt %00001111
 .byt %00000111

;25Hz(0) 50Hz(1) 100Hz(2) 200Hz(3)
IRQSpeedValue
 .byt 7,3,1,0

prSS2ChannelIndex
 .byt 0	;Chip A with Channel A Volume
 .byt 1   ;Chip B with channel B Volume
 .byt 2   ;Chip C with channel C Volume

 .byt 0   ;Chip A with Channel A Status
 .byt 1   ;Chip B with channel B Status
 .byt 2   ;Chip C with channel C Status

 .byt 0   ;EG on A         
 .byt 1   ;EG on B         
 .byt 2   ;EG on A and B   
 .byt 3   ;EG on C         
 .byt 4   ;EG on A and C   
 .byt 5   ;EG on B and C   
 .byt 6   ;EG on A, B and C

 .byt 0   ;Noise on A         
 .byt 1   ;Noise on B         
 .byt 2   ;Noise on A and B   
 .byt 3   ;Noise on C         
 .byt 4   ;Noise on A and C   
 .byt 5   ;Noise on B and C   
 .byt 6   ;Noise on A, B and C
 
prSS2ChannelBits
 .byt 1	;Chip A with Channel A Volume
 .byt 2   ;Chip B with channel B Volume
 .byt 4   ;Chip C with channel C Volume

 .byt 1   ;Chip A with Channel A Status
 .byt 2   ;Chip B with channel B Status
 .byt 4   ;Chip C with channel C Status

 .byt 1   ;EG on A         
 .byt 2   ;EG on B         
 .byt 3   ;EG on A and B   
 .byt 4   ;EG on C         
 .byt 5   ;EG on A and C   
 .byt 6   ;EG on B and C   
 .byt 7   ;EG on A, B and C

 .byt 1   ;Noise on A         
 .byt 2   ;Noise on B         
 .byt 3   ;Noise on A and B   
 .byt 4   ;Noise on C         
 .byt 5   ;Noise on A and C   
 .byt 6   ;Noise on B and C   
 .byt 7   ;Noise on A, B and C
 
 

;Indexed by Type
prSS2VolumeIndex
 .byt 0	;Chip A with Channel A Volume
 .byt 1   ;Chip B with channel B Volume
 .byt 2   ;Chip C with channel C Volume

 .byt 0   ;Chip A with Channel A Status
 .byt 1   ;Chip B with channel B Status
 .byt 2   ;Chip C with channel C Status

 .byt 1   ;EG on A
 .byt 2   ;EG on B
 .byt 3   ;EG on A and B
 .byt 4   ;EG on C
 .byt 5   ;EG on A and C
 .byt 6   ;EG on B and C
 .byt 7   ;EG on A, B and C

 .byt 8   ;Noise on A         
 .byt 9   ;Noise on B         
 .byt 10  ;Noise on A and B   
 .byt 11  ;Noise on C         
 .byt 12  ;Noise on A and C   
 .byt 13  ;Noise on B and C   
 .byt 14  ;Noise on A, B and C

prSS2ResourceUsage
 .byt 0	;Chip A with Channel A Volume
 .byt 1   ;Chip B with channel B Volume
 .byt 2   ;Chip C with channel C Volume

 .byt 0   ;Chip A with Channel A Status
 .byt 1   ;Chip B with channel B Status
 .byt 2   ;Chip C with channel C Status

 .byt 3   ;EG on A
 .byt 3   ;EG on B
 .byt 3   ;EG on C
 .byt 3   ;EG on A and B
 .byt 3   ;EG on B and C
 .byt 3   ;EG on A and C
 .byt 3   ;EG on A, B and C

 .byt 4   ;Noise on A
 .byt 4   ;Noise on B
 .byt 4   ;Noise on C
 .byt 4   ;Noise on A and B
 .byt 4   ;Noise on B and C
 .byt 4   ;Noise on A and C
 .byt 4   ;Noise on A, B and C

prTrackSS	;0-31
 .dsb 8,0

prAYStatusChannelBits
 .byt %00000001	;TA
 .byt %00000010	;TB
 .byt %00000100	;TC
 .byt %00000011	;TA TB
 .byt %00000110	;TB TC
 .byt %00000101	;TA TC
 .byt %00000111	;TA TB TC

 .byt %00001000	;NA
 .byt %00010000	;NB
 .byt %00100000	;NC
 .byt %00011000	;NA NB
 .byt %00110000	;NB NC
 .byt %00101000	;NA NC
 .byt %00111000	;NA NB NC
 .byt %00000001	;Digidrum A
 .byt %00000010     ;Digidrum B
 .byt %00000100	;Digidrum C
 .byt %00000001	;SID A
 .byt %00000010     ;SID B
 .byt %00000100	;SID C
 .byt %00000000	;Buzzer
 .byt %00000001	;Pulsar A
 .byt %00000010     ;Pulsar B
 .byt %00000100	;Pulsar C

 	
prSFXCodeThreshhold
 .byt 0	;00 00 Positive Pitch Offset 1-25
 .byt 25	;01 01 Negative Pitch Offset 1-25
 .byt 50	;02 02 Positive Note Offset 1-25
 .byt 75	;03 03 Negative Note Offset 1-25
 .byt 100	;04 04 Positive Volume Offset 1 to 15
 .byt 115	;05 05 Negative Volume Offset 1 to 15
 .byt 130 ;06 06 Positive Noise Offset 1 to 16
 .byt 146 ;07 07 Negative Noise Offset 1 to 16
 .byt 162 ;08 08 Positive EG Offset 1 to 8
 .byt 170 ;09 09 Negative EG Offset
 .byt 178 ;10 0A Envelope Off(0) or On(1)
 .byt 180 ;11 0B Tone On(0) or Off(1)
 .byt 182 ;12 0C Noise On(0) or Off(1)
 .byt 184 ;13 0D Set Skip Loop Condition(1-3)
 .byt 187 ;14 0F Filter 1 to 4
 .byt 192 ;15 10 Delay 1 to 10
 .byt 202	;16 11 Set Counter 1 to 19
 .byt 221 ;17 11 End SFX
 .byt 222 ;18 12 Loop 0 to 24
 .byt 247 ;19 13 Random Delay
 .byt 248 ;20 14 Random Noise
 .byt 249 ;21 15 Random Volume
 .byt 250	;22 16 Random Note
 .byt 251 ;23 17 Random Pitch
 .byt 252 ;24 18 EG Wave 1 to 4
 
prSFXTypeVectorLo
 .byt <prProc_SFXPositivePitch	;00 00 Positive Pitch Offset 1-25    
 .byt <prProc_SFXNegativePitch          ;01 01 Negative Pitch Offset 1-25    
 .byt <prProc_SFXPositiveNote           ;02 02 Positive Note Offset 1-25     
 .byt <prProc_SFXNegativeNote           ;03 03 Negative Note Offset 1-25     
 .byt <prProc_SFXPositiveVolume         ;04 04 Positive Volume Offset 1 to 15
 .byt <prProc_SFXNegativeVolume         ;05 05 Negative Volume Offset 1 to 15
 .byt <prProc_SFXPositiveNoise          ;06 06 Positive Noise Offset 1 to 16 
 .byt <prProc_SFXNegativeNoise          ;07 07 Negative Noise Offset 1 to 16 
 .byt <prProc_SFXPositiveEGPeriod       ;08 08 Positive EG Offset 1 to 8     
 .byt <prProc_SFXNegativeEGPeriod       ;09 09 Negative EG Offset            
 .byt <prProc_SFXSwitchEG               ;10 0A Envelope Off(0) or On(1)      
 .byt <prProc_SFXSwitchTone             ;11 0B Tone On(0) or Off(1)          
 .byt <prProc_SFXSwitchNoise            ;12 0C Noise On(0) or Off(1)         
 .byt <prProc_SFXSetSkipCondition       ;13 0D Set Skip Loop Condition(1-3)  
 .byt <prProc_SFXFilter                 ;14 0F Filter 1 to 4                 
 .byt <prProc_SFXDelay                  ;15 10 Delay 1 to 10                 
 .byt <prProc_SFXSetCounter             ;16 11 Set Counter 1 to 19           
 .byt <prProc_SFXEndSFX                 ;17 11 End SFX                       
 .byt <prProc_SFXLoop                   ;18 12 Loop 0 to 24                  
 .byt <prProc_SFXRandomDelay            ;19 13 Random Delay                  
 .byt <prProc_SFXRandomNoise            ;20 14 Random Noise                  
 .byt <prProc_SFXRandomVolume           ;21 15 Random Volume                 
 .byt <prProc_SFXRandomNote             ;22 16 Random Note                   
 .byt <prProc_SFXRandomPitch            ;23 17 Random Pitch                  
 .byt <prProc_SFXWave                   ;24 18 EG Wave 1 to 4                

prSFXTypeVectorHi
 .byt >prProc_SFXPositivePitch
 .byt >prProc_SFXNegativePitch
 .byt >prProc_SFXPositiveNote
 .byt >prProc_SFXNegativeNote
 .byt >prProc_SFXPositiveVolume
 .byt >prProc_SFXNegativeVolume
 .byt >prProc_SFXPositiveNoise
 .byt >prProc_SFXNegativeNoise
 .byt >prProc_SFXPositiveEGPeriod
 .byt >prProc_SFXNegativeEGPeriod
 .byt >prProc_SFXSwitchEG
 .byt >prProc_SFXSwitchTone
 .byt >prProc_SFXSwitchNoise
 .byt >prProc_SFXSetSkipCondition
 .byt >prProc_SFXFilter
 .byt >prProc_SFXDelay
 .byt >prProc_SFXSetCounter
 .byt >prProc_SFXEndSFX
 .byt >prProc_SFXLoop
 .byt >prProc_SFXRandomDelay
 .byt >prProc_SFXRandomNoise
 .byt >prProc_SFXRandomVolume
 .byt >prProc_SFXRandomNote
 .byt >prProc_SFXRandomPitch
 .byt >prProc_SFXWave

