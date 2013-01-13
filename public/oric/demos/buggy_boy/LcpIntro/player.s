

	.zero

_Player_temp	.dsb 2

	.text


//
// Time/Synchronisation 6502 assembly library
// (c) 1996 Micka‰l POINTIER  (Dbug from NeXT)
//
// Time value is 16 bits coded, so the maximum value is:
//  65536 100th of a second
//  655 seconds
//  10 minutes
//


//#define MUSIC_START	$2000
#define MUSIC_START	_MusicData





// 21 minutes max (65536/50)
_CurrentSync
	.word 0

_CurrentSyncCopy
	.word 0

_LastSync
	.word 0

_VblFlag
	.byt 2




#define VIA_1	$30f
#define VIA_2	$30c



_PsgControl	.byt 0
_PsgData	.byt 0

_PsgVbl
	.byt 0


_PsgPlay
	lda _PsgVbl
	sta psg_play_read+1
	lda #>_PlayerBuffer
	sta psg_play_read+2

	lda #0
	sta _PsgControl
	ldy #14
		sei		
psg_play_loop

psg_play_read
	ldx	_PlayerBuffer
	lda _PsgControl

	sta	VIA_1
	txa

	pha
	lda	VIA_2
	ora	#$EE		// $EE	238	11101110
	sta	VIA_2

	and	#$11		// $11	17	00010001
	ora	#$CC		// $CC	204	11001100
	sta	VIA_2

	tax
	pla
	sta	VIA_1
	txa
	ora	#$EC		// $EC	236	11101100
	sta	VIA_2

	and	#$11		// $11	17	00010001
	ora	#$CC		// $CC	204	11001100
	sta	VIA_2

	inc _PsgControl
	inc psg_play_read+2 
	dey
	bne psg_play_loop
		cli

	rts





//
// Size in bits of each PSG register
//
_PlayerRegBits
	// Chanel A Frequency
	.byt 8
	.byt 4

	// Chanel B Frequency
	.byt 8
	.byt 4 

	// Chanel C Frequency
	.byt 8
	.byt 4

	// Chanel sound generator
	.byt 5

	// select
	.byt 8 

	// Volume A,B,C
	.byt 5
	.byt 5
	.byt 5

	// Wave period
	.byt 8 
	.byt 8

	// Wave form
	.byt 8





//
// Current PSG values during unpacking
//
_PlayerRegValues
	.dsb 14

_PlayerRegCurrentValue
	.byt 0


#define REGS				14			
#define FRAG				128			
#define OFFNUM				14			
#define OFFHALF				7




//
// Allign the following data on a 256 bytes
// boundary in order to optimise the accessing
// code.
//
	.dsb 256-(*&255)

//
// Unpacking buffer. 
// A big, huge, one
//
_PlayerBuffer
	.dsb 256*14

_PlayerVbl
	.word 0

_PlayerVblRow
	.byt 0
	
_PlayerRegister
	.byt 0

_PlayerRegPointer
	.byt 0

_PlayerUnpackCount
	.byt 0

_ReadBitResult
	.byt 0

CurrentMask
	.byt 0

CurrentByte
	.byt 0

_MusicRowCount
	.word 0


_PlayerInit
	// 2 first bytes represent the number of rows
	lda MUSIC_START
	sta _MusicRowCount
	lda MUSIC_START+1
	sta _MusicRowCount+1

	// Then the music itself
	lda #<(MUSIC_START+2)
	sta ptr_music+1
	lda #>(MUSIC_START+2)
	sta ptr_music+2

	lda #0

	// Clear all data

	sta _ReadBitResult

	sta CurrentMask
	sta CurrentByte

	sta _PlayerVbl
	sta _PlayerVbl+1

	sta _PlayerVblRow

	sta _PlayerRegCurrentValue

	ldx #14
loop_init
	dex
	sta _PlayerRegValues,x
	bne loop_init
	rts



//
// Initialise X with the number of bits to read
// Y is not modifier
// A is saved and restored..
//
_ReadBits
	//
	// save regs
	//
	pha

	//
	// initialise result to 0
	//
	lda #0
	sta _ReadBitResult

	//
	// loop X (parameter) time
	//
loop_read_bits

	//
	// shift result left
	//
	asl _ReadBitResult

	//
	// check for reload
	//
	lda CurrentMask
	bne no_reload

	//
	// reset mask
	//
	lda #128
	sta CurrentMask

	//
	// fetch a new byte, and 
	// increment the adress.
	//
ptr_music
	lda MUSIC_START+2
	sta CurrentByte

	inc ptr_music+1
	bne no_wrap
	inc ptr_music+2
no_wrap

no_reload


	lda CurrentByte
	and CurrentMask
	beq skip_bit
	inc _ReadBitResult
skip_bit

	//
	// shift mask right
	//
	lsr	CurrentMask

	//
	// next one
	//
	dex
	bne loop_read_bits
	
	//
	// restore regs
	//
	pla
	rts







_PlayerUnpackBlock
	//
	// Init loop
	//
	lda #>_PlayerBuffer
	sta _PlayerRegPointer

	ldx #0
	stx _PlayerRegister
player_unpack_block_loop
	//
	// Unpack that register
	//
	jsr _PlayerUnpackRegister2

	//
	// Next register
	//
	ldx _PlayerRegister
	inx
	stx _PlayerRegister
	cpx #REGS
	bne player_unpack_block_loop
	rts




_PlayerUnpackRegister
	lda #>_PlayerBuffer
	clc
	adc _PlayerRegister
	sta _PlayerRegPointer
_PlayerUnpackRegister2
	//
	// Init register bit count and current value
	//	 
	ldx _PlayerRegister
	lda _PlayerRegValues,x
	sta _PlayerRegCurrentValue  
	

	//
	// Check if it's packed or not
	// and call adequate routine...
	//
	ldx #1
	jsr _ReadBits
	ldx _ReadBitResult
	bne _PlayerCopyPacked

	//
	// No change
	//
	//_PlayerCopyUnchanged
	lda _PlayerVbl
	sta player_copy_unchanged_write+1
	lda _PlayerRegPointer				// highpart of buffer adress + register number
	sta player_copy_unchanged_write+2

	ldx #FRAG							// 128 iterations
	lda _PlayerRegCurrentValue			// Value to write

player_copy_unchanged_loop
	dex
player_copy_unchanged_write
	sta _PlayerBuffer,x
	bne player_copy_unchanged_loop

	jmp player_main_return

player_main_return


	//
	// Write back register current value
	//
	ldx _PlayerRegister
	lda _PlayerRegCurrentValue  
	sta _PlayerRegValues,x

	//
	// Next register buffer
	//
	inc _PlayerRegPointer
	rts







_PlayerCopyPacked
	lda _PlayerVbl		// either 0 or 128...
	sta _PlayerVblRow

player_copy_packed_loop
	//
	// Check packing method
	//
	ldx #1
	jsr _ReadBits

	//
	// Call adequate method
	//
	ldx _ReadBitResult
	bne PlayerNotCopyLast

	//
	// Copy last value
	// PlayerCopyLast
	//
	lda _PlayerRegPointer				// highpart of buffer adress + register number
	sta player_copy_last+2

	ldx _PlayerVblRow					// Value between 00 and 7f
	lda _PlayerRegCurrentValue			// Value to copy
player_copy_last
	sta _PlayerBuffer,x

	inc _PlayerVblRow

player_return

	//
	// Check end of loop
	//
	lda _PlayerVblRow
	and #127
	bne player_copy_packed_loop

	jmp player_main_return


PlayerNotCopyLast
	//
	// Check packing method
	//
	ldx #1
	jsr _ReadBits

	//
	// Call adequate method
	//
	ldx _ReadBitResult
	beq PlayerCopyOffset

PlayerReadNew
	//
	// Read new register value (variable bit count)
	//
	ldx _PlayerRegister
	lda _PlayerRegBits,x
	tax
	jsr _ReadBits
	ldx _ReadBitResult
	stx _PlayerRegCurrentValue

	//
	// Copy to stream
	//
	lda _PlayerRegPointer				// highpart of buffer adress + register number
	sta player_read_new+2

	ldx _PlayerVblRow					// Value between 00 and 7f
	lda _PlayerRegCurrentValue			// New value to write
player_read_new
	sta _PlayerBuffer,x

	inc _PlayerVblRow
	jmp player_return




PlayerCopyOffset
	ldx #OFFHALF
	jsr _ReadBits					// Read Offset (0 to 127)

	lda _PlayerRegPointer			// highpart of buffer adress + register number
	sta player_copy_offset_write+2	// Write adress
	sta player_copy_offset_read+2	// Read adress

	//
	// Compute wrap around offset...
	//
	lda _PlayerVblRow					// between 0 and 255
	clc
	adc _ReadBitResult					// + Offset Between 00 and 7f
	sec
	sbc #128							// -128
	tay

	//
	// Read count (7 bits)
	//
	ldx #OFFHALF
	jsr _ReadBits
	
	inc	_ReadBitResult	// 1 to 128

	lda _ReadBitResult
	clc
	adc _PlayerVblRow
	sta _PlayerUnpackCount


	ldx _PlayerVblRow
	
player_copy_offset_loop

player_copy_offset_read
	lda _PlayerBuffer,y				// Y for reading
	iny

player_copy_offset_write
	sta _PlayerBuffer,x				// X for writing

	inc _PlayerVblRow

	inx
	cpx _PlayerUnpackCount 
	bne player_copy_offset_loop 

	sta _PlayerRegCurrentValue

	jmp player_return




_PlayerCount	.byt 0
_PlayerDecount	.byt 0


_Mym_PlayFrame
.(
	//
	// Play a frame of 14 registers
	//
	jsr _PsgPlay

	inc _PsgVbl
	inc _PlayerCount

	lda _PlayerRegister
	cmp #14
	bcs end_reg

	.(
	dec _PlayerDecount
	bne end

	jsr _PlayerUnpackRegister
	inc _PlayerRegister
	lda #9
	sta _PlayerDecount
end	
	rts
	.)

end_reg
	.(
	lda _PlayerCount
	cmp #FRAG
	bcc skip

	lda #0
	sta _PlayerRegister
	sta _PlayerCount
	lda #9
	sta _PlayerDecount
	
	clc
	lda _PlayerVbl+0
	adc #FRAG
	sta _PlayerVbl+0
	bcc skip
	inc _PlayerVbl+1
skip
	.)

	//
	// Check for end of music
	//
	.(
	clc
	lda _PlayerVbl+0
	adc _PlayerCount
	sta _Player_temp+0
	lda _PlayerVbl+1
	adc #0
	sta _Player_temp+1

	// MusicRowCount => 2500 / 128 => 19.53... 
	lda _Player_temp+1
	cmp _MusicRowCount+1
	bcc end
	lda _Player_temp+0
	cmp _MusicRowCount
	bcc end

	//lda #16+1
	//sta $BB80

	/*
	lda #FRAG
	sta _PlayerVbl+0
	lda #0
	sta _PlayerVbl+1
	sta _PlayerVblRow
	sta _PsgVbl
	*/


	sei
	//
	//  Read the number of rows
	//
	jsr _PlayerInit

	//
	// Unpack a 1792 bytes blocs...
	//
	jsr _PlayerUnpackBlock

	lda #FRAG
	sta _PlayerVbl+0

	lda #0
	sta _PlayerVbl+1
	sta _PlayerCount
	sta _PlayerRegister
	sta _PlayerVblRow
	sta _PsgVbl

	lda #9
	sta _PlayerDecount


end
	.)
	
	rts
.)

/*
		if (PlayerCount>=FRAG)
		{
			PlayerRegister=0;
			PlayerCount=0;
			PlayerDecount=9;
			PlayerVbl+=FRAG;
		}
		if ((PlayerVbl+PlayerCount)>=MusicRowCount)
		{
			PlayerVbl=FRAG;
			PlayerVblRow=0;
			PsgVbl=0;
		}
*/

_Mym_Initialize
.(
	//
	//  Read the number of rows
	//
	jsr _PlayerInit

	//
	// Unpack a 1792 bytes blocs...
	//
	jsr _PlayerUnpackBlock

	lda #FRAG
	sta _PlayerVbl+0

	lda #0
	sta _PlayerVbl+1
	sta _PlayerCount
	sta _PlayerRegister
	sta _PlayerVblRow
	sta _PsgVbl

	lda #9
	sta _PlayerDecount

	//
	// Install IRQ
	// 
	jsr _VSync
	sei
	lda #<_Mym_PlayFrame
	sta _System_VblCallBack+0
	lda #>_Mym_PlayFrame
	sta _System_VblCallBack+1
	cli
	rts
.)







