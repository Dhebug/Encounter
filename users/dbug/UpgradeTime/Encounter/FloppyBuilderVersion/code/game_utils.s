
    .text

IrqTasks
.(
    ; Process keyboard
    jsr ReadKeyboard
    jsr SoundUpdate
            
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

