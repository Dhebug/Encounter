; Player size:
; 2014/12/06 - 658 bytes
;              638 bytes - Mostly removed commented out crap, and moved EndMusic at the start to avoid the jmp
;              622 bytes - Improved the ReadBits function
;              580 bytes - The IRQ handler patcher is now modifying the higher byte anymore, since it is the same value on the Oric 1 and Atmos
;              550 bytes - Actually used the secondary way to chain IRQs by patching the RTI
;              546 bytes - Added a "zero write" to register variant
;              492 bytes - Moved everything in the zero page, and replaced the individual clears by one clearing loop
;              485 bytes - Modified the WriteRegister routine to use X and Y instead of X and A, leading to less pushing and popping in the main code

#define _PlayerBuffer		$5900		; .dsb 256*14 (About 3.5 kilobytes)
#define _MusicData			$6700		; Musics are loaded in $67B0, between the player buffer and the redefined character sets

#define VIA_1				$30f
#define VIA_2				$30c

#define OPCODE_RTI			$40
#define OPCODE_JMP			$4c

	.zero

	*=$50

_start_zero_page_data
; ---------------------------------
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

_50hzFlipFlop			.dsb 1
_PlayerCount			.dsb 1 		; Load balancer, counts to 0 to 128
_PlayerRegCurrentValue	.dsb 1 		; For depacking of data

_PlayerRegValues	.dsb 14		; 14 values, each containing the value of one of the PSG registers
; ---------------------------------
_end_zero_page_data


	.text

	*=$5600                             ; Actual start address of the player

MymPlayerStart
	jmp StartMusic			; Call #5600 to start the music
EndMusic					; Call #5603 to stop the music
	php
	sei

	; Restore the RTI opcode
	lda #OPCODE_RTI
	sta $230				; Oric 1
	sta $24A				; Atmos 

	; Stop the sound
	ldy #8
	jsr WriteZeroToRegister

	ldy #9
	jsr WriteZeroToRegister

	ldy #10
	jsr WriteZeroToRegister

	plp
	rts	

StartMusic
	jsr _Mym_Initialize

	;
	; Replace the RTI by a JMP
	; Unfortunately the addresses are different on the Oric 1 and Atmos
	;
	lda #<irq_handler
	sta $230+1				; Oric 1
	sta $24A+1				; Atmos 

	lda #>irq_handler	
	sta $230+2				; Oric 1
	sta $24A+2				; Atmos 

	lda #OPCODE_JMP
	sta $230+0				; Oric 1
	sta $24A+0				; Atmos 

	rts


irq_handler
	; This handler runs at 100hz if comming from the BASIC, 
	; but the music should play at 50hz, so we need to call the playing code only every second frame
	dec _50hzFlipFlop
	bpl skipFrame

	inc _50hzFlipFlop
	inc _50hzFlipFlop

	sei

	pha
	txa
	pha
	tya
	pha

	;
	; Check for end of music
	; 
	dec _MusicResetCounter+0
	bne music_contines
	dec _MusicResetCounter+1
	bne music_contines
music_resets
	jsr _Mym_Initialize
	
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
	jsr WriteRegister

	inc _auto_psg_play_read+2 
	iny
	cpy #14
	bne register_loop
	.)


	jsr _Mym_PlayFrame

	pla
	tay
	pla
	tax
	pla

skipFrame
	rti


; WRITE X TO REGISTER Y 0F 8912.
WriteZeroToRegister
	ldx #0
WriteRegister
.(
	STY $030F  		; Send Y to port A of 6522.	
	TXA
	CPY #$07  		; If writing to register 7, set
	BNE skip  		; 1/0 port to output.
	ORA #$40
skip	
	PHA
	LDA $030C  		; Set CA2 (BC1 of 8912) to 1,
	ORA #$EE  		; set CB2 (BDIR of 8912) to 1.
	STA $030C  		; 8912 latches the address.
	AND #$11  		; Set CA2 and CB2 to 0, BC1 and
	ORA #$CC  		; BDIR in inactive state.
	STA $030C
	TAX
	PLA
	STA $030F  		; Send data to 8912 register.
	TXA
	ORA #$EC  		; Set CA2 to 0 and CB2 to 1,
	STA $030C  		; 8912 latches data.
	AND #$11  		; Set CA2 and CB2 to 0, BC1 and
	ORA #$CC 		; BDIR in inactive state.
	STA $030C
	RTS
.)




_Mym_Initialize
.(
	; Initialize the read bit counter
	lda #<(_MusicData+2)
	sta __auto_music_ptr+1
	lda #>(_MusicData+2)
	sta __auto_music_ptr+2

	; Clear all data
	lda #0
	ldx #_end_zero_page_data-_start_zero_page_data
loop_clear
	sta _start_zero_page_data-1,x
	dex
	bne loop_clear

	; The two first bytes of the MYM music is the number of rows in the music
	; We decrement that at each frame, and when we reach zero, time to start again.
	ldx _MusicData+0
	stx _MusicResetCounter+0
	ldx _MusicData+1
	inx
	stx _MusicResetCounter+1
		
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
	rts
.)



_Mym_PlayFrame
.(

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




;
; Initialise X with the number of bits to read
; Y is not modifier
; A contains the value on exit
;
_ReadOneBit
	lda #1
_ReadBits
	tax
	lda #0
	sta _DecodedResult

	; Will iterate X times (number of bits to read)
loop_read_bits
	dec _DecodeBitCounter
	bpl end_reload

	; reset mask
	lda #7
	sta _DecodeBitCounter

	; fetch a new byte, and increment the adress.
__auto_music_ptr
	lda _MusicData+2
	sta _DecodedByte

	inc __auto_music_ptr+1
	bne end_reload
	inc __auto_music_ptr+2
end_reload

	asl _DecodedByte
	rol _DecodedResult

	dex
	bne loop_read_bits
	
	lda _DecodedResult
	rts





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
	jsr _ReadOneBit
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

	;jmp player_main_return	
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
	jsr _ReadOneBit
	bne PlayerNotCopyLast

UnchangedRegister
.(	
	; We just copy the current value 128 times
	lda _RegisterBufferHigh				; highpart of buffer adress + register number
	sta player_copy_last+2

	ldx _BufferFrameOffset				; Value between 00 and 7f
	lda _PlayerRegCurrentValue			; Value to copy
player_copy_last
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
	jsr _ReadOneBit
	beq DecompressWithOffset

ReadNewRegisterValue
	; Read new register value (variable bit count)
	ldx _CurrentAYRegister
	lda _PlayerRegBits,x
	jsr _ReadBits
	sta _PlayerRegCurrentValue

	; Copy to stream
	lda _RegisterBufferHigh				; highpart of buffer adress + register number
	sta player_read_new+2

	ldx _BufferFrameOffset					; Value between 00 and 7f
	lda _PlayerRegCurrentValue			; New value to write
player_read_new
	sta _PlayerBuffer,x

	inc _BufferFrameOffset
	jmp player_return


DecompressWithOffset
.(
	; Read Offset (0 to 127)
	lda #7
	jsr _ReadBits					
	; Compute wrap around offset...
	clc
	adc _BufferFrameOffset					; between 0 and 255
	sec
	sbc #128							; -128
	tay

	lda _RegisterBufferHigh			; highpart of buffer adress + register number
	sta __auto_write+2				; Write adress
	sta __auto_read+2				; Read adress

	; Read count (7 bits)
	lda #7
	jsr _ReadBits

	ldx _BufferFrameOffset
	
player_copy_offset_loop

__auto_read
	lda _PlayerBuffer,y				; Y for reading
	iny

__auto_write
	sta _PlayerBuffer,x				; X for writing

	inc _BufferFrameOffset

	inx
	dec _DecodedResult
	bpl player_copy_offset_loop 

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



