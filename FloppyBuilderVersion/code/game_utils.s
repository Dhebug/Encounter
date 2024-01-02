
    .zero

_gCurrentLocation       .dsb 1
_gCurrentLocationPtr    .dsb 2

    .text


IrqTasksHighSpeed
.(
    jmp SoundUpdateHighSpeed
.)

IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard
    jsr SoundUpdate50hz
            
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

    .text   // could be .data if we setup the base address properly


_Text_DirectionNorth  .byt "North",0
_Text_DirectionSouth  .byt "South",0
_Text_DirectionEast   .byt "East",0
_Text_DirectionWest   .byt "West",0
_Text_DirectionUp     .byt "Up",0
_Text_DirectionDown   .byt "Down",0

_gDirectionsArray
  .word _Text_DirectionNorth
  .word _Text_DirectionSouth
  .word _Text_DirectionEast  
  .word _Text_DirectionWest   
  .word _Text_DirectionUp  
  .word _Text_DirectionDown  
