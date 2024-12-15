
#include "params.h"

; See D:\_music_\ayfxedit for the editor tool

    .zero

_SoundDataPointer 	.dsb 2
_SoundRoutineTmp    .dsb 2

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
_PsgPlayLoopCount	    .dsb 10      ; 10 levels of loops
_PsgPlayLoopPosition    .dsb 10      ; 10 levels of loops
_PsgPlayLoopIndex	    .byt 255     ; No loop defined

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
    lda #255
	sta _PsgPlayLoopIndex                ; Reset the loop position

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

SoundUpdateHighSpeed
.(
+read_command
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

CommandEndSound
    ldy #SOUND_NOT_PLAYING      ; Finishes the sound
    sty _PsgPlayPosition        ; Save the new command position
end_replay	
    rts

CommandEndFrame
    ldx _PsgPlayLoopIndex       ; 0 is the first valid loop index
    lda _PsgPlayLoopCount,x     ; We are still looping
    bne skip_pointer_update

    tya
    clc
    adc _SoundDataPointer+0
    sta _SoundDataPointer+0
    lda _SoundDataPointer+1
    adc #0
    sta _SoundDataPointer+1

    ldy #0
skip_pointer_update    
    sty _PsgPlayPosition        ; Save the new command position
    rts	

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
    cpy #13
    bne no_env_change
    sty _PsgenvReset
no_env_change    
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

    lda _MusicMixerMask            ; E CBA CBA
    and #%1000                     ; E CBA
    
    beq end_enveloppe_for_music 
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


; The default "StopSound" will only work if the IRQ is running, and does not filter the music mask
_PsgStopSoundAndForceUpdate
    lda #0
    sta _MusicMixerMask
    jsr _PsgStopSound
    jmp SoundUpdate50hz

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
_ShootData      .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$12,$07,$10,$10,$10,$00,$08,$00,SOUND_COMMAND_END
_PingData       .byt SOUND_COMMAND_SET_BANK,$18,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$00,$0F,$00,SOUND_COMMAND_END
_KeyClickHData  .byt SOUND_COMMAND_SET_BANK,$3F,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$1F,$00,$00,SOUND_COMMAND_END
_KeyClickLData  .byt SOUND_COMMAND_SET_BANK,$4F,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$1F,$00,$00,SOUND_COMMAND_END

_ZapData        .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$00,$3E,$0F,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_REPEAT,40
                .byt SOUND_COMMAND_ADD_VALUE,0,2,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_ENDREPEAT			
                .byt SOUND_COMMAND_SET_VALUE,8,0,SOUND_COMMAND_END       ; Finally set the volume to 0
                .byt SOUND_COMMAND_END

_WatchButtonPress 
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_LOW,64             ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_HI,0               ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,8                ; Channel A volume
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11111110           ; Enable Tone on channel A
	.byt SOUND_COMMAND_REPEAT,25,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_ENDREPEAT		  ; Wait half a second
    .byt SOUND_COMMAND_END_FRAME
    .byt SOUND_COMMAND_SET_VALUE,8,6                           ; Lower the volume
    .byt SOUND_COMMAND_END_FRAME
    .byt SOUND_COMMAND_SET_VALUE,8,0                           ; Cut the volume
    .byt SOUND_COMMAND_END

_WatchBeepData
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_LOW,128            ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_HI,0               ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,13               ; Channel A volume
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11111110           ; Enable Tone on channel A
	.byt SOUND_COMMAND_REPEAT,50,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_ENDREPEAT		  ; Wait a second
    .byt SOUND_COMMAND_END_FRAME
    .byt SOUND_COMMAND_SET_VALUE,8,0                           ; Cut the volume
    .byt SOUND_COMMAND_END

_AlarmLedBeeping
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_LOW,128            ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_HI,0               ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,1                ; Channel A volume
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11111110           ; Enable Tone on channel A
	.byt SOUND_COMMAND_REPEAT,50,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_ENDREPEAT		  ; Wait a second
    .byt SOUND_COMMAND_END_FRAME
    .byt SOUND_COMMAND_SET_VALUE,8,0                           ; Cut the volume
    .byt SOUND_COMMAND_END

; For some reasons, a flickering light bulb and a drip of water sound close enough
_WaterDrip
_FlickeringLight
    .byt SOUND_COMMAND_SET_VALUE,REG_NOISE_FREQ,5              ; Noise Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,10               ; Channel A volume
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11110111           ; Enable NOISE on channel A
    .byt SOUND_COMMAND_END_FRAME
    .byt SOUND_COMMAND_SET_VALUE,8,8                           ; Lower the volume
    .byt SOUND_COMMAND_END_FRAME
    .byt SOUND_COMMAND_SET_VALUE,8,0                           ; Cut the volume
    .byt SOUND_COMMAND_END

_BirdChirp1
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_LOW,48            ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_HI,0              ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,5               ; Channel A volume
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11111110           ; Enable Tone on channel A
	.byt SOUND_COMMAND_REPEAT,10
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_FREQ_LOW,255-1,SOUND_COMMAND_END_FRAME
	.byt SOUND_COMMAND_ENDREPEAT			
	.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
    .byt SOUND_COMMAND_END

_BirdChirp2
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_LOW,32            ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_HI,0              ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,5               ; Channel A volume
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11111110           ; Enable Tone on channel A
	.byt SOUND_COMMAND_REPEAT,10
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_FREQ_LOW,255-1,SOUND_COMMAND_END_FRAME
	.byt SOUND_COMMAND_ENDREPEAT			
	.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
    .byt SOUND_COMMAND_END

_FuseBurningStart
    .byt SOUND_COMMAND_SET_VALUE,REG_NOISE_FREQ,10            ; Noise Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0               ; Channel A volume
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11110111          ; Enable Noise on channel A
	.byt SOUND_COMMAND_REPEAT,15
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_VOLUME,1
		.byt SOUND_COMMAND_REPEAT,10,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_ENDREPEAT		  ; Wait one second
	.byt SOUND_COMMAND_ENDREPEAT	
_FuseBurning    
    .byt SOUND_COMMAND_SET_VALUE,REG_NOISE_FREQ,10            ; Noise Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,15              ; Channel A volume
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11110111          ; Enable Noise on channel A
	.byt SOUND_COMMAND_REPEAT,255
	.byt SOUND_COMMAND_REPEAT,2
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_VOLUME,256-1
		.byt SOUND_COMMAND_REPEAT,10,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_ENDREPEAT		  ; Wait one second
	.byt SOUND_COMMAND_ENDREPEAT	
	.byt SOUND_COMMAND_REPEAT,2
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_VOLUME,1
		.byt SOUND_COMMAND_REPEAT,15,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_ENDREPEAT		  ; Wait one second
	.byt SOUND_COMMAND_ENDREPEAT	
	.byt SOUND_COMMAND_ENDREPEAT	

_Acid
    .byt SOUND_COMMAND_SET_VALUE,REG_NOISE_FREQ,31            ; Noise Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0               ; Channel A volume
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11110111          ; Enable Noise on channel A
	.byt SOUND_COMMAND_REPEAT,15
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_VOLUME,1
		.byt SOUND_COMMAND_ADD_VALUE,REG_NOISE_FREQ,255-1
		.byt SOUND_COMMAND_REPEAT,10,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_ENDREPEAT		  ; Wait one second
	.byt SOUND_COMMAND_ENDREPEAT			

	.byt SOUND_COMMAND_REPEAT,250
		.byt SOUND_COMMAND_END_FRAME
	.byt SOUND_COMMAND_ENDREPEAT			

	.byt SOUND_COMMAND_REPEAT,250,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_ENDREPEAT		  ; Wait one second

	.byt SOUND_COMMAND_REPEAT,15
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_VOLUME,255-1,SOUND_COMMAND_END_FRAME
		.byt SOUND_COMMAND_REPEAT,50,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_ENDREPEAT		  ; Wait one second
	.byt SOUND_COMMAND_ENDREPEAT			
	.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
    .byt SOUND_COMMAND_END

_Zipper
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_LOW,0          ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_HI,1           ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,16           ; Channel A volume -> Enveloppe
    .byt SOUND_COMMAND_SET_VALUE,REG_ENV_LOW,64            ; Enveloppe Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_ENV_HI,0              ; Enveloppe Frequency
	.byt SOUND_COMMAND_SET_VALUE,REG_ENV_SHAPE,%1100       ; Enveloppe Shape ///   = 1100
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11111110       ; Enable Tone on channel A
	.byt SOUND_COMMAND_REPEAT,64
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_FREQ_LOW,256-4,SOUND_COMMAND_END_FRAME
	.byt SOUND_COMMAND_ENDREPEAT			
	.byt SOUND_COMMAND_REPEAT,32
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_FREQ_LOW,4,SOUND_COMMAND_END_FRAME
	.byt SOUND_COMMAND_ENDREPEAT			
	.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
    .byt SOUND_COMMAND_END


_UseKeyOnAlarmPanel ; Temporary
_ZipDownTheRope   ; Temporary
_Swoosh
    .byt SOUND_COMMAND_SET_VALUE,REG_NOISE_FREQ,0             ; Noise Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0               ; Channel A volume
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11110111          ; Enable Noise on channel A
	.byt SOUND_COMMAND_REPEAT,15
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_VOLUME,1
		.byt SOUND_COMMAND_ADD_VALUE,REG_NOISE_FREQ,1
		.byt SOUND_COMMAND_END_FRAME
		.byt SOUND_COMMAND_END_FRAME
	.byt SOUND_COMMAND_ENDREPEAT	
	.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
	.byt SOUND_COMMAND_END


_Pling
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_LOW,44         ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_FREQ_HI,0           ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,15           ; Channel A volume

    .byt SOUND_COMMAND_SET_VALUE,REG_B_FREQ_LOW,33        ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_B_FREQ_HI,0           ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_B_VOLUME,15           ; Channel B volume

    .byt SOUND_COMMAND_SET_VALUE,REG_C_FREQ_LOW,50        ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_C_FREQ_HI,0           ; Channel Frequency
    .byt SOUND_COMMAND_SET_VALUE,REG_C_VOLUME,15           ; Channel B volume

    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%1111000       ; Enable Noise + Tone on channel A

	.byt SOUND_COMMAND_REPEAT,8
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_VOLUME,256-1
		.byt SOUND_COMMAND_ADD_VALUE,REG_B_VOLUME,256-1
		.byt SOUND_COMMAND_ADD_VALUE,REG_C_VOLUME,256-2
		.byt SOUND_COMMAND_REPEAT,16
			.byt SOUND_COMMAND_END_FRAME
		.byt SOUND_COMMAND_ENDREPEAT	
	.byt SOUND_COMMAND_ENDREPEAT	

	.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
	.byt SOUND_COMMAND_SET_VALUE,REG_B_VOLUME,0                           ; Cut the volume
	.byt SOUND_COMMAND_SET_VALUE,REG_C_VOLUME,0                           ; Cut the volume
	.byt SOUND_COMMAND_END


#define TONE(freq,volume)    SOUND_COMMAND_SET_VALUE,REG_A_FREQ_LOW,<freq,SOUND_COMMAND_SET_VALUE,REG_A_FREQ_HI,>freq,SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,volume 
#define NOISE(freq)          SOUND_COMMAND_SET_VALUE,REG_NOISE_FREQ,freq

_DoorOpening
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11110110          ; Enable Tone and Noise on channel A
	.byt TONE($194,0)
	.byt NOISE(31)
	.byt SOUND_COMMAND_REPEAT,15
		.byt SOUND_COMMAND_ADD_VALUE,REG_NOISE_FREQ,256-2
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_FREQ_LOW,256-1
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_VOLUME,1
		.byt SOUND_COMMAND_REPEAT,3
			.byt SOUND_COMMAND_END_FRAME
		.byt SOUND_COMMAND_ENDREPEAT			
	.byt SOUND_COMMAND_ENDREPEAT			

	.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
    .byt SOUND_COMMAND_END

_AlarmSwitchPressed
_DoorClosing
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11110110          ; Enable Tone and Noise on channel A
	.byt TONE($194,$F)
	.byt NOISE($1A)
	.byt SOUND_COMMAND_END_FRAME
	.byt TONE($21a,$e)
	.byt NOISE($18)
	.byt SOUND_COMMAND_END_FRAME

    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11110110          ; Enable Tone only channel A
	.byt TONE($30c,$c)
	.byt SOUND_COMMAND_END_FRAME
	.byt TONE($3c6,$b)
	.byt SOUND_COMMAND_END_FRAME
	.byt TONE($440,$a)
	.byt SOUND_COMMAND_END_FRAME
	.byt TONE($535,$9)
	.byt SOUND_COMMAND_END_FRAME

	.byt SOUND_COMMAND_END_FRAME
	.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
    .byt SOUND_COMMAND_END


_EngineRunning
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11110110          ; Enable Tone and Noise on channel A
	.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
	.byt TONE(1435,8)
	.byt NOISE(21)
    .byt SOUND_COMMAND_END

_VroomVroom
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11110110          ; Enable Tone and Noise on channel A
	.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
	.byt TONE($F9B,$4)
	.byt NOISE($1F)
	.byt SOUND_COMMAND_REPEAT,10
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_FREQ_HI,256-1
		.byt SOUND_COMMAND_ADD_VALUE,REG_NOISE_FREQ,256-1
		.byt SOUND_COMMAND_ADD_VALUE,REG_A_VOLUME,1
		.byt SOUND_COMMAND_END_FRAME
		.byt SOUND_COMMAND_END_FRAME
		.byt SOUND_COMMAND_END_FRAME
		.byt SOUND_COMMAND_END_FRAME
		.byt SOUND_COMMAND_END_FRAME
	.byt SOUND_COMMAND_ENDREPEAT			

	;.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
	.byt TONE(1435,8)
	.byt NOISE(21)

    .byt SOUND_COMMAND_END

_ErrorPlop
    .byt SOUND_COMMAND_SET_VALUE,REG_MIXER,%11111110          ; Enable Tone  on channel A
	.byt SOUND_COMMAND_REPEAT,2
		.byt TONE(1300,8)
		.byt SOUND_COMMAND_REPEAT,3
			.byt SOUND_COMMAND_ADD_VALUE,REG_A_VOLUME,1,SOUND_COMMAND_END_FRAME
			.byt SOUND_COMMAND_REPEAT,1,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_ENDREPEAT		  ; Wait one second
		.byt SOUND_COMMAND_ENDREPEAT			
		.byt SOUND_COMMAND_REPEAT,8+3
			.byt SOUND_COMMAND_ADD_VALUE,REG_A_VOLUME,256-1,SOUND_COMMAND_END_FRAME
			.byt SOUND_COMMAND_REPEAT,2,SOUND_COMMAND_END_FRAME,SOUND_COMMAND_ENDREPEAT		  ; Wait one second
		.byt SOUND_COMMAND_ENDREPEAT			
	.byt SOUND_COMMAND_ENDREPEAT			

	.byt SOUND_COMMAND_SET_VALUE,REG_A_VOLUME,0                           ; Cut the volume
	.byt SOUND_COMMAND_END


