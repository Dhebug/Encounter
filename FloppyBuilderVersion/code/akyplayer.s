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

; === > ORIC 1/ATMOS <===
#define VIA_ORA       $30F
#define VIA_PCR       $30C
#define F_SET_REG     $FF
#define F_INACTIVE    $DD
#define F_WRITE_DATA  $FD   


	.zero

ptDATA          .dsb 2   ; = $02      ; +$03
pt2_DT          .dsb 2   ;= $04      ; +$05

    .zero
    //.text

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


; =============================================================================
;Is there a loaded Player Configuration source? If no, use a default configuration.
; => to generate Player Configuration, see export option in Arkos Tracker 2 
; simplified version...
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

; Initializes the player.
; _param0+0/+1 contains the pointer to the song header
_StartMusic
            LDA _param0+0    ; #<Main_Subsong0                                  
            STA ptDATA
            LDA _param0+1    ;#>Main_Subsong0
            STA ptDATA+1
            ;Skips the header.
            LDY #01                                             ;Skips the format version.
            LDA (ptDATA),Y                                      ;Channel count.
            STA ACCA
            CLC
            LDA ptDATA                                           
            ADC #(1+1)          
            STA ptDATA
            LDA ptDATA+1
            ADC #00
            STA ptDATA+1                                           
                                                                
PLY_AKY_INIT_SKIPHEADERLOOP                                     ;There is always at least one PSG to skip.
            CLC
            LDA ptDATA                                           
            ADC #4
            STA ptDATA
            LDA ptDATA+1
            ADC #00
            STA ptDATA+1
            LDA ACCA                                           
            SEC
            SBC #03                                             ;A PSG is three channels.
            BEQ PLY_AKY_INIT_SKIPHEADEREND
            STA ACCA                      
            BCS PLY_AKY_INIT_SKIPHEADERLOOP                     ;Security in case of the PSG channel is not a multiple of 3.
PLY_AKY_INIT_SKIPHEADEREND 
            LDA ptDATA                                           
            STA PLY_AKY_PATTERNFRAMECOUNTER_OVER+1
            LDA ptDATA+1
            STA PLY_AKY_PATTERNFRAMECOUNTER_OVER+5              ;ptData now points on the Linker.
            LDA #$18        ; CLC                               
            STA PLY_AKY_CHANNEL1_REGISTERBLOCKLINESTATE_OPCODE  
            STA PLY_AKY_CHANNEL2_REGISTERBLOCKLINESTATE_OPCODE  
            STA PLY_AKY_CHANNEL3_REGISTERBLOCKLINESTATE_OPCODE  
            LDA #<01                                            
            STA PLY_AKY_PATTERNFRAMECOUNTER+1                   
            LDA #>01
            STA PLY_AKY_PATTERNFRAMECOUNTER+5
            RTS

_EndMusic
    jmp _PsgStopSound

; Plays the music. It must have been initialized before.
_PlayMusicFrame
            
PLY_AKY_PATTERNFRAMECOUNTER 
            LDA #$01                                            
            STA ptDATA
            LDA #$00
            STA ptDATA+1
            LDA ptDATA
.(
            BNE label
            DEC ptDATA+1
label 
.)           
            DEC ptDATA            
            LDA ptDATA                                          
            ORA ptDATA+1                                           
            BEQ PLY_AKY_PATTERNFRAMECOUNTER_OVER                
            LDA ptDATA                                          
            STA PLY_AKY_PATTERNFRAMECOUNTER+1
            LDA ptDATA+1
            STA PLY_AKY_PATTERNFRAMECOUNTER+5
            JMP PLY_AKY_CHANNEL1_WAITBEFORENEXTREGISTERBLOCK    
PLY_AKY_PATTERNFRAMECOUNTER_OVER
;The pattern is not over.
PLY_AKY_PTLINKER 
            LDA #$AC                                            ;Points on the Pattern of the linker.
            STA pt2_DT
            LDA #$AC
            STA pt2_DT+1
            LDY #00                                             ;Gets the duration of the Pattern, or 0 if end of the song.
            LDA (pt2_DT),Y
            STA ptDATA
            INY
            LDA (pt2_DT),Y
            STA ptDATA+1
            ORA ptDATA                                           
            BNE PLY_AKY_LINKERNOTENDSONG                        
            ;End of the song. Where to loop?
            INY                                                 
            LDA (pt2_DT),Y
            STA ptDATA
            INY
            LDA (pt2_DT),Y
            ;We directly point on the frame counter of the pattern to loop to.
            STA pt2_DT+1                                        
            LDA ptDATA
            STA pt2_DT
            ;Gets the duration again. No need to check the end of the song,
            ;we know it contains at least one pattern.
            LDY #00                                             
            LDA (pt2_DT),Y
            STA ptDATA
            INY
            LDA (pt2_DT),Y
            STA ptDATA+1
PLY_AKY_LINKERNOTENDSONG
            LDA ptDATA
            STA PLY_AKY_PATTERNFRAMECOUNTER+1                   
            LDA ptDATA+1
            STA PLY_AKY_PATTERNFRAMECOUNTER+5
            INY                                                 
            LDA (pt2_DT),Y                                      
            STA PLY_AKY_CHANNEL1_PTTRACK+1
            INY
            LDA (pt2_DT),Y
            STA PLY_AKY_CHANNEL1_PTTRACK+5
            INY                                                 
            LDA (pt2_DT),Y                                      
            STA PLY_AKY_CHANNEL2_PTTRACK+1
            INY
            LDA (pt2_DT),Y
            STA PLY_AKY_CHANNEL2_PTTRACK+5
            INY                                                 
            LDA (pt2_DT),Y                                      
            STA PLY_AKY_CHANNEL3_PTTRACK+1
            INY
            LDA (pt2_DT),Y
            STA PLY_AKY_CHANNEL3_PTTRACK+5
            CLC
            LDA pt2_DT                                          
            ADC #08                                             ; fix pt2_DT value                                          
            STA PLY_AKY_PATTERNFRAMECOUNTER_OVER+1
            LDA pt2_DT+1
            ADC #00
            STA PLY_AKY_PATTERNFRAMECOUNTER_OVER+5
            ;Resets the RegisterBlocks of the channel >1. The first one is skipped so there is no need to do so.
            LDA #01                                             
            STA PLY_AKY_CHANNEL2_WAITBEFORENEXTREGISTERBLOCK+1  
            STA PLY_AKY_CHANNEL3_WAITBEFORENEXTREGISTERBLOCK+1  
            JMP PLY_AKY_CHANNEL1_WAITBEFORENEXTREGISTERBLOCK_OVER

; =====================================
;Reading the Tracks.
; =====================================
PLY_AKY_CHANNEL1_WAITBEFORENEXTREGISTERBLOCK 
            LDA #01                                             ;Frames to wait before reading the next RegisterBlock. 0 = finished.
            STA ACCA                                           
            DEC ACCA
            BNE PLY_AKY_CHANNEL1_REGISTERBLOCK_PROCESS          
PLY_AKY_CHANNEL1_WAITBEFORENEXTREGISTERBLOCK_OVER
            ;This RegisterBlock is finished. Reads the next one from the Track.
            ;Obviously, starts at the initial state.
            LDA #$18                                            ; Carry clear (return to initial state)                             
            STA PLY_AKY_CHANNEL1_REGISTERBLOCKLINESTATE_OPCODE  
PLY_AKY_CHANNEL1_PTTRACK 
            LDA #$AC                                            ;Points on the Track.
            STA pt2_DT
            LDA #$AC
            STA pt2_DT+1
    
            LDY #00                                             ;Gets the duration.
            LDA (pt2_DT),Y
            STA ACCA
            INY                                                 ;Reads the RegisterBlock address.
            LDA (pt2_DT),Y
            STA ptDATA
            INY
            LDA (pt2_DT),Y
            STA ptDATA+1
            CLC
            LDA pt2_DT
            ADC #03         
            STA PLY_AKY_CHANNEL1_PTTRACK+1                      
            LDA pt2_DT+1
            ADC #00
            STA PLY_AKY_CHANNEL1_PTTRACK+5
    
            LDA ptDATA                                           
            STA PLY_AKY_CHANNEL1_PTREGISTERBLOCK+1
            LDA ptDATA+1
            STA PLY_AKY_CHANNEL1_PTREGISTERBLOCK+5
            ;A is the duration of the block.
PLY_AKY_CHANNEL1_REGISTERBLOCK_PROCESS
            ;Processes the RegisterBlock, whether it is the current one or a new one.
            LDA ACCA                                           
            STA PLY_AKY_CHANNEL1_WAITBEFORENEXTREGISTERBLOCK+1

PLY_AKY_CHANNEL2_WAITBEFORENEXTREGISTERBLOCK 
            LDA #$01                                            ;Frames to wait before reading the next RegisterBlock. 0 = finished.
            STA ACCA                                           
            DEC ACCA
            BNE PLY_AKY_CHANNEL2_REGISTERBLOCK_PROCESS          
PLY_AKY_CHANNEL2_WAITBEFORENEXTREGISTERBLOCK_OVER
            ;This RegisterBlock is finished. Reads the next one from the Track.
            ;Obviously, starts at the initial state.
            LDA #$18                                            ; Carry clear (return to initial state)
            STA PLY_AKY_CHANNEL2_REGISTERBLOCKLINESTATE_OPCODE  
PLY_AKY_CHANNEL2_PTTRACK 
            LDA #$AC                                            ;Points on the Track.
            STA pt2_DT
            LDA #$AC
            STA pt2_DT+1                                         
    
            LDY #00                                             ;Gets the duration.
            LDA (pt2_DT),Y
            STA ACCA
            INY                                                 ;Reads the RegisterBlock address.
            LDA (pt2_DT),Y
            STA ptDATA
            INY
            LDA (pt2_DT),Y
            STA ptDATA+1
            CLC
            LDA pt2_DT
            ADC #03                                             
            STA PLY_AKY_CHANNEL2_PTTRACK+1                      
            LDA pt2_DT+1
            ADC #00
            STA PLY_AKY_CHANNEL2_PTTRACK+5
    
            LDA ptDATA                                           
            STA PLY_AKY_CHANNEL2_PTREGISTERBLOCK+1
            LDA ptDATA+1
            STA PLY_AKY_CHANNEL2_PTREGISTERBLOCK+5
            ;A is the duration of the block.
PLY_AKY_CHANNEL2_REGISTERBLOCK_PROCESS
            ;Processes the RegisterBlock, whether it is the current one or a new one.
            LDA ACCA                                           
            STA PLY_AKY_CHANNEL2_WAITBEFORENEXTREGISTERBLOCK+1

PLY_AKY_CHANNEL3_WAITBEFORENEXTREGISTERBLOCK 
            LDA #$01                                            ;Frames to wait before reading the next RegisterBlock. 0 = finished.
            STA ACCA                                           
            DEC ACCA
            BNE PLY_AKY_CHANNEL3_REGISTERBLOCK_PROCESS          
PLY_AKY_CHANNEL3_WAITBEFORENEXTREGISTERBLOCK_OVER
            ;This RegisterBlock is finished. Reads the next one from the Track.
            ;Obviously, starts at the initial state.
            LDA #$18                                            ; Carry clear (return to initial state)
            STA PLY_AKY_CHANNEL3_REGISTERBLOCKLINESTATE_OPCODE  

PLY_AKY_CHANNEL3_PTTRACK 
            LDA #$AC                                            ;Points on the Track.
            STA pt2_DT
            LDA #$AC
            STA pt2_DT+1                                        
    
            LDY #00                                             ;Gets the duration.
            LDA (pt2_DT),Y
            STA ACCA
            INY                                                 ;Reads the RegisterBlock address.
            LDA (pt2_DT),Y
            STA ptDATA
            INY
            LDA (pt2_DT),Y
            STA ptDATA+1
            CLC
            LDA pt2_DT
            ADC #03        
            STA PLY_AKY_CHANNEL3_PTTRACK+1                     
            LDA pt2_DT+1
            ADC #00
            STA PLY_AKY_CHANNEL3_PTTRACK+5
    
            LDA ptDATA                                          
            STA PLY_AKY_CHANNEL3_PTREGISTERBLOCK+1
            LDA ptDATA+1
            STA PLY_AKY_CHANNEL3_PTREGISTERBLOCK+5
            ;A is the duration of the block.
PLY_AKY_CHANNEL3_REGISTERBLOCK_PROCESS
            ;Processes the RegisterBlock, whether it is the current one or a new one. 
            LDA ACCA                                          
            STA PLY_AKY_CHANNEL3_WAITBEFORENEXTREGISTERBLOCK+1

; =====================================
;Reading the RegisterBlock.
; =====================================
            LDA #08
            STA volumeRegister                                  ; first volume register
            LDX #00                                             ; first frequency register
            LDY #00                                             ; Y = 0 (all the time)
            ; Register 7 with default values: fully sound-open but noise-close.
            ;R7 has been shift twice to the left, it will be shifted back as the channels are treated.
            LDA #$E0
            STA r7                                               
            ;Channel 1            
PLY_AKY_CHANNEL1_PTREGISTERBLOCK
            LDA #$AC                                            ;Points on the data of the RegisterBlock to read.
            STA ptDATA
            LDA #$AC
            STA ptDATA+1
PLY_AKY_CHANNEL1_REGISTERBLOCKLINESTATE_OPCODE
            CLC                                                 ; Clear C (initial STATE) / Set C (non initial STATE)
            JSR PLY_AKY_READREGISTERBLOCK
            LDA #$38                                            ; opcode for SEC (no more initial state)
            STA PLY_AKY_CHANNEL1_REGISTERBLOCKLINESTATE_OPCODE
            LDA ptDATA                                          ;This is new pointer on the RegisterBlock.
            STA PLY_AKY_CHANNEL1_PTREGISTERBLOCK+1
            LDA ptDATA+1
            STA PLY_AKY_CHANNEL1_PTREGISTERBLOCK+5
    
            ;Channel 2
            ;Shifts the R7 for the next channels.
            LSR r7                                                  
PLY_AKY_CHANNEL2_PTREGISTERBLOCK 
            LDA #$AC                                            ;Points on the data of the RegisterBlock to read.
            STA ptDATA
            LDA #$AC
            STA ptDATA+1
PLY_AKY_CHANNEL2_REGISTERBLOCKLINESTATE_OPCODE
            CLC                                                 ; Clear C (initial STATE) / Set C (non initial STATE)
            JSR PLY_AKY_READREGISTERBLOCK
            LDA #$38                                            ; opcode for SEC (no more initial state)
            STA PLY_AKY_CHANNEL2_REGISTERBLOCKLINESTATE_OPCODE
            LDA ptDATA                                          ;This is new pointer on the RegisterBlock.
            STA PLY_AKY_CHANNEL2_PTREGISTERBLOCK+1
            LDA ptDATA+1
            STA PLY_AKY_CHANNEL2_PTREGISTERBLOCK+5
    
            ;Channel 3
            ;Shifts the R7 for the next channels.
            ROR r7                                                  
PLY_AKY_CHANNEL3_PTREGISTERBLOCK
            LDA #$AC                                            ;Points on the data of the RegisterBlock to read.
            STA ptDATA
            LDA #$AC
            STA ptDATA+1
PLY_AKY_CHANNEL3_REGISTERBLOCKLINESTATE_OPCODE
            CLC                                                 ; Clear C (initial STATE) / Set C (non initial STATE)
            JSR PLY_AKY_READREGISTERBLOCK
            LDA #$38                                            ; opcode for SEC (no more initial state)
            STA PLY_AKY_CHANNEL3_REGISTERBLOCKLINESTATE_OPCODE
            LDA ptDATA                                          ;This is new pointer on the RegisterBlock.
            STA PLY_AKY_CHANNEL3_PTREGISTERBLOCK+1
            LDA ptDATA+1
            STA PLY_AKY_CHANNEL3_PTREGISTERBLOCK+5
    
;Almost all the channel specific registers have been sent. Now sends the remaining registers (6, 7, 11, 12, 13).
;Register 7. Note that managing register 7 before 6/11/12 is done on purpose.
#if 0
            ; Original code
            LDA #07                                             ; Register 7 
            STA VIA_ORA         ; $30F
            LDA #F_SET_REG      ; $FF  -> $            
            STA VIA_PCR         ; $30C
            LDA #F_INACTIVE     ; $DD  -> $               
            STA VIA_PCR         ; $30C

            LDA r7      
            STA VIA_ORA         ; $30F
            LDA #F_WRITE_DATA                        
            STA VIA_PCR         ; $30C
            LDA #F_INACTIVE                        
            STA VIA_PCR         ; $30C
#else
            ; Based on the Oric ROM code

            LDA #07         ; Register 7 
            STA $030F       ; Send the YM register number to port A of 6522.

            LDA $030C  		; Set CA2 (BC1 of 8912) to 1,
            ORA #$EE  		; set CB2 (BDIR of 8912) to 1.
            STA $030C  		; 8912 latches the address.
            AND #$11  		; Set CA2 and CB2 to 0, BC1 and
            ORA #$CC  		; BDIR in inactive state.
            STA $030C
            PHA

            LDA r7      
            ORA #$40        ; Only for the Register 7 (to avoid messing with the I/O port)
            STA $030F       ; Send data to 8912 register.

            PLA
            ORA #$EC  		; Set CA2 to 0 and CB2 to 1,
            STA $030C  		; 8912 latches data.
            AND #$11  		; Set CA2 and CB2 to 0, BC1 and
            ORA #$CC 		; BDIR in inactive state.
            STA $030C
#endif

#ifdef PLY_AKY_USE_Noise                                       ;CONFIG SPECIFIC
            LDA #06                                             ; Register 6
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA PLY_AKY_PSGREGISTER6        
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR
#endif

#ifdef PLY_CFG_UseHardwareSounds                               ;CONFIG SPECIFIC
            LDA #11                                             ; Register 11
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA PLY_AKY_PSGREGISTER11       
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA #12                                             ; Register 12 
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA PLY_AKY_PSGREGISTER12       
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

PLY_AKY_PSGREGISTER13_CODE
            LDA PLY_AKY_PSGREGISTER13
PLY_AKY_PSGREGISTER13_RETRIG
            CMP #$FF                                            ;If IsRetrig?, force the R13 to be triggered.                            
            BEQ PLY_AKY_PSGREGISTER13_END
            STA PLY_AKY_PSGREGISTER13_RETRIG+1

            LDA #13                                             ; Register 13
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA PLY_AKY_PSGREGISTER13       
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR
PLY_AKY_PSGREGISTER13_END
#endif
PLY_AKY_EXIT 

            RTS       
; -----------------------------------------------------------------------------
;Generic code interpreting the RegisterBlock
; IN:   PtData = First Byte
;       Carry = 0 = initial state, 1 = non-initial state. 
; -----------------------------------------------------------------------------
PLY_AKY_READREGISTERBLOCK
            PHP                                                 ; save c
            LDA (ptDATA),Y
            STA ACCA
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            PLP                                                 ; restore c
.(            
            BCC label
            JMP PLY_AKY_RRB_NONINITIALSTATE                     
label 
.)           

            ;Initial state.
            ROR ACCA
.(            
            BCC label
            JMP PLY_AKY_RRB_IS_SOFTWAREONLYORSOFTWAREANDHARDWARE
label 
.)           


            ROR ACCA
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
            ROR ACCA                                           ;Noise?
            BCC PLY_AKY_RRB_NIS_NOSOFTWARENOHARDWARE_READVOLUME
            ;There is a noise. Reads it.
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER6
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            ;Opens the noise channel.
            LDA r7
            AND #%11011111                                      ; reset bit 5 (open)
            STA r7
            
PLY_AKY_RRB_NIS_NOSOFTWARENOHARDWARE_READVOLUME
            ;The volume is now in b0-b3.
            ;and %1111      ;No need, the bit 7 was 0.

            ;Sends the volume.
            LDA volumeRegister
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA ACCA
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR
    
            INC volumeRegister                                  ;Increases the volume register.
            INX                                                 ;Increases the frequency register.
            INX
    
            ;Closes the sound channel.
            LDA r7
            ORA #%00000100                                      ; set bit 2 (close)
            STA r7
            RTS
; -------------------------------------
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
PLY_AKY_RRB_IS_HARDWAREONLY
            ;Retrig?
            ROR ACCA
            BCC PLY_AKY_RRB_IS_HO_NORETRIG
            LDA ACCA
            ORA #%10000000                                      
            STA ACCA   
            STA PLY_AKY_PSGREGISTER13_RETRIG+1                  ;A value to make sure the retrig is performed, yet A can still be use.
PLY_AKY_RRB_IS_HO_NORETRIG
            ;Noise?
            ROR ACCA 
            BCC PLY_AKY_RRB_IS_HO_NONOISE
            ;Reads the noise.
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER6
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            ;Opens the noise channel.
            LDA r7
            AND #%11011111                                      ; reset bit 5 (open)
            STA r7
PLY_AKY_RRB_IS_HO_NONOISE
            ;The envelope.
            LDA ACCA
            AND #15
            STA PLY_AKY_PSGREGISTER13
            ;Copies the hardware period.
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER11
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER12
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            ;Closes the sound channel.
            LDA r7
            ORA #%00000100                                      ; set bit 2 (close)
            STA r7

            LDA volumeRegister
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA #$FF                                            ;Value (volume to 16)
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            INC volumeRegister                                  ;Increases the volume register.                              
            INX                                                 ;Increases the frequency register (mandatory!).
            INX
            RTS
#endif

; -------------------------------------
PLY_AKY_RRB_IS_SOFTWAREONLYORSOFTWAREANDHARDWARE
            ;Another decision to make about the sound type.
            ROR ACCA
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
.(            
            BCC label
            JMP PLY_AKY_RRB_IS_SOFTWAREANDHARDWARE
label 
.)           

#endif

            ;Software only. Structure: 0vvvvntt.
            ;Noise?
            ROR ACCA
            BCC PLY_AKY_RRB_IS_SOFTWAREONLY_NONOISE
            ;Noise. Reads it.
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER6
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            ;Opens the noise channel.
            LDA r7
            AND #%11011111                                      ; reset bit 5 (open)
            STA r7

PLY_AKY_RRB_IS_SOFTWAREONLY_NONOISE
            ;Reads the volume (now b0-b3).
            ;Note: we do NOT peform a "and %1111" because we know the bit 7 of the original byte is 0, so the bit 4 is currently 0. Else the hardware volume would be on!
            ;Sends the volume.
            LDA volumeRegister
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA ACCA
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR
            
            INC volumeRegister                                  ;Increases the volume register.
                 
            ;Sends the LSB software frequency.
            ;LDA FreqRegister
            STX VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            ;Reads the software period.
            LDA (ptDATA),Y
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
      
            INX                                                ;Increases the frequency register.         
   
            ;Sends the MSB software frequency.
            ;LDA FreqRegister
            STX VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            ;Reads the software period.
            LDA (ptDATA),Y
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
         
            INX                                                 ;Increases the frequency register.   
            RTS
; -------------------------------------
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
PLY_AKY_RRB_IS_SOFTWAREANDHARDWARE
            ;Retrig?
            ROR ACCA
#ifdef PLY_CFG_UseRetrig                                       ;CONFIG SPECIFIC
            BCC PLY_AKY_RRB_IS_SAH_NORETRIG
            LDA ACCA
            ORA #%10000000                                      
            STA PLY_AKY_PSGREGISTER13_RETRIG+1                  ;A value to make sure the retrig is performed, yet A can still be use.
            STA ACCA
PLY_AKY_RRB_IS_SAH_NORETRIG
#endif
            ;Noise?
            ROR ACCA
#ifdef PLY_AKY_USE_SoftAndHard_Noise_Agglomerated              ;CONFIG SPECIFIC
            BCC PLY_AKY_RRB_IS_SAH_NONOISE
            ;Reads the noise.

            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER6
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            ;Opens the noise channel.
            LDA r7
            AND #%11011111                                      ; reset bit 5 (open noise)
            STA r7

PLY_AKY_RRB_IS_SAH_NONOISE
#endif
            ;The envelope.
            LDA ACCA
            AND #15                         
            STA PLY_AKY_PSGREGISTER13

            ;Sends the LSB software frequency.
            ;LDA FreqRegister
            STX VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            ;Reads the software period.
            LDA (ptDATA),Y
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR
    
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            INX                                                 ;Increases the frequency register.           
                   
            ;Sends the MSB software frequency.
            ;LDA FreqRegister
            STX VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            ;Reads the software period.
            LDA (ptDATA),Y
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
    
            INX                                                ;Increases the frequency register.
            
            ;Sets the hardware volume.
            LDA volumeRegister
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA #$FF                                            ;Value (volume to 16).
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR
   
            INC volumeRegister                                  ;Increases the volume register.                            

            ;Copies the hardware period. 
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER11
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
          
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER12
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
            
            RTS
#endif

; -------------------------------------
            ;Manages the loop. This code is put here so that no jump needs to be coded when its job is done.
PLY_AKY_RRB_NIS_NOSOFTWARENOHARDWARE_LOOP
            ;Loops. Reads the next pointer to this RegisterBlock.
            LDA (ptDATA),Y
            STA ACCA
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            ;Makes another iteration to read the new data.
            ;Since we KNOW it is not an initial state (because no jump goes to an initial state), we can directly go to the right branching.
            ;Reads the first byte.
            LDA (ptDATA),Y
            STA ptDATA+1
            LDA ACCA
            STA ptDATA
            LDA (ptDATA),Y
            STA ACCA
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
          
; -----------------------------------------------------------------------------
;Generic code interpreting the RegisterBlock - Non initial state. See comment about the Initial state for the registers ins/outs.
; -----------------------------------------------------------------------------
PLY_AKY_RRB_NONINITIALSTATE
            ROR ACCA
            BCS PLY_AKY_RRB_NIS_SOFTWAREONLYORSOFTWAREANDHARDWARE
            ROR ACCA
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
.(            
            BCC label
            JMP PLY_AKY_RRB_NIS_HARDWAREONLY
label 
.)           
           
#endif
            ;No software, no hardware, OR loop.
            LDA ACCA
            STA ACCB
            AND #03                                             ;Bit 3:loop?/volume bit 0, bit 2: volume?
            CMP #02                                             ;If no volume, yet the volume is >0, it means loop.
            BEQ PLY_AKY_RRB_NIS_NOSOFTWARENOHARDWARE_LOOP
            ;No loop: so "no software no hardware".
            ;Closes the sound channel.
            LDA r7
            ORA #%00000100                                      ; set bit 2 (close sound)
            STA r7
            ;Volume? bit 2 - 2.
            LDA ACCB
            ROR
            BCC PLY_AKY_RRB_NIS_NOVOLUME
            AND #15
            STA ACCA

            ;Sends the volume.
            LDA volumeRegister
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA ACCA
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

PLY_AKY_RRB_NIS_NOVOLUME
            ;Sadly, have to lose a bit of CPU here, as this must be done in all cases.
            INC volumeRegister                                  ;Next volume register.
            INX                                                 ;Next frequency registers.
            INX

            ;Noise? Was on bit 7, but there has been two shifts. We can't use A, it may have been modified by the volume AND.           
            LDA #%00100000                                      ; bit 7-2
            BIT ACCB
.(            
            BNE label
            RTS
label 
.)           

            ;Noise.
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER6
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            ;Opens the noise channel.
            LDA r7
            AND #%11011111                                      ; reset bit 5 (open noise)
            STA r7               
            RTS
; -------------------------------------
PLY_AKY_RRB_NIS_SOFTWAREONLYORSOFTWAREANDHARDWARE
            ;Another decision to make about the sound type.
            ROR ACCA
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
.(            
            BCC label
            JMP PLY_AKY_RRB_NIS_SOFTWAREANDHARDWARE
label 
.)           
                   
#endif
            ;Software only. Structure: mspnoise lsp v  v  v  v  (0  1).
            LDA ACCA
            STA ACCB
            ;Gets the volume (already shifted).
            AND #15
            STA ACCA
            ;Sends the volume.
            LDA volumeRegister
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA ACCA
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            INC volumeRegister                                   ;Increases the volume register.
            ;LSP? (Least Significant byte of Period). Was bit 6, but now shifted.
            LDA #%00010000                                      ; bit 6-2
            BIT ACCB
            BEQ PLY_AKY_RRB_NIS_SOFTWAREONLY_NOLSP
                
            ;Sends the LSB software frequency.
            ;LDA FreqRegister
            STX VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA (ptDATA),Y
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
                                                                ; frequency register is not incremented on purpose.
PLY_AKY_RRB_NIS_SOFTWAREONLY_NOLSP
            ;MSP AND/OR (Noise and/or new Noise)? (Most Significant byte of Period).
            LDA #%00100000                                      ; bit 7-2
            BIT ACCB
            BNE PLY_AKY_RRB_NIS_SOFTWAREONLY_MSPANDMAYBENOISE
            ;Bit of loss of CPU, but has to be done in all cases.
            INX
            INX
            RTS
; -------------------------------------
PLY_AKY_RRB_NIS_SOFTWAREONLY_MSPANDMAYBENOISE
            ;MSP and noise?, in the next byte. nipppp (n = newNoise? i = isNoise? p = MSB period).
            LDA (ptDATA),Y                                      ;Useless bits at the end, not a problem.
            STA ACCA
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            ;Sends the MSB software frequency.
            INX                                                 ;Was not increased before.

            ;LDA FreqRegister
            STX VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA ACCA
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR
  
            INX                                                 ;Increases the frequency register.
            ROL ACCA                                            ;Carry is isNoise?
.(            
            BCS label
            RTS                     
            ;Opens the noise channel.
label 
.)           
            LDA r7                                              ; reset bit 5 (open)
            AND #%11011111
            STA r7
            ;Is there a new noise value? If yes, gets the noise.
            ROL ACCA 
.(            
            BCS label
            RTS
label 
.)           
    
            ;Gets the noise.
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER6
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            RTS
; -------------------------------------
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
PLY_AKY_RRB_NIS_HARDWAREONLY
            ;Gets the envelope (initially on b2-b4, but currently on b0-b2). It is on 3 bits, must be encoded on 4. Bit 0 must be 0.
            ROL ACCA                    
            LDA ACCA 
            STA ACCB
            AND #14                 
            STA PLY_AKY_PSGREGISTER13
            ;Closes the sound channel.
            LDA r7
            ORA #%00000100                                      ; set bit 2 (close)
            STA r7
            ;Hardware volume.
            LDA volumeRegister
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA #$FF                                            ;Value (16, hardware volume).
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR
    
            INC volumeRegister                                  ;Increases the volume register.
            INX                                                ;Increases the frequency register.
            INX
    
            ;LSB for hardware period? Currently on b6.
            LDA ACCB
            ROL
            ROL
            STA ACCA
            BCC PLY_AKY_RRB_NIS_HARDWAREONLY_NOLSB

            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER11
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
PLY_AKY_RRB_NIS_HARDWAREONLY_NOLSB
            ;MSB for hardware period?
            ROL ACCA
            BCC PLY_AKY_RRB_NIS_HARDWAREONLY_NOMSB

            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER12
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
PLY_AKY_RRB_NIS_HARDWAREONLY_NOMSB
            ;Noise or retrig?
            ROL ACCA
.(            
            BCC label
            JMP PLY_AKY_RRB_NIS_HARDWARE_SHARED_NOISEORRETRIG_ANDSTOP
label 
.)           
           RTS
#endif

; -------------------------------------
#ifdef PLY_AKY_USE_SoftAndHard_Agglomerated                    ;CONFIG SPECIFIC
PLY_AKY_RRB_NIS_SOFTWAREANDHARDWARE
            ;Hardware volume.
            LDA volumeRegister
            STA VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA #$FF                                            ;Value (16 = hardware volume).
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR
    
            INC volumeRegister                                  ;Increases the volume register.
            ;LSB of hardware period?
            ROR ACCA
            BCC PLY_AKY_RRB_NIS_SAHH_AFTERLSBH
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER11
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
PLY_AKY_RRB_NIS_SAHH_AFTERLSBH
            ;MSB of hardware period?
            ROR ACCA
            BCC PLY_AKY_RRB_NIS_SAHH_AFTERMSBH
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER12
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
PLY_AKY_RRB_NIS_SAHH_AFTERMSBH
            ;LSB of software period?
            LDA ACCA
            ROR
            BCC PLY_AKY_RRB_NIS_SAHH_AFTERLSBS
            STA ACCB

            ;Sends the LSB software frequency.
            ;LDA FreqRegister
            STX VIA_ORA     
            LDA #F_SET_REG                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA (ptDATA),Y
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
                                                                ; frequency register not increased on purpose.
            LDA ACCB
PLY_AKY_RRB_NIS_SAHH_AFTERLSBS
            ;MSB of software period?
            ROR 
            BCC PLY_AKY_RRB_NIS_SAHH_AFTERMSBS
            STA ACCB

            ;Sends the MSB software frequency.
            INX

            ;LDA FreqRegister
            STX VIA_ORA     
            LDA #F_SET_REG                      
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            LDA (ptDATA),Y
            STA VIA_ORA
            LDA #F_WRITE_DATA                        
            STA VIA_PCR
            LDA #F_INACTIVE                        
            STA VIA_PCR

            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
   
            DEX                                                 ;Yup. Will be compensated below.

            LDA ACCB                      
PLY_AKY_RRB_NIS_SAHH_AFTERMSBS
            ;A bit of loss of CPU, but this has to be done every time!
            INX                
            INX                

            ;New hardware envelope?
            ROR
            STA ACCA 
            BCC PLY_AKY_RRB_NIS_SAHH_AFTERENVELOPE
            LDA (ptDATA),Y
            STA PLY_AKY_PSGREGISTER13
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
PLY_AKY_RRB_NIS_SAHH_AFTERENVELOPE
            ;Retrig and/or noise?
            LDA ACCA
            ROR
.(            
            BCS label
            RTS
label 
.)           

#endif

#ifdef PLY_CFG_UseHardwareSounds                               ;CONFIG SPECIFIC
            ;This code is shared with the HardwareOnly. It reads the Noise/Retrig byte, interprets it and exits.
PLY_AKY_RRB_NIS_HARDWARE_SHARED_NOISEORRETRIG_ANDSTOP
            ;Noise or retrig. Reads the next byte.
            LDA (ptDATA),Y
            INC ptDATA
.(            
            BNE label
            INC ptDATA+1
label 
.)           
           
            ;Retrig?
            ROR 
#ifdef PLY_CFG_UseRetrig                                       ;CONFIG SPECIFIC
            BCC PLY_AKY_RRB_NIS_S_NOR_NORETRIG
            ORA #%10000000
            STA PLY_AKY_PSGREGISTER13_RETRIG+1                  ;A value to make sure the retrig is performed, yet A can still be use.
PLY_AKY_RRB_NIS_S_NOR_NORETRIG
#endif

#ifdef PLY_AKY_USE_SoftAndHard_Noise_Agglomerated              ;CONFIG SPECIFIC
            ;Noise? If no, nothing more to do.
            ROR
            STA ACCA
.(            
            BCS label
            RTS
label 
.)           

            ;Noise. Opens the noise channel.
            LDA r7
            AND #%11011111                                      ; reset bit 5 (open)
            STA r7
            LDA ACCA
            ;Is there a new noise value? If yes, gets the noise.
            ROR
.(            
            BCS label
            RTS
label 
.)           
           ;Sets the noise.
            STA PLY_AKY_PSGREGISTER6
#endif
            RTS
#endif


