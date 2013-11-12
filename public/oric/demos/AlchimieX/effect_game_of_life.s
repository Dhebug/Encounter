
 .zero
 
_ptr_buffer1	.dsb 2
_ptr_buffer2	.dsb 2
 
NeighbourCount	.dsb 1


 .text
 
#define GOL_WIDTH 32
#define GOL_HEIGHT 8   // 32*8=256...

 
_GOL_RedefineCharacters
.(
  ldx #8*4
loop  
  lda GOL_Charset-1,x
  sta $b400+36*8-1,x		; $
  dex 
  bne loop
  rts
.) 
 

GOL_Charset
 ; 2
 .byt %000000
 .byt %000000
 .byt %000000
 .byt %001100
 .byt %001100
 .byt %000000
 .byt %000000
 .byt %000000
 
 ; 3
 .byt %000000
 .byt %000000
 .byt %001100
 .byt %011110
 .byt %011110
 .byt %001100
 .byt %000000
 .byt %000000
 
 ; 4
 .byt %000000
 .byt %011100
 .byt %111110
 .byt %111110
 .byt %111110
 .byt %111110
 .byt %011100
 .byt %000000

  ; 5
 .byt %000000
 .byt %011110
 .byt %111111
 .byt %111111
 .byt %111111
 .byt %111111
 .byt %111111
 .byt %011110
 
 
 
 
/*
unsigned char x,y;
unsigned char* screen;

unsigned char* ptr=ptr_buffer1;
screen=(unsigned char*)0xbb80+(40*4)+5;	
for (y=0;y<GOL_HEIGHT;y++)
{
	for (x=0;x<GOL_WIDTH;x++)
	{
		if (*ptr++)	
		{
			screen[x]=32+4;
		}
		else		
		{
			if (screen[x]>' ')
			{
				screen[x]--;
			}
		}
	}
	screen+=40;
}
*/

; #define GOL_WIDTH 32
; #define GOL_HEIGHT 8
; 32*8 => 256 bytes

_GOL_ShowBuffer
.(
	lda _ptr_buffer1+0
	sta tmp0+0
	lda _ptr_buffer1+1
	sta tmp0+1
	
	lda #<$bb80+(40*11)+5
	sta tmp1+0
	lda #>$bb80+(40*11)+5
	sta tmp1+1

	lda #<$bb80+(40*27)+5
	sta tmp2+0
	lda #>$bb80+(40*27)+5
	sta tmp2+1
	
	ldx #GOL_HEIGHT
loop_y

	ldy #0
loop_x
	lda (tmp0),y
	beq fade_out
new
	lda #39
	sta (tmp1),y
	jmp end
	
fade_out	
	lda (tmp1),y
	cmp #32
	beq end
	sec
	sbc #1	
	cmp #35			; the # is destroyed by the character redefinition, so we need to skip it
	bne no_end
	lda #32
no_end	
	sta (tmp1),y
	sta (tmp2),y

end	
	iny
	cpy #GOL_WIDTH
	bne loop_x

	
	.(
	clc
	lda tmp0+0
	adc #32
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)
	
	.(		
	clc
	lda tmp1+0
	adc #40
	sta tmp1+0
	bcc skip
	inc tmp1+1
skip
	.)	

	.(		
	clc
	lda tmp2+0
	sbc #40
	sta tmp2+0
	lda tmp2+1
	sbc #0
	sta tmp2+1
skip
	.)	
	
	dex
	bne loop_y	
	
	rts
.)


NeighbourTable
	.byt 0,1,31,32,33,223,224,225,255		; Last value (backward) is the reference cell
			
_GOL_Evolve
	;jmp _GOL_Evolve_ASM
.(
	lda _ptr_buffer1+0
	sta __read_cell+1+0
	lda _ptr_buffer1+1
	sta __read_cell+1+1

	; Destination is automodified
	lda _ptr_buffer2+0
	sta __write_cell+1+0
	lda _ptr_buffer2+1
	sta __write_cell+1+1
	
loop_cell
	lda #0
	sta NeighbourCount
	
	ldy #0
	ldx #9
loop_neighbour
	clc
	lda __write_cell+1
	adc NeighbourTable-1,x
	tay
__read_cell	
	lda _GameOfLifeBuffer1,y
	.(
	beq skip
	inc NeighbourCount
skip
	.)	
	dex
	bne loop_neighbour
	
	; A contains the state of the center cell
	cmp #0
	bne cell_is_alive

cell_is_dead	
	; Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
	lda NeighbourCount
	cmp #3
	beq new_cell	
	lda #0
	jmp __write_cell
		
cell_is_alive
	; Any live cell with fewer than two live neighbours dies, as if caused by under-population.
	; Any live cell with two or three live neighbours lives on to the next generation.
	; Any live cell with more than three live neighbours dies, as if by overcrowding.
	lda NeighbourCount	; This one includes the alive cell itself, so need to add one when testing
	cmp #2+1
	beq new_cell	
	cmp #3+1
	beq new_cell		
	lda #0
	jmp __write_cell
	
new_cell
	lda #1
	
__write_cell
	sta _GameOfLifeBuffer2
	
	inc __write_cell+1
	bne loop_cell	
	
	rts
.)


BlueRasters
	.byt 16+0
	.byt 16+0
	.byt 16+0
		.byt 16+4
	.byt 16+0
	.byt 16+0
		.byt 16+4
		.byt 16+4
	.byt 16+0
		.byt 16+4
		.byt 16+4
		.byt 16+4
	.byt 16+6
		.byt 16+4
		.byt 16+4
	.byt 16+6
	.byt 16+6
		.byt 16+4
	.byt 16+6
	.byt 16+6
	.byt 16+6
		.byt 16+7
	.byt 16+6
	.byt 16+6
		.byt 16+7
		.byt 16+7
	.byt 16+6
		.byt 16+7
		.byt 16+7
		.byt 16+7
	.byt 16+6
		.byt 16+7
		.byt 16+7
	.byt 16+6		
	.byt 16+6		
		.byt 16+7
	.byt 16+6		
	.byt 16+6		
	.byt 16+6		
		.byt 16+4
	.byt 16+6		
	.byt 16+6		
		.byt 16+4
		.byt 16+4
	.byt 16+6		
		.byt 16+4
		.byt 16+4
		.byt 16+4
	.byt 16+0
		.byt 16+4
		.byt 16+4
	.byt 16+0
	.byt 16+0
		.byt 16+4
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0
	.byt 16+0

RedRasters
	.byt 5
	.byt 5
	.byt 5
		.byt 1
	.byt 5
	.byt 5
		.byt 1
		.byt 1
	.byt 5
		.byt 1
		.byt 1
		.byt 1
	.byt 3
		.byt 1
		.byt 1
	.byt 3
	.byt 3
		.byt 1
	.byt 3
	.byt 3
	.byt 3
		.byt 2
	.byt 3
	.byt 3
		.byt 2
		.byt 2
	.byt 3
		.byt 2
		.byt 2
		.byt 2
	.byt 3
		.byt 2
		.byt 2
	.byt 3		
	.byt 3		
		.byt 2
	.byt 3		
	.byt 3		
	.byt 3		
		.byt 1
	.byt 3		
	.byt 3		
		.byt 1
		.byt 1
	.byt 3		
		.byt 1
		.byt 1
		.byt 1
	.byt 5
		.byt 1
		.byt 1
	.byt 5
	.byt 5
		.byt 1
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	.byt 5
	
	
BlueRastersPos
	.byt 0
	
BlueRastersCurPos
	.byt 0
		
RedRastersPos
	.byt 0
	
RedRastersCurPos
	.byt 0
	
_GOL_Rasters
.(
	lda #<$a000+1+40*32
	sta tmp0+0
	lda #>$a000+1+40*32
	sta tmp0+1
	
	lda BlueRastersPos
	inc BlueRastersPos
	sta BlueRastersCurPos
	
	lda RedRastersPos
	dec RedRastersPos
	sta RedRastersCurPos
	
	ldx #64
loop
	inc BlueRastersCurPos
	lda BlueRastersCurPos
	and #63
	tay
	
	lda BlueRasters,y
	ldy #1
	sta (tmp0),y

	dec RedRastersCurPos
	lda RedRastersCurPos
	and #63
	tay
		
	lda RedRasters,y
	ldy #0
	sta (tmp0),y
	
	.(
	clc
	lda tmp0+0
	adc #40
	sta tmp0+0
	bcc skip
	inc tmp0+1
skip
	.)	
	
	dex
	bne loop
	rts		
.)



	.dsb 256-(*&255)
; These two arrays MUST be alligned on a page boundary
_GameOfLifeBuffer1	.dsb GOL_WIDTH*GOL_HEIGHT
_GameOfLifeBuffer2	.dsb GOL_WIDTH*GOL_HEIGHT

