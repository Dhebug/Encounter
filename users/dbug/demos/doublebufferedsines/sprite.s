
//#define SHOW_COUNTERS

	.zero

_zp_start_
	
nb_characters_drawn		.dsb 1

current_text_ascii		.dsb 1

current_menu_line		.dsb 1

_VSyncCounter1			.dsb 2
_VSyncCounter2			.dsb 2

_gKey					.dsb 1

_SpriteBaseAngleX1		.dsb 1
_SpriteBaseAngleX2		.dsb 1
_SpriteBaseAngleY1		.dsb 1
_SpriteBaseAngleY2		.dsb 1

base_menu_values
current_preset			.dsb 1
_free_1					.dsb 1
_free_2					.dsb 1
sprite_speed_alpha_x	.dsb 1	// 0 1 2 3 4
sprite_speed_beta_x		.dsb 1
_free_3					.dsb 1
_free_4					.dsb 1
sprite_speed_alpha_y	.dsb 1
sprite_speed_beta_y		.dsb 1

ptr_dst
ptr_dst_low				.dsb 1
ptr_dst_high			.dsb 1

_zp_end_

	.text



#define MAX_SPRITE	128

	.dsb 256-(*&255)

_SpriteTablePosX
	.dsb MAX_SPRITE

_SpriteTablePosY
	.dsb MAX_SPRITE


	.dsb 256-(*&255)

_SpriteTableHires_AddrLow
	.dsb MAX_SPRITE

_SpriteTableHires_AddrHigh
	.dsb MAX_SPRITE

	.dsb 256-(*&255)

_SpriteTableText_AddrLow
	.dsb MAX_SPRITE

_SpriteTableText_AddrHigh
	.dsb MAX_SPRITE



	.dsb 256-(*&255)

TablePixels
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1

	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1

	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1

	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1
	.byt 64+32,64+16,64+8,64+4,64+2,64+1


	.dsb 256-(*&255)


_SpriteComputePositions
	lda _SpriteBaseAngleX1
	clc
__auto_base_speed_alpha_x	
	adc #0
	sta _SpriteBaseAngleX1
	tax

	lda _SpriteBaseAngleX2
	clc
__auto_base_speed_beta_x	
	adc #0
	sta _SpriteBaseAngleX2
	tay
	
	;// x=CosTableX[anglex1]+CosTableX[anglex2];
	;// anglex1+=1;
	;// anglex2+=2;
	clc
		
#define CURDOT 0

// 0
__auto_compute_x
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 10
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 20
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 30
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 40
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 50
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 60
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 70
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 80
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 90
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 100
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 110
#include "compute_x.s" // 0
#include "compute_x.s" // 1
#include "compute_x.s" // 2
#include "compute_x.s" // 3
#include "compute_x.s" // 4
#include "compute_x.s" // 5
#include "compute_x.s" // 6
#include "compute_x.s" // 7
#include "compute_x.s" // 8
#include "compute_x.s" // 9

// 120
#include "compute_x.s"  // 0
#include "compute_x.s"  // 1
#include "compute_x.s"  // 2
#include "compute_x.s"  // 3
#include "compute_x.s"  // 4
#include "compute_x.s"  // 5
#include "compute_x.s"  // 6
#include "compute_x.s"  // 7
	
	lda _SpriteBaseAngleY1
	clc
__auto_base_speed_alpha_y
	adc #0
	sta _SpriteBaseAngleY1
	tax

	lda _SpriteBaseAngleY2
	clc
__auto_base_speed_beta_y
	adc #0
	sta _SpriteBaseAngleY2
	tay

		;// y=CosTableY[angley1]+CosTableY[angley2];
		;// angley1+=3;
		;// angley2+=5;
		clc
#define CURDOT 0

// 0
__auto_compute_y
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 10
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 20
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 30
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 40
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 50
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 60
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 70
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 80
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 90
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 100
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 110
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
#include "compute_y.s" // 8
#include "compute_y.s" // 9

// 120
#include "compute_y.s" // 0
#include "compute_y.s" // 1
#include "compute_y.s" // 2
#include "compute_y.s" // 3
#include "compute_y.s" // 4
#include "compute_y.s" // 5
#include "compute_y.s" // 6
#include "compute_y.s" // 7
	
	rts



	.dsb 256-(*&255)

//
// New fast code
//
_SpriteUpdateHiresStuff
	// Start by deleting all the old pixels
	lda #64
__auto_HIRES_ERASE
	// 0
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 10
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 20
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 30
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 40
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 50
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 60
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 70
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 80
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 90
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 100
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 110
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 120
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	
_SpriteUpdateHiresStuff_1st
	//jmp _SpriteUpdateHiresStuff_1st
	
	.(
		ldy #0
		clc
		
#define CURDOT 0

// 0
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 10
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 20
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 30
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 40
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 50
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 60
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 70
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 80
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 90
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 100
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 110
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
#include "sprite_draw.s" // 8
#include "sprite_draw.s" // 9

// 120
#include "sprite_draw.s" // 0
#include "sprite_draw.s" // 1
#include "sprite_draw.s" // 2
#include "sprite_draw.s" // 3
#include "sprite_draw.s" // 4
#include "sprite_draw.s" // 5
#include "sprite_draw.s" // 6
#include "sprite_draw.s" // 7
                         
	rts                  
.)

	


	.dsb 256-(*&255)

_SpriteUpdateTextStuff
.(
	//
	// Clear the locations patched on screen
	//
	ldy #0
	ldx nb_characters_drawn
loop_erase
	lda _SpriteTableText_AddrLow-1,x
	sta tmp0+0
	lda _SpriteTableText_AddrHigh-1,x
	sta tmp0+1
	lda #32
	sta (tmp0),y

	dex 
	bne loop_erase
	stx nb_characters_drawn
.)
	

tototot
	//jmp tototot
	
	// Start by deleting all the old pixels
	lda #64
__auto_TEXT_ERASE
	// 0
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 10
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 20
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 30
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 40
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 50
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 60
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 70
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 80
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 90
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 100
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 110
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	sta $1234 // 8
	sta $1234 // 9
	// 120
	sta $1234 // 0
	sta $1234 // 1
	sta $1234 // 2
	sta $1234 // 3
	sta $1234 // 4
	sta $1234 // 5
	sta $1234 // 6
	sta $1234 // 7
	
_SpriteUpdateTextStuff_1st
	//jmp _SpriteUpdateTextStuff_1st
.(	
	// And draw the new ones
	lda #33
	sta current_text_ascii
	
	lda #0
	sta nb_characters_drawn

	ldy #0
	clc
	
#define CURDOT 0

// 0
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

// 10
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

// 20
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

// 30
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

// 40
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

// 50
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

// 60
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

// 70
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

// 80
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

// 90
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

//100
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

//110
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
#include "sprite_text_draw.s" // 8
#include "sprite_text_draw.s" // 9

//120
#include "sprite_text_draw.s" // 0
#include "sprite_text_draw.s" // 1
#include "sprite_text_draw.s" // 2
#include "sprite_text_draw.s" // 3
#include "sprite_text_draw.s" // 4
#include "sprite_text_draw.s" // 5
#include "sprite_text_draw.s" // 6
#include "sprite_text_draw.s" // 7
                              
	rts                       
.)


#define ATTRB_HIRES	30
#define ATTRB_TEXT 26

#define ENDSCREEN $A000+39+40*7

_MainLoopStuff
.(
	// First wait for vertical retrace
	jsr _VSync
	
#ifdef SHOW_COUNTERS	
	// Start of screen in TEXT mode
	// We poke a "switch to hires" attribute
	jsr _VSyncGetCounter
#endif
	
	lda #ATTRB_TEXT
	sta ENDSCREEN
	
#ifdef SHOW_COUNTERS	
	jsr _VSyncShowCounter1
#endif

	// Draw new HIRES stuff
	jsr _SpriteComputePositions
	jsr _SpriteUpdateHiresStuff_1st


	// Anticipated TEXT dots computations
	jsr _SpriteComputePositions
	
	// Start of screen in TEXT mode
	// We poke a "switch to hires" attribute
#ifdef SHOW_COUNTERS	
	jsr _VSyncGetCounter
#endif
	
	lda #ATTRB_HIRES
	sta ENDSCREEN
	
#ifdef SHOW_COUNTERS	
	jsr _VSyncShowCounter2
#endif
	// Draw new TEXT stuff
	//SpriteComputePositions
	jsr _SpriteUpdateTextStuff_1st
	 
	// First wait for vertical retrace
	jsr _VSync

loop	
		// Start of screen in TEXT mode
		// We poke a "switch to hires" attribute
#ifdef SHOW_COUNTERS	
		jsr _VSyncGetCounter
#endif		
		lda #ATTRB_TEXT
		sta ENDSCREEN
		
#ifdef SHOW_COUNTERS	
		jsr _VSyncShowCounter1
#endif

		// Draw new HIRES stuff
		jsr _SpriteComputePositions
		jsr _SpriteUpdateHiresStuff


		// Anticipated TEXT dots computations
		jsr _SpriteComputePositions
		
		// Start of screen in TEXT mode
		// We poke a "switch to hires" attribute
#ifdef SHOW_COUNTERS	
		jsr _VSyncGetCounter
#endif
		
		lda #ATTRB_HIRES
		sta ENDSCREEN
		
#ifdef SHOW_COUNTERS	
		jsr _VSyncShowCounter2
#endif

		// Draw new TEXT stuff
		//jsr _SpriteComputePositions
		jsr _SpriteUpdateTextStuff
		
		
		// Move stuff...
		jsr _ManageControlScreen
		
	jmp loop

	rts
.)


#define BASE_TEXT $bb80+40*17+6

_MainShowControlKeys
.(
	//	*((char*)0xbb80+40*(16+y)+1)=9;
	lda #<BASE_TEXT
	sta tmp0+0
	lda #>BASE_TEXT
	sta tmp0+1
	
	ldx #0
loop_line	
	ldy #0
loop_char	
	lda _ControlScreen,x
	bmi end_of_line
	inx
	
	sta (tmp0),y
	iny
	jmp loop_char
		
end_of_line
	inx
	lda _ControlScreen,x
	beq end_of_text
	
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc loop_line
	inc tmp0+1
	
	jmp loop_line
	
end_of_text	

	ldx current_menu_line
	lda #16+4	// BLUE
	jsr _SetSelection

	jsr LoadPreset
	
	rts
.)


#define Vm2	0	
#define Vm1	1
#define V0	2
#define Vp1	3
#define Vp2	4

#define MAX_PRESET			6
#define MAX_PRESET_VALUES	13
	
_TablePresets
	.byt 0	,1	,2	,3	,4	,5	   	; 0-n => Preset ID
	;                           
	.byt 1	,2	,0	,0	,127,4  	; 00-FF
	.byt 0	,3	,1	,2	,0	,253   	; 00-FF
	.byt Vp1,Vp2,Vp1,Vp1,Vp2,Vp1	; -2/-1/0/+1/+2
	.byt V0	,Vp2,Vp1,Vp2,Vp2,Vp2		; -2/-1/0/+1/+2
	.byt 1	,4	,1	,3	,1	,7	   	; 00-FF
	.byt 0	,2	,0	,1	,0	,1	   	; 00-FF
	.byt Vp1,Vp2,Vp1,Vp1,Vp2,Vp2	; -2/-1/0/+1/+2
	.byt V0	,Vp2,Vp2,V0	,Vp2,Vp2	; -2/-1/0/+1/+2
	;                           
	.byt 0	,0	,0	,0	,0	,0	   	; Base Alpha X
	.byt 0	,0	,0	,0	,0	,1	   	; Base Beta X
	.byt 64	,64	,64	,0	,64	,3	 	; Base Alpha Y
	.byt 0	,0	,0	,0	,0	,7	   	; Base Beta Y


LoadPreset
	;jmp LoadPreset
	; Read presets from the data table
	.(
	lda #<_TablePresets+MAX_PRESET_VALUES*MAX_PRESET
	sta tmp2+0
	lda #>_TablePresets
	sta tmp2+1
	
	
	ldy current_preset
	ldx #MAX_PRESET_VALUES
loop
	.(
	sec
	lda tmp2+0
	sbc #MAX_PRESET
	sta tmp2+0
	lda tmp2+1
	sbc #0
	sta tmp2+1
	.)
	
	lda (tmp2),y
	pha
	
	dex
	bne loop	
	.)
	
	
	; Then load presets
	ldx #0
	stx current_menu_line
	pla
	sta current_preset
	jsr _SetSelectionValueByte
	
	inc current_menu_line
	pla
	sta __auto_base_speed_alpha_x+1
	jsr _SetSelectionValueByte
	
	inc current_menu_line
	pla
	sta __auto_base_speed_beta_x+1
	jsr _SetSelectionValueByte
		
	inc current_menu_line
	pla
	sta sprite_speed_alpha_x
	jsr _SetSelectionValueSmallSignedNumber

	inc current_menu_line
	pla
	sta sprite_speed_beta_x
	jsr _SetSelectionValueSmallSignedNumber
			
	inc current_menu_line
	pla
	sta __auto_base_speed_alpha_y+1
	jsr _SetSelectionValueByte
	
	inc current_menu_line
	pla
	sta __auto_base_speed_beta_y+1
	jsr _SetSelectionValueByte
		
	inc current_menu_line
	pla
	sta sprite_speed_alpha_y
	jsr _SetSelectionValueSmallSignedNumber

	inc current_menu_line
	pla
	sta sprite_speed_beta_y
	jsr _SetSelectionValueSmallSignedNumber
	
	;
	; Then set X/Y values
	;
	pla
	sta _SpriteBaseAngleX1
	pla
	sta _SpriteBaseAngleX2
	pla
	sta _SpriteBaseAngleY1
	pla
	sta _SpriteBaseAngleY2
	
	ldx #0
	stx current_menu_line
	
	rts

	
_SetSelection
.(
	ldy _ControlScreen_ScreenLow,x
	sty tmp0+0
	ldy _ControlScreen_ScreenHigh,x
	sty tmp0+1
	ldy #0
	sta (tmp0),y
	rts
.)

_SetSelectionValueByte
.(
	ldx current_menu_line

	ldy _ControlScreen_ScreenLow,x
	sty tmp0+0
	ldy _ControlScreen_ScreenHigh,x
	sty tmp0+1
	
	pha
	and #$0F
	tax
	lda _VSyncHexaDigit,x
	ldy #2
	sta (tmp0),y
	pla
	lsr
	lsr
	lsr
	lsr
	tax
	lda _VSyncHexaDigit,x
	ldy #1
	sta (tmp0),y

	rts
.)



_TableDigitValues_0	.asc "-- ++"
_TableDigitValues_1	.asc "21012"

_SetSelectionValueSmallSignedNumber
.(
	ldx current_menu_line

	ldy _ControlScreen_ScreenLow,x
	sty tmp0+0
	ldy _ControlScreen_ScreenHigh,x
	sty tmp0+1

	lda base_menu_values,x
	tax
	
	// Display text '+2' on screen	
	ldy #1
	lda _TableDigitValues_0,x
	sta (tmp0),y
	lda _TableDigitValues_1,x
	iny 
	sta (tmp0),y

	// Patches increment opcodes in memory
	
	// 1) Store the base adress
	ldx current_menu_line
	
	lda _TablePatch_addrbase_low,x
	sta tmp0+0
	lda _TablePatch_addrbase_high,x
	sta tmp0+1

	lda _TablePatch_addrbase_opcode_low,x
	sta __pathch_1+1
	sta __pathch_2+1
	lda _TablePatch_addrbase_opcode_high,x
	sta __pathch_1+2
	sta __pathch_2+2
		
	ldy _TablePatch_offset,x

	clc
	lda base_menu_values,x
	adc base_menu_values,x
	tax	// *2
	
		
	lda #128
	sta tmp1
loop_patch
	// Patch the value
__pathch_1	
	lda $1234,x
	sta (tmp0),y
	iny
	inx
__pathch_2
	lda $1234,x
	sta (tmp0),y
	dey
	dex

	// Increment adress
	clc
	lda tmp0+0
	adc #14
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip	
	
		
	// last one ?
	dec tmp1
	bne loop_patch
	rts
.)




// __auto_compute_x is the label
// Routine is:
//
//	+0 lda _CosTableX,x			// 4 cycles
//	+3 inx							// 2
//	+4 nop							// 2
//	
//	+5 adc _CosTableX,y			// 4
//	+8 iny							// 2 
//	+9 iny							// 2
//
//	+10 ror							// 2
//	+11 sta _SpriteTablePosX+CURDOT	// 4 cycles
//
// Total size=14 bytes * MAX_SPRITE (128 so far)
// 	
//sprite_speed_alpha_x	.dsb 1
//sprite_speed_beta_x		.dsb 1
//sprite_speed_alpha_y	.dsb 1
//sprite_speed_beta_y		.dsb 1


#define _NOP $EA
#define _INX $E8
#define _DEX $CA
#define _INY $C8
#define _DEY $88

// Two bytes, from -2 to +2
_TableOpcodeValuesX
	.byt _DEX,_DEX
	.byt _DEX,_NOP
	.byt _NOP,_NOP
	.byt _INX,_NOP
	.byt _INX,_INX

// Two bytes, from -2 to +2
_TableOpcodeValuesY
	.byt _DEY,_DEY
	.byt _DEY,_NOP
	.byt _NOP,_NOP
	.byt _INY,_NOP
	.byt _INY,_INY


_TablePatch_addrbase_low
	.byt 0
	.byt 0
	.byt 0
	.byt <__auto_compute_x
	.byt <__auto_compute_x
	.byt 0
	.byt 0
	.byt <__auto_compute_y
	.byt <__auto_compute_y

_TablePatch_addrbase_high
	.byt 0
	.byt 0
	.byt 0
	.byt >__auto_compute_x
	.byt >__auto_compute_x
	.byt 0
	.byt 0
	.byt >__auto_compute_y
	.byt >__auto_compute_y

_TablePatch_addrbase_opcode_low
	.byt 0
	.byt 0
	.byt 0
	.byt <_TableOpcodeValuesX
	.byt <_TableOpcodeValuesY
	.byt 0
	.byt 0
	.byt <_TableOpcodeValuesX
	.byt <_TableOpcodeValuesY

_TablePatch_addrbase_opcode_high
	.byt 0
	.byt 0
	.byt 0
	.byt >_TableOpcodeValuesX
	.byt >_TableOpcodeValuesY
	.byt 0
	.byt 0
	.byt >_TableOpcodeValuesX
	.byt >_TableOpcodeValuesY
	
_TablePatch_offset
	.byt 0
	.byt 0
	.byt 0
	.byt 3
	.byt 8
	.byt 0
	.byt 0
	.byt 3
	.byt 8

	
key_up
	//lda #16+1
	//sta $bb80+40*16+1
.(
	ldx current_menu_line
	bne continue
	rts
	
continue
	lda #16		// BLACK
	jsr _SetSelection
	dex
	stx current_menu_line
	lda #16+4	// BLUE
	jsr _SetSelection
	rts
.)
	
key_down
	//lda #16+2
	//sta $bb80+40*16+1
.(
	ldx current_menu_line
	cpx #8
	bne continue
	rts
	
continue
	lda #16		// BLACK
	jsr _SetSelection
	inx
	stx current_menu_line
	lda #16+4	// BLUE
	jsr _SetSelection
	rts
.)

_ManageControlScreen
.(
	//
	// Keyboard handling	
	//
	jsr _KeyboardRead
	
	lda _gKey
	and #4
	bne key_up
	
	lda _gKey
	and #8
	bne key_down
	
	lda _gKey
	and #1
	bne key_left
	
	lda _gKey
	and #2
	bne key_right
	rts
	


key_left
.(
test_Preset
	ldx current_menu_line
	bne test_BaseSpeedAlphaX
	
	.(
	ldx current_preset
	bne continue
	rts
continue
	dex
	stx current_preset
	jmp LoadPreset
	.)

test_BaseSpeedAlphaX
	dex
	bne test_BaseSpeedBetaX
		
	dec __auto_base_speed_alpha_x+1
	lda __auto_base_speed_alpha_x+1
	jmp _SetSelectionValueByte
	
test_BaseSpeedBetaX
	dex
	bne test_SpeedAlphaX

	dec __auto_base_speed_beta_x+1
	lda __auto_base_speed_beta_x+1
	jmp _SetSelectionValueByte
		
test_SpeedAlphaX	
	dex
	bne test_SpeedBetaX

	.(
	ldx sprite_speed_alpha_x
	bne continue
	rts
continue	 
	dex
	stx sprite_speed_alpha_x
	jmp _SetSelectionValueSmallSignedNumber
	.)
		
test_SpeedBetaX	
	dex
	bne test_BaseSpeedAlphaY

	.(
	ldy sprite_speed_beta_x
	bne continue
	rts
continue	 
	dey
	sty sprite_speed_beta_x
	jmp _SetSelectionValueSmallSignedNumber
	.)
		
test_BaseSpeedAlphaY
	dex
	bne test_BaseSpeedBetaY

	dec __auto_base_speed_alpha_y+1
	lda __auto_base_speed_alpha_y+1
	jmp _SetSelectionValueByte
		
test_BaseSpeedBetaY
	dex
	bne test_SpeedAlphaY

	dec __auto_base_speed_beta_y+1
	lda __auto_base_speed_beta_y+1
	jmp _SetSelectionValueByte
		
test_SpeedAlphaY
	dex
	bne test_SpeedBetaY
	
	.(
	ldx sprite_speed_alpha_y
	bne continue
	rts
continue	 
	dex
	stx sprite_speed_alpha_y
	jmp _SetSelectionValueSmallSignedNumber
	.)
	
test_SpeedBetaY
	dex
	bne end

	.(
	ldy sprite_speed_beta_y
	bne continue
	rts
continue	 
	dey
	sty sprite_speed_beta_y
	jmp _SetSelectionValueSmallSignedNumber
	.)
		
end	
	rts
.)




key_right	
.(
test_Preset
	ldx current_menu_line
	bne test_BaseSpeedAlphaX

.(
	ldx current_preset
	cpx #MAX_PRESET-1
	bne continue
	rts
continue	 
	inx
	stx current_preset
	jmp LoadPreset
.)
	

test_BaseSpeedAlphaX
	dex
	bne test_BaseSpeedBetaX
	
	inc __auto_base_speed_alpha_x+1
	lda __auto_base_speed_alpha_x+1
	jmp _SetSelectionValueByte
		
test_BaseSpeedBetaX
	dex
	bne test_SpeedAlphaX
	
	inc __auto_base_speed_beta_x+1
	lda __auto_base_speed_beta_x+1
	jmp _SetSelectionValueByte
	
test_SpeedAlphaX	
	dex
	bne test_SpeedBetaX

.(
	ldx sprite_speed_alpha_x
	cpx #4
	bne continue
	rts
continue	 
	inx
	stx sprite_speed_alpha_x
	jmp _SetSelectionValueSmallSignedNumber
.)
		
test_SpeedBetaX
	dex
	bne test_BaseSpeedAlphaY

.(
	ldy sprite_speed_beta_x
	cpy #4
	bne continue
	rts
continue	 
	iny
	sty sprite_speed_beta_x
	jmp _SetSelectionValueSmallSignedNumber
.)
		
test_BaseSpeedAlphaY
	dex
	bne test_BaseSpeedBetaY

	inc __auto_base_speed_alpha_y+1
	lda __auto_base_speed_alpha_y+1
	jmp _SetSelectionValueByte
	
test_BaseSpeedBetaY
	dex
	bne test_SpeedAlphaY

	inc __auto_base_speed_beta_y+1
	lda __auto_base_speed_beta_y+1
	jmp _SetSelectionValueByte
		
test_SpeedAlphaY	
	dex
	bne test_SpeedBetaY

.(
	ldx sprite_speed_alpha_y
	cpx #4
	bne continue
	rts
continue	 
	inx
	stx sprite_speed_alpha_y
	jmp _SetSelectionValueSmallSignedNumber
.)
		
test_SpeedBetaY	
	dex
	bne end

.(
	ldy sprite_speed_beta_y
	cpy #4
	bne continue
	rts
continue	 
	iny
	sty sprite_speed_beta_y
	jmp _SetSelectionValueSmallSignedNumber
.)
		
end	
	rts
.)
	
.)


	
	
		
	
//ControlValueBaseX1	.byt 0	// -5 to +5
//ControlValueBaseX2	.byt 0	// -5 to +5
//ControlValueBaseY1	.byt 0	// -5 to +5
//ControlValueBaseY2	.byt 0	// -5 to +5

//ControlValueIncX1	.byt 0	// -2 to +2
//ControlValueIncX2	.byt 0	// -2 to +2
//ControlValueIncY1	.byt 0	// -2 to +2
//ControlValueIncY2	.byt 0	// -2 to +2



_ControlScreen
	.asc 9,2,"PRESET  0 ",16,255       // 0
	.byt 255
	.asc 9,4,"BASE SPEED ALPHA X  ",7," 00 ",16,255		// 1
	.asc 9,1,"BASE SPEED BETA X   ",7," 00 ",16,255		// 2
	.asc 9,3,"SPEED ALPHA X       ",7,"  0 ",16,255		// 3
	.asc 9,7,"SPEED BETA X        ",7,"  0 ",16,255		// 4
	.asc 9,7,"BASE SPEED ALPHA Y  ",7," 00 ",16,255		// 5
	.asc 9,3,"BASE SPEED BETA Y   ",7," 00 ",16,255		// 6
	.asc 9,1,"SPEED ALPHA Y       ",7,"  0 ",16,255		// 7
	.asc 9,4,"SPEED BETA Y        ",7,"  0 ",16,255		// 8
	.byt 255,0
	
		
_ControlScreen_ScreenLow
	.byt <$bb80+40*17+9+5
	.byt <$bb80+40*19+22+7
	.byt <$bb80+40*20+22+7
	.byt <$bb80+40*21+22+7
	.byt <$bb80+40*22+22+7
	.byt <$bb80+40*23+22+7
	.byt <$bb80+40*24+22+7
	.byt <$bb80+40*25+22+7
	.byt <$bb80+40*26+22+7
	
_ControlScreen_ScreenHigh
	.byt >$bb80+40*17+9+5
	.byt >$bb80+40*19+22+7
	.byt >$bb80+40*20+22+7
	.byt >$bb80+40*21+22+7
	.byt >$bb80+40*22+22+7
	.byt >$bb80+40*23+22+7
	.byt >$bb80+40*24+22+7
	.byt >$bb80+40*25+22+7
	.byt >$bb80+40*26+22+7

	

_PrepareScreen
.(
	//
	// Top and bottom rasters
	//
	lda #16+4
	sta $a000+40*0
	sta $a000+40*120
	
	lda #16+1
	sta $a000+40*1
	sta $a000+40*121
	
	lda #16+3
	sta $a000+40*2
	sta $a000+40*122
	
	lda #16+7
	sta $a000+40*3
	sta $a000+40*123
	
	lda #16+3
	sta $a000+40*4
	sta $a000+40*124
	
	lda #16+1
	sta $a000+40*5
	sta $a000+40*125
	
	lda #16+4
	sta $a000+40*6
	sta $a000+40*126
	
	lda #16+0
	sta $a000+40*7
	sta $a000+40*127

	
	// Force TEXT mode to go back to HIRES rasters
	lda #16+4
	sta $BB80+40*15
	
	lda #ATTRB_HIRES
	sta $BB80+40*15+1

	// And then back to TEXT mode for the bottom part of the screen
	lda #ATTRB_TEXT
	sta $a000+40*127+39

	lda #ATTRB_HIRES
	sta $bfdf
		
	
	rts
.)
	
TestZeroUn

	*=$00
	
TestZero
	lda #$12
	lda #$13
	sta TestZero+1
TestZeroEnd

	*=$100	
	
TestUn
	lda #$12
	lda #$13
	sta TestUn+1
TestUnEnd

	*=TestZeroUn+(TestUnEnd-TestUn)+(TestZeroEnd-TestZero)
	
TestZeroUnEnd
	lda #$12
	lda #$13
	sta TestZeroUnEnd+1
	
	
	