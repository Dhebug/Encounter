;
; Bytestream module.
; This implement a kind of bytecode based scripting system with simple compact commands.
; This is not definitely not as fast as pure assembler, but it's much more compact
;
#include "params.h"

    .zero 

_gCurrentStream
_gCurrentStreamInt      .dsb 2
_gCurrentStreamStop     .dsb 1
_gDelayStream           .dsb 2

_gStreamItemPtr         .dsb 2
_gStreamNextPtr         .dsb 2   ; Updated after the functions that prints stuff to know how long the string was 

    .text 

_ByteStreamCallbacks
    .word _ByteStreamCommandEnd
    .word _ByteStreamCommandRECTANGLE
    .word _ByteStreamCommandFILL_RECTANGLE
    .word _ByteStreamCommandTEXT
    .word _ByteStreamCommandBUBBLE
    .word _ByteStreamCommandWait
    .word _ByteStreamCommandBITMAP
    .word _ByteStreamCommandFADE_BUFFER
    .word _ByteStreamCommandJUMP
    .word _ByteStreamCommandJUMP_IF_TRUE
    .word _ByteStreamCommandJUMP_IF_FALSE
    .word _ByteStreamCommandINFO_MESSAGE
    .word _ByteStreamCommandFULLSCREEN_ITEM
    .word _ByteStreamCommandStopBreakpoint

; _param0=pointer to the new byteStream
_PlayStreamAsm
.(
    lda _param0+0
    sta _gCurrentStream+0
    lda _param0+1
    sta _gCurrentStream+1

    lda #0
	sta _gDelayStream

loop
    jsr _WaitIRQ
    jsr _HandleByteStream
    lda _gCurrentStream+0
    bne loop
    lda _gCurrentStream+1
    bne loop

    rts
.)


; Fetch the value in _gCurrentStream, increment the pointer, return the value in X
_ByteStreamGetNextByte
.(
    ldy #0
    lda (_gCurrentStream),y
    inc _gCurrentStream+0
    bne skip    
    inc _gCurrentStream+1
skip
    tax
    rts
.)


; A=Item ID
; Return a pointer on the item in _gStreamItemPtr
_ByteStreamComputeItemPtr
    // Item ID
    sta _gStreamItemPtr+0
    lda #0
    sta _gStreamItemPtr+1

    // x2
    asl _gStreamItemPtr+0
    rol _gStreamItemPtr+1

    // x4
    lda _gStreamItemPtr+0
    asl
    sta tmp0+0
    lda _gStreamItemPtr+1
    rol
    sta tmp0+1

    // x6
    clc
    lda _gStreamItemPtr+0
    adc tmp0+0
    sta _gStreamItemPtr+0
    lda _gStreamItemPtr+1
    adc tmp0+1
    sta _gStreamItemPtr+1

    // Item pointer
    clc
    lda _gStreamItemPtr+0
    adc #<_gItems
    sta _gStreamItemPtr+0
    lda _gStreamItemPtr+1
    adc #>_gItems
    sta _gStreamItemPtr+1

    rts


_ByteStreamCommandStopBreakpoint
    jmp _ByteStreamCommandStopBreakpoint
    rts


_ByteStreamCommandEnd
    lda #0
	sta _gCurrentStream+0
    sta _gCurrentStream+1
	sta _gDelayStream

    lda #1
    sta _gCurrentStreamStop
    rts


_ByteStreamCommandWait
    ; In theory the delay could be 8 or 16 bits based on the value, but the code does not use that at the moment
    jsr _ByteStreamGetNextByte
    stx _gDelayStream+0
  
    lda #1
    sta _gCurrentStreamStop
    rts


_ByteStreamCommandFADE_BUFFER
    jmp _BlitBufferToHiresWindow


_ByteStreamCommandJUMP
    //gCurrentStreamInt =  (unsigned int*) *gCurrentStreamInt++;
    ldy #0
    lda (_gCurrentStream),y
    tax                           ; Temporary so we don't change the stream pointer while using it
    iny
    lda (_gCurrentStream),y
    stx _gCurrentStream+0
    sta _gCurrentStream+1
    rts



_ByteStreamCommandJUMP_IF_TRUE
    lda #OPCODE_BEQ                          // F0
    bne common
_ByteStreamCommandJUMP_IF_FALSE
    lda #OPCODE_BNE                          // D0
common
.(
    sta _auto_conditionCheck+0
    eor #OPCODE_BEQ-OPCODE_BNE               //  0b100000
    sta _auto_conditionCheck2+0
    ldy #2
    lda (_gCurrentStream),y
    bne checkItemFlag

checkItemLocation                // OPERATOR_CHECK_ITEM_LOCATION 0 
    ; check =  (gItems[itemId].location == locationId);
    iny
    lda (_gCurrentStream),y      // item ID
    jsr _ByteStreamComputeItemPtr
    iny
    lda (_gCurrentStream),y      // location id
    ldy #2
    cmp (_gStreamItemPtr),y      // gItems->location (+2)
_auto_conditionCheck    
    bne _ByteStreamCommandJUMP   // BNE/BEQ depending of the command
    jmp _ByteStreamMoveBy5

checkItemFlag                    // OPERATOR_CHECK_ITEM_FLAG 1
    ; check =  (gItems[itemId].flags & flagId);
    iny
    lda (_gCurrentStream),y      // item ID
    jsr _ByteStreamComputeItemPtr
    iny
    lda (_gCurrentStream),y      // flag ID
    ldy #4
    and (_gStreamItemPtr),y      // gItems->flags (+4)
_auto_conditionCheck2
    bne _ByteStreamCommandJUMP   // BNE/BEQ depending of the command

+_ByteStreamMoveBy5    ; Continue (jump not taken)
    clc 
    lda _gCurrentStream+0
    adc #5
    sta _gCurrentStream+0
    lda _gCurrentStream+1
    adc #0
    sta _gCurrentStream+1
    rts
.)


_ByteStreamCommandFetchRectangleData
.(
    ; Fetch x/y/width/height/pattern parameters
    ldy #0
loop    
    lda (_gCurrentStream),y
    sta _gDrawPosX,y
    iny
    cpy #5
    bne loop
    ; Increment the pointer
    jmp _ByteStreamMoveBy5
.)    


_ByteStreamCommandRECTANGLE
    jsr _ByteStreamCommandFetchRectangleData
	jmp _DrawFilledRectangle


_ByteStreamCommandFILL_RECTANGLE
    jsr _ByteStreamCommandFetchRectangleData
	jmp _DrawFilledRectangle


_ByteStreamCommandTEXT
    ; Fetch x/y/pattern
    ldy #0
    lda (_gCurrentStream),y
    sta _gDrawPosX

    iny
    lda (_gCurrentStream),y
    sta _gDrawPosY

    iny
    lda (_gCurrentStream),y
    sta _gDrawPattern

    ; Store the current pointer 
    clc
    lda _gCurrentStream+0
    adc #3
    sta _gDrawExtraData+0
    lda _gCurrentStream+1
    adc #0
    sta _gDrawExtraData+1

    ; Print the string (modifies the ExtraData pointer to point to the next string)
    jsr _PrintFancyFont

    ; Update the pointer
    lda _gDrawExtraData+0
    sta _gCurrentStream+0
    lda _gDrawExtraData+1
    sta _gCurrentStream+1
    rts


; _param0+0/+1=pointer to message
; Returns len in y and a
_GetStringLen
.(
    ldy #0
loop    
    lda (_param0),y
    beq end_loop2
    iny
    jmp loop

end_loop2
    tya
    rts
.)


; Adjust the pointer to the next position (_param0+y+1)
_Adjust_gStreamNextPtr
.(
    tya
    sec
    adc _param0+0
    sta _gStreamNextPtr+0
    lda _param0+1
    adc #0
    sta _gStreamNextPtr+1

    rts
.)

; _param0+0/+1=pointer to message
_PrintTopDescriptionAsm
.(
    ;int messageLength = messageLength=strlen(message);
    jsr _GetStringLen
    lsr
    sta _param1  ; Store len/2 for later

    ; memset((char*)0xbb80+17*40+1,' ',39);
    lda #<$bb80+17*40+1:ldy #0:sta (sp),y:iny:lda #>$bb80+17*40+1:sta (sp),y
    lda #" ":iny:sta (sp),y:iny:lda #0:sta (sp),y
    lda #<39:iny:sta (sp),y:iny:lda #>39:sta (sp),y
    jsr _memset

	;strcpy((char*)0xbb80+17*40+20-messageLength/2,message);
    sec
    lda #<$bb80+17*40+20
    sbc _param1              ; len/2 from above
    sta tmp0+0
    lda #>$bb80+17*40+20
    sbc #0
    sta tmp0+1

    ldy #0
loop
    lda (_param0),y
    beq end_loop2
    sta (tmp0),y
    iny
    jmp loop

end_loop2
    ; Adjust the pointer to the next position (_param0+y+1)
    jmp _Adjust_gStreamNextPtr
.)


; _param0+0/+1=pointer to message
; _param1=color
_PrintStatusMessageAsm
    ;rts
    ;jmp _PrintStatusMessageAsm
.(
    ; char* ptrScreen=(char*)0xbb80+40*22;
    lda #<($bb80+40*22)
    sta tmp0+0
    lda #>($bb80+40*22)
    sta tmp0+1

    ; Write the color code
    ldy #1
    lda _param1
    sta (tmp0),y

    ; Write the message
    lda #<($bb80+40*22+2)
    sta tmp0+0
    lda #>($bb80+40*22+2)
    sta tmp0+1

    ldy #0
loop_message    
    lda (_param0),y
    beq end_message
    sta (tmp0),y
    iny
    jmp loop_message
end_message    
    ; Adjust the pointer to the next position (_param0+y+1)
    jsr _Adjust_gStreamNextPtr

    ; Clear the rest of the line
    lda #32
loop_clear
    sta (tmp0),y
    iny
    cpy #39-2
    bne loop_clear

    rts
.)


; _param0+0/+1=pointer to message
_PrintInformationMessageAsm
.(
    ; Set the color
    lda #3
    sta _param1

    ; Print the message
    jsr _PrintStatusMessageAsm

    ; Wait 75 frames
    lda #75
    sta _param0+0
    lda #0
    sta _param0+1

    jmp _WaitFramesAsm
.)


; _param0+0/+1=pointer to message
_PrintErrorMessageAsm
.(
    ; Set the color
    lda #1
    sta _param1

    ; Print the message
    jsr _PrintStatusMessageAsm

    ; Play a 'Ping' sound
    ldx #<_PingData
    ldy #>_PingData
    jsr _PlaySoundAsmXY

    ; Wait 75 frames
    lda #75
    sta _param0+0
    lda #0
    sta _param0+1

    jmp _WaitFramesAsm
.)

; Uses _gCurrentStream and _gStreamNextPtr
_ByteStreamCommandINFO_MESSAGE
.(
    ; PrintInformationMessage(gCurrentStream);    // Should probably return the length or pointer to the end of string
    ; _param0+0/+1=pointer to message (stored in gCurrentStream)
    lda _gCurrentStream+0
    sta _param0+0
    lda  _gCurrentStream+1
    sta _param0+1

    jsr _PrintInformationMessageAsm  

    ; gCurrentStream += strlen(gCurrentStream)+1;
    lda _gStreamNextPtr+0
    sta _gCurrentStream+0
    lda _gStreamNextPtr+1
    sta _gCurrentStream+1

    rts
.)



; _param0=paper color
_ClearMessageWindowAsm
.(
    ; Pointer to first line of the "window"
    lda #<$bb80+40*18
    sta tmp0+0
    lda #>$bb80+40*18
    sta tmp0+1

    ldx #1+23-18
loop_line
    ; Erase the 39 last characters of that line
    ldy #39
    lda #32
loop_column
    sta (tmp0),y
    dey
    bne loop_column

    ; Paper color at the start of the line
    lda _param0
    sta (tmp0),y

    ; Next line
    clc
    lda tmp0+0
    adc #40
    sta tmp0+0
    lda tmp0+1
    adc #0
    sta tmp0+1

    dex
    bne loop_line

    rts
.)

; param0 +0 = xPos
; param0 +1 = yPos
; param1 +0 = width
; param1 +1 = height
; param2 +0 = fillValue
_DrawRectangleOutlineAsm
.(
    ; Pointer to first hires window
    lda #<$a000
    sta _gDrawAddress+0
    lda #>$a000
    sta _gDrawAddress+1

    lda _param2+0
    sta _gDrawPattern  ; fillValue

    ; Left side
    lda _param0+0
	sta _gDrawPosX     ; xPos

    ldx _param0+1
    inx
	stx _gDrawPosY     ; yPos+1

    ldx _param1+1
    dex
    dex
	stx _gDrawHeight   ; height-2

;a jmp a

	jsr _DrawVerticalLine

    ; Right side
    clc
    lda _param0+0
    adc _param1+0
    sec
    sbc #1
	sta _gDrawPosX     ; xPos+width-1

	jsr _DrawVerticalLine

    ; Top side
    ldx _param0+0
    inx
	stx _gDrawPosX     ; xPos+1

    dec _gDrawPosY     ; yPos

    ldx _param1+0
    dex
    dex
	stx _gDrawWidth    ; width-2

	jsr _DrawHorizontalLine

    ; Bottom side
    clc
    lda _param0+1
    adc _param1+1
    sec
    sbc #1
	sta _gDrawPosY     ; yPos+height-1

	jmp _DrawHorizontalLine
.)    


; Used by scenes like showing the newspaper or the map of england
; - Loads an image
; - Display a title string
; - Fades the image in
_ByteStreamCommandFULLSCREEN_ITEM
.(  
    ; _param0=paper color
    ; ClearMessageWindow(16+4);
    lda #16+4
    sta _param0+0
    jsr _ClearMessageWindowAsm

	; unsigned char loaderId = *gCurrentStream++;
    ; LoadFileAt(loaderId,ImageBuffer);
    jsr _ByteStreamGetNextByte
    stx _LoaderApiEntryIndex
    lda #<_ImageBuffer
    sta _LoaderApiAddressLow
    lda #>_ImageBuffer
    sta _LoaderApiAddressHigh
    jsr _LoadApiLoadFileFromDirectory

    ; PrintTopDescription(gCurrentStream);
    lda _gCurrentStream+0
    sta _param0+0
    lda _gCurrentStream+1
    sta _param0+1
    jsr _PrintTopDescriptionAsm

	;gCurrentStream += strlen(gCurrentStream)+1;
    lda _gStreamNextPtr+0
    sta _gCurrentStream+0
    lda _gStreamNextPtr+1
    sta _gCurrentStream+1

    ; BlitBufferToHiresWindow();
    jmp _BlitBufferToHiresWindow
.)


_ByteStreamCommandBITMAP
.( 
	; unsigned char loaderId = *gCurrentStream++;
    jsr _ByteStreamGetNextByte
    cpx _gFlagCurrentSpriteSheet
    beq image_already_loaded             ; We only load the image if it's not already the one in memory
    
    ; Load the requested bitmap
    stx _gFlagCurrentSpriteSheet
    stx _LoaderApiEntryIndex
    lda #<_SecondImageBuffer
    sta _LoaderApiAddressLow
    lda #>_SecondImageBuffer
    sta _LoaderApiAddressHigh
    jsr _LoadApiLoadFileFromDirectory    

image_already_loaded
    ; Load the coordinates and draw the sprite
    ; These should probably be optimize with a simple function that takes a bit mask of which variables to update
    jsr _ByteStreamGetNextByte
    stx _gDrawWidth
    jsr _ByteStreamGetNextByte
    stx _gDrawHeight
    jsr _ByteStreamGetNextByte
    stx _gSourceStride

    jsr _ByteStreamGetNextByte
    stx _gDrawSourceAddress+0
    jsr _ByteStreamGetNextByte
    stx _gDrawSourceAddress+1

    jsr _ByteStreamGetNextByte
    stx _gDrawAddress+0
    jsr _ByteStreamGetNextByte
    stx _gDrawAddress+1

    jmp _BlitSprite
.)



_InitializeGraphicMode
.(
    jsr _ClearTextWindow

    lda #31|128
    sta $bb80+40*0  	   ; Switch to HIRES, using video inverse to keep the 6 pixels white

    lda #26
	sta $a000+40*128       ; Switch to TEXT

	; from the old BASIC code, will fix later
	; CYAN on BLACK for the scene description
    lda #7
	sta $BB80+40*16    ; Line with the arrow character and the clock
    lda #6
	sta $BB80+40*17

	; BLUE background for the log output
	lda #16+4
    sta _param0
    jsr _ClearMessageWindowAsm

	; BLACK background for the inventory area
    lda #16
	sta $BB80+40*24
	sta $BB80+40*25
	sta $BB80+40*26
	sta $BB80+40*27

	; Initialize the ALT charset numbers
    lda #<$b800+"0"*8:ldy #0:sta (sp),y:iny:lda #>$b800+"0"*8:sta (sp),y
    lda #<_gSevenDigitDisplay:iny:sta (sp),y:iny:lda #>_gSevenDigitDisplay:sta (sp),y
    lda #<8*11 :iny:sta (sp),y:iny:lda #>8*11:sta (sp),y
    jmp _memcpy  
.)


_count        .dsb 1
_coordinates  .dsb 2
tmpCount      .dsb 1

_ByteStreamCommandBUBBLE
.(
    jsr _ByteStreamGetNextByte     ; Number of bubbles 
    stx _count

    jsr _ByteStreamGetNextByte     ; Color pattern
    stx _gDrawPattern

    lda _gCurrentStream+0          ; Memorize the pointer for the later passes
    sta _coordinates+0
    lda _gCurrentStream+1
    sta _coordinates+1

    ;
    ; Draw the black outline of the speech bubble
    ;
    .( 
    ldx _count
    stx tmpCount
loop_bubble
    jsr _ByteStreamGetNextByte  ; X Pos
    dex
    stx _param0+0

    jsr _ByteStreamGetNextByte  ; Y Pos
    dex
    stx _param0+1

    jsr _ByteStreamGetNextByte   ; Skip offset Y

    lda #2+2
    sta _param1+0       ; Initial width

    lda #15+2
    sta _param1+1       ; Initial height

    lda _gDrawPattern
    sta _param2+0       ; Pattern

    ; Iterate over the string
    lda #0
    sta cur_char
loop_compute_size
    ldx cur_char
    stx prev_char
    jsr _ByteStreamGetNextByte
    stx cur_char
    beq end_compute_size
    bmi offset
character            ; Get the character width from the font information gFont12x14Width[car-32]+1;
    sec
    lda _param1+0
    adc _gFont12x14Width-32,x
    sta _param1+0    

    ; prev_char + cur_char -> kerning
    jsr _GetKerningValue
    sec
    lda _param1+0    
    sbc kerning
    sta _param1+0    
      
    bne loop_compute_size
offset               ; Signed offset to handle things like AV or To properly
    clc
    txa
    adc _param1+0
    sta _param1+0    
    bne loop_compute_size
end_compute_size

    jsr _DrawRectangleOutlineAsm

    dec tmpCount
    bne loop_bubble
    .)

    ;
    ; Fill the bubble rectangles with the opposite color
    ;
    lda _gDrawPattern
    eor #63
    sta _gDrawPattern

    .( 
    ; Restore the coordinates
    lda _coordinates+0
    sta _gCurrentStream+0
    lda _coordinates+1
    sta _gCurrentStream+1

    ldx _count
    stx tmpCount
loop_bubble
    jsr _ByteStreamGetNextByte  ; X Pos
    stx _gDrawPosX

    jsr _ByteStreamGetNextByte  ; Y Pos
    stx _gDrawPosY

    jsr _ByteStreamGetNextByte   ; Skip offset Y

    lda #15
    sta _gDrawHeight

    lda #2
    sta _gDrawWidth       ; Initial width

    ; Iterate over the string
    lda #0
    sta cur_char
loop_compute_size
    ldx cur_char
    stx prev_char
    jsr _ByteStreamGetNextByte
    stx cur_char
    beq end_compute_size
    bmi offset
character         ; Get the character width from the font information gFont12x14Width[car-32]+1;
    sec
    lda _gDrawWidth
    adc _gFont12x14Width-32,x
    sta _gDrawWidth

    ; prev_char + cur_char -> kerning
    jsr _GetKerningValue
    sec
    lda _gDrawWidth
    sbc kerning
    sta _gDrawWidth

    bne loop_compute_size
offset             ; Signed offset to handle things like AV or To properly
    clc
    txa
    adc _gDrawWidth
    sta _gDrawWidth
    bne loop_compute_size
end_compute_size

    jsr _DrawFilledRectangle

    dec tmpCount
    bne loop_bubble
    .)
    
    ;
    ; Print the actual text in the original color
    ;
    lda _gDrawPattern
    eor #63
    sta _gDrawPattern

    .( 
    ; Restore the coordinates
    lda _coordinates+0
    sta _gCurrentStream+0
    lda _coordinates+1
    sta _gCurrentStream+1

    ldx _count
    stx tmpCount
loop_bubble
    jsr _ByteStreamGetNextByte  ; X Pos
    inx                         ; Offset X
    stx _gDrawPosX

    jsr _ByteStreamGetNextByte  ; Y Pos
    stx _gDrawPosY

    jsr _ByteStreamGetNextByte  ; Offset Y
    clc
    txa
    adc _gDrawPosY
    sta _gDrawPosY

    lda #15
    sta _gDrawHeight

    lda _gCurrentStream+0
    sta _gDrawExtraData+0
    lda _gCurrentStream+1
    sta _gDrawExtraData+1
    
    jsr _PrintFancyFont

    lda _gDrawExtraData+0
    sta _gCurrentStream+0
    lda _gDrawExtraData+1
    sta _gCurrentStream+1

    dec tmpCount
    bne loop_bubble
    .)

    rts
.)

