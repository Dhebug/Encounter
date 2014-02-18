; Add 40 to "tmp1"
#define VIDEOSTART $A7DA
#define LINES 72
#define BYTESWIDE 16
_Add40
.(
	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip	
	rts
.)

_BytePrint
.(
	; load next byte
	lda (tmp0),y
	sta (tmp1),y
	iny
	rts
.)


_DisplayFrame
.(
	lda _PtrGraphic+0
	sta tmp0+0
	lda _PtrGraphic+1
	sta tmp0+1
		
	; set startaddress of video 
	
	lda #<VIDEOSTART
	sta tmp1+0
	lda #>VIDEOSTART
	sta tmp1+1			
	
	; Draw loop
	.(
	ldx #LINES
loop
	ldy #0
	; now print BYTESWIDE bytes (1byte=6pixels, image=LINES pixels across, so BYTESWIDE bytes required
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint
	
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint
	jsr _BytePrint

	.(
	clc
	lda tmp0+0
	adc #BYTESWIDE
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip	
	.)

	jsr _Add40
			
	dex
	bne loop
	.)
		
	; Update PtrGraphic 
	lda tmp0+0
	sta _PtrGraphic+0
	lda tmp0+1
	sta _PtrGraphic+1
	
	rts
.)

_DrawFrame
.(
	.(
	ldx _Frame
loop
	beq end
	clc
	lda _PtrGraphic+0
	; 16 bytes (96 pixels) * 72 lines 
	adc #<BYTESWIDE*LINES
	sta _PtrGraphic+0
	bcc skip
	inc _PtrGraphic+1	
skip
	; add upper half of 16*72 to upper half of ptrgraph
	clc
	lda _PtrGraphic+1
	adc #>BYTESWIDE*LINES
	sta _PtrGraphic+1
	
	dex
	jmp loop
end	
	.)

	jmp _DisplayFrame
.)


; set ink to LEFT of video playback
_VideoInkLeft
.(
	ldx #LINES
	lda #<VIDEOSTART-1
	sta tmp1+0
	lda #>VIDEOSTART-1
	sta tmp1+1
	ldy #0
loop
	lda _InkColor
	sta (tmp1),y
	jsr _Add40
	dex
	bne loop
	rts
.)


