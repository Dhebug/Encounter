#define OBS  osdk_end
#define DODBUG
//#define NOSTARSINLOGO

 // Positions 


OCEN2    .word $0000            ;X-coord
         .word $FFE0-20         ;Y-coord
         .word $FE70+100        ;Z-coord

OCEN3    .word $0000            ;X-coord
         .word $FFE0-40         ;Y-coord
         .word $F9C0+100        ;Z-coord

OCEN4    .word $ffff-50		    ;X-coord
         .word $FFE0-50         ;Y-coord
         .word $1000-200		;Z-coord


VOB      .byt 00           ;View object (camera)
objs	 .byt 00
frame_count .byt 00


_InitTestCode 
.(
  		 jsr INITSTAR
+_ReInit3D
         lda #<OBS        ;Object records
         ldy #>OBS
         jsr Init3D
         jmp _DoubleBuffOn
.)

#ifdef DODBUG
OCEN10   .word $FFFF-51         ;X-coord
         .word $0		        ;Y-coord
         .word 50-1		        ;Z-coord

OCEN11   .word $FFFF-17         ;X-coord
         .word $0		        ;Y-coord
         .word 50-1		        ;Z-coord

OCEN12   .word 17				;X-coord
         .word $0		        ;Y-coord
         .word 50-1		        ;Z-coord

OCEN13   .word 51				;X-coord
         .word $0		        ;Y-coord
         .word 50-1		        ;Z-coord


#else

OCEN10   .word $FFFF-45         ;X-coord
         .word $0		        ;Y-coord
         .word 50-1		        ;Z-coord

OCEN11   .word $FFFF-15         ;X-coord
         .word $0		        ;Y-coord
         .word 50-1		        ;Z-coord

OCEN12   .word 15				;X-coord
         .word $0		        ;Y-coord
         .word 50-1		        ;Z-coord

OCEN13   .word 45				;X-coord
         .word $0		        ;Y-coord
         .word 50-1		        ;Z-coord

#endif

goforit
.(
  .(
  	jsr SetCurOb
	lda #6
	sta tmp
loopp
	sec
	jsr Pitch
	dec tmp
	bne loopp
.)
	rts
.)



_Test1337
.(

    lda #<MAMBA     ;Object data
    ldy #>MAMBA
    ldx #1          ;ID
    jsr AddObj
    stx VOB          ;View object

    lda #<ONE     ;Object data
    ldy #>ONE
    ldx #2
    jsr AddObj
    sta POINT        ;Object pointer
    sty POINT+1
.(
    ldy #5           ;Set center
l1  lda OCEN10,Y
    sta (POINT),Y
    dey
    bpl l1
.)

    lda #<THREE     ;Object data
    ldy #>THREE
    ldx #3
    jsr AddObj
    sta POINT        ;Object pointer
    sty POINT+1
.(
    ldy #5           ;Set center
l1  lda OCEN11,Y
    sta (POINT),Y
    dey
    bpl l1
.)

    lda #<THREE     ;Object data
    ldy #>THREE
    ldx #3
    jsr AddObj
    sta POINT        ;Object pointer
    sty POINT+1
.(
    ldy #5           ;Set center
l1  lda OCEN12,Y
    sta (POINT),Y
    dey
    bpl l1
.)

    lda #<SEVEN     ;Object data
    ldy #>SEVEN
    ldx #3
    jsr AddObj
    sta POINT        ;Object pointer
    sty POINT+1
.(
    ldy #5           ;Set center
l1  lda OCEN13,Y
    sta (POINT),Y
    dey
    bpl l1
.)


    jsr set_ink2

#ifdef DODBUG

;;;;;;;;;;; PREROTATIONS ;;;;;;;;;;;;;;	
.(
    lda #$10
    sta frame_count
loop
	ldx #4

  .(
  	jsr SetCurOb
	lda #4
	sta tmp
loopp
	clc
	jsr Pitch
	dec tmp
	bne loopp
.)
	
	
	ldx #3

.(
  	jsr SetCurOb
	lda #4
	sta tmp
loopp
	clc
	jsr Yaw
	dec tmp
	bne loopp
.)
	
	
	ldx #2
.(
  	jsr SetCurOb
	lda #4
	sta tmp
loopp
	sec
	jsr Pitch
	dec tmp
	bne loopp
.)

	ldx #1
.(
  	jsr SetCurOb
	lda #4
	sta tmp
loopp
	sec
	jsr Yaw
	dec tmp
	bne loopp
.)

    dec frame_count
    bne loop
    
.)

;;;; DIFFERENT ROTATIONS

.(
    lda #$10
    sta frame_count
loop
#ifndef NOSTARSINLOGO
	jsr _UpdateFrame
#else
	jsr _UpdateFrameNoStars
#endif


	ldx #4

.(
  	jsr SetCurOb
	lda #4
	sta tmp
loopp
	sec
	jsr Pitch
	dec tmp
	bne loopp
.)
	
	
	ldx #3

.(
  	jsr SetCurOb
	lda #4
	sta tmp
loopp
	sec
	jsr Yaw
	dec tmp
	bne loopp
.)
	
	
	ldx #2
.(
  	jsr SetCurOb
	lda #4
	sta tmp
loopp
	clc
	jsr Pitch
	dec tmp
	bne loopp
.)

	ldx #1
.(
  	jsr SetCurOb
	lda #4
	sta tmp
loopp
	clc
	jsr Yaw
	dec tmp
	bne loopp
.)

	ldx #0
	jsr SetCurOb
	lda #$ff-2
	jsr MoveForwards
	
    dec frame_count
    bne loop
    
.)

#endif

;;;;;; SYNCRONIZED ROTATIONS

.(
#ifdef DODBUG
    lda #$40;+10
#else
	lda #$40;+10
#endif
    sta frame_count
loop
#ifndef NOSTARSINLOGO
	jsr _UpdateFrame
#else
	jsr _UpdateFrameNoStars
#endif
	ldx #4
	jsr goforit
	ldx #3
	jsr goforit
	ldx #2
	jsr goforit
	ldx #1
	jsr goforit

	ldx #0
	jsr SetCurOb
	lda #$ff-2
	jsr MoveForwards
	
    dec frame_count
    bne loop
    
.)

	rts
.)


#ifdef NOSTARSINLOGO
_UpdateFrameNoStars
.(
	ldx VOB
	jsr SetCurOb
    jsr CalcView
    jsr SortVis
    jsr clr_hires2
    jsr DrawAllVis   ;Draw objects
    jmp dump_buf
.)
#endif



_FirstScene
.(

	; Create camera and ships

    lda #<MAMBA     ;Object data
    ldy #>MAMBA
    ldx #1          ;ID
    jsr AddObj
    stx VOB          ;View object

    lda #<MAMBA     ;Object data
    ldy #>MAMBA
    ldx #2
    jsr AddObj
    sta POINT        ;Object pointer
    sty POINT+1
.(
    ldy #5           ;Set center
l1  lda OCEN2,Y
    sta (POINT),Y
    dey
    bpl l1
.)
    lda #<THARGOID     ;Object data
    ldy #>THARGOID
    ldx #3
    jsr AddObj
    sta POINT        ;Object pointer
    sty POINT+1
.(
    ldy #5           ;Set center
l1  lda OCEN3,Y
    sta (POINT),Y
    dey
    bpl l1
.)
	ldx #0
	ldy #0
	lda #$60
	jsr SetMat

    jsr set_ink2

	; Starfield moving up sequence
.(
    lda #40
    sta frame_count
loop
	jsr _UpdateFrame
	lda #1
    jsr STARSUBY

    dec frame_count
    bne loop
.)


	jsr _clr_toparea

	; Advance sequence, first the mamba, then the thargoid
.(
    lda #80
    sta frame_count
loop
	jsr _UpdateFrame
    jsr Advance

    dec frame_count
    bne loop
    
.)

	; Move the camera..

	ldx VOB
	jsr SetCurOb
	sta POINT        ;Object pointer
    sty POINT+1
.(
    ldy #5           ;Set center
l1  lda OCEN4,y
    sta (POINT),y
    dey
    bpl l1
.)
	; Turn it

	ldx #0
	ldy #$40
	lda #0
	jsr SetMat

	; New Starfield
	jsr INITSTAR

	; Place sun
	jsr _PutSun

	; Advance ships a bit more..
.(
    lda #5
    sta frame_count
loop
	jsr _UpdateFrame
    jsr Advance

    dec frame_count
    bne loop
.)


; Turn mamba and keep advancing, but slower...
	
.(
    lda #60
    sta frame_count
loop
	jsr _UpdateFrame

	ldx #1
    jsr SetCurOb
	lda frame_count
	cmp #35
	bcc step2
 	clc
	jsr Pitch 
 	clc
	jsr Pitch 
	clc
	jsr Roll 
	lda #3
    jsr MoveForwards

	jmp next

step2
 	clc
	jsr Pitch 

next
	ldx #2
    jsr SetCurOb
	lda #6
    jsr MoveForwards
    dec frame_count
    bne loop

.)


	; Last turn and rotation
.(
    lda #5
    sta frame_count
loop
	jsr _UpdateFrame

	ldx #1
    jsr SetCurOb
	sec
    jsr Yaw

	ldx #2
    jsr SetCurOb
	clc
    jsr Pitch
	clc
	jsr Yaw

    dec frame_count
    bne loop
.)

    rts

.)


_RotateThargoid
.(
	lda #$20
	sta frame_count
loop
	jsr _UpdateFrame
	ldx #2
	jsr SetCurOb
	clc
	jsr Pitch
	
	jsr BalanceMamba
	
	dec frame_count
	bne loop


#if 0
+patch_clc
	clc
	jsr Roll

	dec frame_count
	bne loop

	lda patch_clc
	cmp #$18
	beq setit
	lda #$18
	.byt $2c
setit
	lda #$38
	sta patch_clc
#endif

	rts
.)

BalanceMamba
.(
	ldx #1
	jsr SetCurOb
	
	lda frame_count
	ror
	bcc avoid

	cmp #9
	bcs setit
	clc
	bcc doit
setit
	sec
doit
	jmp Roll
avoid
	rts
.)


_UpdateFrame
.(
  	lda double_buff
	bne cont
	rts
cont
    ldx VOB
    jsr SetCurOb
    jsr CalcView
    jsr SortVis
    jsr clr_hires2
	jsr PlotStars
    jsr DrawAllVis   ;Draw objects
    jmp dump_buf
.)


_PutSun
.(
	; Prepare bitmap with stars
	jsr clr_hires2
	jsr PlotStars

	lda #<_SmallSun
	sta loopcol+1
	lda #>_SmallSun
	sta loopcol+2

	lda #<buffer+39-14
	sta loopcol+4
	lda #>buffer+39-14
	sta loopcol+5

	; Dump Sun into bitmap
	ldy #0
looprow
	ldx #13
loopcol
	lda _SmallSun,x
	sta buffer+39-14,x
	dex
	bpl loopcol

	clc
	lda #14
	adc loopcol+1
	sta loopcol+1
	bcc nocarry
	inc loopcol+2
nocarry

	clc
	lda #40
	adc loopcol+4
	sta loopcol+4
	bcc nocarry2
	inc loopcol+5
nocarry2

	iny
	cpy #55
	bne looprow

	; Dump bitmap
	jsr dump_buf

	; Patch code
	lda #WIDTH-14
	sta dump_buf+1
	
	rts
.)


Advance
.(
    ldx NUMOBJS
    beq end
    dex 

    stx objs    
loop
    cpx VOB
    beq next

    jsr SetCurOb
    lda #10
    jsr MoveForwards
next
    dec objs
    ldx objs

    bpl loop 
end
    rts
.)


_FinalScene
.(

; The Thargoid leaves
	lda #$30-15
	sta frame_count
loop
	jsr _UpdateFrame
	ldx #2
	jsr SetCurOb
	lda #$32-15
	sec
	sbc frame_count
	jsr MoveForwards
	jsr BalanceMamba
	dec frame_count
	bne loop

; The Mamba leaves

	lda #$15
	sta frame_count
loop3
	jsr _UpdateFrame
	ldx #1
	jsr SetCurOb
	clc
	jsr Pitch
	clc
	jsr Roll
	dec frame_count
	bne loop3


	lda #$10
	sta frame_count
loop2
	jsr _UpdateFrame
	ldx #1
	jsr SetCurOb
	lda #$12
	sec
	sbc frame_count
	jsr MoveForwards
	dec frame_count
	bne loop2

	rts	
	
.)


; Places alternate attribute controls in the first columns of the screen
; params regA,  regX = attributes to set 


set_ink
.(
	sta color1+1
	stx color2+1

	ldy #<($a000)
	sty tmp
	ldy #>($a000)
	sty tmp+1
	ldx #100 
loop
	ldy #0
color1
	lda #0 ;SMC
	sta (tmp),y

	ldy #40
color2
	lda #0 ; SMC
	sta (tmp),y

	lda tmp
	clc
	adc #80
	sta tmp
	bcc nocarry
	inc tmp+1

nocarry
	dex
	bne loop
end

    rts	
.)



set_ink2
.(
	ldy #<($a000+(TOP)*40)
	sty tmp
	ldy #>($a000+(TOP)*40)
	sty tmp+1

	ldx #(50) ;(122/2)
loop
	lda #$03
	ldy #0
	sta (tmp),y
	lda #$06
	ldy #40
	sta (tmp),y
	
	lda tmp
	clc
	adc #80
	sta tmp
	bcc nocarry
	inc tmp+1
nocarry

	dex
	bne loop
end
	rts	
.)



; A real random generator... trying to enhance this...
randgen 
.(
   php				; INTERRUPTS MUST BE ENABLED!  We store the state of flags. 
   cli 
   lda randseed     ; get old lsb of seed. 
   ora $308			; lsb of VIA T2L-L/T2C-L. 
   rol				; this is even, but the carry fixes this. 
   adc $304			; lsb of VIA TK-L/T1C-L.  This is taken mod 256. 
   sta randseed     ; random enough yet. 
   sbc randseed+1   ; minus the hsb of seed... 
   rol				; same comment than before.  Carry is fairly random. 
   sta randseed+1   ; we are set. 
   plp 
   rts				; see you later alligator. 
.)
randseed 
  .word $dead       ; will it be $dead again? 


dump_buf
.(
	ldx #WIDTH
loop
	lda buffer+LEFT+40*0,x
	sta $a000+LEFT+40*(0+TOP),x
	lda buffer+LEFT+40*1,x
	sta $a000+LEFT+40*(1+TOP),x
	lda buffer+LEFT+40*2,x
	sta $a000+LEFT+40*(2+TOP),x
	lda buffer+LEFT+40*3,x
	sta $a000+LEFT+40*(3+TOP),x
	lda buffer+LEFT+40*4,x
	sta $a000+LEFT+40*(4+TOP),x
	lda buffer+LEFT+40*5,x
	sta $a000+LEFT+40*(5+TOP),x
	lda buffer+LEFT+40*6,x
	sta $a000+LEFT+40*(6+TOP),x
	lda buffer+LEFT+40*7,x
	sta $a000+LEFT+40*(7+TOP),x
	lda buffer+LEFT+40*8,x
	sta $a000+LEFT+40*(8+TOP),x
	lda buffer+LEFT+40*9,x
	sta $a000+LEFT+40*(9+TOP),x
	lda buffer+LEFT+40*10,x
	sta $a000+LEFT+40*(10+TOP),x
	lda buffer+LEFT+40*11,x
	sta $a000+LEFT+40*(11+TOP),x
	lda buffer+LEFT+40*12,x
	sta $a000+LEFT+40*(12+TOP),x
	lda buffer+LEFT+40*13,x
	sta $a000+LEFT+40*(13+TOP),x
	lda buffer+LEFT+40*14,x
	sta $a000+LEFT+40*(14+TOP),x
	lda buffer+LEFT+40*15,x
	sta $a000+LEFT+40*(15+TOP),x
	lda buffer+LEFT+40*16,x
	sta $a000+LEFT+40*(16+TOP),x
	lda buffer+LEFT+40*17,x
	sta $a000+LEFT+40*(17+TOP),x
	lda buffer+LEFT+40*18,x
	sta $a000+LEFT+40*(18+TOP),x
	lda buffer+LEFT+40*19,x
	sta $a000+LEFT+40*(19+TOP),x
	lda buffer+LEFT+40*20,x
	sta $a000+LEFT+40*(20+TOP),x
	lda buffer+LEFT+40*21,x
	sta $a000+LEFT+40*(21+TOP),x
	lda buffer+LEFT+40*22,x
	sta $a000+LEFT+40*(22+TOP),x
	lda buffer+LEFT+40*23,x
	sta $a000+LEFT+40*(23+TOP),x
	lda buffer+LEFT+40*24,x
	sta $a000+LEFT+40*(24+TOP),x
	lda buffer+LEFT+40*25,x
	sta $a000+LEFT+40*(25+TOP),x
	lda buffer+LEFT+40*26,x
	sta $a000+LEFT+40*(26+TOP),x
	lda buffer+LEFT+40*27,x
	sta $a000+LEFT+40*(27+TOP),x
	lda buffer+LEFT+40*28,x
	sta $a000+LEFT+40*(28+TOP),x
	lda buffer+LEFT+40*29,x
	sta $a000+LEFT+40*(29+TOP),x
	lda buffer+LEFT+40*30,x
	sta $a000+LEFT+40*(30+TOP),x
	lda buffer+LEFT+40*31,x
	sta $a000+LEFT+40*(31+TOP),x
	lda buffer+LEFT+40*32,x
	sta $a000+LEFT+40*(32+TOP),x
	lda buffer+LEFT+40*33,x
	sta $a000+LEFT+40*(33+TOP),x
	lda buffer+LEFT+40*34,x
	sta $a000+LEFT+40*(34+TOP),x
	lda buffer+LEFT+40*35,x
	sta $a000+LEFT+40*(35+TOP),x
	lda buffer+LEFT+40*36,x
	sta $a000+LEFT+40*(36+TOP),x
	lda buffer+LEFT+40*37,x
	sta $a000+LEFT+40*(37+TOP),x
	lda buffer+LEFT+40*38,x
	sta $a000+LEFT+40*(38+TOP),x
	lda buffer+LEFT+40*39,x
	sta $a000+LEFT+40*(39+TOP),x
	lda buffer+LEFT+40*40,x
	sta $a000+LEFT+40*(40+TOP),x
	lda buffer+LEFT+40*41,x
	sta $a000+LEFT+40*(41+TOP),x
	lda buffer+LEFT+40*42,x
	sta $a000+LEFT+40*(42+TOP),x
	lda buffer+LEFT+40*43,x
	sta $a000+LEFT+40*(43+TOP),x
	lda buffer+LEFT+40*44,x
	sta $a000+LEFT+40*(44+TOP),x
	lda buffer+LEFT+40*45,x
	sta $a000+LEFT+40*(45+TOP),x
	lda buffer+LEFT+40*46,x
	sta $a000+LEFT+40*(46+TOP),x
	lda buffer+LEFT+40*47,x
	sta $a000+LEFT+40*(47+TOP),x
	lda buffer+LEFT+40*48,x
	sta $a000+LEFT+40*(48+TOP),x
	lda buffer+LEFT+40*49,x
	sta $a000+LEFT+40*(49+TOP),x
	lda buffer+LEFT+40*50,x
	sta $a000+LEFT+40*(50+TOP),x
	lda buffer+LEFT+40*51,x
	sta $a000+LEFT+40*(51+TOP),x
	lda buffer+LEFT+40*52,x
	sta $a000+LEFT+40*(52+TOP),x
	lda buffer+LEFT+40*53,x
	sta $a000+LEFT+40*(53+TOP),x
	lda buffer+LEFT+40*54,x
	sta $a000+LEFT+40*(54+TOP),x
	lda buffer+LEFT+40*55,x
	sta $a000+LEFT+40*(55+TOP),x
	lda buffer+LEFT+40*56,x
	sta $a000+LEFT+40*(56+TOP),x
	lda buffer+LEFT+40*57,x
	sta $a000+LEFT+40*(57+TOP),x
	lda buffer+LEFT+40*58,x
	sta $a000+LEFT+40*(58+TOP),x
	lda buffer+LEFT+40*59,x
	sta $a000+LEFT+40*(59+TOP),x
	lda buffer+LEFT+40*60,x
	sta $a000+LEFT+40*(60+TOP),x
	lda buffer+LEFT+40*61,x
	sta $a000+LEFT+40*(61+TOP),x
	lda buffer+LEFT+40*62,x
	sta $a000+LEFT+40*(62+TOP),x
	lda buffer+LEFT+40*63,x
	sta $a000+LEFT+40*(63+TOP),x
	lda buffer+LEFT+40*64,x
	sta $a000+LEFT+40*(64+TOP),x
	lda buffer+LEFT+40*65,x
	sta $a000+LEFT+40*(65+TOP),x
	lda buffer+LEFT+40*66,x
	sta $a000+LEFT+40*(66+TOP),x
	lda buffer+LEFT+40*67,x
	sta $a000+LEFT+40*(67+TOP),x
	lda buffer+LEFT+40*68,x
	sta $a000+LEFT+40*(68+TOP),x
	lda buffer+LEFT+40*69,x
	sta $a000+LEFT+40*(69+TOP),x
	lda buffer+LEFT+40*70,x
	sta $a000+LEFT+40*(70+TOP),x
	lda buffer+LEFT+40*71,x
	sta $a000+LEFT+40*(71+TOP),x
	lda buffer+LEFT+40*72,x
	sta $a000+LEFT+40*(72+TOP),x
	lda buffer+LEFT+40*73,x
	sta $a000+LEFT+40*(73+TOP),x
	lda buffer+LEFT+40*74,x
	sta $a000+LEFT+40*(74+TOP),x
	lda buffer+LEFT+40*75,x
	sta $a000+LEFT+40*(75+TOP),x
	lda buffer+LEFT+40*76,x
	sta $a000+LEFT+40*(76+TOP),x
	lda buffer+LEFT+40*77,x
	sta $a000+LEFT+40*(77+TOP),x
	lda buffer+LEFT+40*78,x
	sta $a000+LEFT+40*(78+TOP),x
	lda buffer+LEFT+40*79,x
	sta $a000+LEFT+40*(79+TOP),x
	lda buffer+LEFT+40*80,x
	sta $a000+LEFT+40*(80+TOP),x
	lda buffer+LEFT+40*81,x
	sta $a000+LEFT+40*(81+TOP),x
	lda buffer+LEFT+40*82,x
	sta $a000+LEFT+40*(82+TOP),x
	lda buffer+LEFT+40*83,x
	sta $a000+LEFT+40*(83+TOP),x
	lda buffer+LEFT+40*84,x
	sta $a000+LEFT+40*(84+TOP),x
	lda buffer+LEFT+40*85,x
	sta $a000+LEFT+40*(85+TOP),x
	lda buffer+LEFT+40*86,x
	sta $a000+LEFT+40*(86+TOP),x
	lda buffer+LEFT+40*87,x
	sta $a000+LEFT+40*(87+TOP),x
	lda buffer+LEFT+40*88,x
	sta $a000+LEFT+40*(88+TOP),x
	lda buffer+LEFT+40*89,x
	sta $a000+LEFT+40*(89+TOP),x
	lda buffer+LEFT+40*90,x
	sta $a000+LEFT+40*(90+TOP),x
	lda buffer+LEFT+40*91,x
	sta $a000+LEFT+40*(91+TOP),x
	lda buffer+LEFT+40*92,x
	sta $a000+LEFT+40*(92+TOP),x
	lda buffer+LEFT+40*93,x
	sta $a000+LEFT+40*(93+TOP),x
	lda buffer+LEFT+40*94,x
	sta $a000+LEFT+40*(94+TOP),x
	lda buffer+LEFT+40*95,x
	sta $a000+LEFT+40*(95+TOP),x
	lda buffer+LEFT+40*96,x
	sta $a000+LEFT+40*(96+TOP),x
	lda buffer+LEFT+40*97,x
	sta $a000+LEFT+40*(97+TOP),x
	lda buffer+LEFT+40*98,x
	sta $a000+LEFT+40*(98+TOP),x
	lda buffer+LEFT+40*99,x
	sta $a000+LEFT+40*(99+TOP),x
/*
	lda buffer+LEFT+40*100,x
	sta $a000+LEFT+40*(100+TOP),x
	lda buffer+LEFT+40*101,x
	sta $a000+LEFT+40*(101+TOP),x
	lda buffer+LEFT+40*102,x
	sta $a000+LEFT+40*(102+TOP),x
	lda buffer+LEFT+40*103,x
	sta $a000+LEFT+40*(103+TOP),x
	lda buffer+LEFT+40*104,x
	sta $a000+LEFT+40*(104+TOP),x
	lda buffer+LEFT+40*105,x
	sta $a000+LEFT+40*(105+TOP),x
	lda buffer+LEFT+40*106,x
	sta $a000+LEFT+40*(106+TOP),x
	lda buffer+LEFT+40*107,x
	sta $a000+LEFT+40*(107+TOP),x
	lda buffer+LEFT+40*108,x
	sta $a000+LEFT+40*(108+TOP),x
	lda buffer+LEFT+40*109,x
	sta $a000+LEFT+40*(109+TOP),x
	lda buffer+LEFT+40*110,x
	sta $a000+LEFT+40*(110+TOP),x
	lda buffer+LEFT+40*111,x
	sta $a000+LEFT+40*(111+TOP),x
	lda buffer+LEFT+40*112,x
	sta $a000+LEFT+40*(112+TOP),x
	lda buffer+LEFT+40*113,x
	sta $a000+LEFT+40*(113+TOP),x
	lda buffer+LEFT+40*114,x
	sta $a000+LEFT+40*(114+TOP),x
	lda buffer+LEFT+40*115,x
	sta $a000+LEFT+40*(115+TOP),x
	lda buffer+LEFT+40*116,x
	sta $a000+LEFT+40*(116+TOP),x
	lda buffer+LEFT+40*117,x
	sta $a000+LEFT+40*(117+TOP),x
	lda buffer+LEFT+40*118,x
	sta $a000+LEFT+40*(118+TOP),x
	lda buffer+LEFT+40*119,x
	sta $a000+LEFT+40*(119+TOP),x
	lda buffer+LEFT+40*120,x
	sta $a000+LEFT+40*(120+TOP),x
	lda buffer+LEFT+40*121,x
	sta $a000+LEFT+40*(121+TOP),x
*/
	dex
	bmi end
	jmp loop
end
	rts
.)


clr_hires2
.(
	ldx #WIDTH
	lda #$40
loop
	sta buffer+LEFT+40*0,x
	sta buffer+LEFT+40*1,x
	sta buffer+LEFT+40*2,x
	sta buffer+LEFT+40*3,x
	sta buffer+LEFT+40*4,x
	sta buffer+LEFT+40*5,x
	sta buffer+LEFT+40*6,x
	sta buffer+LEFT+40*7,x
	sta buffer+LEFT+40*8,x
	sta buffer+LEFT+40*9,x
	sta buffer+LEFT+40*10,x
	sta buffer+LEFT+40*11,x
	sta buffer+LEFT+40*12,x
	sta buffer+LEFT+40*13,x
	sta buffer+LEFT+40*14,x
	sta buffer+LEFT+40*15,x
	sta buffer+LEFT+40*16,x
	sta buffer+LEFT+40*17,x
	sta buffer+LEFT+40*18,x
	sta buffer+LEFT+40*19,x
	sta buffer+LEFT+40*20,x
	sta buffer+LEFT+40*21,x
	sta buffer+LEFT+40*22,x
	sta buffer+LEFT+40*23,x
	sta buffer+LEFT+40*24,x
	sta buffer+LEFT+40*25,x
	sta buffer+LEFT+40*26,x
	sta buffer+LEFT+40*27,x
	sta buffer+LEFT+40*28,x
	sta buffer+LEFT+40*29,x
	sta buffer+LEFT+40*30,x
	sta buffer+LEFT+40*31,x
	sta buffer+LEFT+40*32,x
	sta buffer+LEFT+40*33,x
	sta buffer+LEFT+40*34,x
	sta buffer+LEFT+40*35,x
	sta buffer+LEFT+40*36,x
	sta buffer+LEFT+40*37,x
	sta buffer+LEFT+40*38,x
	sta buffer+LEFT+40*39,x
	sta buffer+LEFT+40*40,x
	sta buffer+LEFT+40*41,x
	sta buffer+LEFT+40*42,x
	sta buffer+LEFT+40*43,x
	sta buffer+LEFT+40*44,x
	sta buffer+LEFT+40*45,x
	sta buffer+LEFT+40*46,x
	sta buffer+LEFT+40*47,x
	sta buffer+LEFT+40*48,x
	sta buffer+LEFT+40*49,x
	sta buffer+LEFT+40*50,x
	sta buffer+LEFT+40*51,x
	sta buffer+LEFT+40*52,x
	sta buffer+LEFT+40*53,x
	sta buffer+LEFT+40*54,x
	sta buffer+LEFT+40*55,x
	sta buffer+LEFT+40*56,x
	sta buffer+LEFT+40*57,x
	sta buffer+LEFT+40*58,x
	sta buffer+LEFT+40*59,x
	sta buffer+LEFT+40*60,x
	sta buffer+LEFT+40*61,x
	sta buffer+LEFT+40*62,x
	sta buffer+LEFT+40*63,x
	sta buffer+LEFT+40*64,x
	sta buffer+LEFT+40*65,x
	sta buffer+LEFT+40*66,x
	sta buffer+LEFT+40*67,x
	sta buffer+LEFT+40*68,x
	sta buffer+LEFT+40*69,x
	sta buffer+LEFT+40*70,x
	sta buffer+LEFT+40*71,x
	sta buffer+LEFT+40*72,x
	sta buffer+LEFT+40*73,x
	sta buffer+LEFT+40*74,x
	sta buffer+LEFT+40*75,x
	sta buffer+LEFT+40*76,x
	sta buffer+LEFT+40*77,x
	sta buffer+LEFT+40*78,x
	sta buffer+LEFT+40*79,x
	sta buffer+LEFT+40*80,x
	sta buffer+LEFT+40*81,x
	sta buffer+LEFT+40*82,x
	sta buffer+LEFT+40*83,x
	sta buffer+LEFT+40*84,x
	sta buffer+LEFT+40*85,x
	sta buffer+LEFT+40*86,x
	sta buffer+LEFT+40*87,x
	sta buffer+LEFT+40*88,x
	sta buffer+LEFT+40*89,x
	sta buffer+LEFT+40*90,x
	sta buffer+LEFT+40*91,x
	sta buffer+LEFT+40*92,x
	sta buffer+LEFT+40*93,x
	sta buffer+LEFT+40*94,x
	sta buffer+LEFT+40*95,x
	sta buffer+LEFT+40*96,x
	sta buffer+LEFT+40*97,x
	sta buffer+LEFT+40*98,x
	sta buffer+LEFT+40*99,x
/*
	sta buffer+LEFT+40*100,x
	sta buffer+LEFT+40*101,x
	sta buffer+LEFT+40*102,x
	sta buffer+LEFT+40*103,x
	sta buffer+LEFT+40*104,x
	sta buffer+LEFT+40*105,x
	sta buffer+LEFT+40*106,x
	sta buffer+LEFT+40*107,x
	sta buffer+LEFT+40*108,x
	sta buffer+LEFT+40*109,x
	sta buffer+LEFT+40*110,x
	sta buffer+LEFT+40*111,x
	sta buffer+LEFT+40*112,x
	sta buffer+LEFT+40*113,x
	sta buffer+LEFT+40*114,x
	sta buffer+LEFT+40*115,x
	sta buffer+LEFT+40*116,x
	sta buffer+LEFT+40*117,x
	sta buffer+LEFT+40*118,x
	sta buffer+LEFT+40*119,x
	sta buffer+LEFT+40*120,x
	sta buffer+LEFT+40*121,x
*/
	dex
	bmi end
	jmp loop
end
	rts
.)








