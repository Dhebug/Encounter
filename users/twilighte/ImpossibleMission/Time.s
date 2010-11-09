;Time.s

;Time warnings consist of following intervals
;Every ten minutes time will blink red
;Last ten minutes time will remain red
;last minute will beep if audio on
BlinkRed	lda #128+63
	sta OddTimerRow
	sta Update_Hours
	sta Update_Minutes
	lda #00
	sta EvenTimerRow
	rts

OutOfTime	inc TimeExpired
	;Show 0;00;00
	lda #0
	sta Time_Hours
	sta Time_Minutes
	sta Time_Seconds
UpdateHoursMinutesAndSeconds
	jsr DisplaySeconds
	jsr DisplayMinutes
	jmp DisplayHours

UpdateTime
	;Reset time to blue background if it blinked red last frame
	lda EvenTimerRow
.(
	bne skip1
	lda #00
	sta OddTimerRow
	lda #128+63
	sta EvenTimerRow
	jsr UpdateHoursMinutesAndSeconds
	
skip1	;Now reset update flags
.)
	lda #00
	sta Update_Hours
	sta Update_Minutes
	
	dec Time_Seconds
	bpl CheckWarnings
	lda #59
	sta Time_Seconds
	
DecrementMinutes
	inc Update_Minutes
	dec Time_Minutes
	bpl CheckWarnings
	lda #59
	sta Time_Minutes
	
	inc Update_Hours
	dec Time_Hours
	bmi OutOfTime

;Now we've updated the time (but not plotted changes) we can check for warnings

CheckWarnings
	;Check - last minute will beep if audio on
.(
	lda Time_Hours
	ora Time_Minutes
	bne skip2
	
	lda #SFX_HIGHBEEP
	jsr KickSFX
	
skip2	;Check - Last ten minutes time will remain red
	ldx Time_Minutes
	lda Time_Hours
	bne skip3
	cpx #11
	bcs skip3
	
skip5	jsr BlinkRed
	jmp skip4
	
skip3	;Check - Every ten minutes(X;TT;00) time will blink red
	lda Time_Seconds
	bne skip4
	txa
	ldx #5
loop1	cmp TenMinuteIntervals,x
	beq skip5
	dex
	bpl loop1
	
skip4	;Now check for the digit updates that are required
	jsr DisplaySeconds
	
	lda Update_Minutes
	beq skip6
	jsr DisplayMinutes
	
skip6	lda Update_Hours
	beq skip7
	jsr DisplayHours
skip7	rts
.)	
	
TenMinuteIntervals
 .byt 0,10,20,30,40,50	
















	
	
	


;	;Reset blue background
;	ldx EvenTimerRow
;.(
;	bne skip1
;	lda #00
;	sta OddTimerRow
;	lda #128+63
;	sta EvenTimerRow
;	jsr UpdateHoursMinutesAndSeconds
;;ProcessTimeWarnings
;	;Check - last minute will beep if audio on
;	lda Time_Hours
;.(
;	bne skip3
;	lda Time_Minutes
;	bne skip3
;	lda #
;	jsr KickSFX
;skip3	;Check - Last ten minutes time will remain red
;	lda Time_Hours
;	bne skip2
;	lda Time_Minutes
;	cmp #11
;	bcc BlinkRed
;skip2	;Check - Every ten minutes time will blink red
;	lda Time_Seconds
;	bne TimeContinue
;	ldx #6
;	lda Time_Minutes
;loop1	cmp TenMinuteIntervals,x
;	beq BlinkRed
;	dex
;	bpl loop1
;.)
;TimeContinue
;skip1	;Counting down from 8;00;00
;.)
;	dec Time_Seconds
;	bpl TimeSkip1
;	lda #59
;	sta Time_Seconds
;	;Count 10 minutes
;	dec TenMinuteCounter
;	bne DecrementMinutes
;	lda #10
;	sta TenMinuteCounter
;	;Then flag display routine to momentarily display red background
;	lda #128+63
;	sta OddTimerRow
;	lda #00
;	sta EvenTimerRow
;	jsr DisplayHours
;DecrementMinutes
;	dec Time_Minutes
;	bpl TimeSkip1
;	lda #59
;	sta Time_Minutes
;	dec Time_Hours
;	bmi OutOfTime
;TimeSkip1	;always update seconds
;	jsr DisplaySeconds
;	;Don't update minutes or hours unless they've changed
;	lda Time_Minutes
;	cmp Time_OldMinutes
;	beq TimeSkip2
;	sta Time_OldMinutes
;	jsr DisplayMinutes
;TimeSkip2	lda Time_Hours
;	cmp Time_OldHours
;	beq TimeSkip3
;	sta Time_OldHours
;	jsr DisplayHours
;TimeSkip3	rts
;
;	
;OutOfTime
;	;Flag system that Time has expired
;	inc TimeExpired
;	;Show 0;00;00
;	lda #0
;	sta Time_Hours
;	sta Time_Minutes
;	sta Time_Seconds
;UpdateHoursMinutesAndSeconds
;	jsr DisplaySeconds
;	jsr DisplayMinutes
;	jmp DisplayHours
	
DisplaySeconds
	;Split Seconds into tens and units
	lda Time_Seconds
	jsr SplitIntoTensAndUnits
	stx TensDigit
	
	;Display Units
	ldx #6
	jsr DisplayDigit
	
	;Display Tens
	lda TensDigit
	ldx #5
	jmp DisplayDigit

DisplayMinutes
	;Split Minutes into tens and units
	lda Time_Minutes
	jsr SplitIntoTensAndUnits
	stx TensDigit
	
	;Display Units
	ldx #3
	jsr DisplayDigit
	
	;Display Tens
	lda TensDigit
	ldx #2
	jmp DisplayDigit

DisplayHours
	lda Time_Hours
	
	;Display Units
	ldx #0
	jmp DisplayDigit

DisplayDigit
	;Digit in Y so x6
	asl
.(
	sta vector1+1
	asl
vector1	adc #00
.)
	tay
	
	;Screen X offset in X
	lda Character48,y
	eor OddTimerRow
	sta $A000+23+40*190,x
	
	lda Character48+1,y
	eor EvenTimerRow
	sta $A000+23+40*191,x
	
	lda Character48+2,y
	eor OddTimerRow
	sta $A000+23+40*192,x
	
	lda Character48+3,y
	eor EvenTimerRow
	sta $A000+23+40*193,x
	
	lda Character48+4,y
	eor OddTimerRow
	sta $A000+23+40*194,x
	
	lda Character48+5,y
	eor EvenTimerRow
	sta $A000+23+40*195,x
	rts

SplitIntoTensAndUnits
	ldx #255
	sec
.(
loop1	inx
	sbc #10
	bcs loop1
.)
	adc #10
	;A holds units whilst X holds Tens
	rts
	

	
