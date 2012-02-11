


_playertext	.dsb 2
_turntext	.byt " TURN: USE CURSOR KEYS.",10,"X=SELECT",10,"P=POSSIBLE MOVES",0

;
; Simply erases the three lines of TEXT at the bottom of the HIRES screen
; It's possible to change the INK color in the code iself.
;
_erasetextarea
.(
	lda #5		; Purple color
	ldx #40*3
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
_printmessage
.(
	; Erase the 3 lines of text
	jsr _erasetextarea
		
	ldy #2
	jmp _printline
.)


; char turntext[]=" TURN: USE CURSOR KEYS.\nX=SELECT PIECE P=POSSIBLE MOVES";
; printf("%c\n\n\n%s%s%c",19,playertext,turntext,19);

_printturnprompt
.(
	; Erase the 3 lines of text
	jsr _erasetextarea
	
	; First line of text
	lda _playertext+0
	sta _message+0
	lda _playertext+1
	sta _message+1

	ldy #2
	jsr _printline
	
	; Second line of text
	lda #<_turntext
	sta _message+0
	lda #>_turntext
	sta _message+1	
	jmp _printline
.)


