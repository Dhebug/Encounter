;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Code to handle the starfield

#include "params.h"	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _create_stars
;; Assign random location to stars
;; Be sure they are in odd rows
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_create_stars
.(
	ldy #NSTARS-1
loop
	jsr randgen
	and #%111
	adc #0
	ldx randseed
    stx tmp
    rol tmp
    adc #0
    
    
	sec
	rol
	tax

    ; Align _backbuffer	so that low part 
    ; is always zero
	;lda #<_backbuffer
	;clc
	;adc tab_m40lo,x
	lda tab_m40lo,x
	sta starslo,y
	clc
	lda #>_backbuffer
	adc tab_m40hi,x
	sta starshi,y

	jsr randgen
	cmp #74
	bcc doit
	and #31*2
	;adc #3
doit
	sta starsx,y
	dey
	bpl loop
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Perform scroll with the starfield
; one routine for each direction
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_scroll_stars_left
.(
	lda _star_tile+3
	asl
	and #%00111111
	beq update
	;ora #%01000000
	sta _star_tile+3
	rts
update
	ldx #NSTARS-1
loop
	dec starsx,x
	dex
	bpl loop

	lda #%00000001
	sta smc_updatestar+1
	rts
.)

_scroll_stars_right
.(
	lda _star_tile+3
	and #%00111111
	lsr
	beq updates
	;ora #%01000000
	sta _star_tile+3
	rts
updates
	lda #%00100000
	sta smc_updatestar+1

	ldx #NSTARS-1
loop
	inc starsx,x
	dex
	bpl loop

	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _plot_stars
;; Draw star tiles on backbuffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_plot_stars
.(
	ldx #NSTARS-1
loop
	lda starslo,x
	sta tmp
	lda starshi,x
	sta tmp+1

	ldy starsx,x
	;cmp #2
	bmi skip
	cpy #39
	bcs skip
	
	;tay
	lda (tmp),y
	cmp #32
	bne skip

	lda #STAR_TILE+32
	sta (tmp),y
skip
	dex
	bpl loop
	rts
.)
