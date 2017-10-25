;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Debugging and exception catching

#include "debug.h"

#define COLOR(color) pha:lda #16+(color&7):sta $bb80+40*27:pla

#ifdef DOCHECKS_A
#endif
	
LastCommandCalled .byt $ff
LastFunctionCalled .byt $ff
	
	
;; Catch engine exceptions (no memory...)
#ifdef DOCHECKS_B
catchEngineException
	COLOR(1)
#ifdef SHOWDBGINFO	
	jsr DisplayErrorCode
#endif	
	sec
	bcs *
	rts
#endif

; Catch some basic scripting exceptions
#ifdef DOCHECKS_C
catchScriptException
	COLOR(3)
#ifdef SHOWDBGINFO	
	jsr DisplayErrorCode
#endif	
	sec
	bcs *
	rts
#endif

#ifdef SHOWDBGINFO
HexData	.byt "0123456789ABCDEF"
DisplayErrorCode
	pha
	ldy #<$a000+2
	sty screen
	ldy #>$a000+2
	sty screen+1	
	lsr
	lsr
	lsr
	lsr	
	tax
	lda HexData,x
	jsr put_code
	pla
	and #15
	tax
	lda HexData,x	
	jmp put_code
	

d1 .byt 00
d2 .byt 00

DisplayResToLoad
.(
	lda tmp+1
	sta d2
	lda tmp
	sta d1
	
	lda #<$a000+25
	sta screen
	lda #>$a000+25
	sta screen+1
	
	; GetType	
	lda d1
	lsr
	lsr
	lsr
	lsr
	tax
	lda HexData,x
	jsr put_code

	lda d1
	and #%00001111
	tax
	lda HexData,x	
	jsr put_code

	jsr put_space
	; GetId	
	lda d2
	lsr
	lsr
	lsr
	lsr
	tax
	lda HexData,x
	jsr put_code
	
	lda d2
	and #15
	tax
	lda HexData,x
	jsr put_code

	lda d1
	sta tmp
	lda d2
	sta tmp+1
	rts
.)
#endif

#ifdef DISPLAY_MEMORY
#ifndef SHOWDBGINFO
HexData	.byt "0123456789ABCDEF"
#endif
freemem .word 0000	
DisplayMem
.(
	pha
	lda tmp
	pha
	lda tmp0
	pha
	lda tmp0+1
	pha
	stx savx+1
	sty savy+1
	ldy #<$a000+20
	sty screen
	ldy #>$a000+20
	sty screen+1	
	lda freemem+1
	jsr putbyte
	lda freemem
	jsr putbyte
savx
	ldx #0
savy 
	ldy #0
	pla
	sta tmp0+1
	pla
	sta tmp0
	pla
	sta tmp	
	pla
	rts
putbyte
	pha
	lsr
	lsr
	lsr
	lsr	
	tax
	lda HexData,x
	jsr put_code
	pla
	and #15
	tax
	lda HexData,x	
	jmp put_code
.)
#endif
	
__endofOASISresidentpart

#if *>=$fc00
#error ******** Disk loading code overwritten! Try moving tables outside overlay ram
#endif

.dsb $fc00-*
__LoaderStartCode
	

