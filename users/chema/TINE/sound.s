; sound file


; Routine for dumping registers to AY

#define ayc_Register $FF
#define ayc_Write    $FD
#define ayc_Inactive $DD
     
#define via_pcr      $030C
#define via_porta    $030F    


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

#ifdef 0
AYRegDump
.(
	sei

    LDX #13
loop 
	LDA RegisterBlock,X
	cpx #13
	beq skip2
    CMP ReferenceBlock,X
    BEQ skip
skip2
    STA ReferenceBlock,X
    STX via_porta
    LDY #ayc_Register
    STY via_pcr
    LDY #ayc_Inactive
    STY via_pcr
    STA via_porta  
    LDA #ayc_Write
    STA via_pcr
    STY via_pcr
skip
	DEX
    BPL loop
	
	cli
    RTS
.)
		 
		 
RegisterBlock
	.dsb 7,0
	.byt %1110000
	.byt $10
	.dsb 5,0
ReferenceBlock
	.dsb 14,128


InitSound
.(
	jmp AYRegDump
.)

SndExplosion
.(
	ldx #AY_Noise
	lda #%00010
	sta RegisterBlock,x
	ldx #AY_EnvelopeMSB
	lda #$28
	sta RegisterBlock,x
	jmp AYRegDump

.)


SndShoot

SndHit
.(
	ldx #AY_EnvelopeMSB
	lda #$05
	sta RegisterBlock,x
	jmp AYRegDump
.)

SndHitNoShields
.(
  	ldx #AY_AToneMSB
	lda #2
	sta RegisterBlock,x
	ldx #AY_EnvelopeMSB
	lda #$05
	sta RegisterBlock,x
	jsr AYRegDump
  	ldx #AY_AToneMSB
	lda #0
	sta RegisterBlock,x
	rts
.)

#else

; Needs X and Y with the low and high bytes of the
; table with register values
AYRegDump
.(
	sei
	stx loop+1
	sty loop+2

    LDX #13
loop 
	LDA $dead,X
	cpx #13
	beq skip2
    CMP ReferenceBlock,X
    BEQ skip
skip2
    STA ReferenceBlock,X
    STX via_porta
    LDY #ayc_Register
    STY via_pcr
    LDY #ayc_Inactive
    STY via_pcr
    STA via_porta  
    LDA #ayc_Write
    STA via_pcr
    STY via_pcr
skip
	DEX
    BPL loop
	
	cli
    RTS
.)
		 
ReferenceBlock
	.dsb 14,128


InitSound
.(
	;jmp AYRegDump
	rts
.)

SndExplosion
.(
	ldx #<explosion
	ldy #>explosion
	jmp AYRegDump
explosion
	;.byt 0,0,0,0,0,0,%00010,%1110000,$10,$0,$0,0,$28,0
	.byt 0,$4,0,$4,0,$6,$18,$40,$10,$10,$10,0,$20,0
.)


SndCrash
.(
	ldx #<crash
	ldy #>crash
	jmp AYRegDump
crash
	.byt 0,1,0,2,0,3,$2,$40,$10,$10,$10,0,4,0
.)

SndShoot
.(
	ldx #<shoot
	ldy #>shoot
	jmp AYRegDump
shoot
	.byt $1d,0,$15,0,$10,0,0,$40,$10,$10,$10,$a0,0,$4

.)

SndHit
.(
	ldx #<hit
	ldy #>hit
	jmp AYRegDump
hit
	.byt 0,0,0,0,0,0,%00010,%1110000,$10,$0,$0,0,$05,0
.)

SndHitNoShields
.(
  	ldx #<hit
	ldy #>hit
	jmp AYRegDump
hit
	.byt 0,2,0,0,0,0,%00010,%1110000,$10,$0,$0,0,$05,0
.)

SndSelect
.(
  	ldx #<sel
	ldy #>sel
	jmp AYRegDump
sel
	.byt $18,1,0,0,$18,1,0,$78,$10,0,$10,0,$02,0
.)

SndPic
.(
  	ldx #<pic
	ldy #>pic
	jmp AYRegDump
pic
	.byt $b,0,0,0,0,0,0,$78,$10,0,0,0,$01,0
.)

SndPoc
.(
  	ldx #<pic
	ldy #>pic
	jmp AYRegDump
pic
	.byt $10,0,0,0,0,0,0,$78,$10,0,0,0,$01,0
.)

SndPocLow
.(
  	ldx #<pic
	ldy #>pic
	jmp AYRegDump
pic
	.byt $d,2,0,0,0,0,0,$78,$10,0,0,0,$01,0
.)

SndMsg
.(
  	ldx #<msg
	ldy #>msg
	jmp AYRegDump
msg
	.byt $10,0,$19,0,$28,0,0,$78,$10,$10,$10,0,$01,0

.)


SndBell1
.(
  	ldx #<bell
	ldy #>bell
	jmp AYRegDump
bell
	.byt 0,1,0,2,0,1,0,$78,$10,$10,$10,0,$a,0
.)

SndBell2
.(
  	ldx #<bell
	ldy #>bell
	jmp AYRegDump
bell
	.byt $fa,0,0,3,$fb,0,0,$78,$10,$10,$10,0,$a,0
.)

SndMissile
.(
  	ldx #<missile
	ldy #>missile
	jmp AYRegDump
missile
	.byt 0,0,0,0,0,0,$6c,$41,$10,0,0,0,$10,9
.)

SndTest
.(
  	ldx #<msg
	ldy #>msg
	jmp AYRegDump
msg
	.byt $10,0,$10,1,$10,2,0,$78,$10,$10,$10,0,$08,0

.)


#endif







