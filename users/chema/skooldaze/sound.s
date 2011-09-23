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

.text 


PlayTuneA
	sei
	lda #<_TuneDataA
	sta Song
	lda #>_TuneDataA
	sta Song+1
	lda #<_TuneDataB
	sta Song2
	lda #>_TuneDataB
	sta Song2+1
PlayTuneCommon
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

	cli
	rts
PlayTuneB
	sei
	lda #<_Tune2DataA
	sta Song
	lda #>_Tune2DataA
	sta Song+1
	lda #<_Tune2DataB
	sta Song2
	lda #>_Tune2DataB
	sta Song2+1
	bne PlayTuneCommon

/*
_Tune2DataA
	.byt 5*12+G_, 5*12+G_, 5*12+G_, 5*12+A_, 5*12+B_, 5*12+B_, 5*12+A_, 5*12+A_ 
	.byt 5*12+G_, 5*12+B_, 5*12+A_, 5*12+A_, 5*12+G_, 5*12+G_, 5*12+G_, RST
	.byt 5*12+G_, 5*12+G_, 5*12+G_, 5*12+A_, 5*12+B_, 5*12+B_, 5*12+A_, 5*12+A_ 
	.byt 5*12+G_, 5*12+B_, 5*12+A_, 5*12+A_, 5*12+G_, 5*12+G_, 5*12+G_, RST 

A A A A | E(2) E(2) | A G F E | D(3) - | G G G A | B(2) A(2) | G B A A | G(3) - |
There is an accompaniment: 

G D B D | G D C D | B D C D | G D G F | G D B D | G D C D | B D C D | B D G - | 

C D C B | A B C A | D# B A G | F C B A | G D B D | G D C D | B D C D | B D B/G - |

Read more: http://wiki.answers.com/Q/Where_can_you_get_notes_for_au_clarie_de_la_lune#ixzz1YbEKUZqp
*/



StopSound
InitSound
.(
	ldx #<zeros
	ldy #>zeros
	jmp AYRegDump
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
.)

#define SFX_SHHIT		1
#define SFX_KNOCK		2
#define SFX_TWANG		3
#define SFX_STEP		4
#define SFX_HIT			5
#define SFX_LINES1		6
#define SFX_LINES2		7
#define SFX_SAFELETTER	8


SndHitShld
	lda #SFX_SHHIT
	.byt $2c
SndKnocked
	lda #SFX_KNOCK
	.byt $2c
SndHit
	lda #SFX_HIT
	.byt $2c
SndStep
	lda #SFX_STEP
	.byt $2c
SndFire
	lda #SFX_TWANG
	.byt $2c
SndLines1
	lda #SFX_LINES1
	.byt $2c
SndLines2
	lda #SFX_LINES2
	.byt $2c
SndSafeLetter
	lda #SFX_SAFELETTER
SndCommon
	sta Sfx
	rts






