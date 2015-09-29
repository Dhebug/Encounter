
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Sound engine

#include "sound.h"

; Some zero-page variables
.zero 

MusicPlaying		.byt 00

; Pointers to pattern codes (patterns vs indexes in pattern lists)
pcodes_lo			.word 0000
pcodes_hi			.word 0000


; Temporal pointer
zpPointer			.word 0000

; Temporal reg     
snd_tmp             .byt 0

; Last value of pitch per channel (for vibrattos, etc.)
ay_savPitch_hi		.byt 0,0,0
ay_savPitch_lo		.byt 0,0,0

note2pitchtmp		.byt 0,0

; Pointer to pattern list for each channel
PList_lo			.byt 0,0,0
PList_hi			.byt 0,0,0

; Pointers to active pattern for each channel
Pattern_lo			.byt 0,0,0
Pattern_hi			.byt 0,0,0


; Index into pattern list for each channel
ListIndexes			.byt 0,0,0

; Note number to play next, for each channel
NoteCounters		.byt 0,0,0

; RST timers for each channel
IsResting			.byt 0,0,0

; Note offset, for each channel
NoteOffset			.byt 0,0,0

; Amount to substract to volume, for each channel (0-15)
SetVolume			.byt 0,0,0

; Priority of pattern being played
; on each channel. 0 means empty.
; the higher the number, the higher 
; the priority
Priority			.byt 0,0,0

; Timer for speed of music, separate for each channel
TimerCounter		.byt 0,0,0


; Pointers to envelopes, for each channel
Envelopes_lo		.byt 0,0,0
Envelopes_hi		.byt 0,0,0

; Pointers to ornaments, for each channel
Ornaments_lo		.byt 0,0,0
Ornaments_hi		.byt 0,0,0

; Pointer to volume envelope position, for each channel
Env_p				.byt 0,0,0

; Pointer to ornament table position, for each channel
Orn_p				.byt 0,0,0



Sfx					.byt 00
GlobalVolume		.byt 00	

; Song Tempo
Tempo .byt 7

; Sfx flagbyte
SfxFlags .byt 0


.text

__snd_engine_start

/***** Commands in a pattern list *****/

l_commands_lo .byt <EndPatList,<SetEnvelope,<SetOrnament,<NoiseOn,<NoiseOff,<ToneOn,<ToneOff,<NoiseVal,<SetNoteOffset,<Loop,<DoSetVolume,<WaitFlag
l_commands_hi .byt >EndPatList,>SetEnvelope,>SetOrnament,>NoiseOn,>NoiseOff,>ToneOn,>ToneOff,>NoiseVal,>SetNoteOffset,>Loop,>DoSetVolume,>WaitFlag


/* Flags needed for Noise and Tone On/Off commands */

tab_NoiseFlags .byt %00001000, %00010000, %00100000
tab_ToneFlags  .byt %00000001, %00000010, %00000100

/* Implementation of commands */

DoSetVolume
.(
	; Grab parameter
	inc ListIndexes,x
	ldy ListIndexes,x
	lda (zpPointer),y
	sta SetVolume,x
	rts
.)

EndPatList
.(
	; Indicate that nothing else
	; should be played
	lda #0
	sta Pattern_hi,x

	; Silence the channel
	sta ayw_Volume,x
	
	; and mark that channel as free
	sta Priority,x	
	
	; Get rid of context
	pla
	pla

	; This code automatically stops
	; sound if there is nothing to
	; play. Not sure that this is
	; correct for sfx.
	
	lda Pattern_hi
	ora Pattern_hi+1
	ora Pattern_hi+2
	bne notends
	stx savx+1
	jsr StopSound
savx
	ldx #0
notends
	
	rts
.)

SetEnvelope
.(
	; Set the envelope for channel in reg X
	; Get parameter: Envelope number
	inc ListIndexes,x
	ldy ListIndexes,x
	lda (zpPointer),y

	; Each entry has 8 bytes
	asl
	asl
	asl
	clc
	adc #<Envelope_table
	sta Envelopes_lo,x
	lda #>Envelope_table
	adc #0
	sta Envelopes_hi,x
	lda #7
	sta Env_p,x
	rts
.)
SetOrnament
.(
	; Set the Ornament for channel in reg X
	; Get parameter: Ornament number
	inc ListIndexes,x
	ldy ListIndexes,x
	lda (zpPointer),y

	; Each entry has 8 bytes
	asl
	asl
	asl
	clc
	adc #<Ornament_table
	sta Ornaments_lo,x
	lda #>Ornament_table
	adc #0
	sta Ornaments_hi,x
	lda #7
	sta Orn_p,x

	rts
.)


NoiseOn
.(
	lda tab_NoiseFlags,x
	eor #$ff
	and ayw_Status
	sta ayw_Status
	rts
.)

NoiseOff
.(
	lda tab_NoiseFlags,x
	ora ayw_Status
	sta ayw_Status
	rts
.)

ToneOn
.(
	lda tab_ToneFlags,x
	eor #$ff
	and ayw_Status
	sta ayw_Status
	rts
.)

ToneOff
.(
	lda tab_ToneFlags,x
	ora ayw_Status
	sta ayw_Status
	rts
.)


NoiseVal
.(
	; Grab parameter
	inc ListIndexes,x
	ldy ListIndexes,x
	lda (zpPointer),y
	sta ayw_Noise
	rts
.)

SetNoteOffset
.(
	; Grab parameter
	inc ListIndexes,x
	ldy ListIndexes,x
	lda (zpPointer),y
	sta NoteOffset,x
	rts
.)


Loop
.(
	; Grab parameter
	inc ListIndexes,x
	ldy ListIndexes,x
	lda (zpPointer),y
	sec
	sbc #1
	sta ListIndexes,x
	rts
.)

WaitFlag
.(
	; Grab parameter
	ldy ListIndexes+1,x
	lda (zpPointer),y
	and SfxFlags
	bne flagset 
	pla
	pla
	pla
	pla
	dec ListIndexes,x
	;rts
	jmp hackme
flagset	
	inc ListIndexes,x
	; Reset the flag
	lda (zpPointer),y
	eor #$ff
	and SfxFlags
	sta SfxFlags
	rts
.)


/***** End of commands *****/

/* Process next pattern in list */


NextPatternList
.(
	; Process pattern list for channel in reg X
	lda PList_lo,x
	sta zpPointer
	lda PList_hi,x
	sta zpPointer+1

nextinlist
	ldy ListIndexes,x
	lda (zpPointer),y
	bmi command
	tay
	lda (pcodes_lo),y
	sta Pattern_lo,x
	lda (pcodes_hi),y
	sta Pattern_hi,x
	lda #0
	sta NoteCounters,x
	rts
command
	; Process command
	and #%01111111
	tay
	lda l_commands_lo,y
	sta smc_command+1
	lda l_commands_hi,y
	sta smc_command+2
smc_command
	jsr $1234	
	inc ListIndexes,x	
	jmp nextinlist
.)


/***** Commands inside a pattern *****/

p_commands_lo	.byt < end_pattern, <rest, <silence,<pat_noise_on,<pat_noise_off,<pat_tone_on,<pat_tone_off
p_commands_hi	.byt > end_pattern, >rest, >silence,>pat_noise_on,>pat_noise_off,>pat_tone_on,>pat_tone_off

end_pattern
.(
	inc ListIndexes,x
	jsr NextPatternList
	jmp process
.)


silence
.(
	lda #0
	sta ayw_Volume,x
	inc NoteCounters,x
	jmp process
.)


rest
.(
	lda snd_tmp
	and #%1111
	clc
	adc #1
	sta IsResting,x
	jmp end_process
.)

pat_noise_on
.(
	jsr NoiseOn
+common_noise	
	inc NoteCounters,x
	jmp process
.)

pat_noise_off
.(
	jsr NoiseOff
	jmp common_noise
.)

pat_tone_on
.(
	jsr ToneOn
	jmp common_noise
.)

pat_tone_off
.(
	jsr ToneOff
	jmp common_noise
.)



/***** End of commands inside a pattern *****/


/***** Processing music: entry point for player *****/

ProcessMusic
.(
	ldx #2

loop_channels

	lda Pattern_hi,x
	bne continue
	jmp done

continue
	lda TimerCounter,x
	bne nonewnote

proceed
	lda #7
	ldy Env_p,x
	cpy #HOLD_TEMPO-1
	beq skipsettingenv
	sta Env_p,x
skipsettingenv
	sta Orn_p,x

	; Process channel 
+process
	lda IsResting,x
	beq goon
	dec IsResting,x
	bne nonewnote;checkorn
goon
	lda Pattern_hi,x
	;beq done
	bne notdone
	jmp done
notdone	
	sta zpPointer+1
	lda Pattern_lo,x
	sta zpPointer

	ldy NoteCounters,x
	lda (zpPointer),y

	bpl nocommand 
	; Check commands on pattern
	and #%01111111
	; Commands are: 1cccpppp
	sta snd_tmp
	lsr
	lsr
	lsr
	lsr
	tay
	lda p_commands_lo,y
	sta smc_command+1
	lda p_commands_hi,y
	sta smc_command+2
smc_command
	jmp $0000
nocommand

+donote
	clc
	adc NoteOffset,x
	jsr Note2Pitch
	lda note2pitchtmp
	sta ay_savPitch_lo,x
	sta ayw_PitchLo,x
	lda note2pitchtmp+1
	sta ay_savPitch_hi,x
	sta ayw_PitchHi,x
	
+end_process	
	; Increment Counter
	inc NoteCounters,x

+nonewnote
	; Proceed with volume & ornament envelopes, unless we are resting
	lda IsResting,x
	beq checkenv
	cmp #1 
	bne checkorn
	lda ayw_Volume,x
	beq silenced
	
	; Check the envelope
checkenv	
	ldy Env_p,x
	bmi checkorn
	
	lda Tempo
	sec
	sbc TimerCounter,x
	cmp #HOLD_TEMPO+1+1
	bcc nothold
	
	lda TimerCounter,x
	cmp #HOLD_TEMPO+1-2
	bcs checkorn
bkpme
	lda IsResting,x
	cmp #1
	beq nothold
	
	lda Pattern_hi,x
	sta zpPointer+1
	lda Pattern_lo,x
	sta zpPointer
	ldy NoteCounters,x
	;iny
	lda (zpPointer),y
	and #%11110000
	cmp #RST
	beq checkorn
	
nothold
	ldy Env_p,x
	lda Envelopes_lo,x
	sta zpPointer
	lda Envelopes_hi,x
	sta zpPointer+1
	lda (zpPointer),y
	sec
	sbc SetVolume,x
	sbc GlobalVolume
	bpl doit
	lda #0
doit
	sta ayw_Volume,x
	dec Env_p,x

	; Check the ornament
checkorn
	lda Orn_p,x
	and #%111
	tay
	lda Ornaments_lo,x
	sta zpPointer
	lda Ornaments_hi,x
	sta zpPointer+1
    lda #0
    sta snd_tmp
	lda (zpPointer),y
    bpl skipneg
    dec snd_tmp
skipneg
 	clc
	adc ay_savPitch_lo,x
	sta ayw_PitchLo,x
    lda snd_tmp
    adc ay_savPitch_hi,x
	sta ayw_PitchHi,x
done
	dec Orn_p,x

silenced
	; Decrement timer
	dec TimerCounter,x
	bpl skip
	lda Tempo
	sta TimerCounter,x
skip
+hackme
	dex
	;bpl loop_channels
    bmi end
    jmp loop_channels
end

; Let the program flow...
.)
SendAY	
.(
	ldx #13
loop1	
	lda ayw_Bank,x
	cmp ayr_Bank,x
	beq skip1
	sta ayr_Bank,x
	ldy ayRealRegister,x
	sty via_porta
	ldy #ayc_Register
	sty via_pcr
	ldy #ayc_Inactive
	sty via_pcr
	sta via_porta
	lda #ayc_Write
	sta via_pcr
	sty via_pcr
skip1	
	dex
	bpl loop1
savx
	rts
.)

/***** End of player main routine *****/


/* Auxilary routines */

;;;;;;;;;;;;;;;;;;;;;;;;
; Send a register to AY 
; X=regnumber A=value
;;;;;;;;;;;;;;;;;;;;;;;;
SendAYReg
.(
	;Store register number VIA Port A
    stx via_porta
	pha
	;Set AY Control lines to Register Number 
    lda #ayc_Register
    sta via_pcr
	;Set AY Control lines to inactive 
    lda #ayc_Inactive
    sta via_pcr
	;Place the Register value into VIA Port A
	pla
    sta via_porta
	;Set AY Control lines to Write 
    lda #ayc_Write
    sta via_pcr
	;Set AY Control lines to inactive again 
    lda #ayc_Inactive
    sta via_pcr
    rts
.)

; Stopping, initializing sound routines
zeros
	.byt 0,0,0,0,0,0,0,%01111000,0,0,0,0,0,0

StopSound
	lda #0
	sta MusicPlaying
	beq initend
InitSound
	inc MusicPlaying

initend
	ldx #<zeros
	ldy #>zeros
; Needs X and Y with the low and high bytes of the
; table with register values
AYRegDump
.(
	stx loop+1
	sty loop+2

    ldx #13
loop 
	lda $dead,x

/*
	; Prevent anything nasty
	cpx #AY_Status
	bne skip
	ora #%01000000
skip
*/
	sta ayr_Bank,x
	sta ayw_Bank,x
	jsr SendAYReg
  	dex
    bpl loop
    rts
.)


//#define COMPACT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Conversion from note to pitch
; This is the slow version
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#ifdef COMPACT
; Table with base pitches for notes
base_pitch_lo
   .byt $ee,$16,$4c,$8e,$d8,$2e,$8e,$f6,$66,$e0,$60,$e8
base_pitch_hi
   .byt $0e,$0e,$0d,$0c,$0b,$0b,$0a,$09,$09,$08,$08,$07

Note2Pitch
.(
       ;Convert Large Note to Octave(X) and 12 value Note(A) (Divide by 12)
		stx savx+1
        ldx #255
        sec
  .(
  loop1 inx
        sbc #12
        bcs loop1
        adc #12
        ;Fetch 12 Bit Base Note
        tay
        lda base_pitch_lo,y
        sta note2pitchtmp
        lda base_pitch_hi,y
        ;Finish if Octave Zero
        cpx #00
        beq finishp
        ;Shift up for Octave
  loop2 lsr
        ror note2pitchtmp
        dex
        bne loop2
  finishp
  .)
        sta note2pitchtmp+1
savx
		ldx #0
        rts 
.)
#else
Note2Pitch
.(
	tay
	lda _YM_FREQUENCIESHI,y
    sta note2pitchtmp+1
	lda _YM_FREQUENCIESLO,y
    sta note2pitchtmp+0
	rts
.)

_YM_FREQUENCIESHI
.byt 14,14,13,12,11,11,10,9,9,8,8,7,7,7,6,6,5,5,5,4,4,4,4,3,3,3,3,3,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
_YM_FREQUENCIESLO
.byt 239,25,78,141,218,47,143,247,104,225,97,233,119,12,167,71,237,152,71,252,180,112,49,244,188,134,83,36,246,204,164,126,90,56,24,250,222,195,170,146,123,102,82,63,45,28,12,253,239,225,213,201,190,179,169,159,150,142,134,127,119,113,106,100,95,89,84,80,75,71,67,63,60,56,53,50,47,45,42,40,38,36,34,32,30,28,27,25,24,22,21,20,19,18,17,16,15,14,13,13
#endif

ayRealRegister
 .byt 0,2,4,1,3,5,6,7,8,9,10,11,12,13

ayw_Bank
ayw_PitchLo	.byt 0,0,0
ayw_PitchHi	.byt 0,0,0
ayw_Noise		.byt 0
ayw_Status	.byt %01111000
ayw_Volume	.byt 0,0,0
ayw_EGPeriod	.byt 0,0
ayw_Cycle		.byt 0

ReferenceBlock
ayr_Bank
ayr_PitchLo	.byt 128,128,128
ayr_PitchHi	.byt 128,128,128
ayr_Noise		.byt 128
ayr_Status	.byt 128
ayr_Volume	.byt 128,128,128
ayr_EGPeriod	.byt 128,128
ayr_Cycle		.byt 128

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _StartPlayer should be called
; before attempting to play
; anything
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Empty .byt END
_StartPlayer
.(
	sei

	; Set default value for Tempo
	lda #7
	sta Tempo

	; Set an empty tune
	lda #<Empty
	sta PList_lo
	sta PList_lo+1
	sta PList_lo+2
	lda #>Empty
	sta PList_hi
	sta PList_hi+1
	sta PList_hi+2

	; Initialize variables
	lda #0
	ldx #20
loop
	sta ListIndexes,x
	dex
	bpl loop

	sta SfxFlags
	
	; Initialize Envelope and Ornament pointers
	lda #7
	sta Env_p
	sta Orn_p

	; Call InitSound (which indicates there is music playing 
	; and clears the AY registers
	jsr InitSound

	; Executes the first command in the pattern list
	; it is necessary.
	
	ldx #0
	jsr NextPatternList
	ldx #1
	jsr NextPatternList
	ldx #2
	jsr NextPatternList
	
	
	cli
	rts	


.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PlaySfx A=snd id
; Plays a sound effect
; in an empty channel.
; If there isn't one, it
; takes the one with
; smaller priority if it is less
; than or equal to the effect
; priority.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_PlaySfx
.(
	sei
	stx savx+1
	
	; Grab effect id
	sta savid+1
	
	; Get priority
	tax
	lda sfx_priority,x
	
	; Look for a free channel
	ldx #$ff
	ldy #2
loop
	cmp Priority,y
	bcc skip
	; We have found one
	tya
	tax
	lda Priority,y
skip
	dey
	bpl loop

	; Either we found one channel (reg X=0,1,2)
	; or not (X=$ff)
	txa
	bmi notfound

savid
	ldy #00
	
	lda sfx_listlo,y
	sta PList_lo,x
	lda sfx_listhi,y
	sta PList_hi,x
	
	lda sfx_priority,y
	sta Priority,x
	
	lda #0
	sta ListIndexes,x
	sta TimerCounter,x
	sta SetVolume,x		; Suppose they all start at max volume
	sta NoteOffset,x
	sta IsResting,x
	
	lda #7
	sta Env_p,x
	sta Orn_p,x
	
	jsr NextPatternList
	
	lda #1
	sta MusicPlaying
	
notfound	
	txa
savx
	ldx #0
	cli
	rts
.)


_PlaySong
.(
	sei
	stx savx+1

	
	ldy #0
	lda (tmp),y
	sta Tempo	
	;sta TimerCounter,x

	iny
.(	

loop	
	lda (tmp),y
	sta pcodes_lo-1,y
	iny
	cpy #5
	bne loop
.)	

	;ldy #5
	lda (tmp),y
	sta PList_lo
	iny
	lda (tmp),y
	sta PList_hi
	iny
	lda (tmp),y
	sta PList_lo+1
	iny
	lda (tmp),y
	sta PList_hi+1
	iny
	lda (tmp),y
	sta PList_lo+2
	iny
	lda (tmp),y
	sta PList_hi+2

	lda #255
	sta Priority
	sta Priority+1
	sta Priority+2
	
PlayTuneCommon
	jsr InitSound

	ldx #2
loop
	lda #0
	sta ListIndexes,x
	;sta TimerCounter,x
	sta SetVolume,x	
	lda #7
	sta Env_p,x
	sta Orn_p,x
	jsr NextPatternList

	dex
	bpl loop
	
savx
	ldx #0
	
	cli
	rts
.)	

		
__snd_engine_end
