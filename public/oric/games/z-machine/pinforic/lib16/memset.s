; void *memset (void *buffer, int c, int count)
;
; shamelessly adopted from Fabrice Frances' memcpy. :-)
; (clueless comments added by me)
; [me=alexios@vennea.demon.co.uk] :-)

_memset
        ldy #0          ; get buffer pointer
        lda (sp),y
        sta op1
        sta memsetret+1 ; keep return value for later
        iny
        lda (sp),y
        sta op2
        sta memsetret+3 ; keep return value for later

        iny             ; get character to fill buffer with
        lda (sp),y
        pha             ; stack it -- we'll be needing it later

        ldy #4          ; get the count of bytes to set
	sec
	lda #0
	sbc (sp),y
	sta tmp
	tax
	iny
	cmp #1
	lda (sp),y
	adc #0
	tay
        beq memsetret   ; I don't have a clue what just happened here! :-)

        sec             ; adjust the self-modifying part of the routine.
	lda op1
	sbc tmp
        sta memcpyloop+1
	lda op1+1
	sbc #0
        sta memcpyloop+2

        pla             ; recover the byte value from the stack

memsetloop              ; main loop
        sta $2211,x     ; set a byte
        inx
        bne memsetloop
        inc memsetloop+2
	dey
        bne memsetloop

memsetret
        ldx #1          ; return buffer
        lda #3
	rts

