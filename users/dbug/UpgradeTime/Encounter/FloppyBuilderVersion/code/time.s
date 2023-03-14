

    .text

CountSecondDown
    ;jmp CountSecondDown
.(
  ; Make the ":" symbol between the hour and minute blink every second
  ; ":" = 58 = 111010
  ; " " = 32 = 100000
  lda TimeMinutesDots
  eor #%11010
  sta TimeMinutesDots
  cmp #":"
  bne end_count_down

  ; Do a small tick
  ;jsr PlaySoundSeconds

  ; Count down the seconds
  ldx TimeSeconds+1
  dex
  stx TimeSeconds+1
  cpx #"0"-1
  bne end_count_down
  ldx #"9"
  stx TimeSeconds+1

  ldx TimeSeconds+0
  dex
  stx TimeSeconds+0
  cpx #"0"-1
  bne end_count_down
  ldx #"5"
  stx TimeSeconds+0

  ; Count down the minutes
  ldx TimeMinutes+1
  dex
  stx TimeMinutes+1
  cpx #"0"-1
  bne end_count_down
  ldx #"9"
  stx TimeMinutes+1

  ldx TimeMinutes+0
  dex
  stx TimeMinutes+0
  cpx #"0"-1
  bne end_count_down
  ldx #"5"
  stx TimeMinutes+0
  
  ; Count down the hour
  ldx TimeHours
  dex
  stx TimeHours
  cpx #"0"-1
  bne end_count_down
  ; GAME OVER!
  ldx #"9"
  stx TimeHours
  
end_count_down

+_DisplayClock
  ; Display
  ldx #6+1
loop
  lda TimeHours-1,x
  ;sta $bfdf-6,x
  ;sta $bb80+16*40+39-6,x
  sta $bb80+16*40+39-6-1,x
  dex
  bpl loop  

  rts
.)




Milliseconds    .byt 100
    .byt 1        ; RED - TEMPS COLOR
TimeHours
    .byt "2"
TimeMinutesDots    
    .byt ":"      ; : = 58   space = 32
TimeMinutes    
    .byt "0"
    .byt "0"
    .byt ":"
TimeSeconds    
    .byt "0"
    .byt "0"
