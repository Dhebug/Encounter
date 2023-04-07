
  .zero

width   .dsb 1
height  .dsb 1    

    .text

_gFlagDirections  .byt 0    ; Bit flag containing all the possible directions for the current scene (used to draw the arrows on the scene)

_gDrawAddress   .word 0
_gDrawExtraData .word 0
_gDrawPosX    .byt 0
_gDrawPosY    .byt 0
_gDrawWidth   .byt 0
_gDrawHeight  .byt 0
_gDrawPattern .byt 0



; tmp0  -> screen
; tmp1  -> character string
; tmp2  -> x / y position
; tmp3  -> current character
; tmp4  -> width / v
; tmp5  -> targetPtr
; tmp6  -> shiftTablePtr
; tmp7  -> fontPtr
; reg0  -> targetScanlinePtr
.(
baseLinePtr   = tmp0
messagePtr    = tmp1
x_position    = tmp2
y_position    = tmp2+1
width_char    = tmp4
font_byte     = tmp4+1
targetPtr     = tmp5
shiftTablePtr = tmp6
fontPtr       = tmp7
scanlinePtr   = reg0

end_of_string
  ; Update the pointer
  clc
  lda messagePtr+0
  adc #1
  sta _gDrawExtraData+0
  lda messagePtr+1
  adc #0
  sta _gDrawExtraData+1

  rts

+_PrintFancyFont
  ; Depending of the request pattern, we auto-modify the code 
  ; to avoid having a test and branch in the inner loop
  lda _gDrawPattern
  and #63
  bne or_mode

and_mode                 ; Black text over white background
  ldy #%01111111
  ldx #$31               ; and (zp),y
  bne continue_mode

or_mode                  ; White text over black background
  ldy #%00000000
  ldx #$11               ; ora (zp),y

continue_mode
  sty auto_eor_1__+1
  sty auto_eor_2__+1

  stx auto_or_and_1__
  stx auto_or_and_2__

  ;char* baseLinePtr = (char*)0xa000+(gDrawPosY*40);
  ldx _gDrawPosY
  clc 
  lda _gDrawAddress+0
  adc _gTableMulBy40Low,x
  sta baseLinePtr+0

  lda _gDrawAddress+1
  adc _gTableMulBy40High,x
  sta baseLinePtr+1

  ; Copy the pointer to the string
  lda _gDrawExtraData+0
  sta messagePtr+0
  lda _gDrawExtraData+1
  sta messagePtr+1

  lda _gDrawPosX
  sta x_position
  lda _gDrawPosY
  sta y_position

loop_character
  ; Fetch the next character from the string
  ; 0    -> End of string
  ; 13   -> Carriage return (used to handle multi-line strings) followed by a scanline count
  ; <0   -> Horizontal offset to simulate kerning tables
  ; >=32 -> Normal ASCII characters in the 32-127 range
  ldy #0
  lda (messagePtr),y
  beq end_of_string
  bmi negative_value
  cmp #13
  bne normal_character

carriage_return  
  ; Reset the position to the left margin
  lda _gDrawPosX
  sta x_position

  ; Increment message pointer to fetch the scanline count
  .(  
  inc messagePtr+0
  bne skip
  inc messagePtr+1
skip
  .)  

  ;	Update the baseline pointer 
  lda (messagePtr),y
  tax 
  clc 
  lda baseLinePtr+0
  adc _gTableMulBy40Low,x
  sta baseLinePtr+0

  lda baseLinePtr+1
  adc _gTableMulBy40High,x
  sta baseLinePtr+1

  bne continue


negative_value
  ; xPos += car;
  clc
  adc x_position
  sta x_position

continue 
  .(  ; Increment message pointer
  inc messagePtr+0
  bne skip
  inc messagePtr+1
skip
  .)  
  bne loop_character


normal_character
  ; Convert the character input from [32-127] to [0-95] because we are using many look-up tables
  sec
  sbc #32

  ; Get the width (in pixels) of the current character (used to do proper proportional font handling)
  tax
  ldy _gFont12x14Width,x
  sty width_char

  ; Locate the bitmap definition for this character in the 1140x14 bitmap. Each character is two bytes wide and 14 scanlines tall
  asl                   ; characters are two bytes wide
  clc
  adc #<_gFont12x14
  sta fontPtr+0
  lda #0
  adc #>_gFont12x14
  sta fontPtr+1

  ; Using the current x coordinate in the scanline, we compute the actual position on the screen where to start drawing the character
  lda x_position 
  tax                   ; Keep the original current X value for later
  sec                   ; +1 because we don't want the characters to be glued together
  adc width_char
  sta x_position

  ;clc                  ; Already at zero thanks to the prevous adc
  lda baseLinePtr+0
  adc _gTableDivBy6,x
  sta targetPtr+0
  lda baseLinePtr+1
  adc #0
  sta targetPtr+1

  ; The shift table contains all the combinations of 6 pixels patterns shifted by 0 to 5 pixels to the right.
  ; Each entry requires two bytes, and each need to be merged to the target buffer to rebuild the complete shifted graphics
  lda _gTableModulo6,x
  lsr                      ; The lsr + ror is equivalent to multiply by 128 the 16 bit value
  sta shiftTablePtr+1      ; Store the divided by two value in the most significant byte
  lda #0
  ror                      ; Get back the carry at the top of the least significant byte
  sta shiftTablePtr+0

  ; Then we add the base address of the buffer, we could not do that in the previous pass because the carry was alrady used for the ror trick
  clc
  lda shiftTablePtr+0
  adc #<_gShiftBuffer
  sta shiftTablePtr+0
  lda shiftTablePtr+1
  adc #>_gShiftBuffer
  sta shiftTablePtr+1

  dec width_char
column_loop  
  ; Draw the 14 scanlines of each character vertically one by one.
  lda targetPtr+0
  sta scanlinePtr+0
  lda targetPtr+1
  sta scanlinePtr+1

  ldx #14
scanline_loop  
  ; Read one byte from the character
  ; char v = (*fontPtr & 63)<<1;
  ldy #0
  lda (fontPtr),y
  and #63
  asl
  sta font_byte         ; (v & 63) << 1

  ; And use the shift table to get the left and right parts shifted by the right amount
  ;	targetScanlinePtr[0] &= (~shiftTablePtr[v+0])|64;
  ldy font_byte
  lda (shiftTablePtr),y
auto_eor_1__
  eor #%00111111
  ldy #0
auto_or_and_1__
  and (scanlinePtr),y
  sta (scanlinePtr),y

  ;	targetScanlinePtr[1] &= (~shiftTablePtr[v+1])|64;
  ldy font_byte
  iny
  lda (shiftTablePtr),y
auto_eor_2__
  eor #%00111111
  ldy #1
auto_or_and_2__
  and (scanlinePtr),y
  sta (scanlinePtr),y

  ; Next scanline of the font
  .(
  clc
  lda fontPtr+0
  adc #95*2
  sta fontPtr+0
  bcc skip
  inc fontPtr+1
skip  
  .)

  ; Next scanline on the screen
  .(
  clc
  lda scanlinePtr+0
  adc #40
  sta scanlinePtr+0
  bcc skip
  inc scanlinePtr+1
skip  
  .)

  dex 
  bne scanline_loop

  ; Move to the next screen column
  .(
  inc targetPtr+0
  bne skip
  inc targetPtr+1
skip  
  .)

  ; fontPtr = fontPtr - (95*2*14) +1;
  sec
  lda fontPtr+0
  sbc #<95*2*14-1
  sta fontPtr+0
  lda fontPtr+1
  sbc #>95*2*14-1
  sta fontPtr+1

  ; width-=6;
  sec
  lda width_char
  sbc #6
  sta width_char

  ; while (width>0)
  bpl column_loop
  jmp continue  
.)


_DrawFilledRectangle
.(
  ;char* baseLinePtr = (char*)0xa000+(gDrawPosY*40);
  ldx _gDrawPosY
  clc 
  lda _gDrawAddress+0
  adc _gTableMulBy40Low,x
  sta tmp0+0

  lda _gDrawAddress+1
  adc _gTableMulBy40High,x
  sta tmp0+1                   ; baseLinePtr

  ;char* drawPtr  = baseLinePtr+gTableDivBy6[gDrawPosX];
  ; +gTableDivBy6[gDrawPosX];
  ldx _gDrawPosX
  clc
  lda _gTableDivBy6,x
  sta tmp1                     ; leftOffset
  adc tmp0+0
  sta tmp0+0

  lda tmp0+1
  adc #0
  sta tmp0+1                   ; drawPtr

  ;char leftPixelFillMask = gBitPixelMaskLeft[gTableModulo6[gDrawPosX]];
  lda _gTableModulo6,x
  tax
  lda _gBitPixelMaskLeft,x
  ora #64
  sta tmp2+0                 ; leftPixelFillMask
  eor #%00111111
  sta tmp2+1                 ; leftPixelFillMask (inverted for masking)

  ;char* rightPtr = baseLinePtr
  ; +gTableDivBy6[gDrawPosX+gDrawWidth-1];
  clc
  lda _gDrawPosX
  adc _gDrawWidth
  tax
  dex
  sec
  lda _gTableDivBy6,x
  sbc tmp1
  sta tmp1              ; byteCount

  ;char rightPixeFillMask = gBitPixelMaskRight[gTableModulo6[gDrawPosX+gDrawWidth-1]];
  lda _gTableModulo6,x
  tax
  lda _gBitPixelMaskRight,x
  ora #64
  sta tmp3+0                  ; rightPixeFillMask
  eor #%00111111
  sta tmp3+1                  ; rightPixeFillMask (inverted for masking)

  ldx _gDrawHeight
loop_next_line
  stx tmp5

  ; if (byteCount==0)
  lda tmp1
  bne multiple_byte

  ; tmp0 -> drawPtr
  ; tmp1 -> byteCount
  ; tmp2 -> leftPixelFillMask (normal / inverted)
  ; tmp3 -> rightPixeFillMask (normal / inverted)

one_byte
  ; Special case where the start and the end are the same
  ; *drawPtr = (*drawPtr) & (~(leftPixelFillMask & rightPixeFillMask)|64) | (gDrawPattern & leftPixelFillMask & rightPixeFillMask);
  lda _gDrawPattern
  and tmp2+0
  and tmp3+0
  sta tmp4             ; (gDrawPattern & leftPixelFillMask & rightPixeFillMask);

  lda tmp2+0
  and tmp3+0
  ora #64
  eor #%00111111
  sta tmp4+1

  ldy #0
  lda (tmp0),y
  ;and tmp2+1           ; & (~(leftPixelFillMask & rightPixeFillMask)|64) 
  ;and tmp3+1
  and tmp4+1
  ora tmp4             ; | (gDrawPattern & leftPixelFillMask & rightPixeFillMask);
  sta (tmp0),y
  jmp next_line

multiple_byte  
  ; *drawPtr++  = ((*drawPtr) & (~leftPixelFillMask|64)) | (gDrawPattern & leftPixelFillMask);
  lda _gDrawPattern
  and tmp2+0
  sta tmp4             ; (gDrawPattern & leftPixelFillMask);

  ldy #0
  lda (tmp0),y
  and tmp2+1           ; & (~leftPixelFillMask|64))
  ora tmp4             ; | (gDrawPattern & leftPixelFillMask);
  sta (tmp0),y

  ; while (--byteCount)  *drawPtr++ = gDrawPattern; 
  lda _gDrawPattern
  ldx tmp1
repeat_loop  
  dex 
  beq end_repeat
  iny
  sta (tmp0),y
  jmp repeat_loop

end_repeat    
  ; *drawPtr = ((*drawPtr) & (~rightPixeFillMask|64)) | (gDrawPattern & rightPixeFillMask);
  lda _gDrawPattern
  and tmp3+0
  sta tmp4             ; (gDrawPattern & rightPixeFillMask);

  iny
  lda (tmp0),y
  and tmp3+1           ; & (~rightPixeFillMask|64))
  ora tmp4             ; | (gDrawPattern & rightPixeFillMask);
  sta (tmp0),y

next_line
  ; leftPtr+=40;
  clc
  lda tmp0+0
  adc #40
  sta tmp0+0
  lda tmp0+1
  adc #0
  sta tmp0+1

  ldx tmp5
  dex
  bne loop_next_line

  rts
.)



_DrawHorizontalLine
.(
  lda _gDrawHeight
  pha
  lda #1
  sta _gDrawHeight
  jsr _DrawFilledRectangle
  pla
  sta _gDrawHeight
  rts
.)


_DrawVerticalLine
.(
  lda _gDrawWidth
  pha
  lda #1
  sta _gDrawWidth
  jsr _DrawFilledRectangle
  pla
  sta _gDrawWidth
  rts
.)


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


; Needs 6 characters to copy the 36x8 bottom part of the arrow block
; 59 -> ; character, followed by <=>?@
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


; Merges together the 14 scanlines of one character's column
; This is used to compute the width of each character
GetFancyFontColumnMerged
.(
  lda _gFont12x14+190*0,y
  ora _gFont12x14+190*1,y
  ora _gFont12x14+190*2,y
  ora _gFont12x14+190*3,y
  ora _gFont12x14+190*4,y
  ora _gFont12x14+190*5,y
  ora _gFont12x14+190*6,y
  ora _gFont12x14+190*7,y
  ora _gFont12x14+190*8,y
  ora _gFont12x14+190*9,y
  ora _gFont12x14+190*10,y
  ora _gFont12x14+190*11,y
  ora _gFont12x14+190*12,y
  ora _gFont12x14+190*13,y
  and #%00111111
  rts
.)


; Computes the width of each of the 96 characters in the font by calling GetFancyFontColumnMerged
; for each of the columns, then tries to locate the bottom-most bit, then stores the result in the
; _gFont12x14Width table.
;
; We have a special case for the space character which technically has no graphical representation,
; that one has been force to 4 pixels wide after experimentation with text display
_ComputeFancyFontWidth
.(
  ldx #0
loop_character
  txa
  asl    ; x2
  tay
  iny    ; Read the second merged byte 
  jsr GetFancyFontColumnMerged   
  beq not_double_byte

double_byte                      ; This is a wide character, using two bytes
  ldy #12
  jmp find_top_bit

not_double_byte                      
  dey    ; Read the first merged byte 
  jsr GetFancyFontColumnMerged   
  beq zero_byte
single_byte  
  ldy #6                         ; This is a narrow character, only requires one byte
find_top_bit
  lsr 
  bcs end_byte                   ; Found the top right pixel
  dey
  jmp find_top_bit

zero_byte                        ; Probably the space character, does not use anything
  ldy #0
end_byte  
  tya
  sta _gFont12x14Width,x         ; Store the width

  ; next character
  inx
  cpx #95
  bne loop_character  

  ; Value for the space
  ; 6 is too spaced out
  lda #4
  sta _gFont12x14Width+0
  rts
.)


; Generate the tables used to shift the graphics.
;
; The first loop just create the first initia 64 values (on the left byte) and zeroes (on the right byte)
; The second loop does a copy/shift propagation by shifting the source by one pixel and then writes it back
; to the destination buffer... which becomes the new source buffer for the next iteration loop.
;
; After 5 passes we have all the 6 possible shifted positions available.
_GenerateShiftBuffer
.(
  lda #<_gShiftBuffer
  sta tmp1+0
  lda #>_gShiftBuffer
  sta tmp1+1

  ; Initial fill of the buffer with just the unshifted pattern
  ldx #0
  ldy #0
loop_fill
  txa
  sta (tmp1),y
  iny 

  lda #0
  sta (tmp1),y
  iny 

  inx 
  cpx #64
  bne loop_fill  

  ; Then we do 5 copies, each using the previous content shifted by one
  ldx #5
loop_scroll_outer
  clc
  lda tmp1+0
  sta tmp0+0
  adc #64*2
  sta tmp1+0

  lda tmp1+1
  sta tmp0+1
  adc #0
  sta tmp1+1

  ldy #0
loop_scroll_inner
  lda (tmp0),y      ; Load the first byte
  lsr               ; -> c
  sta (tmp1),y      ; Write down the first byte shifted by one
  iny

  lda #0
  ror               ; c -> b7
  lsr               ; c -> b6
  ora (tmp0),y      ; Merged the second byte
  lsr
  sta (tmp1),y      ; Write down the second byte shifted by one
  iny

  cpy #64*2
  bne loop_scroll_inner

  dex
  bne loop_scroll_outer

  rts
.)


; Generate the 16bit table with y*40 values
; This is used to access any specific scanline in the back buffer (or screen) without any multiplication
_GenerateMul40Table
.(
  ldx #0
  stx _gTableMulBy40Low
  stx _gTableMulBy40High

loop
  clc
  lda _gTableMulBy40Low,x
  adc #40
  sta _gTableMulBy40Low+1,x

  lda _gTableMulBy40High,x
  adc #0
  sta _gTableMulBy40High+1,x

  inx 
  cpx #127
  bne loop  
  rts
.)


; Given a X value, returns the value modulo 6 (used to access the proper pixel in a graphical block)
_gTableModulo6
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3,4,5
  .byt 0,1,2,3,4,5,0,1,2,3,4,5,0,1,2,3


; Given a X value, returns the value divide by 6 (used to locate the proper byte in a scanline)
_gTableDivBy6
  .byt 0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,7,7,7,7,7,7,8,8,8,8,8,8,9,9,9,9,9,9
  .byt 10,10,10,10,10,10,11,11,11,11,11,11,12,12,12,12,12,12,13,13,13,13,13,13,14,14,14,14,14,14,15,15,15,15,15,15,16,16,16,16,16,16,17,17,17,17,17,17,18,18,18,18,18,18,19,19,19,19,19,19
  .byt 20,20,20,20,20,20,21,21,21,21,21,21,22,22,22,22,22,22,23,23,23,23,23,23,24,24,24,24,24,24,25,25,25,25,25,25,26,26,26,26,26,26,27,27,27,27,27,27,28,28,28,28,28,28,29,29,29,29,29,29
  .byt 30,30,30,30,30,30,31,31,31,31,31,31,32,32,32,32,32,32,33,33,33,33,33,33,34,34,34,34,34,34,35,35,35,35,35,35,36,36,36,36,36,36,37,37,37,37,37,37,38,38,38,38,38,38,39,39,39,39,39,39
  .byt 40,40,40,40,40,40,41,41,41,41,41,41,42,42,42,42


; Bitmap with each possible combination of pixel to mask to draw a vertical line
_gBitPixelMask
  .byt %100000
  .byt %010000
  .byt %001000
  .byt %000100
  .byt %000010
  .byt %000001

; Bitmap with each possible left endings - used to draw horizontal segments
_gBitPixelMaskLeft
  .byt %111111
  .byt %011111
  .byt %001111
  .byt %000111
  .byt %000011
  .byt %000001

; Bitmap with each possible right endings - used to draw horizontal segments
_gBitPixelMaskRight
  .byt %100000
  .byt %110000
  .byt %111000
  .byt %111100
  .byt %111110
  .byt %111111


; 95 characters (from space to tilde), each is two byte large and 14 lines tall = 2660 bytes
_gFont12x14
  .byt $40,$40,$40,$40,$54,$40,$40,$40,$42,$40,$40,$40,$40,$40,$50,$40
  .byt $44,$40,$48,$40,$48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$44,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$60,$40,$40,$40,$40,$40,$40,$40
  .byt $48,$40,$54,$40,$45,$40,$47,$40,$58,$50,$4e,$40,$50,$40,$48,$40
  .byt $48,$40,$68,$40,$40,$40,$40,$40,$40,$40,$40,$40,$44,$40,$4c,$40
  .byt $46,$40,$4e,$40,$4c,$40,$42,$40,$4f,$40,$46,$40,$7e,$40,$4c,$40
  .byt $46,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$58,$40,$40,$40
  .byt $40,$50,$4f,$60,$47,$70,$4f,$70,$4f,$70,$4f,$70,$47,$60,$4e,$4e
  .byt $4e,$40,$47,$40,$4e,$58,$4e,$40,$4c,$43,$4c,$4e,$47,$60,$4f,$60
  .byt $47,$60,$4f,$60,$4f,$40,$7f,$60,$58,$5c,$78,$78,$79,$47,$5c,$78
  .byt $70,$50,$5f,$70,$4c,$40,$60,$40,$5c,$40,$48,$40,$40,$40,$60,$40
  .byt $40,$40,$58,$40,$40,$40,$43,$40,$40,$40,$40,$70,$40,$40,$58,$40
  .byt $48,$40,$42,$40,$58,$40,$58,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$58,$40,$60,$40,$58,$40,$40,$40,$40,$40,$48,$40
  .byt $68,$40,$45,$40,$4b,$40,$64,$60,$52,$40,$60,$40,$50,$40,$44,$40
  .byt $5c,$40,$40,$40,$40,$40,$40,$40,$40,$40,$48,$40,$52,$40,$5a,$40
  .byt $51,$40,$52,$40,$46,$40,$48,$40,$48,$40,$42,$40,$52,$40,$49,$40
  .byt $40,$40,$40,$40,$41,$40,$40,$40,$60,$40,$64,$40,$4f,$40,$40,$70
  .byt $44,$60,$48,$50,$44,$48,$44,$50,$44,$50,$48,$50,$44,$44,$44,$40
  .byt $42,$40,$44,$60,$44,$40,$44,$46,$46,$44,$48,$50,$44,$50,$48,$50
  .byt $44,$50,$51,$40,$64,$60,$48,$48,$50,$50,$51,$42,$48,$50,$48,$60
  .byt $50,$50,$48,$40,$50,$40,$44,$40,$48,$40,$40,$40,$50,$40,$40,$40
  .byt $48,$40,$40,$40,$41,$40,$40,$40,$41,$40,$40,$40,$48,$40,$40,$40
  .byt $40,$40,$48,$40,$48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$50,$40,$60,$40,$48,$40,$40,$40,$40,$40,$48,$40,$40,$40
  .byt $5f,$60,$54,$40,$64,$60,$50,$50,$40,$40,$60,$40,$44,$40,$68,$40
  .byt $48,$40,$40,$40,$40,$40,$40,$40,$48,$40,$52,$40,$44,$40,$41,$40
  .byt $42,$40,$4a,$40,$50,$40,$50,$40,$44,$40,$52,$40,$51,$40,$40,$40
  .byt $40,$40,$46,$40,$40,$40,$58,$40,$44,$40,$50,$60,$41,$50,$44,$60
  .byt $50,$50,$44,$44,$48,$40,$48,$40,$50,$50,$48,$48,$44,$40,$44,$40
  .byt $49,$40,$48,$40,$4a,$4a,$46,$44,$50,$48,$48,$50,$50,$48,$44,$50
  .byt $50,$40,$44,$40,$50,$50,$50,$60,$51,$42,$44,$60,$49,$40,$40,$60
  .byt $50,$40,$50,$40,$48,$40,$54,$40,$40,$40,$40,$40,$40,$40,$48,$40
  .byt $40,$40,$42,$40,$40,$40,$41,$40,$40,$40,$48,$40,$40,$40,$40,$40
  .byt $48,$40,$48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $50,$40,$60,$40,$48,$40,$40,$40,$40,$40,$50,$40,$40,$40,$4a,$40
  .byt $54,$40,$59,$40,$48,$50,$40,$40,$60,$40,$44,$40,$40,$40,$48,$40
  .byt $40,$40,$40,$40,$40,$40,$48,$40,$62,$40,$44,$40,$41,$40,$44,$40
  .byt $4a,$40,$5e,$40,$6c,$40,$44,$40,$54,$40,$51,$40,$50,$40,$50,$40
  .byt $58,$40,$40,$40,$46,$40,$44,$40,$67,$50,$42,$50,$49,$40,$60,$40
  .byt $48,$44,$48,$40,$48,$40,$60,$40,$48,$48,$48,$40,$44,$40,$4a,$40
  .byt $48,$40,$4a,$4a,$49,$44,$60,$48,$48,$50,$60,$48,$48,$60,$50,$40
  .byt $48,$40,$50,$50,$50,$60,$52,$64,$45,$40,$4a,$40,$41,$40,$50,$40
  .byt $50,$40,$48,$40,$54,$40,$40,$40,$40,$40,$4e,$40,$56,$40,$4c,$40
  .byt $4e,$40,$4c,$40,$47,$60,$4c,$40,$53,$40,$70,$40,$4c,$40,$53,$40
  .byt $50,$40,$76,$70,$73,$40,$4e,$40,$5b,$40,$4e,$40,$74,$40,$5c,$40
  .byt $7c,$40,$71,$40,$79,$40,$79,$48,$59,$40,$71,$40,$5e,$40,$50,$40
  .byt $60,$40,$50,$40,$40,$40,$40,$40,$50,$40,$40,$40,$4a,$40,$4e,$40
  .byt $43,$40,$53,$60,$40,$40,$60,$40,$44,$40,$40,$40,$7e,$40,$40,$40
  .byt $78,$40,$40,$40,$50,$40,$62,$40,$44,$40,$42,$40,$4c,$40,$52,$40
  .byt $41,$40,$72,$40,$48,$40,$58,$40,$53,$40,$40,$40,$40,$40,$60,$40
  .byt $7e,$40,$41,$40,$48,$40,$69,$50,$44,$50,$4f,$40,$60,$40,$48,$44
  .byt $4f,$40,$4f,$40,$60,$40,$4f,$78,$48,$40,$44,$40,$4c,$40,$48,$40
  .byt $4a,$52,$49,$48,$60,$48,$4b,$60,$60,$48,$4b,$40,$4c,$40,$48,$40
  .byt $50,$50,$51,$40,$52,$64,$42,$40,$44,$40,$42,$40,$50,$40,$48,$40
  .byt $48,$40,$62,$40,$40,$40,$40,$40,$52,$40,$5a,$40,$54,$40,$52,$40
  .byt $54,$40,$42,$40,$53,$40,$55,$40,$50,$40,$44,$40,$54,$40,$50,$40
  .byt $5b,$50,$55,$40,$52,$40,$4d,$40,$52,$40,$58,$40,$64,$40,$50,$40
  .byt $51,$40,$69,$40,$69,$48,$4a,$40,$51,$40,$52,$40,$60,$40,$60,$40
  .byt $50,$40,$72,$40,$40,$40,$50,$40,$40,$40,$4a,$40,$45,$40,$42,$58
  .byt $65,$40,$40,$40,$60,$40,$44,$40,$40,$40,$48,$40,$40,$40,$40,$40
  .byt $40,$40,$50,$40,$62,$40,$44,$40,$44,$40,$42,$40,$64,$40,$41,$40
  .byt $62,$40,$48,$40,$64,$40,$4d,$40,$40,$40,$40,$40,$58,$40,$40,$40
  .byt $46,$40,$50,$40,$6a,$70,$47,$70,$48,$60,$60,$40,$48,$44,$48,$40
  .byt $48,$40,$61,$70,$48,$48,$48,$40,$44,$40,$4a,$40,$48,$40,$49,$54
  .byt $48,$68,$60,$48,$48,$40,$60,$48,$49,$40,$42,$40,$48,$40,$50,$50
  .byt $52,$40,$54,$68,$45,$40,$44,$40,$44,$40,$50,$40,$48,$40,$48,$40
  .byt $40,$40,$40,$40,$40,$40,$62,$40,$52,$40,$60,$40,$62,$40,$78,$40
  .byt $42,$40,$52,$40,$59,$40,$50,$40,$44,$40,$58,$40,$50,$40,$52,$50
  .byt $59,$40,$62,$40,$49,$40,$62,$40,$50,$40,$70,$40,$50,$40,$51,$40
  .byt $51,$40,$52,$48,$44,$40,$51,$40,$44,$40,$50,$40,$60,$40,$48,$40
  .byt $6e,$40,$40,$40,$40,$40,$40,$40,$7f,$40,$45,$40,$44,$64,$61,$40
  .byt $40,$40,$60,$40,$48,$40,$40,$40,$48,$40,$40,$40,$40,$40,$40,$40
  .byt $50,$40,$64,$40,$48,$40,$48,$40,$42,$40,$7f,$40,$61,$40,$62,$40
  .byt $50,$40,$64,$40,$42,$40,$40,$40,$40,$40,$46,$40,$7e,$40,$58,$40
  .byt $50,$40,$6d,$60,$48,$50,$50,$60,$60,$40,$50,$48,$50,$40,$50,$40
  .byt $60,$60,$50,$50,$50,$40,$48,$40,$51,$40,$50,$40,$51,$64,$50,$68
  .byt $60,$50,$50,$40,$60,$50,$50,$60,$42,$40,$48,$40,$60,$60,$4a,$40
  .byt $54,$68,$49,$40,$48,$40,$48,$40,$50,$40,$48,$40,$48,$40,$40,$40
  .byt $40,$40,$40,$40,$64,$40,$62,$40,$60,$40,$64,$40,$60,$40,$44,$40
  .byt $52,$40,$52,$40,$60,$40,$48,$40,$64,$40,$60,$40,$64,$60,$62,$40
  .byt $62,$40,$51,$40,$64,$40,$60,$40,$4c,$40,$60,$40,$66,$40,$52,$40
  .byt $52,$50,$4c,$40,$62,$40,$48,$40,$50,$40,$60,$40,$50,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$54,$40,$6a,$40,$44,$64,$62,$40,$40,$40
  .byt $50,$40,$50,$40,$40,$40,$40,$40,$50,$40,$40,$40,$40,$40,$60,$40
  .byt $64,$40,$48,$40,$50,$40,$64,$40,$44,$40,$62,$40,$64,$40,$50,$40
  .byt $64,$40,$64,$40,$40,$40,$40,$40,$41,$40,$40,$40,$60,$40,$40,$40
  .byt $50,$40,$50,$50,$51,$40,$50,$60,$50,$50,$50,$60,$50,$40,$50,$60
  .byt $50,$50,$50,$40,$48,$40,$50,$60,$51,$40,$51,$44,$50,$50,$50,$60
  .byt $50,$40,$50,$60,$50,$60,$62,$40,$50,$40,$61,$60,$4c,$40,$48,$50
  .byt $50,$60,$48,$40,$50,$60,$60,$40,$44,$40,$50,$40,$40,$40,$40,$40
  .byt $40,$40,$6c,$40,$64,$40,$64,$40,$6c,$40,$64,$40,$44,$40,$4c,$40
  .byt $62,$40,$60,$40,$48,$40,$64,$40,$60,$40,$64,$60,$62,$40,$64,$40
  .byt $52,$40,$6c,$40,$60,$40,$64,$40,$68,$40,$6a,$40,$52,$40,$52,$50
  .byt $54,$40,$66,$40,$52,$40,$60,$40,$60,$40,$50,$40,$40,$40,$40,$40
  .byt $60,$40,$40,$40,$54,$40,$7c,$40,$48,$58,$5c,$40,$40,$40,$50,$40
  .byt $60,$40,$40,$40,$40,$40,$60,$40,$40,$40,$60,$40,$40,$40,$58,$40
  .byt $7e,$40,$7f,$40,$78,$40,$4e,$40,$5c,$40,$58,$40,$60,$40,$78,$40
  .byt $78,$40,$60,$40,$50,$40,$40,$40,$40,$40,$40,$40,$60,$40,$4f,$40
  .byt $78,$78,$7e,$40,$4f,$40,$7f,$60,$7f,$60,$78,$40,$4f,$40,$78,$78
  .byt $78,$40,$48,$40,$78,$58,$7e,$40,$79,$4e,$78,$50,$4f,$40,$78,$40
  .byt $4f,$40,$78,$58,$7c,$40,$78,$40,$5e,$70,$48,$40,$48,$50,$79,$70
  .byt $5c,$40,$7f,$60,$60,$40,$44,$40,$50,$40,$40,$40,$40,$40,$40,$40
  .byt $76,$40,$78,$40,$78,$40,$76,$40,$78,$40,$44,$40,$48,$40,$63,$40
  .byt $70,$40,$48,$40,$66,$40,$70,$40,$64,$70,$63,$40,$78,$40,$5c,$40
  .byt $74,$40,$60,$40,$78,$40,$70,$40,$73,$40,$5c,$40,$5d,$60,$66,$40
  .byt $7a,$40,$7e,$40,$60,$40,$60,$40,$50,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$4c,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$70,$40,$40,$40,$70,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$44,$40,$54,$40,$40,$40,$40,$40
  .byt $48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$50,$40,$44,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$42,$40
  .byt $40,$40,$70,$40,$40,$40,$70,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$50,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$53,$48,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$7f,$60,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$48,$40,$62,$40,$40,$40,$40,$40,$50,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$40,$48,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$44,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$60,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$50,$78,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$48,$40,$62,$40,$40,$40,$40,$40,$50,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$60,$40,$48,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$64,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$70,$40,$7c,$40,$40,$40,$40,$40,$60,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$60,$40,$48,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40,$40,$40,$40,$40,$78,$40,$40,$40,$40,$40,$40,$40
  .byt $40,$40,$40,$40
_Font12x14End


; Width (in pixels) of each of the 95 characters in the 12x14 font
_gFont12x14Width
 .dsb 95

; Contains all the combinations of 6 pixels patterns shifted by 0 to 5 pixels to the right.
; Each entry requires two bytes, and each need to be merged to the target buffer to rebuild
; the complete shifted graphics
_gShiftBuffer
  .dsb 64*2*6           ; 768 bytes

; Contains all the combination of X*40 to access specific scanlines
_gTableMulBy40Low     .dsb 128
_gTableMulBy40High    .dsb 128


    .bss

* = $C000

_ImageBuffer    .dsb 40*200


