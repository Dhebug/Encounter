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

