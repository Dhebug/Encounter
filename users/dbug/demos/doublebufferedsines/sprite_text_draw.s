// Assumes that carry is cleared at the beggining, and restored it cleaned at the end
.(
	ldx _SpriteTablePosX+CURDOT				// Read X coordinate of dot in the table
	lda _TableDiv6,x
	
	ldx _SpriteTablePosY+CURDOT				// Read Y coordinate of dot in the table
	adc _TextAddrLow+8,x
	sta tmp0+0								// Screen position of the character (low byte)
	lda _TextAddrHigh+8,x
	adc #0
	sta tmp0+1								// Screen position of the character (high byte)

	lda (tmp0),y							// Get the ascii code of the character located in this area
	cmp #32									// Allocated ?
	bne update_char							// Yes, so update that one
	
	// Allocate a new character
	ldx nb_characters_drawn
	lda tmp0+0
	sta _SpriteTableText_AddrLow,x
	lda tmp0+1
	sta _SpriteTableText_AddrHigh,x
	inc nb_characters_drawn

	// Set new ascii code to this place
	lda current_text_ascii
	sta (tmp0),y
	inc current_text_ascii
	
update_char
	// At this point we have A=ascii code
	tay

	lda _SpriteTablePosY+CURDOT				// Read Y coordinate of dot in the table
	and #7									// Modulo 8 to point on the right byte in the character

	clc	
	adc	_CharAddrLow,y
	sta tmp1+0
	sta __auto_TEXT_ERASE+((CURDOT)*3)+1	// Store for erasing (low byte)
	lda	_CharAddrHigh,y
	adc #0
	sta tmp1+1
	sta __auto_TEXT_ERASE+((CURDOT)*3)+2	// Store for erasing (high byte)

	ldx _SpriteTablePosX+CURDOT				// Read X coordinate of dot in the table
	lda TablePixels,x						// Pixel definition
	
	ldy #0
	ora (tmp1),y							// Mask pixel
	sta (tmp1),y

#define CURDOT CURDOT+1
.)	
	
