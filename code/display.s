
#include "params.h"

  .zero

width   .dsb 1
height  .dsb 1    

prev_char     = reg1
cur_char      = reg2
kerning       = reg3

    .text

_gFlagCurrentSpriteSheet  .byt 255  ; Index of the currently loaded "sprite" image
_gFlagCurrentMusicFile    .byt 255  ; Index of the currently loaded Arkos music file

_gDrawPatternAddress .word 0
_gDrawSourceAddress  .word 0
_gDrawAddress        .word 0
_gDrawExtraData      .word 0

_gDrawPosX      .byt 0
_gDrawPosY      .byt 0
_gDrawWidth     .byt 0
_gDrawHeight    .byt 0
_gDrawPattern   .byt 0
_gSourceStride  .byt 0




.(
sourcePtr   = tmp0
targetPtr   = tmp1
saveY       = tmp2

+_BlitSprite

  lda _gDrawSourceAddress+0
  sta sourcePtr+0
  lda _gDrawSourceAddress+1
  sta sourcePtr+1

  lda _gDrawAddress+0
  sta targetPtr+0
  lda _gDrawAddress+1
  sta targetPtr+1

  ldx _gDrawHeight
loop_y
  stx saveY

  ldy _gDrawWidth
  dey
loop_x
  lda (sourcePtr),y        ; Read the source byte
  
  rol
  rol
  rol
  and #3                   ; The two top bits are used as an index in the mask table
  tax
  ;ldx #3

  lda (targetPtr),y        ; Read the target
  and _TableMask,x         ; Mask out what we don't want based on the table
  ora (sourcePtr),y        ; Merge-in the source content
  
  and #63+64
  ;ora #64
  sta (targetPtr),y        ; Write back to the target
  dey
  bpl loop_x

  ; Next scanlines on the source
  .(
  clc
  lda sourcePtr+0
  adc _gSourceStride
  sta sourcePtr+0
  bcc skip
  inc sourcePtr+1
skip  
  .)

  ; Next scanlines on the target
  .(
  clc
  lda targetPtr+0
  adc #40
  sta targetPtr+0
  bcc skip
  inc targetPtr+1
skip  
  .)

  ldx saveY
  dex
  bne loop_y

  rts
.)


_TableMask
  .byt %11000000            ; 00...... Completely erase the background
  .byt %11000111            ; 01......
  .byt %11111000            ; 10......
  .byt %11111111            ; 11...... Keep the background unmodified


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

  ; Reset the kerning
  lda #0
  sta cur_char

loop_character
  ; The kerning works with pairs of characters, so we need to keep track of the previous and next character
  lda cur_char
  sta prev_char

  ; Fetch the next character from the string
  ; 0    -> End of string
  ; 13   -> Carriage return (used to handle multi-line strings) followed by a scanline count
  ; <0   -> Horizontal offset to simulate kerning tables
  ; >=32 -> Normal ASCII characters in the 32-127 range
  ldy #0
  lda (messagePtr),y
  sta cur_char          ; -- test
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

  ; prev_char + cur_char -> kerning
  jsr _GetKerningValue
   
  ; Using the current x coordinate in the scanline, we compute the actual position on the screen where to start drawing the character
  lda x_position 
  sec
  sbc kerning           ; Subract the kerning value to group together closer some combinations of letters
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


  ; Search in the kerning table for a matching prev/cur combination of characters
  ; We could store somewhere in the font (size table?) if it's even worth looking at all to avoid the lookup for some letters
_GetKerningValue  
  .(
  lda #0
  sta kerning           ; By default, no kerning adjustment to apply
  tax                   ; x=0
  lda prev_char
  beq end_kerning       ; No kerning to solve for the very first character
loop_kerning
  lda _gFont12x14Kerning+0,x     
  beq end_kerning
  cmp prev_char                   ; Check the first character
  bne next_pair
  lda cur_char
  cmp _gFont12x14Kerning+1,x      ; Check the second character
  bne next_pair

  lda _gFont12x14Kerning+2,x      ; Store the associated kerning value
  sta kerning
  rts

next_pair  
  inx
  inx
  inx
  bne loop_kerning
end_kerning  
  rts
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
  sta $bfdf-255,x
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
  ldx #20
loop_bottom
  lda #%01111111
  sta _ImageBuffer+40*126-1,x
  sta _ImageBuffer+40*126-1+40-20,x

  lda #%01000000
  sta _ImageBuffer+40*125-1,x
  sta _ImageBuffer+40*127-1,x

  sta _ImageBuffer+40*125-1+40-20,x
  sta _ImageBuffer+40*127-1+40-20,x

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


; A000-B3FF 5120 bytes of half HIRES (240x128 resolution)
; Exactly 20*256
_BlitBufferToHiresWindow
.(
  jsr _AddFancyImageFrame
  jsr _DrawArrows

  lda #26
  sta _ImageBuffer+40*128   ; Force back to TEXT

#ifdef DISABLE_FADES
  jsr _BlitBufferToHiresWindowInternal
#else
  jsr _CrossFadeBufferToHiresWindow
#endif
  rts
.)


_CrossFadeBufferToHiresWindow
.(
  lda #<_6x6DitherMatrix+6*2
  sta _gDrawPatternAddress+0
  lda #>_6x6DitherMatrix+6*2
  sta _gDrawPatternAddress+1

  ldx #1
loop
  txa
  pha 

  jsr _BlendBufferToHiresWindowInternal
  sei
  ; Dom thought 6 seconds was too short, he lost when he was busy with the clay and the water
  ;jsr Count10SecondsDown                    ; With 10 seconds decrements, impossible to possibly win the game at all
  jsr Count1SecondsDown                      ; Let's try with 1 second instead: Playtrough duration: 1:30:30 remaining with 1 second per fade
  jsr Count1SecondsDown
  jsr Count1SecondsDown
  jsr Count1SecondsDown                      ; Let's try with 4 seconds: Playtrough duration: 1:04:50
  ;jsr Count1SecondsDown
  ;jsr Count1SecondsDown                      ; Let's try with 6 seconds: Playtrough duration: 0:37:34
  cli

  .(  
  clc 
  lda _gDrawPatternAddress+0
  adc #6*2
  sta _gDrawPatternAddress+0
  bcc skip
  inc _gDrawPatternAddress+1
skip  
  .)

  pla
  tax
  inx
  inx
  cpx #13
  bne loop
  rts
.)


_BlendBufferToHiresWindowInternal
.(
  ; Initialize the source position
  lda #<_ImageBuffer+0
  sta auto_source_ptr__+1
  lda #>_ImageBuffer+0
  sta auto_source_ptr__+2

  ; Initialize the target position
  lda #<$A000+0
  sta auto_screen_ptr1__+1
  sta auto_screen_ptr2__+1
  sta auto_screen_ptr3__+1
  lda #>$A000+0
  sta auto_screen_ptr1__+2
  sta auto_screen_ptr2__+2
  sta auto_screen_ptr3__+2

  ; Set the pattern pointer
  lda _gDrawPatternAddress+0
  sta auto_pattern_table__+1
  lda _gDrawPatternAddress+1
  sta auto_pattern_table__+2

  ldx #0
loop_next_line

  ; Selecting the proper dithering pattern based on the vertical position
  lda _gTableModulo6,x    ; Value between 0 and 5
  tay
auto_pattern_table__  
  lda $1234,y               ; Get the pattern
  sta auto_and_pattern__+1  ; Save the source image pattern (inverted)

  ; while (--byteCount)  *drawPtr++ = gDrawPattern; 
  ldy #39
repeat_loop  

  ; First unroll
auto_screen_ptr1__  
  lda $a000,y          ; 4 - Read the graphics
auto_source_ptr__  
  eor _ImageBuffer,y   ; 4 - Read source graphics
auto_and_pattern__  
  and #%01010101       ; 2 - Mask out the bits we don't want
auto_screen_ptr2__  
  eor $a000,y          ; 4 - Write back to screen
auto_screen_ptr3__  
  sta $a000,y          ; 5 - Write back to screen
  dey                  ; 2  = 21 cycles per byte (40*128*21 = 107520)

  bpl repeat_loop

  ; Point both the source and target pointers to the next scanline.
  ; Both buffers are aligned on the same page, so no need to increment them separately
  .(
  clc
  lda auto_source_ptr__+1
  adc #40
  sta auto_source_ptr__+1
  sta auto_screen_ptr1__+1
  sta auto_screen_ptr2__+1
  sta auto_screen_ptr3__+1
  bcc skip 
  inc auto_source_ptr__+2    ; 6
  inc auto_screen_ptr1__+2   ; 6
  inc auto_screen_ptr2__+2   ; 6
  inc auto_screen_ptr3__+2   ; 6 -> 24
skip  
  .)

  inx
  cpx #128
  bne loop_next_line
end
  rts
.)



_BlitBufferToHiresWindowInternal
.(
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
  rts
.)



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
 .byt %011100
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

	//
	// Generate multiple of 6 data table
	//
.(
	ldx #0
	stx tmp0+1	// cur div
	stx tmp0+2	// cur mod
loop6
	lda tmp0+1
	sta _gTableDivBy6,x

	lda tmp0+2
	sta _gTableModulo6,x

	ldy tmp0+2
	iny
	cpy #6
	bne skip_mod
	ldy #0
	inc tmp0+1
skip_mod
	sty tmp0+2

	inx
	bne loop6
.)
  rts
.)


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

; Kerning table: Pairs of characters associated with a value subtracted to the x position of the second character
_gFont12x14Kerning
  .byt "ff",2
  .byt "fi",1
  .byt "fa",2
  .byt "fe",2
  .byt "fo",2
  .byt "ij",2
  .byt "ig",1
  .byt "Ja",2
  .byt "op",1
  .byt "Of",1
  .byt "ra",1
  .byt "rd",1
  .byt "re",1
  .byt "rk",1
  .byt "ro",1
  .byt "rp",1
  .byt "if",1
  .byt "da",1
  .byt "ta",1
  .byt "te",1
  .byt "th",1
  .byt "to",1
  .byt "Th",1
  .byt "Te",2
  .byt "To",2
  .byt "Us",1
  .byt "'e",2
#ifdef LANGUAGE_FR    
#pragma osdk replace_characters : é:{ è:} ê:| à:@ î:i ô:^
  .byt "là",2
  .byt "tô",1
  .byt "tè",1
#else
#endif
  .byt 0           ; End of table


; 16 block of 6x6 pixels arranged vertically, 6x96 pixels bitmap
; 13 values on the top for ordered dither
;  3 values at the end with some growing circle
_6x6DitherMatrix
#include "..\build\files\pattern_6x6_dither_matrix.s"
