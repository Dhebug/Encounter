;
; Bytestream module.
; This implement a kind of bytecode based scripting system with simple compact commands.
; This is not definitely not as fast as pure assembler, but it's much more compact
;
#include "params.h"
#include "game_enums.h"

    .zero 

_gCurrentStream             .dsb 2
_gCurrentStreamStop         .dsb 1   ; 1 = Stop stream / 2 = Wait / 4 = Stop stream and refresh the scene
_gDelayStream               .dsb 2
_gStreamCutScene            .dsb 1   ; 1 = In a cut scene
_gStreamSkipPoint           .dsb 2   ; Pointer to a label where we can jump if the user presses spaces during a cut scene

_gCurrentItem               .dsb 1   ; Used to handle the e_ITEM_CURRENT value, set by DispatchStream
_gStreamItemPtr             .dsb 2   ; Used to store the address of an item of interest (gItems+6*item id)
_gStreamAssociatedItemPtr   .dsb 2   ; associated item pointer, needs to be behind _gStreamItemPtr in memory
_gCurrentAssociatedItem     .dsb 1   ; Similar to _gCurrentItem but for containers

_gStreamLocationPtr         .dsb 2   ; Used to store the address of a location of interest (gLocations+10*location id)
_gStreamNextPtr             .dsb 2   ; Updated after the functions that prints stuff to know how long the string was 
_gStreamReturnPtr           .dsb 2   ; The ONE level of subfunction we are allowed to call using GOSUB and RETURN

    .text 

_ByteStreamCallbacks
    .word _ByteStreamCommand_END
    .word _ByteStreamCommand_RECTANGLE
    .word _ByteStreamCommand_FILL_RECTANGLE
    .word _ByteStreamCommand_TEXT
    .word _ByteStreamCommand_WHITE_BUBBLE
    .word _ByteStreamCommand_BLACK_BUBBLE
    .word _ByteStreamCommand_WAIT
    .word _ByteStreamCommand_BITMAP
    .word _ByteStreamCommand_FADE_BUFFER
    .word _ByteStreamCommand_JUMP
    .word _ByteStreamCommand_JUMP_IF_TRUE
    .word _ByteStreamCommand_JUMP_IF_FALSE
    .word _ByteStreamCommand_INFO_MESSAGE
    .word _ByteStreamCommand_DISPLAY_IMAGE
    .word _ByteStreamCommand_DISPLAY_IMAGE_ONLY
    .word _ByteStreamCommand_END_AND_REFRESH
    .word _ByteStreamCommand_ERROR_MESSAGE
    .word _ByteStreamCommand_SET_ITEM_LOCATION
    .word _ByteStreamCommand_SET_ITEM_FLAGS
    .word _ByteStreamCommand_UNSET_ITEM_FLAGS
    .word _ByteStreamCommand_SET_ITEM_DESCRIPTION
    .word _ByteStreamCommand_SET_LOCATION_DIRECTION
    .word _ByteStreamCommand_UNLOCK_ACHIEVEMENT
    .word _ByteStreamCommand_INCREASE_SCORE
    .word _ByteStreamCommand_GAME_OVER
    .word _ByteStreamCommand_CLEAR_FULL_TEXT_AREA
    .word _ByteStreamCommand_SET_SCENE_IMAGE
    .word _ByteStreamCommand_DISPLAY_IMAGE_NOBLIT
    .word _ByteStreamCommand_CLEAR_TEXT_AREA
    .word _ByteStreamCommand_GOSUB
    .word _ByteStreamCommand_RETURN
    .word _ByteStreamCommand_DO_ONCE
    .word _ByteStreamCommand_SET_CUTSCENE
    .word _ByteStreamCommand_PLAY_SOUND
    .word _ByteStreamCommand_WAIT_RANDOM
    .word _ByteStreamCommand_START_CLOCK
    .word _ByteStreamCommand_STOP_CLOCK
    .word _ByteStreamCommand_END_AND_PARTIAL_REFRESH
    .word _ByteStreamCommand_LOAD_MUSIC
    .word _ByteStreamCommand_STOP_MUSIC                  ; Implemented in akyplayer.s
    .word _ByteStreamCommand_WAIT_KEYPRESS               ; Implemented in keyboard.s -> Result in _gInputKey
    .word _ByteStreamCommand_QUICK_MESSAGE
    .word _ByteStreamCommand_SET_SKIP_POINT
    .word _ByteStreamCommand_SET_PLAYER_LOCATTION
    .word _ByteStreamCommand_SET_CURRENT_ITEM
    .word _ByteStreamCommand_COMMAND_CALL_NATIVE


; Checks if there's a stream delay active.
; If no delay is active, does nothing and returns zero
; If there's a delay, decrements it and returns 1
_DecrementDelayStream
.(
    lda _gDelayStream+0             ; Are we executing a WAIT command?
    ora _gDelayStream+1
    bne decrement
    rts                             ;  A contains zero value

decrement    
    lda _gDelayStream+0             ; Decrement and wait
    bne skip
    dec _gDelayStream+1
skip
    dec _gDelayStream+0
    lda #1
    rts
.)

; Loop that executes a stream stream.
; Handles the skipable cut scenes as well as timed delays (in numbers of frames)
_HandleByteStream
    ;jmp _HandleByteStream
.(
    jsr _DecrementDelayStream 
    bne end_stream                   ; Still decrementing the delay

    lda _gCurrentStream+0            ; Do we have a valid stream pointer?
    ora _gCurrentStream+1
    beq end_stream

    lda #<$a000                      ; By default, all the draw commands to to the screen
    sta _gDrawAddress+0
    lda #>$a000
    sta _gDrawAddress+1

    lda #0                           ; And we make sure we are in running mode
    sta _gCurrentStreamStop

loop_next_command                    ; Command loop
    jsr _ByteStreamGetNextByte       ; Fetch the next command id (increments the pointer, return the value in X and a)
    cpx #_COMMAND_COUNT              ; Is it a valid command?
    bcc valid_command
    jsr _Panic                       ; Probably corrupted stream, definitely not a valid command
valid_command
    
    asl                              ; Multiply the command id by 2...
    tax
    lda _ByteStreamCallbacks+0,x     ; ...and use it as an index in the command callbak table
    sta auto_callback+0
    lda _ByteStreamCallbacks+1,x
    sta auto_callback+1
auto_callback = *+1
    jsr $0000                        ; Call the function

    lda _gStreamCutScene             ; Is the cut scene mode enabled?
    beq check_stream_end

delay_stream_loop                    ; Delay loop
    jsr _DecrementDelayStream        ; Decrement the delay loop
    beq check_stream_end             ; Done

    jsr _WaitIRQ                     ; Wait one frame

    lda _gStreamSkipPoint+0           ; If we have a skip point and the keyboard is pressed, jump there immediately
    ora _gStreamSkipPoint+1           ; This is used to skip the intro sequence when reaching the market place.
    beq delay_stream_loop
    jsr _ReadKeyNoBounce
    beq delay_stream_loop

    lda _gStreamSkipPoint+0           ; Jump the stream to the skip point position
    sta _gCurrentStream+0
    lda _gStreamSkipPoint+1
    sta _gCurrentStream+1

    lda #0
    sta _gStreamSkipPoint+0           ; Clear the skip point
    sta _gStreamSkipPoint+1
    sta _gDelayStream+0
    sta _gDelayStream+1

check_stream_end
    lda _gCurrentStreamStop          ; Should we contine the execution of commands?
    beq loop_next_command            ; Can be triggered by END, WAIT, END_AND_REFRESH

end_stream    
    rts
.)

    
; _param0=pointer to the new byteStream
_PlayStreamAsm
.(
    lda _param0+0
    sta _gCurrentStream+0
    lda _param0+1
    sta _gCurrentStream+1
+_PlayStreamAsm_gCurrentStream
    lda #0
	sta _gDelayStream
    sta _gCurrentStreamStop
    sta _gStreamCutScene

loop
    jsr _WaitIRQ
    jsr _HandleByteStream        ; Eventually perform a delay if gDelayStream is set

    lda _gCurrentStreamStop
    and #FLAG_END_STREAM
    bne stream_stop

    lda _gCurrentStream+0
    bne loop
    lda _gCurrentStream+1
    bne loop
quit
    rts
stream_stop
    lda _gCurrentStreamStop
    and #FLAG_REFRESH_SCENE
    beq check_partial_refresh
    jmp _LoadScene
check_partial_refresh    
    lda _gCurrentStreamStop
    and #FLAG_PARTIAL_REFRESH
    beq quit
+_RefreshSceneInformation
    lda #16+4
    sta _param0
    jsr _ClearMessageWindowAsm
    jmp _PrintSceneInformation
.)


; _param0=id of the element we are searching for in the table
; _param1=pointer to a table with id:stream pointer
_DispatchStream
.(
    ; Store the item id into "CurrentItem"
    lda _param0
    sta _gCurrentItem

    ldy #0
search_loop    
    lda (_param1),y     ; Check the ID in the table
    iny
    cmp _param0         ; Does that match the ID we are looking for?
    beq found_it
    cmp #255            ; Or is it the end of the table?
    beq found_it

    iny                 ; Skip the callback/stream pointer
    iny
    jmp search_loop

found_it    
    lda (_param1),y     ; Copy the stream pointer to _param0
    sta _param0+0
    iny
    lda (_param1),y
    sta _param0+1

    jmp _PlayStreamAsm
.)


; _param0=id of the first element we are searching for in the table
; _param1=pointer to a table with id:stream pointer
; _param2=id of the second element we are searching for in the table
_DispatchStream2
.(
    ; Store the item id into "CurrentItem"
    lda _param0
    sta _gCurrentItem

    ldy #0
search_loop    
    lda (_param1),y     ; Get the first ID from the table
    iny
    tax                 ; Copy to X
    lda (_param1),y     ; Check the second in the table
    iny
    cmp #255            ; Is it the end of the table?
    beq found_it

    cpx _param0         ; Does that match the first ID we are looking for?
    bne no_match
    cmp _param2         ; Does that match the second ID we are looking for?
    bne no_match

found_it    
    lda (_param1),y     ; Copy the stream pointer to _param0
    sta _param0+0
    iny
    lda (_param1),y
    sta _param0+1

    jmp _PlayStreamAsm

no_match
    iny                 ; Skip the callback/stream pointer
    iny
    jmp search_loop
.)


; Fetch the value in _gCurrentStream, increment the pointer, return the value in X and a
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


_ByteStreamFetchLocationID
.(
    lda (_gCurrentStream),y      // location ID
    cmp #e_LOC_CURRENT
    bne keep_location_id
use_current_location_id    
    lda _gCurrentLocation        // Use the current location
keep_location_id    
    iny
    rts
.)


; Fetches the next byte from the stream and if matches e_ITEM_CURRENT replaces by _gCurrentItem
; Then uses the value to compute the _gStreamItemPtr pointer
_ByteStreamFetchItemID
.(
    lda (_gCurrentStream),y      // item ID
    cmp #e_ITEM_CURRENT
    bne keep_item_id
use_current_item_id    
    lda _gCurrentItem            // Use the current item
keep_item_id    
    iny
    ; fall-through into _ByteStreamComputeItemPtr
; A=Item ID
; Return a pointer on the item in _gStreamItemPtr
; sizeof(item) = 6
; 6 = 4n+2n = n<<2 + n<<1
+_ByteStreamComputeItemPtr
    stx tmp1
    ldx #0
    jsr _ByteStreamComputeItemPtrIndexX
    ldx tmp1
    rts

+_ByteStreamComputeItemPtrIndexX    
    // Item ID
    sta _gStreamItemPtr+0,x
    lda #0
    sta _gStreamItemPtr+1,x

    // x2
    asl _gStreamItemPtr+0,x
    rol _gStreamItemPtr+1,x

    // x4
    lda _gStreamItemPtr+0,x
    asl
    sta tmp0+0
    lda _gStreamItemPtr+1,x
    rol
    sta tmp0+1

    // x6
    clc
    lda _gStreamItemPtr+0,x
    adc tmp0+0
    sta _gStreamItemPtr+0,x
    lda _gStreamItemPtr+1,x
    adc tmp0+1
    sta _gStreamItemPtr+1,x

    // Item pointer
    clc
    lda _gStreamItemPtr+0,x
    adc #<_gItems
    sta _gStreamItemPtr+0,x
    lda _gStreamItemPtr+1,x
    adc #>_gItems
    sta _gStreamItemPtr+1,x
    rts
.)

; A=Refernce Item ID
; Return a pointer on the item in _gStreamItemPtr as well as _gStreamAssociatedItemPtr if there's an associated item (or a copy of it if not)
_ByteStreamComputeDualItemPtr
.(
    ; Fetch the first item
    jsr _ByteStreamComputeItemPtr
    ldy #3
    lda (_gStreamItemPtr),y      // gItems->associated_item (+3) = read associated_item id    
    cmp #255
    beq end_associated_item
    ldx #2
    jsr _ByteStreamComputeItemPtrIndexX
end_associated_item
.)




; A=Location ID
; Return a pointer on the location in _gStreamLocationPtr
; sizeof(location) = 8 
; 10 = 8n+2n = n<<3 + n<<1
_ByteStreamComputeLocationPtr
    // Location ID
    sta _gStreamLocationPtr+0
    lda #0
    sta _gStreamLocationPtr+1

    // x2
    asl _gStreamLocationPtr+0
    rol _gStreamLocationPtr+1

    // x4
    asl _gStreamLocationPtr+0
    rol _gStreamLocationPtr+1

    // x8
    asl _gStreamLocationPtr+0
    rol _gStreamLocationPtr+1

    // Item pointer
    clc
    lda _gStreamLocationPtr+0
    adc #<_gLocations
    sta _gStreamLocationPtr+0
    lda _gStreamLocationPtr+1
    adc #>_gLocations
    sta _gStreamLocationPtr+1

    rts


_ByteStreamCommand_END
.(
    lda #FLAG_END_STREAM   ; Stop
+_ByteStreamCommandEndWithStopCode
    sta _gCurrentStreamStop
    lda #0
	sta _gCurrentStream+0
    sta _gCurrentStream+1
	sta _gDelayStream
    rts
.)

; .byt COMMAND_END_AND_REFRESH
_ByteStreamCommand_END_AND_REFRESH
.(
    ;jmp _ByteStreamCommandEndAndRefresh
    lda #FLAG_END_STREAM|FLAG_REFRESH_SCENE   ; Stop and refresh scene
    bne _ByteStreamCommandEndWithStopCode
.)


; .byt COMMAND_END_AND_PARTIAL_REFRESH
_ByteStreamCommand_END_AND_PARTIAL_REFRESH
.(
    ;jmp _ByteStreamCommandEndAndRefresh
    lda #FLAG_END_STREAM|FLAG_PARTIAL_REFRESH   ; Stop and refresh the scene information (ie: we don't run all the image loading)
    bne _ByteStreamCommandEndWithStopCode
.)


; .byt COMMAND_WAIT,duration
_ByteStreamCommand_WAIT
.(
    ; In theory the delay could be 8 or 16 bits based on the value, but the code does not use that at the moment
    jsr _ByteStreamGetNextByte
    stx _gDelayStream+0
 
    ; If we are in a cutscene we don't count WAIT instructions as a way to go back to gameplay
    lda _gStreamCutScene
    bne end_stream_stop
    lda #FLAG_WAIT
    sta _gCurrentStreamStop
end_stream_stop    
    rts
.)


;.byt COMMAND_WAIT_RANDOM,base_duration,rand_mask
_ByteStreamCommand_WAIT_RANDOM
.(
    ; In theory the delay could be 8 or 16 bits based on the value, but the code does not use that at the moment
    jsr _ByteStreamGetNextByte
    stx _gDelayStream+0

    ; Call the internal 32 bit randomize function, result is in _randseedLow+0/+1/+2/+3
    jsr _rand32
    jsr _ByteStreamGetNextByte
    txa
    and _randseedLow+0
    clc
    adc _gDelayStream+0
    sta _gDelayStream+0
    
    ; If we are in a cutscene we don't count WAIT instructions as a way to go back to gameplay
    lda _gStreamCutScene
    bne end_stream_stop
    lda #FLAG_WAIT
    sta _gCurrentStreamStop
end_stream_stop    
    rts
.)


_ByteStreamCommand_FADE_BUFFER
    jmp _BlitBufferToHiresWindow


; We can only use GOSUB once, and then we need to RETURN
; Multiple level of GOSUB are not supported, and calling another stream while we are in a GOSUB will probably cause havok
 _ByteStreamCommand_GOSUB
    ; Store the current pointer+2 into the return register
    clc
    lda _gCurrentStream+0
    adc #2
    sta _gStreamReturnPtr+0
    lda _gCurrentStream+1
    adc #0
    sta _gStreamReturnPtr+1

    ; Then overwrite the current stream pointer with the one provided in the GOSUB instruction parameters
    ldy #0
    lda (_gCurrentStream),y
    tax                           ; Temporary so we don't change the stream pointer while using it
    iny
    lda (_gCurrentStream),y
    stx _gCurrentStream+0
    sta _gCurrentStream+1
    rts


; We can only use RETURN if GOSUB has been called before
 _ByteStreamCommand_RETURN
    lda _gStreamReturnPtr+0
    sta _gCurrentStream+0
    lda _gStreamReturnPtr+1
    sta _gCurrentStream+1
    rts


; .byt COMMAND_SET_CUT_SCENE,flag
_ByteStreamCommand_SET_CUTSCENE
.(
    ldy #0
    lda (_gCurrentStream),y       ; Get the cut scene flag
    sta _gStreamCutScene
    lda #1
    jmp _ByteStreamMoveByA
.)

; param0.ptr=registerList;asm("jsr _PlaySoundAsm"); }
; .byt COMMAND_PLAY_SOUND,<sound,>sound
_ByteStreamCommand_PLAY_SOUND
.(
    lda _gSoundEnabled
    beq no_sound

    ldy #0
    lda (_gCurrentStream),y       ; Get the sound file address (low byte)
    sta _param0+0
    iny
    lda (_gCurrentStream),y       ; Get the sound file address (high byte)
    sta _param0+1
    jsr _PlaySoundAsm

no_sound    
    lda #2
    jmp _ByteStreamMoveByA
.)


; .byt COMMAND_LOAD_MUSIC,musicId
_ByteStreamCommand_LOAD_MUSIC
.(
	; unsigned char loaderId = *gCurrentStream++;
    jsr _ByteStreamGetNextByte
    cpx _gCurrentMusicFileIndex
    beq music_already_loaded             ; We only load the music if it's not already the one in memory
    
    ; Load the requested bitmap
    stx _gCurrentMusicFileIndex
    stx _LoaderApiEntryIndex
    lda #<_ArkosMusic
    sta _LoaderApiAddressLow
    lda #>_ArkosMusic
    sta _LoaderApiAddressHigh
    jsr _LoadApiLoadFileFromDirectory    

music_already_loaded
    lda _gMusicEnabled
    beq no_music
    lda #1+2+4+8+16+32        ; All the three channels are used
    sta _MusicMixerMask
    lda #<_ArkosMusic
    sta _param0+0
    lda #>_ArkosMusic
    sta _param0+1
    jmp _StartMusic
no_music
    rts    
.)



; .byt COMMAND_DO_ONCE,1,<label,>label
_ByteStreamCommand_DO_ONCE
.(
    ldy #0
    lda (_gCurrentStream),y       ; Get the counter
    bne not_done
    iny
    lda (_gCurrentStream),y       ; Script address
    tax                           ; Temporary so we don't change the stream pointer while using it
    iny
    lda (_gCurrentStream),y
    stx _gCurrentStream+0
    sta _gCurrentStream+1
    rts
not_done    
    tax                            ; Decrement the counter
    dex
    txa
    sta (_gCurrentStream),y        ; Write down the counter
    lda #3                         ; Skip counter and address
    jmp _ByteStreamMoveByA
.)


; .byt COMMAND_SET_SKIP_POINT,<label,>label
_ByteStreamCommand_SET_SKIP_POINT
.(
    jsr _ByteStreamGetNextByte
    stx _gStreamSkipPoint+0
    jsr _ByteStreamGetNextByte
    stx _gStreamSkipPoint+1
    rts
.)


; .byt COMMAND_CALL_NATIVE,<address,>address
_ByteStreamCommand_COMMAND_CALL_NATIVE
.(
    ; Fetch the native routine address
    jsr _ByteStreamGetNextByte
    sta _auto_jmp+0
    jsr _ByteStreamGetNextByte
    sta _auto_jmp+1

    ; jmp to it
_auto_jmp = *+1    
    jmp $1234
.)



; .byt COMMAND_JUMP_IF_TRUE,<label,>label,expression
_ByteStreamCommand_JUMP_IF_TRUE
    lda #OPCODE_BEQ                          // F0
    bne common
_ByteStreamCommand_JUMP_IF_FALSE
    lda #OPCODE_BNE                          // D0
common
.(
    sta _auto_conditionCheckItemLocation+0
    sta _auto_conditionCheckPlayerLocation+0
    sta _auto_conditionCheckItemContainer+0
    sta _auto_conditionCheckAdressValue+0
    eor #OPCODE_BEQ-OPCODE_BNE               //  0b100000
    sta _auto_conditionCheckItemFlag+0       // Item flags check is inverted
    ldy #2
    lda (_gCurrentStream),y
    bne checkItemFlag

checkItemLocation                // OPERATOR_CHECK_ITEM_LOCATION 0 
    ; check =  (gItems[itemId].location == locationId);
    iny
    jsr _ByteStreamFetchItemID
    jsr _ByteStreamFetchLocationID // location id
    ldy #2
    cmp (_gStreamItemPtr),y      // gItems->location (+2)
_auto_conditionCheckItemLocation
    bne _ByteStreamCommand_JUMP   // BNE/BEQ depending of the command
    jmp _ByteStreamMoveBy5

checkPlayerLocation              // OPERATOR_CHECK_PLAYER_LOCATION 2 
    ; check =  (gItems[itemId].location == locationId);
    iny
    jsr _ByteStreamFetchLocationID // location id
    ldy #2
    cmp _gCurrentLocation         // Player position
_auto_conditionCheckPlayerLocation    
    bne _ByteStreamCommand_JUMP   // BNE/BEQ depending of the command
    lda #4
    jmp _ByteStreamMoveByA

; .byt COMMAND_JUMP,<label,>label
+_ByteStreamCommand_JUMP
    ldy #0
    lda (_gCurrentStream),y
    tax                           ; Temporary so we don't change the stream pointer while using it
    iny
    lda (_gCurrentStream),y
    stx _gCurrentStream+0
    sta _gCurrentStream+1
    rts

checkItemContainer
    ; check =  (gItems[itemId].flags & flagId);
    iny
    jsr _ByteStreamFetchItemID
    lda (_gCurrentStream),y      // flag ID
    ldy #3
    cmp (_gStreamItemPtr),y      // gItems->associated_item (+3)
_auto_conditionCheckItemContainer
    bne _ByteStreamCommand_JUMP   // BNE/BEQ depending of the command
    jmp _ByteStreamMoveBy5

checkItemFlag                    // OPERATOR_CHECK_ITEM_FLAG 1
    cmp #OPERATOR_CHECK_PLAYER_LOCATION
    beq checkPlayerLocation
    cmp #OPERATOR_CHECK_ITEM_CONTAINER
    beq checkItemContainer
    cmp #OPERATOR_CHECK_ADDRESS_VALUE
    beq checkAdressValue
    ; check =  (gItems[itemId].flags & flagId);
    iny
    jsr _ByteStreamFetchItemID
    lda (_gCurrentStream),y      // flag ID
    ldy #4
    and (_gStreamItemPtr),y      // gItems->flags (+4)
_auto_conditionCheckItemFlag
    bne _ByteStreamCommand_JUMP   // BNE/BEQ depending of the command

+_ByteStreamMoveBy5    ; Continue (jump not taken)
    lda #5
+_ByteStreamMoveByA    
    clc 
    adc _gCurrentStream+0
    sta _gCurrentStream+0
    lda _gCurrentStream+1
    adc #0
    sta _gCurrentStream+1
    rts

checkAdressValue                 // OPERATOR_CHECK_ADDRESS_VALUE,<address,>address,value
    ; check =  (*address == value);
    iny
    lda (_gCurrentStream),y      // <address
    sta _auto_cmp+0
    iny
    lda (_gCurrentStream),y      // >address
    sta _auto_cmp+1
    iny
    lda (_gCurrentStream),y      // value
_auto_cmp = *+1    
    cmp $1234
_auto_conditionCheckAdressValue
    bne _ByteStreamCommand_JUMP   // BNE/BEQ depending of the command
    lda #6
    jmp _ByteStreamMoveByA
.)


; .byt COMMAND_SET_PLAYER_LOCATION,location
_ByteStreamCommand_SET_PLAYER_LOCATTION
.(
    jsr _ByteStreamGetNextByte
    stx _gCurrentLocation
    rts
.)


; Can be used to change in a script what the current item is (by default that is set to the item that triggered the script)
; .byt COMMAND_SET_CURRENT_ITEM,item
_ByteStreamCommand_SET_CURRENT_ITEM
.(
    jsr _ByteStreamGetNextByte
    stx _gCurrentItem
    rts
.)


; Can be used to set the location of any item
; .byt COMMAND_SET_ITEM_LOCATION,item,location
_ByteStreamCommand_SET_ITEM_LOCATION
.(
    ldy #0
    jsr _ByteStreamFetchItemID
    lda (_gCurrentStream),y      // location id
    cmp #e_LOC_CURRENT
    bne store_location
    lda _gCurrentLocation        // Use the current player location
store_location    
    ldy #2
    sta (_gStreamItemPtr),y      // gItems->location (+2) = location id
    sta tmp1                     // Save the location in tmp1 (tmp0 is modified by _ByteStreamComputeItemPtr)    
    
    ; If the item is in a container and the location is not the inventory, we need to empty it
    cmp #e_LOC_INVENTORY
    beq end_container
    iny
    lda (_gStreamItemPtr),y      // gItems->associated_item (+3) = read associated_item id    
    cmp #255
    beq end_container
    pha
    lda #255
    sta (_gStreamItemPtr),y      // gItems->associated_item (+3) = clear associated_item id in item  
    pla
    jsr _ByteStreamComputeItemPtr  // Get the container pointer
    lda #255
    sta (_gStreamItemPtr),y      // gItems->associated_item (+3) = clear associated_item id  in container
    iny
    lda (_gStreamItemPtr),y      // gItems->flags (+4) = read flags
    and #ITEM_FLAG_IS_CONTAINER
    bne end_container            // If the associated object is a container, it stays where it is
    ldy #2
    lda tmp1                     // Reload the saved location so the transported items don't stay in the inventory
    sta (_gStreamItemPtr),y      // gItems->location (+2) = location id
end_container   
    
    lda #2
    jmp _ByteStreamMoveByA
.)

// .byt COMMAND_SET_ITEM_FLAGS,item,flags
 _ByteStreamCommand_SET_ITEM_FLAGS
 .(
    ldy #0
    jsr _ByteStreamFetchItemID
    lda (_gCurrentStream),y      // flag mask
    ldy #4                       
    ora (_gStreamItemPtr),y      // gItems->flags (+4) |= flag mask
    sta (_gStreamItemPtr),y      // gItems->flags (+4) |= flag mask

    lda #2
    jmp _ByteStreamMoveByA
 .)

; .byt COMMAND_UNSET_ITEM_FLAGS,item,flags
 _ByteStreamCommand_UNSET_ITEM_FLAGS
 .(
    ldy #0
    jsr _ByteStreamFetchItemID
    lda (_gCurrentStream),y      // flag mask
    ldy #4                       
    and (_gStreamItemPtr),y      // gItems->flags (+4) &= flag mask
    sta (_gStreamItemPtr),y      // gItems->flags (+4) |= flag mask

    lda #2
    jmp _ByteStreamMoveByA
 .)

; .byt COMMAND_SET_ITEM_DESCRIPTION,item,description,0
_ByteStreamCommand_SET_ITEM_DESCRIPTION
.(
    ldy #0
    jsr _ByteStreamFetchItemID
    lda #1
    jsr _ByteStreamMoveByA

    ldy #0
    lda _gCurrentStream+0
    sta (_gStreamItemPtr),y      // gItems->description (+0) = <_gCurrentStream
    iny
    lda _gCurrentStream+1
    sta (_gStreamItemPtr),y      // gItems->description (+1) = >_gCurrentStream

+FindNullTerminator
    ; Find the null terminator
    ldy #0
search_loop
    lda (_gCurrentStream),y      // item ID
    beq found_zero
    iny
    bne search_loop

found_zero
    iny
    tya

    jmp _ByteStreamMoveByA
.)



; .byt COMMAND_SET_SCENE_IMAGE,imageId
_ByteStreamCommand_SET_SCENE_IMAGE
.(
    ldy #0
    lda (_gCurrentStream),y      // Image ID
    sta _gSceneImage

    ; TODO: In theory should implement that so we don't have double loading
    ;LoadFileAt(gSceneImage,ImageBuffer);	
    lda _gSceneImage:sta _LoaderApiEntryIndex
    lda #<_ImageBuffer:sta _LoaderApiAddressLow
    lda #>_ImageBuffer:sta _LoaderApiAddressHigh
    jsr _LoadApiLoadFileFromDirectory

    lda #1
    jmp _ByteStreamMoveByA
.)


;                                     +0       +1        +2
; .byt COMMAND_SET_LOCATION_DIRECTION,location,direction,value
_ByteStreamCommand_SET_LOCATION_DIRECTION
.(
    ldy #0
    lda (_gCurrentStream),y      // location ID
    jsr _ByteStreamComputeLocationPtr

    iny
    lda (_gCurrentStream),y      // Direction to update
    sta tmp0

    iny
    lda (_gCurrentStream),y      // New value for this direction

    ldy tmp0
    sta (_gStreamLocationPtr),y  // _gStreamLocationPtr->directions[requested direction] (+0) = new value

    jsr _PrintSceneDirections

    lda #3
    jmp _ByteStreamMoveByA
.)



; .byt COMMAND_UNLOCK_ACHIEVEMENT,achievement
_ByteStreamCommand_UNLOCK_ACHIEVEMENT
.(
    ldy #0
    lda (_gCurrentStream),y             // Achievement value
    sta _param0
    jsr _UnlockAchievementAsm

    lda #1
    jmp _ByteStreamMoveByA
.)

; .byt COMMAND_INCREASE_SCORE,<points,>points
_ByteStreamCommand_INCREASE_SCORE
.(
    clc

    ldy #0
    lda (_gCurrentStream),y             // Number of points (low)
    adc _gScore+0                       // Add to existing score
    sta _gScore+0
    lda #0
    sta (_gCurrentStream),y             // Resets the score value to make sure we don't give points twice if the command is called twice

    iny
    lda (_gCurrentStream),y             // Number of points (high)
    adc _gScore+1
    sta _gScore+1
    lda #0
    sta (_gCurrentStream),y             // Resets the score value to make sure we don't give points twice if the command is called twice

    lda #2
    jmp _ByteStreamMoveByA
.)


; .byt COMMAND_GAME_OVER,condition
_ByteStreamCommand_GAME_OVER
.(
    ldy #0
    lda (_gCurrentStream),y             // Gameover condition
    sta _gGameOverCondition

    jsr _StopClock                      // Also stop the clock to be fair to the player

    lda #1
    jmp _ByteStreamMoveByA
.)

; .byt COMMAND_START_CLOCK
_ByteStreamCommand_START_CLOCK
    jmp _StartClock

; .byt COMMAND_STOP_CLOCK
_ByteStreamCommand_STOP_CLOCK
    jmp _StopClock



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


_ByteStreamCommand_RECTANGLE
    jsr _ByteStreamCommandFetchRectangleData
	jmp _DrawFilledRectangle


_ByteStreamCommand_FILL_RECTANGLE
    jsr _ByteStreamCommandFetchRectangleData
	jmp _DrawFilledRectangle


_ByteStreamCommand_TEXT
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
; _param1=color
_PrintStatusMessageNextLineAsm
    clc
    lda _gStatusMessageLocation+0
    adc #40
    sta tmp0+0
    sta tmp1+0
    lda _gStatusMessageLocation+1
    adc #0
    sta tmp0+1
    sta tmp1+1
    jmp _PrintStatusMessageAddr

_PrintStatusMessageAsm
    ;rts
    ;jmp _PrintStatusMessageAsm
.(
    ; char* ptrScreen=(char*)0xbb80+40*22;
    lda _gStatusMessageLocation+0
    sta tmp0+0
    sta tmp1+0
    lda _gStatusMessageLocation+1
    sta tmp0+1
    sta tmp1+1
+_PrintStatusMessageAddr
    ; Write the color code
    ldy #1
    lda _param1
    sta (tmp0),y
    sta (tmp1),y

    ; Clear the rest of the line
    lda #32
loop_clear
    iny
    sta (tmp0),y
    sta (tmp1),y
    cpy #39
    bne loop_clear

    ; Write the message
    clc
    lda tmp0+0
    adc #2
    sta tmp0+0
    lda tmp0+1
    adc #0
    sta tmp0+1

    clc
    lda tmp1+0
    adc #2
    sta tmp1+0
    lda tmp1+1
    adc #0
    sta tmp1+1

    ldy #0
loop_message    
    lda (_param0),y
    beq end_message
    sta (tmp0),y
    sta (tmp1),y
    iny
    jmp loop_message
end_message    
    ; Adjust the pointer to the next position (_param0+y+1)
    jmp _Adjust_gStreamNextPtr
.)


; _param0+0/+1=pointer to message
_PrintInformationMessageAsm
.(
    ; Set the color
    lda #3
    sta _param1

    ; Print the message
    jsr _PrintStatusMessageAsm

    ; Wait a bit after the message is displayed
    jmp _WaitAfterMessage
.)


; _param0+0/+1=pointer to message
_PrintErrorMessageShortAsm
.(
    ; Set a short delay
    lda #50
    pha 
    jmp print_error_common
+_PrintErrorMessageAsmAX    
    sta _param0+0
    stx _param0+1
+_PrintErrorMessageAsm
    jsr _PlayErrorSound

    lda _param0+0
    sta _gCurrentStream+0
    lda _param0+1
    sta _gCurrentStream+1
    jsr _ByteStreamCommand_ERROR_MESSAGE

    lda #0
	sta _gCurrentStream+0
    sta _gCurrentStream+1

    jmp _RefreshSceneInformation

print_error_common
    ; Set the color
    lda #1
    sta _param1

    ; Print the message
    jsr _PrintStatusMessageNextLineAsm

    ; Play a 'Ping' sound
    jsr _PlayErrorSound

    ; Wait a bit after the message is displayed
    pla 
    jmp _WaitAfterMessageCommon
.)

_LongWaitAfterMessage
.(
    lda #150
    bne _WaitAfterMessageCommon
+_ShortWait
    lda #12
    bne _WaitAfterMessageCommon
+_WaitAfterMessage
    ; Wait 75 frames
    lda #75
+_WaitAfterMessageCommon    
    sta _param0+0
    lda #0
    sta _param0+1

    jmp _WaitFramesAsm
.)

; QUICK_MESSAGE has no pause
; INFO_MESSAGE has the standard 75 frame, and is generally followed by WAIT(50*2), total = 175 frames

; Uses _gCurrentStream and _gStreamNextPtr
; .byt COMMAND_INFO_MESSAGE,message,0
_ByteStreamCommand_INFO_MESSAGE
.(
    jsr _ByteStreamCommand_QUICK_MESSAGE

    ; Wait a bit after the message is displayed
    jmp _LongWaitAfterMessage
.)

; .byt COMMAND_QUICK_MESSAGE,message,0
_ByteStreamCommand_QUICK_MESSAGE
.(
    ; PrintInformationMessage(gCurrentStream);    // Should probably return the length or pointer to the end of string
    ; _param0+0/+1=pointer to message (stored in gCurrentStream)
    lda _gCurrentStream+0
    sta _param0+0
    lda  _gCurrentStream+1
    sta _param0+1

    ; Set the double height attribute
    lda #10
    sta _param1

    ; Set a different screen location for the big messages
    lda #<($bb80+40*20)
    sta tmp0+0
    lda #>($bb80+40*20)
    sta tmp0+1
    lda #<($bb80+40*21)
    sta tmp1+0
    lda #>($bb80+40*21)
    sta tmp1+1
    
    jsr _PrintStatusMessageAddr

    ; gCurrentStream += strlen(gCurrentStream)+1;
    lda _gStreamNextPtr+0
    sta _gCurrentStream+0
    lda _gStreamNextPtr+1
    sta _gCurrentStream+1
    rts
.)


; PrintErrorMessage(gTextAGenericWhiteBag);    // "It's just a white generic bag"
; Uses _gCurrentStream and _gStreamNextPtr
_ByteStreamCommand_ERROR_MESSAGE
.(
    ; Make the window purple
    lda #16+5
    sta _param0
    jsr _ClearMessageWindowAsm            ; Clear X

    jmp _ByteStreamCommand_INFO_MESSAGE
.)


; _param0=paper color
_ClearMessageAndInventoryWindow
.(
    ldx #1+23+4-18-1
    jmp common_bit
+_ClearMessageWindowAsmX
    stx _param0+0
+_ClearMessageWindowAsm
    ldx #1+23-18-1
common_bit
    ; Pointer to first line of the "window"
    lda #<$bb80+40*17
    sta tmp0+0
    lda #>$bb80+40*17
    sta tmp0+1

    ; Top fluff
    lda _param0
    and #7          ; Ink color
    ldy #0
    sta (tmp0),y
    iny
    lda #"/"
    sta (tmp0),y
    iny
    lda #127
loop_top_fluff    
    sta (tmp0),y
    iny
    cpy #38
    bne loop_top_fluff
    lda #"\"
    sta (tmp0),y

    ; Then start painting the bit area
    jsr _Add40ToTmp0

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
    jsr _Add40ToTmp0

    dex
    bne loop_line

    ; Bottom fluff
    lda _param0
    and #7          ; Ink color
    ldy #0
    sta (tmp0),y
    iny
    lda #"<"
    sta (tmp0),y
    iny
    lda #"="
loop_bottom_fluff    
    sta (tmp0),y
    iny
    cpy #38
    bne loop_bottom_fluff
    lda #"#"
    sta (tmp0),y
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
; .byt COMMAND_FULLSCREEN_ITEM,imagedId,description,0
_ByteStreamCommand_DISPLAY_IMAGE
.(
    jsr _ByteStreamCommand_DISPLAY_IMAGE_NOBLIT
    ; BlitBufferToHiresWindow();
    jmp _BlitBufferToHiresWindow
.)

_ByteStreamCommand_DISPLAY_IMAGE_ONLY
.(
    jsr _ByteStreamCommand_DISPLAY_IMAGE_NO_CLEAR_TEXT
    jmp _BlitBufferToHiresWindow
.)    

; .byt COMMAND_FULLSCREEN_ITEM_NOBLIT,imagedId,description,0
_ByteStreamCommand_DISPLAY_IMAGE_NOBLIT
.(  
    ; _param0=paper color
    ; ClearMessageWindow(16+4);
    lda #16+4
    sta _param0+0
    jsr _ClearMessageWindowAsm
+_ByteStreamCommand_DISPLAY_IMAGE_NO_CLEAR_TEXT
	; unsigned char loaderId = *gCurrentStream++;
    ; LoadFileAt(loaderId,ImageBuffer);
    jsr _ByteStreamGetNextByte
    stx _LoaderApiEntryIndex
    lda #<_ImageBuffer
    sta _LoaderApiAddressLow
    lda #>_ImageBuffer
    sta _LoaderApiAddressHigh
    jsr _LoadApiLoadFileFromDirectory
    rts
.)


; .byt COMMAND_CLEAR_TEXT_AREA,16+(paper_color&7)
_ByteStreamCommand_CLEAR_TEXT_AREA
.(
    ; _param0=paper color
    ; ClearMessageWindow(16+4);
    jsr _ByteStreamGetNextByte
    stx _param0+0
    jmp _ClearMessageWindowAsm
.)


; .byt COMMAND_CLEAR_FULL_TEXT_AREA,16+(paper_color&7)
_ByteStreamCommand_CLEAR_FULL_TEXT_AREA
.(
    ; _param0=paper color
    ; ClearMessageWindow(16+4);
    jsr _ByteStreamGetNextByte
    stx _param0+0
    jmp _ClearMessageAndInventoryWindow
.)


; .byt COMMAND_BITMAP,imageId,w,h,stride
_ByteStreamCommand_BITMAP
.( 
	; unsigned char loaderId = *gCurrentStream++;
    jsr _ByteStreamGetNextByte
    cpx _gCurrentSpriteSheetIndex
    beq image_already_loaded             ; We only load the image if it's not already the one in memory
    
    ; Load the requested bitmap
    stx _gCurrentSpriteSheetIndex
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

    lda #ATTRIBUTE_HIRES   ; Make the attribute appear black until we need to change it to white (in which case we need to apply |128 to it)
    sta $bb80+40*0  	   ; Switch to HIRES, using video inverse to keep the 6 pixels white

    lda #ATTRIBUTE_TEXT
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
    MEMCPY_JMP(_MemCpy_B800_0_7DigitDisplay)
.)



_BubblesWidth .dsb MAX_BUBBLE       ; TODO: Should adjust and check based on the max number of bubbles


 _ByteStreamCommand_WHITE_BUBBLE
    ldx #64                        ; White on Black Color pattern
    bne draw_bubble
 _ByteStreamCommand_BLACK_BUBBLE
    ldx #127                       ; White on Black Color pattern
draw_bubble
.(
_count         = reg4
_coordinates   = reg5
tmpCount       = reg6

    stx _gDrawPattern

    jsr _ByteStreamGetNextByte     ; Number of bubbles 
    stx _count                     ; Should not exceed the size of _BubblesWidth

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
    ; Store the value
    lda _param1+0
    ldx tmpCount
    sta _BubblesWidth-1,x

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

    ; Iterate over the string
loop_compute_size
    jsr _ByteStreamGetNextByte
    bne loop_compute_size

    ; Restore the computed width
    ldx tmpCount
    sec
    lda _BubblesWidth-1,x
    sbc #2
    sta _gDrawWidth

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

