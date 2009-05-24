

	.zero

	*= $50

ap		.dsb 2
fp		.dsb 2
sp		.dsb 2
tmp0	.dsb 2
tmp1	.dsb 2
tmp2	.dsb 2
tmp3	.dsb 2
tmp4	.dsb 2
tmp5	.dsb 2
tmp6	.dsb 2
tmp7	.dsb 2
op1		.dsb 2
op2		.dsb 2
tmp		.dsb 2
reg0	.dsb 2
reg1	.dsb 2
reg2	.dsb 2
reg3	.dsb 2
reg4	.dsb 2
reg5	.dsb 2
reg6	.dsb 2
reg7	.dsb 2


	.text


#define run_adress			$600	; Come from original TAP executable
#define unpacked_size		8723	; Come from original TAP executable

; Packed source data adress
#define	ptr_source			tmp0	

; Destination adress where we depack
#define	ptr_destination		tmp1	

; Point on the end of the depacked stuff
#define	ptr_destination_end	tmp2	

; Temporary used to hold a pointer on depacked stuff
#define ptr_source_back		tmp3	

; Temporary
#define offset				tmp4	

#define mask_counter		reg0
#define mask_value			reg1
#define nb_src				reg2
#define nb_dst				reg3


_Unpack
	; Initialise start and end adresses
	clc
	lda #<_UnpackBeginData
	sta ptr_source
	adc #<unpacked_size
	sta ptr_destination_end+0
	
	lda #>_UnpackBeginData
	sta ptr_source+1
	adc #>unpacked_size
	sta ptr_destination_end+1


	; Initialise variables
	; We try to keep "y" null during all the code,
	; so the block copy routine has to be sure that
	; y is null on exit
	ldy #0
	lda #1
	sta mask_counter
	 
_UnpackLoop
	; Handle bit mask
	dec mask_counter
	bne _UnpackEndReload
	
	; Reload encoding type mask
	lda #8
	sta mask_counter

	lda (ptr_source),y	; Read from source stream
	sta mask_value   

	inc ptr_source		; Move stream pointer (one byte)
	bne _UnpackEndReload
	inc ptr_source+1
_UnpackEndReload

	ror mask_value		; Carry contains type. 0 for block, 1 for single byte
	bcc _UnpackCopyBlock

_UnpackWriteByte
	; Copy one byte from the source stream
	lda (ptr_source),y
	sta (ptr_destination),y

	inc ptr_source
	bne _UnpackWriteByteEndTmp0Inc
	inc ptr_source+1
_UnpackWriteByteEndTmp0Inc

	lda #1
	sta nb_dst



_UnpackEndLoop
	; We increase the current destination pointer,
	; by a given value, white checking if we reach
	; the end of the buffer.
	clc
	lda ptr_destination
	adc nb_dst
	sta ptr_destination
	ldx ptr_destination+1
	bcc _UnpackEndLoopSkip
	inc ptr_destination+1
_UnpackEndLoopSkip
	cpx ptr_destination_end+1
	bmi _UnpackLoop  
	cmp ptr_destination_end
	bmi _UnpackLoop  
_UnpackEnd
	; Run the unpacked executable
	jmp run_adress
	

_UnpackCopyBlock

;BreakPoint jmp BreakPoint	
	; Copy a number of bytes from the already unpacked stream
	; Here we know that y is null. So no need for clearing it.
	; Just be sure it's still null at the end.
	; At this point, the source pointer points to a two byte
	; value that actually contains a 4 bits counter, and a 
	; 12 bit offset to point back into the depacked stream.
	; The counter is in the 4 high order bits.
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

	; Beware, in that loop, the direction is important
	; since RLE like depacking is done by recopying the
	; very same byte just copied... Do not make it a 
	; reverse loop to achieve some speed gain...
	; Y was equal to 1 after the offset computation,
	; a simple decrement is ok to make it null again.
	dey
_UnpackCopyBlockLoop
	lda (ptr_source_back),y	; Read from already unpacked stream
	sta (ptr_destination),y	; Write to destination buffer
	iny
	cpy nb_dst
	bne _UnpackCopyBlockLoop
	ldy #0

	clc
	lda ptr_source
	adc #2
	sta ptr_source
	bcc _UnpackEndLoop
	inc ptr_source+1
	jmp _UnpackEndLoop

_UnpackEndCode

; Taille actuelle du code 279 octets
; 0x08d7 - 0x07e8 => 239 octets
; 0x08c8 - 0x07e5 => 227 octets
; 0x08d5 - 0x0800 => 213 octets
; 0x08c9 - 0x0800 => 201 octets
; 0x08c5 - 0x0800 => 197 octets
; 0x08c3 - 0x0800 => 195 octets
; 0x08c0 - 0x0800 => 192 octets

_UnpackBeginData
	.byt 0,1,2,3,4
_UnpackEndData


