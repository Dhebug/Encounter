
#include "params.h"

; See D:\_music_\ayfxedit for the editor tool

    .zero

_SoundDataPointer 	.dsb 2
_SoundRoutineTmp    .dsb 3    ; Register ID, Value 1, Value 2
_SoundPsgTemp       .dsb 1    ; IRQ-safe temp for _PsgSetRegister

_PsgVirtualRegisters
_PsgfreqA 		.dsb 2    ;  0 1    Chanel A Frequency
_PsgfreqB		.dsb 2    ;  2 3    Chanel B Frequency
_PsgfreqC		.dsb 2    ;  4 5    Chanel C Frequency
_PsgfreqNoise	.dsb 1      ;  6      Chanel sound generator
_Psgmixer		.dsb 1    ;  7      Mixer/Selector -> Everything is disabled by default
_PsgvolumeA		.dsb 1      ;  8      Volume A
_PsgvolumeB		.dsb 1      ;  9      Volume B
_PsgvolumeC		.dsb 1      ; 10      Volume C
_PsgfreqShape   .dsb 2    ; 11 12   Wave period
_PsgenvShape    .dsb 1      ; 13      Wave form
_PsgenvReset    .dsb 1      ; If set to 0, do not update register 13 (TODO: could be a bit field in _PsgNeedUpdate)

_MusicPsgVirtualRegisters
_MusicPsgfreqA 		.dsb 2    ;  0 1    Chanel A Frequency
_MusicPsgfreqB		.dsb 2    ;  2 3    Chanel B Frequency
_MusicPsgfreqC		.dsb 2    ;  4 5    Chanel C Frequency
_MusicPsgfreqNoise	.dsb 1      ;  6      Chanel sound generator
_MusicPsgmixer		.dsb 1    ;  7      Mixer/Selector -> Everything is disabled by default
_MusicPsgvolumeA	.dsb 1      ;  8      Volume A
_MusicPsgvolumeB	.dsb 1      ;  9      Volume B
_MusicPsgvolumeC	.dsb 1      ; 10      Volume C
_MusicPsgfreqShape  .dsb 2    ; 11 12   Wave period
_MusicPsgenvShape   .dsb 1      ; 13      Wave form
_MusicPsgenvReset   .dsb 1      ; If set to 0, do not update register 13 (TODO: could be a bit field in _PsgNeedUpdate)

    .text

_MusicMixerMask     .byt 0      ; By default no channels are reserved for the music

_PsgNeedUpdate  .byt 0

_PsgPlayPosition        .byt SOUND_NOT_PLAYING
_PsgPlayLoopIndex	    .byt 255     ; No loop defined
_PsgPlayDelay           .byt 0       ; No delay

previousCommand .byt SOUND_COMMAND_END

    .text

_PlaySoundAsm                            ; When called from C using the virtual registers
    ldx _param0+0                        
    ldy _param0+1
_PlaySoundAsmXY                          ; Direct assembler call using XY registers
    lda _gSoundEnabled
    beq end_sound
	sei
    stx _SoundDataPointer+0              ; Update the register list
    sty _SoundDataPointer+1

    lda #0
	sta _PsgPlayPosition                 ; 255 = Done playing
    sta _PsgPlayDelay                    ; 0 = No delay
    lda #255
	sta _PsgPlayLoopIndex                ; Reset the loop position

    ldy #SOUND_COMMAND_END
    sty previousCommand

	cli
end_sound    
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
    lda #1
    sta _PsgenvReset             ; Indicate that we want to force the Env register
    ;jsr SendBankToPsg           ; Sent all the sounds to the YM
    jmp read_command

CommandSoundWait
    ;jmp CommandSoundWait
    lda (_SoundDataPointer),y   ; Delay
    sta _PsgPlayDelay
    iny
    sty _PsgPlayPosition        ; Save the new command position and quit
    rts

CommandEndFrameFlag
    ldy #SOUND_COMMAND_END
    sty previousCommand
    rts

IrqTasksHighSpeed
SoundUpdateHighSpeed
.(
+read_command
    ldy _PsgPlayPosition
    cpy #SOUND_NOT_PLAYING                   ; Playing anything?
    beq end_replay

    ldx _PsgPlayDelay                        ; Are we in a wait command?
    beq no_delay
    dec _PsgPlayDelay
    rts
no_delay

    lda previousCommand
    asl
    bcs CommandEndSound                      ; SOUND_FLAG_END?
    asl
    bcs CommandEndFrameFlag

    lda (_SoundDataPointer),y                ; Read the next command
    sta previousCommand
    and #%00111111                           ; Flush extra flags
    iny                                      ; Increment the pointer
    ;cmp #SOUND_COMMAND_END
    ;beq CommandEndSound
    cmp #SOUND_COMMAND_END_FRAME
    beq CommandEndFrame
    cmp #SOUND_COMMAND_SET_BANK
    beq CommandSetBank
    cmp #SOUND_COMMAND_SET_VALUE
    beq CommandSetValue
    cmp #SOUND_COMMAND_SET_VALUE2
    beq CommandSetValue2
    cmp #SOUND_COMMAND_ADD_VALUE
    beq CommandAddValue
    cmp #SOUND_COMMAND_REPEAT
    beq CommandLoopStart
    cmp #SOUND_COMMAND_ENDREPEAT
    beq CommandLoopEnd
    cmp #SOUND_COMMAND_WAIT
    beq CommandSoundWait

    ; If we reach here, it means we got some corrupted data or unsupported command like using SOUND_COMMAND_END instead of the SOUND_FLAG_END flag
    jsr _Panic

CommandEndSound
    ldy #SOUND_COMMAND_END
    sty previousCommand
    ldy #SOUND_NOT_PLAYING      ; Finishes the sound
    sty _PsgPlayPosition        ; Save the new command position
end_replay	
    rts
    
CommandEndFrame
    ldx _PsgPlayLoopIndex       ; 0 is the first valid loop index
    cpx #255                    ; No active loop?
    beq do_pointer_update
    lda _PsgPlayLoopCount,x     ; We are still looping
    bne skip_pointer_update
do_pointer_update
    tya
    clc
    adc _SoundDataPointer+0
    sta _SoundDataPointer+0
    lda _SoundDataPointer+1
    adc #0
    sta _SoundDataPointer+1

    ldy #SOUND_COMMAND_END
    sty previousCommand

    ldy #0
skip_pointer_update    
    sty _PsgPlayPosition        ; Save the new command position
    rts	

CommandAddValue
    jsr SoundRead2

    ; Add the value to the virtual register (faster than reading the PSG internals)
    ldy _SoundRoutineTmp+0
    lda _PsgVirtualRegisters,y
    clc
    adc _SoundRoutineTmp+1
    tax  
    jmp _PsgSetVirtualAndActualRegisterAndLoopForNextCommand     ; Update the real register ; y=register number, x=register value
        
; Should not be used to set the enveloppe shape register
CommandSetValue2
    ;jmp CommandSetValue2
    jsr SoundRead3

    ; Set the value to the virtual register then update the real register
    ldy _SoundRoutineTmp+0
    ldx _SoundRoutineTmp+1
    jsr _PsgSetVirtualAndActualRegister			 ; y=register number, x=register value
    iny
    ldx _SoundRoutineTmp+2
    jmp _PsgSetVirtualAndActualRegisterAndLoopForNextCommand     ; Update the real register ; y=register number, x=register value

CommandSetValue
    jsr SoundRead2

    ; Set the value to the virtual register
    ldy _SoundRoutineTmp+0
    lda _SoundRoutineTmp+1
    cpy #13
    bne no_env_change
    sty _PsgenvReset
no_env_change    
    tax
    jmp _PsgSetVirtualAndActualRegisterAndLoopForNextCommand     ; Update the real register ; y=register number, x=register value

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


SoundRead3    
    lda (_SoundDataPointer),y    ; Register to change
    sta _SoundRoutineTmp+0
    iny
    lda (_SoundDataPointer),y    ; Register value
    sta _SoundRoutineTmp+1
    iny
    lda (_SoundDataPointer),y    ; Register value
    sta _SoundRoutineTmp+2
    iny
    sty _PsgPlayPosition        ; Save the new command position
    rts

SoundRead2  
    lda (_SoundDataPointer),y    ; Register to change
    sta _SoundRoutineTmp+0
    iny
    lda (_SoundDataPointer),y    ; Register value
    sta _SoundRoutineTmp+1
    iny
    sty _PsgPlayPosition        ; Save the new command position
    rts


; The default "StopSound" will only work if the IRQ is running, and does not filter the music mask
_PsgStopSoundAndForceUpdate
    lda #0
    sta _MusicMixerMask
    jsr _PsgStopSound
    ;jmp SoundUpdate50hz  -- Fall through
; Update the sound generator
SoundUpdate50hz    
.(
    lda _PsgNeedUpdate
    bne continue
    rts
continue

    and #1
    sta _PsgNeedUpdate

    ; Experimental code: Mixing sound effects with a music track
    ; Voice ABC / Noise ABC / Enveloppe
.(
    lda _MusicMixerMask            ; E CBA CBA

    ror
    bcc end_channel_1_for_music 
    ldx _MusicPsgfreqA+0
    stx _PsgfreqA+0
    ldx _MusicPsgfreqA+1
    stx _PsgfreqA+1
    ldx _MusicPsgvolumeA+0
    stx _PsgvolumeA+0
end_channel_1_for_music    

    ror
    bcc end_channel_2_for_music 
    ldx _MusicPsgfreqB+0
    stx _PsgfreqB+0
    ldx _MusicPsgfreqB+1
    stx _PsgfreqB+1
    ldx _MusicPsgvolumeB+0
    stx _PsgvolumeB+0
end_channel_2_for_music    

    ror
    bcc end_channel_3_for_music 
    ldx _MusicPsgfreqC+0
    stx _PsgfreqC+0
    ldx _MusicPsgfreqC+1
    stx _PsgfreqC+1
    ldx _MusicPsgvolumeC+0
    stx _PsgvolumeC+0
end_channel_3_for_music    

    ror                            ; bit 3 (envelope) -> carry
    bcc end_enveloppe_for_music
    ldx _MusicPsgfreqShape+0
    stx _PsgfreqShape+0
    ldx _MusicPsgfreqShape+1
    stx _PsgfreqShape+1
    ldx _MusicPsgenvShape
    stx _PsgenvShape
    lda _MusicPsgenvReset
    sta _PsgenvReset
end_enveloppe_for_music    
    

    lda _MusicMixerMask
    beq end_music_mixer
    eor #255
    and _Psgmixer 
    sta _Psgmixer

    lda _MusicPsgmixer
    and _MusicMixerMask
    ora _Psgmixer 
    sta _Psgmixer

end_music_mixer
.)        
    ; Test

    lda _Psgmixer
    ora #%11000000         ; Making sure we don't break things connected to the IO ports (like the keyboard)
    sta _Psgmixer

    ldy #0
register_loop
    ldx	_PsgVirtualRegisters,y   
    jsr _PsgSetRegister   ; y=register number /  x=value to write

    iny
    cpy #13
    bne register_loop

    ; Special case for the Envelope shape - Changing it resets the envelope
    lda _PsgenvReset
    beq skip_update

    ldx	_PsgVirtualRegisters,y
    jsr _PsgSetRegister   ; y=register number /  x=value to write

    lda #0
    sta _PsgenvReset      ; Reset, so we don't update it next time

skip_update	
    rts
.)


; y=register number
; x=value to write
_PsgSetVirtualAndActualRegisterAndLoopForNextCommand
    jsr _PsgSetVirtualAndActualRegister			 ; y=register number, x=register value
    jmp read_command

_PsgSetVirtualAndActualRegister
    stx _PsgVirtualRegisters,y
_PsgSetRegister
.(
    sty	via_porta
    lda	via_pcr
    ora	#$EE		; $EE	238	11101110  BDIR+BC1 = select register
    sta	via_pcr

    eor	#$22		; $EE^$22=$CC  Toggle BDIR+BC1 to idle state
    sta	via_pcr
    sta	_SoundPsgTemp	; Save idle PCR value

    stx	via_porta	; Write register value directly from X
    ora	#$20		; $CC|$20=$EC  BDIR = write mode
    sta	via_pcr

    lda	_SoundPsgTemp	; Restore idle state
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
_ExplodeData    .byt SOUND_COMMAND_SET_BANK|SOUND_FLAG_END,$00,$00,$00,$00,$00,$00,$1F,$07,$10,$10,$10,$00,$18,$00
_ShootData      .byt SOUND_COMMAND_SET_BANK|SOUND_FLAG_END,$00,$00,$00,$00,$00,$00,$12,$07,$10,$10,$10,$00,$08,$00
_PingData       .byt SOUND_COMMAND_SET_BANK|SOUND_FLAG_END,$18,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$00,$0F,$00
_KeyClickHData  .byt SOUND_COMMAND_SET_BANK|SOUND_FLAG_END,$3F,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$1F,$00,$00
_KeyClickLData  .byt SOUND_COMMAND_SET_BANK|SOUND_FLAG_END,$4F,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$1F,$00,$00

_ZapData        
    .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$00,$3E,$0F,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
    SOUND_REPEAT(40)
        SOUND_ADD_VALUE_ENDFRAME(0,2)
    SOUND_ENDREPEAT()
    SOUND_SET_VALUE_END(8,0)                    ; Finally set the volume to 0


_WatchButtonPress 
    SOUND_SET_VALUE2(REG_A_FREQ,64)
    SOUND_SET_VALUE(REG_A_VOLUME,8)                ; Channel A volume
    SOUND_SET_VALUE(REG_MIXER,%11111110)           ; Enable Tone on channel A
    SOUND_WAIT(25)                                 ; Wait half a second
    SOUND_SET_VALUE_ENDFRAME(8,6)                  ; Lower the volume
    SOUND_SET_VALUE_END(8,0)                       ; Cut the volume


_WatchBeepData
    SOUND_SET_VALUE2(REG_A_FREQ,128)
    SOUND_SET_VALUE(REG_A_VOLUME,13)               ; Channel A volume
    SOUND_SET_VALUE(REG_MIXER,%11111110)           ; Enable Tone on channel A
    SOUND_WAIT(50)                                 ; Wait a second
    SOUND_SET_VALUE_END(8,0)                       ; Cut the volume


_AlarmLedBeeping
    SOUND_SET_VALUE2(REG_A_FREQ,128)               ; Channel Frequency
    SOUND_SET_VALUE(REG_A_VOLUME,1)                ; Channel A volume
    SOUND_SET_VALUE(REG_MIXER,%11111110)           ; Enable Tone on channel A
    SOUND_WAIT(50)                                 ; Wait a second
    SOUND_SET_VALUE_END(8,0)                       ; Cut the volume


; For some reasons, a flickering light bulb and a drip of water sound close enough
_WaterDrip
_FlickeringLight
    SOUND_SET_VALUE(REG_NOISE_FREQ,5)              ; Noise Frequency
    SOUND_SET_VALUE(REG_A_VOLUME,10)               ; Channel A volume
    SOUND_SET_VALUE_ENDFRAME(REG_MIXER,%11110111)  ; Enable NOISE on channel A
    SOUND_SET_VALUE_ENDFRAME(8,8)                  ; Lower the volume
    SOUND_SET_VALUE_END(8,0)                       ; Cut the volume


_BirdChirp1
    SOUND_SET_VALUE2(REG_A_FREQ,48)                ; Channel Frequency
    SOUND_SET_VALUE(REG_A_VOLUME,5)                ; Channel A volume
    SOUND_SET_VALUE(REG_MIXER,%11111110)           ; Enable Tone on channel A
	SOUND_REPEAT(10)
		SOUND_ADD_VALUE_ENDFRAME(REG_A_FREQ_LOW,255-1)
	SOUND_ENDREPEAT()
	SOUND_SET_VALUE_END(REG_A_VOLUME,0)                ; Cut the volume


_BirdChirp2
    SOUND_SET_VALUE2(REG_A_FREQ,32)                ; Channel Frequency
    SOUND_SET_VALUE(REG_A_VOLUME,5)                ; Channel A volume
    SOUND_SET_VALUE(REG_MIXER,%11111110)           ; Enable Tone on channel A
	SOUND_REPEAT(10)
		SOUND_ADD_VALUE_ENDFRAME(REG_A_FREQ_LOW,255-1)
	SOUND_ENDREPEAT()
	SOUND_SET_VALUE_END(REG_A_VOLUME,0)                ; Cut the volume


_FuseBurningStart
    SOUND_SET_VALUE(REG_NOISE_FREQ,10)             ; Noise Frequency
    SOUND_SET_VALUE(REG_A_VOLUME,0)                ; Channel A volume
    SOUND_SET_VALUE(REG_MIXER,%11110111)           ; Enable Noise on channel A
	SOUND_REPEAT(15)
		SOUND_ADD_VALUE(REG_A_VOLUME,1)
        SOUND_WAIT(10)
	SOUND_ENDREPEAT()
_FuseBurning    
    SOUND_SET_VALUE(REG_NOISE_FREQ,10)             ; Noise Frequency
    SOUND_SET_VALUE(REG_A_VOLUME,15)               ; Channel A volume
    SOUND_SET_VALUE(REG_MIXER,%11110111)           ; Enable Noise on channel A
	SOUND_REPEAT(255)
        SOUND_REPEAT(2)
            SOUND_ADD_VALUE(REG_A_VOLUME,256-1)
            SOUND_WAIT(10)
        SOUND_ENDREPEAT()
        SOUND_REPEAT(2)
            SOUND_ADD_VALUE(REG_A_VOLUME,1)
            SOUND_WAIT(15)
        SOUND_ENDREPEAT()
	SOUND_ENDREPEAT()

_Acid
    SOUND_SET_VALUE(REG_NOISE_FREQ,31)             ; Noise Frequency
    SOUND_SET_VALUE(REG_A_VOLUME,0)                ; Channel A volume
    SOUND_SET_VALUE(REG_MIXER,%11110111)           ; Enable Noise on channel A
	SOUND_REPEAT(15)
		SOUND_ADD_VALUE(REG_A_VOLUME,1)
		SOUND_ADD_VALUE(REG_NOISE_FREQ,255-1)
        SOUND_WAIT(10)
	SOUND_ENDREPEAT()
    SOUND_WAIT(250)
    SOUND_WAIT(250)
	SOUND_REPEAT(15)
		SOUND_ADD_VALUE_ENDFRAME(REG_A_VOLUME,255-1)
        SOUND_WAIT(50)
	SOUND_ENDREPEAT()
	SOUND_SET_VALUE_END(REG_A_VOLUME,0)                           ; Cut the volume


_Zipper
    SOUND_SET_VALUE2(REG_A_FREQ,256)
    SOUND_SET_VALUE(REG_A_VOLUME,16)           ; Channel A volume -> Enveloppe

    SOUND_SET_VALUE2(REG_ENV,64)
	SOUND_SET_VALUE(REG_ENV_SHAPE,%1100)       ; Enveloppe Shape ///   = 1100
    SOUND_SET_VALUE(REG_MIXER,%11111110)       ; Enable Tone on channel A
	SOUND_REPEAT(64)
		SOUND_ADD_VALUE_ENDFRAME(REG_A_FREQ_LOW,256-4)
	SOUND_ENDREPEAT()
	SOUND_REPEAT(32)
		SOUND_ADD_VALUE_ENDFRAME(REG_A_FREQ_LOW,4)
	SOUND_ENDREPEAT()
	SOUND_SET_VALUE_END(REG_A_VOLUME,0)                           ; Cut the volume


_UseKeyOnAlarmPanel ; Temporary
_ZipDownTheRope   ; Temporary
_Swoosh
    SOUND_SET_VALUE(REG_NOISE_FREQ,0)             ; Noise Frequency
    SOUND_SET_VALUE(REG_A_VOLUME,0)               ; Channel A volume
    SOUND_SET_VALUE(REG_MIXER,%11110111)          ; Enable Noise on channel A
	SOUND_REPEAT(15)
		SOUND_ADD_VALUE(REG_A_VOLUME,1)
		SOUND_ADD_VALUE_ENDFRAME(REG_NOISE_FREQ,1)
	SOUND_ENDREPEAT()
	SOUND_SET_VALUE_END(REG_A_VOLUME,0)                           ; Cut the volume


_Pling
    SOUND_SET_VALUE2(REG_A_FREQ,44)                 ; Channel A Frequency
    SOUND_SET_VALUE(REG_A_VOLUME,15)                ; Channel A volume

    SOUND_SET_VALUE2(REG_B_FREQ,33)                 ; Channel B Frequency
    SOUND_SET_VALUE(REG_B_VOLUME,15)                ; Channel B volume

    SOUND_SET_VALUE2(REG_C_FREQ,50)                 ; Channel C Frequency
    SOUND_SET_VALUE(REG_C_VOLUME,15)                ; Channel C volume

    SOUND_SET_VALUE(REG_MIXER,%1111000)             ; Enable Noise + Tone on channel A

	SOUND_REPEAT(8)
		SOUND_ADD_VALUE(REG_A_VOLUME,256-1)
		SOUND_ADD_VALUE(REG_B_VOLUME,256-1)
		SOUND_ADD_VALUE(REG_C_VOLUME,256-2)
        SOUND_WAIT(16)
	SOUND_ENDREPEAT()

	SOUND_SET_VALUE(REG_A_VOLUME,0)                 ; Cut the volume
	SOUND_SET_VALUE(REG_B_VOLUME,0)                 ; Cut the volume
	SOUND_SET_VALUE_END(REG_C_VOLUME,0)             ; Cut the volume


_DoorOpening
    SOUND_SET_VALUE(REG_MIXER,%11110110)            ; Enable Tone and Noise on channel A
	SOUND_SET_TONE_A($194,0)
	SOUND_SET_NOISE(31)
	SOUND_REPEAT(15)
		SOUND_ADD_VALUE(REG_NOISE_FREQ,256-2)
		SOUND_ADD_VALUE(REG_A_FREQ_LOW,256-1)
		SOUND_ADD_VALUE(REG_A_VOLUME,1)
        SOUND_WAIT(3)
	SOUND_ENDREPEAT()
	SOUND_SET_VALUE_END(REG_A_VOLUME,0)                           ; Cut the volume


_AlarmSwitchPressed
_DoorClosing
    SOUND_SET_VALUE(REG_MIXER,%11110110)          ; Enable Tone and Noise on channel A
	SOUND_SET_TONE_A($194,$F)
	SOUND_SET_NOISE_ENDFRAME($1A)
	SOUND_SET_TONE_A($21a,$e)
	SOUND_SET_NOISE_ENDFRAME($18)

    SOUND_SET_VALUE(REG_MIXER,%11110110)          ; Enable Tone only channel A
	SOUND_SET_TONE_A($30c,$c)
	.byt SOUND_COMMAND_END_FRAME
	SOUND_SET_TONE_A($3c6,$b)
	.byt SOUND_COMMAND_END_FRAME
	SOUND_SET_TONE_A($440,$a)
	.byt SOUND_COMMAND_END_FRAME
	SOUND_SET_TONE_A($535,$9)
	.byt SOUND_COMMAND_END_FRAME

	.byt SOUND_COMMAND_END_FRAME
	SOUND_SET_VALUE_END(REG_A_VOLUME,0)                           ; Cut the volume


_EngineRunning
    SOUND_SET_VALUE(REG_MIXER,%11110110)          ; Enable Tone and Noise on channel A
	SOUND_SET_VALUE(REG_A_VOLUME,0)                           ; Cut the volume
	SOUND_SET_TONE_A(1435,8)
	SOUND_SET_NOISE_END(21)


_VroomVroom
    SOUND_SET_VALUE(REG_MIXER,%11110110)          ; Enable Tone and Noise on channel A
	SOUND_SET_VALUE(REG_A_VOLUME,0)                           ; Cut the volume
	SOUND_SET_TONE_A($F9B,$4)
	SOUND_SET_NOISE($1F)
	SOUND_REPEAT(10)
		SOUND_ADD_VALUE(REG_A_FREQ_HI,256-1)
		SOUND_ADD_VALUE(REG_NOISE_FREQ,256-1)
		SOUND_ADD_VALUE(REG_A_VOLUME,1)
        SOUND_WAIT(5)
	SOUND_ENDREPEAT()
	SOUND_SET_TONE_A(1435,8)
	SOUND_SET_NOISE_END(21)



_Snore
    SOUND_SET_VALUE(REG_MIXER,%11110111)            ; Enable Noise on channel A
	SOUND_SET_VALUE(REG_A_VOLUME,0)                 ; Cut the volume
	SOUND_SET_NOISE($1F)

    SOUND_REPEAT(5)
        SOUND_ADD_VALUE(REG_A_VOLUME,1)
        SOUND_WAIT(45)
    SOUND_ENDREPEAT()

    SOUND_WAIT(50)

    SOUND_REPEAT(5)
        SOUND_ADD_VALUE(REG_A_VOLUME,256-1)
        SOUND_WAIT(30)
    SOUND_ENDREPEAT()

	SOUND_SET_VALUE_END(REG_A_VOLUME,0)                 ; Cut the volume


_ErrorPlop
    SOUND_SET_VALUE(REG_MIXER,%11111110)          ; Enable Tone  on channel A
	SOUND_REPEAT(2)
		SOUND_SET_TONE_A(1300,8)
		SOUND_REPEAT(3)
			SOUND_ADD_VALUE(REG_A_VOLUME,1)
            SOUND_WAIT(2)
		SOUND_ENDREPEAT()
		SOUND_REPEAT(8+3)
			SOUND_ADD_VALUE(REG_A_VOLUME,256-1)
            SOUND_WAIT(2)
		SOUND_ENDREPEAT()
	SOUND_ENDREPEAT()
	SOUND_SET_VALUE_END(REG_A_VOLUME,0)                           ; Cut the volume



#if 0 // Work in progress - not happy
_DogGrowling
    SOUND_SET_VALUE(REG_MIXER,%11110110)            ; Enable Noise on channel A

    SOUND_REPEAT(250)

        SOUND_SET_VALUE2(REG_A_FREQ,2048)
    	SOUND_SET_NOISE(25)
    	SOUND_SET_VALUE(REG_A_VOLUME,2)                 ; Set the initial volume

        //SOUND_REPEAT(250)

        SOUND_REPEAT(8)
            SOUND_REPEAT(15)
                SOUND_ADD_VALUE(REG_NOISE_FREQ,3)
                SOUND_ADD_VALUE_ENDFRAME(REG_A_FREQ,4)
            SOUND_ENDREPEAT()
            SOUND_ADD_VALUE(REG_A_VOLUME,1)
        SOUND_ENDREPEAT()

        SOUND_REPEAT(8)
            SOUND_REPEAT(15)
                SOUND_ADD_VALUE(REG_NOISE_FREQ,3)
                SOUND_ADD_VALUE_ENDFRAME(REG_A_FREQ,256-4)
            SOUND_ENDREPEAT()
            SOUND_ADD_VALUE(REG_A_VOLUME,256-1)
        SOUND_ENDREPEAT()


    	//SOUND_SET_VALUE(REG_A_VOLUME,0)                 ; Set the initial volume

        //SOUND_WAIT(250)

    SOUND_ENDREPEAT()

	SOUND_SET_VALUE_END(REG_A_VOLUME,0)                 ; Cut the volume
#endif




