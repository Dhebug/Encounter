#include "params.h"

    .text

CountSecondDown
    ;jmp CountSecondDown
.(
+Count1SecondsDown
_auto_nop_rts
  nop                     ; This get patched by a RTS when the countdown reached zero

  ; Make the ":" symbol between the hour and minute blink every second
  ; ":" = 58 = 111010
  ; " " = 32 = 100000
  lda _TimeMinutesDots
  eor #%11010
  sta _TimeMinutesDots
  cmp #":"
  bne end_count_down

  ; Do a small tick
  ;jsr PlaySoundSeconds

  ; Count down the seconds
  ldx _TimeSeconds+1
  dex
  stx _TimeSeconds+1
  cpx #"0"-1
  bne end_count_down
  ldx #"9"
  stx _TimeSeconds+1

+Count10SecondsDown
  ldx _TimeSeconds+0
  dex
  stx _TimeSeconds+0
  cpx #"0"-1
  bne end_count_down
  ldx #"5"
  stx _TimeSeconds+0

+CountMinuteDown
  ; Count down the minutes
  ldx _TimeMinutes+1
  dex
  stx _TimeMinutes+1
  cpx #"0"-1
  bne end_count_down
  ldx #"9"
  stx _TimeMinutes+1

  ldx _TimeMinutes+0
  dex
  stx _TimeMinutes+0
  cpx #"0"-1
  bne end_count_down
  ldx #"5"
  stx _TimeMinutes+0
  
  ; Count down the hour
  ldx _TimeHours
  dex
  stx _TimeHours
  cpx #"0"-1
  bne end_count_down

  ; Count-Down reached zero:
  ; We stop the counter
  lda #OPCODE_RTS
  sta _auto_nop_rts

  ; We inform the game there is a GAME OVER condition
  ldx #"9"
  stx _TimeHours
  rts
  
end_count_down

+_DisplayClock
  ; Display
  ldx #6+1
loop
  lda _TimeHours-1,x
  ;sta $bfdf-6,x
  sta $bb80+16*40+39-6-1-2,x
  ;sta $bb80+27*40+39-6-1,x
  dex
  bpl loop  

  rts
.)




_TimeMilliseconds    
    .byt 100
    .byt 1        ; RED - TEMPS COLOR
_TimeHours
    .byt "2"
_TimeMinutesDots    
    .byt ":"      ; : = 58   space = 32
_TimeMinutes    
    .byt "0"
    .byt "0"
    .byt ":"
_TimeSeconds    
    .byt "0"
    .byt "0"
