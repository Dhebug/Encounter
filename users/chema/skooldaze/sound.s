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

#include "params.h"
#include "sound.h"

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

#ifdef USE_THREE_TUNES

PlayTuneC
	sei
	lda #<_Tune3DataA
	sta Song
	lda #>_Tune3DataA
	sta Song+1
	lda #<_Tune3DataB
	sta Song2
	lda #>_Tune3DataB
	sta Song2+1
	bne PlayTuneCommon

_Tune3DataA
	.byt 4*12+G_, 4*12+G_, 4*12+G_, 4*12+A_, 4*12+B_, 4*12+B_, 4*12+A_, 4*12+A_ 
	.byt 4*12+G_, 4*12+B_, 4*12+A_, 4*12+A_, 4*12+G_, 4*12+G_, 4*12+G_, RST
	.byt 4*12+G_, 4*12+G_, 4*12+G_, 4*12+A_, 4*12+B_, 4*12+B_, 4*12+A_, 4*12+A_ 
	.byt 4*12+G_, 4*12+B_, 4*12+A_, 4*12+A_, 4*12+G_, 4*12+G_, 4*12+G_, RST
	.byt 4*12+A_, 4*12+A_, 4*12+A_, 4*12+A_, 4*12+E_, 4*12+E_, 4*12+E_, 4*12+E_
	.byt 4*12+A_, 4*12+G_, 4*12+F_, 4*12+E_, 4*12+D_, 4*12+D_, 4*12+D_, RST
	.byt 4*12+G_, 4*12+G_, 4*12+G_, 4*12+A_, 4*12+B_, 4*12+B_, 4*12+A_, 4*12+A_
	.byt 4*12+G_, 4*12+B_, 4*12+A_, 4*12+A_, 4*12+G_, 4*12+G_, 4*12+G_, RST,$80

_Tune3DataB
	.byt 3*12+G_, 3*12+D_, 3*12+B_, 3*12+D_, 3*12+G_, 3*12+D_, 3*12+C_, 3*12+D_
	.byt 3*12+B_, 3*12+D_, 3*12+C_, 3*12+D_, 3*12+G_, 3*12+D_, 3*12+G_, 3*12+F_
	.byt 3*12+G_, 3*12+D_, 3*12+B_, 3*12+D_, 3*12+G_, 3*12+D_, 3*12+C_, 3*12+D_
	.byt 3*12+B_, 3*12+D_, 3*12+C_, 3*12+D_, 3*12+B_, 3*12+D_, 3*12+G_, RST
	.byt 3*12+C_, 3*12+D_, 3*12+C_, 3*12+B_, 3*12+A_, 3*12+B_, 3*12+C_, 3*12+A_
	.byt 3*12+DS_, 3*12+B_, 3*12+A_, 3*12+G_, 3*12+F_, 3*12+C_, 3*12+B_, 3*12+A_
	.byt 3*12+G_, 3*12+D_, 3*12+B_, 3*12+D_, 3*12+G_, 3*12+D_, 3*12+C_, 3*12+D_
	.byt 3*12+B_, 3*12+D_, 3*12+C_, 3*12+D_, 3*12+B_, 3*12+D_, 3*12+B_, RST

#endif

/*
G G G A | B(2) A(2) | G B A A | G(3) - | G G G A | B(2) A(2) | G B A A | G(3) - | 

A A A A | E(2) E(2) | A G F E | D(3) - | G G G A | B(2) A(2) | G B A A | G(3) - |

 There is an accompaniment: 

G D B D | G D C D | B D C D | G D G F | G D B D | G D C D | B D C D | B D G - | 

C D C B | A B C A | D# B A G | F C B A | G D B D | G D C D | B D C D | B D B/G - |

Read more: http://wiki.answers.com/Q/Where_can_you_get_notes_for_au_clarie_de_la_lune#ixzz1YbEKUZqp
*/



StopSound
InitSound
.(
	//jsr SendAYReg
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

//#ifdef 0
	; Prevent anything nasty
	cpx #AY_Status
	bne skip
	ora #%01000000
skip
//#endif
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
	lda audio_off
	bne end
	ldx #<Bell1
	ldy #>Bell1
	jsr AYRegDump
	jsr wait
	jsr wait
	ldx #<Bell2
	ldy #>Bell2
	jmp AYRegDump
end
	rts
.)

#define SFX_SHHIT		1
#define SFX_KNOCK		2
#define SFX_TWANG		3
#define SFX_STEP		4
#define SFX_HIT			5
#define SFX_LINES1		6
#define SFX_LINES2		7
#define SFX_SAFELETTER	8
#define SFX_PIC			9


SndHitShld
	lda #SFX_SHHIT
	.byt $2c
SndKnocked
	lda #SFX_KNOCK
	.byt $2c
SndHit
	lda #SFX_HIT
	.byt $2c
SndFire
	lda #SFX_TWANG
SndCommon
	sta Sfx
	jmp flash_border

SndPic
	lda #SFX_PIC
	.byt $2c
SndStep
	lda #SFX_STEP
	sta Sfx
	rts
	
SndLines1
	lda #SFX_LINES1
	sta Sfx
	jmp wait

SndLines2
	lda #SFX_LINES2
	.byt $2c

SndSafeLetter
	lda #SFX_LINES1	;#SFX_SAFELETTER
	sta Sfx
	jsr wait
	jmp StopSound



_safeletter
	;.byt 0,4,0,0,0,0,$ff,$78,10,0,0,2,0,$e


