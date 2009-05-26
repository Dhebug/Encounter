
; Space1999 Music & SFX (All Code and Data)

; Sound routines & data come after the game frame (frame.s), as specified in 
; osdk_config.bat. It is automatically added to the .bss section in the correct 
; addresses.
; This file is also #included when compiling overlay data and generating the 
; game disk.

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
#define EG02	3
;Missing DEC/INC Period and Noise
#define efx_End             	0
#define efx_ToneOn	    	1
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
#define efx_SetNoiseRandom 	136
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


 .zero
;*=$00
;Music ZP Starts here..
irq_source		.dsb 2
MusicTempoCount		.dsb 1	;Effect Tempo fixed at 100hz
PatternNotePeriod	.dsb 3
irqTemp02		.dsb 1
irqTemp03		.dsb 1
irqTemp04		.dsb 1
;Effect ZP starts here..
EffectSource		.dsb 2
EffectTemp01		.dsb 1
EffectTemp02		.dsb 1

#ifdef 0
;Music ZP Starts here..
#define irq_source		    $f3
#define MusicTempoCount	    $f5     ;Effect Tempo fixed at 100hz
#define PatternNotePeriod	$f6
#define irqTemp02		    $f9
#define irqTemp03		    $fa
#define irqTemp04		    $fb
;Effect ZP starts here..
#define EffectSource		$fc
#define EffectTemp01		$fe
#define EffectTemp02		$ff


.zero

#endif

irq_A               .byt 0
irq_X               .byt 0
irq_Y               .byt 0
_TimerCounter        .byt 40        ;Slows key read to 25Hz 
_KeyCode             .dsb 1        ;The _KeyCode 


.text 

irqsav .dsb 2



_PlayMainTune
         lda #%10000000
         jmp PlayAudio

_StopMusic
        lda #0
        jmp PlayAudio




_restore_irq
	sei
	lda irqsav
	;sta $0245
	sta $fffe
	lda irqsav+1
	;sta $0246
	sta $ffff
	cli
	rts

_init_irq_routine 
        ;Since we are starting from when the standard irq has already been 
        ;setup, we need not worry about ensuring one irq event and/or right 
        ;timer period, only redirecting irq vector to our own irq handler. 
        sei
	    ;lda $0245
		lda $fffe
	    sta irqsav
        lda #<irq_routine 
        ;sta $0245        ;When we disable rom, we should change this to $fffe 
        sta $fffe
	    ;lda $0246
		lda $ffff
	    sta irqsav+1
        lda #>irq_routine 
        ;sta $0246        ;When we disable rom, we should change this to $ffff 
        sta $ffff

        ;Turn off music and sfx
    	lda #128
    	sta MusicStatus
    	;sta EffectNumber
    	;sta EffectNumber+1
    	;sta EffectNumber+2

        cli 
        rts 

;The IRQ routine will run (Like Oric) at 100Hz. 
irq_routine 
        sei
        ;Preserve registers 
      	sta irq_A
    	stx irq_X
    	sty irq_Y

        ;Protect against Decimal mode 
        cld 

        ;Clear IRQ event 
        lda via_t1cl 

    	;Process Music
    	jsr ProcMusic
 
        ;Process timer event 
        dec _TimerCounter 
.( 
        lda _TimerCounter 
        and #3        ;Essentially, every 4th irq, call key read 
        bne skip1 
        ;Process keyboard 
        jsr proc_keyboard 

skip1
.) 
        ;Restore Registers 
        lda irq_A
    	ldx irq_X
    	ldy irq_Y

        ;End of IRQ 
        cli
        rti 

proc_keyboard 
        ;Setup ay to point to column register 
        ;Note that the write to the column register cannot simply be permanent 
        ;(Which would reduce amount of code) because some orics freeze(crash). 
        lda #$0E        ;AY Column register 
        sta via_porta 
        lda #$FF 
        sta via_pcr 
        ldy #$dd 
        sty via_pcr 

        ;Scan for ESC key pressed 
.( 
        lda via_portb
	    and #%11111000
        ;lda #1      ; Row for ESC key
        ora #1
        sta via_portb 
        lda #$df    ; Column for ESC key
        sta via_porta 
        lda #$fd 
        sta via_pcr 
        sty via_pcr 
        ;Whilst not needed on Euphoric, this time delay is required for 
        ;some Real Orics otherwise no key will be returned! 
        ;We should use this time for something else if given an oppertunity 
        nop 
        nop 
        nop 
        nop 

        lda via_portb 
        and #08 
        bne skip1 
        rts 
skip1 
.) 
		ldx #0
		txs
		cli
		jmp _launch_game


;Row and column tables for Z,X,M,B,T,-,=,CTRL and ESC 
;KeyRow 
; .byt 2,0,2,2,1,3,7,2,1 
;KeyColumn 
; .byt $df,$bf,$fe,$fb,$fd,$f7,$7f,$ef,$df


;>>>> Call here
;Load Accumulator with the following Bits before calling PlayAudio
;Bit 0-1 Forms value 0-3
;        0 Assign Music to Track specified in Data
;	 1 Assign Effect specified in Data to Channel A
;        2 Assign Effect specified in Data to Channel B
;        3 Assign Effect specified in Data to Channel C
;Bit 2-6 Forms value 0-31
;        0-31 Data
;Bit 7-7 Forms value 0-1
;	 0 Stop Effect on specified Channel or Track
;	 1 Start Effect on specified Channel or Track
PlayAudio
	sta paTemp01
	and #03
	beq ControlMusic

#ifdef 0
	tax
	lda paTemp01
	lsr
	lsr
	cmp #32
	and #31
	bcc StopEffect
StartEffect
	;
	tay
	lda Channel_SFX_NoteHeaders,y
	dex
	sta EffectNote,x
	sty EffectTemp02
	jsr CalcAndStorePitch
	ldy EffectTemp02
	lda Channel_SFX_EffectAndEGHeaders,y	;0-1 EG / 2-6 Effect
	lsr
	lsr
	sta EffectNumber,x
	lda #00
	sta EffectIndex,x
	sta FilterIndex,x
	;Disable Sample and Ornaments on this channel
	lda #128
	sta SampleProperty,x
	sta OrnamentProperty,x

	lda Channel_SFX_EffectAndEGHeaders,y
	and #03
.(
	beq skip1	;No EG Setting
	tay
	lda EGValue-1,y
	sta AY_EGPeriodLo
skip1	rts
.)
StopEffect
	lda #128
	sta EffectNumber-1,x
	lda #00
	sta AY_Volume-1,x
	rts
#endif

ControlMusic
	;Data holds index
	lda paTemp01
	lsr
	lsr
	and #31
	tax
	lda paTemp01
.(
	bpl StopMusic
	sei
	sta TrackLoop	;Default Loop Off
	ldy EventStart,x
	sty EventIndex
	lda TrackProperty,x	;B7==Loop B0-4==Music Tempo
	bpl skip1
	sty TrackLoop
skip1	and #63
	STA MusicTempoCount
	sta MusicTempoReference
	lda EventEnd,x
	sta EndEvent
	lda TrackChannels,x
	sta TracksChannelsUsed

	;Enable all channels
	lda #%01111000
	sta AY_Status

	;And start music
	lda #00
	sta MusicStatus
	jsr ProcEvents
	ldx #2
loop1	jsr ProcPattern
	dex
	bpl loop1
	cli
	rts

StopMusic
.)
	lda #128
	sta MusicStatus
	;Silence channels that the music used
	ldx #02
.(
loop1	lda #128
	sta SampleProperty,X
	sta OrnamentProperty,X
	lsr TracksChannelsUsed
	bcc skip1
	lda #00
	sta AY_Volume,x
skip1	dex
	bpl loop1
.)
	rts

;*********** Music Routines start here ******************

MaximumVolume 
 .byt 0   ;0(Loud)-15(Mute)

ProcMusic
	dec MusicTempoCount
.(
	bne skip4	;28DA
	lda MusicTempoReference
	sta MusicTempoCount
	lda MusicStatus
	bmi SendAY	;28F7
skip1	ldx #2		;Process Delays
loop2	;Add Pattern Rest Check
	lda PatternRest,x
	bmi skip2
	dec PatternNotePeriod,x
	bne skip2	;28C7
	jsr ProcPattern
	lda MusicStatus
	bne skip3	;28CA
skip2	dex
	bpl loop2	;28BB

skip3	lda MusicStatus
	lsr
	bcc skip4	;28DA
	asl
	sta MusicStatus
	jsr ProcEvents	;ProcEvents
	jmp skip1
skip4	ldx #$02
loop3	lda SampleProperty,X
	bmi skip5	;28EC
	jsr ProcSample	;ProcSample
skip5	lda OrnamentProperty,X
	bmi skip6	;28F4
	jsr ProcOrnament	;Process Ornaments
skip6	dex
	bpl  loop3	;28E4
.)


ControlMaximumVolume 
        ldx #02 
.( 
loop1   lda ReferenceBank+8,x 
        cmp RegisterBank+8,x 
        beq skip2 
        lda AY_Volume,x 
        sec 
        sbc MaximumVolume 
        bcs skip1 
        lda #00 
skip1   sta AY_Volume,x 
skip2   dex 
        bpl loop1 
.)

;Expand SendAY
; 1)include EG
; 2)Pitch Registers are indexed
; 3)Reference Bank avoids sending same value twice
SendAY	ldy #$0D
.(
loop1	ldx RegisterPointer,y
	lda RegisterBank,x
	cmp ReferenceBank,x
	beq skip1
	sta ReferenceBank,x
	sty via_porta
	ldx #pcr_Register
	stx via_pcr
	ldx #pcr_Disabled
	stx via_pcr
	sta via_porta
	lda #pcr_Value
	sta via_pcr
	stx via_pcr
skip1	dey
	bpl loop1
.)

	rts

ProcPattern
	LDA RuntimePatternBaseLo,X
	STA irq_source
	LDA RuntimePatternBaseHi,X
	STA irq_source+1
	LDY RuntimePatternIndex,X
	LDA (irq_source),Y
	PHP
	AND #127
	CMP #126

	BCS mskip1	; 2968
	ADC RuntimePatternNoteOffset,X	;Note Offset
	STA RuntimeNote,X
	LDA #0
	STA SampleIndex,x
	STA OrnamentIndex,x
	INY
	LDA (irq_source),Y
	LSR
	LSR
	LSR
	LSR
	STA OrnamentProperty,X	;Ornament Number
	LDA (irq_source),Y
	AND #$0F
	PLP
	BPL mskip2 	;295B
	STA AY_Volume,X
	LDA #$80
mskip2	STA SampleProperty,X
	LDA #$01
Routine2960
	STA PatternNotePeriod,X
	INY
Routine2963
	TYA
	STA RuntimePatternIndex,X
	RTS
mskip1
	BNE mskip3	; 2971
	PLP
	INY
	LDA (irq_source),Y
	JMP Routine2960
mskip3

	PLP
	LDA #$01
	STA PatternNotePeriod,X
	LDA MusicStatus
	ORA #$01
	STA MusicStatus
	JMP Routine2963

ProcOrnament	;Ornament
	;A is Ornament Number
	tay
	lda OrnamentAddressTableLo,y
	sta irq_source
	lda OrnamentAddressTableHi,y
	sta irq_source+1
mloop10	LDY OrnamentIndex,x
	LDA (irq_source),Y
	BEQ Routine29C7
	cmp #03	;$03 is flag to loop to start
	bne mskip10
	lda #00
	sta OrnamentIndex,X
	jmp mloop10
mskip10	LSR
	BCS Routine29D7
	LSR
	BCS Routine29AA
	;Note?
	ADC RuntimeNote,X
	JMP Routine29B1
Routine29AA
	STA irqTemp02
	LDA RuntimeNote,X
	SBC irqTemp02
Routine29B1
	JSR Routine2AE2
	;Resultant pitch in A(Lo) and irq_source(Hi)
	sta AY_PitchLo,x
	lda irq_source
	sta AY_PitchHi,x
Routine29B9
	INY
	TYA
	STA OrnamentIndex,X
	RTS
Routine29C7
	CPY #$00
	BNE Routine29D1
	LDA RuntimeNote,X
	JSR Routine29B1
Routine29D1
	LDA #$80
	STA OrnamentProperty,X
	RTS
Routine29D7	;Pitch
	LSR
	PHP
	STA irqTemp04
	LDA RuntimeNote,X
	JSR Routine2AE2
	PLP
	BCS Routine29F0
	ADC irqTemp04
	sta AY_PitchLo,x
	LDA irq_source
	ADC #$00
	sta AY_PitchHi,x
	JMP Routine29B9
Routine29F0
	SBC irqTemp04
	sta AY_PitchLo,x
	LDA irq_source
	SBC #$00
	sta AY_PitchHi,x
	JMP Routine29B9

ProcSample	;Sample (A==SampleNum?)
	tay
	lda SampleAddressTableLo,y
	sta irq_source
	lda SampleAddressTableHi,y
	sta irq_source+1
	LDY SampleIndex,X
	LDA (irq_source),Y
	BEQ Routine2A55
	PHA
	AND #$0F
	STA AY_Volume,X
	PLA
	LSR
	LSR
	LSR
	AND #$1E
	STA AY_Noise
	BEQ Routine2A46
	JSR Routine2A5B
	EOR #$FF
	AND AY_Status
	JMP Routine2A4C
Routine2A46
	JSR Routine2A5B
	ORA AY_Status
Routine2A4C
	STA AY_Status
	INY
	TYA
	STA SampleIndex,X
	RTS
Routine2A55
	LDA #$80
	STA SampleProperty,X
	RTS
Routine2A5B
	LDA #$04
	STX irqTemp02
Routine2A5F
	ASL
	DEX
	BPL Routine2A5F
	LDX irqTemp02
	RTS

ProcEvents
	LDX #$02
	LDA #$00
Routine2A6A
	STA RuntimePatternIndex,X
	DEX
	BPL Routine2A6A
;	DEC EventRowRepeats
;	BMI Routine2A76
;	RTS
Routine2A76
	LDX EventIndex
	LDA Event_A_Pats,X
	sta PatternRest
	AND #$1F
	TAY
	LDA Table33A4,Y
	STA RuntimePatternBaseLo
	LDA Table33AC,Y
	STA RuntimePatternBaseHi
	LDA Event_A_NOFS,X
	AND #$7F
	STA RuntimePatternNoteOffset

	LDA Event_B_Pats,X
	sta PatternRest+1
	AND #$1F
	TAY
	LDA Table33B4,Y
	STA RuntimePatternBaseLo+1
	LDA Table33BC,Y
	STA RuntimePatternBaseHi+1
	LDA Event_B_NOFS,X
	AND #$7F
	STA RuntimePatternNoteOffset+1

	LDA Event_C_Pats,X
	sta PatternRest+2
	AND #$1F
	TAY
	LDA Table33C4,Y
	STA RuntimePatternBaseLo+2
	LDA Table33CC,Y
	STA RuntimePatternBaseHi+2
	LDA Event_C_NOFS,X
	AND #$7F
	STA RuntimePatternNoteOffset+2
	INX
	CPX EndEvent	;#$0B
	BCC Routine2ADE
	;Handle Looping
	lda TrackLoop
	bmi mskip99
	sta EventIndex
	rts

mskip99	LDA MusicStatus
	ORA #$80
	STA MusicStatus
Routine2ADE
	STX EventIndex
	RTS
Routine2AE2
	STX irqTemp02
	LDX #$FF
	SEC
	SBC #$40
	BCC Routine2B0B
Routine2AEB
	INX
	SBC #$0C
	BCS Routine2AEB
	STX irqTemp03
	ADC #$0C
	TAX
	LDA BasePitchHi,X
	STA irq_source
	LDA BasePitchLo,X
	LDX irqTemp03
	BEQ Routine2B07
Routine2B01
	LSR irq_source
	ROR
	DEX
	BNE Routine2B01
Routine2B07
	LDX irqTemp02
	CLC
	RTS
Routine2B0B
	LDA #$00
	STA irq_source
	LDX irqTemp02
	RTS

;******************* Effect Code Starts here ************************
#ifdef 0
ProcEffect
	ldx #02
.(
loop3	ldy EffectNumber,x
	bmi skip2
	lda PauseDelay,x
	beq skip3
	dec PauseDelay,x
	jmp skip2

skip3	lda EffectBaseAddressLo,y
	sta EffectSource
	lda EffectBaseAddressHi,y
	sta EffectSource+1
loop2	ldy EffectIndex,x
	lda (EffectSource),y
	ldy #24
loop1	cmp EffectCodeThreshhold,y
	bcs skip1
	dey
	bpl loop1
skip1	sbc EffectCodeThreshhold,y
	pha
	lda EffectCodeVectorLo,y
	sta vector1+1
	lda EffectCodeVectorHi,y
	sta vector1+2
	pla
	clc
vector1	jsr $dead
	inc EffectIndex,x
	bcs skip2
	jmp loop2
skip2	dex
	bpl loop3
.)
	;Now Process Effect Pitch
	ldx #02
.(
loop1   ldy FilterIndex,x
        beq skip3
	lda EffectPitchLo,x
        and FilterMask-1,y
	sta AY_PitchLo,x
        lda #00
        sta AY_PitchHi,x
	jmp skip1
	;Store Pitch
skip3	lda EffectPitchLo,x
	sta AY_PitchLo,x
	lda EffectPitchHi,x
	sta AY_PitchHi,x
skip1	dex
	bpl loop1
.)
	rts

efxc_End             ;00 000(1)
	lda #128
	sta EffectNumber,x
	sec	;Wait indefinately
	rts
efxc_ToneOn	    ;01 001(1)
	lda AY_Status
	and ToneMask,x
	sta AY_Status
	rts
efxc_ToneOff         ;02 002(1)
	lda AY_Status
	ora ToneBit,x
	sta AY_Status
	rts
efxc_NoiseOn         ;03 003(1)
	lda AY_Status
	and NoiseMask,x
	sta AY_Status
	rts
efxc_NoiseOff        ;04 004(1)
	lda AY_Status
	ora NoiseBit,x
	sta AY_Status
	rts
efxc_EnvelopeOn      ;05 005(1)
	lda AY_Volume,x
	ora #16
	sta AY_Volume,x
	rts
efxc_EnvelopeOff     ;06 006(1)
	lda AY_Volume,x
	and #15
	sta AY_Volume,x
	rts
efxc_SetAbsoluteMode ;07 007(1)
	lda #01
	sta AbsoluteMode,x
	rts
efxc_SetNoiseRandom
	jsr getrand2
	and #31
	sta AY_Noise
	rts
efxc_IncVolume       ;13 137(1)
	inc AY_Volume,x
	rts
efxc_DecVolume       ;14 138(1)
	dec AY_Volume,x
	rts
efxc_Volume          ;17 141(16)
	sta AY_Volume,x
	rts
efxc_SetEnvTriangle  ;18 157(1)
	lda #10
	sta AY_EGCycle
	rts
efxc_SetEnvSawtooth  ;19 158(1)
	lda #12
	sta AY_EGCycle
	rts
efxc_SetCounter 	    ;22 185(20)
	sta EffectCounter,x
	rts
efxc_Pause 	    ;23 205(50)
	sta PauseDelay,x
	sec	;Wait on Pause
	rts
efxc_IncPitch        ;08 008(32)
	sta PitchOffset
	;Inc Pitch Relative
	lda EffectPitchLo,x
	clc
	adc PitchOffset
	sta TempPitchLo
	lda EffectPitchHi,x
	adc #00
	and #15
	sta TempPitchHi
	jmp efxc_PitchSort


efxc_DecPitch        ;09 040(32)
	sta PitchOffset
	;Inc Pitch Relative
	lda EffectPitchLo,x
	sec
	sbc PitchOffset
	sta TempPitchLo
	lda EffectPitchHi,x
	sbc #00
	and #15
	sta TempPitchHi
efxc_PitchSort
	;Support Relative & Absolute Modes
	ldy AbsoluteMode,x
.(
	beq skip1
	lda TempPitchLo
	sta EffectPitchLo,x
	lda TempPitchHi
	sta EffectPitchHi,x

skip1
.)
	clc
	rts


efxc_IncNote         ;10 072(32)
	sta NoteOffset
	;Inc Note Relative
	lda EffectNote,x
	clc
	adc NoteOffset
	;Support Relative & Absolute Modes
	ldy AbsoluteMode,x
.(
	beq skip1
	sta EffectNote,x
skip1	jmp CalcAndStorePitch	;Store also to EffectPitchLo and Hi
.)

efxc_DecNote         ;11 104(32)
	sta NoteOffset
	;Dec Note Relative
	lda EffectNote,x
	sec
	sbc NoteOffset
	;Support Relative & Absolute Modes
	ldy AbsoluteMode,x
.(
	beq skip1
	sta EffectNote,x
skip1	jmp CalcAndStorePitch
.)

efxc_SkipZeroPitch
	ldy #00
	lda AY_PitchLo,x
	jmp SkipZeroCountRent
efxc_SkipZeroVolume  ;15 139(1)
	lda AY_Volume,x
	ldy #00
	and #15
	jmp SkipZeroCountRent
efxc_SkipZeroCount   ;16 140(1)
	ldy #00
	lda EffectCounter,x
SkipZeroCountRent
.(
	bne skip1
	ldy #01
skip1	tya
.)
	sta SkipLoopFlag,x
	rts
efxc_LoopRow 	    ;21 163(22)
	sta EffectTemp01
	;Count counter
	lda EffectCounter,x
.(
	beq skip2
	dec EffectCounter,x
skip2	lda SkipLoopFlag,x
	bne skip1
	lda EffectIndex,x
	sec
	sbc EffectTemp01
	sta EffectIndex,x
	dec EffectIndex,x
	;On a loop, disable any transient sample/ornament flags
	lda #128
	sta SampleProperty,x
	sta OrnamentProperty,x
	clc
skip1	lda #00
	sta SkipLoopFlag,x
	rts
.)

efxc_FilterFrequency ;20 159(4)
	;Need to check original code (possibly latest)
	sta FilterIndex,x
	rts

random2
.word  $3611
temprand
.byt $00
getrand2
         lda random2+1
         sta temprand
         lda random2
         asl
         rol temprand
         asl
         rol temprand

         clc
         adc random2
         pha
         lda temprand
         adc random2+1
         sta random2+1
         pla
         adc #$11
         sta random2
         lda random2+1
         adc #$36
         sta random2+1
         rts

CalcAndStorePitch	;Store also to EffectPitchLo and Hi
	;Note in "A" - Use Routine2AEB (Sonix routine)
	ldy #255
.(
loop1	iny
	sbc #$0C
	bcs loop1
	sty irqTemp03
	adc #$0C
	tay
	lda BasePitchHi,y
	sta irq_source
	lda BasePitchLo,y
	ldy irqTemp03
	beq skip1
loop2	lsr irq_source
	ror
	dey
	bne loop2
skip1	;A==Low  irq_source==High
.)
	sta EffectPitchLo,x
	lda irq_source
	sta EffectPitchHi,x
	rts

#endif

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
#ifdef 0

Channel_SFX_NoteHeaders
 .byt NoteG+12*7    ;A  00
 .byt NoteC+12*1    ;   01
 .byt NoteC+12*2    ;   02
 .byt NoteC+12*6    ;   03
 .byt NoteC+12*3    ;   04
 .byt NoteF+12*9    ;   05
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
 .byt NoteC+12*0    ;   18
 .byt NoteC+12*5    ;   19
 .byt NoteG+12*7    ;   20
 .byt NoteG+12*7    ;   21
 .byt NoteG+12*3    ;   22

Channel_SFX_EffectAndEGHeaders
 .byt hEffectV		 ;A  00  Switch
 .byt hEffectU           ;   01 Door Opening/Closing
 .byt hEffectT           ;   02 Pick up
 .byt hEffectS           ;   03 Drop
 .byt hEffectR           ;   04 Step #1 (Keonig)
 .byt hEffectR           ;   05 Step #2 (Carter)
 .byt hEffectH+EG20      ;   06 Lift Start
 .byt hEffectG+EG20      ;   07 Lift End
 .byt hEffectE+EG09      ;   08 Alarm #1 (Power Down)

 .byt hEffectQ           ;B  09 Effect #1 (InfoPost)
 .byt hEffectP           ;   10 New Msg through Commlink
 .byt hEffectO           ;   11 Effect #2 (InfoPost)
 .byt hEffectN           ;   12 Computer Room #1
 .byt hEffectM           ;   13 Computer Room #2
 .byt hEffectP           ;   14 Beep for Info Messages in Text Area
 .byt hEffectF           ;   15 Robot Shuffle
 .byt hEffectD+EG20      ;   16 Alarm #2

 .byt hEffectL           ;C  17 Dying
 .byt hEffectK+EG20      ;   18 Contact with Enemy #2
 .byt hEffectK+EG02      ;   19 Contact with Enemy #1(Primary)
 .byt hEffectJ           ;   20 Alarm #3 (Life Support Circuit Open)
 .byt hEffectI           ;   21 Alarm #3 End

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
 .byt efx_EnvelopeOn
 .byt efx_Pause+18
 .byt efx_EnvelopeOff
 .byt efx_Pause+7
 .byt efx_EnvelopeOn
 .byt efx_Pause+9
 .byt efx_EnvelopeOff
 .byt efx_Pause+36
 .byt efx_EnvelopeOn
 .byt efx_Pause+18
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
 .byt efx_LoopRow+11	;To row 4
EffectF	;16
 .byt efx_ToneOff
 .byt efx_EnvelopeOff
 .byt efx_NoiseOn
 .byt efx_SetCounter+6
 .byt efx_Volume+0
 .byt efx_IncVolume
 .byt efx_Pause+1
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+3
 .byt efx_DecVolume
 .byt efx_Pause+1
 .byt efx_SkipZeroVolume
 .byt efx_LoopRow+3
 .byt efx_End
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
 .byt efx_EnvelopeOn
 .byt efx_SetAbsoluteMode
 .byt efx_SetCounter+8
 .byt efx_SetEnvTriangle
 .byt efx_IncNote+5
 .byt efx_Pause+1
 .byt efx_SetEnvSawtooth
 .byt efx_IncNote+9
 .byt efx_Pause+1
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+7
 .byt efx_EnvelopeOff
 .byt efx_End
EffectL	;16	Decreasing pitch and volume
 .byt efx_ToneOn
 .byt efx_NoiseOff
 .byt efx_EnvelopeOff
 .byt efx_Volume+15
 .byt efx_SetAbsoluteMode
 .byt efx_SetCounter+15
 .byt efx_Pause+2
 .byt efx_IncPitch+1
 .byt efx_SkipZeroCount
 .byt efx_LoopRow+3	;6
 .byt efx_DecPitch+7
 .byt efx_DecVolume
 .byt efx_SkipZeroVolume
 .byt efx_LoopRow+8
 .byt efx_End
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
 .byt efx_SetNoiseRandom
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
 .byt 20,9,2
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
EffectCodeVectorLo
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
 .byt <efxc_SetNoiseRandom
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
 .byt >efxc_SetNoiseRandom
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
 .byt >efxc_SkipZeroPitch
FilterIndex
 .byt 0,0,0
FilterMask
 .byt 7         ;1
 .byt 15        ;2
 .byt 31        ;3
 .byt 127       ;4
EndOfAll



#endif


