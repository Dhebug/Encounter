#include "params.h"
#include "game_enums.h"

    .zero

_gCurrentLocation           .dsb 1
_gCurrentLocationPtr        .dsb 2
_gSceneImage                .dsb 1
_gCurrentItemCount          .dsb 1
_gInventoryOffset           .dsb 1
_gInventoryMaxOffset        .dsb 1

_gActionMappingPtr          .dsb 2
_gScreenPtr                 .dsb 2       ; Used ty the routines that prints inventory, items, etc...
buffer_position             .dsb 1
_gKeywordString             .dsb 2       ; Initialized by FindKeyword

_gKeywordMenuEntries        .dsb 2
_gKeywordMenuEntryCount     .dsb 1
_gKeywordMenuSelected       .dsb 1
_gShouldCleanWindow         .dsb 1
_gActionMenuCount           .dsb 1
_gMaxWordIndex              .dsb 1

    .text

;
; Print the list of selectable options.
; The display is done over 4 lines and multiple columns.
;
; In order to accomodate the variable number of items the width of columns must change:
; 8 items or less  -> 18 characters (18*2 = 36)
; 12 items or less -> 12 characters (12*3 = 36)
; 16 items or less ->  9 characters ( 9*4 = 36)
; 20 items or less ->  7 characters ( 7*5 = 35)
; 24 items or less ->  6 characters ( 6*6 = 36)
;
_RefreshActionMenu
.(
    ; Make sure we don't have overflow
    lda _gKeywordMenuSelected
    cmp _gKeywordMenuEntryCount
    bcc end_selection_overflow
    lda #0
    sta _gKeywordMenuSelected
end_selection_overflow    

    ; No valid item selected
    lda #e_WORD_COUNT_
    sta auto_result

    ; Screen pointer
    lda #<$bb80+40*18
    sta _gScreenPtr+0
    lda #>$bb80+40*18
    sta _gScreenPtr+1

    LDA _gKeywordMenuEntryCount
    CMP #8+1                     ; Up to 8 items (2 columns)
    BCC SetWidth18
    CMP #12+1                    ; Up to 12 items (3 columns)
    BCC SetWidth12
    CMP #16+1                    ; Up to 16 items (4 columns)
    BCC SetWidth9
    CMP #20+1                    ; Up to 20 items (5 columns)
    BCC SetWidth7
    LDA #40*4-6                  ; Default case (6 columns)
    bne StoreWidth

SetWidth18:
    LDA #40*4-18                 ; Load 18 (2 bytes)
    BNE StoreWidth               ; Jump to store (always taken, 2 bytes)
SetWidth12:
    LDA #40*4-12                 ; Load 12 (2 bytes)
    BNE StoreWidth               ; Jump to store (always taken, 2 bytes)
SetWidth9:
    LDA #40*4-9                  ; Load 9 (2 bytes)
    BNE StoreWidth               ; Jump to store (always taken, 2 bytes)
SetWidth7:
    LDA #40*4-7                  ; Load 7 (2 bytes)
    BNE StoreWidth               ; Jump to store (always taken, 2 bytes)

StoreWidth:
    STA width_patch            ; Store result in _gColumnWidth (1 byte)

    ; Item drawing loop
    ldy #0
loop_item_entry
    cpy _gKeywordMenuEntryCount
    bcs end_item_loop
    tya
    pha

    lda (_gKeywordMenuEntries),y
    sta _param0

    cpy _gKeywordMenuSelected
    bne no_selected
selected
    sta auto_result              ; Store the currently selected keyword
    lda #2                       ; Green text
    bne set_color
no_selected
    lda #7                       ; White text
set_color    
    ldy #1
    sta (_gScreenPtr),y          ; Write the color to the screen

    ; PrintStringAt(gKeywordString,scanline+2);  
    jsr _GetKeywordString       ; Input in _param0, Result in gKeywordString

    lda _gKeywordString+0       ; Message pointer
    sta _param0+0
    lda _gKeywordString+1
    sta _param0+1

    clc                         ; Screen pointer
    lda _gScreenPtr+0
    adc #2
    sta _gPrintAddress+0
    lda _gScreenPtr+1
    adc #0
    sta _gPrintAddress+1

    ; Enable truncation
    lda #1
    sta _gPrintQuitIfSpace

    lda #0                      ; Position
    sta _gPrintPos
    jsr _PrintStringInternal


    ; Increment the screen pointer to the next line
    clc
    lda _gScreenPtr+0 
    adc #40
    sta _gScreenPtr+0
    lda _gScreenPtr+1
    adc #0
    sta _gScreenPtr+1

    pla
    tay
    iny
    ;tya

    and #3
    cmp #3
    bne loop_item_entry    

    ; Increment the screen pointer to the next column
    sec
    lda _gScreenPtr+0 
width_patch = *+1    
    sbc #40*4-12          ; Width
    sta _gScreenPtr+0
    lda _gScreenPtr+1
    sbc #0
    sta _gScreenPtr+1

    bne loop_item_entry    

end_item_loop
    
    ; Return the keyword id
    lda #0
auto_result = *+1    
    ldx #e_WORD_COUNT_
    rts
.)



// MARK:IRQ 50hz
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


_gFlagDirections  .byt 0    ; Bit flag containing all the possible directions for the current scene (used to draw the arrows on the scene)

// MARK:Draw Arrows
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


// MARK:Blit Bloc
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
 .byt %000000,%001111
 .byt %000000,%000111
 .byt %000000,%001111
 .byt %000000,%011101
 .byt %000000,%111000
 .byt %000001,%110000
 .byt %000001,%100000

ArrowDown ; Patch at 18,129
 .byt %011000,%000000
 .byt %011100,%000000
 .byt %001110,%000000
 .byt %000111,%010000
 .byt %000011,%110000
 .byt %000001,%110000
 .byt %000011,%110000





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



// MARK:Input Arrows
_InputArrows
.(
    ; Check if we're in container request mode
    lda _gContainerRequestMode
    beq normal_mode

    ; Container request mode: handle ESC and arrow keys specially
    lda _gInputKey
    cmp #KEY_ESC
    beq container_esc_pressed
    ; For arrow keys, just ignore them (return immediately)
    rts

container_esc_pressed
    ; ESC pressed during container request: abort silently
    ; Set the answer to e_WORD_SKIP (same as menu cancel) and exit
    lda #e_WORD_SKIP
    sta _gWordBuffer+0
    lda #1
    sta _gWordCount
    lda #1
    sta _gInputDone
    rts

normal_mode
    lda _gInputBufferPos
    beq buffer_empty
    ; Buffer is not empty, not acceptable, report an error and go back to the user
    jmp _PlayErrorSound

buffer_empty
    lda #1
    sta _gWordCount

    ; Diagonal checks:
    ; If any of the four directions or space/fire are pressed, 
    ; then we wait to see if some of the other inputs are triggered.
    lda _KeyBank+4
    and #MATRIX_KEY_UP+MATRIX_KEY_LEFT+MATRIX_KEY_DOWN+MATRIX_KEY_RIGHT+MATRIX_KEY_SPACE
    beq end_diagonal_check

    ; 7 IRQ is 7/50th of a second
    ldx #7
loop_check_irq
    ldy _KeyBank+4
    tya
    and #MATRIX_KEY_UP
    beq not_up
    tya
    and #MATRIX_KEY_LEFT+MATRIX_KEY_RIGHT+MATRIX_KEY_SPACE
    beq not_up 
    ldx #e_WORD_UP             ; The player wants to go UP
    jmp store_keyword

not_up
    tya
    and #MATRIX_KEY_DOWN
    beq not_down
    tya
    and #MATRIX_KEY_LEFT+MATRIX_KEY_RIGHT+MATRIX_KEY_SPACE
    beq not_down 
    ldx #e_WORD_DOWN          ; The player wants to go DOWN
    jmp store_keyword
    
not_down
    jsr _WaitIRQ
    dex
    bne loop_check_irq    

end_diagonal_check

    ldy _gInputKey

    ldx #e_WORD_HELP
    cpy #KEY_ESC
    beq store_keyword

    ldx #e_WORD_WEST
    cpy #KEY_LEFT
    beq store_keyword

    ldx #e_WORD_EAST
    cpy #KEY_RIGHT
    beq store_keyword

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
    beq store_keyword

    ldx #e_WORD_SOUTH
    cpy #KEY_DOWN
    beq store_keyword

control_pressed
    ldx #e_WORD_UP
    cpy #KEY_UP
    beq store_keyword

    ldx #e_WORD_DOWN
    cpy #KEY_DOWN
    beq store_keyword

; gInventoryOffset-=40
shift_pressed
;    jsr _Panic
    ldx #e_WORD_UP
    cpy #KEY_UP
    beq not_scroll_up   
    dec _gInventoryOffset
    jmp _PrintSceneObjects
not_scroll_up
    ldx #e_WORD_DOWN
    cpy #KEY_DOWN
    beq not_scroll_down
    inc _gInventoryOffset
    jmp _PrintSceneObjects
not_scroll_down
    rts

store_keyword
    stx _gWordBuffer
    lda #e_WORD_COUNT_           ; Sentinelle word to avoid printing out of the buffer
    sta _gWordBuffer+1
    jsr _PrintKeywordBuffer

    ; Wait half a second
    jsr _ShortWait

+_RunWordBufferCommand
    ; Run the actual command
    lda _gAnswerProcessingCallback+0
    sta callback+0
    lda _gAnswerProcessingCallback+1
    sta callback+1

callback = *+1
    jsr $1234
+reset_input    
    jsr _ResetInput

    lda #e_WORD_SKIP              ; To avoid duplicate execution when pressing enter - good_input
    sta _gWordBuffer+0            

    lda #1
    sta _gAskQuestion
    rts
.)



#ifdef LANGUAGE_FR    
_CancelText .byt "-ANNULE-",0
#else
_CancelText .byt "-CANCEL-",0
#endif


; param0 = input keyword
; Result string in _gKeywordString+0/1
_GetKeywordString
.(
    lda _param0
    cmp #e_WORD_COUNT_
    bne valid_keyword

invalid_keyword
    lda #<_CancelText
    sta _gKeywordString+0
    lda #>_CancelText
    sta _gKeywordString+1
    rts

valid_keyword    
    cmp #128
    bcs find_verb

    ldx #0
    jsr _ByteStreamComputeItemPtrIndexX

    ; Get the pointer to the word
    ldy #0
    lda (_gStreamItemPtr),y
    sta _gKeywordString+0
    iny
    lda (_gStreamItemPtr),y
    sta _gKeywordString+1

    ldy #0
search_underscore    
    lda (_gKeywordString),y
    beq found_zero
    cmp #"_"
    beq found
    iny
    bne search_underscore
found
    clc
    iny
    tya
    adc _gKeywordString+0
    sta _gKeywordString+0
    lda #0
    adc _gKeywordString+1
    sta _gKeywordString+1

found_zero
    rts

find_verb    
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
auto_keyword = *+1    
    cmp _param0                   ; Match with the token 
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
    sta _gKeywordString+0
    iny
    lda (tmp0),y
    sta _gKeywordString+1

    rts
.)


_PrintKeywordBuffer
.(
    ; Initialize the start of the command field location 
    clc
    lda _gStatusMessageLocation+0
    adc #40+1
    sta tmp2+0
    lda _gStatusMessageLocation+1
    adc #0
    sta tmp2+1

    ; Force redraw the prompt in green
    ldy #0
    lda #2             ; Green
    sta (tmp2),y
    iny 
    lda #">"           ; Prompt
    sta (tmp2),y

    ; Increment the pointer to the start of the actual input
    clc
    lda tmp2+0
    adc #2
    sta tmp2+0
    lda tmp2+1
    adc #0
    sta tmp2+1

    ldy #0
    sty buffer_position

    ldx #0
word_loop    
    txa
    ldy _gWordBuffer,x
    cpy #e_WORD_COUNT_           ; Last keyword in the buffer?
    beq clear_line
    sty _param0
    pha
    jsr _GetKeywordString

    ; Print it in the player command field to simulate they typed it in
    ; sprintf(gStatusMessageLocation+40+1,"%c>%s%c ",2,gInputBuffer, ((VblCounter&32)||(gInputKey==KEY_RETURN))?32:32|128);
    ldy #0
print_word_loop
    lda (_gKeywordString),y
    beq done_printing
    cmp #" "
    beq done_printing
    sta (tmp2),y
    iny
    inc buffer_position
    bne print_word_loop
done_printing
    ; Print a space separator character
    lda #" "
    sta (tmp2),y
    iny
    inc buffer_position

    ; Increase buffer position based on the size of the keyword
    clc
    tya
    adc tmp2+0
    sta tmp2+0
    lda tmp2+1
    adc #0
    sta tmp2+1

    pla
    tax
    inx
    cpx #MAX_WORDS
    bne word_loop

    ; Complete the rest of the line with spaces to erase whatever content was there before
clear_line    
    lda #" "
    ldy #0
    ldx buffer_position
clear_line_loop    
    cpx #37
    bcs end_of_line
    sta (tmp2),y
    iny
    inx
    bne clear_line_loop

end_of_line
    rts
.)


// MARK:Validate Input
_ValidateInputSpace
.(
    lda _gInputKey
    cmp #KEY_SPACE+1                     ; Is it a displayable character?
    bcc check_input

good_input     
    ldx #1   
    rts

bad_input
    ldx #0           ; Refuse the input
    rts

; gWordBuffer[gWordCount] = itemId;
+_ValidateInputReturn
check_input
    jsr _ParseInputBuffer         ; Convert each of the words into a token id

    ; Validate that all the words are actually valid
    ldx _gWordCount
    beq show_action_menu          ; bad_input                 ; No keyword -> bad input (should use that to show the token selector menu)
loop_check_valid_word
    lda _gWordBuffer-1,x
    cmp #e_WORD_COUNT_
    beq bad_input
    dex
    bne loop_check_valid_word

    ; Then we check that the number of parameters matches the actual instruction    
    jsr _FindActionMapping        ; Need to get the mapping data to know how many keyword we can have

    ldy #1
    lda (_gActionMappingPtr),y    ; Load flag
    and #3                        ; Isolate the item count
    tax

    lda _gInputKey
    cmp #KEY_RETURN               ; For return we need the exact matching number of keywords
    beq check_return

    cmp #KEY_SPACE                ; For space we allow typing as lon as we are missing words
    beq check_space
    bne good_input

check_return
    inx                           ; Max total of keywords we can have
    cpx _gWordCount               ; Compare with the number of keywords entered
    beq good_input                ; Exact number of parameters = OK
    bne bad_input                 ; Different number of parameters = not good

check_space
    cpx _gWordCount               ; Compare with the number of keywords entered
    bcs good_input                ; Still some keywords to input = OK
    bcc bad_input                 ; X>=word count

show_action_menu
    jsr _PrintActionMenu
    jmp good_input
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


// MARK:Find Action
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
    cmp #e_WORD_COUNT_
    beq not_found
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


// MARK:Run Action
_RunAction
    ;jmp _RunAction
.(
    ; Start by loading the stream pointer since all the comands use that
    ldy #2
    lda (_gActionMappingPtr),y      ; Stream pointer (low)
    sta _param1+0
    iny
    lda (_gActionMappingPtr),y      ; Stream pointer (high)
    sta _param1+1

    ldy #1
    lda (_gActionMappingPtr),y            ; Load flag
    tax
    and #FLAG_MAPPING_STREAM              ; if (flags & FLAG_MAPPING_STREAM)
    beq play_native_code_callback

    txa
    and #FLAG_MAPPING_STREAM_CALLBACK     ; if (flags & FLAG_MAPPING_STREAM_CALLBACK)
    bne play_script_callback

    ; It's one of these case where we need one or two items
    lda _gWordBuffer+1                    ; First item
    cmp #e_ITEM_COUNT_                    ; if (itemId<e_ITEM_COUNT_)
    bcs error_unknown_item                ; No idea what this item is (possibly not possible anymore with the new parser)
    jsr _ByteStreamComputeItemPtr         ; Item ID in A result is _gStreamItemPtr (does not touch X or Y)

    ; Check where this first item is located
    ldy #2
    lda (_gStreamItemPtr),y               ; Item location
    cmp #e_LOC_INVENTORY
    beq first_item_available              ; We have it in our inventory
    cmp _gCurrentLocation
    bne error_item_not_present            ; It's not in the scene

first_item_available
    ; Clear the window
    lda #16+4
    sta _param0
    jsr _ClearMessageWindowAsm            ; Clear X

    ; Do we need a second item?
    ldy #1
    lda (_gActionMappingPtr),y            ; Load flag/item count
    and #3                                ; Mask out the item count
    cmp #2
    beq requires_two_items

requires_one_item
    ; Stupidly this command has the table as second parameter...
    lda _gWordBuffer+1                    ; Item id as the first parameter
    sta _param0+0
    jmp _DispatchStream

requires_two_items
    ; It's one of these case where we need one or two items
    lda _gWordBuffer+2                    ; Second item
    cmp #e_ITEM_COUNT_                    ; if (itemId<e_ITEM_COUNT_)
    bcs error_unknown_item                ; No idea what this item is (possibly not possible anymore with the new parser)
    jsr _ByteStreamComputeItemPtr         ; Item ID in A result is _gStreamItemPtr (does not touch X or Y)

    ; Check where this second item is located
    ldy #2
    lda (_gStreamItemPtr),y               ; Item location
    cmp #e_LOC_INVENTORY
    beq second_item_available              ; We have it in our inventory
    cmp _gCurrentLocation
    bne error_item_not_present            ; It's not in the scene

second_item_available
    ; That one takes three parameters: First item, Dispatcher table, Second item
    lda _gWordBuffer+1                    ; First Item id as the first parameter
    sta _param0+0
    lda _gWordBuffer+2                    ; Second Item id as the third parameter
    sta _param2+0
    jmp _DispatchStream2

play_script_callback
    lda _param1+0
    sta _gCurrentStream+0
    lda _param1+1
    sta _gCurrentStream+1
    jmp _PlayStreamAsm_gCurrentStream

play_native_code_callback
    ;gActionMappingPtr->u.function();
    jmp (_param1)

error_item_not_present
    lda #<_gTextErrorItemNotPresent
    sta _param0+0
    lda #>_gTextErrorItemNotPresent
    sta _param0+1
    jmp _PrintErrorMessageAsm

; possibly not possible anymore with the new parser
error_unknown_item
    lda #<_gTextErrorUnknownItem
    sta _param0+0
    lda #>_gTextErrorUnknownItem
    sta _param0+1
    jmp _PrintErrorMessageAsm

.)


// MARK:Process Container
_ProcessContainerAnswer
.(
    lda #0               ; Part of the 16 bit return code
    ldx _gWordCount
    beq not_found

    ldx _gWordBuffer     ; Return the first word
    rts

not_found
    ldx #e_ITEM_COUNT_   ; Triggers the "will not work" message, can be used to disengage the "in what" requester
    rts
.)


// MARK:Handle Highlight
_HandleKeywordHighlight
.(
    ; When the player presses SHIFT we redraw the item list with highlights
    lda _KeyBank+4
    and #16
    sta _ShouldShowKeyWords

    ; If there is an input error, and it's an actual item, we high-light the items
    lda _gInputErrorCounter
    beq end_input_error
    lda _gWordCount                    ; If we have more than one keyword, there's definitely a wrong item
    cmp #1
    bcs force_shift

    lda _gAnswerProcessingCallback+0   ; If we were asking for a container, that's also definitely a wrong item
    cmp #<_ProcessContainerAnswer
    bne end_input_error
    lda _gAnswerProcessingCallback+1
    cmp #>_ProcessContainerAnswer
    bne end_input_error

force_shift    
    lda #16
    sta _ShouldShowKeyWords
end_input_error

    ; We only redraw when the status change between highlighted and not highlighted
    lda _ShouldShowKeyWords
    cmp _ShowingKeyWords
    beq no_change

    sta _gShowHighlights
    sta _ShowingKeyWords
    jsr _PrintSceneObjects
    jsr _PrintInventory

no_change    
    rts
.)



// MARK:Print Objects
;
; This prints the entire list of all objects found in the current location,
; eventually handling vertical scrolling with clamping if the list does not fit the screen.
; (Scrolling is done by default using SHIFT+UP or DOWN)
;
_PrintSceneObjects
.(
    ; Clear the buffer (479/40=11.975 lines long)
    jsr _ClearTemporaryBuffer479

    ; Paint the background blue in the intermediate buffer since it's going to be copied to the screen later on
    lda #16+4
    sta _TemporaryBuffer479+40*0
    sta _TemporaryBuffer479+40*1
    sta _TemporaryBuffer479+40*2
    sta _TemporaryBuffer479+40*3
    sta _TemporaryBuffer479+40*4
    sta _TemporaryBuffer479+40*5
    sta _TemporaryBuffer479+40*6
    sta _TemporaryBuffer479+40*7
    sta _TemporaryBuffer479+40*8
    sta _TemporaryBuffer479+40*9

    lda #0
    sta _gPrintPos

    lda #<-3
    sta _gInventoryMaxOffset

    ; Check if ther are any items present at the current location
    ldx #0
loop_search    
    txa
    jsr _ByteStreamComputeItemPtr         ; Item ID in A result is _gStreamItemPtr (does not touch X or Y)

    ldy #2
    lda (_gStreamItemPtr),y               ; Item location
    cmp _gCurrentLocation
    beq found_items                       ; It's int the scene

    inx 
    cpx #e_ITEM_COUNT_
    bne loop_search                       ; Next item

no_items    
    ; PrintStringAt(gTextNothingHere,TemporaryBuffer479+1);  // "There is nothing of interest here"
    lda #<_TemporaryBuffer479+1
    sta _gPrintAddress+0
    lda #>_TemporaryBuffer479+1
    sta _gPrintAddress+1

    lda #<_gTextNothingHere
    ldx #>_gTextNothingHere
    jmp print_and_blit_description_buffer

found_items    
    ; gPrintWidth=38;
    lda #38
    sta _gPrintWidth

    ; PrintStringAt(gTextCanSee,TemporaryBuffer479+2);
    lda #<_TemporaryBuffer479+2
    sta _gPrintAddress+0
    lda #>_TemporaryBuffer479+2
    sta _gPrintAddress+1

    lda #<_gTextCanSee
    ldx #>_gTextCanSee
    jsr _PrintStringInternalAX

    lda #OPCODE_RTS
    sta _nop_or_rts

    ; for (item=0;item<e_ITEM_COUNT_;item++)
    ; Check if ther are any items present at the current location
    ldx #0
loop_print
    txa
    pha
    jsr _ByteStreamComputeItemPtr         ; Item ID in A result is _gStreamItemPtr (does not touch X or Y)

    ldy #2
    lda (_gStreamItemPtr),y               ; Item location
    cmp _gCurrentLocation
    bne next_item                         ; It's int the scene

    ; We only print the word separators if it's not the first word
    jsr _PrintSeparatorIfNeeded
    lda #OPCODE_NOP
    sta _nop_or_rts

    ; #define PrintString(message)               { param0.ptr=message;asm("jsr _PrintStringInternal"); } 
    ldy #1
    lda (_gStreamItemPtr),y               ; Item description
    tax
    dey
    lda (_gStreamItemPtr),y               ; Item description
    jsr _PrintStringAndMoveToNextLineIfNeeded

next_item
    pla
    tax
    inx 
    cpx #e_ITEM_COUNT_
    bne loop_print                       ; Next item
    
    ; Final dot?
    lda _gPrintPos
    cmp _gPrintWidth
    bcs no_dot
    lda #<_gTextDot
    ldx #>_gTextDot
print_and_blit_description_buffer
    jsr _PrintStringInternalAX
no_dot

    ; Make sure the scroll position of the scene object window is properly clamped    
    lda _gInventoryOffset
    cmp _gInventoryMaxOffset    ; Inventory Offset > Max Offset ?
    bvc no_overflow
    eor #$80                    ; Flip sign bit if overflow
 no_overflow
    bmi negative_clamp
    lda _gInventoryMaxOffset

negative_clamp
    cmp #0                      ; Inventory offset < 0 ?
    bpl done_clamping
    lda #0
done_clamping
    sta _gInventoryOffset

    ; Blitt the buffer to the screen
    lda #<_TemporaryBuffer479
    sta _MemCpy_BlittInventory+2
    lda #>_TemporaryBuffer479
    sta _MemCpy_BlittInventory+3

    ldx _gInventoryOffset
    beq end_add
loop_add
    clc
    lda _MemCpy_BlittInventory+2
    adc #40
    sta _MemCpy_BlittInventory+2
    lda _MemCpy_BlittInventory+3
    adc #0
    sta _MemCpy_BlittInventory+3

    dex 
    bne loop_add    

end_add
    MEMCPY_JMP(_MemCpy_BlittInventory)
.)



_PrintSeparatorIfNeeded
.(
+_nop_or_rts    
    rts
    ; Comma separator?
    lda _gPrintPos
    cmp _gPrintWidth
    bcs no_comma
    lda #<_gTextComma
    ldx #>_gTextComma
    jsr _PrintStringAndMoveToNextLineIfNeeded
no_comma

    ; Space separator?
    lda _gPrintPos
    cmp _gPrintWidth
    bcs no_space
    lda #<_gTextSpace
    ldx #>_gTextSpace
    jsr _PrintStringAndMoveToNextLineIfNeeded
no_space

    rts
.)

_PrintStringAndMoveToNextLineIfNeeded
    jsr _PrintStringInternalAX
_MoveToNextLineIfNeeded
.(
    lda _gPrintLineTruncated
    beq skip
    inc _gInventoryMaxOffset
skip
    rts
.)



_gTextComma         .byt ",",0
_gTextSpace         .byt " ",0
_gTextDot           .byt ".",0

_gColoredSeparator  .byt " ",0
_gColonSeparator    .byt ":",0

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


// MARK:Print Inventory
// The inventory display is done in two passes, using an intermediate buffer to limit flickering.
// The first pass displays all the non empty containers and their associated content
// The second pass displays the rest
// And finally the buffer is copied back to video memory.
_PrintInventory
.(
    lda #0
    sta _gCurrentItemCount

    jsr _ClearTemporaryBuffer479

    lda #38
    sta _gPrintWidth
    lda #1
    sta _gPrintRemovePrefix

    ;
    ; First pass: Only the containers with something inside
    ;
    lda #<_TemporaryBuffer479
    sta _gScreenPtr+0
    lda #>_TemporaryBuffer479
    sta _gScreenPtr+1

    lda #0
loop_item
    pha
    jsr _ByteStreamComputeDualItemPtr     ; Fetch the item information

    ; unsigned char associatedItemId = itemPtr->associated_item;
    ; if ( (itemPtr->location == e_LOC_INVENTORY) && (itemPtr->flags & ITEM_FLAG_IS_CONTAINER) && (associatedItemId!=255) )

    ldy #4                       ; Is it a container?
    lda (_gStreamItemPtr),y      ; gItems->flags (+4) = read flags
    and #ITEM_FLAG_IS_CONTAINER
    beq skip_item

    dey                          ; Is there an associated item?
    lda (_gStreamItemPtr),y      ; gItems->associated_item (+3) = read associated_item id    
    cmp #255
    beq skip_item

    dey                          ; Is it in the inventory?
    lda (_gStreamItemPtr),y      ; gItems->location (+2) = location id
    cmp #e_LOC_INVENTORY
    bne skip_item

    jsr _PrintInventorySetColor  ; Set the proper color

    ;PrintStringAt(gColoredSeparator,gScreenPtr);
    lda #0
    sta _gPrintPos

    lda _gScreenPtr+0
    sta _gPrintAddress+0
    lda _gScreenPtr+1
    sta _gPrintAddress+1

    lda #<_gColoredSeparator
    ldx #>_gColoredSeparator
    jsr _PrintStringInternalAX

    ;PrintString(itemPtr->description);  // Print the container
    ldy #1
    lda (_gStreamItemPtr),y      ; gItems->description (+0) = item description
    tax
    dey
    lda (_gStreamItemPtr),y      ; gItems->description (+0) = item description
    jsr _PrintStringInternalAX

    ;PrintString(":");
    lda #<_gColonSeparator
    ldx #>_gColonSeparator
    jsr _PrintStringInternalAX

    ;PrintString(gItems[associatedItemId].description);
    ldy #1
    lda (_gStreamAssociatedItemPtr),y      ; gItems->description (+0) = item description
    tax
    dey
    lda (_gStreamAssociatedItemPtr),y      ; gItems->description (+0) = item description
    jsr _PrintStringInternalAX


    inc _gCurrentItemCount       ; gCurrentItemCount+=2;
    inc _gCurrentItemCount

    clc                          ; gScreenPtr+=40;
    lda _gScreenPtr+0
    adc #40
    sta _gScreenPtr+0
    lda _gScreenPtr+1
    adc #0
    sta _gScreenPtr+1

skip_item
    pla
    clc
    adc #1
    cmp #e_ITEM_COUNT_
    bne loop_item
.)
.(
    // Solo items pass
    // Second pass: Everything else
   
    lda #0
loop_single_items
    pha
    jsr _ByteStreamComputeItemPtr     ; Fetch the item information

    ; unsigned char associatedItemId = itemPtr->associated_item;
    ;if ( (itemPtr->location == e_LOC_INVENTORY) && (associatedItemId==255))
    ldy #3                       ; Is there an associated item?
    lda (_gStreamItemPtr),y      ; gItems->associated_item (+3) = read associated_item id    
    cmp #255
    bne skip_item

    dey                          ; Is it in the inventory?
    lda (_gStreamItemPtr),y      ; gItems->location (+2) = location id
    cmp #e_LOC_INVENTORY
    bne skip_item

    jsr _PrintInventoryComputeScreenPtr
    jsr _PrintInventorySetColor  ; Set the proper color

    ;PrintStringAt(gColoredSeparator,gScreenPtr);
    lda #0
    sta _gPrintPos

    lda _gScreenPtr+0
    sta _gPrintAddress+0
    lda _gScreenPtr+1
    sta _gPrintAddress+1

    lda #<_gColoredSeparator
    ldx #>_gColoredSeparator
    jsr _PrintStringInternalAX

    ;PrintString(itemPtr->description);  // Print the container
    ldy #1
    lda (_gStreamItemPtr),y      ; gItems->description (+0) = item description
    tax
    dey
    lda (_gStreamItemPtr),y      ; gItems->description (+0) = item description
    jsr _PrintStringInternalAX

    inc _gCurrentItemCount

skip_item
    pla
    clc
    adc #1
    cmp #e_ITEM_COUNT_
    bne loop_single_items

    jsr _BlittTemporaryBuffer479

    lda #0
    sta _gPrintRemovePrefix
    rts
.)


; CYAN  =7=%111
; YELLOW=3=%011
_PrintInventorySetColor
.(
    ; gColoredSeparator[0] = (gCurrentItemCount&1)^((gCurrentItemCount&2)>>1)  ?7:3;  // Alternate the ink colors based on the counter
    ldx #3
    lda _gCurrentItemCount
    and #1
    sta tmp0
    lda _gCurrentItemCount
    lsr 
    and #1
    eor tmp0
    beq yellow
    ldx #7
yellow    
    stx _gColoredSeparator
    rts
.)



_PrintInventoryComputeScreenPtr
.(
    ; gScreenPtr = (char*)TemporaryBuffer479+40*(gCurrentItemCount/2)+(gCurrentItemCount&1)*20;  
    lda #<_TemporaryBuffer479
    sta _gScreenPtr+0
    lda #>_TemporaryBuffer479
    sta _gScreenPtr+1

    ldx _gCurrentItemCount
    beq end_line
loop_line
    clc
    lda _gScreenPtr+0
    adc #20
    sta _gScreenPtr+0
    lda _gScreenPtr+1
    adc #0
    sta _gScreenPtr+1
    dex
    bne loop_line
end_line
    rts
.)



_CleanWindowIfNecessary
.(
    lda _gShouldCleanWindow
    beq done_cleaning

    MEMSET_JSR(_MemSet_CleanWindow1)
    MEMSET_JSR(_MemSet_CleanWindow2)
    MEMSET_JSR(_MemSet_CleanWindow3)
    MEMSET_JSR(_MemSet_CleanWindow4)

    lda #0
    sta _gShouldCleanWindow
    sta _gKeywordMenuSelected
done_cleaning
    rts
.)



; These filters should leave the X register untouched
_AllContainersItemsFilterCallback
    lda _gCurrentItem
    cmp #e_ITEM__Last_Container+1
    bcs _ItemFilteredOut          ; >=    
_AllItemsFilterCallback           ; Returns all the items at the current location or in the inventory
    ldy #2
    lda (_gStreamItemPtr),y       ; +2 = location
    cmp _gCurrentLocation
    beq _ItemFilteredIn
    lda (_gStreamItemPtr),y       ; +2 = location
    cmp #e_LOC_INVENTORY
    beq _ItemFilteredIn
    bne _ItemFilteredOut

_AllSceneItemsFilterCallback      ; Use for TAKE
    ldy #2
    lda (_gStreamItemPtr),y       ; +2 = location
    cmp _gCurrentLocation
    beq _ItemFilteredIn
    bne _ItemFilteredOut

_AllInventoryItemsFilterCallback  ; Use for DROP
    ldy #2
    lda (_gStreamItemPtr),y       ; +2 = location
    cmp #e_LOC_INVENTORY
    beq _ItemFilteredIn
    bne _ItemFilteredOut

_ItemFilteredOut
    lda #0
    rts

_ItemFilteredIn
    lda #1
    rts



; Generate a list of items to display using one of the filters
_BuildContainerList
    lda #<_AllContainersItemsFilterCallback
    ldx #>_AllContainersItemsFilterCallback
    jmp _BuildItemSetCallbackAX

; Generate a list of relevant items depending of the selected action verb
_BuildContextualItemList
    ldy _gWordBuffer+0                     ; Action VERB

    lda #<_AllSceneItemsFilterCallback     ; TAKE is only concerned by items in the location
    ldx #>_AllSceneItemsFilterCallback
    cpy #e_WORD_TAKE
    beq _BuildItemSetCallbackAX

    lda #<_AllInventoryItemsFilterCallback  ; DROP only lists the items in the inventory
    ldx #>_AllInventoryItemsFilterCallback
    cpy #e_WORD_DROP
    beq _BuildItemSetCallbackAX

    lda #<_AllItemsFilterCallback           ; Any other command shows everything
    ldx #>_AllItemsFilterCallback
    ; Fallback
_BuildItemSetCallbackAX
    sta _gKeywordItemsFilter+0
    stx _gKeywordItemsFilter+1
    ; Fallback
_BuildItemList
.(
    ; gKeywordMenuEntries=(WORDS*)TemporaryBuffer479;
    lda #<_TemporaryBuffer479
    sta _gKeywordMenuEntries+0
    lda #>_TemporaryBuffer479
    sta _gKeywordMenuEntries+1

    ; gKeywordMenuEntryCount=1;
    ldx #0
    stx _gKeywordMenuEntryCount
loop_search
    txa
    jsr _ByteStreamComputeItemPtr         ; Item ID in A result is _gStreamItemPtr (does not touch X or Y)
    
    stx _gCurrentItem
+_gKeywordItemsFilter = *+1
    jsr _ItemFilteredOut                  ; Patched by the caller with the proper callback (does not touch X)
    beq next_item

    ; Item matched the filter
    txa
    jsr _AddItemEntry

next_item
    inx 
    cpx #e_ITEM_COUNT_
    bne loop_search                       ; Next item

    ; Add a fake "Cancel" item at the end of the list
    lda #e_WORD_COUNT_
_AddItemEntry
    ldy _gKeywordMenuEntryCount
    sta (_gKeywordMenuEntries),y          ; Add it to the list
    inc _gKeywordMenuEntryCount
    rts
.)


// MARK: Player Move
; Called when the player moves NSEWUD to a new location
_PlayerMove
.(
    sec
    lda _gWordBuffer               ; Get the keyword (it's assumed that it's one of the 6 possible directions)
    sbc #e_WORD_NORTH

    tay
    lda (_gCurrentLocationPtr),y   ; Get the target location for this direction
    cmp #e_LOC_NONE                ; Does it actually exist?
    beq wrong_direction

go_there    
    sta _gCurrentLocation          ; Store the current location

    ldx #<_KeyClickHData           ; Play the "click" sound
    ldy #>_KeyClickHData           
    jsr _PlaySoundAsmXY            

    jmp _LoadScene                 ; Load the actual scene

wrong_direction
    lda #ACHIEVEMENT_WRONG_DIRECTION     ; Trigger the "can't go there" achievement
    jsr _UnlockAchievementAsmA

    lda #<_gTextErrorInvalidDirection    ; Print the error message
    sta _param0+0
    lda #>_gTextErrorInvalidDirection
    sta _param0+1
    jmp _PrintErrorMessageShortAsm
.)



// MARK:Take Item
_TakeItem
.(
    ; Get itemId from gWordBuffer[1]
    lda _gWordBuffer+1       ; Load gWordBuffer[1] into A (itemId)
    cmp #e_WORD_COUNT_
    bne keep_going
    ; User cancelled the operation
    jmp _PrintSceneObjects

keep_going    
    sta _gCurrentItem

    ; if (itemId >= e_ITEM_COUNT_)
    cmp #e_ITEM_COUNT_
    bcc validate_item        ; It's an actual item (not a verb)

    ; Check gWordCount <= 1
    lda _gWordCount         ; Load gWordCount
    cmp #2                  ; Compare with 2
    bcs item_not_present

need_more_details    
    lda #<_gTextErrorNeedMoreDetails
    ldx #>_gTextErrorNeedMoreDetails
    jmp _PrintErrorMessageAsmAX

item_not_present
    lda #<_gTextErrorCantTakeNoSee
    ldx #>_gTextErrorCantTakeNoSee
    jmp _PrintErrorMessageAsmAX

validate_item
    jsr _ByteStreamComputeItemPtr   ; Initializes _gStreamItemPtr from A (item id)

    ldy #2                          ; Location offset
    lda (_gStreamItemPtr),y         ; Load itemPtr->location

check_if_in_inventory_already       ; if (itemPtr->location == e_LOC_INVENTORY)           // Do we already have the item?
    cmp #e_LOC_INVENTORY
    bne check_if_in_scene
    
    lda #<_gTextErrorAlreadyHaveItem ; Already in the inventory
    ldx #>_gTextErrorAlreadyHaveItem
    jmp _PrintErrorMessageAsmAX

check_if_in_scene                   ; if (itemPtr->location != gCurrentLocation)          // Is the item in the scene?
    cmp _gCurrentLocation           ; Compare with gCurrentLocation
    beq check_inventory_space
    
    lda #<_gTextErrorItemNotPresent ; The item is not in the scene
    ldx #>_gTextErrorItemNotPresent
    jmp _PrintErrorMessageAsmAX

check_inventory_space               ; if (gCurrentItemCount >= 8)
    lda _gCurrentItemCount          ; Load gCurrentItemCount
    cmp #8
    bcc check_if_movable
    
    lda #<_gTextErrorInventoryFull  ; The inventory is full
    ldx #>_gTextErrorInventoryFull
    jmp _PrintErrorMessageAsmAX

check_if_movable                    ; if (itemPtr->flags & ITEM_FLAG_IMMOVABLE)
    ldy #4                          ; Flags offset
    lda (_gStreamItemPtr),y         ; Load itemPtr->flags
    and #ITEM_FLAG_IMMOVABLE
    beq check_if_needs_container
    
    lda #<_gTextErrorCannotDo       ; This item cannot be moved
    ldx #>_gTextErrorCannotDo
    jmp _PrintErrorMessageAsmAX

check_if_needs_container
    ldy #5                          ; Usable containers flags offset
    lda (_gStreamItemPtr),Y         ; Load itemPtr->usable_containers
    bne query_container

execute_bytestream
    ; DispatchStream(gTakeItemMappingsArray,gCurrentItem);
    lda _gCurrentItem
    sta _param0

    lda #<_gTakeItemMappingsArray
    sta _param1+0
    lda #>_gTakeItemMappingsArray
    sta _param1+1

    jmp _DispatchStream

query_container
    ; Save the current item because it will be overwritten by the AskInput
    lda _gCurrentItem
    pha

    ; Save the default input parameters used by the normal command processing
    ; and put in place another set of parameters to request the container to use
    lda _gAnswerProcessingCallback+1    ; AnswerProcessingFun previousCallback = gAnswerProcessingCallback;
    pha
    lda _gAnswerProcessingCallback+0
    pha 

    lda #<_ProcessContainerAnswer       ; gAnswerProcessingCallback = ProcessContainerAnswer;
    sta _gAnswerProcessingCallback+0
    lda #>_ProcessContainerAnswer
    sta _gAnswerProcessingCallback+1

    lda _gInputMessage+1                ; const char* previousInputMessage = gInputMessage;
    pha
    lda _gInputMessage+0
    pha 

    lda #<_gTextCarryInWhat             ; gInputMessage = gTextCarryInWhat;
    sta _gInputMessage+0
    lda #>_gTextCarryInWhat
    sta _gInputMessage+1

    lda #1                              ; gInputAcceptsEmpty = 1;
    sta _gInputAcceptsEmpty
    sta _gContainerRequestMode          ; Enable container request mode (disables arrows, ESC aborts)

    ; Ask the user to provide the container to use
    jsr _AskInput                  ; gCurrentAssociatedItem = AskInput();    // "Carry it in what?"

    lda #0
    sta _gInputDone
    sta _gContainerRequestMode          ; Disable container request mode

    lda _gWordBuffer+0
    sta _gCurrentAssociatedItem

    ; Restore the original parameters
    pla                            ; gInputMessage = previousInputMessage;
    sta _gInputMessage+0
    pla 
    sta _gInputMessage+1

    pla                            ; gAnswerProcessingCallback = previousCallback;
    sta _gAnswerProcessingCallback+0
    pla 
    sta _gAnswerProcessingCallback+1

    lda #0                         ; gInputAcceptsEmpty = 0;
    sta _gInputAcceptsEmpty        

    pla
    sta _gCurrentItem
    jsr _ByteStreamComputeItemPtr   ; Initializes _gStreamItemPtr from A (item id)

validate_answer
    ; Validate the answer
    lda _gCurrentAssociatedItem
    cmp #e_WORD_SKIP
    beq user_canceled
    cmp #e_ITEM_COUNT_
    bne validate_container

user_canceled
    ; The user selected the CANCEL option (or pressed ESC)
    jmp _PrintSceneObjects

validate_container    
    lda _gCurrentAssociatedItem         ; if (gCurrentAssociatedItem > e_ITEM__Last_Container)
    cmp #(e_ITEM__Last_Container + 1)   ; Compare with e_ITEM__Last_Container + 1
    bcc check_usable_container

print_invalid_container
    lda #<_gTextErrorNotAContainer
    ldx #>_gTextErrorNotAContainer
    jmp _PrintErrorMessageAsmAX

check_usable_container              ; Calculate (1 << gCurrentAssociatedItem)    
    tax                             ; The item ID will be used as a counter
    lda #1                          ; Start with 1
    cpx #0
    beq test_bit                    ; If shift count is 0, skip shifting
shift_loop
    asl                             ; Shift left
    dex                             ; Decrement shift count
    bne shift_loop                  ; Repeat until X = 0

test_bit          ; Check !(gStreamItemPtr->usable_containers & (1 << gCurrentAssociatedItem))
    ldy #5                          ; Offset to usable_containers field
    and (_gStreamItemPtr),y         ; AND with usable_containers
    beq print_invalid_container     ; If result is 0, condition fails, go to error

container_is_valid
    ; gStreamAssociatedItemPtr=&gItems[gCurrentAssociatedItem];
    lda _gCurrentAssociatedItem            ; ID of the container
    ldx #2                                 ; Targets gStreamAssociatedItemPtr instead of gStreamItemPtr
    jsr _ByteStreamComputeItemPtrIndexX    ; Comnpute the pointer

    ldy #2                              ; Location offset
    lda (_gStreamAssociatedItemPtr),y   ; Load itemPtr->location
    cmp #e_LOC_INVENTORY                ; if (gStreamAssociatedItemPtr->location != e_LOC_INVENTORY)
    beq check_container_inventory_space

check_if_container_in_scene             ; if (itemPtr->location != gCurrentLocation)          // Is the item in the scene?
    cmp _gCurrentLocation               ; Compare with gCurrentLocation
    beq check_container_inventory_space
    
    lda #<_gTextErrorMissingContainer   ; The container is not in the scene
    ldx #>_gTextErrorMissingContainer
    jmp _PrintErrorMessageAsmAX

check_container_inventory_space
    ldy #2                              ; Location offset
    lda (_gStreamAssociatedItemPtr),y   ; Load container location
    ldx #8-1                            ; Assume container in scene (threshold = 7)
    cmp #e_LOC_INVENTORY
    bne check_threshold                 ; If not in inventory, use threshold 7
    inx                                 ; Container in inventory, increment to 8

check_threshold
    cpx _gCurrentItemCount              ; Compare threshold with count
    bcs put_container_in_inventory      ; If threshold >= count, we have room

    lda #<_gTextErrorInventoryFull      ; The inventory is full
    ldx #>_gTextErrorInventoryFull
    jmp _PrintErrorMessageAsmAX

put_container_in_inventory
    lda #e_LOC_INVENTORY
    sta (_gStreamAssociatedItemPtr),y   ; Move the container into the inventory

check_if_container_empty
    ldy #3
    lda (_gStreamAssociatedItemPtr),y
    cmp #255                            ; if (gStreamAssociatedItemPtr->associated_item != 255)
    beq empty_container
    
    lda #<_gTextErrorAlreadyFull        ; The container is not empty
    ldx #>_gTextErrorAlreadyFull
    jmp _PrintErrorMessageAsmAX

empty_container
    ; Looks like we have both the item and an empty container!
    ;ldy #3
    lda _gCurrentAssociatedItem          ; gStreamItemPtr->associated_item 	      = gCurrentAssociatedItem;
    sta (_gStreamItemPtr),y
    lda _gCurrentItem                    ; gStreamAssociatedItemPtr->associated_item = gCurrentItem;
    sta (_gStreamAssociatedItemPtr),y    

    jmp execute_bytestream
.)



_PrintActionMenu
.(
    inc _gActionMenuCount          ; ++gActionMenuCount;

    ldx #0                         ; gWordCount=0;
    stx _gWordCount

    inx                            ; gShouldCleanWindow=1;
    stx _gShouldCleanWindow

    jsr _WaitReleasedKey

forever_loop
    jsr _CleanWindowIfNecessary

    lda #1
    sta _gMaxWordIndex

    ; Depending of the context we either show a list of commands or a list of items
    .(
    lda #<_ProcessContainerAnswer    ; if (gAnswerProcessingCallback == ProcessContainerAnswer)
    cmp _gAnswerProcessingCallback+0
    bne end_container_check
    lda #>_ProcessContainerAnswer
    cmp _gAnswerProcessingCallback+1
    bne end_container_check

    ; Containers list
    jsr _BuildContainerList
    jmp show_menu

end_container_check
    .)

    lda _gWordCount                 ; if (gWordCount==0)
    bne end_verb_check

    ; Default input mode - Verb
    lda #12+1                         ; gKeywordMenuEntryCount=12; +1 for the CANCEL option
    sta _gKeywordMenuEntryCount

    lda #<_gActionMappingMenu       ; gKeywordMenuEntries=gActionMappingMenu;
    sta _gKeywordMenuEntries+0
    lda #>_gActionMappingMenu
    sta _gKeywordMenuEntries+1
end_verb_check

show_menu
    ; gWordBuffer[gWordCount]=RefreshActionMenu();
    jsr _RefreshActionMenu
    ldy _gWordCount
    stx _gWordBuffer,y

    ; Check if the current entry maps to an action
    jsr _FindActionMapping       ; if (FindActionMapping())
    beq end_action_mapping

    ; gMaxWordIndex = 1+gActionMappingPtr->flag&3;  // Number of items after    
    ldy #1                        ; Flag offset
    lda (_gActionMappingPtr),y
    and #3                        ; Number of items associated with the command
    clc
    adc #1                        ; + the command itself
    sta _gMaxWordIndex
end_action_mapping

    ; Print the content of the keyword buffer into a human readable string
    jsr _PrintKeywordBuffer

    ; Input loop the calls the main handler so we can see scene animations as well as the time out sequence.
input_loop
    ; Read the keyboard
    jsr _ReadKeyNoBounce
    stx _gInputKey

    ; Call the animation code
    jsr _AskInputCallback
    cpx #e_WORD_CONTINUE
    beq continue
    lda #KEY_ESC        ; Simulate a ESCAPE key press
    sta _gInputKey
continue

    ; No need to process inputs and animation more than once a 1/50th of a second
    jsr _WaitIRQ

    lda _gInputKey
    beq input_loop           ; while (gInputKey==0);

    ; Keyboard dispatcher
    jsr CheckMenuKeys  

    .(
    ; Bounds checking of the menu selection to keep it between 0 and entry count
    lda _gKeywordMenuSelected
    bpl check_overflow            ; Check if the selection index is negative

    clc
    adc _gKeywordMenuEntryCount   ; Make it positive

check_overflow
    cmp _gKeywordMenuEntryCount   ; Check if we are past the menu size
    bcc end
    lda #0                        ; Wrap back to start
end
    sta _gKeywordMenuSelected
    .)

    jmp forever_loop
.)



CheckMenuKeys   
.(
    lda _gInputKey 
    cmp #KEY_UP
    bne end_up
    dec _gKeywordMenuSelected
    rts
end_up    

    cmp #KEY_DOWN
    bne end_down
    inc _gKeywordMenuSelected
    rts
end_down

    cmp #KEY_LEFT
    bne end_left
    sec
    lda _gKeywordMenuSelected
    sbc #4
    sta _gKeywordMenuSelected
    rts
end_left

    cmp #KEY_RIGHT
    bne end_right
    clc
    lda _gKeywordMenuSelected
    adc #4
    sta _gKeywordMenuSelected
    rts
end_right

    cmp #KEY_DEL
    bne end_delete
    lda _gWordCount
    beq end_delete
    ; Delete the currently selected word
    dec _gWordCount
    lda #1
    sta _gShouldCleanWindow
    rts
end_delete

    cmp #KEY_ESC
    bne end_escape
escape    
    lda #0                    ; gWordCount=0;
    sta _gWordCount
    lda #e_WORD_SKIP          ; gWordBuffer[0]=e_WORD_SKIP;
    sta _gWordBuffer+0
    jsr _PrintSceneObjects
    jsr _ResetInput
    dec _gActionMenuCount     ; --gActionMenuCount;

quit_menu
    ; We pop the calling function and just quit violently
    pla
    pla

    ;pla
    ;pla
    rts

end_escape

    cmp #KEY_SPACE
    beq validate
    cmp #KEY_RETURN
    bne end_validate
validate
    ; Check if the currently selected word is CANCEL
    ldx _gWordCount
    lda _gWordBuffer,x
    cmp #e_WORD_COUNT_        ; CANCEL?
    beq escape                ; We simulate a press on the ESCAPE key to quit the menu
    
    inx
    cpx _gMaxWordIndex        ; compare with max - ((gWordCount+1)>=gMaxWordIndex)
    bcc more_words            ; skip if < max (carry clear)
last_word    

    ldx #16+4                           ; ClearMessageWindow(16+4);
    jsr _ClearMessageWindowAsmX

    .(
    lda #<_ProcessContainerAnswer    ; if (gAnswerProcessingCallback == ProcessContainerAnswer)
    cmp _gAnswerProcessingCallback+0
    bne not_container_list
    lda #>_ProcessContainerAnswer
    cmp _gAnswerProcessingCallback+1
    bne not_container_list
is_container_list
    lda #0                        ; gInputKey = 0;
    sta _gInputKey
    lda #1                        ; gInputDone = 1;
    sta _gInputDone
    dec _gActionMenuCount         ; --gActionMenuCount;
    jmp quit_menu

not_container_list
    jsr _RunWordBufferCommand
    .)

    dec _gActionMenuCount         ; --gActionMenuCount;
    jmp quit_menu

more_words
    inc _gWordCount               ; gWordCount++;   // Should check if we need this word
    lda #1                        ; gShouldCleanWindow=1;
    sta _gShouldCleanWindow
    jmp _BuildContextualItemList

end_validate
    rts
.)


// MARK:Display Scene
_PrintSceneInformation
.(
    ; Display the score
    ; sprintf((char*)0xbb80+16*40+1,gTextScore,gScore);   // "Score:"
    ldy #0 
	lda #<$bb80+16*40+1
    sta (sp),y

    iny
    lda #>$bb80+16*40+1
    sta (sp),y

    iny
	lda #<_gTextScore 
    sta (sp),y

    iny
    lda #>_gTextScore 
    sta (sp),y

    iny
	lda _gScore 
    sta (sp),y 

    iny 
    lda _gScore+1 
    sta (sp),y 

	iny
    jsr _sprintf

    ; Draw the rest of the information
	jsr _PrintSceneDirections
	jsr _PrintSceneObjects
	jmp _PrintInventory
.)


; On Microdisc, location $314 contains the following flags on write operations
; bit 7: Eprom select (active low) 
; bit 6-5: drive select (0 to 3) 
; bit 4: side select 
; bit 3: double density enable (0: double density, 1: single density) 
; bit 2: along with bit 3, selects the data separator clock divisor            (1: double density, 0: single-density) 
; bit 1: ROMDIS (active low). When 0, internal Basic rom is disabled. 
; bit 0: enable FDC INTRQ to appear on read location $0314 and to drive cpu IRQ	
; and $0318 bit 7 contains the state of DRQ

_Reset
.(
    sei
    lda #0
    sta $3fa        ; Jasmin: Disable overlay RAM
    sta $3fb        ; Jasmin: Enable ROM
    lda #%10000010
    sta $0314       ; Microdisc: Disable overlay and enable ROM
    jmp ($fffc)
.)


/*
-- 0xbb80-0x9900 --

$9900 - Shift buffers
$9900	768	768	_gShiftBuffer
$9c00	256	256	_gTableModulo6
$9d00	256	256	_gTableDivBy6
$9e00	512	512	_free_to_use_9e00
$a000	5120	5120	_HIRES_MEMORY_START
--> $9900-$a000 = 1792 bytes

$b400	1	1	_Attribute_TEXT  = $a000+5120
$b401	383	383	_free_to_use_b401
$b580	136	136	_TextCharsetNumbers
$b608	256	256	_TextCharsetUpperCaseLetters
$b708	248	248	_TextCharsetLowerCaseLetters
$b800	128	128	_gTableMulBy40Low
$b880	128	128	_gTableMulBy40High
$b900	640	640	_maybe_free_to_use
$bb80	1	1	_Attribute_HIRES, _TEXT_MEMORY_START
-> $bfe0-$b400 = 3040 bytes

Area that needs preserving:
$a000+5120-$bb80 = 1920 bytes



$c000	5120	5120	_ImageBuffer
$d400	320	320	_ImageBufferEnd
$d540	5120	5120	_SecondImageBuffer
$e940	2660	2660	_gFont12x14


// Entry #132 '..\build\files\hires_monkey_king.hir'
// - Starts on the second side on track 37 sector 12 and is 7 sectors long 
// (1581 compressed bytes: 19% of 8000 bytes).

// Entry #133 '..\build\files\monkey_king.o'
// - Starts on the second side on track 38 sector 1 and is 16 sectors long 
// (3874 compressed bytes: 81% of 4739 bytes).

*/
_PlayMonkeyKing
.(
    ; Stop the clock so it does not damage the HIRES content
    jsr _StopClock

    ; Load the HIRES picture (8000 bytes)      
    ldx #LOADER_MONKEY_KING_HIRES
    stx _LoaderApiEntryIndex
    lda #<_ImageBuffer
    sta _LoaderApiAddressLow
    lda #>_ImageBuffer
    sta _LoaderApiAddressHigh
    jsr _LoadApiLoadFileFromDirectory    
    
    ; Copy the image
    jsr _BlitBufferToHiresWindowInternal        ; Copy the top 5120 bytes with the image content
    
    ; 3040+1792=4832
    ; 4832+(40*24)=4832+960=5792
    ; $C000 = _ImageBuffer+0         = 3040 bytes = Bottom of screen memory
    ; $CBE0 = _ImageBuffer+3040      = 1792 bytes = Saved charsets
    ; $D2E0 = _ImageBuffer+3040+1792 =  960 bytes = 24 last lines of the HIRES picture

    MEMCPY_JSR(_MemCpy_SaveHiresMemoryBottom)   ; Save the bottom half of screen memory
    MEMCPY_JSR(_MemCpy_SaveCharsetData)         ; Save the charset area data
    
    MEMCPY_JSR(_MemCpy_9900_B500)               ; Move the font from TEXT to HIRES location

    MEMCPY_JSR(_MemCpy_BlittHiresImageBottom)   ; Copy the bottom 2880 bytes with the image content

    MEMCPY_JSR(_MemCpy_MoveBottomGraphics)      ; Preserve the bottom part of the image

    ; Erase graphics in the lower border to avoid glitches during loading
    ldx #40*3-1
    lda #32|128
loop_1
    sta $bb80+40*25,x
    dex
    bpl loop_1

    ; LOADER_MONKEY_KING - About 4721 bytes
    ldx #LOADER_MONKEY_KING
    stx _LoaderApiEntryIndex
    lda #<_Minigame
    sta _LoaderApiAddressLow
    lda #>_Minigame
    sta _LoaderApiAddressHigh
    jsr _LoadApiLoadFileFromDirectory

    ;jsr _Panic

    ; Patch the import vectors
    lda #<_ReadKeyNoBounce
    sta _Minigame+3+1
    lda #>_ReadKeyNoBounce
    sta _Minigame+3+2

    lda #<_PlaySoundAsmXY
    sta _Minigame+6+1
    lda #>_PlaySoundAsmXY
    sta _Minigame+6+2

    lda #<_VSync
    sta _Minigame+9+1
    lda #>_VSync
    sta _Minigame+9+2
   

    ; Launch the game
    jsr _Minigame

    ; Restore whatever graphics mode we had
    MEMCPY_JSR(_MemCpy_RestoreHiresMemoryBottom)   ; Restore the bottom half of screen memory
    MEMCPY_JSR(_MemCpy_RestoreCharsetData)         ; Restore the bottom charset area data

    ; Force clear the upper memory buffers
    MEMSET_JSR(_MemSet_CleanTopMemory)            ; Clean the masking buffer
    jsr _BlitBufferToHiresWindowInternal          ; Copy the top 5120 bytes with the image content

    ; Invalidate the cached data 
    lda #255
    sta _gCurrentSpriteSheetIndex
    sta _gCurrentMusicFileIndex

    ; Reload the font data
    jsr _LoadFonts

    ; Start the game clock again
    jmp _StartClock
.)



; ParseInputBuffer - Parses the input buffer and fills gWordBuffer with word IDs
; At the end of the parsing, each of the words is terminated by a zero so it can be printed individually
_ParseInputBuffer
.(
    lda #e_WORD_COUNT_              ; Clear gWordBuffer to e_WORD_COUNT_
    sta _gWordBuffer+0
    sta _gWordBuffer+1
    sta _gWordBuffer+2
    
    ldy #0                          ; Y = index into gInputBuffer
    sty _gWordCount                 ; gWordCount = 0

main_loop
    lda _gInputBuffer,y             ; car = gInputBuffer[y]
    beq done                        ; Null terminator = done
    
    cmp #" "
    bne not_space
    iny                             ; Skip space
    bne main_loop                   ; Always branches (Y won't be 0)

not_space
    sty tmp2                        ; tmp2 = inputPtr (start of word)

find_end_word
    iny
    lda _gInputBuffer,y
    beq end_word_found
    cmp #" "
    bne find_end_word

end_word_found
    sty tmp3                        ; tmp3 = endWordPtr

    ; param0 = &gInputBuffer[inputPtr] (same for verb and item searches)
    clc
    lda #<_gInputBuffer
    adc tmp2
    sta _param0
    lda #>_gInputBuffer
    adc #0
    sta _param0+1

    ; foundKeywordId = e_WORD_COUNT_ (not found)
    ldx #e_WORD_COUNT_

    ; If gWordCount == 0, search verbs first
    lda _gWordCount
    bne search_items
    
    ; Search in gWordsArray (verbs)
    lda #<_gWordsArray
    sta tmp5
    lda #>_gWordsArray
    sta tmp5+1

search_verbs_loop
    ldy #2
    lda (tmp5),y                    ; keywordPtr->id
    cmp #e_WORD_COUNT_
    beq search_items                ; End of verb list
    tax                             ; Save verb ID
    
    ldy #0                          ; param1 = keywordPtr->word (param0 already set)
    lda (tmp5),y
    sta _param1
    iny
    lda (tmp5),y
    sta _param1+1
    
    jsr _KeywordCompare
    bne next_verb                   ; Z=0 means no match
    
store_word
    ldy _gWordCount
    stx _gWordBuffer,y
    inc _gWordCount
    
    ldy tmp3                        ; Y = endWordPtr, continue scanning
    bne main_loop

next_verb
    clc
    lda tmp5
    adc #3                          ; sizeof(keyword) = 3
    sta tmp5
    bcc search_verbs_loop
    inc tmp5+1
    bne search_verbs_loop           ; Always branches (high byte won't be 0)

done
    rts

search_items
    lda #<_gItems
    sta tmp5
    lda #>_gItems
    sta tmp5+1
    
    ldx #0                       ; itemId = 0
search_items_loop
    cpx #e_ITEM_COUNT_
    bne keep_searching    
    ldx #e_WORD_COUNT_
    bne store_word
    
keep_searching    
    ; Get description pointer, find '_'
    ldy #0
    lda (tmp5),y
    sta tmp7
    iny
    lda (tmp5),y
    sta tmp7+1
    
    ldy #0
find_underscore
    lda (tmp7),y
    beq compare_item
    iny
    cmp #"_"
    bne find_underscore
    ; Y now points past the '_'

compare_item
    ; param1 = description + Y (after '_'), param0 already set
    tya
    clc
    adc tmp7
    sta _param1
    lda tmp7+1
    adc #0
    sta _param1+1
    
    jsr _KeywordCompare
    bne next_item                   ; Z=0 means no match
  
    ; X contains our current match    
    ; Check if accessible
    ldy #2
    lda (tmp5),y                    ; itemPtr->location
    cmp #e_LOC_INVENTORY
    beq store_word
    cmp _gCurrentLocation
    beq store_word
    ; Not accessible, keep searching

next_item
    inx
    clc
    lda tmp5
    adc #6                          ; sizeof(item) = 6
    sta tmp5
    bcc search_items_loop
    inc tmp5+1
    bne search_items_loop           ; Always branches (high byte won't be 0)
.)


// Fill param0.ptr=first;param1.ptr=second; first, result is in Z
_KeywordCompare
.(
    ldy #0
loop_character  
    lda (_param0),y
    jsr ConvertChar
    sta _param2+0

    lda (_param1),y
    jsr ConvertChar

    cmp _param2+0
    bne compare_done     ; Z=0 (no match)

    lda _param2+0
    beq compare_done     ; Z=1 (match - null terminator)

    iny
    bne loop_character

compare_done
    rts
.)



// MARK:AskInput
_AskInput
.(
    jsr _ResetInput             ; Also clears gInputDone

main_loop
    lda _gInputDone
    bne done_and_quit

    ; if (gAskQuestion)
    lda _gAskQuestion
    beq inner_loop

    ; if (gInputMessage[0])
    ldy #0
    sty _gAskQuestion
    lda (_gInputMessage),y
    beq skip_save_message

    ; Save the area under the prompt location (offsets 1..39, skipping attribute byte)
    ldy #39
save_loop
    lda (_gStatusMessageLocation),y
    sta _gPrintMessageBackground-1,y
    dey
    bne save_loop

    ; PrintStatusMessage(2, gInputMessage)
    lda _gInputMessage+0
    sta _param0+0
    lda _gInputMessage+1
    sta _param0+1
    lda #2
    sta _param1
    jsr _PrintStatusMessageAsm

skip_save_message
    ; Erase the prompt area
    lda #" "
    ldy #41                 ; Start Y at the desired offset
clear_input_loop
    sta (_gStatusMessageLocation),y  ; Write to Base Address + Y
    iny
    cpy #80                 ; Compare against Start Offset (41) + Length (39)
    bne clear_input_loop

    ; do { ... } while (gInputKey==0)
inner_loop
    ; if (AskInputCallback() != e_WORD_CONTINUE) return
    jsr _AskInputCallback
    cpx #e_WORD_CONTINUE
    beq callback_ok
done_and_quit    
    rts                             ; Quit AskInput immediately
callback_ok
    ; InputCheckKey()
    jsr _InputCheckKey

    ; --- Render input line (replaces sprintf) ---
    ; sprintf(gStatusMessageLocation+40+1,"%c>%s%c ",
    ;         gInputErrorCounter?1:2,gInputBuffer, ((VblCounter&32)||(gInputKey==KEY_RETURN))?32:32|128);
    ; tmp0 = gStatusMessageLocation + 41 (start of input line, position 1)
    ldy #41                          ; We start on the second line from the prompt location

    ; Write color code: red (1) if error, green (2) otherwise
    lda #2                    ; Default to Green
    ldx _gInputErrorCounter
    beq write_color
    lsr                       ; 2 >> 1 = 1 (Red)
write_color
    sta (_gStatusMessageLocation),y
    
    lda #">"
    iny
    sta (_gStatusMessageLocation),y     ; Write ">"

    ; Copy gInputBuffer characters
    ldx #0
copy_input
    iny
    lda _gInputBuffer,x
    beq write_cursor
    sta (_gStatusMessageLocation),y
    inx
    bne copy_input                  ; Always branches (buffer < 256)

write_cursor   
    lda #32                        ; Start with space
    ldx _gInputKey                 
    cpx #KEY_RETURN                ; If RETURN pressed, we keep the cursor hidden
    beq print_cursor
    and _VblCounter                ; Here we get either 32 or 0
    bne print_cursor
cursor_visible    
    ora #32+128                    ; Set video inverse to show the cursor
print_cursor
    sta (_gStatusMessageLocation),y  ; Cursor: space (32) if VblCounter&32 or KEY_RETURN, else inverse space (160)
    iny
    
    lda #32
    sta (_gStatusMessageLocation),y ; Trailing space (cleans up after character delete)

    jsr _WaitIRQ

    lda _gInputKey                  ; switch (gInputKey)
    beq inner_loop                  ; while (gInputKey==0)
    
    cmp #KEY_DEL
    bne not_del
    jsr _InputDelete
    jmp main_loop

not_del
    cmp #KEY_RETURN
    beq handle_return

    ; Range check for arrows/ESC: KEY_UP(6)..KEY_ESC(10)
    cmp #KEY_UP
    bcc handle_default
    cmp #KEY_ESC+1
    bcc handle_arrow

handle_default
    jsr _InputDefaultKey
    jmp main_loop

handle_arrow
    jsr _InputArrows
    jmp main_loop

handle_return
    ; if (ValidateInputReturn() || (gWordCount==0 && gInputAcceptsEmpty))
    jsr _ValidateInputReturn
    txa
    bne valid_input

    ; OR condition
    lda _gWordCount
    bne invalid_input
    lda _gInputAcceptsEmpty
    beq invalid_input

valid_input
    ; Call gAnswerProcessingCallback() via self-modifying code.
    ; Could technically be changed in the call back itself, so don't change it at the start of the function
    lda _gAnswerProcessingCallback+0
    sta ask_callback+1
    lda _gAnswerProcessingCallback+1
    sta ask_callback+2
ask_callback
    jsr $1234
    cpx #e_WORD_CONTINUE
    bne quit_return

    ; Continue: reset and ask again
    jsr _ResetInput
    lda #1
    sta _gAskQuestion
    jmp main_loop

invalid_input
    jsr _InputError
    jmp main_loop

quit_return
    ; if (gInputMessage[0]) restore the status message line
    ldy #0
    lda (_gInputMessage),y
    beq quit_done

    ; Restore the area under the prompt location (offsets 1..39, skipping attribute byte)
    ldy #39
restore_loop
    lda _gPrintMessageBackground-1,y
    sta (_gStatusMessageLocation),y
    dey
    bne restore_loop

quit_done
    rts
.)

_EndGameUtils_
