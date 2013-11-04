;
; Simply erases the three lines of TEXT at the bottom of the HIRES screen
; It's possible to change the INK color in the code iself.
;
_erasetextarea
.(
	lda #5		; Purple color
	;ldx #40*3
	ldx _erasetext
loop_erase	
	sta $bb80+25*40-1,x
	dex
	bne loop_erase
	
	rts
.)


;
; _message=source message
; y=screen offset (2, 42, 82)
_printline
.(	
	ldx #255
loop_draw
    inx
    
    .byt $BD		; lda $1234,x
+_message
	.word $1234	
	
	beq end			; 0
	cmp #10			; \n
	beq next_line
	sta $bb80+25*40,y
	iny
	bne loop_draw	
	
next_line   
	cpy #39
	bcs last_line
	ldy #42
	bne loop_draw	
last_line	
	ldy #82
	bne loop_draw	

end		
	rts
.)


;
; Usage: Set the adress of the string to print in the _message variable 
; Note: The string should be terminated by a 0
; 
_PrintMessage
.(
	; Erase the 3 lines of text
	jsr _erasetextarea
		
	ldy #2
	jmp _printline
.)
