
#include "params.h"

    .zero

_SoundDataPointer 	.dsb 2
_SoundRoutineTmp    .dsb 2

    .text

_PsgVirtualRegisters
_PsgfreqA 		.byt 0,0    ;  0 1    Chanel A Frequency
_PsgfreqB		.byt 0,0    ;  2 3    Chanel B Frequency
_PsgfreqC		.byt 0,0    ;  4 5    Chanel C Frequency
_PsgfreqNoise	.byt 0      ;  6      Chanel sound generator
_Psgmixer		.byt 0      ;  7      Mixer/Selector
_PsgvolumeA		.byt 0      ;  8      Volume A
_PsgvolumeB		.byt 0      ;  9      Volume B
_PsgvolumeC		.byt 0      ; 10      Volume C
_PsgfreqShape   .byt 0,0    ; 11 12   Wave period
_PsgenvShape    .byt 0      ; 13      Wave form

_PsgNeedUpdate  .byt 0

_PsgPlayPosition        .byt SOUND_NOT_PLAYING
_PsgPlayLoopCount	    .dsb 10      ; 10 levels of loops
_PsgPlayLoopPosition    .dsb 10      ; 10 levels of loops
_PsgPlayLoopIndex	    .byt 255     ; No loop defined

    .text


SoundUpdateHighSpeed
.(
read_command
    ldy _PsgPlayPosition
    cpy #SOUND_NOT_PLAYING                   ; Playing anything?
    beq end_replay

    lda (_SoundDataPointer),y                ; Read the next command
    iny                                      ; Increment the pointer
    cmp #SOUND_COMMAND_END
    beq CommandEndSound
    cmp #SOUND_COMMAND_END_FRAME
    beq CommandEndFrame
    cmp #SOUND_COMMAND_SET_BANK
    beq CommandSetBank
    cmp #SOUND_COMMAND_SET_VALUE
    beq CommandSetValue
    cmp #SOUND_COMMAND_ADD_VALUE
    beq CommandAddValue
    cmp #SOUND_COMMAND_REPEAT
    beq CommandLoopStart
    cmp #SOUND_COMMAND_ENDREPEAT
    beq CommandLoopEnd

    ; If we reach here, it means we got some corrupted data
    jsr _Panic

end_replay	
    rts

CommandEndSound
    ldy #SOUND_NOT_PLAYING      ; Finishes the sound
CommandEndFrame
    sty _PsgPlayPosition        ; Save the new command position
    rts	

CommandSetBank
    ldx #0
copy_bank
    lda (_SoundDataPointer),y
    iny
    sta _PsgVirtualRegisters,x
    inx
    cpx #14
    bne copy_bank
    sty _PsgPlayPosition        ; Save the new command position
    lda #2
    sta _PsgNeedUpdate
    ;jsr SendBankToPsg           ; Sent all the sounds to the YM
    jmp read_command

CommandAddValue
    lda (_SoundDataPointer),y    ; Register to change
    iny
    sta _SoundRoutineTmp+0
    lda (_SoundDataPointer),y    ; Register value
    iny
    sta _SoundRoutineTmp+1
    sty _PsgPlayPosition        ; Save the new command position

    ; Add the value to the virtual register (faster than reading the PSG internals)
    ldy _SoundRoutineTmp+0
    lda _PsgVirtualRegisters,y
    clc
    adc _SoundRoutineTmp+1
    sta _PsgVirtualRegisters,y
    tax

    ; Update the real register
    jsr _PsgSetRegister			 ; y=register number, x=register value

    jmp read_command
        
CommandSetValue
    lda (_SoundDataPointer),y    ; Register to change
    iny
    sta _SoundRoutineTmp+0
    lda (_SoundDataPointer),y    ; Register value
    iny
    sta _SoundRoutineTmp+1
    sty _PsgPlayPosition        ; Save the new command position

    ; Set the value to the virtual register
    ldy _SoundRoutineTmp+0
    lda _SoundRoutineTmp+1
    sta _PsgVirtualRegisters,y
    tax

    ; Update the real register
    jsr _PsgSetRegister			 ; y=register number, x=register value

    jmp read_command

CommandLoopStart
    inc _PsgPlayLoopIndex
    ldx _PsgPlayLoopIndex       ; 0 is the first valid loop index

    lda (_SoundDataPointer),y   ; Loop count
    iny
    sty _PsgPlayPosition        ; Save the new command position
    sta _PsgPlayLoopCount,x     ; Save the number of iterations to perform
    tya
    sta _PsgPlayLoopPosition,x  ; Save the looping position
    jmp read_command

CommandLoopEnd
    ldx _PsgPlayLoopIndex       ; 0 is the first valid loop index
    dec _PsgPlayLoopCount,x     ; One more iteration
    beq end_loop
    ldy _PsgPlayLoopPosition,x  ; Load the looping position
    sty _PsgPlayPosition        ; Save the new command position
    jmp read_command
end_loop
    dec _PsgPlayLoopIndex
    sty _PsgPlayPosition        ; Save the new command position
    jmp read_command
.)

; Update the sound generator
SoundUpdate50hz    
.(
    lda _PsgNeedUpdate
    beq skip_update

    and #1
    sta _PsgNeedUpdate

    lda _Psgmixer
    ora #%11000000
    sta _Psgmixer

    ldy #0
register_loop
    ldx	_PsgVirtualRegisters,y

    ; y=register number
    ; x=value to write
    jsr _PsgSetRegister

    iny
    cpy #14
    bne register_loop
skip_update	
rts
.)


; y=register number
; x=value to write
_PsgSetRegister
.(
    sty	via_porta
    txa

    pha
    lda	via_pcr
    ora	#$EE		; $EE	238	11101110
    sta	via_pcr

    and	#$11		; $11	17	00010001
    ora	#$CC		; $CC	204	11001100
    sta	via_pcr

    tax
    pla
    sta	via_porta
    txa
    ora	#$EC		; $EC	236	11101100
    sta	via_pcr

    and	#$11		; $11	17	00010001
    ora	#$CC		; $CC	204	11001100
    sta	via_pcr

    rts
.)


_PsgStopSound
.(
    lda #0
    sta _PsgvolumeA
    sta _PsgvolumeB
    sta _PsgvolumeC
    lda #1
    sta _PsgNeedUpdate
    rts
.)

; A FREQ (LOW|HIGH), B FREQ (LOW|HIGH), C FREQ (LOW|HIGH), N FREQ, CONTROL, A VOL, B VOL, C VOL, ENV (LOW|HIGH)
;                                           0   1   2   3   4   5   6   7   8   9   10  11  12  13
_ExplodeData    .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$1F,$07,$10,$10,$10,$00,$18,$00,SOUND_COMMAND_END
_ShootData      .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$0F,$07,$10,$10,$10,$00,$08,$00,SOUND_COMMAND_END
_PingData       .byt SOUND_COMMAND_SET_BANK,$18,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$00,$0F,$00,SOUND_COMMAND_END
_KeyClickHData  .byt SOUND_COMMAND_SET_BANK,$1F,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$1F,$00,$00,SOUND_COMMAND_END
_KeyClickLData  .byt SOUND_COMMAND_SET_BANK,$2F,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$1F,$00,$00,SOUND_COMMAND_END

_ZapData        .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$00,$3E,$0F,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_REPEAT,40
                .byt SOUND_COMMAND_ADD_VALUE,0,2,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_ENDREPEAT			
                .byt SOUND_COMMAND_SET_VALUE,8,0,SOUND_COMMAND_END       ; Finally set the volume to 0
                .byt SOUND_COMMAND_END

// 200 hz version
_TypeWriterData .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$05,%11110111,$03,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$04,SOUND_COMMAND_SET_VALUE,$08,$05,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$03,SOUND_COMMAND_SET_VALUE,$08,$0f,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$02,SOUND_COMMAND_SET_VALUE,$08,$0D,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$01,SOUND_COMMAND_SET_VALUE,$08,$0a,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$01,SOUND_COMMAND_SET_VALUE,$08,$07,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,8,0,SOUND_COMMAND_END                    ; Finally set the volume to 0
                .byt SOUND_COMMAND_END

_SpaceBarData   .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$08,%11110111,$03,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$0a,SOUND_COMMAND_SET_VALUE,$08,$05,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$07,SOUND_COMMAND_SET_VALUE,$08,$0f,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$05,SOUND_COMMAND_SET_VALUE,$08,$0D,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$04,SOUND_COMMAND_SET_VALUE,$08,$0a,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$03,SOUND_COMMAND_SET_VALUE,$08,$07,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,8,0,SOUND_COMMAND_END                    ; Finally set the volume to 0
                .byt SOUND_COMMAND_END
