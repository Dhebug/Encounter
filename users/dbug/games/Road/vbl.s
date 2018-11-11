

_VSync
	lda $300
vsync_wait
	lda $30D
	and #%00010000 ;test du bit cb1 du registre d'indicateur d'IRQ
	beq vsync_wait
	rts

_VSyncCounter1	.word 0
_VSyncCounter2	.word 0


_VSyncGetCounter
	lda #0
	sta _VSyncCounter1
	sta _VSyncCounter1+1
	sta _VSyncCounter2
	sta _VSyncCounter2+1

	lda $300
vsynccounter_wait1
	lda $30D
	and #%00010000 ;test du bit cb1 du registre d'indicateur d'IRQ
	bne vsynccounter_wait1_end

	inc _VSyncCounter1
	bne vsynccounter_wait1
	inc _VSyncCounter1+1
	beq vsynccounter_end
	jmp vsynccounter_wait1

vsynccounter_wait1_end


	lda $300
vsynccounter_wait2
	lda $30D
	and #%00010000 ;test du bit cb1 du registre d'indicateur d'IRQ
	bne vsynccounter_wait2_end

	inc _VSyncCounter2
	bne vsynccounter_wait2
	inc _VSyncCounter2+1
	beq vsynccounter_wait2_end
	jmp vsynccounter_wait2

vsynccounter_wait2_end

vsynccounter_end
	rts





_IrqOff
	sei
	rts



_Temporize
	ldy #1
temporize_outer
	ldx #0
temporize_inner
	dex
	bne temporize_inner

	dey
	bne temporize_outer

	rts


_DrawBarX	.byt 0
_DrawBarValue	.byt 0

_DrawBar
	lda #$00
	sta tmp0
	lda #$a0
	sta tmp0+1
	ldx #200
	ldy _DrawBarX	
DrawBarLoopY
	lda _DrawBarValue
	sta (tmp0),y

	clc
	lda tmp0
	adc #40
	sta tmp0
	bcc toto
	inc tmp0+1
toto
	dex
	bne DrawBarLoopY
	rts

