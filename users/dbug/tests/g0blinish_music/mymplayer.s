; Player size:
; 2014/12/06 - 658 bytes
;              638 bytes - Mostly removed commented out crap, and moved EndMusic at the start to avoid the jmp
;              622 bytes - Improved the ReadBits function
;              580 bytes - The IRQ handler patcher is now modifying the higher byte anymore, since it is the same value on the Oric 1 and Atmos
;              550 bytes - Actually used the secondary way to chain IRQs by patching the RTI
;              546 bytes - Added a "zero write" to register variant
;              492 bytes - Moved everything in the zero page, and replaced the individual clears by one clearing loop
;              485 bytes - Modified the WriteRegister routine to use X and Y instead of X and A, leading to less pushing and popping in the main code
;              478 bytes - The main music routine is now inline in the IRQ
;              469 bytes - Optimized the sound stopping code :)
;              465 bytes - Inlined the mym initialisation in the StartMusic code
;              455 bytes - Simplified the load balancer code by using the same frame counter for two different purpose.
;              449 bytes - Merged more initialization code all over the place
;              442 bytes - Improved the logic in the mym depacking
;              416 bytes - Used zero page addressing for the write buffers
;              413 bytes - Reordered some of the depacking code to avoid refetching data multiple time

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

_ptr_register_buffer
_ptr_register_buffer_low	.dsb 1 		; Points to the low byte of the decoded register buffer
_ptr_register_buffer_high	.dsb 1		; Points to the high byte of the decoded register buffer, increment to move to the next register	

_MusicResetCounter	.dsb 2		; Contains the number of rows to play before reseting

_CurrentFrame		.dsb 1		; From 0 to 255 and then cycles... the index of the frame to play this vbl

_PlayerVbl			.dsb 1

_FrameLoadBalancer	.dsb 1		; We depack a new frame every 9 VBLs, this way the 14 registers are evenly depacked over 128 frames
temp_value			.dsb 1      ; temp
_50hzFlipFlop			.dsb 1
_PlayerRegCurrentValue	.dsb 1 		; For depacking of data

_PlayerRegValues	.dsb 14		; 14 values, each containing the value of one of the PSG registers
; ---------------------------------
_end_zero_page_data


	.text

	*=$5600                             ; Actual start address of the player

MymPlayerStart
	jmp StartMusic			; Call #5600 to start the music
EndMusic					; Call #5603 to stop the music
	; Restore the RTI opcode
	lda #OPCODE_RTI
	sta $230				; Oric 1
	sta $24A				; Atmos 

	; Stop the sound
	ldy #8
	jsr WriteZeroToRegister
	iny
	jsr WriteZeroToRegister
	iny 
	; Fall-through
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


StartMusic
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
	sta _ptr_register_buffer_high

	ldx #0
	stx _ptr_register_buffer_low
unpack_block_loop
	stx _CurrentAYRegister
	
	; Unpack that register
	jsr _PlayerUnpackRegister

	; Next register
	ldx _CurrentAYRegister
	inx
	cpx #14
	bne unpack_block_loop
	.)

	jsr NextFrameBlock
.)


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
	.(
	dec _MusicResetCounter+0
	bne continue
	dec _MusicResetCounter+1
	bne continue
	; reset the music
	jsr StartMusic	
continue
	.)

	;
	; Play a frame of 14 registers, starting by the last one
	;
	.(
	lda _CurrentFrame
	sta _auto_psg_play_read+1
	lda #>(_PlayerBuffer+13*256)
	sta _auto_psg_play_read+2

	ldy #13
register_loop

_auto_psg_play_read
	ldx	_PlayerBuffer
	jsr WriteRegister

	dec _auto_psg_play_read+2 
	dey
	bpl register_loop
	.)

	inc _CurrentFrame

	;
	; Depack one new frame ?
	;
	lda _CurrentAYRegister
	cmp #14
	bcs end_reg

	dec _FrameLoadBalancer
	bne end_frame

	jsr _PlayerUnpackRegister
	inc _CurrentAYRegister
	jsr ResetLoadBalancer
	bne end_frame
end_reg

	; Reached a multiple of 128 frames?
	lda _CurrentFrame
	and #127				; Probably possible to use BIT to check for more stuff at once
	bne end_frame
	jsr NextFrameBlock
end_frame

	pla
	tay
	pla
	tax
	pla

skipFrame
	rti


NextFrameBlock
	lda #0
	sta _CurrentAYRegister

	lda #>_PlayerBuffer
	sta _ptr_register_buffer_high

	lda _PlayerVbl+0
	eor #128
	sta _PlayerVbl+0

ResetLoadBalancer
	lda #9
	sta _FrameLoadBalancer
	rts




;
; Initialise X with the number of bits to read
; Y is not modified
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
	; Init register bit count and current value
	ldx _CurrentAYRegister
	lda _PlayerRegValues,x
	sta _PlayerRegCurrentValue  

	ldy _PlayerVbl						; Either 0 or 128 at this point else we have a problem...
	
	; Check if it's packed or not and call adequate routine...
	jsr _ReadOneBit
	bne DecompressFragment
	
; No change at all, just repeat '_PlayerRegCurrentValue' 128 times 
UnchangedFragment	
	lda _PlayerRegCurrentValue			; Value to write
	ldx #128							; 128 iterations
loop_repeat_register
	sta (_ptr_register_buffer),y
	iny	
	dex
	bne loop_repeat_register

player_main_return
	; Move to the next register buffer
	inc _ptr_register_buffer_high
	rts


DecompressFragment
loop_depack_fragment		
	jsr _ReadOneBit						; Check packing method
	beq RepeatLastRegisterValue
	jsr _ReadOneBit						; Check packing method
	beq DecompressWithOffset

; New register value copied to the register stream
ReadNewRegisterValue
	; Read new register value (variable bit count)
	ldx _CurrentAYRegister
	lda _PlayerRegBits,x
	jsr _ReadBits

	sta (_ptr_register_buffer),y
	iny
	jmp player_return


; Repeat the previous value of the register
RepeatLastRegisterValue
	lda _PlayerRegCurrentValue			; Value to copy
	sta (_ptr_register_buffer),y
	iny 

player_return
	sta _PlayerRegCurrentValue			; New value to write

	; Check end of loop
	tya 
	and #127
	bne loop_depack_fragment

	; Write back register current value
	ldx _CurrentAYRegister
	lda _PlayerRegCurrentValue  
	sta _PlayerRegValues,x

	jmp player_main_return


; Offset depacking
DecompressWithOffset
.(
	lda _ptr_register_buffer_high		; highpart of buffer adress + register number
	sta __auto_read+2					; Read adress

	; Read Offset (0 to 127)
	lda #7
	jsr _ReadBits					
	; Compute wrap around offset...
	clc
	tya
	adc _DecodedResult					; between 0 and 255
	sec
	sbc #128							; -128
	sta temp_value
		
	; Read count (7 bits)
	lda #7
	jsr _ReadBits

	ldx temp_value
loop_copy_offset
__auto_read
	lda _PlayerBuffer,x				; X for reading
	inx

	sta (_ptr_register_buffer),y 	; Y for writing
	iny
	dec _DecodedResult
	bpl loop_copy_offset 
	bmi player_return
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



