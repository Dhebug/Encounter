;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Sound and sfx routines
;; ----------------------

#define        via_portb                $0300 
#define        via_t1cl                $0304 
#define        via_t1ch                $0305 
#define        via_t1ll                $0306 
#define        via_t1lh                $0307 
#define        via_t2ll                $0308 
#define        via_t2ch                $0309 
#define        via_sr                  $030A 
#define        via_acr                 $030b 
#define        via_pcr                 $030c 
#define        via_ifr                 $030D 
#define        via_ier                 $030E 
#define        via_porta               $030f 

#define ayc_Register $FF
#define ayc_Write    $FD
#define ayc_Inactive $DD


#define AY_AToneLSB		0
#define AY_AToneMSB		1
#define AY_BToneLSB		2
#define AY_BToneMSB		3
#define AY_CToneLSB		4
#define AY_CToneMSB		5
#define AY_Noise		6
#define AY_Status		7
#define AY_AAmplitude	8
#define AY_BAmplitude	9
#define AY_CAmplitude	10
#define AY_EnvelopeLSB	11
#define AY_EnvelopeMSB	12
#define AY_EnvelopeCy	13
#define AY_IOPort		14

.zero
TimerCounter        .byt 0
NoteCounter		    .byt 0
ay_Pitch_A_High		.byt 0
ay_Pitch_A_Low		.byt 0
.text 


PlayTune
.(
	sei
	lda #<_TuneDataA
	sta tmp0
	lda #>_TuneDataA
	sta tmp0+1
	lda #<_TuneDataB
	sta tmp1
	lda #>_TuneDataB
	sta tmp1+1

	lda #0
	sta NoteCounter

	jsr InitSound

	; Set volume
	lda #$f
	ldx #8
	jsr SendAYReg
	lda #$f
	ldx #9
	jsr SendAYReg

loop
	ldy NoteCounter
	lda (tmp0),y
	bmi endplay
	beq restA
	jsr Note2Pitch
	lda ay_Pitch_A_Low
	ldx #0
	jsr SendAYReg
	lda ay_Pitch_A_High
	ldx #1
	jsr SendAYReg
restA
	ldy NoteCounter
	lda (tmp1),y
	beq restB
	jsr Note2Pitch
	lda ay_Pitch_A_Low
	ldx #2
	jsr SendAYReg
	lda ay_Pitch_A_High
	ldx #3
	jsr SendAYReg
restB	
	inc NoteCounter

	; Make a pause
	ldx #40*3
	ldy #0
loopp1
loopp2
	dey
	bne loopp2
	dex
	bne loopp1
	jmp loop

endplay
	jsr StopSound
	cli
	jmp wait
.)

StopSound
InitSound
.(
	ldx #<zeros
	ldy #>zeros
	jmp AYRegDump
zeros
	.byt 0,0,0,0,0,0,0,%01111000,0,0,0,0,0,0
.)

; X=regnumber A=value
SendAYReg
.(
	;Store register number VIA Port A
    stx via_porta
	pha
	;Set AY Control lines to Register Number 
    lda #ayc_Register
    sta via_pcr
	;Set AY Control lines to inactive 
    lda #ayc_Inactive
    sta via_pcr
	;Place the Register value into VIA Port A
	pla
    sta via_porta
	;Set AY Control lines to Write 
    lda #ayc_Write
    sta via_pcr
	;Set AY Control lines to inactive again 
    lda #ayc_Inactive
    sta via_pcr
    rts
.)



; Needs X and Y with the low and high bytes of the
; table with register values
AYRegDump
.(
	stx loop+1
	sty loop+2

    ldx #13
loop 
	lda $dead,x

	; Prevent anything nasty
	cpx #AY_Status
	bne skip
	ora #%01000000
skip
	jsr SendAYReg
  	dex
    bpl loop
    rts
.)


Note2Pitch
.(
        ;Convert Large Note to Octave(X) and 12 value Note(A) (Divide by 12)
        LDX #255
        SEC
  .(
  loop1 INX
        SBC #12
        BCS loop1
        ADC #12
        ;Fetch 12 Bit Base Note
        TAY
        LDA base_pitch_lo,Y
        STA ay_Pitch_A_Low
        LDA base_pitch_hi,Y
        ;Finish if Octave Zero
        CPX #00
        BEQ finish
        ;Shift up for Octave
  loop2 LSR
        ROR ay_Pitch_A_Low
        DEX
        BNE loop2
  finish
  .)
        STA ay_Pitch_A_High
        RTS 
.)



PlayBell
.(
	ldx #<Bell1
	ldy #>Bell1
	jsr AYRegDump
	jsr wait
	jsr wait
	ldx #<Bell2
	ldy #>Bell2
	jmp AYRegDump
Bell1
	.byt $35,0,$2e,0,0,0,0,%1111100,$10,$10,0,$70,$01,$8
Bell2
	.byt $35,0,$2e,0,0,0,0,%1111100,$10,$10,0,0,$04,0
.)






