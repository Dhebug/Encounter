;
; scanf(const char *format,...)
;

; it seems difficult to avoid adding a buffer to the unbuffered Oric input,
; this consumes a lot of space, but how to do it differently ?

scanbuf	.dsb 256

_scanf 
	lda #<scanbuf
	sta tmp
	lda #>scanbuf
	sta tmp+1
	jsr gets
    lda #<scanbuf
    sta loadchar+1
    lda #>scanbuf
    sta loadchar+2
	ldy #0
	jmp scanf
