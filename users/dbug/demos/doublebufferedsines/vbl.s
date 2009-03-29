

#define VSYNC_COUNTER_ADDR_1 $bb80+33+17*40
#define VSYNC_COUNTER_ADDR_2 $bb80+33+18*40




_VSyncHexaDigit
	.asc "0123456789ABCDEF"




_VSync
	lda $300
vsync_wait
	lda $30D
	and #%00010000 ;test du bit cb1 du registre d'indicateur d'IRQ
	beq vsync_wait
	rts


_VSyncShowCounter1
.(
	lda _VSyncCounter1+0
	and #$0F
	tax
	lda _VSyncHexaDigit,x
	sta VSYNC_COUNTER_ADDR_1+3
	lda _VSyncCounter1+0
	lsr
	lsr
	lsr
	lsr
	tax
	lda _VSyncHexaDigit,x
	sta VSYNC_COUNTER_ADDR_1+2

	lda _VSyncCounter1+1
	and #$0F
	tax
	lda _VSyncHexaDigit,x
	sta VSYNC_COUNTER_ADDR_1+1
	lda _VSyncCounter1+1
	lsr
	lsr
	lsr
	lsr
	tax
	lda _VSyncHexaDigit,x
	sta VSYNC_COUNTER_ADDR_1+0
	rts
.)


_VSyncShowCounter2
.(
	lda _VSyncCounter1+0
	and #$0F
	tax
	lda _VSyncHexaDigit,x
	sta VSYNC_COUNTER_ADDR_2+3
	lda _VSyncCounter1+0
	lsr
	lsr
	lsr
	lsr
	tax
	lda _VSyncHexaDigit,x
	sta VSYNC_COUNTER_ADDR_2+2

	lda _VSyncCounter1+1
	and #$0F
	tax
	lda _VSyncHexaDigit,x
	sta VSYNC_COUNTER_ADDR_2+1
	lda _VSyncCounter1+1
	lsr
	lsr
	lsr
	lsr
	tax
	lda _VSyncHexaDigit,x
	sta VSYNC_COUNTER_ADDR_2+0
	rts
.)


_VSyncGetCounter
	.(
	lda #0
	sta _VSyncCounter1
	sta _VSyncCounter1+1

	lda $300
vsynccounter_wait1
	lda $30D
	and #%00010000 ;test du bit cb1 du registre d'indicateur d'IRQ
	bne vsynccounter_wait1_end

	inc _VSyncCounter1
	bne vsynccounter_wait1
	inc _VSyncCounter1+1
	bne  vsynccounter_wait1

vsynccounter_wait1_end
	rts
	.)


_VSyncGetCounterStats
.(
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
.)
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



_Break
	jmp _Break
	
_KeyboardFlush
.(
loop
	jsr _KeyboardRead
	lda _gKey
	bne loop
	rts
.)	

_KeyboardWait
.(
	jsr _KeyboardFlush
loop	
	jsr _KeyboardRead
	lda _gKey
	beq loop
	rts
.)
	
_KeyboardRead
	lda #00
	sta _gKey

read_left
	ldx #$df
	jsr KeyboardSetUp
	beq read_right
	lda _gKey	
	ora #1
	sta _gKey
	
read_right
	ldx #$7f
	jsr KeyboardSetUp
	beq read_up
	lda _gKey	
	ora #2
	sta _gKey
	
read_up
	ldx #$f7
	jsr KeyboardSetUp
	beq read_down
	lda _gKey	
	ora #4
	sta _gKey
	
read_down
	ldx #$bf
	jsr KeyboardSetUp
	beq read_fire
	lda _gKey	
	ora #8
	sta _gKey
	
read_fire
	ldx #$fe
	jsr KeyboardSetUp
	beq read_end
	lda _gKey	
	ora #16
	sta _gKey
	
read_end
	rts


KeyboardSetUp
	;x=column a=row
	lda #04
	sta $300
	lda #$0e
	sta $30f
	lda #$ff
	sta $30c
	ldy #$dd
	sty $30c
	stx $30f
	lda #$fd
	sta $30c
	sty $30c
	lda $300
	and #08
	rts
