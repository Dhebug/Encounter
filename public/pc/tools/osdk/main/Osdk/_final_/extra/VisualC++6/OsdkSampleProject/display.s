

; This function does nothing except write 'OK'
; in the status line
_DisplayTest
	lda #"O"
	sta $BB80
	lda #"K"
	sta $BB81
	rts


