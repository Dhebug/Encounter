; To check: AYC
; http://cpcwiki.eu/index.php/AYC

#include "floppy_description.h"

	.zero

_DecodedByte		.dsb 1		; Byte being currently decoded from the MYM stream
_DecodeBitCounter	.dsb 1		; Number of bits we can read in the current byte
_DecodedResult		.dsb 1		; What is returned by the 'read bits' function

_CurrentAYRegister	.dsb 1		; Contains the number of the register being decoded	

_RegisterBufferHigh	.dsb 1		; Points to the high byte of the decoded register buffer, increment to move to the next register	
_BufferFrameOffset	.dsb 1		; From 0 to 127, used when filling the decoded register buffer

_MusicResetCounter	.dsb 2		; Contains the number of rows to play before reseting

_CurrentFrame		.dsb 1		; From 0 to 255 and then cycles... the index of the frame to play this vbl

_PlayerVbl			.dsb 1

_FrameLoadBalancer	.dsb 1		; We depack a new frame every 9 VBLs, this way the 14 registers are evenly depacked over 128 frames

_MusicTimer 					; So we can 'wait' a particular position of the music
_MusicTimerLow		.dsb 1
_MusicTimerHigh		.dsb 1

	.text

#define VIA_1				$30f
#define VIA_2				$30c

_PlayerCount		.byt 0
_MusicPlaying		.byt 0


;
; Current PSG values during unpacking
;
_PlayerRegValues		
_RegisterChanAFrequency
	; Chanel A Frequency
	.byt 8
	.byt 4

_RegisterChanBFrequency
	; Chanel B Frequency
	.byt 8
	.byt 4 

_RegisterChanCFrequency
	; Chanel C Frequency
	.byt 8
	.byt 4

_RegisterChanNoiseFrequency
	; Chanel sound generator
	.byt 5

	; select
	.byt 8 

	; Volume A,B,C
_RegisterChanAVolume
	.byt 5
_RegisterChanBVolume
	.byt 5
_RegisterChanCVolume
	.byt 5

	; Wave period
	.byt 8 
	.byt 8

	; Wave form
	.byt 8

_PlayerRegCurrentValue	.byt 0


_Mym_MusicStart
.(
	; The two first bytes of the MYM music is the number of rows in the music
	; We decrement that at each frame, and when we reach zero, time to start again.
	ldx _MusicData+0
	stx _MusicResetCounter+0
	ldx _MusicData+1
	inx
	stx _MusicResetCounter+1
		
	.(
	; Initialize the read bit counter
	lda #<(_MusicData+2)
	sta __auto_music_ptr+1
	lda #>(_MusicData+2)
	sta __auto_music_ptr+2

	lda #1
	sta _DecodeBitCounter

	; Clear all data
	lda #0
	sta _DecodedResult
	sta _DecodedByte
	sta _PlayerVbl
	sta _PlayerRegCurrentValue
	sta _BufferFrameOffset
	sta _PlayerCount
	sta _CurrentAYRegister
	sta _CurrentFrame
	sta _MusicTimerLow
	sta _MusicTimerHigh

	ldx #14
loop_init
	dex
	sta _PlayerRegValues,x
	bne loop_init
	.)

	;
	; Unpack the 128 first register frames
	;
	.(
	lda #>_PlayerBuffer
	sta _RegisterBufferHigh

	ldx #0
unpack_block_loop
	stx _CurrentAYRegister
	
	; Unpack that register
	jsr _PlayerUnpackRegister2

	; Next register
	ldx _CurrentAYRegister
	inx
	cpx #14
	bne unpack_block_loop
	.)

	lda #128
	sta _PlayerVbl+0

	lda #0
	sta _PlayerCount
	sta _CurrentAYRegister
	sta _CurrentFrame

	lda #9
	sta _FrameLoadBalancer

	lda #1
	sta _MusicPlaying

	;
	; Install the IRQ
	;
	php
	sei
	lda #<_Mym_PlayFrame
	sta _InterruptCallBack_3+1
	lda #>_Mym_PlayFrame
	sta _InterruptCallBack_3+2
#ifdef ENABLE_TIMING_DEBUGGING
	jsr _InitializeTimings
#endif
	plp

	rts
.)


_Mym_MusicStop
.(
	; Indicate the main code that the music is finished
	lda #0
	sta _MusicPlaying

	; Disable the IRQ so it does not conflict or cause weird things
	php
	sei
	lda #<_DoNothing
	sta _InterruptCallBack_3+1
	lda #>_DoNothing
	sta _InterruptCallBack_3+2
	plp

	; Cut the sound so it does not sounds like a dying cat

	; y=register number
	; x=value to write
	ldy #7 ; Control register
	ldx #$FF
	jsr _PsgPlayRegister

	ldy #8 	; Volume A
	ldx #0
	jsr _PsgPlayRegister

	ldy #9	; Volume B
	ldx #0
	jsr _PsgPlayRegister

	ldy #10	; Volume C
	ldx #0
	jsr _PsgPlayRegister
	rts
.)

_Mym_PlayFrame
.(
#ifdef ENABLE_TIMING_DEBUGGING
	jsr _DisplayTimings
#endif

	.(
	inc  _MusicTimerLow
	bne skip
	inc  _MusicTimerHigh
skip
	.)

	;
	; Check for end of music
	; CountZero: $81,$0d
	dec _MusicResetCounter+0
	bne music_contines
	dec _MusicResetCounter+1
	bne music_contines

music_resets
	jmp _Mym_MusicStop
	
music_contines	

	;
	; Play a frame of 14 registers
	;
	.(
	lda _CurrentFrame
	sta _auto_psg_play_read+1
	lda #>_PlayerBuffer
	sta _auto_psg_play_read+2

	ldy #0
register_loop

_auto_psg_play_read
	ldx	_PlayerBuffer

	; y=register number
	; x=value to write
	jsr _PsgPlayRegister

	inc _auto_psg_play_read+2 
	iny
	cpy #14
	bne register_loop
	.)


	inc _CurrentFrame
	inc _PlayerCount

	lda _CurrentAYRegister
	cmp #14
	bcs end_reg

	.(
	dec _FrameLoadBalancer
	bne end

	jsr _PlayerUnpackRegister
	inc _CurrentAYRegister
	lda #9
	sta _FrameLoadBalancer
end	
	rts
	.)

end_reg
	.(
	lda _PlayerCount
	cmp #128
	bcc skip

	lda #0
	sta _CurrentAYRegister
	sta _PlayerCount
	lda #9
	sta _FrameLoadBalancer
	
	clc
	lda _PlayerVbl+0
	adc #128
	sta _PlayerVbl+0
skip
	.)

	rts
.)


; y=register number
; x=value to write
_PsgPlayRegister
.(
	sty	VIA_1
	txa

	pha
	lda	VIA_2
	ora	#$EE		; $EE	238	11101110
	sta	VIA_2

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	VIA_2

	tax
	pla
	sta	VIA_1
	txa
	ora	#$EC		; $EC	236	11101100
	sta	VIA_2

	and	#$11		; $11	17	00010001
	ora	#$CC		; $CC	204	11001100
	sta	VIA_2

	rts
.)



;
; Initialise X with the number of bits to read
; Y is not modifier
;
_ReadBits
.(
	lda #0
	sta _DecodedResult

	; Will iterate X times (number of bits to read)
loop_read_bits

	dec _DecodeBitCounter
	beq get_next_byte

shift_bit
	asl _DecodedByte
	rol _DecodedResult

	dex
	bne loop_read_bits
	rts

get_next_byte	
	; reset mask
	lda #8
	sta _DecodeBitCounter

	; fetch a new byte, and increment the adress.
+__auto_music_ptr
	lda _MusicData+2
	sta _DecodedByte

	inc __auto_music_ptr+1
	bne shift_bit
	inc __auto_music_ptr+2
	jmp shift_bit
.)




_PlayerUnpackRegister
	lda #>_PlayerBuffer
	clc
	adc _CurrentAYRegister
	sta _RegisterBufferHigh
_PlayerUnpackRegister2
	;
	; Init register bit count and current value
	;	 
	ldx _CurrentAYRegister
	lda _PlayerRegValues,x
	sta _PlayerRegCurrentValue  
	

	;
	; Check if it's packed or not
	; and call adequate routine...
	;
	ldx #1
	jsr _ReadBits
	ldx _DecodedResult
	bne DecompressFragment

	
UnchangedFragment	
.(
	;
	; No change at all, just repeat '_PlayerRegCurrentValue' 128 times 
	;
	lda _RegisterBufferHigh				; highpart of buffer adress + register number
	sta __auto_copy_unchanged_write+2

	ldx #128							; 128 iterations
	lda _PlayerRegCurrentValue			; Value to write

	ldy _PlayerVbl
	
repeat_loop
__auto_copy_unchanged_write
	sta _PlayerBuffer,y
	iny	
	dex
	bne repeat_loop
.)

	jmp player_main_return

	
player_main_return
	; Write back register current value
	ldx _CurrentAYRegister
	lda _PlayerRegCurrentValue  
	sta _PlayerRegValues,x

	; Move to the next register buffer
	inc _RegisterBufferHigh
	rts




DecompressFragment
	lda _PlayerVbl						; Either 0 or 128 at this point else we have a problem...
	sta _BufferFrameOffset

decompressFragmentLoop	
	
player_copy_packed_loop
	; Check packing method
	ldx #1
	jsr _ReadBits

	ldx _DecodedResult
	bne PlayerNotCopyLast

UnchangedRegister
.(	
	; We just copy the current value 128 times
	lda _RegisterBufferHigh				; highpart of buffer adress + register number
	sta __auto_player_copy_last+2

	ldx _BufferFrameOffset				; Value between 00 and 7f
	lda _PlayerRegCurrentValue			; Value to copy
__auto_player_copy_last
	sta _PlayerBuffer,x

	inc _BufferFrameOffset
.)


player_return

	; Check end of loop
	lda _BufferFrameOffset
	and #127
	bne decompressFragmentLoop

	jmp player_main_return


PlayerNotCopyLast
	; Check packing method
	ldx #1
	jsr _ReadBits

	ldx _DecodedResult
	beq DecompressWithOffset

ReadNewRegisterValue
	; Read new register value (variable bit count)
	ldx _CurrentAYRegister
	lda _PlayerRegBits,x
	tax
	jsr _ReadBits
	ldx _DecodedResult
	stx _PlayerRegCurrentValue

	; Copy to stream
	lda _RegisterBufferHigh				; highpart of buffer adress + register number
	sta __auto_player_read_new+2

	ldx _BufferFrameOffset				; Value between 00 and 7f
	lda _PlayerRegCurrentValue			; New value to write
__auto_player_read_new
	sta _PlayerBuffer,x

	inc _BufferFrameOffset
	jmp player_return




DecompressWithOffset
.(
	; Read Offset (0 to 127)
	ldx #7
	jsr _ReadBits					

	lda _RegisterBufferHigh			; highpart of buffer adress + register number
	sta __auto_write+2				; Write adress
	sta __auto_read+2				; Read adress

	; Compute wrap around offset...
	lda _BufferFrameOffset				; between 0 and 255
	clc
	adc _DecodedResult					; + Offset Between 00 and 7f
	sec
	sbc #128							; -128
	tay

	; Read count (7 bits)
	ldx #7
	jsr _ReadBits
	
	inc	_DecodedResult					; 1 to 129


	ldx _BufferFrameOffset
	
player_copy_offset_loop

__auto_read
	lda _PlayerBuffer,y				; Y for reading
	iny

__auto_write
	sta _PlayerBuffer,x				; X for writing

	inx
	dec _DecodedResult
	bne player_copy_offset_loop 

	stx _BufferFrameOffset
	sta _PlayerRegCurrentValue

	jmp player_return
.)



;
; Size in bits of each PSG register
;
_PlayerRegBits
	; Chanel A Frequency
	.byt 8
	.byt 4

	; Chanel B Frequency
	.byt 8
	.byt 4 

	; Chanel C Frequency
	.byt 8
	.byt 4

	; Chanel sound generator
	.byt 5

	; select
	.byt 8 

	; Volume A,B,C
	.byt 5
	.byt 5
	.byt 5

	; Wave period
	.byt 8 
	.byt 8

	; Wave form
	.byt 8




#ifdef ENABLE_TIMING_DEBUGGING

#define TIMING_ADDRESS $bb80+40*25+10
_InitializeTimings
	lda #"0"
	; Minute
	sta TIMING_ADDRESS+0
	sta TIMING_ADDRESS+1
	; Second
	sta TIMING_ADDRESS+3
	sta TIMING_ADDRESS+4
	; Frame (50th of a second)
	sta TIMING_ADDRESS+6
	sta TIMING_ADDRESS+7
	lda #"'"
	sta TIMING_ADDRESS+2
	lda #34
	sta TIMING_ADDRESS+5
	lda #16+1
	sta TIMING_ADDRESS-1
	lda #16+0
	sta TIMING_ADDRESS+9
	rts

_DisplayTimings
.(
	; Increment the low frame value
	inc TIMING_ADDRESS+7
	ldx TIMING_ADDRESS+7
	cpx #":"
	bne done
	ldx #"0"
	stx TIMING_ADDRESS+7

	; Increment the high frame value
	inc TIMING_ADDRESS+6
	ldx TIMING_ADDRESS+6
	cpx #"5"
	bne done
	ldx #"0"
	stx TIMING_ADDRESS+6
	stx TIMING_ADDRESS+7

	; Increment the low second value
	inc TIMING_ADDRESS+4
	ldx TIMING_ADDRESS+4
	cpx #":"
	bne done
	ldx #"0"
	stx TIMING_ADDRESS+4

	; Increment the high second value
	inc TIMING_ADDRESS+3
	ldx TIMING_ADDRESS+3
	cpx #"6"
	bne done
	ldx #"0"
	stx TIMING_ADDRESS+3
	stx TIMING_ADDRESS+4

	; Increment the low minute value
	inc TIMING_ADDRESS+1
	ldx TIMING_ADDRESS+1
	cpx #":"
	bne done
	ldx #"0"
	stx TIMING_ADDRESS+1

	; Increment the high minute value
	inc TIMING_ADDRESS+0
	ldx TIMING_ADDRESS+0
	cpx #"6"
	bne done
	ldx #"0"
	stx TIMING_ADDRESS+0
	stx TIMING_ADDRESS+1

done
	rts
.)
#endif


