;SFX Command Codes
#define	SETCHANNEL_A		0
#define	SETCHANNEL_B       		1
#define	SETCHANNEL_C       		2

#define	SETCHANNEL_A_   		3
#define	SETCHANNEL_A_E   		4
#define	SETCHANNEL_A_N   		5
#define	SETCHANNEL_A_NE   		6
#define	SETCHANNEL_A_T   		7
#define	SETCHANNEL_A_TE   		8
#define	SETCHANNEL_A_TN   		9
#define	SETCHANNEL_A_TNE   		10
#define	SETCHANNEL_B_   		11
#define	SETCHANNEL_B_E   		12
#define	SETCHANNEL_B_N   		13
#define	SETCHANNEL_B_NE   		14
#define	SETCHANNEL_B_T   		15
#define	SETCHANNEL_B_TE   		16
#define	SETCHANNEL_B_TN   		17
#define	SETCHANNEL_B_TNE   		18
#define	SETCHANNEL_C_   		19
#define	SETCHANNEL_C_E   		20
#define	SETCHANNEL_C_N   		21
#define	SETCHANNEL_C_NE   		22
#define	SETCHANNEL_C_T   		23
#define	SETCHANNEL_C_TE   		24
#define	SETCHANNEL_C_TN   		25
#define	SETCHANNEL_C_TNE   		26

#define	SETPITCH   		27

#define	SETVOLUME       		28

#define	PLAY            		44

#define	END_A_OFF          		94
#define	END_B_OFF          		95
#define	END_AB_OFF         		96
#define	END_C_OFF          		97
#define	END_AC_OFF         		98
#define	END_BC_OFF         		99
#define	END_ABC_OFF        		100

#define	SFXJUMP         		101

#define	ADJUSTVOLUME		102+15

#define	LOOPONVOLUMERANGE		133

#define	LOOPONCOUNTERRANGE		134

#define	SETNOISE			135

#define	SETENV			167

#define	TRIGGER_SAWTOOTH   		168
#define	TRIGGER_TRIANGLE   		169
#define	TRIGGER_DESCEND    		170
#define	TRIGGER_ASCEND     		171

#define	ADJUSTPITCH     		172+15

#define	END_NORMAL         		203

#define	SETNOTE			204

#define	SETCOUNTER      		205

#define	RANDOM_HIGH		0


;Simple SFX Driver
;Utilising all three channels and EG with Software Envelopes
;1) End of Puzzle Memory	- A High Beep
;2) Exit Pocket Computer	- B Low Beep
;3) Enter Pocket Computer	- B Mid beep
;4) Pause Game		- A Mid beep
;5) Resume game		- A High beep
;6) merge failed		- A Low Beep
;7) merge successful	- A High Beep
;8) Passcode found		- ABC Chord
;9) Dial Tone		- AB Tone
;10)Dial option1		- AB Sequence of set pitches/notes, long high note then random high note then silence
;11)Dial option2		- AB Sequence of set pitches/notes, long high note then random high note then silence
;12)SC Scale		- BC Note fading
;13)SC Sequence wrong	- BC Low Beep
;14)SC Sequence right	- BC High Beep
;15)Footstep Left		- AN Tsh
;16)Footstep Right		- AN Tsh
;17)Robot plasma		- CE tzz
;18)Lift start		- BC Pitchbend up then constant dischord
;19)Lift end		- BC Pitchbend down to silence
;24)Robot Turn		- B Tone osc
;25)Robot Motors		- B Tone Low pitch Pattern
;26)Plasma Ethan(Kill)	- CE intermittant random tzz



;All Sounds are dedicated to a particular sound source, be it A,B,C,N,E or a combination thereof.
;Simplicity is the name of the game here since the code must fit into the smallest space.
;Scripts are chosen for their flexibility (though not neccesarily for their speed).

;Each script is dedicated to a unique SFX.
;The script dictates the channels used.
;A single script may be as much as 256 bytes long.

;000 SETCHANNEL_A
;001 SETCHANNEL_B
;002 SETCHANNEL_C
;
;003 SETCHANNEL_A_tne
;004 SETCHANNEL_A_tnE
;005 SETCHANNEL_A_tNe
;006 SETCHANNEL_A_tNE
;007 SETCHANNEL_A_Tne
;008 SETCHANNEL_A_TnE
;009 SETCHANNEL_A_TNe
;010 SETCHANNEL_A_TNE
;011 SETCHANNEL_B_tne
;012 SETCHANNEL_B_tnE
;013 SETCHANNEL_B_tNe
;014 SETCHANNEL_B_tNE
;015 SETCHANNEL_B_Tne
;016 SETCHANNEL_B_TnE
;017 SETCHANNEL_B_TNe
;018 SETCHANNEL_B_TNE
;019 SETCHANNEL_C_tne
;020 SETCHANNEL_C_tnE
;021 SETCHANNEL_C_tNe
;022 SETCHANNEL_C_tNE
;023 SETCHANNEL_C_Tne
;024 SETCHANNEL_C_TnE
;025 SETCHANNEL_C_TNe
;026 SETCHANNEL_C_TNE
;
;027 SETPITCH,PitchLo
;
;028 SETVOLUME+15
;
;044 PLAY+49
;
;094 END_A_OFF
;095 END_B_OFF
;096 END_AB_OFF
;097 END_C_OFF
;098 END_AC_OFF
;099 END_BC_OFF
;100 END_ABC_OFF
;
;101 JUMP,lo,hi
;
;102 ADJUSTVOLUME-15 to ADJUSTVOLUME+15
;
;133 LOOPONVOLUMERANGE,offset
;
;134 LOOPONCOUNTERRANGE,offset
;
;135 SETNOISE+31
;
;167 SETENV,lo,hi
;
;168 TRIGGER_SAWTOOTH
;169 TRIGGER_TRIANGLE
;170 TRIGGER_DESCEND
;171 TRIGGER_ASCEND
;
;172 ADJUSTPITCH-15
;
;203 END_NORMAL
;
;204 SETCOUNTER+52

;A SFX ID
KickSFX
.(
	stx vector1+1
	sty vector2+1
	tax
	ldy sfx_PrimaryIndex,x
	lda sfx_ScriptAddressLo,x
	sta sfx_AddressLo,y
	lda sfx_ScriptAddressHi,x
	sta sfx_AddressHi,y
	;Now reset current sfx for this index
	lda #00
	sta ay_PitchHi,y
	sta sfx_Index,y
	sta sfx_PlayPeriod,y
	lda #1
	sta sfx_Status,y
vector1	ldx #00
vector2	ldy #00
.)
	rts
	
	

sfx_ScriptEngine
	;Are bees present on the screen?
	ldx #2
.(
loop2	lda sfx_Status,x
	beq skip1
;	nop
;	jmp loop2	;???
	lda sfx_PlayPeriod,x
	beq skip2
	dec sfx_PlayPeriod,x
	jmp skip1
skip2	lda sfx_AddressLo,x
	sta sfx
	lda sfx_AddressHi,x
	sta sfx+1
loop3	ldy sfx_Index,x
	lda (sfx),y
	iny
	sty sfxTemp2
	ldy #17
loop1	dey
	cmp sfxValueThreshhold,y
	bcc loop1
	sbc sfxValueThreshhold,y
	sta sfxTemp1
	
	lda sfx_Index,x
	adc sfxCodeBytes,y
	sta sfx_Index,x
	
	lda sfxCodeVectorLo,y
	sta vector1+1
	lda sfxCodeVectorHi,y
	sta vector1+2
	
	ldy sfxTemp2
	lda sfxTemp1
	sec
vector1	jsr $dead
	bcs loop3
skip1	dex
	bpl loop2
.)
SendAYBank
	;Send AY Bank
	ldx #$0D
.(
loop1	lda ay_Bank,x
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
	ldy ay_RegisterID,x
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

ay_Bank
ay_PitchLo	.byt 0,0,0
ay_PitchHi	.byt 0,0,0
ay_Noise		.byt 0
ay_Status		.byt 127
ay_Volume		.byt 0,0,0
ay_EGPeriodLo	.byt 0
ay_EGPeriodHi	.byt 0
ay_Cycle		.byt 0
ayr_Bank
ayr_PitchLo	.byt 128,128,128
ayr_PitchHi	.byt 128,128,128
ayr_Noise		.byt 128
ayr_Status	.byt 128
ayr_Volume	.byt 128,128,128
ayr_EGPeriodLo	.byt 128
ayr_EGPeriodHi	.byt 128
ayr_Cycle		.byt 128
ay_RegisterID
 .byt 0,2,4	;ayr_PitchLo
 .byt 1,3,5	;ayr_PitchHi
 .byt 6		;ayr_Noise
 .byt 7		;ayr_Status
 .byt 8,9,10	;ayr_Volume
 .byt 11		;ayr_EGPeriodLo
 .byt 12		;ayr_EGPeriodHi
 .byt 13		;ayr_Cycle


;sfx_Status
;0 Inactive
;1 Active
sfx_Status
 .dsb 3,0
;sfx_PlayPeriod
;0    Timed out
;1-52 Playing
sfx_PlayPeriod
 .dsb 3,0
sfx_ScriptAddressLo
 .byt <Script_Killed	;00
 .byt <Script_FireOrb         ;01
 .byt <Script_FireSword       ;02
 .byt <Script_FireHeart       ;03
 .byt <Script_Launcher	;04
 .byt <Script_CollectKey	;05
 .byt <Script_RainDrop	;06
 .byt <Script_FreeFairy	;07
 .byt <Script_Trampolene	;08
 .byt <Script_Door		;09
 .byt <Script_Footstep	;10
 .byt <Script_Spider	;11
 .byt <Script_Bees		;12
 .byt <Script_Explosion	;13
 .byt <Script_GameOver	;14
 .byt <Script_LevelComplete	;15
 .byt <Script_CollectUmbrella	;16
 .byt <Script_CollectHoney	;17
 .byt <Script_CollectBoots	;18
 .byt <Script_Starfield	;19

sfx_ScriptAddressHi
 .byt >Script_Killed	;00         
 .byt >Script_FireOrb         ;01
 .byt >Script_FireSword       ;02
 .byt >Script_FireHeart       ;03
 .byt >Script_Launcher	;04
 .byt >Script_CollectKey	;05
 .byt >Script_RainDrop	;06
 .byt >Script_FreeFairy	;07
 .byt >Script_Trampolene	;08
 .byt >Script_Door		;09
 .byt >Script_Footstep	;10
 .byt >Script_Spider	;11
 .byt >Script_Bees		;12
 .byt >Script_Explosion	;13
 .byt >Script_GameOver	;14
 .byt >Script_LevelComplete	;15
 .byt >Script_CollectUmbrella	;16
 .byt >Script_CollectHoney	;17
 .byt >Script_CollectBoots	;18
 .byt >Script_Starfield	;19
;A - Hero Fire
;B - Pickup
;C - NPC's
sfx_PrimaryIndex
 .byt 0			;00 Script_
 .byt 0			;01 Script_FireOrb
 .byt 0			;02 Script_ 
 .byt 0			;03 Script_ 
 .byt 2			;04 Script_Launcher
 .byt 1			;05 Script_CollectKey
 .byt 1			;06 Script_RainDrop
 .byt 1			;07 Script_FreeFairy
 .byt 0			;08 Script_Trampolene
 .byt 1			;09 Script_Door
 .byt 0			;10 Script_Footstep
 .byt 2			;11 Script_Spider
 .byt 2			;12 Script_Bees
 .byt 2			;13 Script_Explosion
 .byt 0			;14 Script_GameOver
 .byt 0			;15 Script_LevelComplete
 .byt 1			;16 Script_CollectUmbrella
 .byt 1			;17 Script_CollectHoney
 .byt 1			;18 Script_CollectBoots
 .byt 0			;19 Script_Starfield
sfx_AddressLo
 .dsb 3,0
sfx_AddressHi
 .dsb 3,0
sfx_Index
 .dsb 3,0
sfx_Counter
 .dsb 3,0

sfxValueThreshhold
 .byt 0 	;00 SETCHANNEL_A etc.
 .byt 3	;01 SETCHANNEL_A_tne etc.
 .byt 27 	;02 SETPITCH,PitchLo
 .byt 28 	;03 SETVOLUME+15
 .byt 44 	;04 PLAY+49
 .byt 94 	;05 END_A_OFF etc.
 .byt 101 ;06 JUMP,lo,hi
 .byt 102 ;07 ADJUSTVOLUME-15 to ADJUSTVOLUME+15
 .byt 133 ;08 LOOPONVOLUMERANGE,offset
 .byt 134 ;09 LOOPONCOUNTERRANGE,offset
 .byt 135 ;10 SETNOISE+31
 .byt 167 ;11 SETENV,lo,hi
 .byt 168 ;12 TRIGGER_SAWTOOTH etc.
 .byt 172 ;13 ADJUSTPITCH-15
 .byt 203	;14 END_NORMAL
 .byt 204	;15 SETNOTE,Note
 .byt 205	;16 SETCOUNTER+51
sfxCodeBytes	;Like how many parameters?
 .byt 0 	;SETCHANNEL_A etc.
 .byt 0	;SETCHANNEL_A_tne etc.
 .byt 1	;SETPITCH,PitchLo
 .byt 0	;SETVOLUME+15
 .byt 0	;PLAY+49
 .byt 0	;END_A_OFF etc.
 .byt 2	;JUMP,lo,hi
 .byt 0	;ADJUSTVOLUME-15 to ADJUSTVOLUME+15
 .byt 1	;LOOPONVOLUMERANGE,offset
 .byt 1	;LOOPONCOUNTERRANGE,offset
 .byt 0	;SETNOISE+31
 .byt 2	;SETENV,lo,hi
 .byt 0	;TRIGGER_SAWTOOTH etc.
 .byt 0	;ADJUSTPITCH-15
 .byt 0	;END_NORMAL
 .byt 1	;SETNOTE,Note
 .byt 0	;SETCOUNTER+52
sfxCodeVectorLo
 .byt <sfxcom_SetChannel 	;SETCHANNEL_A etc.
 .byt <sfxcom_SetChannelFlags	;SETCHANNEL_A_tne etc.
 .byt <sfxcom_SetPitch	;SETPITCH,PitchLo
 .byt <sfxcom_SetVolume	;SETVOLUME+15
 .byt <sfxcom_Play		;PLAY+49
 .byt <sfxcom_End_		;END_A_OFF etc.
 .byt <sfxcom_Jump		;JUMP,lo,hi
 .byt <sfxcom_AdjustVolume	;ADJUSTVOLUME-15 to ADJUSTVOLUME+15
 .byt <sfxcom_LoopOnVolume	;LOOPONVOLUMERANGE,offset
 .byt <sfxcom_LoopOnCounter	;LOOPONCOUNTERRANGE,offset
 .byt <sfxcom_SetNoise	;SETNOISE+31
 .byt <sfxcom_SetEnv		;SETENV,lo,hi
 .byt <sfxcom_TriggerCycle	;TRIGGER_SAWTOOTH etc.
 .byt <sfxcom_AdjustPitch	;ADJUSTPITCH-15
 .byt <sfxcom_End		;END_NORMAL
 .byt <sfxcom_SetNote	;SETNOTE,Note
 .byt <sfxcom_SetCounter	;SETCOUNTER+52
sfxCodeVectorHi
 .byt >sfxcom_SetChannel 	;SETCHANNEL_A etc.
 .byt >sfxcom_SetChannelFlags	;SETCHANNEL_A_tne etc.
 .byt >sfxcom_SetPitch	;SETPITCH,PitchLo
 .byt >sfxcom_SetVolume	;SETVOLUME+15
 .byt >sfxcom_Play		;PLAY+49
 .byt >sfxcom_End_		;END_A_OFF etc.
 .byt >sfxcom_Jump		;JUMP,lo,hi
 .byt >sfxcom_AdjustVolume	;ADJUSTVOLUME-15 to ADJUSTVOLUME+15
 .byt >sfxcom_LoopOnVolume	;LOOPONVOLUMERANGE,offset
 .byt >sfxcom_LoopOnCounter	;LOOPONCOUNTERRANGE,offset
 .byt >sfxcom_SetNoise	;SETNOISE+31
 .byt >sfxcom_SetEnv		;SETENV,lo,hi
 .byt >sfxcom_TriggerCycle	;TRIGGER_SAWTOOTH etc.
 .byt >sfxcom_AdjustPitch	;ADJUSTPITCH-15
 .byt >sfxcom_End		;END_NORMAL
 .byt >sfxcom_SetNote	;SETNOTE,Note
 .byt >sfxcom_SetCounter	;SETCOUNTER+52


;000 SETCHANNEL_A
;001 SETCHANNEL_B
;002 SETCHANNEL_C
sfxcom_SetChannel 	;SETCHANNEL_A etc.
	sta sfx_CurrentChannel,x
	rts

;000 SETCHANNEL_A_tne
;001 SETCHANNEL_A_tnE
;002 SETCHANNEL_A_tNe
;003 SETCHANNEL_A_tNE
;004 SETCHANNEL_A_Tne
;005 SETCHANNEL_A_TnE
;006 SETCHANNEL_A_TNe
;007 SETCHANNEL_A_TNE
;008 SETCHANNEL_B_tne
;009 SETCHANNEL_B_tnE
;010 SETCHANNEL_B_tNe
;011 SETCHANNEL_B_tNE
;012 SETCHANNEL_B_Tne
;013 SETCHANNEL_B_TnE
;014 SETCHANNEL_B_TNe
;015 SETCHANNEL_B_TNE
;016 SETCHANNEL_C_tne
;017 SETCHANNEL_C_tnE
;018 SETCHANNEL_C_tNe
;019 SETCHANNEL_C_tNE
;020 SETCHANNEL_C_Tne
;021 SETCHANNEL_C_TnE
;022 SETCHANNEL_C_TNe
;023 SETCHANNEL_C_TNE
sfxcom_SetChannelFlags	;SETCHANNEL_A_tne etc.
	;Set Current Channel
	tay
	lda StatusCode,y
.(
	sta vector2+1
	tya
	and #1
	asl
	asl
	asl
	asl
	sta vector1+1
;	pha
	tya
	lsr
	lsr
	lsr
	sta sfx_CurrentChannel,x
	tay
;	;We must store here too so that if we overflow volume through rel steps we'll know its not EG flag
;	pla
;	sta ay_EnvelopeFlag,y
	;Write away Status Register
	lda ay_Status
	and StatusBitMask4Channel,y
vector2	ora #00
	sta ay_Status
	;Set Envelope
	lda ay_Volume,y
	and #15
vector1	ora #00
.)
	sta ay_Volume,y
	sec
	rts
	
StatusCode	;24
 .byt %00001001,%00001001,%00000001,%00000001,%00001000,%00001000,%00000000,%00000000
 .byt %00010010,%00010010,%00000010,%00000010,%00010000,%00010000,%00000000,%00000000
 .byt %00100100,%00100100,%00000100,%00000100,%00100000,%00100000,%00000000,%00000000
StatusBitMask4Channel
 .byt %11110110	;A
 .byt %11101101	;B
 .byt %11011011	;C

;027 SETPITCH,PitchLo
sfxcom_SetPitch	;SETPITCH,PitchLo
	lda (sfx),y
	cmp #RANDOM_HIGH
.(
	bne WriteAsPitch
	;Randomise Pitch High
	jsr GetRandomNumber
	and #31
;	adc #10
WriteAsPitch
.)
	ldy sfx_CurrentChannel,x
	sta ay_PitchLo,y
	sec
	rts

sfxcom_SetNote
	lda (sfx),y
	cmp #RANDOM_HIGH
.(
	bne WriteAsNote
	jsr GetRandomNumber
	and #127
WriteAsNote
.)
	;Split note into Semitone and Octave
	ldy #255
	sec
.(
loop1	iny
	sbc #12
	bcs loop1
	adc #12

	sty vector2+1
	tay
	lda BasePitchHi,y

	sta vector1+1
	lda BasePitchLo,y
vector2	ldy #00
	beq skip1
loop2	lsr vector1+1
	ror
	dey
	bne loop2
skip1	ldy sfx_CurrentChannel,x
	sta ay_PitchLo,y
vector1	lda #00
.)
	sta ay_PitchHi,y
	sec
	rts
	
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

	
	
	


;028 SETVOLUME+15
sfxcom_SetVolume	;SETVOLUME+15
	ldy sfx_CurrentChannel,x
	sta ay_Volume,y
	rts

;044 PLAY+49
sfxcom_Play		;PLAY+49
	cmp #00
.(
	bne skip1
	jsr GetRandomNumber
	and #7
	adc #2
skip1	sbc #1
	sta sfx_PlayPeriod,x
.)
	clc
	rts


;094 001 END_A_OFF
;095 010 END_B_OFF
;096 011 END_AB_OFF
;097 100 END_C_OFF
;098 101 END_AC_OFF
;099 110 END_BC_OFF
;100 111 END_ABC_OFF
;B0==A
;B1==B
;B2==C
sfxcom_End_		;END_A_OFF etc.
	tay
	iny
	tya
	and #1
.(
	beq skip1
	lda #00
	sta ay_Volume
skip1	tya
	and #2
	beq skip2
	lda #00
	sta ay_Volume+1
skip2	tya
	and #4
	beq skip3
	lda #00
	sta ay_Volume+2
skip3	sta sfx_Status,x
.)
	clc
	rts

;101 JUMP,lo,hi
sfxcom_Jump		;JUMP,lo,hi
	lda #00
	sta sfx_Index,x
	lda (sfx),y
	sta sfx_AddressLo,x
	pha
	iny
	lda (sfx),y
	sta sfx_AddressHi,x
	sta sfx+1
	pla
	sta sfx
	rts

;102 ADJUSTVOLUME-15 to ADJUSTVOLUME+15
sfxcom_AdjustVolume	;ADJUSTVOLUME-15 to ADJUSTVOLUME+15
	tay
	lda TwosCompliment32,y
.(
	sta vector1+1
	ldy sfx_CurrentChannel,x
	lda ay_Volume,y
	clc
vector1	adc #00
.)
	sta ay_Volume,y
	sec
	rts
TwosCompliment32
 .byt 241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
 .byt 0
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

;133 LOOPONVOLUMERANGE,offset	;Cannot Loop with EG flag set!
sfxcom_LoopOnVolume	;LOOPONVOLUMERANGE,offset
	lda (sfx),y
	sta sfxTemp1
	ldy sfx_CurrentChannel,x
	lda ay_Volume,y
	cmp #16

	bcs AbortLoop
PerformLoop
	lda sfxTemp1
	sta sfx_Index,x
	sec
	rts
AbortLoop	clc
	rts

;134 LOOPONCOUNTERRANGE,offset
sfxcom_LoopOnCounter	;LOOPONCOUNTERRANGE,offset
	lda (sfx),y
	sta sfxTemp1
	lda sfx_Counter,x
	beq AbortLoop
	dec sfx_Counter,x
	jmp PerformLoop

;135 SETNOISE+31
sfxcom_SetNoise	;SETNOISE+31
	sta ay_Noise
	rts
;167 SETENV,lo,hi
sfxcom_SetEnv		;SETENV,lo,hi
	lda (sfx),y
	sta ay_EGPeriodLo
	iny
	lda (sfx),y
	sta ay_EGPeriodHi
	rts
	
;168 TRIGGER_SAWTOOTH
;169 TRIGGER_TRIANGLE
;170 TRIGGER_DESCEND
;171 TRIGGER_ASCEND
sfxcom_TriggerCycle	;TRIGGER_SAWTOOTH etc.
	tay
	lda EGWaveCode,y
	sta ay_Cycle
	;And ensure this does trigger cycle (by setting reference wild)
	lda #128
	sta ayr_Cycle
	rts
EGWaveCode
 .byt 8	;168 TRIGGER_SAWTOOTH
 .byt 10	;169 TRIGGER_TRIANGLE
 .byt 0	;170 TRIGGER_DESCEND
 .byt 4	;171 TRIGGER_ASCEND

;172 ADJUSTPITCH-15
sfxcom_AdjustPitch	;ADJUSTPITCH-15
	tay
.(
	bne skip1
	;If adjust 0 then random adjust -32 to +31 but on 12 bit pitch
	jsr GetRandomNumber
	and #63
	sec
	sbc #32
	bmi Negative12BitPitchStep
	jmp Positive12BitPitchStep
skip1	lda TwosCompliment32,y
skip2	sta vector1+1
	ldy sfx_CurrentChannel,x
	lda ay_PitchLo,y
	clc
vector1	adc #00
	sta ay_PitchLo,y
	sec
	rts
Negative12BitPitchStep
	sta vector2+1
	ldy sfx_CurrentChannel,x
	lda ay_PitchLo,y
vector2	sbc #00
	sta ay_PitchLo,y
	lda ay_PitchHi,y
	sbc #00
	jmp skip3
Positive12BitPitchStep
	clc
	ldy sfx_CurrentChannel,x
	adc ay_PitchLo,y
	sta ay_PitchLo,y
	lda ay_PitchHi,y
	adc #00
skip3	and #15
.)
	sta ay_PitchHi,y
	sec
	rts

;203 END_NORMAL
sfxcom_End
	lda #00
	sta sfx_Status,x
	rts

;204 SETCOUNTER+51
sfxcom_SetCounter	;SETCOUNTER+52
	cmp #00
.(
	bne skip1
	jsr GetRandomNumber
	and #7
	clc
	adc #1
skip1	sta sfx_Counter,x
.)
	sec
	rts

