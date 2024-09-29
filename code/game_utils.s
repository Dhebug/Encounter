
    .zero

_gCurrentLocation           .dsb 1
_gCurrentLocationPtr        .dsb 2
_gDescription               .dsb 2
_gSceneImage                .dsb 1

    .text


IrqTasksHighSpeed
.(
    jmp SoundUpdateHighSpeed
.)

IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard

    ; Update the sound engine
    jsr SoundUpdate50hz
            
    ; "Realtime" Clock
    .(
    dec _TimeMilliseconds
    bne skip_count_down

    lda #50
    sta _TimeMilliseconds

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

_gFlagDirections  .byt 0    ; Bit flag containing all the possible directions for the current scene (used to draw the arrows on the scene)

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
  lda _BlitDataTable+0,x   ; Blit mode (AND/ORA)
  beq end_draw_arrow
  sta BlitOperation

  lsr _gFlagDirections
  bcc skip_draw

  lda _BlitDataTable+1,x   ; Source graphics
  sta tmp0+0
  lda _BlitDataTable+2,x
  sta tmp0+1

  lda _BlitDataTable+3,x   ; Destination
  sta tmp1+0
  lda _BlitDataTable+4,x
  sta tmp1+1

  lda _BlitDataTable+5,x   ; Dimensions
  sta width
  lda _BlitDataTable+6,x
  sta height
  
  txa                     ; I wish we had phx/plx on the base 6502
  pha 
  jsr _BlitBloc
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



#define BLIT_AND $31    
#define BLIT_OR  $11

#define BLIT_INFO(opcode,source,destination,width,height)  .byt opcode,<source,>source,<destination,>destination,width,height

_BlitDataTable
  ; ArrowBlockMasks -> 102,111 -> 17,111
  ; The block itself is 32x18 pixels (6 bytes wide)
  ; The top 18 pixels is the AND mask, the bottom 18 pixels are the OR mask
  BLIT_INFO(BLIT_AND  ,_ArrowBlockMasks+0    ,_ImageBuffer+17+40*110,6, 26)       // Arrow block (AND masked)
  BLIT_INFO(BLIT_OR   ,_ArrowBlockMasks+6*26 ,_ImageBuffer+17+40*110,6, 26)       // Arrow block (OR masked)
  ; The four directional arrows
  BLIT_INFO(BLIT_OR   ,ArrowTop    ,_ImageBuffer+19+40*112,2, 6)                 // North Arrow
  BLIT_INFO(BLIT_OR   ,ArrowBottom ,_ImageBuffer+19+40*120,2,13)                 // South Arrow
  BLIT_INFO(BLIT_OR   ,ArrowRight  ,_ImageBuffer+20+40*116,3, 9)                 // East Arrow
  BLIT_INFO(BLIT_OR   ,ArrowLeft   ,_ImageBuffer+17+40*116,3, 9)                 // West Arrow
  ; Should have two more entries for UP and DOWN there
  BLIT_INFO(BLIT_OR   ,ArrowUp     ,_ImageBuffer+20+40*129,2, 7)                 // Up Arrow
  BLIT_INFO(BLIT_OR   ,ArrowDown   ,_ImageBuffer+18+40*129,2, 7)                 // Down Arrow
  .byt 0


_BlitBloc
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
_ArrowBlockMasks  
#include "..\build\files\masks_arrow_block.s"

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

