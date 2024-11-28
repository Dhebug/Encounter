#include "params.h"

    .zero

_gCurrentLocation           .dsb 1
_gCurrentLocationPtr        .dsb 2
_gDescription               .dsb 2
_gSceneImage                .dsb 1
_gCurrentItemCount          .dsb 1
_gInventoryOffset           .dsb 2

_gActionMappingPtr          .dsb 2

    .text


IrqTasksHighSpeed
.(
    jmp SoundUpdateHighSpeed
.)

IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard

    ; Call the music player
    jsr _PlayMusicFrame

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





; MARK:Print Directions
_PrintSceneDirections
.(
    ldy #1                  ; Used to shift the bitmask
    sty tmp0
    dey                     ; 0
    sty _gFlagDirections    ; gFlagDirections = 0;
loop    
    lda (_gCurrentLocationPtr),y
    cmp #e_LOC_NONE         ; if (directions[direction]!=e_LOC_NONE)
    beq skip
    lda _gFlagDirections    ; gFlagDirections|= (1<<direction);
    ora tmp0
    sta _gFlagDirections
skip    
    asl tmp0
    iny
    cpy #e_DIRECTION_COUNT_
    bne loop
    rts
.)



_InputArrows
.(
    lda _gInputBufferPos
    beq buffer_empty
    ; Buffer is not empty, not acceptable, report an error and go back to the user
    ldx #<_ErrorPlop
    ldy #>_ErrorPlop
    jmp _PlaySoundAsmXY

buffer_empty
    lda #1
    sta _gWordCount

    ldy _gInputKey

    ldx #e_WORD_WEST
    cpy #KEY_LEFT
    beq store_direction

    ldx #e_WORD_EAST
    cpy #KEY_RIGHT
    beq store_direction

    lda _KeyBank+2
    and #16
    bne control_pressed
no_control
    ldx #0
    lda _KeyBank+4          ; Left shift
    ora _KeyBank+7          ; Right shift 
    and #16                 ; The two shift keys are on the same column
    bne shift_pressed

    ldx #e_WORD_NORTH
    cpy #KEY_UP
    beq store_direction

    ldx #e_WORD_SOUTH
    cpy #KEY_DOWN
    beq store_direction

control_pressed
    ldx #e_WORD_UP
    cpy #KEY_UP
    beq store_direction

    ldx #e_WORD_DOWN
    cpy #KEY_DOWN
    beq store_direction

; gInventoryOffset-=40
shift_pressed
;    jsr _Panic
    ldx #e_WORD_UP
    cpy #KEY_UP
    beq not_scroll_up
    sec
    lda _gInventoryOffset+0
    sbc #40
    sta _gInventoryOffset+0
    lda _gInventoryOffset+1
    sbc #0
    sta _gInventoryOffset+1
    jmp _PrintSceneObjects
not_scroll_up
    ldx #e_WORD_DOWN
    cpy #KEY_DOWN
    beq not_scroll_down
    clc
    lda _gInventoryOffset+0
    adc #40
    sta _gInventoryOffset+0
    lda _gInventoryOffset+1
    adc #0
    sta _gInventoryOffset+1
    jmp _PrintSceneObjects
not_scroll_down
    rts

store_direction
    stx _gWordBuffer

    ; Try to find the keyword in the table
    lda #<_gWordsArray
    sta tmp0+0
    lda #>_gWordsArray
    sta tmp0+1
loop_search_keyword
    ldy #2
    lda (tmp0),y
    cmp #e_WORD_COUNT_
    beq reset_input               ; Not supposed to happen if the code above is correct.
    cmp _gWordBuffer
    beq found_it
    ; Next keyword
    clc
    lda tmp0+0
    adc #3
    sta tmp0+0
    lda tmp0+1
    adc #0
    sta tmp0+1
    bne loop_search_keyword

found_it
    ; Get the pointer to the word
    ldy #0
    lda (tmp0),y
    sta tmp1+0
    iny
    lda (tmp0),y
    sta tmp1+1

    ; Print it in the player command field to simulate they typed it in
    clc
    lda _gStatusMessageLocation+0
    adc #40+1+2
    sta tmp2+0
    lda _gStatusMessageLocation+1
    adc #0
    sta tmp2+1

    ; sprintf(gStatusMessageLocation+40+1,"%c>%s%c ",2,gInputBuffer, ((VblCounter&32)||(gInputKey==KEY_RETURN))?32:32|128);
    ldy #0
print_word_loop
    lda (tmp1),y
    beq done_printing
    sta (tmp2),y
    iny
    bne print_word_loop
done_printing

    ; Wait half a second
    jsr _ShortWait

    ; Run the actual command
    lda _gAnswerProcessingCallback+0
    sta callback+0
    lda _gAnswerProcessingCallback+1
    sta callback+1

callback = *+1
    jsr $1234
reset_input    
    jsr _ResetInput

    lda #1
    sta _gAskQuestion
    rts
.)



; extern action_mapping gActionMappingsArray[];
/*
typedef struct
{
    unsigned char id;				// The id of the instruction (ex: e_WORD_TAKE)
    unsigned char flag;             // See: FLAG_MAPPING_DEFAULT, FLAG_MAPPING_STREAM, FLAG_MAPPING_TWO_ITEMS in scripting.h
    union 
    {
        callback function;          // Pointer to the routine to call (ex: TakeItem())
        void* stream;               // Pointer to a stream
    } u;
} action_mapping;
    WORD_MAPPING(e_WORD_COMBINE   ,_gCombineItemMappingsArray ,FLAG_MAPPING_STREAM|FLAG_MAPPING_TWO_ITEMS)
    WORD_MAPPING(e_WORD_READ      ,_gReadItemMappingsArray    ,FLAG_MAPPING_STREAM)

*/
_ValidateInputSpace
.(
    lda _gInputKey
    cmp #32+1                     ; Is it a displayable character?
    bcc check_input

good_input     
    ldx #1   
    rts

; gWordBuffer[gWordCount] = itemId;
+_ValidateInputReturn
check_input
    jsr _ParseInputBuffer
    ldx _gWordCount
    cpx #1
    beq one_word 
    cpx #2
    beq two_words    
    cpx #3
    beq three_words
    bne bad_input

three_words
    lda _gInputKey
    cmp #32
    beq bad_input       ; It's fine to have three words in the buffer, but not to add a fourth one
    lda _gWordBuffer+2
    cmp #e_WORD_COUNT_
    beq bad_input

two_words
    lda _gWordBuffer+1
    cmp #e_WORD_COUNT_
    beq bad_input

one_word
    lda _gWordBuffer+0
    cmp #e_WORD_COUNT_
    beq bad_input
    jmp good_input

bad_input
    ldx #0           ; Refuse the input
    rts
 .)


// Fill param0.ptr=first;param1.ptr=second; first, returns in X
_KeywordCompare
.(
    ldy #0
loop_character  
    ; Read first character
    lda (_param0),y
    jsr ConvertChar
    sta _param2+0

    ; Read second character
    lda (_param1),y
    jsr ConvertChar
    sta _param2+1

    ; Are they the same?
    cmp _param2+0
    bne no_match         ; Nope, different characters

    lda _param2+0
    beq matches          ; Null terminator -> gone

    iny                  ; Next character
    jmp loop_character


end_first_string

matches
    lda #0
    ldx #1
    rts

no_match
    lda #0
    ldx #0           ; Refuse the input
    rts
.)



// A=input char
// X=result
ConvertChar
.(
    ; We replace spaces by zeroes to stop the scan (our keywords are insecable)
    cmp #" "
    bne not_space
    lda #0
    rts
not_space    

    ; We convert all characters to the same case (does not matter if it's upper or lower case as long a it's the same)
    cmp #"A"
    bcc not_shifted_letter
    cmp #"Z"+1
    bcs not_shifted_letter
letter_a_z
    ora #32            ; Make the character lower case
    rts                ; And return
not_shifted_letter

#ifdef LANGUAGE_FR
#pragma osdk replace_characters : é:{ è:} ê:| à:@ î:i ô:^
    cmp #"é"
    beq change_to_e
    cmp #"è"
    beq change_to_e
    cmp #"ê"
    bne not_e
change_to_e    
    lda #"e"
    rts
not_e

    cmp #"à"
    bne not_a
change_to_a    
    lda #"a"
    rts
not_a

#endif
    rts
.)



; Input: _gWordBuffer[0]
; Output: _gActionMappingPtr points to the right entry and return 1, else returns 0
_FindActionMapping
.(
    ; Start of action table
    lda #<_gActionMappingsArray
    sta _gActionMappingPtr+0
    lda #>_gActionMappingsArray
    sta _gActionMappingPtr+1

search_loop
    ldy #0
    lda (_gActionMappingPtr),y       ; Load the word id from the table entry
    cmp _gWordBuffer+0               ; Compare with the first keyword
    beq found

    clc
    lda _gActionMappingPtr+0
    adc #4
    sta _gActionMappingPtr+0
    lda _gActionMappingPtr+1
    adc #0
    sta _gActionMappingPtr+1
    jmp search_loop

not_found
    lda #0
    ldx #0
    rts

found
    lda #0
    ldx #1
    rts
.)




; memset((char*)TemporaryBuffer479,' ',40*4);  = 160
; memset((char*)TemporaryBuffer479,' ',40*10); = 400
_ClearTemporaryBuffer479
.(
    MEMSET_JMP(_MemSetTemporaryBuffer479)
.)

_BlittTemporaryBuffer479
.(
    MEMCPY_JMP(_MemCpy__BlittTemporaryBuffer479)
.)


_EndGameUtils_
