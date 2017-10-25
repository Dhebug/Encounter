/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

;; Mouse management and UI routines

#include "script.h"
#include "params.h"
#include "gameids.h"

; Zero page vars moved to data.s 

.text

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code to manage mouse cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InitMouse
.(
	lda #120
	sta plotX
	sta newPlotX
	lda #100
	sta plotY
	sta newPlotY
	lda #0
	sta MouseInvalid
	sta MouseShown
	sta MouseClicked
	lda #1
	sta MouseOff
	rts
.)

ShowMouse
.(
	lda MouseOff
	bne ret
	lda MouseShown
	beq doit
ret	
	rts
doit
	inc MouseShown
	jmp PlotCross
.)
HideMouse
.(
	;lda MouseOff
	;bne ret
	lda MouseShown
	bne doit
ret	
	rts
doit
	dec MouseShown
	jmp PlotCross
.)


UpdateMouse
.(
	lda MouseShown
	beq end
	lda MouseInvalid
	bne doit 
end	
	rts
doit
	lda #0
	sta MouseInvalid
	jsr HideMouse
	lda newPlotX
	sta plotX
	lda newPlotY
	sta plotY
	jsr ShowMouse
	jmp ProcessMouseMoves
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PlotCross
; Draws (with eor) a cross (clipped) at
; current plotX, plotY position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; META: TODO: This should be optimized and
; different cursors should be selectable

#define CURSOR_SIZE 5
maskattr .byt %01000000

#define NEWPLOTCROSS
#ifdef NEWPLOTCROSS
#define inic op1
PlotCross
.(
	ldx plotX
	ldy plotY
	jsr PixelAddress  
	sta tmp
	lda #%00111111
.(   
	eor (tmp0),y
	bit maskattr
	beq skip1
	sta (tmp0),y         
skip1 
.)
	dey
	lda tmp
	sec
	sbc #1
	sta tmp
.(   
	eor (tmp0),y
	bit maskattr
	beq skip1
	sta (tmp0),y         
skip1 
.)
	iny
	iny
	lda tmp
	eor #$ff
	asl
	and #%00111111
.(   
	eor (tmp0),y
	bit maskattr
	beq skip1
	sta (tmp0),y         
skip1 
.)
        ; vertical arm
	lda plotY
	sec
	sbc #CURSOR_SIZE
	bcs inside3
	lda #0
inside3
	sta inic
	
	lda plotY
	clc
	adc #CURSOR_SIZE+1
	cmp #200-8 
	bcc inside4
	lda #199-8
inside4
	sta endc2+1   
	
	ldx plotX
	ldy inic
	jsr PixelAddress     
	sta tmp
loopver
	lda tmp
	eor (tmp0),y
	bit maskattr
	beq skip2
	sta (tmp0),y         
skip2 
	clc
	lda tmp0
	adc #40
	sta tmp0
	bcc nocarry
	inc tmp0+1
 nocarry
	inc inic
	lda inic
endc2
	cmp #0  ; SMC
	bne loopver

	rts
;inic .byt 0
#undef inic
.) 
#else

PlotCross
.(
#define inic op1
    ; init point X
    lda plotX
    sec
    sbc #CURSOR_SIZE
    cmp #12-6
    bcs inside1
    lda #12-6
inside1
    sta inic

    lda plotX
    clc
    adc #CURSOR_SIZE
    cmp #240-12+6 
    bcc inside2
    lda #240-12-1+6
inside2
    sta endc+1   
    
    ; horizontal arm
    ldy plotY
    ldx inic
    jsr PixelAddress
    sta tmp
 loophor   
    lda tmp
    eor (tmp0),y
    bit maskattr
    beq skip1
    sta (tmp0),y         
skip1 
    lsr tmp
    bne kk
    lda #%100000
    iny
    sta tmp
kk
    inc inic
    lda inic
endc
    cmp #0  ;SMC
    bne loophor

    ; vertical arm
    lda plotY
    sec
    sbc #CURSOR_SIZE
    ;cmp #0
    bcs inside3
    lda #0
inside3
    sta inic

    lda plotY
    clc
    adc #CURSOR_SIZE
    cmp #200-8 
    bcc inside4
    lda #199-8
inside4
    sta endc2+1   

    ldx plotX
    ldy inic
    jsr PixelAddress     
    sta tmp
loopver
    lda tmp
    eor (tmp0),y
    bit maskattr
    beq skip2
    sta (tmp0),y         
 skip2 
    clc
    lda tmp0
    adc #40
    sta tmp0
    bcc nocarry
    inc tmp0+1
 nocarry
    inc inic
    lda inic
endc2
    cmp #0  ; SMC
    bne loopver

    rts
;inic .byt 0
#undef inic
.) 


#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Checks if the cursor is
; over a tile marked for redraw.
; if it is the case returns with z=0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 	
IsCursorInvalid
.(
	lda plotY
	cmp #(ROOM_ROWS)*8+6
	bcc indrawarea
	lda #0
	rts
indrawarea
	; Divide by 8
	lsr
	lsr
	lsr
	; Save, but first keep it in [0..14]
	tay
	beq do
	dey ; Start at pos-1
do
	cpy #15
	bcc do2
	ldy #14
do2	
	sty smc_Row+1
	
	ldx plotX
	; Divide by 6
	lda _TableDiv6,x
	; Same again... keep it in [0..COLS-2]
	sec
	sbc #1
	cmp #VISIBLE_COLS-1
	bcc do3
	lda #VISIBLE_COLS-2
do3	
	sta smc_Col+1

	lda #3
	sta tmp0+1
loop	
smc_Row
	ldy #0
smc_Col	
	lda #0
	jsr getSRBforTile
	sta tmp0
	
	lda #3
	sta tmp1
loop2	
	; Is it marked for redraw?
	lda (tmp4),y
	bit tmp0
	bne invalid
	
	clc
	lda #5
	adc tmp4
	bcc skip1
	inc tmp4+1
skip1	
	sta tmp4
	
	dec tmp1
	bne loop2

	inc smc_Col+1
	dec tmp0+1
	bne loop

valid	
	; We didn't find any invalid
	; tile for the cursor
	; Return with Z=1
	lda #0
invalid
	; Return with Z=0
	; if bne invalid above is true
	; else with Z=1
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Usual PixelAddress routine
; Pass X,Y the pixel coordinates, return
; the adress as (tmp0),y and bitflag
; in reg A.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PixelAddress
.(
	lda _HiresAddrLow,y			; 4
	sta tmp0+0				; 3
	lda _HiresAddrHigh,y			; 4
	sta tmp0+1				; 3 => Total 14 cycles

  	ldy _TableDiv6,x			; 4
	lda _TableBit6Reverse,x			; 4
    
	rts						; 22+rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Routines for keyboard reading simulating the mouse
; and more...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


#define NUM_KEYS 5	


	
; Tables for keyboard handling	
; These two have been moved to tables.s	
;tab_banks 		.byt 4,4,4,4,4
;tab_bits 		.byt %00000001,%10000000,%00100000,%01000000,%00001000
tab_routinel 		.byt <click,<kright,<kleft,<kdown,<kup
tab_routineh 		.byt >click,>kright,>kleft,>kdown,>kup
old_stat		.dsb NUM_KEYS,0

.zero
mtmp 			.byt 0
.text
escape
.(
	ldx override_thread
	cpx #$ff
	beq menu
	
	lda override_offset
	cmp thread_offset_lo,x
	lda override_offset+1
	sbc thread_offset_hi,x
	; META: Check this... not sure it is okay
	;bvc skip
	;eor #$80
;skip	
	bcc end	; Cannot jump backwards
	
	lda override_offset
	sta thread_offset_lo,x
	lda override_offset+1
	sta thread_offset_hi,x
	lda #$ff
	sta override_thread
	lda #SFX_ESC
	jmp _PlaySfx	
end	
	rts
menu	
	; Shows up the meny if not on a cutscene
	jmp DoMenu
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mouse movement, with accelerations
; and position check to void getting offscreen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
acc_mouse
	ldy old_stat,x
	lda #0
	cpy #4
	adc #0
	cpy #16
	adc #0
	cpy #32
	adc #0
	rts
click
.(	
	ldx #0
	lda old_stat,x
	bne skip
	lda plotY
	sta clickY
	lda plotX
	sta clickX
	inc MouseClicked
skip	
	rts
.)	
kright
	ldx #1
	jsr acc_mouse
	sec	
	adc newPlotX
	cmp #240-12+6
	bcs cant
	sta newPlotX
can
	inc MouseInvalid ; This may fail if called 256 times without updating
cant	
	rts
kleft
	ldx #2
	jsr acc_mouse
	clc
	sta mtmp
	lda newPlotX
	sbc mtmp
	cmp #12-6
	bcc cant
	sta newPlotX
	bcs can
kdown
	ldx #3
	jsr acc_mouse
	sec	
	adc newPlotY
	cmp #199-8
	bcs cant
	sta newPlotY
	bcc can
kup
	ldx #4
	jsr acc_mouse
	clc
	sta mtmp
	lda newPlotY
	sbc mtmp
	bcc cant
	beq cant
	sta newPlotY
	bcs can

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Process keypresses to simulate
; mouse movements.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ProcessUserInput
.(
	lda MouseOff
	bne end

	ldx #NUM_KEYS-1
loop
#ifdef IJK_SUPPORT	
	lda $100
	beq UseKB
	lda joy_Left
	and joybits,x	
	jmp process
UseKB	
#endif	
	ldy tab_banks,x	
	lda _KeyBank,y
	and tab_bits,x
process	
	beq skip
	lda tab_routinel,x
	sta smc_command+1
	lda tab_routineh,x
	sta smc_command+2
	stx keysav+1
smc_command
	jsr $1234
+keysav
	ldx #0
	inc old_stat,x
	bne skip2
skip	
	lda #0
	sta old_stat,x
skip2	
	dex
	bpl loop
end	
	rts
.)

#ifdef IJK_SUPPORT	


; Order is click, right, left, down and up
;joybits .byt 32, 2, 1, 8, 16	; This is used if the comply to Generic Format code is used.
joybits .byt %00100, %00001, %00010, %10000, %01000	; Direct result of IJK driver

#endif

SetMouseOff
.(
	lda MouseOff
	beq setitoff
ret	
	rts
setitoff
	lda #1
	sta MouseOff
	jmp HideMouse
+SetMouseOn
	lda MouseOff
	beq ret
	lda #0
	sta MouseOff
	jmp ShowMouse
.)


