
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

_gStatusMessageLocation .word $bb80+40*22

_spaceCounter  .dsb 1
_wasTruncated  .dsb 1
_car           .dsb 1
_lengthFixing  .dsb 1    // If we find a control character, it does not count as part of the word
_isHighlighted .dsb 1


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

#if 1
; _param0 +0/+1 = pointer to the string
_PrintStringInternal
    ;jmp _PrintStringInternal
.(  
#ifdef ENABLE_PRINTER    
    lda _param0+0
    ldx _param0+1
    jsr _PrinterSendStringAsm
#endif

    lda #0
    sta _isHighlighted
    sta _spaceCounter
    sta _wasTruncated
    sta _gPrintLineTruncated

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
    lda #0
    sta _gPrintTerminator   // Resets the terminator to zero (maybe?)
    rts

space    
    inc _spaceCounter
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
    beq space               // If we are not removing prefixes, then print a space
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
    inc _gPrintPos
next_car
    dex
    bne loop_print_word

    lda #0
    sta _isHighlighted
    sta _wasTruncated
    jmp loop

.)
#endif

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
  ; memsetAsm($a000,_param0+0,$bfe0-$a000)
  lda #<$a000:ldy #0:sta (sp),y:iny:lda #>$a000:sta (sp),y
  lda _param0+0:iny:sta (sp),y:iny:lda #0:sta (sp),y
  lda #<$bfe0-$a000:iny:sta (sp),y:iny:lda #>$bfe0-$a000:sta (sp),y
  jsr _memset  

  lda #ATTRIBUTE_TEXT
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

  ;jsr _Panic

  ; memset((char*)0xbb80,paperColor,0xbfe0-0xbb80);         // First fill the TEXT area with the paper color
  lda #<$bb80:ldy #0:sta (sp),y:iny:lda #>$bb80:sta (sp),y
  lda _param0+0:iny:sta (sp),y:iny:lda #0:sta (sp),y
  lda #<$bfe0-$bb80:iny:sta (sp),y:iny:lda #>$bfe0-$bb80:sta (sp),y
  jsr _memset

  ; memset((char*)0xa000,paperColor,0xbfe0-0xa000);         // Then fill the rest of the screen (including the charsets)
  lda #<$a000:ldy #0:sta (sp),y:iny:lda #>$a000:sta (sp),y
  lda _param0+0:iny:sta (sp),y:iny:lda #0:sta (sp),y
  lda #<$bfe0-$a000:iny:sta (sp),y:iny:lda #>$bfe0-$a000:sta (sp),y
  jsr _memset

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


