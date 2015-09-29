;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Code to handle radar


; Y table (rows 0-23)
_ytablelo
.byt <(RADAR_BASE+0),<(RADAR_BASE+1),<(RADAR_BASE+2),<(RADAR_BASE+3),<(RADAR_BASE+4),<(RADAR_BASE+5),<(RADAR_BASE+6),<(RADAR_BASE+7)
.byt <(RADAR_BASE+88),<(RADAR_BASE+89),<(RADAR_BASE+90),<(RADAR_BASE+91),<(RADAR_BASE+92),<(RADAR_BASE+93),<(RADAR_BASE+94),<(RADAR_BASE+95)
.byt <(RADAR_BASE+176),<(RADAR_BASE+177),<(RADAR_BASE+178),<(RADAR_BASE+179),<(RADAR_BASE+180),<(RADAR_BASE+181),<(RADAR_BASE+182),<(RADAR_BASE+183)

_ytablehi
.byt >(RADAR_BASE+0),>(RADAR_BASE+1),>(RADAR_BASE+2),>(RADAR_BASE+3),>(RADAR_BASE+4),>(RADAR_BASE+5),>(RADAR_BASE+6),>(RADAR_BASE+7)
.byt >(RADAR_BASE+88),>(RADAR_BASE+89),>(RADAR_BASE+90),>(RADAR_BASE+91),>(RADAR_BASE+92),>(RADAR_BASE+93),>(RADAR_BASE+94),>(RADAR_BASE+95)
.byt >(RADAR_BASE+176),>(RADAR_BASE+177),>(RADAR_BASE+178),>(RADAR_BASE+179),>(RADAR_BASE+180),>(RADAR_BASE+181),>(RADAR_BASE+182),>(RADAR_BASE+183)

; X table (columns 0-63)
_xtable
.byt 0,0,0,0,0,0 ; First 6 cols
.byt 8,8,8,8,8,8 
.byt 16,16,16,16,16,16 
.byt 24,24,24,24,24,24
.byt 32,32,32,32,32,32
.byt 40,40,40,40,40,40
.byt 48,48,48,48,48,48
.byt 56,56,56,56,56,56
.byt 64,64,64,64,64,64
.byt 72,72,72,72,72,72
.byt 80,80,80,80,80,80

; Mask table
_masktable
.byt %00100000,%00010000,%00001000,%00000100,%00000010,%00000001
.byt %00100000,%00010000,%00001000,%00000100,%00000010,%00000001
.byt %00100000,%00010000,%00001000,%00000100,%00000010,%00000001
.byt %00100000,%00010000,%00001000,%00000100,%00000010,%00000001
.byt %00100000,%00010000,%00001000,%00000100,%00000010,%00000001
.byt %00100000,%00010000,%00001000,%00000100,%00000010,%00000001
.byt %00100000,%00010000,%00001000,%00000100,%00000010,%00000001
.byt %00100000,%00010000,%00001000,%00000100,%00000010,%00000001
.byt %00100000,%00010000,%00001000,%00000100,%00000010,%00000001
.byt %00100000,%00010000,%00001000,%00000100,%00000010,%00000001
.byt %00100000,%00010000,%00001000,%00000100,%00000010,%00000001


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Plots a pixel in the radar
; area. Y=row, A=col
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_radar_put_pixel
.(
	lsr
	;lsr
	cmp #64
	bcs end
	tax
+rt	
    lda _ytablelo+3,y
    clc
	adc _xtable+1,x
    sta tmp
    lda _ytablehi+3,y
    adc #0
    sta tmp+1

    lda _masktable+1,x
	ldy #0
	eor (tmp),y
	sta (tmp),y
end	
	rts
.)
	
	
_draw_radar
.(
	lda _inicol
	clc
	adc #MANTA_COL
	sta tmp1

	ldx #FIRST_SHOT-1
loop
	; Is sprite active?
	lda sprite_status,x
	beq skip
	
	ldy sprite_rows,x
	lda sprite_cols,x
	sec
	sbc tmp1
	clc
	adc #128/2
	stx savx+1
	jsr _radar_put_pixel
savx
ldx #0

skip
	dex
	cpx #1
	bne loop
	rts
.)






