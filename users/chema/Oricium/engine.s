;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Engine routines

#include "params.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _clear_backbuffer
;; Clears the backbuffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_clear_backbuffer
.(
	lda #32
	ldy #39-PCOLSL-PCOLSR
loop
	sta _backbuffer+40*0+PCOLSL,y
	sta _backbuffer+40*1+PCOLSL,y
	sta _backbuffer+40*2+PCOLSL,y
	sta _backbuffer+40*3+PCOLSL,y
	sta _backbuffer+40*4+PCOLSL,y
	sta _backbuffer+40*5+PCOLSL,y
	sta _backbuffer+40*6+PCOLSL,y
	sta _backbuffer+40*7+PCOLSL,y
	sta _backbuffer+40*8+PCOLSL,y
	sta _backbuffer+40*9+PCOLSL,y
	sta _backbuffer+40*10+PCOLSL,y
	sta _backbuffer+40*11+PCOLSL,y
	sta _backbuffer+40*12+PCOLSL,y
	sta _backbuffer+40*13+PCOLSL,y
	sta _backbuffer+40*14+PCOLSL,y
	sta _backbuffer+40*15+PCOLSL,y
	sta _backbuffer+40*16+PCOLSL,y
	sta _backbuffer+40*17+PCOLSL,y
	sta _backbuffer+40*18+PCOLSL,y
	sta _backbuffer+40*19+PCOLSL,y
	dey
	bpl loop
	rts
.)

#ifdef TRYAIC
#define SCR_ADDR $bb80+40*START_ROW+1
#else
#define SCR_ADDR $bb80+40*START_ROW
#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _dump_backbuffer
;; Dumps the backbuffer onto screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_dump_backbuffer
.(
	ldy #39-PCOLSL-PCOLSR
loop
	lda _backbuffer+40*0+PCOLSL,y
	sta SCR_ADDR+40*0+PCOLSL,y
	lda _backbuffer+40*1+PCOLSL,y
	sta SCR_ADDR+40*1+PCOLSL,y
	lda _backbuffer+40*2+PCOLSL,y
	sta SCR_ADDR+40*2+PCOLSL,y
	lda _backbuffer+40*3+PCOLSL,y
	sta SCR_ADDR+40*3+PCOLSL,y
	lda _backbuffer+40*4+PCOLSL,y
	sta SCR_ADDR+40*4+PCOLSL,y
	lda _backbuffer+40*5+PCOLSL,y
	sta SCR_ADDR+40*5+PCOLSL,y
	lda _backbuffer+40*6+PCOLSL,y
	sta SCR_ADDR+40*6+PCOLSL,y
	lda _backbuffer+40*7+PCOLSL,y
	sta SCR_ADDR+40*7+PCOLSL,y
	lda _backbuffer+40*8+PCOLSL,y
	sta SCR_ADDR+40*8+PCOLSL,y
	lda _backbuffer+40*9+PCOLSL,y
	sta SCR_ADDR+40*9+PCOLSL,y
	lda _backbuffer+40*10+PCOLSL,y
	sta SCR_ADDR+40*10+PCOLSL,y
	lda _backbuffer+40*11+PCOLSL,y
	sta SCR_ADDR+40*11+PCOLSL,y
	lda _backbuffer+40*12+PCOLSL,y
	sta SCR_ADDR+40*12+PCOLSL,y
	lda _backbuffer+40*13+PCOLSL,y
	sta SCR_ADDR+40*13+PCOLSL,y
	lda _backbuffer+40*14+PCOLSL,y
	sta SCR_ADDR+40*14+PCOLSL,y
	lda _backbuffer+40*15+PCOLSL,y
	sta SCR_ADDR+40*15+PCOLSL,y
	lda _backbuffer+40*16+PCOLSL,y
	sta SCR_ADDR+40*16+PCOLSL,y
	lda _backbuffer+40*17+PCOLSL,y
	sta SCR_ADDR+40*17+PCOLSL,y
	lda _backbuffer+40*18+PCOLSL,y
	sta SCR_ADDR+40*18+PCOLSL,y
	lda _backbuffer+40*19+PCOLSL,y
	sta SCR_ADDR+40*19+PCOLSL,y

	dey
	bpl loop
	rts
.)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; _render_background
;; Draws the background onto the back
;; buffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_render_background
.(
	; Start drawing the background
	; From _inicol onwards.
	; Unrolled to get speed.
	; Takes the tile code from the map
	; which is organized in memory
	; so that every row lies on a page
	; boundary, so an indexed addressing
	; with x=column, gets the tile

	lda #39-PCOLSL-PCOLSR
	tay
	clc
	adc _inicol
	tax
	;ldy #39-PCOLSL-PCOLSR
loop
	lda _start_rows+256*0,x
	sta _backbuffer+40*0+PCOLSL,y
	lda _start_rows+256*1,x
	sta _backbuffer+40*1+PCOLSL,y
	lda _start_rows+256*2,x
	sta _backbuffer+40*2+PCOLSL,y
	lda _start_rows+256*3,x
	sta _backbuffer+40*3+PCOLSL,y
	lda _start_rows+256*4,x
	sta _backbuffer+40*4+PCOLSL,y
	lda _start_rows+256*5,x
	sta _backbuffer+40*5+PCOLSL,y
	lda _start_rows+256*6,x
	sta _backbuffer+40*6+PCOLSL,y
	lda _start_rows+256*7,x
	sta _backbuffer+40*7+PCOLSL,y
	lda _start_rows+256*8,x
	sta _backbuffer+40*8+PCOLSL,y
	lda _start_rows+256*9,x
	sta _backbuffer+40*9+PCOLSL,y
	lda _start_rows+256*10,x
	sta _backbuffer+40*10+PCOLSL,y
	lda _start_rows+256*11,x
	sta _backbuffer+40*11+PCOLSL,y
	lda _start_rows+256*12,x
	sta _backbuffer+40*12+PCOLSL,y
	lda _start_rows+256*13,x
	sta _backbuffer+40*13+PCOLSL,y
	lda _start_rows+256*14,x
	sta _backbuffer+40*14+PCOLSL,y
	lda _start_rows+256*15,x
	sta _backbuffer+40*15+PCOLSL,y
	lda _start_rows+256*16,x
	sta _backbuffer+40*16+PCOLSL,y
	lda _start_rows+256*17,x
	sta _backbuffer+40*17+PCOLSL,y
	lda _start_rows+256*18,x
	sta _backbuffer+40*18+PCOLSL,y
	lda _start_rows+256*19,x
	sta _backbuffer+40*19+PCOLSL,y
	dex 
	dey
	bpl loop
	
	; Plot the stars
	jmp _plot_stars
.)





