
    .text

IrqTasks
.(
	; Process keyboard
	jsr ReadKeyboard
			
    ; "Realtime" Clock
    .(
    dec Milliseconds
    bne skip_count_down

    lda #50
    sta Milliseconds

    jsr CountSecondDown
skip_count_down  
    .)

    rts    
.)

