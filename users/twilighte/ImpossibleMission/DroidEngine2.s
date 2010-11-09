;Droids
;Rather than hold movement in script why not have a bit for each type of movement then on game start
;set the behaviours by fetching a random 8 bit number.
;
;0 Pause at 10 Paces
;1 Pause at 5 Paces
;2 Look back (Only with B0-1 set)
;3 Speed (0==Fast 1==Slow)
;4 Spark
;5 Repeat at bounds
;6 Sound sensor (Senses Ethan wherever he is in the room)
;7 Light Sensor (Only sense Ethan when facing him on same level) - Triggers second behaviour parameter
;
;Provide two variables.. one for normal behaviour and the other for when Ethan is detected.

DroidEngine
	ldx UltimateDroid
	bmi skip1
loop1	lda DroidsSnoozing
	bne skip4
	lda DroidDelay,x
	beq skip2
	dec DroidDelay,x
	jsr PlotDroid
	jmp skip3
skip2	;Is this droid using normal or Found behaviour?
	lda DroidBehaviourSet,x	;0==Normal 1==Found
	bne skip5
	;
	lda DroidAttribute,x
	bpl skip5
	jsr Check
skip5	ldy DroidAction,x
	lda DroidActionAddressLo,y
	sta vector1+1
	lda DroidActionAddressHi,y
	sta vector1+2
vector1	jsr $dead
skip4	jsr PlotDroid
skip3	dex
	bpl loop1
skip1	rts

da_Move	lda DroidX,x
	
	;Check if bounds reached
	cmp DroidCurrentBound,x
	beq BoundReached
	
	clc
	adc DroidStep,x	;255 or 1
	sta DroidX,x
	
	;Check if paces reached
	lda DroidPacing,x	;Flag to indicate if droid paces or not
.(
	beq skip1
	dec DroidPaces,x	;Number of paces (B0-1)
	bne skip1
	
	;Droids paces have just run out - restore pace and observe bits 2 and 4
	lda DroidAttribute,x
	and #3
	sta DroidPaces,x
	lda DroidAttribute,x
	and #BIT2
	bne Switch2Lookback
	lda DroidAttribute,x
	and #BIT4
	bne Switch2Spark
skip1	rts
.)

BoundReached
	
	
;0 Pause at 10 Paces
;1 Pause at 5 Paces
;2 Look back (Only with B0-1 set)
;3 Speed (0==Fast 1==Slow)
;4 Spark
;5 Repeat at bounds
;6 Sound sensor (Senses Ethan wherever he is in the room) - Triggers second behaviour parameter
;7 Light Sensor (Only sense Ethan when facing him on same level) - Triggers second behaviour parameter
	
	
	
	;Sort Speed
	lda DroidAttribute,x
	and #BIT3
	lsr
	lsr
	lsr
	sta DroidDelay,x
	;Sort
	lda DroidAttribute,x
	
	
	
	

