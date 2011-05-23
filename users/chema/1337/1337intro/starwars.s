

#define _Texture128x256	_BufferUnpack

;.dsb 4096	; 128x256 pixels texture


	.zero

*=$2c

_ptr_screen		.dsb 2
_textLine		.dsb 2
_dst_x0			.dsb 1
_dst_x02		.dsb 1
_dst_x1			.dsb 1
_src_x			.dsb 2
_src_xinc		.dsb 2
_ptr_base_font	.dsb 2	; unsigned char* LetterTable[8][128]; LetterTable[y][car]=Font8x8+offset+8*y;

_dst_x			.dsb 1
_dst_y			.dsb 1

_line			.dsb 2
_position		.dsb 2

_save_x			.dsb 1

;_scanline		.dsb 40
#define _scanline $7c


	.text

_RasterizeInitScanlineBuffer	
.(
	;
	; Clear the buffer content
	;
	lda #64
	ldx #40
loop	
	sta _scanline-1,x
	dex
	bne loop
		
	;
	; Unpack the texture
	;
	lda #<_Texture128x256Packed
	sta tmp0+0
	lda #>_Texture128x256Packed
	sta tmp0+1

	lda #<_Texture128x256
	sta tmp1+0
	lda #>_Texture128x256
	sta tmp1+1
	
	jmp _FileUnpack
	
	rts
.)
	


		
	.dsb 256-(*&255)	
	
	
;
; Uses a temporary 40 bytes buffer
;
_RasterizeNextLineMapping
.(
	; src_xinc=XIncTable[dst_y];
	; src_x   =0;
	lda #0
	sta _src_x
	sta _src_x+1
	
	ldy _dst_y
	lda _XIncTableLow,y
	sta __src_xinc+1
	lda _XIncTableHigh,y
	sta __src_xinc1+1
				
	; Point on the start of the texture scanline
	; - First pointer is for the left half
	; - Second pointer is for the second half	
	clc
	lda _ptr_base_font+0
	sta __pixel_test_left+1
	adc #8
	sta __pixel_test_right+1
	lda _ptr_base_font+1
	sta __pixel_test_left+2
	adc #0
	sta __pixel_test_right+2
	
	
	sec
	lda #120
	sbc _dst_x0
	sta _dst_x02
	
	clc
	lda #<_TableDiv6b
	adc _dst_x02
	sta __patch_div6_right+1
	lda #>_TableDiv6b
	adc #0
	sta __patch_div6_right+2
	
	clc
	lda #<_Patterns
	adc _dst_x02
	sta __patch_patterns_right+1
	lda #>_Patterns
	adc #0
	sta __patch_patterns_right+2
		
	;x=dst_x
	ldy _dst_x0
	clc
loop_x

	; src_x+=src_xinc;
	; 16 bit addition to get 8:8 format (8 bits integer + 8 bit accuracy decimal part)
	;clc
	lda _src_x
__src_xinc
	adc #123
	sta _src_x
	lda _src_x+1
	tax						; Source pixel (integer part)	
__src_xinc1
	adc #123
	sta _src_x+1

	; Left side
	lda BitMaskTable,x		; Get the bit pattern to test
	sta __pixel_mask_left+1 
	sta __pixel_mask_right+1 
	lda BitShiftTable,x
	sta __pixel_test_offset_right+1
	tax
__pixel_mask_left
	lda #$12				; Source texture bit
__pixel_test_left
	and $1234,x				; Source texture byte
	beq skip_left

	;	ptr_screen[TableDiv6[dst_x]]|=Patterns[dst_x];
	ldx _TableDiv6b,y
	lda _scanline,x
	ora _Patterns,y
	sta _scanline,x
skip_left

	; Right side
__pixel_mask_right
	lda #$12				; Source texture bit
__pixel_test_offset_right
	ldx #$12
__pixel_test_right
	and $1234,x				; Source texture byte
	beq skip_right

	;	ptr_screen[TableDiv6[dst_x]]|=Patterns[dst_x];
__patch_div6_right	
	ldx _TableDiv6b,y
	lda _scanline,x
__patch_patterns_right	
	ora _Patterns,y
	sta _scanline,x
skip_right
			
	iny
	cpy #120
	bne loop_x
	
	;
	; Blit the buffer content to the screen
	;
	ldx _dst_x1
	ldy _TableDiv6b,x
	iny
	sty __endy+1

	ldx _dst_x0
	ldy _TableDiv6b,x
		
	ldx #64
blit	
	lda _scanline,y
	stx _scanline,y
	;ora #64					; Optional: For testing purpose to avoid screen corruption when accessing out of bound texture data containing nasty attributes
	sta (_ptr_screen),y
	iny
__endy	
	cpy #7
	bne blit

	; ptr_screen+=40;
	.(
	clc
	lda _ptr_screen+0
	adc #40
	sta _ptr_screen+0
	bcc skip
	inc _ptr_screen+1
skip	
	.)
	
	; dst_x0--;
	; dst_x1++;
	dec _dst_x0
	inc _dst_x1
			
	rts
.)


#define START_OFFSET 10


_RasterizeScroller
.(
	; ptr_screen=((unsigned char*)0xa000)+40*(86+START_OFFSET);
	lda #<$a000+40*(86+START_OFFSET);
	sta _ptr_screen+0
	lda #>$a000+40*(86+START_OFFSET);
	sta _ptr_screen+1
	
	; dst_x0=120-START_OFFSET;
	; dst_x1=120+START_OFFSET;
	lda #120-START_OFFSET;
	sta _dst_x0
	lda #120+START_OFFSET;
	sta _dst_x1
	
	; for (dst_y=START_OFFSET;dst_y<65;dst_y++)	// 114
	ldy #START_OFFSET	; 10, end = 65
loop
	sty _dst_y

	; line=position+OffsetTable[dst_y];
	sec
	lda _position+0
	sbc _OffsetTable,y
	sta _line+0
	lda _position+1
	sbc #0
	sta _line+1

	; if ((line<0) || (line>255))
	lda _line+1
	bne out
	
in
	; ptr_base_font=Texture128x256+(line*16);
	
	; x2
	asl _line+0
	rol _line+1

	; x4
	asl _line+0
	rol _line+1

	; x8
	asl _line+0
	rol _line+1

	; x16
	asl _line+0
	rol _line+1
				
	clc
	lda #<_Texture128x256
	adc _line+0
	sta _ptr_base_font+0
	lda #>_Texture128x256
	adc _line+1
	sta _ptr_base_font+1
	
	jmp draw
		
out		
	; ptr_base_font=EmptyTextureLine;
	lda #<_EmptyTextureLine
	sta _ptr_base_font+0
	lda #>_EmptyTextureLine
	sta _ptr_base_font+1

draw
		
	jsr _RasterizeNextLineMapping
	
	ldy _dst_y
	iny
	cpy #65
	bne loop
	
	rts
.)



_SWTablesInit
.(
	;//
	;// Generate multiple of 6 data table
	;//
.(
	lda #0
	sta tmp0+0	// cur mul
	sta tmp0+1	// cur div
	sta tmp0+2	// cur mod
	
	lda #128
	sta tmp0+3	// BitMaskTable
	
	lda #32
	sta tmp0+4	// _Patterns

	ldx #0
loop
	lda tmp0+0
	clc
	adc #6
	sta tmp0+0

	lda tmp0+1
	sta _TableDiv6b,x

	ldy tmp0+2
	iny
	cpy #6
	bne skip_mod
	ldy #0
	inc tmp0+1
skip_mod
	sty tmp0+2

	.(
	; Contains repeated 128,64,32,16,8,4,2,1
	lda tmp0+3
	sta BitMaskTable,x		
	lsr tmp0+3
	bne skip
	lda #128
	sta tmp0+3
skip	
	.)

	.(
	; Contains repeated 32,16,8,4,2,1
	lda tmp0+4
	sta _Patterns,x		
	lsr tmp0+4
	bne skip
	lda #32
	sta tmp0+4
skip	
	.)
	
	.(
	; Contains X/8
	txa
	lsr
	lsr
	lsr
	sta BitShiftTable,x
	.)
		
	inx
	bne loop
.)

	
;	sei
	rts
.)

			
_OffsetTable
	.byt 65-0
	.byt 65-0
	.byt 65-0
	.byt 65-0
	.byt 65-0
	.byt 65-0
	.byt 65-0
	.byt 65-0
	.byt 65-0
	.byt 65-0
	.byt 65-0
	.byt 65-2
	.byt 65-4
	.byt 65-5
	.byt 65-7
	.byt 65-8
	.byt 65-9
	.byt 65-11
	.byt 65-12
	.byt 65-13
	.byt 65-14
	.byt 65-16
	.byt 65-17
	.byt 65-18
	.byt 65-19
	.byt 65-20
	.byt 65-22
	.byt 65-23
	.byt 65-24
	.byt 65-25
	.byt 65-26
	.byt 65-27
	.byt 65-29
	.byt 65-30
	.byt 65-31
	.byt 65-32
	.byt 65-33
	.byt 65-34
	.byt 65-35
	.byt 65-37
	.byt 65-38
	.byt 65-39
	.byt 65-40
	.byt 65-41
	.byt 65-42
	.byt 65-43
	.byt 65-44
	.byt 65-46
	.byt 65-47
	.byt 65-48
	.byt 65-49
	.byt 65-50
	.byt 65-51
	.byt 65-52
	.byt 65-53
	.byt 65-54
	.byt 65-56
	.byt 65-57
	.byt 65-58
	.byt 65-59
	.byt 65-60
	.byt 65-61
	.byt 65-62
	.byt 65-63
	.byt 65-64
	.byt 65-65

_DataEnd_


//_TableDiv6				.dsb 256
#if 0
BitMaskTable			.dsb 256
BitShiftTable			.dsb 256
_Patterns				.dsb 256
_XIncTableLow			.dsb 256
_XIncTableHigh			.dsb 256

#endif

_EmptyTextureLine		.dsb 16		; 16 bytes with zeros



