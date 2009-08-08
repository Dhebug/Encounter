;OBE_Code.s - Optimised Bitmap Encoding - Twilighte 2009 V1.0
;Embeds movement steps in bitmap data to facilitate only writing bytes to active
;(graphic) areas of screen.
#define BOX_X	$BFE0
#define BOX_Y	$BFE1
#define BOX_W	$BFE2
#define BOX_H	$BFE3
#define REL_X	$BFE4
#define REL_Y	$BFE5
#define OBE_INTERLACEFIRST	$BFE6
#define OBE_INTERLACEMODE	$BFE7

 .zero
*=$00

screen	.dsb 2
source	.dsb 2
Temp01	.dsb 1
InterlaceRow	.dsb 1
CursorX	.dsb 1
CursorY	.dsb 1
RowType	.dsb 1

 .text
*=$9C00

PlotBoxNRel
	lda BOX_X
	clc
	ldy BOX_Y
	adc ylocl,y
	sta screen
	lda yloch,y
	adc #00
	sta screen+1
	
	;Invert top row
	ldy BOX_W
.(
loop1	lda (screen),y
	eor #128
	sta (screen),y
	dey
	bpl loop1
.)
	;Plot REL byte
	lda REL_Y
	clc
	adc BOX_Y
	tay
	lda ylocl,y
	sta screen
	lda yloch,y
	sta screen+1
	lda REL_X
	clc
	adc BOX_X
	tay
	lda (screen),y
	eor #128
	sta (screen),y
	
	lda BOX_Y
	clc
	adc BOX_H
	tay
	lda BOX_X
	clc
	adc ylocl,y
	sta screen
	lda yloch,y
	adc #00
	sta screen+1
	
	;Invert bottom row
	ldy BOX_W
.(
loop1	lda (screen),y
	eor #128
	sta (screen),y
	dey
	bpl loop1
.)
	rts

	
ylocl
 .byt $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68,$90,$B8,$E0,$08,$30,$58,$80,$A8,$D0,$F8,$20,$48,$70,$98,$C0,$E8,$10,$38,$60,$88,$B0,$D8
 .byt $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68,$90,$B8,$E0,$08,$30,$58,$80,$A8,$D0,$F8,$20,$48,$70,$98,$C0,$E8,$10,$38,$60,$88,$B0,$D8
 .byt $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68,$90,$B8,$E0,$08,$30,$58,$80,$A8,$D0,$F8,$20,$48,$70,$98,$C0,$E8,$10,$38,$60,$88,$B0,$D8
 .byt $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68,$90,$B8,$E0,$08,$30,$58,$80,$A8,$D0,$F8,$20,$48,$70,$98,$C0,$E8,$10,$38,$60,$88,$B0,$D8
 .byt $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68,$90,$B8,$E0,$08,$30,$58,$80,$A8,$D0,$F8,$20,$48,$70,$98,$C0,$E8,$10,$38,$60,$88,$B0,$D8
 .byt $00,$28,$50,$78,$A0,$C8,$F0,$18,$40,$68,$90,$B8,$E0,$08,$30,$58,$80,$A8,$D0,$F8,$20,$48,$70,$98,$C0,$E8,$10,$38,$60,$88,$B0,$D8
 .byt $00,$28,$50,$78,$A0,$C8,$F0,$18
yloch
 .byt $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A1,$A1,$A1,$A1,$A1,$A1,$A2,$A2,$A2,$A2,$A2,$A2,$A2,$A3,$A3,$A3,$A3,$A3,$A3,$A4,$A4,$A4,$A4,$A4,$A4
 .byt $A5,$A5,$A5,$A5,$A5,$A5,$A5,$A6,$A6,$A6,$A6,$A6,$A6,$A7,$A7,$A7,$A7,$A7,$A7,$A7,$A8,$A8,$A8,$A8,$A8,$A8,$A9,$A9,$A9,$A9,$A9,$A9
 .byt $AA,$AA,$AA,$AA,$AA,$AA,$AA,$AB,$AB,$AB,$AB,$AB,$AB,$AC,$AC,$AC,$AC,$AC,$AC,$AC,$AD,$AD,$AD,$AD,$AD,$AD,$AE,$AE,$AE,$AE,$AE,$AE
 .byt $AF,$AF,$AF,$AF,$AF,$AF,$AF,$B0,$B0,$B0,$B0,$B0,$B0,$B1,$B1,$B1,$B1,$B1,$B1,$B1,$B2,$B2,$B2,$B2,$B2,$B2,$B3,$B3,$B3,$B3,$B3,$B3
 .byt $B4,$B4,$B4,$B4,$B4,$B4,$B4,$B5,$B5,$B5,$B5,$B5,$B5,$B6,$B6,$B6,$B6,$B6,$B6,$B6,$B7,$B7,$B7,$B7,$B7,$B7,$B8,$B8,$B8,$B8,$B8,$B8
 .byt $B9,$B9,$B9,$B9,$B9,$B9,$B9,$BA,$BA,$BA,$BA,$BA,$BA,$BB,$BB,$BB,$BB,$BB,$BB,$BB,$BC,$BC,$BC,$BC,$BC,$BC,$BD,$BD,$BD,$BD,$BD,$BD
 .byt $BE,$BE,$BE,$BE,$BE,$BE,$BE,$BF
	
End
	rts
PlotOBE
	
	;
	lda REL_X
	clc
	adc #3
	sta CursorX
	lda REL_Y
	adc #11
	sta CursorY
	lda #<$9000
	sta source
	lda #>$9000
	sta source+1
	ldy #00
	lda OBE_INTERLACEFIRST
	sta InterlaceRow
	and CursorY
	sta RowType
.(	
loop1	lda (source),y
;	sei
;	jmp loop1
	bmi Inversed
	cmp #8
	beq End
	bcc Plot
	cmp #24
	bcc Plot
	cmp #64
	bcs Plot
XStep	cmp #44
	bcc MoveLeft
MoveRight	sbc #44
	clc
	adc CursorX
	sta CursorX
	jmp CalcScreenAndNextByte
MoveLeft	sec
	sbc #24
	sta Temp01
	lda CursorX
	sbc Temp01
	sta CursorX
	jmp CalcScreenAndNextByte
Inversed	cmp #24+128
	bcc Plot
	cmp #64+128
	bcs Plot
YStep	cmp #44+128
	bcc MoveUp
MoveDown	sbc #44+128
	clc
	adc CursorY
	sta CursorY
	;Currently we can't deal with jumping more than 1 row
	jmp CalulateIfInterlaceRow
MoveUp	sec
	sbc #24+128
	sta Temp01
	lda CursorY
	sbc Temp01
	sta CursorY
CalulateIfInterlaceRow
	and #1
	ldx #00
	cmp RowType
	bne NotInterlaceRow
	ldx #1
NotInterlaceRow
	stx InterlaceRow
	jmp CalcScreenAndNextByte
Plot	;Interlace?
	ldx OBE_INTERLACEMODE
	beq NonInterlacedRow
Interlaced
	ldx InterlaceRow
	bne NonInterlacedRow
InterlaceByte
	and (screen),y
	sta (screen),y
	inc CursorX
	jmp CalcScreenAndNextByte
NonInterlacedRow
	sta (screen),y
	inc CursorX
CalcScreenAndNextByte
	lda CursorX
	ldx CursorY
	clc
	adc ylocl,x
	sta screen
	lda yloch,x
	adc #00
	sta screen+1
NextByte	inc source
	bne skip1
	inc source+1
skip1	jmp loop1
.)	
	

	

	
	
		