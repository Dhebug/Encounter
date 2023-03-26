
  .zero

width   .dsb 1
height  .dsb 1    

    .text

_gFlagDirections  .byt 0    ; Bit flag containing all the possible directions for the current scene (used to draw the arrows on the scene)

; A000-B3FF 5120 bytes of half HIRES (240x128 resolution)
; Exactly 20*256
_ClearHiresWindow  
.(
  lda #64 ;+1+4
  ldx #0
loop
  sta $a000+256*0,x
  sta $a000+256*1,x
  sta $a000+256*2,x
  sta $a000+256*3,x
  sta $a000+256*4,x
  sta $a000+256*5,x
  sta $a000+256*6,x
  sta $a000+256*7,x
  sta $a000+256*8,x
  sta $a000+256*9,x
  sta $a000+256*10,x
  sta $a000+256*11,x
  sta $a000+256*12,x
  sta $a000+256*13,x
  sta $a000+256*14,x
  sta $a000+256*15,x
  sta $a000+256*16,x
  sta $a000+256*17,x
  sta $a000+256*18,x
  sta $a000+256*19,x
  dex
  bne loop
  rts
.)

; Full Oric display is 240x224
; The top graphic window is 240x128
; Which leaves us with a 240x96 text area at the bottom (12 lines )
; 40*12 = 480
_ClearTextWindow  
.(
  lda #" "   ;lda #"x" ;+1+4
  ldx #0
loop
  sta $bb80+40*16+256*0,x
  sta $bfdf-256,x
  dex
  bne loop
  rts
.)


_AddFancyImageFrame
.(
  ; Put the white and black line at the very top
  ldx #40
loop_top
  lda #%01111111
  sta _ImageBuffer+40*0-1,x

  lda #%01000000
  sta _ImageBuffer+40*1-1,x

  dex
  bne loop_top

  lda #<_ImageBuffer+40*2
  sta tmp0+0
  lda #>_ImageBuffer+40*2
  sta tmp0+1

  ; Intermediate junction elements at the top left and right
  lda #%01100000
  sta _ImageBuffer+40*1+0
  lda #%01000001
  sta _ImageBuffer+40*1+39

  ; Put the white and black line on each side of the image
  ldx #128-2-3
loop_sides
  ldy #0
  lda (tmp0),y
  and #%11101111
  ora #%01100000
  sta (tmp0),y

  ldy #39
  lda (tmp0),y
  and #%11111101
  ora #%01000001
  sta (tmp0),y

  clc 
  lda tmp0+0
  adc #40
  sta tmp0+0
  lda tmp0+1
  adc #0
  sta tmp0+1

  dex
  bne loop_sides

  ; The three lines at the bottom
  ldx #19
loop_bottom
  lda #%01111111
  sta _ImageBuffer+40*126-1,x
  sta _ImageBuffer+40*126-1+40-19,x

  lda #%01000000
  sta _ImageBuffer+40*125-1,x
  sta _ImageBuffer+40*127-1,x

  sta _ImageBuffer+40*125-1+40-19,x
  sta _ImageBuffer+40*127-1+40-19,x

  dex
  bne loop_bottom

  ; Intermediate junction elements at the bottom left and right
  lda #%01110000
  sta _ImageBuffer+40*125+0
  lda #%01000011
  sta _ImageBuffer+40*125+39

  lda #%01011111
  sta _ImageBuffer+40*126+0
  lda #%01111110
  sta _ImageBuffer+40*126+39

  rts
.)

_DrawArrows
.(
  ; ArrowBlockMasks -> 102,111 -> 17,111
  ; The block itself is 32x18 pixels (6 bytes wide)
  ; The top 18 pixels is the AND mask, the bottom 18 pixels are the OR mask
  lda #<ArrowBlockMasks
  sta tmp0+0
  lda #>ArrowBlockMasks
  sta tmp0+1

  lda #18+8
  sta height

  lda #6
  sta width
  
  lda #<_ImageBuffer+17+40*110
  sta tmp1+0
  lda #>_ImageBuffer+17+40*110
  sta tmp1+1
  
  lda #$31            ; and (tmp0),y
  sta BlitOperation
  jsr BlitBloc

  lda #18+8
  sta height

  lda #6
  sta width

  lda #<_ImageBuffer+17+40*110
  sta tmp1+0
  lda #>_ImageBuffer+17+40*110
  sta tmp1+1

  lda #$11            ; ora (tmp0),y
  sta BlitOperation
  jsr BlitBloc
  
  ; Then add the individual arrows over
  lda _gFlagDirections
  and #1
  beq no_north
  jsr PatchArrowTop  
no_north  

  lda _gFlagDirections
  and #2
  beq no_south
  jsr PatchArrowBottom
no_south  

  lda _gFlagDirections
  and #4
  beq no_east
  jsr PatchArrowRight  
no_east  

  lda _gFlagDirections
  and #8
  beq no_west
  jsr PatchArrowLeft  
no_west  
 
  jsr PatchArrowCharacters

  ; Reset the direction
  lda #0
  sta _gFlagDirections
  rts
.)

; A000-B3FF 5120 bytes of half HIRES (240x128 resolution)
; Exactly 20*256
_BlitBufferToHiresWindow
.(
  jsr _AddFancyImageFrame
  jsr _DrawArrows

  lda #26
  sta _ImageBuffer+40*128-1   ; Force back to TEXT

  ldx #0
loop
  lda _ImageBuffer+256*0,x
  sta $a000+256*0,x
  lda _ImageBuffer+256*1,x
  sta $a000+256*1,x
  lda _ImageBuffer+256*2,x
  sta $a000+256*2,x
  lda _ImageBuffer+256*3,x
  sta $a000+256*3,x
  lda _ImageBuffer+256*4,x
  sta $a000+256*4,x
  lda _ImageBuffer+256*5,x
  sta $a000+256*5,x
  lda _ImageBuffer+256*6,x
  sta $a000+256*6,x
  lda _ImageBuffer+256*7,x
  sta $a000+256*7,x
  lda _ImageBuffer+256*8,x
  sta $a000+256*8,x
  lda _ImageBuffer+256*9,x
  sta $a000+256*9,x
  lda _ImageBuffer+256*10,x
  sta $a000+256*10,x
  lda _ImageBuffer+256*11,x
  sta $a000+256*11,x
  lda _ImageBuffer+256*12,x
  sta $a000+256*12,x
  lda _ImageBuffer+256*13,x
  sta $a000+256*13,x
  lda _ImageBuffer+256*14,x
  sta $a000+256*14,x
  lda _ImageBuffer+256*15,x
  sta $a000+256*15,x
  lda _ImageBuffer+256*16,x
  sta $a000+256*16,x
  lda _ImageBuffer+256*17,x
  sta $a000+256*17,x
  lda _ImageBuffer+256*18,x
  sta $a000+256*18,x
  lda _ImageBuffer+256*19,x
  sta $a000+256*19,x
  dex
  bne loop

  ;jsr _Breakpoint
  rts
.)



PatchArrowTop
.(
  lda #<ArrowTop
  sta tmp0+0
  lda #>ArrowTop
  sta tmp0+1

  lda #6
  sta height

  lda #2
  sta width
  
  lda #<_ImageBuffer+19+40*112
  sta tmp1+0
  lda #>_ImageBuffer+19+40*112
  sta tmp1+1
  
  jmp BlitBloc
.)

PatchArrowLeft
.(
  lda #<ArrowLeft
  sta tmp0+0
  lda #>ArrowLeft
  sta tmp0+1

  lda #9
  sta height

  lda #3
  sta width
  
  lda #<_ImageBuffer+17+40*116
  sta tmp1+0
  lda #>_ImageBuffer+17+40*116
  sta tmp1+1
  
  jmp BlitBloc
.)


PatchArrowRight
.(
  lda #<ArrowRight
  sta tmp0+0
  lda #>ArrowRight
  sta tmp0+1

  lda #9
  sta height

  lda #3
  sta width

  lda #<_ImageBuffer+20+40*82
  sta tmp1+0
  lda #>_ImageBuffer+20+40*82
  sta tmp1+1
  
  lda #<_ImageBuffer+20+40*116
  sta tmp1+0
  lda #>_ImageBuffer+20+40*116
  sta tmp1+1
  
  jmp BlitBloc
.)

PatchArrowBottom
.(
  lda #<ArrowBottom
  sta tmp0+0
  lda #>ArrowBottom
  sta tmp0+1

  lda #13
  sta height

  lda #2
  sta width
  
  lda #<_ImageBuffer+19+40*120
  sta tmp1+0
  lda #>_ImageBuffer+19+40*120
  sta tmp1+1
  
  jmp BlitBloc
.)


BlitBloc
.(
loop_y  
  ldy #0
  ldx width
loop_x
  lda (tmp1),y
+BlitOperation  
  ora (tmp0),y
  ora #64
  ;eor (tmp0),y  
  sta (tmp1),y
  iny
  dex
  bne loop_x

  clc
  lda tmp0+0
  adc width
  sta tmp0+0
  lda tmp0+1
  adc #0
  sta tmp0+1

  clc
  lda tmp1+0
  adc #40
  sta tmp1+0
  lda tmp1+1
  adc #0
  sta tmp1+1

  dec height
  bne loop_y
  rts
.)

; From arrow_block_masks.png
; Contains two 36x28 pixels elements: The top half should be ANDed and the bottom half to be ORed with the image
ArrowBlockMasks  
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$5f,$7f,$7f,$7f,$7f,$7c,$47
	.byt $7f,$7f,$7f,$7f,$70,$41,$7f,$7f,$7f,$7f,$40,$40,$5f,$7f,$7f,$7c
	.byt $40,$40,$47,$7f,$7f,$70,$40,$40,$41,$7f,$7f,$40,$40,$40,$40,$5f
	.byt $7c,$40,$40,$40,$40,$47,$78,$40,$40,$40,$40,$43,$7c,$40,$40,$40
	.byt $40,$47,$7e,$40,$40,$40,$40,$4f,$7f,$40,$40,$40,$40,$5f,$7f,$60
	.byt $40,$40,$40,$7f,$7f,$70,$40,$40,$41,$7f,$40,$78,$40,$40,$43,$60
	.byt $5a,$4c,$40,$40,$46,$40,$40,$42,$40,$40,$48,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60
	.byt $40,$40,$40,$40,$43,$58,$40,$40,$40,$40,$4c,$66,$40,$40,$40,$40
	.byt $71,$51,$60,$40,$40,$43,$42,$68,$58,$40,$40,$4c,$41,$50,$46,$40
	.byt $40,$70,$60,$60,$61,$60,$43,$45,$40,$40,$54,$58,$44,$4a,$40,$40
	.byt $4a,$44,$49,$55,$54,$45,$55,$52,$44,$6a,$68,$62,$6a,$64,$42,$55
	.byt $41,$50,$55,$48,$41,$4a,$40,$60,$4a,$50,$40,$64,$41,$50,$44,$60
	.byt $40,$52,$42,$68,$49,$40,$40,$48,$41,$50,$42,$40,$5a,$44,$42,$68
	.byt $44,$4b,$40,$42,$55,$55,$48,$40,$40,$41,$4a,$6a,$50,$40,$40,$40
	.byt $65,$54,$60,$40,$40,$40,$52,$69,$40,$40,$40,$40,$49,$52,$40,$40
	.byt $40,$40,$44,$64,$40,$40,$40,$40,$42,$48,$40,$40,$40,$40,$41,$50
	.byt $40,$40,$40,$40,$40,$60,$40,$40


ArrowTop ; Patch at 19,112
 .byt %000000,%100000
 .byt %000001,%110000
 .byt %000111,%111100
 .byt %000001,%110000
 .byt %000001,%110000
 .byt %000000,%100000

ArrowLeft ; Patch at 17,116
 .byt %000000,%000001,%100000
 .byt %000000,%000111,%000000
 .byt %000000,%011111,%000000
 .byt %000001,%111111,%111100
 .byt %000000,%111111,%111100
 .byt %000000,%011111,%000000
 .byt %000000,%001111,%000000
 .byt %000000,%000110,%000000
 .byt %000000,%000010,%000000

ArrowRight ; Patch at 20,116
 .byt %000000,%110000,%000000
 .byt %000000,%011100,%000000
 .byt %000000,%011111,%000000
 .byt %000111,%111111,%110000
 .byt %000111,%111111,%100000
 .byt %000000,%011111,%000000
 .byt %000000,%011110,%000000
 .byt %000000,%001100,%000000
 .byt %000000,%001000,%000000

ArrowBottom ; Patch at 19,120
 .byt %000000,%100000
 .byt %000001,%110000
 .byt %000001,%110000
 .byt %000001,%110000
 .byt %000011,%111000
 .byt %000011,%111000
 .byt %000011,%111000
 .byt %011111,%111111
 .byt %001111,%111110
 .byt %000111,%111100
 .byt %000011,%111000
 .byt %000001,%110000
 .byt %000000,%100000


// Needs 6 characters to copy the 36x8 bottom part of the arrow block
// 59 -> ; character, followed by <=>?@
PatchArrowCharacters
.(
  ldx #0
  ldy #0
loop  
  lda _ImageBuffer+40*(128+0)+17,x
  sta $B800+8*59+0,y
  lda _ImageBuffer+40*(128+1)+17,x
  sta $B800+8*59+1,y
  lda _ImageBuffer+40*(128+2)+17,x
  sta $B800+8*59+2,y
  lda _ImageBuffer+40*(128+3)+17,x
  sta $B800+8*59+3,y
  lda _ImageBuffer+40*(128+4)+17,x
  sta $B800+8*59+4,y
  lda _ImageBuffer+40*(128+5)+17,x
  sta $B800+8*59+5,y
  lda _ImageBuffer+40*(128+6)+17,x
  sta $B800+8*59+6,y
  lda _ImageBuffer+40*(128+7)+17,x
  sta $B800+8*59+7,y

  tya
  clc
  adc #8
  tay

  inx
  cpx #6
  bne loop
  rts
.)

    .bss

* = $C000

_ImageBuffer    .dsb 40*200


