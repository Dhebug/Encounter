; ACME 0.96.4

;
; 6502 ARKOS PLAYER for AKY format (ARKOS TRACKER 2)
; from:
;       AKY music player - V1.0.
;       By Julien Névo a.k.a. Targhan/Arkos - CPC PSG sending optimization trick by Madram/Overlanders.
;       December 2016.
;       This player only target 1 PSG, as it allows some nice optimizations.
;
;       6502 conversion: Arnaud Cocquière a.K.a GROUiK/FRENCH TOUCH
;       for APPLE IIx + MOCKINGBOARD | ORIC 1/ATMOS
; =============================================================================
; VERSION 0.10 - 07/2019
; =============================================================================

#include "params.h"

; === > ORIC 1/ATMOS <===
;#define VIA_ORA       $30F
;#define VIA_PCR       $30C
;#define F_SET_REG     $FF
;#define F_INACTIVE    $DD
;#define F_WRITE_DATA  $FD   


	.zero

ptr_music           .dsb 2   ; = $02      ; +$03
#ifdef USE_MUSIC_EVENTS
ptr_music_events    .dsb 2
event_counter       .dsb 2
#endif

pt2_DT              .dsb 2   ;= $04      ; +$05

; could be relocated anywhere (but slower):
ACCA            .dsb 2   ;= $06      ; save A
ACCB            .dsb 2   ;= $07      ; save A (bis)
volumeRegister  .dsb 2   ;= $08
r7              .dsb 2   ;= $09 

    .text

; -------------------------------------
;Some stored PSG registers. They MUST be consecutive.
PLY_AKY_PSGREGISTER6        .byt 0
PLY_AKY_PSGREGISTER11       .byt 0
PLY_AKY_PSGREGISTER12       .byt 0
PLY_AKY_PSGREGISTER13       .byt 0

save_x     .byt 0

_MusicLoopIndex .byt 0          ; Just a simple counter incrementing each time a new pattern starts
_MusicEvent     .byt 0          ; Value from the event track for the music

; =============================================================================
;Is there a loaded Player Configuration source? If no, use a default configuration.
; => to generate Player Configuration, see export option in Arkos Tracker 2 
; simplified version...

; game_over_music_playerconfig.asm
#define PLY_CFG_ConfigurationIsPresent 1
#define PLY_CFG_UseSpeedTracks 1
#define PLY_CFG_UseTranspositions 1
#define PLY_CFG_UseEffects 1
#define PLY_CFG_UseInstrumentLoopTo 1
#define PLY_CFG_NoSoftNoHard 1
#define PLY_CFG_SoftOnly 1
#define PLY_CFG_SoftOnly_SoftwareArpeggio 1
#define PLY_CFG_UseEffect_PitchGlide 1
#define PLY_CFG_UseEffect_PitchUp 1
#define PLY_CFG_UseEffect_PitchTable 1
#define PLY_CFG_UseEffect_ArpeggioTable 1
#define PLY_CFG_UseEffect_SetVolume 1
#define PLY_CFG_UseEffect_VolumeOut 1

; success_music_playerconfig.asm
#define PLY_CFG_ConfigurationIsPresent 1
#define PLY_CFG_UseSpeedTracks 1
#define PLY_CFG_UseEffects 1
#define PLY_CFG_UseInstrumentLoopTo 1
#define PLY_CFG_NoSoftNoHard 1
#define PLY_CFG_SoftOnly 1
#define PLY_CFG_UseEffect_PitchTable 1
#define PLY_CFG_UseEffect_SetVolume 1
#define PLY_CFG_UseEffect_VolumeOut = 1  

; you_won_music_playerconfig.asm
#define PLY_CFG_ConfigurationIsPresent 1
#define PLY_CFG_UseSpeedTracks 1
#define PLY_CFG_UseTranspositions 1
#define PLY_CFG_UseEffects 1
#define PLY_CFG_UseInstrumentLoopTo 1
#define PLY_CFG_NoSoftNoHard 1
#define PLY_CFG_SoftOnly 1
#define PLY_CFG_SoftOnly_SoftwareArpeggio 1
#define PLY_CFG_UseEffect_PitchGlide 1
#define PLY_CFG_UseEffect_PitchUp 1
#define PLY_CFG_UseEffect_PitchDown 1
#define PLY_CFG_UseEffect_PitchTable 1
#define PLY_CFG_UseEffect_ArpeggioTable 1
#define PLY_CFG_UseEffect_SetVolume 1
#define PLY_CFG_UseEffect_VolumeIn 1
#define PLY_CFG_UseEffect_VolumeOut 1

; intro_music_playerconfig.a
#define PLY_CFG_ConfigurationIsPresent 1
#define PLY_CFG_UseSpeedTracks 1
#define PLY_CFG_UseEffects 1
#define PLY_CFG_UseInstrumentLoopTo 1
#define PLY_CFG_NoSoftNoHard 1
#define PLY_CFG_SoftOnly 1
#define PLY_CFG_SoftOnly_SoftwareArpeggio 1
#define PLY_CFG_UseEffect_PitchGlide 1
#define PLY_CFG_UseEffect_PitchUp 1
#define PLY_CFG_UseEffect_PitchDown 1
#define PLY_CFG_UseEffect_PitchTable 1
#define PLY_CFG_UseEffect_ArpeggioTable 1
#define PLY_CFG_UseEffect_SetVolume 1
#define PLY_CFG_UseEffect_VolumeOut 1

; intro_music_typewriter_playerconfig.a
#define PLY_CFG_ConfigurationIsPresent 1
#define PLY_CFG_UseSpeedTracks 1
#define PLY_CFG_UseEffects 1
#define PLY_CFG_UseInstrumentLoopTo 1
#define PLY_CFG_NoSoftNoHard 1
#define PLY_CFG_SoftOnly 1
#define PLY_CFG_UseEffect_ArpeggioTable 1
#define PLY_CFG_UseEffect_SetVolume 1
#define PLY_CFG_UseEffect_VolumeOut = 1  


#ifndef PLY_CFG_ConfigurationIsPresent 

#define PLY_CFG_UseHardwareSounds  1
#define PLY_CFG_UseRetrig  1
#define PLY_CFG_NoSoftNoHard  1              ; not used
#define PLY_CFG_NoSoftNoHard_Noise  1        ; not used
#define PLY_CFG_SoftOnly  1                  ; not used
#define PLY_CFG_SoftOnly_Noise  1            ; not used
#define PLY_CFG_SoftToHard  1                
#define PLY_CFG_SoftToHard_Noise  1
#define PLY_CFG_SoftToHard_Retrig  1         ; not used
#define PLY_CFG_HardOnly  1                  
#define PLY_CFG_HardOnly_Noise  1            ; not used
#define PLY_CFG_HardOnly_Retrig  1           ; not used
#define PLY_CFG_SoftAndHard  1               ; not used
#define PLY_CFG_SoftAndHard_Noise  1
#define PLY_CFG_SoftAndHard_Retrig  1        ; not used

#endif

;Agglomerates the hardware sound configuration flags, because they are treated the same in this player.
#ifdef PLY_CFG_SoftToHard 
#define PLY_AKY_USE_SoftAndHard_Agglomerated  1
#endif

#ifdef PLY_CFG_SoftAndHard 
#define  PLY_AKY_USE_SoftAndHard_Agglomerated 1 
#endif

#ifdef PLY_CFG_HardToSoft 
#define PLY_AKY_USE_SoftAndHard_Agglomerated  1 
#endif

#ifdef PLY_CFG_HardOnly
#define  PLY_AKY_USE_SoftAndHard_Agglomerated  1 
#endif

#ifdef PLY_CFG_SoftToHard_Noise 
#define  PLY_AKY_USE_SoftAndHard_Noise_Agglomerated  1 
#endif

#ifdef PLY_CFG_SoftAndHard_Noise 
#define  PLY_AKY_USE_SoftAndHard_Noise_Agglomerated  1 
#endif

#ifdef PLY_CFG_HardToSoft_Noise 
#define  PLY_AKY_USE_SoftAndHard_Noise_Agglomerated  1 
#endif

;Any noise?
#ifdef PLY_AKY_USE_SoftAndHard_Noise_Agglomerated 
#define  PLY_AKY_USE_Noise  1 
#endif

#ifdef PLY_CFG_NoSoftNoHard_Noise 
#define  PLY_AKY_USE_Noise  1 
#endif

#ifdef PLY_CFG_SoftOnly_Noise 
#define  PLY_AKY_USE_Noise  1 
#endif



; =============================================================================
#ifdef USE_MUSIC_EVENTS
ProcessEvent
.(
    ;jmp ProcessEvent

    ; Decrement counter
    lda event_counter+0
    bne skip
    lda event_counter+1
    beq FetchNextEvent            ; Did we reached zero?
    dec event_counter+1
skip 
    dec event_counter+0
    rts

+FetchNextEvent
    ; Read the 16 bit frame counter
    ldy #0
    lda (ptr_music_events),y
    sta event_counter+0
    iny
    lda (ptr_music_events),y
    sta event_counter+1
    iny

    ; If the frame counter value is 0, it means it's the end of the sequence
    lda event_counter+0
    ora event_counter+1
    beq end_of_sequence

    ; Else we force decrement the counter
    jsr ProcessEvent

    ; Then the 8 bit event value
    lda (ptr_music_events),y
    sta _MusicEvent

    ; Point to the next entry
    clc
    lda ptr_music_events+0
    adc #3
    sta ptr_music_events+0
    lda ptr_music_events+1
    adc #0
    sta ptr_music_events+1
    rts

end_of_sequence
    ; Read the 16 bit event loop pointer
    lda (ptr_music_events),y
    tax
    iny
    lda (ptr_music_events),y
    stx ptr_music_events+0
    sta ptr_music_events+1
    jmp FetchNextEvent
.)
#endif

; Initializes the player.
; _param0+0/+1 contains the pointer to the song header
_StartMusic
.(
    lda _gMusicEnabled
    beq end
    
    lda #0
    sta _MusicLoopIndex

    lda _param0+0           ; Save the pointer to the music 
    sta ptr_music
    lda _param0+1
    sta ptr_music+1
#ifdef USE_MUSIC_EVENTS
    lda _param1+0           ; And the pointer to the events
    sta ptr_music_events+0
    lda _param1+1
    sta ptr_music_events+1
    jsr FetchNextEvent
#endif
    ;Skips the header.
    ldy #1                                             ;Skips the format version.
    lda (ptr_music),Y                                      ;Channel count.
    sta ACCA
    clc
    lda ptr_music                                           
    adc #(1+1)          
    sta ptr_music
    lda ptr_music+1
    adc #0
    sta ptr_music+1                                           

scan_header_loop                                     ;There is always at least one PSG to skip.
    clc
    lda ptr_music                                           
    adc #4
    sta ptr_music
    lda ptr_music+1
    adc #0
    sta ptr_music+1

    lda ACCA                                           
    sec
    sbc #3                                             ;A PSG is three channels.
    beq end_header_loop

    sta ACCA                      
    BCS scan_header_loop                     ;Security in case of the PSG channel is not a multiple of 3.

end_header_loop 
    lda ptr_music                                           
    sta auto_linker_low
    lda ptr_music+1
    sta auto_linker_high              ;ptData now points on the Linker.
    lda #OPCODE_CLC
    sta PLY_AKY_CHANNEL1_REGISTERBLOCKLINESTATE_OPCODE  
    sta PLY_AKY_CHANNEL2_REGISTERBLOCKLINESTATE_OPCODE  
    sta PLY_AKY_CHANNEL3_REGISTERBLOCKLINESTATE_OPCODE  
    lda #<01                                            
    sta auto_pattern_low                   
    lda #>01
    sta auto_pattern_high

    lda #OPCODE_NOP
    sta auto_play_stop   ; Enable the music player frame callback
end    
    rts
.)

_EndMusic
    lda #0
    sta _MusicMixerMask   ; Release all the reserved channels
    sta _MusicLoopIndex
    lda #OPCODE_RTS
    sta auto_play_stop   ; Disable the music player frame callback
    jmp _PsgStopSound

; Plays the music. It must have been initialized before.
_PlayMusicFrame
auto_play_stop 
    rts
#ifdef USE_MUSIC_EVENTS    
    jsr ProcessEvent
#endif    
    lda #1
    sta _PsgNeedUpdate
            
PLY_AKY_PATTERNFRAMECOUNTER 
auto_pattern_low = *+1
    lda #$01                                            
    sta ptr_music
auto_pattern_high = *+1    
    lda #$00
    sta ptr_music+1
    lda ptr_music
.(
    bne label
    dec ptr_music+1
label 
.)           
    dec ptr_music            
    lda ptr_music                                          
    ora ptr_music+1                                           
    beq PLY_AKY_PATTERNFRAMECOUNTER_OVER                
    lda ptr_music                                          
    sta auto_pattern_low
    lda ptr_music+1
    sta auto_pattern_high
    jmp PLY_AKY_CHANNEL1_WAITBEFORENEXTREGISTERBLOCK    

PLY_AKY_PATTERNFRAMECOUNTER_OVER
;The pattern is not over.
;PLY_AKY_PTLINKER 
    inc _MusicLoopIndex
auto_linker_low = *+1
    lda #$AC                                            ;Points on the Pattern of the linker.
    sta pt2_DT
auto_linker_high = *+1
    lda #$AC
    sta pt2_DT+1
    ldy #0                                             ;Gets the duration of the Pattern, or 0 if end of the song.
    lda (pt2_DT),Y
    sta ptr_music
    iny
    lda (pt2_DT),Y
    sta ptr_music+1
    ora ptr_music                                           
    bne PLY_AKY_LINKERNOTENDSONG      

end_of_song                      
    ;End of the song. Where to loop?
    iny                                                 
    lda (pt2_DT),Y
    sta ptr_music
    iny
    lda (pt2_DT),Y
    ;We directly point on the frame counter of the pattern to loop to.
    sta pt2_DT+1                                        
    lda ptr_music
    sta pt2_DT
    ;Gets the duration again. No need to check the end of the song,
    ;we know it contains at least one pattern.
    ldy #0                                             
    lda (pt2_DT),Y
    sta ptr_music
    iny
    lda (pt2_DT),Y
    sta ptr_music+1

PLY_AKY_LINKERNOTENDSONG
    lda ptr_music
    sta auto_pattern_low                   
    lda ptr_music+1
    sta auto_pattern_high
    iny      
                                               
    lda (pt2_DT),Y                                      
    sta auto_chan1_track_low
    iny
    lda (pt2_DT),Y
    sta auto_chan1_track_high
    iny                                                 
    lda (pt2_DT),Y                                      
    sta auto_chan2_track_low
    iny
    lda (pt2_DT),Y
    sta auto_chan2_track_high
    iny                                                 
    lda (pt2_DT),Y                                      
    sta auto_chan3_track_low
    iny
    lda (pt2_DT),Y
    sta auto_chan3_track_high

    clc
    lda pt2_DT                                          
    adc #8                                             ; fix pt2_DT value                                          
    sta auto_linker_low
    lda pt2_DT+1
    adc #0
    sta auto_linker_high

    ;Resets the RegisterBlocks of the channel >1. The first one is skipped so there is no need to do so.
    lda #1                                             
    sta PLY_AKY_CHANNEL2_WAITBEFORENEXTREGISTERBLOCK+1  
    sta PLY_AKY_CHANNEL3_WAITBEFORENEXTREGISTERBLOCK+1  
    jmp PLY_AKY_CHANNEL1_WAITBEFORENEXTREGISTERBLOCK_OVER

; =====================================
;Reading the Tracks.
; =====================================
PLY_AKY_CHANNEL1_WAITBEFORENEXTREGISTERBLOCK 
    lda #01                                             ;Frames to wait before reading the next RegisterBlock. 0 = finished.
    sta ACCA                                           
    dec ACCA
    bne PLY_AKY_CHANNEL1_REGISTERBLOCK_PROCESS          
PLY_AKY_CHANNEL1_WAITBEFORENEXTREGISTERBLOCK_OVER
    ;This RegisterBlock is finished. Reads the next one from the Track.
    ;Obviously, starts at the initial state.
    lda #OPCODE_CLC                                            ; Carry clear (return to initial state)                             
    sta PLY_AKY_CHANNEL1_REGISTERBLOCKLINESTATE_OPCODE  
PLY_AKY_CHANNEL1_PTTRACK 
auto_chan1_track_low = *+1
    lda #$AC                                            ;Points on the Track.
    sta pt2_DT
auto_chan1_track_high = *+1
    lda #$AC
    sta pt2_DT+1

    ldy #00                                             ;Gets the duration.
    lda (pt2_DT),Y
    sta ACCA
    iny                                                 ;Reads the RegisterBlock address.
    lda (pt2_DT),Y
    sta ptr_music
    iny
    lda (pt2_DT),Y
    sta ptr_music+1
    clc
    lda pt2_DT
    adc #03         
    sta auto_chan1_track_low                      
    lda pt2_DT+1
    adc #00
    sta auto_chan1_track_high

    lda ptr_music                                           
    sta PLY_AKY_CHANNEL1_PTREGISTERBLOCK+1
    lda ptr_music+1
    sta PLY_AKY_CHANNEL1_PTREGISTERBLOCK+5
    ;A is the duration of the block.
PLY_AKY_CHANNEL1_REGISTERBLOCK_PROCESS
    ;Processes the RegisterBlock, whether it is the current one or a new one.
    lda ACCA                                           
    sta PLY_AKY_CHANNEL1_WAITBEFORENEXTREGISTERBLOCK+1

PLY_AKY_CHANNEL2_WAITBEFORENEXTREGISTERBLOCK 
    lda #$01                                            ;Frames to wait before reading the next RegisterBlock. 0 = finished.
    sta ACCA                                           
    dec ACCA
    bne PLY_AKY_CHANNEL2_REGISTERBLOCK_PROCESS          
PLY_AKY_CHANNEL2_WAITBEFORENEXTREGISTERBLOCK_OVER
    ;This RegisterBlock is finished. Reads the next one from the Track.
    ;Obviously, starts at the initial state.
    lda #OPCODE_CLC                                            ; Carry clear (return to initial state)
    sta PLY_AKY_CHANNEL2_REGISTERBLOCKLINESTATE_OPCODE  
PLY_AKY_CHANNEL2_PTTRACK 
auto_chan2_track_low = *+1
    lda #$AC                                            ;Points on the Track.
    sta pt2_DT
auto_chan2_track_high = *+1    
    lda #$AC
    sta pt2_DT+1                                         

    ldy #00                                             ;Gets the duration.
    lda (pt2_DT),Y
    sta ACCA
    iny                                                 ;Reads the RegisterBlock address.
    lda (pt2_DT),Y
    sta ptr_music
    iny
    lda (pt2_DT),Y
    sta ptr_music+1
    clc
    lda pt2_DT
    adc #03                                             
    sta auto_chan2_track_low                      
    lda pt2_DT+1
    adc #00
    sta auto_chan2_track_high

    lda ptr_music                                           
    sta PLY_AKY_CHANNEL2_PTREGISTERBLOCK+1
    lda ptr_music+1
    sta PLY_AKY_CHANNEL2_PTREGISTERBLOCK+5
    ;A is the duration of the block.
PLY_AKY_CHANNEL2_REGISTERBLOCK_PROCESS
    ;Processes the RegisterBlock, whether it is the current one or a new one.
    lda ACCA                                           
    sta PLY_AKY_CHANNEL2_WAITBEFORENEXTREGISTERBLOCK+1

PLY_AKY_CHANNEL3_WAITBEFORENEXTREGISTERBLOCK 
    lda #$01                                            ;Frames to wait before reading the next RegisterBlock. 0 = finished.
    sta ACCA                                           
    dec ACCA
    bne PLY_AKY_CHANNEL3_REGISTERBLOCK_PROCESS          
PLY_AKY_CHANNEL3_WAITBEFORENEXTREGISTERBLOCK_OVER
    ;This RegisterBlock is finished. Reads the next one from the Track.
    ;Obviously, starts at the initial state.
    lda #OPCODE_CLC                                            ; Carry clear (return to initial state)
    sta PLY_AKY_CHANNEL3_REGISTERBLOCKLINESTATE_OPCODE  

PLY_AKY_CHANNEL3_PTTRACK 
auto_chan3_track_low = *+1
    lda #$AC                                            ;Points on the Track.
    sta pt2_DT
auto_chan3_track_high = *+1
    lda #$AC
    sta pt2_DT+1                                        

    ldy #00                                             ;Gets the duration.
    lda (pt2_DT),Y
    sta ACCA
    iny                                                 ;Reads the RegisterBlock address.
    lda (pt2_DT),Y
    sta ptr_music
    iny
    lda (pt2_DT),Y
    sta ptr_music+1
    clc
    lda pt2_DT
    adc #03        
    sta auto_chan3_track_low                     
    lda pt2_DT+1
    adc #00
    sta auto_chan3_track_high

    lda ptr_music                                          
    sta PLY_AKY_CHANNEL3_PTREGISTERBLOCK+1
    lda ptr_music+1
    sta PLY_AKY_CHANNEL3_PTREGISTERBLOCK+5
    ;A is the duration of the block.
PLY_AKY_CHANNEL3_REGISTERBLOCK_PROCESS
    ;Processes the RegisterBlock, whether it is the current one or a new one. 
    lda ACCA                                          
    sta PLY_AKY_CHANNEL3_WAITBEFORENEXTREGISTERBLOCK+1

; =====================================
; Reading the RegisterBlock.
; =====================================
    lda #08
    sta volumeRegister                                  ; first volume register
    LDX #00                                             ; first frequency register
    ldy #00                                             ; Y = 0 (all the time)
    ; Register 7 with default values: fully sound-open but noise-close.
    ;R7 has been shift twice to the left, it will be shifted back as the channels are treated.
    lda #$E0
    sta r7                                               
    ;Channel 1            
PLY_AKY_CHANNEL1_PTREGISTERBLOCK
    lda #$AC                                            ;Points on the data of the RegisterBlock to read.
    sta ptr_music
    lda #$AC
    sta ptr_music+1
PLY_AKY_CHANNEL1_REGISTERBLOCKLINESTATE_OPCODE
    clc                                                 ; Clear C (initial STATE) / Set C (non initial STATE)
    JSR PLY_AKY_READREGISTERBLOCK
    lda #OPCODE_SEC                                            ; opcode for SEC (no more initial state)
    sta PLY_AKY_CHANNEL1_REGISTERBLOCKLINESTATE_OPCODE
    lda ptr_music                                          ;This is new pointer on the RegisterBlock.
    sta PLY_AKY_CHANNEL1_PTREGISTERBLOCK+1
    lda ptr_music+1
    sta PLY_AKY_CHANNEL1_PTREGISTERBLOCK+5

    ;Channel 2
    ;Shifts the R7 for the next channels.
    lsr r7                                                  
PLY_AKY_CHANNEL2_PTREGISTERBLOCK 
    lda #$AC                                            ;Points on the data of the RegisterBlock to read.
    sta ptr_music
    lda #$AC
    sta ptr_music+1
PLY_AKY_CHANNEL2_REGISTERBLOCKLINESTATE_OPCODE
    clc                                                 ; Clear C (initial STATE) / Set C (non initial STATE)
    jsr PLY_AKY_READREGISTERBLOCK
    lda #OPCODE_SEC                                            ; opcode for SEC (no more initial state)
    sta PLY_AKY_CHANNEL2_REGISTERBLOCKLINESTATE_OPCODE
    lda ptr_music                                          ;This is new pointer on the RegisterBlock.
    sta PLY_AKY_CHANNEL2_PTREGISTERBLOCK+1
    lda ptr_music+1
    sta PLY_AKY_CHANNEL2_PTREGISTERBLOCK+5

    ;Channel 3
    ;Shifts the R7 for the next channels.
    ror r7                                                  
PLY_AKY_CHANNEL3_PTREGISTERBLOCK
    lda #$AC                                            ;Points on the data of the RegisterBlock to read.
    sta ptr_music
    lda #$AC
    sta ptr_music+1
PLY_AKY_CHANNEL3_REGISTERBLOCKLINESTATE_OPCODE
    clc                                                 ; Clear C (initial STATE) / Set C (non initial STATE)
    JSR PLY_AKY_READREGISTERBLOCK
    lda #OPCODE_SEC                                            ; opcode for SEC (no more initial state)
    sta PLY_AKY_CHANNEL3_REGISTERBLOCKLINESTATE_OPCODE
    lda ptr_music                                          ;This is new pointer on the RegisterBlock.
    sta PLY_AKY_CHANNEL3_PTREGISTERBLOCK+1
    lda ptr_music+1
    sta PLY_AKY_CHANNEL3_PTREGISTERBLOCK+5
    
    ; Almost all the channel specific registers have been sent. Now sends the remaining registers (6, 7, 11, 12, 13).
    ; Register 7. Note that managing register 7 before 6/11/12 is done on purpose.
    lda r7                           ; Register 7
    sta _MusicPsgmixer               ; Should probably do some magic to avoid overwriting the special effect values on the other channels

#ifdef PLY_AKY_USE_Noise                                       ;CONFIG SPECIFIC
    lda PLY_AKY_PSGREGISTER6         ; Register 6
    sta _MusicPsgfreqNoise
#endif

#ifdef PLY_CFG_UseHardwareSounds                               ;CONFIG SPECIFIC
    lda PLY_AKY_PSGREGISTER11         ; Register 11
    sta _MusicPsgfreqShape+0
 
    lda PLY_AKY_PSGREGISTER12         ; Register 12 
    sta _MusicPsgfreqShape+1 
    
PLY_AKY_PSGREGISTER13_CODE
    lda PLY_AKY_PSGREGISTER13
PLY_AKY_PSGREGISTER13_RETRIG
    CMP #$FF                                            ;If IsRetrig?, force the R13 to be triggered.                            
    beq PLY_AKY_PSGREGISTER13_END
    sta PLY_AKY_PSGREGISTER13_RETRIG+1

    lda PLY_AKY_PSGREGISTER13         ; Register 13
    sta _MusicPsgenvShape             ; Probably need a way to avoid the retrig of enveloppe in audio.s
    lda #1
    sta _MusicPsgenvReset             ; Indicate the IRQ code that yes we want to update the register
PLY_AKY_PSGREGISTER13_END
#endif
PLY_AKY_EXIT 

            rts       
; -----------------------------------------------------------------------------
;Generic code interpreting the RegisterBlock
; IN:   PtData = First Byte
;       Carry = 0 = initial state, 1 = non-initial state. 
; -----------------------------------------------------------------------------
PLY_AKY_READREGISTERBLOCK
    PHP                                                 ; save c
    lda (ptr_music),Y
    sta ACCA
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    PLP                                                 ; restore c
.(            
    bcc label
    jmp PLY_AKY_RRB_NONINITIALSTATE                     
label 
.)           

    ;Initial state.
    ror ACCA
.(            
    bcc label
    jmp PLY_AKY_RRB_IS_SOFTWAREONLYORSOFTWAREANDHARDWARE
label 
.)           


    ror ACCA
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
    BCS PLY_AKY_RRB_IS_HARDWAREONLY
#endif
; -----------------------------------------------------------------------------
;Generic code interpreting the RegisterBlock - Initial state.
; IN:   ptData = Points after the first byte.
;       ACCA (A) = First byte, twice shifted to the right (type removed).
;       r7 = Register 7. All sounds are open (0) by default, all noises closed (1).
;       volumeRegister = Volume register.
;       X = LSB frequency register.
;       Y used
;
; OUT:  ptData MUST point after the structure.
;       r7 = updated (ONLY bit 2 and 5).
;       volumeRegister = Volume register increased of 1 (*** IMPORTANT! The code MUST increase it, even if not using it! ***)
;       X = LSB frequency register, increased of 2.
;       Y = 0
; -----------------------------------------------------------------------------
PLY_AKY_RRB_IS_NOSOFTWARENOHARDWARE
    ;No software no hardware.
    ror ACCA                                           ;Noise?
    bcc PLY_AKY_RRB_NIS_NOSOFTWARENOHARDWARE_READVOLUME
    ;There is a noise. Reads it.
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER6
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    ;Opens the noise channel.
    lda r7
    and #%11011111                                      ; reset bit 5 (open)
    sta r7
    
PLY_AKY_RRB_NIS_NOSOFTWARENOHARDWARE_READVOLUME
    ;The volume is now in b0-b3.
    ;and %1111      ;No need, the bit 7 was 0.

    ;Sends the volume.
    stx save_x
    ldx volumeRegister
    lda ACCA
    sta _MusicPsgVirtualRegisters,x
    ldx save_x

    inc volumeRegister                                  ;Increases the volume register.
    inx                                                 ;Increases the frequency register.
    inx

    ;Closes the sound channel.
    lda r7
    ora #%00000100                                      ; set bit 2 (close)
    sta r7
    rts
; -------------------------------------
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
PLY_AKY_RRB_IS_HARDWAREONLY
    ;Retrig?
    ror ACCA
    bcc PLY_AKY_RRB_IS_HO_NORETRIG
    lda ACCA
    ora #%10000000                                      
    sta ACCA   
    sta PLY_AKY_PSGREGISTER13_RETRIG+1                  ;A value to make sure the retrig is performed, yet A can still be use.
PLY_AKY_RRB_IS_HO_NORETRIG
    ;Noise?
    ror ACCA 
    bcc PLY_AKY_RRB_IS_HO_NONOISE
    ;Reads the noise.
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER6
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
           
    ;Opens the noise channel.
    lda r7
    and #%11011111                                      ; reset bit 5 (open)
    sta r7
PLY_AKY_RRB_IS_HO_NONOISE
    ;The envelope.
    lda ACCA
    and #15
    sta PLY_AKY_PSGREGISTER13
    ;Copies the hardware period.
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER11
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER12
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    ;Closes the sound channel.
    lda r7
    ora #%00000100                                      ; set bit 2 (close)
    sta r7

    stx save_x
    ldx volumeRegister
    lda #$FF                                            ;Value (volume to 16)
    sta _MusicPsgVirtualRegisters,x
    ldx save_x

    inc volumeRegister                                  ;Increases the volume register.                              
    inx                                                 ;Increases the frequency register (mandatory!).
    inx
    rts
#endif

; -------------------------------------
PLY_AKY_RRB_IS_SOFTWAREONLYORSOFTWAREANDHARDWARE
    ;Another decision to make about the sound type.
    ror ACCA
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
.(            
    bcc label
    jmp PLY_AKY_RRB_IS_SOFTWAREANDHARDWARE
label 
.)           

#endif

    ;Software only. Structure: 0vvvvntt.
    ;Noise?
    ror ACCA
    bcc PLY_AKY_RRB_IS_SOFTWAREONLY_NONOISE
    ;Noise. Reads it.
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER6
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    ;Opens the noise channel.
    lda r7
    and #%11011111                                      ; reset bit 5 (open)
    sta r7

PLY_AKY_RRB_IS_SOFTWAREONLY_NONOISE
    ;Reads the volume (now b0-b3).
    ;Note: we do NOT peform a "and %1111" because we know the bit 7 of the original byte is 0, so the bit 4 is currently 0. Else the hardware volume would be on!
    ;Sends the volume.
    stx save_x
    ldx volumeRegister
    lda ACCA
    sta _MusicPsgVirtualRegisters,x
    ldx save_x
    
    inc volumeRegister                                  ;Increases the volume register.
            
    ;Sends the LSB software frequency.
    ;Reads the software period.
    lda (ptr_music),Y
    sta _MusicPsgVirtualRegisters,x

    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           

    inx                                                ;Increases the frequency register.         

    ;Sends the MSB software frequency.
    lda (ptr_music),Y
    sta _MusicPsgVirtualRegisters,x

    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    inx                                                 ;Increases the frequency register.   
    rts


; -------------------------------------
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
PLY_AKY_RRB_IS_SOFTWAREANDHARDWARE
    ;Retrig?
    ror ACCA
#ifdef PLY_CFG_UseRetrig                                       ;CONFIG SPECIFIC
    bcc PLY_AKY_RRB_IS_SAH_NORETRIG
    lda ACCA
    ora #%10000000                                      
    sta PLY_AKY_PSGREGISTER13_RETRIG+1                  ;A value to make sure the retrig is performed, yet A can still be use.
    sta ACCA
PLY_AKY_RRB_IS_SAH_NORETRIG
#endif
    ;Noise?
    ror ACCA
#ifdef PLY_AKY_USE_SoftAndHard_Noise_Agglomerated              ;CONFIG SPECIFIC
    bcc PLY_AKY_RRB_IS_SAH_NONOISE
    ;Reads the noise.

    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER6
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    ;Opens the noise channel.
    lda r7
    and #%11011111                                      ; reset bit 5 (open noise)
    sta r7

PLY_AKY_RRB_IS_SAH_NONOISE
#endif

    ;The envelope.
    lda ACCA
    and #15                         
    sta PLY_AKY_PSGREGISTER13

    ;Sends the LSB software frequency.
    lda (ptr_music),Y
    sta _MusicPsgVirtualRegisters,x   
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    inx                                                 ;Increases the frequency register.           
            
    ;Sends the MSB software frequency.
    lda (ptr_music),Y
    sta _MusicPsgVirtualRegisters,x
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    inx                                                ;Increases the frequency register.
    
    ;Sets the hardware volume.
    stx save_x
    ldx volumeRegister
    lda #$FF                                            ;Value (volume to 16).
    sta _MusicPsgVirtualRegisters,x
    ldx save_x

    inc volumeRegister                                  ;Increases the volume register.                            

    ;Copies the hardware period. 
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER11
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER12
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)              
    rts
#endif

; -------------------------------------
    ;Manages the loop. This code is put here so that no jump needs to be coded when its job is done.
PLY_AKY_RRB_NIS_NOSOFTWARENOHARDWARE_LOOP
    ;Loops. Reads the next pointer to this RegisterBlock.
    lda (ptr_music),Y
    sta ACCA
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    ;Makes another iteration to read the new data.
    ;Since we KNOW it is not an initial state (because no jump goes to an initial state), we can directly go to the right branching.
    ;Reads the first byte.
    lda (ptr_music),Y
    sta ptr_music+1
    lda ACCA
    sta ptr_music
    lda (ptr_music),Y
    sta ACCA
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
          
; -----------------------------------------------------------------------------
;Generic code interpreting the RegisterBlock - Non initial state. See comment about the Initial state for the registers ins/outs.
; -----------------------------------------------------------------------------
PLY_AKY_RRB_NONINITIALSTATE
    ror ACCA
    BCS PLY_AKY_RRB_NIS_SOFTWAREONLYORSOFTWAREANDHARDWARE
    ror ACCA
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
.(            
    bcc label
    jmp PLY_AKY_RRB_NIS_HARDWAREONLY
label 
.)           
    
#endif
    ;No software, no hardware, OR loop.
    lda ACCA
    sta ACCB
    and #03                                             ;Bit 3:loop?/volume bit 0, bit 2: volume?
    CMP #02                                             ;If no volume, yet the volume is >0, it means loop.
    beq PLY_AKY_RRB_NIS_NOSOFTWARENOHARDWARE_LOOP
    ;No loop: so "no software no hardware".
    ;Closes the sound channel.
    lda r7
    ora #%00000100                                      ; set bit 2 (close sound)
    sta r7
    ;Volume? bit 2 - 2.
    lda ACCB
    ror
    bcc PLY_AKY_RRB_NIS_NOVOLUME
    and #15
    sta ACCA

    ;Sends the volume.
    stx save_x
    ldx volumeRegister
    lda ACCA
    sta _MusicPsgVirtualRegisters,x
    ldx save_x

PLY_AKY_RRB_NIS_NOVOLUME
    ;Sadly, have to lose a bit of CPU here, as this must be done in all cases.
    inc volumeRegister                                  ;Next volume register.
    inx                                                 ;Next frequency registers.
    inx

    ;Noise? Was on bit 7, but there has been two shifts. We can't use A, it may have been modified by the volume and.           
    lda #%00100000                                      ; bit 7-2
    bit ACCB
.(            
    bne label
    rts
label 
.)           

    ;Noise.
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER6
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    ;Opens the noise channel.
    lda r7
    and #%11011111                                      ; reset bit 5 (open noise)
    sta r7               
    rts




PLY_AKY_RRB_NIS_SOFTWAREONLYORSOFTWAREANDHARDWARE
    ;Another decision to make about the sound type.
    ror ACCA
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
.(            
    bcc label
    jmp PLY_AKY_RRB_NIS_SOFTWAREANDHARDWARE
label 
.)           
            
#endif
    ;Software only. Structure: mspnoise lsp v  v  v  v  (0  1).
    lda ACCA
    sta ACCB
    ;Gets the volume (already shifted).
    and #15
    sta ACCA

    ;Sends the volume.
    stx save_x
    ldx volumeRegister
    lda ACCA
    sta _MusicPsgVirtualRegisters,x
    ldx save_x

    inc volumeRegister                                   ;Increases the volume register.
    ;LSP? (Least Significant byte of Period). Was bit 6, but now shifted.
    lda #%00010000                                      ; bit 6-2
    bit ACCB
    beq PLY_AKY_RRB_NIS_SOFTWAREONLY_NOLSP
        
    ;Sends the LSB software frequency.
    ;lda FreqRegister
    lda (ptr_music),Y
    sta _MusicPsgVirtualRegisters,x

    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
           
                                                        ; frequency register is not incremented on purpose.
PLY_AKY_RRB_NIS_SOFTWAREONLY_NOLSP
    ;MSP and/OR (Noise and/or new Noise)? (Most Significant byte of Period).
    lda #%00100000                                      ; bit 7-2
    bit ACCB
    bne PLY_AKY_RRB_NIS_SOFTWAREONLY_MSPANDMAYBENOISE
    ;Bit of loss of CPU, but has to be done in all cases.
    inx
    inx
    rts
; -------------------------------------
PLY_AKY_RRB_NIS_SOFTWAREONLY_MSPANDMAYBENOISE
    ;MSP and noise?, in the next byte. nipppp (n = newNoise? i = isNoise? p = MSB period).
    lda (ptr_music),Y                                      ;Useless bits at the end, not a problem.
    sta ACCA
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    ;Sends the MSB software frequency.
    inx                                                 ;Was not increased before.

    ;lda FreqRegister
    lda ACCA
    sta _MusicPsgVirtualRegisters,x

    inx                                                 ;Increases the frequency register.
    rol ACCA                                            ;Carry is isNoise?
.(            
    BCS label
    rts                     
    ;Opens the noise channel.
label 
.)           
    lda r7                                              ; reset bit 5 (open)
    and #%11011111
    sta r7
    ;Is there a new noise value? If yes, gets the noise.
    rol ACCA 
.(            
    BCS label
    rts
label 
.)           

    ;Gets the noise.
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER6
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)             
    rts


; -------------------------------------
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
PLY_AKY_RRB_NIS_HARDWAREONLY
    ;Gets the envelope (initially on b2-b4, but currently on b0-b2). It is on 3 bits, must be encoded on 4. Bit 0 must be 0.
    rol ACCA                    
    lda ACCA 
    sta ACCB
    and #14                 
    sta PLY_AKY_PSGREGISTER13
    ;Closes the sound channel.
    lda r7
    ora #%00000100                                      ; set bit 2 (close)
    sta r7

    ;Hardware volume.
    stx save_x
    ldx volumeRegister
    lda #$FF                                            ;Value (16, hardware volume).
    sta _MusicPsgVirtualRegisters,x
    ldx save_x

    inc volumeRegister                                  ;Increases the volume register.
    inx                                                ;Increases the frequency register.
    inx

    ;LSB for hardware period? Currently on b6.
    lda ACCB
    rol
    rol
    sta ACCA
    bcc PLY_AKY_RRB_NIS_HARDWAREONLY_NOLSB

    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER11
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
PLY_AKY_RRB_NIS_HARDWAREONLY_NOLSB
    ;MSB for hardware period?
    rol ACCA
    bcc PLY_AKY_RRB_NIS_HARDWAREONLY_NOMSB

    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER12
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
           
PLY_AKY_RRB_NIS_HARDWAREONLY_NOMSB
    ;Noise or retrig?
    rol ACCA
.(            
    bcc label
    jmp PLY_AKY_RRB_NIS_HARDWARE_SHARED_NOISEORRETRIG_ANDSTOP
label 
.)           
    rts
#endif

; -------------------------------------
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
PLY_AKY_RRB_NIS_SOFTWAREANDHARDWARE
    ;Hardware volume.
    stx save_x
    ldx volumeRegister
    lda #$FF                                            ;Value (16, hardware volume).
    sta _MusicPsgVirtualRegisters,x
    ldx save_x

    inc volumeRegister                                  ;Increases the volume register.
    ;LSB of hardware period?
    ror ACCA
    bcc PLY_AKY_RRB_NIS_SAHH_AFTERLSBH
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER11
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
PLY_AKY_RRB_NIS_SAHH_AFTERLSBH
    ;MSB of hardware period?
    ror ACCA
    bcc PLY_AKY_RRB_NIS_SAHH_AFTERMSBH
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER12
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
PLY_AKY_RRB_NIS_SAHH_AFTERMSBH
    ;LSB of software period?
    lda ACCA
    ror
    bcc PLY_AKY_RRB_NIS_SAHH_AFTERLSBS
    sta ACCB

    ;Sends the LSB software frequency.
    ;lda FreqRegister
    lda (ptr_music),Y
    sta _MusicPsgVirtualRegisters,x

    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
                                                        ; frequency register not increased on purpose.
    lda ACCB
PLY_AKY_RRB_NIS_SAHH_AFTERLSBS
    ;MSB of software period?
    ror 
    bcc PLY_AKY_RRB_NIS_SAHH_AFTERMSBS
    sta ACCB

    ;Sends the MSB software frequency.
    inx

    ;lda FreqRegister
    lda (ptr_music),Y
    sta _MusicPsgVirtualRegisters,x

    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           

    DEX                                                 ;Yup. Will be compensated below.

    lda ACCB                      
PLY_AKY_RRB_NIS_SAHH_AFTERMSBS
    ;A bit of loss of CPU, but this has to be done every time!
    inx                
    inx                

    ;New hardware envelope?
    ror
    sta ACCA 
    bcc PLY_AKY_RRB_NIS_SAHH_AFTERENVELOPE
    lda (ptr_music),Y
    sta PLY_AKY_PSGREGISTER13
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
PLY_AKY_RRB_NIS_SAHH_AFTERENVELOPE
    ;Retrig and/or noise?
    lda ACCA
    ror
.(            
    BCS label
    rts
label 
.)           

#endif


#ifdef PLY_CFG_UseHardwareSounds                               ;CONFIG SPECIFIC
    ;This code is shared with the HardwareOnly. It reads the Noise/Retrig byte, interprets it and exits.
PLY_AKY_RRB_NIS_HARDWARE_SHARED_NOISEORRETRIG_ANDSTOP
    ;Noise or retrig. Reads the next byte.
    lda (ptr_music),Y
    inc ptr_music
.(            
    bne label
    inc ptr_music+1
label 
.)           
    
    ;Retrig?
    ror 
#ifdef PLY_CFG_UseRetrig                                       ;CONFIG SPECIFIC
    bcc PLY_AKY_RRB_NIS_S_NOR_NORETRIG
    ora #%10000000
    sta PLY_AKY_PSGREGISTER13_RETRIG+1                  ;A value to make sure the retrig is performed, yet A can still be use.
PLY_AKY_RRB_NIS_S_NOR_NORETRIG
#endif

#ifdef PLY_AKY_USE_SoftAndHard_Noise_Agglomerated              ;CONFIG SPECIFIC
    ;Noise? If no, nothing more to do.
    ror
    sta ACCA
.(            
    BCS label
    rts
label 
.)           

    ;Noise. Opens the noise channel.
    lda r7
    and #%11011111                                      ; reset bit 5 (open)
    sta r7
    lda ACCA
    ;Is there a new noise value? If yes, gets the noise.
    ror
.(            
    BCS label
    rts
label 
.)           
    ;Sets the noise.
    sta PLY_AKY_PSGREGISTER6
#endif
    rts
#endif


