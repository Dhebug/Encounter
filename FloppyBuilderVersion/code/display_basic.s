
#include "params.h"

    .text

_gIsHires       .byt 1
_gPrintAddress  .word $bb80;


_Add40ToTmp0
  clc
  lda tmp0+0
  adc #40
  sta tmp0+0
  lda tmp0+1
  adc #0
  sta tmp0+1
  rts


; param0.uchar=paperColor
; param0.uchars[1]=inkColor
_TextAsm
.(
  lda _gIsHires
  beq was_text

was_hires
  ; memsetAsm($a000,_param0+0,$bfe0-$a000)
  lda #<$a000:ldy #0:sta (sp),y:iny:lda #>$a000:sta (sp),y
  lda _param0+0:iny:sta (sp),y:iny:lda #0:sta (sp),y
  lda #<$bfe0-$a000:iny:sta (sp),y:iny:lda #>$bfe0-$a000:sta (sp),y
  jsr _memset  

  lda #26
  sta $bfdf

  jsr _WaitIRQ
  jsr _WaitIRQ

  ; memcpyAsm($b500,$9900,8*96)
  lda #<$b500:ldy #0:sta (sp),y:iny:lda #>$b500:sta (sp),y
  lda #<$9900:iny:sta (sp),y:iny:lda #>$9900:sta (sp),y
  lda #<8*96 :iny:sta (sp),y:iny:lda #>8*96:sta (sp),y
  jsr _memcpy  

  lda #0
  sta _gIsHires
  jmp common2

was_text  
  ; memsetAsm($bb80,_param0+0,$bfe0-$bb80);
  lda #<$bb80:ldy #0:sta (sp),y:iny:lda #>$bb80:sta (sp),y
  lda _param0+0:iny:sta (sp),y:iny:lda #0:sta (sp),y
  lda #<$bfe0-$bb80:iny:sta (sp),y:iny:lda #>$bfe0-$bb80:sta (sp),y
  jsr _memset

  jmp common2

common2

  lda #<$bb80
  sta tmp0+0
  lda #>$bb80
  sta tmp0+1

  ldx #0
loop_y

  lda #32
  ldy #39
loop_x
  sta (tmp0),y
  dey
  cpy #1
  bne loop_x

  lda _param0+1
  sta (tmp0),y

  jsr _Add40ToTmp0

  inx
  cpx #28  
  bne loop_y

  rts
.)



; param0.uchar=paperColor
; param0.uchars[1]=inkColor
_HiresAsm
.(
  lda _gIsHires
  bne was_hires_already

  ; memcpy((char*)0x9900,(char*)0xb500,8*96);
  lda #<$9900:ldy #0:sta (sp),y:iny:lda #>$9900:sta (sp),y
  lda #<$b500:iny:sta (sp),y:iny:lda #>$b500:sta (sp),y
  lda #<8*96 :iny:sta (sp),y:iny:lda #>8*96:sta (sp),y
  jsr _memcpy  

  lda #1
  sta _gIsHires

was_hires_already

  ; memset((char*)0xa000,paperColor,0xbfe0-0xa000);   // Blinks for some reason, bug in memset???
  lda #<$a000:ldy #0:sta (sp),y:iny:lda #>$a000:sta (sp),y
  lda _param0+0:iny:sta (sp),y:iny:lda #0:sta (sp),y
  lda #<$bfe0-$a000:iny:sta (sp),y:iny:lda #>$bfe0-$a000:sta (sp),y
  jsr _memset

  lda #31
  sta $bfdf

  jsr _WaitIRQ
  jsr _WaitIRQ

  ; Set paper and ink colors on the 200 lines ot HIRES mode
  lda #<$a000
  sta tmp0+0
  lda #>$a000
  sta tmp0+1

  ldx #200
  jsr _FillPaperInk

  ; Set paper and ink colors on the last three lines of TEXT mode
  lda #<$bb80+40*25
  sta tmp0+0
  lda #>$bb80+40*25
  sta tmp0+1

  ldx #3
  jsr _FillPaperInk
  rts    
.)

_FillPaperInk
.(
loop_y
  ldy #0
  lda _param0+0
  sta (tmp0),y     ; paper color
  iny
  lda _param0+0
  sta (tmp0),y     ; ink color

  jsr _Add40ToTmp0

  dex
  bne loop_y
  rts
.)


