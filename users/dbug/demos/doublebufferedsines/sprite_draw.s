// Assumes that carry is cleared at the beggining, and restored it cleaned at the end
.(
	ldx _SpriteTablePosX+CURDOT				// Read X coordinate of dot in the table
	lda _TableDiv6,x

	ldx _SpriteTablePosY+CURDOT				// Read Y coordinate of dot in the table
	adc _HiresAddrLow+8,x					// HIRES adress (low byte)
	sta tmp0+0
	sta __auto_HIRES_ERASE+((CURDOT)*3)+1		// Store for erasing (low byte)
	
	lda _HiresAddrHigh+8,x					// HIRES adress (high byte)
	adc #0
	sta tmp0+1
	sta __auto_HIRES_ERASE+((CURDOT)*3)+2	// Store for erasing (high byte)

	ldx _SpriteTablePosX+CURDOT				// Read X coordinate of dot in the table
	lda TablePixels,x
	ora (tmp0),y							// Read from screen
	sta (tmp0),y							// Write on screen

#define CURDOT CURDOT+1
.)	
	