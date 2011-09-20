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

	; Set volume
	ldx #$f
	lda #8
	jsr SendAYReg
	ldx #$f
	lda #9
	jsr SendAYReg

	ldx #%01111100
	lda #7
	jsr SendAYReg

	ldx #0
	lda #$d
	jsr SendAYReg

	ldx #0
	lda #$b
	jsr SendAYReg

	ldx #0
	lda #$c
	jsr SendAYReg

	ldx #0
	lda #6
	jsr SendAYReg


loop
	ldy NoteCounter
	lda (tmp0),y
	bmi endplay
	beq restA
	jsr Note2Pitch
	ldx ay_Pitch_A_Low
	lda #0
	jsr SendAYReg
	ldx ay_Pitch_A_High
	lda #1
	jsr SendAYReg
restA
	ldy NoteCounter
	lda (tmp1),y
	beq restB
	jsr Note2Pitch
	ldx ay_Pitch_A_Low
	lda #2
	jsr SendAYReg
	ldx ay_Pitch_A_High
	lda #3
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
	; Set volume
	ldx #$0
	lda #8
	jsr SendAYReg
	lda #9
	jsr SendAYReg
	lda #10
	jsr SendAYReg
	cli
	jmp wait
.)



; A=regnumber X=value
SendAYReg
.(
	;Load the accumulator with the Register number and store in VIA Port A
    STA via_porta
	;Set AY Control lines to Register Number 
    LDA #ayc_Register
    STA via_pcr
	;Set AY Control lines to inactive 
    LDA #ayc_Inactive
    STA via_pcr
	;Place the Register value into VIA Port A
    STX via_porta
	;Set AY Control lines to Write 
    LDA #ayc_Write
    STA via_pcr
	;Set AY Control lines to inactive again 
    LDA #ayc_Inactive
    STA via_pcr
    RTS
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










