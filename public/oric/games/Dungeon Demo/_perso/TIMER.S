;
;
; Time/Synchronisation 6502 assembly library
; (c) 1996 Micka‰l POINTIER  (Dbug from NeXT)
;
; Time value is 16 bits coded, so the maximum value is:
;  65536 100th of a second
;  655 seconds
;  10 minutes
;


_FlagSync	BYTE 0


_TimeValueIrq		WORD 0




_Wait
	ldy #0
	lda (sp),y			; Lower part of time
	tax

	iny
	lda (sp),y			; Upper part of time
	tay

	iny
	inx

wait_loop
	inc	_FlagSync
wait_sync
	lda	_FlagSync
	bne	wait_sync
	dex
	bne	wait_loop
	dey
	bne	wait_loop

	rts




_TimeIrqHandler
	ldx	#0
	stx	_FlagSync

	clc
	lda	_TimeValueIrq
	adc	#1
	sta	_TimeValueIrq

	lda	_TimeValueIrq+1
	adc	#0
	sta	_TimeValueIrq+1
	rts




_VSync
	ldx	#2
vsync_loop_2
	lda	#1
	sta	_FlagSync
vsync_loop_1
	lda	_FlagSync
	bne	vsync_loop_1
	dex
	bne	vsync_loop_2
	rts



