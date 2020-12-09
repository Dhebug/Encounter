;
; stprintf(str,...)
;
; Warning, This is a kludge to use printf to
; format-print in the status line

statusline_flag .byte 0

ST_LINE = 48000
_stprintf

        lda #$ff
        sta statusline_flag
	; Initialize a counter
	lda #0
	sta tx_count2
				
	; Call to _printf
    jsr _printf
	
        lda #0
        sta statusline_flag
	; We're done!
	rts

tx_stbuff	
	; Get character to print &
	; store it in status line+counter
	pha
	tya
	pha
	lda #<(ST_LINE)
	sta tmp1
	lda #>(ST_LINE)
	sta tmp1+1
	ldy tx_count2
	txa
        cpy #40
        beq *+5
	sta (tmp1),y
        iny
        sty tx_count2
	pla
	tay
	pla
  	rts

; Buffers
tx_addr2
    .byte 0,0
tx_count2
    .byte 0

