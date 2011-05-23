
;;;;;;;;;;;;;;;;;;;;;;;
; Some graphical routines for drawing lines,
; colours, ship controls and double buffering.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#include "oobj3d\params.h"
#include "main.h"
#include "tine.h"


#define pzero tmp

Draw4Lines
.(

	ldy #15
loop
	lda (pzero),y    ; YD
	sta _OtherPixelY
    dey
	lda (pzero),y    ; XD
	sta _OtherPixelX
    dey
  	lda (pzero),y    ; YO
	sta _CurrentPixelY
    dey
  	lda (pzero),y    ; XO
	sta _CurrentPixelX

	sty savy+1
	jsr _DrawLine
savy
	ldy #0	; SMC
	dey
	bpl loop

	rts
.)


_DrawLaser
.(
	jsr PatchLaserDraw

#ifdef REALRANDOM
	jsr randgen
	lsr
	and #%1
	;clc
	adc #(120-1-1)
	tax
	lda randseed
	lsr
	and #%1
	;clc
	adc #(61-1)

	stx Coords+2
	sta Coords+3
	stx Coords+6
	sta Coords+7
	inx
	inx
	stx Coords+10
	sta Coords+11
	stx Coords+14
	sta Coords+15
#endif

    lda #<Coords
    sta pzero
    lda #>Coords
    sta pzero+1
    jmp Draw4Lines

Coords 
    .byt 10,  121, (120-1), (61)
    .byt 57+2,  121, (120-1), (61)
    .byt 230, 121, (120+1), (61)
    .byt 183-2, 121, (120+1), (61) 
.)


_DrawCrosshair
.(
#ifdef 0
    lda #<Coords
    sta pzero
    lda #>Coords
    sta pzero+1
    jmp Draw4Lines

Coords 
    .byt 104, 61, 111, 61
    .byt 129, 61, 136, 61
    .byt 120, 46, 120, 53
    .byt 120, 69, 120, 76 
#endif

	lda #%11101100
	sta buffer+61*40+17
	lda #%11111000
	sta buffer+61*40+17+1
	lda #%11000111
	sta buffer+61*40+17+4
	lda #%11001101
	sta buffer+61*40+17+5


	lda #<buffer+(45+2)*40+20
	sta tmp
	lda #>buffer+(45+2)*40+20
	sta tmp+1

	ldx #5
	ldy #0
loop1
	lda (tmp),y
	ora #%01100000
	sta (tmp),y
	lda tab_crosshair,x
	clc
	adc tmp
	sta tmp
	bcc noc1
	inc tmp+1
noc1
	dex
	bpl loop1

	lda #<buffer+(45+10+12+8)*40+20
	sta tmp
	lda #>buffer+(45+10+12+8)*40+20
	sta tmp+1

	ldx #5
	ldy #0
loop2
	lda (tmp),y
	ora #%01100000
	sta (tmp),y
	lda tmp
	sec
	sbc tab_crosshair,x
	sta tmp
	bcs noc2
	dec tmp+1
noc2
	dex
	bpl loop2

	rts

.)

tab_crosshair
.byt 40,40,40,80,80,80



#ifdef 0
_DrawFrameBorder
.(
    lda #<Coords
    sta pzero
    lda #>Coords
    sta pzero+1
    jmp Draw4Lines

Coords
/*    .byt 5,     5,      5,     5+123
    .byt 5,     5+123,  5+230, 5+123
    .byt 5+230, 5+123,  5+230, 5
    .byt 5+230, 5,      5,     5 */

	.byt 11,     5+5,      11,     5+123+5
    .byt 11,     5+123+5,  228, 5+123+5
    .byt 228, 5+123+5,  228, 5+5
    .byt 228, 5+5,      11,     5+5	

.)

#endif

; Places an attribute control in the first column of the screen
; params regA = attribute to set

set_ink
.(
	ldy _current_screen
	cpy #SCR_FRONT
	bne end
	ldy #<($a000+(TOP)*40)
	sty tmp
	ldy #>($a000+(TOP)*40)
	sty tmp+1
	ldy #0
	ldx #122
loop
	sta (tmp),y
	pha
	lda tmp
	clc
	adc #40
	sta tmp
	bcc nocarry
	inc tmp+1
nocarry
	pla
	dex
	bne loop
end

	;Patch loop code
	lda #$20	; jsr opcode
	sta _patch_set_ink
	lda #<set_ink2
	sta _patch_set_ink+1
	lda #>set_ink2
	sta _patch_set_ink+2

	rts	
.)

set_ink2
.(
	ldy _current_screen
	cpy #SCR_FRONT
	bne end
	ldy #<($a000+(TOP)*40)
	sty tmp
	ldy #>($a000+(TOP)*40)
	sty tmp+1

	ldx #(122/2)
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

	; Remove patch in main loop
	lda #$ea	; nop opcode
	ldx #2
loop2
	sta _patch_set_ink,x
	dex
	bpl loop2

	rts	
.)


dump_buf
.(
#ifdef ALTSCANS
  lda frame_time
  cmp #MAXFRAMETIME1
  bcc all
  lda frame_number
  and #1
  bne all
  jmp dump_buffodd
all
#endif
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
	dex
	bmi end
	jmp loop
end
	rts
.)


clr_hires2
.(

#ifdef ALTSCANS
  lda frame_time
  cmp #MAXFRAMETIME1
  bcc all
  lda frame_number
  and #1
  bne all
  jmp clr_hires2odd
all
#endif

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
	dex
	bmi end
	jmp loop
end
	rts
.)

#ifdef ALTSCANS

dump_buffodd
.(
	ldx #WIDTH
loop
	lda buffer+LEFT+40*1,x
	sta $a000+LEFT+40*(1+TOP),x
	lda buffer+LEFT+40*3,x
	sta $a000+LEFT+40*(3+TOP),x
	lda buffer+LEFT+40*5,x
	sta $a000+LEFT+40*(5+TOP),x
	lda buffer+LEFT+40*7,x
	sta $a000+LEFT+40*(7+TOP),x
	lda buffer+LEFT+40*9,x
	sta $a000+LEFT+40*(9+TOP),x
	lda buffer+LEFT+40*11,x
	sta $a000+LEFT+40*(11+TOP),x
	lda buffer+LEFT+40*13,x
	sta $a000+LEFT+40*(13+TOP),x
	lda buffer+LEFT+40*15,x
	sta $a000+LEFT+40*(15+TOP),x
	lda buffer+LEFT+40*17,x
	sta $a000+LEFT+40*(17+TOP),x
	lda buffer+LEFT+40*19,x
	sta $a000+LEFT+40*(19+TOP),x
	lda buffer+LEFT+40*21,x
	sta $a000+LEFT+40*(21+TOP),x
	lda buffer+LEFT+40*23,x
	sta $a000+LEFT+40*(23+TOP),x
	lda buffer+LEFT+40*25,x
	sta $a000+LEFT+40*(25+TOP),x
	lda buffer+LEFT+40*27,x
	sta $a000+LEFT+40*(27+TOP),x
	lda buffer+LEFT+40*29,x
	sta $a000+LEFT+40*(29+TOP),x
	lda buffer+LEFT+40*31,x
	sta $a000+LEFT+40*(31+TOP),x
	lda buffer+LEFT+40*33,x
	sta $a000+LEFT+40*(33+TOP),x
	lda buffer+LEFT+40*35,x
	sta $a000+LEFT+40*(35+TOP),x
	lda buffer+LEFT+40*37,x
	sta $a000+LEFT+40*(37+TOP),x
	lda buffer+LEFT+40*39,x
	sta $a000+LEFT+40*(39+TOP),x
	lda buffer+LEFT+40*41,x
	sta $a000+LEFT+40*(41+TOP),x
	lda buffer+LEFT+40*43,x
	sta $a000+LEFT+40*(43+TOP),x
	lda buffer+LEFT+40*45,x
	sta $a000+LEFT+40*(45+TOP),x
	lda buffer+LEFT+40*47,x
	sta $a000+LEFT+40*(47+TOP),x
	lda buffer+LEFT+40*49,x
	sta $a000+LEFT+40*(49+TOP),x
	lda buffer+LEFT+40*51,x
	sta $a000+LEFT+40*(51+TOP),x
	lda buffer+LEFT+40*53,x
	sta $a000+LEFT+40*(53+TOP),x
	lda buffer+LEFT+40*55,x
	sta $a000+LEFT+40*(55+TOP),x
	lda buffer+LEFT+40*57,x
	sta $a000+LEFT+40*(57+TOP),x
	lda buffer+LEFT+40*59,x
	sta $a000+LEFT+40*(59+TOP),x
	lda buffer+LEFT+40*61,x
	sta $a000+LEFT+40*(61+TOP),x
	lda buffer+LEFT+40*63,x
	sta $a000+LEFT+40*(63+TOP),x
	lda buffer+LEFT+40*65,x
	sta $a000+LEFT+40*(65+TOP),x
	lda buffer+LEFT+40*67,x
	sta $a000+LEFT+40*(67+TOP),x
	lda buffer+LEFT+40*69,x
	sta $a000+LEFT+40*(69+TOP),x
	lda buffer+LEFT+40*71,x
	sta $a000+LEFT+40*(71+TOP),x
	lda buffer+LEFT+40*73,x
	sta $a000+LEFT+40*(73+TOP),x
	lda buffer+LEFT+40*75,x
	sta $a000+LEFT+40*(75+TOP),x
	lda buffer+LEFT+40*77,x
	sta $a000+LEFT+40*(77+TOP),x
	lda buffer+LEFT+40*79,x
	sta $a000+LEFT+40*(79+TOP),x
	lda buffer+LEFT+40*81,x
	sta $a000+LEFT+40*(81+TOP),x
	lda buffer+LEFT+40*83,x
	sta $a000+LEFT+40*(83+TOP),x
	lda buffer+LEFT+40*85,x
	sta $a000+LEFT+40*(85+TOP),x
	lda buffer+LEFT+40*87,x
	sta $a000+LEFT+40*(87+TOP),x
	lda buffer+LEFT+40*89,x
	sta $a000+LEFT+40*(89+TOP),x
	lda buffer+LEFT+40*91,x
	sta $a000+LEFT+40*(91+TOP),x
	lda buffer+LEFT+40*93,x
	sta $a000+LEFT+40*(93+TOP),x
	lda buffer+LEFT+40*95,x
	sta $a000+LEFT+40*(95+TOP),x
	lda buffer+LEFT+40*97,x
	sta $a000+LEFT+40*(97+TOP),x
	lda buffer+LEFT+40*99,x
	sta $a000+LEFT+40*(99+TOP),x
	lda buffer+LEFT+40*101,x
	sta $a000+LEFT+40*(101+TOP),x
	lda buffer+LEFT+40*103,x
	sta $a000+LEFT+40*(103+TOP),x
	lda buffer+LEFT+40*105,x
	sta $a000+LEFT+40*(105+TOP),x
	lda buffer+LEFT+40*107,x
	sta $a000+LEFT+40*(107+TOP),x
	lda buffer+LEFT+40*109,x
	sta $a000+LEFT+40*(109+TOP),x
	lda buffer+LEFT+40*111,x
	sta $a000+LEFT+40*(111+TOP),x
	lda buffer+LEFT+40*113,x
	sta $a000+LEFT+40*(113+TOP),x
	lda buffer+LEFT+40*115,x
	sta $a000+LEFT+40*(115+TOP),x
	lda buffer+LEFT+40*117,x
	sta $a000+LEFT+40*(117+TOP),x
	lda buffer+LEFT+40*119,x
	sta $a000+LEFT+40*(119+TOP),x
	lda buffer+LEFT+40*121,x
	sta $a000+LEFT+40*(121+TOP),x
	dex
	bmi end
	jmp loop
end
	rts
.)

clr_hires2odd
.(
	ldx #WIDTH
	lda #$40
loop
	sta buffer+LEFT+40*1,x
	sta buffer+LEFT+40*3,x
	sta buffer+LEFT+40*5,x
	sta buffer+LEFT+40*7,x
	sta buffer+LEFT+40*9,x
	sta buffer+LEFT+40*11,x
	sta buffer+LEFT+40*13,x
	sta buffer+LEFT+40*15,x
	sta buffer+LEFT+40*17,x
	sta buffer+LEFT+40*19,x
	sta buffer+LEFT+40*21,x
	sta buffer+LEFT+40*23,x
	sta buffer+LEFT+40*25,x
	sta buffer+LEFT+40*27,x
	sta buffer+LEFT+40*29,x
	sta buffer+LEFT+40*31,x
	sta buffer+LEFT+40*33,x
	sta buffer+LEFT+40*35,x
	sta buffer+LEFT+40*37,x
	sta buffer+LEFT+40*39,x
	sta buffer+LEFT+40*41,x
	sta buffer+LEFT+40*43,x
	sta buffer+LEFT+40*45,x
	sta buffer+LEFT+40*47,x
	sta buffer+LEFT+40*49,x
	sta buffer+LEFT+40*51,x
	sta buffer+LEFT+40*53,x
	sta buffer+LEFT+40*55,x
	sta buffer+LEFT+40*57,x
	sta buffer+LEFT+40*59,x
	sta buffer+LEFT+40*61,x
	sta buffer+LEFT+40*63,x
	sta buffer+LEFT+40*65,x
	sta buffer+LEFT+40*67,x
	sta buffer+LEFT+40*69,x
	sta buffer+LEFT+40*71,x
	sta buffer+LEFT+40*73,x
	sta buffer+LEFT+40*75,x
	sta buffer+LEFT+40*77,x
	sta buffer+LEFT+40*79,x
	sta buffer+LEFT+40*81,x
	sta buffer+LEFT+40*83,x
	sta buffer+LEFT+40*85,x
	sta buffer+LEFT+40*87,x
	sta buffer+LEFT+40*89,x
	sta buffer+LEFT+40*91,x
	sta buffer+LEFT+40*93,x
	sta buffer+LEFT+40*95,x
	sta buffer+LEFT+40*97,x
	sta buffer+LEFT+40*99,x
	sta buffer+LEFT+40*101,x
	sta buffer+LEFT+40*103,x
	sta buffer+LEFT+40*105,x
	sta buffer+LEFT+40*107,x
	sta buffer+LEFT+40*109,x
	sta buffer+LEFT+40*111,x
	sta buffer+LEFT+40*113,x
	sta buffer+LEFT+40*115,x
	sta buffer+LEFT+40*117,x
	sta buffer+LEFT+40*119,x
	sta buffer+LEFT+40*121,x
	dex
	bmi end
	jmp loop
end
	rts
.)


/*
dump_buffeven
.(
	ldx #WIDTH
loop
	lda buffer+LEFT+40*0,x
	sta $a000+LEFT+40*(0+TOP),x
	lda buffer+LEFT+40*2,x
	sta $a000+LEFT+40*(2+TOP),x
	lda buffer+LEFT+40*4,x
	sta $a000+LEFT+40*(4+TOP),x
	lda buffer+LEFT+40*6,x
	sta $a000+LEFT+40*(6+TOP),x
	lda buffer+LEFT+40*8,x
	sta $a000+LEFT+40*(8+TOP),x
	lda buffer+LEFT+40*10,x
	sta $a000+LEFT+40*(10+TOP),x
	lda buffer+LEFT+40*12,x
	sta $a000+LEFT+40*(12+TOP),x
	lda buffer+LEFT+40*14,x
	sta $a000+LEFT+40*(14+TOP),x
	lda buffer+LEFT+40*16,x
	sta $a000+LEFT+40*(16+TOP),x
	lda buffer+LEFT+40*18,x
	sta $a000+LEFT+40*(18+TOP),x
	lda buffer+LEFT+40*20,x
	sta $a000+LEFT+40*(20+TOP),x
	lda buffer+LEFT+40*22,x
	sta $a000+LEFT+40*(22+TOP),x
	lda buffer+LEFT+40*24,x
	sta $a000+LEFT+40*(24+TOP),x
	lda buffer+LEFT+40*26,x
	sta $a000+LEFT+40*(26+TOP),x
	lda buffer+LEFT+40*28,x
	sta $a000+LEFT+40*(28+TOP),x
	lda buffer+LEFT+40*30,x
	sta $a000+LEFT+40*(30+TOP),x
	lda buffer+LEFT+40*32,x
	sta $a000+LEFT+40*(32+TOP),x
	lda buffer+LEFT+40*34,x
	sta $a000+LEFT+40*(34+TOP),x
	lda buffer+LEFT+40*36,x
	sta $a000+LEFT+40*(36+TOP),x
	lda buffer+LEFT+40*38,x
	sta $a000+LEFT+40*(38+TOP),x
	lda buffer+LEFT+40*40,x
	sta $a000+LEFT+40*(40+TOP),x
	lda buffer+LEFT+40*42,x
	sta $a000+LEFT+40*(42+TOP),x
	lda buffer+LEFT+40*44,x
	sta $a000+LEFT+40*(44+TOP),x
	lda buffer+LEFT+40*46,x
	sta $a000+LEFT+40*(46+TOP),x
	lda buffer+LEFT+40*48,x
	sta $a000+LEFT+40*(48+TOP),x
	lda buffer+LEFT+40*50,x
	sta $a000+LEFT+40*(50+TOP),x
	lda buffer+LEFT+40*52,x
	sta $a000+LEFT+40*(52+TOP),x
	lda buffer+LEFT+40*54,x
	sta $a000+LEFT+40*(54+TOP),x
	lda buffer+LEFT+40*56,x
	sta $a000+LEFT+40*(56+TOP),x
	lda buffer+LEFT+40*58,x
	sta $a000+LEFT+40*(58+TOP),x
	lda buffer+LEFT+40*60,x
	sta $a000+LEFT+40*(60+TOP),x
	lda buffer+LEFT+40*62,x
	sta $a000+LEFT+40*(62+TOP),x
	lda buffer+LEFT+40*64,x
	sta $a000+LEFT+40*(64+TOP),x
	lda buffer+LEFT+40*66,x
	sta $a000+LEFT+40*(66+TOP),x
	lda buffer+LEFT+40*68,x
	sta $a000+LEFT+40*(68+TOP),x
	lda buffer+LEFT+40*70,x
	sta $a000+LEFT+40*(70+TOP),x
	lda buffer+LEFT+40*72,x
	sta $a000+LEFT+40*(72+TOP),x
	lda buffer+LEFT+40*74,x
	sta $a000+LEFT+40*(74+TOP),x
	lda buffer+LEFT+40*76,x
	sta $a000+LEFT+40*(76+TOP),x
	lda buffer+LEFT+40*78,x
	sta $a000+LEFT+40*(78+TOP),x
	lda buffer+LEFT+40*80,x
	sta $a000+LEFT+40*(80+TOP),x
	lda buffer+LEFT+40*82,x
	sta $a000+LEFT+40*(82+TOP),x
	lda buffer+LEFT+40*84,x
	sta $a000+LEFT+40*(84+TOP),x
	lda buffer+LEFT+40*86,x
	sta $a000+LEFT+40*(86+TOP),x
	lda buffer+LEFT+40*88,x
	sta $a000+LEFT+40*(88+TOP),x
	lda buffer+LEFT+40*90,x
	sta $a000+LEFT+40*(90+TOP),x
	lda buffer+LEFT+40*92,x
	sta $a000+LEFT+40*(92+TOP),x
	lda buffer+LEFT+40*94,x
	sta $a000+LEFT+40*(94+TOP),x
	lda buffer+LEFT+40*96,x
	sta $a000+LEFT+40*(96+TOP),x
	lda buffer+LEFT+40*98,x
	sta $a000+LEFT+40*(98+TOP),x
	lda buffer+LEFT+40*100,x
	sta $a000+LEFT+40*(100+TOP),x
	lda buffer+LEFT+40*102,x
	sta $a000+LEFT+40*(102+TOP),x
	lda buffer+LEFT+40*104,x
	sta $a000+LEFT+40*(104+TOP),x
	lda buffer+LEFT+40*106,x
	sta $a000+LEFT+40*(106+TOP),x
	lda buffer+LEFT+40*108,x
	sta $a000+LEFT+40*(108+TOP),x
	lda buffer+LEFT+40*110,x
	sta $a000+LEFT+40*(110+TOP),x
	lda buffer+LEFT+40*112,x
	sta $a000+LEFT+40*(112+TOP),x
	lda buffer+LEFT+40*114,x
	sta $a000+LEFT+40*(114+TOP),x
	lda buffer+LEFT+40*116,x
	sta $a000+LEFT+40*(116+TOP),x
	lda buffer+LEFT+40*118,x
	sta $a000+LEFT+40*(118+TOP),x
	lda buffer+LEFT+40*120,x
	sta $a000+LEFT+40*(120+TOP),x
	dex
	bmi end
	jmp loop
end
	rts
.)

clr_hires2even
.(
	ldx #WIDTH
	lda #$40
loop
	sta buffer+LEFT+40*0,x
	sta buffer+LEFT+40*2,x
	sta buffer+LEFT+40*4,x
	sta buffer+LEFT+40*6,x
	sta buffer+LEFT+40*8,x
	sta buffer+LEFT+40*10,x
	sta buffer+LEFT+40*12,x
	sta buffer+LEFT+40*14,x
	sta buffer+LEFT+40*16,x
	sta buffer+LEFT+40*18,x
	sta buffer+LEFT+40*20,x
	sta buffer+LEFT+40*22,x
	sta buffer+LEFT+40*24,x
	sta buffer+LEFT+40*26,x
	sta buffer+LEFT+40*28,x
	sta buffer+LEFT+40*30,x
	sta buffer+LEFT+40*32,x
	sta buffer+LEFT+40*34,x
	sta buffer+LEFT+40*36,x
	sta buffer+LEFT+40*38,x
	sta buffer+LEFT+40*40,x
	sta buffer+LEFT+40*42,x
	sta buffer+LEFT+40*44,x
	sta buffer+LEFT+40*46,x
	sta buffer+LEFT+40*48,x
	sta buffer+LEFT+40*50,x
	sta buffer+LEFT+40*52,x
	sta buffer+LEFT+40*54,x
	sta buffer+LEFT+40*56,x
	sta buffer+LEFT+40*58,x
	sta buffer+LEFT+40*60,x
	sta buffer+LEFT+40*62,x
	sta buffer+LEFT+40*64,x
	sta buffer+LEFT+40*66,x
	sta buffer+LEFT+40*68,x
	sta buffer+LEFT+40*70,x
	sta buffer+LEFT+40*72,x
	sta buffer+LEFT+40*74,x
	sta buffer+LEFT+40*76,x
	sta buffer+LEFT+40*78,x
	sta buffer+LEFT+40*80,x
	sta buffer+LEFT+40*82,x
	sta buffer+LEFT+40*84,x
	sta buffer+LEFT+40*86,x
	sta buffer+LEFT+40*88,x
	sta buffer+LEFT+40*90,x
	sta buffer+LEFT+40*92,x
	sta buffer+LEFT+40*94,x
	sta buffer+LEFT+40*96,x
	sta buffer+LEFT+40*98,x
	sta buffer+LEFT+40*100,x
	sta buffer+LEFT+40*102,x
	sta buffer+LEFT+40*104,x
	sta buffer+LEFT+40*106,x
	sta buffer+LEFT+40*108,x
	sta buffer+LEFT+40*110,x
	sta buffer+LEFT+40*112,x
	sta buffer+LEFT+40*114,x
	sta buffer+LEFT+40*116,x
	sta buffer+LEFT+40*118,x
	sta buffer+LEFT+40*120,x
	dex
	bmi end
	jmp loop
end
	rts
.)


*/

#endif


;#define STARTCTRL $bf68-(61*40)
#define STARTCTRL $bf68-(68*40)

countlines .byt 0

load_frame
.(
    
    lda #67;60
    sta countlines

    lda #<STARTCTRL
    sta tmp0
    lda #>STARTCTRL
    sta tmp0+1

    lda #<_controls
    sta tmp1
    lda #>_controls
    sta tmp1+1

	jsr copy_mem
	

	lda #11
    sta countlines

    lda #<$a000
    sta tmp0
    lda #>$a000
    sta tmp0+1

    lda #<_up_controls
    sta tmp1
    lda #>_up_controls
    sta tmp1+1

	jmp copy_mem

	;rts

.)


copy_mem
.(
looplines
    ldy #39
loopscans
    lda (tmp1),y
    sta (tmp0),y
    dey
    bpl loopscans
    
    lda tmp0
    clc
    adc #40
    bcc noinc1
    inc tmp0+1
noinc1
    sta tmp0

    lda tmp1
    clc
    adc #40
    bcc noinc2
    inc tmp1+1
noinc2
    sta tmp1
    
    dec countlines
    bne looplines
	rts
.)

save_frame
.(
    jsr clear_compass
    jsr EraseRadar
	

    lda #67;60
    sta countlines

    lda #<STARTCTRL
    sta tmp1
    lda #>STARTCTRL
    sta tmp1+1

    lda #<_controls
    sta tmp0
    lda #>_controls
    sta tmp0+1

	jsr copy_mem

	lda #11
    sta countlines

    lda #<$a000
    sta tmp1
    lda #>$a000
    sta tmp1+1

    lda #<_up_controls
    sta tmp0
    lda #>_up_controls
    sta tmp0+1

	jmp copy_mem

    ;rts

.)







