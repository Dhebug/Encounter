
    .zero

    .text


IrqTasksHighSpeed
.(
    rts
.)

IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard
    rts    
.)

