
#include "params.h"

    .zero

_gPrintAddress      .dsb 2
_gPrintPos          .dsb 1
_gPrintPosStart     .dsb 1      // Used by the prefix removal to know where to start back from
_gPrintLineTruncated .dsb 1

    .text

_gIsHires           .byt 1
_gPrintWidth        .byt 40
_gPrintTerminator   .byt 0          // 0 byt default, but could be TEXT_END to allow for setting black ink changes
_gShowHighlights    .byt 0
_gPrintRemovePrefix .byt 0
_gPrintQuitIfSpace  .byt 0          // Used by the option menu to truncate items to the important word

_gStatusMessageLocation .word $bb80+40*22

_spaceCounter  .dsb 1
_wasTruncated  .dsb 1
_car           .dsb 1
_lengthFixing  .dsb 1    // If we find a control character, it does not count as part of the word
_isHighlighted .dsb 1
_lastCharacter .dsb 1    // Used to detect if a prefix is behind an apostrophe


; Should probably be in a separate "text.s"
_PrintSpacesIfAny
.(
    ; if (spaceCounter && !wasTruncated)
    ldx _spaceCounter
    beq no_spaces
    lda _wasTruncated
    bne skip

    lda #32         ; Space
    ldy _gPrintPos
print_spaces
    sta (_gPrintAddress),y
    iny
    dex
    bne print_spaces
    sty _gPrintPos

skip    
    ; spaceCounter=0;
    lda #0
    sta _spaceCounter
no_spaces    
    rts
.)


; _param0 +0/+1 = pointer to the string
_MovePointerToAfterPrefixIfFound
.(
    ldy #0
loop    
    lda (_param0),y
    beq no_prefix
    cmp #"$"
    beq found_prefix
    iny
    jmp loop

found_prefix
    clc
    tya
    adc _param0+0
    sta _param0+0
    lda _param0+1
    adc #0
    sta _param0+1
no_prefix
    rts
.)


; A/X = pointer to the string -> copied to _param0 +0/+1
_PrintStringInternalAX
    sta _param0+0
    stx _param0+1
; _param0 +0/+1 = pointer to the string
_PrintStringInternal
    ;jmp _PrintStringInternal
.(  
    lda _gPrintRemovePrefix
    beq no_prefix_removal
    jsr _MovePointerToAfterPrefixIfFound
no_prefix_removal    
    lda #0
    sta _isHighlighted
    sta _spaceCounter
    sta _wasTruncated
    sta _gPrintLineTruncated
    sta _lastCharacter

    lda _gPrintPos
    sta _gPrintPosStart

loop
    ldy #0
    sty _lengthFixing
    lda (_param0),y
    cmp #" "                // Space
    beq space
    cmp #TEXT_CRLF          // Carriage return
    beq carriage_return
    cmp #"_"                // Highlighted word prefix (in this case means "end of highlighte")
    beq highlighter_character
    cmp #"$"                // Mark where a word actually starts (when the strip suffix is enabled, else printed as a space)
    beq prefix_marker_character
    cmp _gPrintTerminator   // Either 0 or TEXT_END depending of the setting
    bne normal_character

quit
    jsr _PrintSpacesIfAny
abort    
    lda #0
    sta _gPrintTerminator   // Resets the terminator to zero (maybe?)
    sta _gPrintQuitIfSpace
    rts

space_except_after_apostrophe
    ldx _lastCharacter
    cpx #"'"
    beq skip_space
space    
    inc _spaceCounter
    lda _gPrintQuitIfSpace
    bne abort
skip_space    
    jsr _IncrementParam0
    jmp loop

carriage_return    
    lda #0
    sta _wasTruncated
    sta _gPrintPos
    jsr _Add40ToPrintAddress
    jsr _IncrementParam0
    jmp loop

prefix_marker_character
    lda #" "
    ldx _gPrintRemovePrefix
    beq space_except_after_apostrophe               // If we are not removing prefixes, then print a space
active_suffix    
    ldx _gPrintPosStart    // Reset the starting position
    stx _gPrintPos
    jsr _IncrementParam0
    jmp loop

highlighter_character
    inc _lengthFixing       // The word starts by "_"
normal_character
    ; Find the length of the next word
    iny
loop_find_word_end
    lda (_param0),y
    cmp _gPrintTerminator   // Either 0 or TEXT_END depending of the setting
    beq found_word_end
    cmp #" "                // Space
    beq found_word_end
    cmp #"$"                // Mark where a word actually starts (when the strip suffix is enabled, else printed as a space)
    beq found_word_end
    cmp #TEXT_CRLF          // Carriage return
    beq found_word_end
    cmp #"_"                // Highlighted word prefix (in this case means "end of highlighte")
    bne skip_highlight
    inc _lengthFixing
skip_highlight
    iny

    jmp loop_find_word_end

//found_word_end_and_eat_character    

found_word_end
    ; Length is in Y

    ; Does it fit? 
    tya
    tax 
    sec
    sbc _lengthFixing    ; Make sure to remove any control character we found
    clc
    adc _gPrintPos
    adc _spaceCounter
    cmp _gPrintWidth
    bmi end_wrap_test
    beq end_wrap_test
.(    
    ; Does not fit
    lda #1
    sta _wasTruncated
    sta _gPrintLineTruncated

    lda #0
    sta _gPrintPos

    jsr _Add40ToPrintAddress
.)
end_wrap_test
    stx tmp0
    jsr _PrintSpacesIfAny    ; Changes X
    ldx tmp0

    ; Print the actual word
    ; Word lenght in X
loop_print_word
    ldy #0
    lda (_param0),y
    jsr _IncrementParam0

    cmp #"_"                // Highlighted word prefix (in this case means "end of highlighte")
    bne skip_highlighter
    lda _gShowHighlights
    beq no_highlights

    lda _isHighlighted
    eor #128
    sta _isHighlighted
no_highlights
    jmp next_car
    
skip_highlighter
    ora _isHighlighted
    ldy _gPrintPos
    sta (_gPrintAddress),y
    sta _lastCharacter
    inc _gPrintPos
next_car
    dex
    bne loop_print_word

    lda #0
    sta _isHighlighted
    sta _wasTruncated
    jmp loop

.)


_IncrementParam0
.(
  inc _param0+0
  bne skip
  inc _param0+1
skip
  rts
.)

_Add40ToPrintAddress
  clc
  lda _gPrintAddress+0
  adc #40
  sta _gPrintAddress+0
  lda _gPrintAddress+1
  adc #0
  sta _gPrintAddress+1
  rts


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
  MEMSET_VALUE_JSR(_MemSet_A000_BFE0,_param0+0)

  lda #ATTRIBUTE_TEXT
  sta $bfdf

  jsr _WaitIRQ
  jsr _WaitIRQ

  MEMCPY_JSR(_MemCpy_B500_9900)

  lda #0
  sta _gIsHires
  jmp common2

was_text  
  MEMSET_VALUE_JSR(_MemSet_BB80_BFE0,_param0+0)
  ;jmp common2

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

  MEMCPY_JSR(_MemCpy_9900_B500)

  lda #1
  sta _gIsHires

was_hires_already
  MEMSET_VALUE_JSR(_MemSet_BB80_BFE0,_param0+0)     // First fill the TEXT area with the paper color
  MEMSET_VALUE_JSR(_MemSet_A000_BFE0,_param0+0)     // Then fill the rest of the screen (including the charsets)

  lda #ATTRIBUTE_HIRES
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



_UnlockAchievementAsm
.(
    ; unsigned char* assignementPtr = &gAchievements[assignment/8];
    lda _param0
+_UnlockAchievementAsmA    
    lsr             ; /2
    lsr             ; /4
    lsr             ; /8
    clc
    adc #<_gAchievements
    sta tmp0+0
    lda #0
    adc #>_gAchievements
    sta tmp0+1

    ; unsigned char bitmask = 1<<(assignment&7);
    lda _param0
    and #7
    tax
    lda _BitMaskArray,x

    ; OR with the current byte value
    ldy #0
    ora (tmp0),y
    cmp (tmp0),y
    beq no_change

    sta (tmp0),y
    lda #1
    sta _gAchievementsChanged
no_change
    rts
.)

_BitMaskArray
    .byt %00000001
    .byt %00000010
    .byt %00000100
    .byt %00001000
    .byt %00010000
    .byt %00100000
    .byt %01000000
    .byt %10000000



; MARK: Keyboard layout
; Call SetKeyboardLayout with X pointing on the right offset from KeyboardLayoutBase
; Azerty = KeyboardLayoutAzerty-KeyboardLayoutBase = 0
; Qwerty = KeyboardLayoutQwerty-KeyboardLayoutBase = 7
; Qwertz = KeyboardLayoutQwertz-KeyboardLayoutBase = 14
_SetKeyboardLayout
    lda _gKeyboardLayout
    cmp #KEYBOARD_AZERTY
    beq _SetKeyboardAzerty
    cmp #KEYBOARD_QWERTZ
    beq _SetKeyboardQwertz
_SetKeyboardQwerty
    ldx #KeyboardLayoutQwerty-KeyboardLayoutBase
    bne SetKeyboardLayout
_SetKeyboardQwertz
    ldx #KeyboardLayoutQwertz-KeyboardLayoutBase
    bne SetKeyboardLayout
_SetKeyboardAzerty
    ldx #KeyboardLayoutAzerty-KeyboardLayoutBase
    ;jmp _SetKeyboardLayout  -- Fallthrough
SetKeyboardLayout
.(
    ; Read and push on the stack the entire array from the current offset
    ldy #7
read_value    
    lda KeyboardLayoutBase,x
    inx
    pha
    dey
    bne read_value

    ldy #7
write_value    
    ldx KeyboardLayoutScanCode-1,y
    pla 
    sta _KeyboardASCIIMapping,x
    dey
    bne write_value
    rts
.)


KeyboardLayoutBase
KeyboardLayoutAzerty    .byt "Q","W","A","Z","Y","M",","
KeyboardLayoutQwerty    .byt "A","Z","Q","W","Y",":","M"
KeyboardLayoutQwertz    .byt "A","Y","Q","W","Z",":","M"

KeyboardLayoutScanCode  .byt 8*6+5,8*2+5,8*1+6,8*6+7,8*6+0,8*3+2,8*2+0



_MemsetTableSystem
.(
    ; memsetAsm($a000,_param0+0,$bfe0-$a000)
    lda _MemSetDataBase+0,x:ldy #0:sta (sp),y:iny:lda _MemSetDataBase+1,x:sta (sp),y
    lda _MemSetDataBase+2,x:iny:sta (sp),y:iny:lda #0:sta (sp),y
    lda _MemSetDataBase+3,x:iny:sta (sp),y:iny:lda _MemSetDataBase+4,x:sta (sp),y
    jmp _memset                                                            ; - about 29 bytes
.)

_MemcpyTableSystem
.(
    ; memcpyAsm($b500,$9900,8*96)
    lda _MemCpyDataBase+0,x:ldy #0:sta (sp),y:iny:lda _MemCpyDataBase+1,x:sta (sp),y
    lda _MemCpyDataBase+2,x:iny:sta (sp),y:iny:lda _MemCpyDataBase+3,x:sta (sp),y
    lda _MemCpyDataBase+4,x:iny:sta (sp),y:iny:lda _MemCpyDataBase+5,x:sta (sp),y
    jmp _memcpy  
.)

_MemSetDataBase
_MemSetTemporaryBuffer479   MEMSET_ENTRY(_TemporaryBuffer479,32,40*10)
_MemSet_A000_BFE0           MEMSET_ENTRY($a000,0,$bfe0-$a000)
_MemSet_BB80_BFE0           MEMSET_ENTRY($bb80,0,$bfe0-$bb80)

_MemCpyDataBase
_MemCpy_B500_9900               MEMCPY_ENTRY($b500,$b9900,8*96)
_MemCpy_9900_B500               MEMCPY_ENTRY($b9900,$b500,8*96)
#ifdef MODULE_GAME
_MemCpy_B800_0_7DigitDisplay        MEMCPY_ENTRY($b800+"0"*8,_gSevenDigitDisplay,8*11)
_MemCpy__BlittTemporaryBuffer479    MEMCPY_ENTRY($bb80+40*24,_TemporaryBuffer479,40*4)

_MemSet_CleanWindow1        MEMSET_ENTRY($bb80+40*18+1,32,39)
_MemSet_CleanWindow2        MEMSET_ENTRY($bb80+40*19+1,32,39)
_MemSet_CleanWindow3        MEMSET_ENTRY($bb80+40*20+1,32,39)
_MemSet_CleanWindow4        MEMSET_ENTRY($bb80+40*21+1,32,39)

_MemSet_CleanTopMemory      MEMSET_ENTRY(_ImageBuffer,64,_ArkosMusic-_ImageBuffer)

_MemCpy_BlittInventory      MEMCPY_ENTRY($bb80+40*18,_TemporaryBuffer479,40*4)

; Monkey King stuff
_MemCpy_BlittHiresImageBottom       MEMCPY_ENTRY($a000+5120,_ImageBuffer+5120,2880)     ; Bottom half of the image -> screen

_MemCpy_SaveHiresMemoryBottom       MEMCPY_ENTRY(_SavedData1,$a000+5120,3040)           ; Save the bottom part of screen memory
_MemCpy_RestoreHiresMemoryBottom    MEMCPY_ENTRY($a000+5120,_SavedData1,3040)           ; Restore the bottom part of screen memory

_MemCpy_SaveCharsetData             MEMCPY_ENTRY(_SavedData2,$9900,1792)           ; Save the charset area data
_MemCpy_RestoreCharsetData          MEMCPY_ENTRY($9900,_SavedData2,1792)           ; Restore the bottom charset area data

_MemCpy_MoveBottomGraphics          MEMCPY_ENTRY(_SavedData3,_ImageBuffer+8000,960)     ; Copy the last 24 lines of the image to a saved buffer

#endif
