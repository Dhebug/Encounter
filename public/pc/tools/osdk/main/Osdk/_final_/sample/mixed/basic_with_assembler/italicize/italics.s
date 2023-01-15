	.text    

 *=$8000

; Called when the assembler is loaded.
; Can be used to perfom initializations
_EntryPoint 
 rts

; To "italicize" the text, all we need to do is to shift right the first
; four scanlines of each of the characters, then jump over the next four ones
; until we reach $B800 which is the first 
_MakeItalics 
  lda #<$B400+8*32
  sta shift+1
  lda #>$B400+8*32
  sta shift+2
loop

  ldx #4
shift
  lsr $B400
  inc shift+1
  dex
  bne shift

  clc
  lda shift+1
  adc #4
  sta shift+1
  bne loop

  ldx shift+2
  inx
  stx shift+2
  cpx #$B8
  bne loop
  rts
