	
  .text    

 *=$8000

; Called when the assembler is loaded.
; Can be used to perfom initializations
_EntryPoint 
 rts

; To "italicize" the text, all we need to do is to shift right the first
; four scanlines of each of the characters, then jump over the next four ones
; until we reach $B800 which is the first 
_ScrollUp
  ldx #39
loop
  lda $BB80+40*27,x
  pha
  lda $BB80+40*0,x
  sta $BB80+40*27,x
  lda $BB80+40*1,x
  sta $BB80+40*0,x
  lda $BB80+40*2,x
  sta $BB80+40*1,x
  lda $BB80+40*3,x
  sta $BB80+40*2,x
  lda $BB80+40*4,x
  sta $BB80+40*3,x
  lda $BB80+40*5,x
  sta $BB80+40*4,x
  lda $BB80+40*6,x
  sta $BB80+40*5,x
  lda $BB80+40*7,x
  sta $BB80+40*6,x
  lda $BB80+40*8,x
  sta $BB80+40*7,x
  lda $BB80+40*9,x
  sta $BB80+40*8,x
  lda $BB80+40*10,x
  sta $BB80+40*9,x
  lda $BB80+40*11,x
  sta $BB80+40*10,x
  lda $BB80+40*12,x
  sta $BB80+40*11,x
  lda $BB80+40*13,x
  sta $BB80+40*12,x
  lda $BB80+40*14,x
  sta $BB80+40*13,x
  lda $BB80+40*15,x
  sta $BB80+40*14,x
  lda $BB80+40*16,x
  sta $BB80+40*15,x
  lda $BB80+40*17,x
  sta $BB80+40*16,x
  lda $BB80+40*18,x
  sta $BB80+40*17,x
  lda $BB80+40*19,x
  sta $BB80+40*18,x
  lda $BB80+40*20,x
  sta $BB80+40*19,x
  lda $BB80+40*21,x
  sta $BB80+40*20,x
  lda $BB80+40*22,x
  sta $BB80+40*21,x
  lda $BB80+40*23,x
  sta $BB80+40*22,x
  lda $BB80+40*24,x
  sta $BB80+40*23,x
  lda $BB80+40*25,x
  sta $BB80+40*24,x
  lda $BB80+40*26,x
  sta $BB80+40*25,x
  lda $BB80+40*27,x
  sta $BB80+40*26,x
  pla
  sta $BB80+40*27,x
  dex
  bmi end
  jmp loop
end
  rts
