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
    tax
    inc _gCurrentStream+0
    bne skip    
    inc _gCurrentStream+1
skip
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
    lda #OPCODE_BEQ
    bne common
_ByteStreamCommandJUMP_IF_FALSE
    lda #OPCODE_BNE
common
.(
    sta conditionCheck+0
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
    jmp conditionCheck

checkItemFlag                    // OPERATOR_CHECK_ITEM_FLAG 1
    ; check =  (gItems[itemId].flags & flagId);
    iny
    lda (_gCurrentStream),y      // item ID
    jsr _ByteStreamComputeItemPtr
    iny
    lda (_gCurrentStream),y      // flag ID
    ldy #4
    cmp (_gStreamItemPtr),y      // gItems->flags (+4)
    ;jmp conditionCheck

conditionCheck
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

