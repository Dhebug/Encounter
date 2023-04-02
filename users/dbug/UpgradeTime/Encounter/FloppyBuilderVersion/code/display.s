
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
  ; Hack the bitmask to add the arrow bitmap background as elements to always draw
  lda _gFlagDirections
  asl
  asl
  ora #3
  sta _gFlagDirections

  ; Iterate over the list of all bitmap elements, and draw them if the bit is activated in the mask variable
  ldx #0
loop_draw_arrow  
  lda BlitDataTable+0,x   ; Blit mode (AND/ORA)
  beq end_draw_arrow
  sta BlitOperation

  lsr _gFlagDirections
  bcc skip_draw

  lda BlitDataTable+1,x   ; Source graphics
  sta tmp0+0
  lda BlitDataTable+2,x
  sta tmp0+1

  lda BlitDataTable+3,x   ; Destination
  sta tmp1+0
  lda BlitDataTable+4,x
  sta tmp1+1

  lda BlitDataTable+5,x   ; Dimensions
  sta width
  lda BlitDataTable+6,x
  sta height
  
  txa                     ; I wish we had phx/plx on the base 6502
  pha 
  jsr BlitBloc
  pla
  tax

skip_draw  
  txa
  clc
  adc #7
  tax
  jmp loop_draw_arrow
end_draw_arrow
 
  jsr PatchArrowCharacters

  ; Reset the direction (note: Will happen automatically when the UP and DOWN cases are handled)
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


#define BLIT_AND $31    
#define BLIT_OR  $11

#define BLIT_INFO(opcode,source,destination,width,height)  .byt opcode,<source,>source,<destination,>destination,width,height

BlitDataTable
  ; ArrowBlockMasks -> 102,111 -> 17,111
  ; The block itself is 32x18 pixels (6 bytes wide)
  ; The top 18 pixels is the AND mask, the bottom 18 pixels are the OR mask
  BLIT_INFO(BLIT_AND  ,ArrowBlockMasks+0    ,_ImageBuffer+17+40*110,6, 26)       // Arrow block (AND masked)
  BLIT_INFO(BLIT_OR   ,ArrowBlockMasks+6*26 ,_ImageBuffer+17+40*110,6, 26)       // Arrow block (OR masked)
  ; The four directional arrows
  BLIT_INFO(BLIT_OR   ,ArrowTop    ,_ImageBuffer+19+40*112,2, 6)                 // North Arrow
  BLIT_INFO(BLIT_OR   ,ArrowBottom ,_ImageBuffer+19+40*120,2,13)                 // South Arrow
  BLIT_INFO(BLIT_OR   ,ArrowRight  ,_ImageBuffer+20+40*116,3, 9)                 // East Arrow
  BLIT_INFO(BLIT_OR   ,ArrowLeft   ,_ImageBuffer+17+40*116,3, 9)                 // West Arrow
  ; Should have two more entries for UP and DOWN there
  BLIT_INFO(BLIT_OR   ,ArrowUp     ,_ImageBuffer+20+40*129,2, 7)                 // Up Arrow
  BLIT_INFO(BLIT_OR   ,ArrowDown   ,_ImageBuffer+18+40*129,2, 7)                 // Down Arrow
  .byt 0


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

ArrowUp ; Patch at 20,129
 .byt %000000,%000111
 .byt %000000,%000011
 .byt %000000,%001101
 .byt %000000,%001000
 .byt %000000,%111000
 .byt %000000,%100000
 .byt %000011,%100000

ArrowDown ; Patch at 18,129
 .byt %111000,%000000
 .byt %001000,%000000
 .byt %001110,%000000
 .byt %000010,%000000
 .byt %000011,%010000
 .byt %000000,%110000
 .byt %000001,%110000


_gSevenDigitDisplay
 ; 0
 .byt %011100
 .byt %100010
 .byt %100010
 .byt %000000
 .byt %100010
 .byt %100010
 .byt %011100
 .byt %000000
 ; 1
 .byt %000000
 .byt %000010
 .byt %000010
 .byt %000000
 .byt %000010
 .byt %000010
 .byt %000000
 .byt %000000
 ; 2
 .byt %011100
 .byt %000010
 .byt %000010
 .byt %011100
 .byt %100000
 .byt %100000
 .byt %011100
 .byt %000000
 ; 3
 .byt %011100
 .byt %000010
 .byt %000010
 .byt %011100
 .byt %000010
 .byt %000010
 .byt %011100
 .byt %000000
 ; 4
 .byt %000000
 .byt %100010
 .byt %100010
 .byt %011100
 .byt %000010
 .byt %000010
 .byt %000000
 .byt %000000
 ; 5
 .byt %011100
 .byt %100000
 .byt %100000
 .byt %011100
 .byt %000010
 .byt %000010
 .byt %011100
 .byt %000000
 ; 6
 .byt %011100
 .byt %100000
 .byt %100000
 .byt %011100
 .byt %100010
 .byt %100010
 .byt %011100
 .byt %000000
 ; 7
 .byt %011100
 .byt %000010
 .byt %000010
 .byt %000000
 .byt %000010
 .byt %000010
 .byt %000000
 .byt %000000
 ; 8
 .byt %011100
 .byt %100010
 .byt %100010
 .byt %000000
 .byt %100010
 .byt %100010
 .byt %011100
 .byt %000000
 ; 9
 .byt %011100
 .byt %100010
 .byt %100010
 .byt %011100
 .byt %000010
 .byt %000010
 .byt %011100
 .byt %000000
 ; :
 .byt %000000
 .byt %000000
 .byt %001100
 .byt %000000
 .byt %000000
 .byt %001100
 .byt %000000
 .byt %000000


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


_gTableModulo6
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3

_gTableDivBy6
  .byt 0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9,9,9,9
  .byt 10,10,10,10,10,10,11,11,11,11,11,11,12,12,12,12,12,12,13,13,13,13,13,13,14,14,14,14,14,14,15,15,15,15,15,15,16,16,16,16,16,16,17,17,17,17,17,17,18,18,18,18,18,18,19,19,19,19,19,19
  .byt 20,20,20,20,20,20,21,21,21,21,21,21,22,22,22,22,22,22,23,23,23,23,23,23,24,24,24,24,24,24,25,25,25,25,25,25,26,26,26,26,26,26,27,27,27,27,27,27,28,28,28,28,28,28,29,29,29,29,29,29
  .byt 30,30,30,30,30,30,31,31,31,31,31,31,32,32,32,32,32,32,33,33,33,33,33,33,34,34,34,34,34,34,35,35,35,35,35,35,36,36,36,36,36,36,37,37,37,37,37,37,38,38,38,38,38,38,39,39,39,39,39,39
  .byt 40,40,40,40,40,40,41,41,41,41,41,41,42,42,42,42

_gBitPixelMask
  .byt %100000
  .byt %010000
  .byt %001000
  .byt %000100
  .byt %000010
  .byt %000001

_gBitPixelMaskLeft
  .byt %111111
  .byt %011111
  .byt %001111
  .byt %000111
  .byt %000011
  .byt %000001

_gBitPixelMaskRight
  .byt %100000
  .byt %110000
  .byt %111000
  .byt %111100
  .byt %111110
  .byt %111111

    .bss

* = $C000

_ImageBuffer    .dsb 40*200


