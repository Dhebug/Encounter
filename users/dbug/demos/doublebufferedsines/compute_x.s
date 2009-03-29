// Assumes that carry is cleared at the beggining, and restored it cleaned at the end
.(
	lda _CosTableX,x			// 4 cycles
	nop							// 2
	nop							// 2
	
	adc _CosTableX,y			// 4
	nop							// 2 
	nop							// 2
	
	ror							// 2
	sta _SpriteTablePosX+CURDOT	// 4 cycles
	
#define CURDOT CURDOT+1
.)	
	