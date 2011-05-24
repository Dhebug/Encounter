;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Text strings
;; --------------------


; Searches for a string. tmp0 holds pointer to base and A holds offset (in strings).
search_string
.(
	stx savex+1	; Preserve reg x
    tax
    bne cont
	ldx savex+1
    rts
cont
    ldy #0
loop
    lda (tmp0),y
    beq out    ; Search for zero
    iny
    bne loop

out
    ; Found the end. 
	; Skip consecutive zeros
loop2
	iny
	lda (tmp0),y
	beq loop2
	
	;Add length to pointer    
    tya
    clc
    adc tmp0
    bcc nocarry
    inc tmp0+1
nocarry
    sta tmp0    

    dex
    bne cont
  
savex
	ldx #0	; restore reg x
    rts

.)



names_extras
	.asc "        "
empty_st
	.byt 0
	.asc "ERIC"
	.byt 0
	.dsb 9,0
	.asc "BOY WANDER"
	.byt 0
	.dsb 9,0
	.asc "ANGELFACE"
	.byt 0
	.dsb 9,0
	.asc "EINSTEIN"
	.byt 0
	.dsb 9,0
	.asc "MR ROCKITT"
	.byt 0
	.dsb 9,0
	.asc "MR WACKER"
	.byt 0
	.dsb 9,0
	.asc "MR WITHIT"
	.byt 0
	.dsb 9,0
	.asc "MR CREAK"
	.byt 0
	.dsb 9,0
	.asc "Please Sir - I cannot tell a lie . ."
	.byt SPACES_8
	.byt 0
	.asc "REVISION"
	.byt 0

class_names
	.asc "READING ROOM"
	.byt 0
	.asc "MAP ROOM"
	.byt 0
	.asc "WHITE ROOM"
	.byt 0
	.asc "EXAM ROOM"
	.byt 0
	.asc "LIBRARY"
	.byt 0
	.asc "DINNER"
	.byt 0
	.asc "PLAYTIME"
	.byt 0

demo_msg
	.asc "DEMO. - PRESS"
	.byt 0
	.asc "A KEY TO PLAY"
	.byt 0

sit_messages
	.asc "RIGHT! SIT DOWN MY LITTLE CHERUBS"
	.byt SPACES_8
	.byt 0
	.asc "COME ON CHAPS - SETTLE DOWN"
	.byt SPACES_8
	.byt 0
	.asc "BE QUIET AND SEATED YOU NASTY LITTLE BOYS"
	.byt SPACES_8
	.byt 0
	.asc "SILENCE! OR I'LL CANE THE LOT OF YOU"
	.byt SPACES_8
	.byt 0

class_messages
st_write_essay
	.byt "WRITE AN ESSAY WITH THIS TITLE"
	.byt SPACES_8
	.byt 0
st_page_book
	.byt "TURN TO PAGE "
st_page_template
	.byt "123 OF YOUR BOOKS, BE SILENT AND START READING"
	.byt SPACES_8
	.byt 0
st_question_book
	.byt "ANSWER THE QUESTIONS ON PAGE "
st_question_template
	.byt "123 OF YOUR LOVELY TEXTBOOK"
	.byt SPACES_8
	.byt 0


