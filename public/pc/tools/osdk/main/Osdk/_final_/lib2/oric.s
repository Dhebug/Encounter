_peek
    ldy #$0         ; grab one 16-bit parameter
    lda (sp),y      ; LSB
    sta tmp
    iny
    lda (sp),y      ; MSB
    sta tmp+1
    ldy #$0
    lda (tmp),y     ; Peek at the memory
    jmp grexit2     ; Return the byte found there


_deek
    ldy #$0         ; grab one 16-bit parameter
    lda (sp),y      ; LSB
    sta tmp
    iny
    lda (sp),y      ; MSB
    sta tmp+1
    ldy #$0
    lda (tmp),y     ; Get the low order byte
	tax
    iny             ; Next byte
    lda (tmp),y     ; Get high order byte
    rts


_poke
    ldy #$0         ; Grab one 16-bit parameter
    lda (sp),y      ; LSB
	sta tmp
	iny
    lda (sp),y      ; MSB
	sta tmp+1
    iny
    lda (sp),y      ; Grab an 8-bit parameter
    ldy #$0
    sta (tmp),y    ; Poke the latter to the former
    rts

_doke
    ldy #$0         ; Grab one 16-bit parameter
    lda (sp),y      ; LSB
	sta tmp
	iny
    lda (sp),y      ; MSB
	sta tmp+1
	iny             ; Grab another 16-bit parameter
    lda (sp),y      ; Grab the LSB first
    ldy #$0
    sta (tmp),y    ; Poke the LSB
    ldy #$3         ; Now grab the MSB
    lda (sp),y
    ldy #$1
    sta (tmp),y    ; And poke it as well
    rts
	
_call			; Call a machine code routine
    ldy #$0
    lda (sp),y
    sta tmp
    iny
    lda (sp),y
    sta tmp+1
    jmp (tmp)

_bang		; invoke the Basic '!' handler
    ldy #$0         ; grab string pointer
    lda (sp),y
    sta $e9
    iny
    lda (sp),y
    sta $ea

    jsr $00e8       ; read first char
    jmp ($02f5)     ; call the ! command handler

