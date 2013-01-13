

	.zero

#define VIA_1	$30f
#define VIA_2	$30c

#define VIA_TIMER_DELAY 250		// 4Khz
#define VBL_DECOUNT 80			// 80*50 => 4000 échantillons par seconde /2 => 2000 octets / seconde 


IRQ_SAVE_A				.dsb 1
IRQ_SAVE_X				.dsb 1
IRQ_SAVE_Y				.dsb 1
						
IRQ_SAVE_A2				.dsb 1
IRQ_SAVE_X2				.dsb 1
IRQ_SAVE_Y2				.dsb 1

_System_IrqCounter		.dsb 1
_SystemEffectTrigger	.dsb 1    //		$13       ;

_System_VblCallBack		.dsb 2
_VblCounter				.dsb 1

_SystemFrameCounter
_SystemFrameCounter_low		.dsb 1
_SystemFrameCounter_high	.dsb 1

	.text


	
_Breakpoint
	jmp _Breakpoint
	rts

_VSync
.(
	//rts
	pha
loop_wait
	lda _VblCounter
	beq loop_wait
	lda #0
	sta _VblCounter
	pla
	rts
.)


_System_ExecuteCallback
	jmp (_System_VblCallBack)


_System_Initialize
.(
	//
	// Switch OFF interrupts, and enable Overlay RAM
	// Because writing in ROM, is basicaly very hard !
	//
	sei
	lda #%11111101
	sta $314

	//
	// Init params
	//
	lda #0
	sta _SystemFrameCounter_low
	sta _SystemFrameCounter_high


	jsr _System_InstallDoNothing_CallBack_Private
	jsr _System_InstallIRQ_SimpleVbl

	cli

	rts
.)



//
// Installs a VBL Callback doing exactly nothing
//
_System_InstallDoNothing_CallBack
	jsr _VSync
_System_InstallDoNothing_CallBack_Private
	sei
	lda #<_System_DoNothing
	sta _System_VblCallBack+0
	lda #>_System_DoNothing
	sta _System_VblCallBack+1
	cli
	rts

_System_DoNothing
	rts



//
// Installs a simple 50hz Irq
//
_System_InstallIRQ_SimpleVbl
.(
	sei

	// Set the VIA parameters
	lda #<20000
	sta $306
	lda #>20000
	sta $307

	lda #0
	sta _System_IrqCounter

	// Install interrupt
	lda #<_InterruptCode_SimpleVbl
	sta $FFFE
	lda #>_InterruptCode_SimpleVbl
	sta $FFFF

	cli
	rts	
.)




//
// A simple IRQ that increment a VBL counter
// Should be called at 50hz frequency
//
_InterruptCode_SimpleVbl
.(
	bit $304
	inc _VblCounter

	.(
	inc _SystemFrameCounter_low
	bne skip
	inc _SystemFrameCounter_high
skip
	.)


	pha
	txa
	pha
	tya
	pha

	jsr _System_ExecuteCallback

	pla
	tay
	pla
	tax
	pla

	rti
.)




// y=control register
// x=data register
_PsgSetRegister
.(
	sty	VIA_1

	lda	VIA_2
	ora	#$EE		; $EE	238	11101110
	sta	VIA_2
	lda #$CC		; $CC	204	11001100
	sta	VIA_2

	stx	VIA_1
	lda	#$EC		; $EC	236	11101100
	sta	VIA_2
	lda #$CC		; $CC	204	11001100
	sta	VIA_2
	rts
.)




// Packed source data adress
#define	ptr_source			tmp0	

// Destination adress where we depack
#define	ptr_destination		tmp1	

// Point on the end of the depacked stuff
#define	ptr_destination_end	tmp2	

// Temporary used to hold a pointer on depacked stuff
#define ptr_source_back		tmp3	

// Temporary
#define offset				tmp4	

#define mask_counter		reg0
#define mask_value			reg1
#define nb_src				reg2
#define nb_dst				reg3


UnpackError
	rts

UnpackLetters	.byt "LZ77"


// void file_unpack(void *ptr_dst,void *ptr_src)

_file_unpack
	//jmp _file_unpack

	ldy #0
	lda (sp),y
	sta ptr_destination
	iny
	lda (sp),y
	sta ptr_destination+1


	// Source adress
	ldy #2
	lda (sp),y
	sta ptr_source
	iny
	lda (sp),y
	sta ptr_source+1

_System_DataUnpack
	// Test if it's LZ77
	ldy #3
unpack_lz77test_loop
	lda (ptr_source),y
	cmp UnpackLetters,y
	bne UnpackError
	dey 
	bpl unpack_lz77test_loop


	// Get the unpacked size, and add it to the destination
	// adress in order to get the end adress.
	ldy #4
	clc
	lda ptr_destination
	adc (ptr_source),y
	sta ptr_destination_end+0
	iny
	lda ptr_destination+1
	adc (ptr_source),y
	sta ptr_destination_end+1


	// Move the source pointer ahead to point on packed data (+0)
	clc
	lda ptr_source
	adc #8
	sta ptr_source
	lda ptr_source+1
	adc #0
	sta ptr_source+1


	// Initialise variables
	// We try to keep "y" null during all the code,
	// so the block copy routine has to be sure that
	// y is null on exit
	ldy #0
	lda #1
	sta mask_counter
	 
UnpackLoop
	// Handle bit mask
	dec mask_counter
	bne UnpackEndReload
	
	// Reload encoding type mask
	lda #8
	sta mask_counter

	lda (ptr_source),y	// Read from source stream
	sta mask_value   

	inc ptr_source		// Move stream pointer (one byte)
	bne UnpackEndReload
	inc ptr_source+1
UnpackEndReload

	ror mask_value		// Carry contains type. 0 for block, 1 for single byte
	bcc UnpackCopyBlock

UnpackWriteByte
	// Copy one byte from the source stream
	lda (ptr_source),y
	sta (ptr_destination),y

	inc ptr_source
	bne UnpackWriteByteEndTmp0Inc
	inc ptr_source+1
UnpackWriteByteEndTmp0Inc

	lda #1
	sta nb_dst



UnpackEndLoop
	// We increase the current destination pointer,
	// by a given value, white checking if we reach
	// the end of the buffer.
	clc
	lda ptr_destination
	adc nb_dst
	sta ptr_destination
	ldx ptr_destination+1
	bcc UnpackEndLoopSkip
	inc ptr_destination+1
UnpackEndLoopSkip
	cpx ptr_destination_end+1
	bcc UnpackLoop  
	cmp ptr_destination_end
	bcc UnpackLoop  
UnpackEnd
	rts


UnpackCopyBlock

//BreakPoint jmp BreakPoint	
	// Copy a number of bytes from the already unpacked stream
	// Here we know that y is null. So no need for clearing it.
	// Just be sure it's still null at the end.
	// At this point, the source pointer points to a two byte
	// value that actually contains a 4 bits counter, and a 
	// 12 bit offset to point back into the depacked stream.
	// The counter is in the 4 high order bits.
	clc
	lda (ptr_source),y
	adc #1
	sta offset
	iny
	lda (ptr_source),y
	tax
	adc #0
	and #$0f
	sta offset+1

	txa
	lsr
	lsr
	lsr
	lsr
	clc
	adc #3
	sta nb_dst

	sec
	lda ptr_destination
	sbc offset
	sta ptr_source_back
	lda ptr_destination+1
	sbc offset+1
	sta ptr_source_back+1

	// Beware, in that loop, the direction is important
	// since RLE like depacking is done by recopying the
	// very same byte just copied... Do not make it a 
	// reverse loop to achieve some speed gain...
	// Y was equal to 1 after the offset computation,
	// a simple decrement is ok to make it null again.
	dey
UnpackCopyBlockLoop
	lda (ptr_source_back),y	// Read from already unpacked stream
	sta (ptr_destination),y	// Write to destination buffer
	iny
	cpy nb_dst
	bne UnpackCopyBlockLoop
	ldy #0

	clc
	lda ptr_source
	adc #2
	sta ptr_source
	bcc UnpackEndLoop
	inc ptr_source+1
	jmp UnpackEndLoop

UnpackEndCode

// Taille actuelle du code 279 octets
// 0x08d7 - 0x07e8 => 239 octets
// 0x08c8 - 0x07e5 => 227 octets
// 0x08d5 - 0x0800 => 213 octets
// 0x08c9 - 0x0800 => 201 octets
// 0x08c5 - 0x0800 => 197 octets
// 0x08c3 - 0x0800 => 195 octets
// 0x08c0 - 0x0800 => 192 octets





