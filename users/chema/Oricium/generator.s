;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Procedural generator

#include "params.h"


; Definition of constants
#define UPWINGROW 3
#define DOWNWINGROW 17
#define WINGHEIGHT 9

#define DO_INVERT 0

__generator_start

start_seed_r1	.word 21387
start_seed_r2	.word 12487
sav_seed 		.dsb 4
last_seed		.dsb 4
seed_r1 		.dsb 2
seed_r2 		.dsb 2

haswings		.byt 00	; Does the ship have wings?
lastwing		.byt 00	; Was the last generated part a wing?
lastlastwing	.byt 00 ; Was the second-to-last generated part a wing?
flag			.byt 00	; When 1 we are dealing with connected blocks
lastheight		.byt 00	; Last height
lastcol			.byt 00	; Last column
lastwidth		.byt 00	; Last width
lastpopulated	.byt 00 ; Has the last block been populated?
hasrunway		.byt 00	; Has a runway (other than in wings) been drawn?
col				.byt 00	; Current column
; Current block for population
pw					.byt 00
ph					.byt 00

height			.byt 00
width			.byt 00

; Used in populating pieces
.zero
todo .byt $00
hh .byt $00
.text

#define piece_w		tmp0
#define piece_h		tmp0+1
#define piece_col	tmp1
#define piece_row	tmp1+1

#define fill_r		tmp2
#define fill_c		tmp2+1
#define fill_rep	tmp3
#define fill_tile	tmp3+1
#define fill_tile1	tmp3+1
#define fill_tilei	tmp4
#define fill_tilee  tmp4+1
#define fill_tile2	tmp5


;;;;;;;;;;;;;;;;;;;;;;
; Routine to get the
; next element in the
; generating sequence
;;;;;;;;;;;;;;;;;;;;;;
waggle
.(
	clc
	lda seed_r1
	pha
	adc seed_r2
	sta seed_r1
	lda seed_r1+1
	pha
	adc seed_r2+1
	sta seed_r1+1
	pla
	sta seed_r2+1
	pla
	sta seed_r2
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear the current ship
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clear_ship
.(
	lda #>_start_rows
	sta smc_prow+2
	lda #0
	sta smc_prow+1

	lda #$20
	ldy #20
loop
	ldx #$0
loop2
smc_prow
	sta _start_rows,x
	inx
	bne loop2
	inc smc_prow+2
	dey
	bne loop
	rts
.)	


;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generates the boss!
;;;;;;;;;;;;;;;;;;;;;;;;;;;
generate_boss
.(
	; Area has already been cleared
	; Boss is 40x20
	lda#>_start_rows
	sta tmp1+1
	lda #BOSS_COL
	sta tmp1
	lda #<boss_map
	sta tmp2
	lda #>boss_map
	sta tmp2+1

	lda #20
	sta tmp
looprow	
	ldy #39
loopcol	
	lda (tmp2),y
	sta (tmp1),y
	dey
	bpl loopcol

	inc tmp1+1	
	lda #40
	clc
	adc tmp2
	bcc nocarry
	inc tmp2+1
nocarry	
	sta tmp2
	dec tmp
	bne looprow
	
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generates a new ship
;;;;;;;;;;;;;;;;;;;;;;;;;;;
generate_ship
.(
	; Clearing the ship has already been done
	;jsr clear_ship
	; Check for bonus modes
	
	lda boss_mode
	beq normallevel
	jmp generate_boss
	
normallevel	
	lda onslaught
	beq normal_mode
	rts
normal_mode	

	lda labyrinth_mode
	beq normalship
	jmp generate_labyrinth
normalship

	; Decide which set of decorations to use

	lda seed_r1
	bmi skipbchain
	jsr swap_bchain
skipbchain
	lda seed_r1
	asl
	bmi skipsschain
	jsr swap_schain
skipsschain	
	lda seed_r1
	lsr
	bcc skipschain
	jsr swap_mchain
skipschain	
	lda seed_r2
	bmi skipwind
	jsr swap_windows
skipwind	
	

	; Initialize variables
.(
	lda #0
	ldx #8
loop
	sta haswings,x
	dex
	bpl loop
.)
	lda #40
	sta col			; Current column

	inc lastpopulated

	; Loop creating parts
part_loop
	
	; Some initializations and generation of pseudo-random
	;lda #0
	;sta haswings

	jsr waggle
	jsr waggle

	; Create the heigtt of the new block
;height=bitand(round(r1/256),3)+1;
;height=bitshift(height,1)+1;

	lda seed_r1+1
	and #3
	clc
	adc #1
	sec
	rol
	sta height

	; If the height is the same as the previous block
	; separate both and signal it setting flag=0
;if(height==lastheight)
;    col=col+5;
;    flag=0;
;end

	cmp lastheight
	bne setwidth
	lda col
	clc
	adc #5
	sta col
	lda #0
	sta flag
setwidth
;width=bitand(r1,15)+3;
	lda seed_r1
	and #15
	clc
	adc #3
	sta width

	; If nearly at the end of the space, create a block to cover the remainings
	/*
    ;if (col+width)>256-30-10 
    ;    width=256-30-10-col;
    ;end
*/
.(
	clc
	adc col
	bcs popandend 
	cmp #255-30-10
	bcc proceed
	lda #255-30-10
	sec
	sbc col
	bmi popandend
	sta width
.)
proceed

	; If it is a very small block, we are finished with this part, 
	; populate the previous one and jump to end
;if (width<=2)
;    if lastpopulated==0
;        populate(lastcol,pw,ph);
;    end
;    break;
;end
	lda width
	cmp #2+1
	bcs proceed2

popandend
	; Populate the previous block
	lda lastpopulated
	bne endship
	jsr _populate
endship
	jmp finish

proceed2
	; Indicate if we created a wing
	;lastlastwing=lastwing;
	lda lastwing
	sta lastlastwing
    
	; Create a new block
	jsr waggle

	; Choose between creating a pair of
	; wings or a normal block
;if(bitand(r1,255)<30 && lastwing==0)
;    % Generate wings
;else
;    % Generate one piece
;end

	lda lastwing
	beq dowing
	jmp normalblock
dowing
	lda seed_r1+1
	cmp #30
	bcc dowing2
	jmp normalblock
dowing2	
	; Generate wings
	;haswings=1;
    ;col=col+4;flag=0;
	inc haswings
	clc
	lda #4
	adc col
	sta col
	lda #0
	sta flag

;h=bitand(height,1)+1;
;width=bitshift(width,1)+16;
;generate_piece(width,h,col,wr1);
;generate_piece(width,h,col,wr2);

	lsr height
	adc #1
	sta piece_h

	lda width
	asl
	adc #16
	sta tmp
	clc
	adc col
	bcs incorrect
	cmp #255-30
	bcc correct 
incorrect
	lda width
	clc
	adc #8
	sta tmp
correct
	lda tmp
	sta width

	sta piece_w
	lda col
	sta piece_col
	lda #UPWINGROW
	sta piece_row
	jsr generate_piece
	lda #DOWNWINGROW
	sta piece_row
	jsr generate_piece
		

;% Block to glue both
;cs=col+floor(width/2)-floor(width/8);
;ce=col+floor(width/2)+floor(width/8);
;for i=wr1+h-1:wr2-h
;    draw_tile(11,cs,i);
;    draw_tile(14,ce,i);
;    for j=cs+1:ce-1
;        draw_tile(13,j,i);
;    end
;end

	lda #UPWINGROW
	clc
	adc piece_h
	sta fill_r
	dec fill_r

	lda piece_h
	asl
	sta tmp
	lda #(DOWNWINGROW-UPWINGROW)
	sec
	sbc tmp
	tax
	inx
	inx
	stx savx+1
	
	lda piece_w
	lsr
	pha
	sta tmp
	lda piece_col
	clc
	adc tmp
	sta tmp
	pla
	lsr
	lsr
	sta tmp+1
	lda tmp
	sec
	sbc tmp+1
	sta fill_c
	sta savfillc+1

	lda piece_w
	lsr
	lsr
	ora #%1
	sta fill_rep
	sta savfillr+1

	jsr fill_area

;draw_tile(16,cs,wr1+h-1);
;draw_tile(15,ce,wr1+h-1);
;draw_tile(16,cs,wr2-h);
;draw_tile(15,ce,wr2-h);
	lda #16+$20
	ldy #0
	sta (tmp),y
	ldy fill_rep
	lda #15+$20
	sta (tmp),y
	lda tmp+1
	sec
savx
	sbc #00
	sta tmp+1
	inc tmp+1

	lda #16+$20
	ldy #0
	sta (tmp),y
	ldy fill_rep
	lda #15+$20
	sta (tmp),y
	
  
	;lastwing=1;
	inc lastwing
	jmp populate_block

normalblock
	; Generate a normal block
; if(lastwing==1)&&(height<6)
;        height=9;
; end
	lda lastwing
	beq skip1
	lda height
	cmp #6
	bcs skip1
	lda #9
	sta height
skip1
    ;generate_piece(width,height,col,10);
	lda col
	sta piece_col
	lda #10
	sta piece_row
	lda width
	sta piece_w

	lda height
	sta piece_h
	jsr generate_piece
    
	; Check if this piece is part of a bigger
	; block and repair their connection if that
	; is the case

;if(flag && lastwing==0)
;    repair_connection(col,lastheight,height);
;end
;lastwing=0;

	lda flag
	beq skip2
	lda lastwing
	bne skip2

	jsr repair_connection
skip2
	lda #0
	sta lastwing

populate_block

	; Populate this block with windows, etc.
	; The idea is accumulate parts for each block until
	; something forces us to stop, for instance a pair
	; of wings, a small part or a disconnection.
	; When something like that happens, call the routine
	; to add elements to the block we have accumulated.

	; If we just created a pair of wings, we have to populate
	; the previous block, if it has not yet been populated.
.(
	lda lastwing
	beq	 notwing

	; We have just created a pair of wings
	; Did we populate the previous block?
	lda lastpopulated
	bne skipp
	; We didn't, so do it
	jsr _populate
skipp
	; Populate the wings
	jsr _populatewing
	lda #0
	sta pw
	sta ph
done
	beq connect_blocks ; We're done
notwing
	; We have not just created a pair of wings
	; need to check if we need to populate the previous
	lda lastpopulated
	beq notpopulated
	; Unless it is too small, start accumulating
	lda height
	cmp #2
	bcs accumulate_start
toosmall
	; it is too small
	inc lastpopulated
	lda #0
	sta pw
	sta ph
	beq connect_blocks ; We're done
accumulate_start
	lda width
	sta pw
	lda height
	sta ph
	lda #0
	sta lastpopulated
	beq connect_blocks ; We're done
notpopulated
	; We created another block and the previous has not been
	; populated yet
;if (flag==0) || (abs(lastheight-height) > 2) 
	lda flag
	beq discon
	lda lastheight
	sec
	sbc height
	bpl positive
	sta tmp
	lda #0
	sec
	sbc tmp
positive
	cmp #2+1
	bcc nodiscon	
discon
	jsr _populate
	jmp accumulate_start
nodiscon
	; We have not disconnected (indicated by flag or difference
	; in height too high)
	; Check if this new block is tiny
	lda height
	cmp #2+1
	bcs accumulate
	; We cannot accumulate this, populate previous, mark this
	; as populated (to avoid doing it) and finish
	jsr _populate
	jmp toosmall
accumulate
	; Okay, accumulate this for later
	lda pw
	clc
	adc width
	sta pw
	lda ph
	cmp height
	bcc isok
	lda height
	sta ph
isok
	lda #0
	sta lastpopulated
.)	
	
connect_blocks

	; Connect two blocks with chains, etc..

; if (flag==0 && lastcol>0)
	; if this is the first block or flag is zero, do nothing
	lda lastcol
	bne true1
	jmp end_blocks
true1
	lda flag
	beq true2
	jmp end_blocks
true2
 
	; Decide wheter to put wingchains or not

; if (lastwing==1 && lastheight>(wr2-wr1)/2)|| (lastlastwing==1 && height>(wr2-wr1)/2)
	lda lastwing
	beq secondcheck
	; We have just put wings, but can we use wing chains?
	lda lastheight
	cmp #((DOWNWINGROW-UPWINGROW)/2)+1
	bcs candoit
secondcheck
	lda lastlastwing
	beq normalwings
	lda height
	cmp #((DOWNWINGROW-UPWINGROW)/2)+1
	bcc normalwings
candoit
	; Okay, we can put wingchains!		
;	 wingchains(lastcol+1,col-1);
	ldx lastcol
	inx
	stx fill_c
	lda col
	sec
	sbc lastcol
	sbc #2
	sta fill_rep
	jsr wingchains

	jmp end_blocks

; else
normalwings
	; We have to put normal chains, decide the type. First set params

;  if(lastlastwing==0)
;   if(lastheight<height)
;    h=lastheight;
;   else
;    h=height;
;   end
;  else
;   h=4;
;   lastcol=lastcol-round(lastwidth*3/8);
;  end
.(
	lda lastlastwing
	bne there
	lda lastheight
	cmp height
	bcc there2
	lda height
there2
	jmp contwing 
there
	lda lastwidth
	asl
	clc
	adc lastwidth
	lsr
	lsr
	lsr
	sta tmp
	lda lastcol
	sec
	sbc tmp
	sta lastcol
	lda #4
.)	 

contwing
	sta savh+1


;  [r1,r2]=fib(r1,r2);
	jsr waggle

	; Set size
;  c1=lastcol+1;c2=col-1;
	ldx lastcol
	inx
	stx fill_c

	ldx col
	dex
	stx tmp

;  if(lastwing==1) c2=cs-1; end
	lda lastwing
	beq false1
savfillc
	ldx #0
	dex
	stx tmp
false1

;  if(lastlastwing==1) c1=ce+1; end
	lda lastlastwing
	beq false2
savfillr
	lda #0
	sec
	adc savfillc+1
	sta fill_c

false2
	lda tmp
	sec
	sbc fill_c
	sta fill_rep

                
;  if(bitand(r1,255)>100 || h<8)
;     bigchain(c1,c2,h)
;  else
;     smallchain(c1,c2);
;  end
; end
;end

	;lda seed_r1
	;cmp #100	
	;bcs nosmall
	lda savh+1
	cmp #8
	bcc nosmall
	jsr smallchain
	jmp end_blocks
nosmall
	jsr bigchain

	; Done with chains... at last!

end_blocks
	; Finished, update the column
	;lastcol=col+width;  
	lda col
	clc
	adc width
	sta lastcol
	
	; Randomly separate blocks
	;jsr waggle
	;jsr waggle

;if (bitand(r2,255)<50 || lastwing==1)
;    col=col+width+floor(bitand(r2,7)/2)*4+3;
;    flag=0;
;else
;    col=col+width;
;    flag=1;
;end

	lda lastwing
	bne doit
    lda seed_r2+1
	cmp #50
	bcs doother
doit
	lda #0
	sta flag

	lda seed_r2
	and #7-4
	asl
	adc #3
	clc
	adc width
	bcc skipend ; jumps always
doother
	inc flag
	lda width
	clc
skipend
	adc col
	sta col

    ; Save last height and width
    ;lastheight=height; lastwidth=width;
	lda height
	sta lastheight
	lda width
	sta lastwidth

	; Go to next part
	jmp part_loop

finish
	jsr place_switches
.(
	; Put energy balls around
	lda #0
	sta tmp
	lda #17
	clc
	adc #>_start_rows
	sta tmp+1
	; External loop
	ldx #7
loopr
	ldy #$ff
loopc
	; Get tile
	lda (tmp),y
	cmp #13+$20
	bne skipthis
	jsr waggle
	cmp #10
	bcs skipthis
	; Set an energy ball here
	lda #ENERGYBALL_TILE+$20
	sta (tmp),y
skipthis
	dey
	bne loopc	; Column 0 is always space
	
	; Change row
	dec tmp+1
	dec tmp+1
	
	dex
	bne loopr	; 9 rows to check (only odd rows from 19 to 1)
.)	
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generate chains connecting wings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wingchains
.(
	; Wing chains are one strip
	; with altenating tiles 26 and 27
	; and a first one 25
	lda #25+$20
	sta fill_tilee
	lda #26+$20
	sta fill_tile1
	lda #27+$20
	sta fill_tile2
	lda #0	; No ending tile
	sta fill_tilei

	; put at the position of each
	; wing

	lda #UPWINGROW-1
	sta fill_r
	jsr fill_with_tile2
	lda #DOWNWINGROW-1
	sta fill_r
	jmp fill_with_tile2
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generate one big chain
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bigchain
.(
	; Big chains are two strips with 
	; alternating tiles 21 and 22
	; and a first one 20
	lda #20+$20
	sta fill_tilee
	lda #21+$20
	sta fill_tile1
	lda #22+$20
	sta fill_tile2
	lda #0	; No ending tile
	sta fill_tilei
	
	; which are set on rows 9 and 10
	lda #9
	sta fill_r
	jsr fill_with_tile2
	inc fill_r
	jsr fill_with_tile2

	; And if there is enough height,
	; add two small chains at both sides
+savh
	lda #0
	cmp #5
	bcs doit
	rts
doit
    ; These small chains start with thile
	; 23 and are composed of tiles 24

	lda #23+$20
	sta fill_tilee
	lda #24+$20
	sta fill_tile1
	sta fill_tile2
	lda #0	; No ending tile
	sta fill_tilei	

	; which are set on rows 7 and 12
	lda #7
	sta fill_r
	jsr fill_with_tile2
	lda #12
	sta fill_r
	jmp fill_with_tile2
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generate small chains
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
smallchain
.(
	; Small chains are, in fact, quite big
	; They are composed of several strips:
	; alternating tiles 26 and 27 and a first one 25
	; for rows 7 and 13
	; and tiles 24 with a first one of 23
	; for rows 5, 9, 11 and 15

	lda #25+$20
	sta fill_tilee
	lda #26+$20
	sta fill_tile1
	lda #27+$20
	sta fill_tile2
	lda #0	; No ending tile
	sta fill_tilei
	
	; which are set on rows 7, 11 and 13
	lda #7
	sta fill_r
	jsr fill_with_tile2

	lda #13
	sta fill_r
	jsr fill_with_tile2

	lda #23+$20
	sta fill_tilee
	lda #24+$20
	sta fill_tile
	
	; which are set on rows 5, 9 and 15
	lda #5
	sta fill_r
	jsr fill_with_tile
	lda #9
	sta fill_r
	jsr fill_with_tile
	lda #11
	sta fill_r
	jsr fill_with_tile
	lda #15
	sta fill_r
	jmp fill_with_tile
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generate a new piece for the
; spaceship
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
generate_piece
.(
	; Start drawing a block of background

	;for c=col+1:width+col-1
	;    for r=row-height:row+height-1
	;        draw_tile(13,c,r);
	;    end
	;end


	lda piece_row
	sec
	sbc piece_h
	sta fill_r

	lda piece_h
	asl
	sec
	sbc #1
	tax
	
	ldy piece_col
	;iny
	sty fill_c
	ldy piece_w
	;dey
	sty fill_rep
	jsr fill_area

	; Set the upper and lower borders
;for i=1:width-1
;   draw_tile(6,col+i,row-height);
;   draw_tile(6,col+i,row+(height-1));
;end
		
	lda #6+$20
	sta fill_tile
	sta fill_tilei
	sta fill_tilee

	lda piece_row
	sec
	sbc piece_h
	sta fill_r
	ldx piece_col
	inx
	stx fill_c
	ldx width
	dex
	stx fill_rep
	jsr fill_with_tile

	lda piece_row
	clc
	adc piece_h
	sec
	sbc #1
	sta fill_r
	jsr fill_with_tile

	; This is to set left/right borders, but it has
	; already been done...
;for i=row-(height):row+(height-1)
;    draw_tile(11,col,i);
;    draw_tile(14,col+width,i);
;end


	; Randomly select angeled or squared ends for 
	; the left side
;if bitand(r1,256)&&width>4
;	% Angeled
;	for i=0:3
;		 draw_tile(2+i,col+i,row-height);
;		draw_tile(2+i,col+i,row+height-1);
;	end


	; This is for both
	lda piece_row
	clc
	adc #>_start_rows
	sec
	sbc piece_h
	sta tmp2+1
	lda piece_row
	clc
	adc #>_start_rows
	adc piece_h
	sta tmp3+1
	dec tmp3+1
	lda piece_col
	sta tmp2
	sta tmp3

	lda seed_r1+1
	and #1
	beq squared1
	lda width
	cmp #4
	bcc squared1

	; Angeled corners, put the
	; correct tiles
	ldy #3
	lda #5+$20
.(
loop
	sta (tmp2),y
	sta (tmp3),y
	sec
	sbc #1
	dey
	bpl loop
.)

;	draw_tile(12,col,row-(height-1));
;	draw_tile(11,col,row+(height-2));
;	flag=1;
	lda piece_row
	sec
	adc #>_start_rows
	sec
	sbc piece_h
	sta tmp+1
	lda #0
	sta tmp
	ldy piece_col
	lda #12+$20
	sta (tmp),y
	
	/*
	lda piece_row
	adc #>_start_rows
	clc
	adc piece_h
	sec
	sbc #2
	sta tmp+1
	lda #11+$20
	sta (tmp),y
	*/
	inc smc_flag+1

	bne nextpart ; jumps always

squared1
	; Squared borders
;else
;	% Squared
;	draw_tile(18,col,row-height);
;	draw_tile(18,col,row+height-1);
;	flag=0;
;end

	ldy #0
	lda #18+$20
	sta (tmp2),y
	sta (tmp3),y

	lda #0
	sta smc_flag+1

nextpart
	; Now do the same for the right side

;if bitand(r1,512)&& ((width>8) || (width>4 && flag==0))
smc_flag
	lda #0
	bne compnext
	lda piece_w
	cmp #5
	bcs angeled2
	bcc squared2
compnext
	lda piece_w
	cmp #8
	bcc squared2
	lda seed_r1+1
	and #%10
	beq squared2
angeled2
;	% Angeled
;	for i=0:3
;       draw_tile(7+i,col+width+i-3,row-height);
;		draw_tile(7+i,col+width+i-3,row+height-1);
;	end

	ldy piece_w
	;dey
	ldx #3
	lda #10+$20
.(
loop
	sta (tmp2),y
	sta (tmp3),y
	sec
	sbc #1
	dey
	dex
	bpl loop
.)

;	draw_tile(17,col+width,row-(height-1));
;	draw_tile(12,col+width-1,row+(height-2));
;	draw_tile(17,col+width,row+(height-2));

	lda piece_row
	sec
	adc #>_start_rows
	sec
	sbc piece_h
	sta tmp+1
	lda #0
	sta tmp
	lda piece_col
	clc
	adc piece_w
	tay
	;dey
	lda #17+$20
	sta (tmp),y

	lda piece_row
	adc #>_start_rows
	;clc
	adc piece_h
	sec
	sbc #2
	sta tmp+1
	lda #17+$20
	sta (tmp),y

	dey
	lda #12+$20
	sta (tmp),y

	bne end ; Jumps always
squared2
;else
;    % Squared
;    draw_tile(19,col+width,row-height);
;    draw_tile(19,col+width,row+height-1);
;end
	ldy piece_w
	;dey
	lda #19+$20
	sta(tmp2),y
	sta(tmp3),y
end
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Repairs a connection between
; pieces of the same block
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
repair_connection
.(
	; Determine the smallest height
	; and draw the corner tiles
;if lastheight>height
;    h=height;
;    draw_tile(15,col,10-h);
;    draw_tile(15,col,10+h-1);
;else
;    h=lastheight;
;    draw_tile(16,col,10-h);
;    draw_tile(16,col,10+h-1);
;end

	lda height
	cmp lastheight
	bcc option2
	lda lastheight
option2
	php
	sta tmp
	lda #10
	sec
	sbc tmp
	clc
	adc #>_start_rows
	sta tmp1+1
	lda #0
	sta tmp1
	sta tmp2
	lda #10
	clc
	adc tmp
	sbc #0
	clc
	adc #>_start_rows
	sta tmp2+1
	plp
	lda #15+$20
	adc #0
	ldy col
	;dey
	sta (tmp1),y
	sta (tmp2),y
	;h=h-1;
	inc tmp1+1
	dec tmp2+1

	; Fill the connection with background
	; pattern
;for i=10-h:10+h-1
;    draw_tile(13,col,i);
;    draw_tile(13,col-1,i);
;end
.(
	lda tmp2+1
	sec
	sbc tmp1+1
	tax
	lda #13+$20
loop
	ldy col
	sta (tmp1),y
	dey
	sta (tmp1),y
	inc tmp1+1
	dex
	bpl loop
.)

	; Done
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;
; Fills an area with a
; set of tiles 
; Reg x=number of rows
;;;;;;;;;;;;;;;;;;;;;;;;
fill_area
.(
	lda #13+$20
	sta fill_tile
	lda #14+$20
	sta fill_tilei
	lda #11+$20
	sta fill_tilee
+fill_area_ex
.(
loop
	jsr fill_with_tile
	inc fill_r
	dex
	bne loop
.)
end
	rts
.)

fill_area2
.(
loop
	jsr fill_with_tile2
	inc fill_r
	dex
	bne loop
end
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fills a range of columns
; with a tile strip with
; this structure:
; fill_tilee fill_tile ... fill_tile fill_tilei
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fill_with_tile
	lda fill_tile
	sta fill_tile2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fills a range of columns
; with a tile strip with
; this structure:
; fill_tilee fill_tile1 fill_tile2 ... fill_tile2 fill_tilei
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fill_with_tile2
.(
	lda fill_r
	clc
	adc #>_start_rows
	sta tmp+1
	lda fill_c
	sta tmp
	
	ldy #0
	lda (tmp),y
	cmp #28+$20
	beq loop
	cmp #29+$20
	beq loop	
	lda fill_tilee
	beq loop
	sta (tmp),y
loop
	iny
	lda (tmp),y
	cmp #28+$20
	beq end
	cmp #29+$20
	beq end
	lda fill_tile1
	sta (tmp),y
	cpy fill_rep
	beq end

	iny
	lda (tmp),y
	cmp #28+$20
	beq end
	cmp #29+$20
	beq end	
	lda fill_tile2
	sta (tmp),y
	cpy fill_rep
	bne loop

end
	lda (tmp),y
	cmp #28+$20
	beq end2
	cmp #29+$20
	beq end2
	lda fill_tilei
	beq end2
	sta (tmp),y
end2
	rts

.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Populates a pair of wings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_populatewing
.(
	; Create a runway
	ldy piece_col
	iny
	iny
	sty fill_c
	lda piece_w
	sec
	sbc #5
	sta fill_rep
	lda #UPWINGROW-1
	sta fill_r
	jsr put_runway
	lda #DOWNWINGROW-1
	sta fill_r
	jmp put_runway
.)

put_runway
.(
	lda #0
	sta fill_tilei
	sta fill_tilee
	lda #36+$20
	sta fill_tile
	jsr fill_with_tile
	inc fill_r
	jsr fill_with_tile
    dec fill_r

	; Put some ships on the runway, if it is long enough
	lda fill_rep
	cmp #18-6
	bcc noroom

	pha
	lda tmp1
	pha
	
	lda fill_c
	clc
	adc fill_rep
	sta tmp1
	dec tmp1
	dec tmp1

	lda fill_c
	pha
	; Start the loop
	lda fill_c
	clc
	adc #4
	sta fill_c
	ldx #39+$20
loop
	jsr put_squared_object

	lda fill_c
	clc
	adc #7
	sta fill_c
	cmp tmp1
	bcc loop

	; Get column, tmp1 and rep back, as we have destroyed them
	pla
	sta fill_c
	pla
	sta tmp1
	pla
	sta fill_rep
noroom
	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Populates a block
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_populate
.(
	; Prepare params for filling
	; that is fill_c, fill_r, fill_rep
	; and the number of rows in reg X
	lda lastcol
	sec
	sbc pw
	clc
	adc #2
	sta fill_c
	lda pw
	sec
	sbc #4
	bpl ok
	rts
ok
	sta todo 
	lda #10
	sec
	sbc ph
	clc
	adc #1
	
; CHECK
;	cmp #21
;	bcc contin
;dbug	
;	lda #0
;	beq dbug
;contin	
	sta fill_r
	lda ph
	asl
	sec
	sbc #2
	sta hh
	
	; If there is height enough, create three different areas
	lda hh
	cmp #12
	bcs areas
	; there is not, so simply call populate_segment
	jmp populate_segment
areas
	; there is, so divide it in three parts
	lsr 
	lsr
	sta hh
    
 .(
    ldx #3
loop
    lda seed_r1,x
    sta sav_seed,x
    dex
    bpl loop
.)
	jsr populate_segment
	asl hh
	jsr populate_segment
	lsr hh
.(
    ldx #3
loop
    lda sav_seed,x
    sta seed_r1,x
    dex
    bpl loop
.)

	;jmp populate_segment
.)

populate_segment
.(
	lda fill_c
	pha
	lda todo
	pha

	; Divide the segment in pieces
	; along its lenght randomly

	lda fill_r
	sta sav_fr+1

loop
	lda todo
	bmi end
	cmp #1 ; this sets ornaments up to 3 tiles wide
	bcc end

sav_fr
	lda #0
	sta fill_r

	jsr waggle
	lda seed_r2
	and #15
	ora #4
	cmp todo
	bcc isok
	lda todo
isok
	sta fill_rep		

	lda todo
	clc ; This is intentional
	sbc fill_rep
	sta todo
	
	ldx hh
	jsr populate_piece

	lda fill_c
	sec ; This is intentional
	adc fill_rep
	sta fill_c

	jmp loop
end
	pla
	sta todo
	pla
	sta fill_c
	rts
.)

populate_piece
.(
    ; Test if we can put a runway here...
	jsr waggle

	; Load A with the horizontal size here,
	; so we can cmp later on if no runway	
	lda fill_rep	
	
	ldy hasrunway
	bne norunway
    
    cmp #14
    bcc norunway
	cpx #4
	bcc norunway
	
	stx savxb+1
	inc hasrunway
	lda fill_r
	pha
    ;and #$fe
	ora #1
    sta fill_r

	; Make the runway shorter
	dec fill_rep
	
	; Put some lights through it
	lda #0
	sta fill_tilee
	lda #37+$20
	sta fill_tilei
	sta fill_tile
	jsr fill_with_tile
	inc fill_r

	; Draw the runway
    jsr put_runway
	pla
	sta fill_r
	
	; Put the fill_rep value back
	inc fill_rep
savxb
	ldx #0
    jmp finish 
norunway	
	; Let's draw some ornaments
/*	
	; Is there enough room to fit a diamond thing?
	cmp #9
	bcc nodiamond
	lda seed_r1
	lsr
	bcc nodiamond
	;jmp populate_diamond
nodiamond	
*/
	; If small area, then small object
	cmp #6
	bcs nosmall
	
	; Randomly draw small objects
	jsr waggle
    lda seed_r1
    ;cmp #128
    ;bcc sq_object
	bpl sq_object

nosmall	
	; Some random combined with level will
	; decide if we are to draw barriers
	; Ignore sign bit, as has been used
	; for other matters
	; If level = 1 no barriers
	
	lda level
	cmp #2
	bcc nobarrier
	lda seed_r1
	and #%01111111
	cmp #90
	bcs nobarrier
	
	; Check if it is possible to draw a barrier here
	lda fill_r
	and #%1
	bne nobarrier
	cpx #4
	bcc nobarrier
	lda fill_rep
	cmp #4
	bcc nobarrier
	
	; Okay let's draw a barrier!
	jmp populate_barrier

nobarrier	
	; No barrier and no small object,
	; draw holes, grids, windows, etc
	jmp populate_holegrid

    
+sq_object
	; Select and put a squared 2x2 piece
	; Only if there is enough space
    lda fill_rep
    cmp #2
    bcc finish
    cpx #4
    bcc finish

	; Save contents of reg X (number of rows)
    stx savx+1
	; Prepare everything
	ldx #37+$20
	lda seed_r2
	bmi skip
    ldx #41+$20
skip	
	; Need to adjust starting row to odd/even
    lda fill_r
	pha
	cmp #6
	bcc noaddone
	;clc This is intentional!
	adc #1
noaddone
    and #$fe
    sta fill_r
	
	; Let's draw it!
    jsr put_squared_object
	
	; Get back the value of reg X
	; and the value of row
savx
    ldx #0
	pla
	sta fill_r
+finish
	; Finish adding the number of rows drawn, 
	; so the routine can continue
	txa
	clc
	adc fill_r
	sta fill_r
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw a diamond thing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
populate_diamond
.(
	rts
.)


; Subroutine to save some memory
common_barrier1
.(
	ldx #BARRIER_START+2+DO_INVERT
	stx fill_tilee
	inx 
	stx fill_tile1
	;inx 
	ldx #BARRIER_START+4
	stx fill_tile2
	inx 
	stx fill_tilei
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws a barrier
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
populate_barrier
.(

	; Let's decide between vertical or horizontal
	jsr waggle
	bcc vertical_barrier
	lda fill_rep
	cmp #5
	bcc vertical_barrier

	; Set an horizontal barrier

	ldx #BARRIER_START+2+DO_INVERT
	stx fill_tilee
	inx
	stx fill_tile
	;inx
	ldx #BARRIER_START+4
	stx fill_tilei
	
	dec fill_rep
	dec fill_rep
	dec fill_rep
	
	jsr fill_with_tile
	iny
	
	
	lda #BARRIER_START+5
	sta (tmp),y

	inc tmp+1
	ldy #0
	lda #BARRIER_START+2
	sta (tmp),y
	
	inc fill_c
	ldx #BARRIER_START+3
	stx fill_tilee
	ldx #1+$20
	stx fill_tile
	stx fill_tilei
	inc fill_r
	jsr fill_with_tile
	
	inc fill_r
	
	inc fill_rep
	inc fill_rep
	inc fill_rep
	
	dec fill_c
	rts
	
vertical_barrier
	; Set a vertical barrier
	jsr common_barrier1

	; First row
	lda fill_rep
	pha
	lda #3
	sta fill_rep
	jsr fill_with_tile2

	; Second & subsequent rows
	inc fill_r
	ldx #BARRIER_START+DO_INVERT
	stx	fill_tilee
	inx
	stx	fill_tile1
	ldx #1+$20
	stx	fill_tile2
	stx fill_tilei

	; Calculate the heigth of the barrier
	ldx hh
	dex
	dex
	jsr fill_area2

	; Last row
	jsr common_barrier1
	
	ldx #BARRIER_START+2
	stx fill_tilee
	inx
	stx fill_tile1
	
	ldx #1+$20
	stx	fill_tile2
	stx fill_tilei
	lda #3
	sta fill_rep
	jsr fill_with_tile2	

	; Set back the value of the variables
	; so the routine may continue
	inc fill_r
	pla
	sta fill_rep
	rts
.)

; A subroutine to save some memory
phg_helper
.(
	lda (tmp6),y
	sta	fill_tilee
	iny
	lda (tmp6),y
	sta	fill_tile1
	iny
	lda (tmp6),y
	sta	fill_tile2
	iny
	lda (tmp6),y
	sta	fill_tilei

	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws a hole, grid, windows, etc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
populate_holegrid
.(
	; Decide the type (using the tables)
	jsr waggle
	lda seed_r1
	and #%11
	tay
	lda pop_table_lo,y
	sta tmp6
	lda pop_table_hi,y
	sta tmp6+1

	; save these for later...
	stx res_x+1
	lda fill_r
	sta res_a+1

	; Check aligment for this ornament
	lda pop_align,y
	bmi aligned
	eor fill_r
	and #%1
	bne aligned
	inc fill_r
	dex
aligned
	lda pop_align2,y
	beq nomore
	txa
	and #$fe
	cmp #3
	bcs cont
nosuccess
res_x
	ldx #0
res_a
	lda #0
	sta fill_r
catch2	
	jmp	finish
cont
	tax
nomore
	; Save register X
	stx savx+1

	; Update number of repetitions
	lda fill_rep
	sta savrep+1
	and #$fe
	beq nosuccess

	sta fill_rep

	; Proceed to draw
	ldy #0
	jsr phg_helper
	jsr fill_with_tile2
	
	; Get back the value of X and
	; update it
savx
	ldx #0
	dex
	dex

	; Draw the rest
	ldy #4
	inc fill_r
	jsr phg_helper
	jsr fill_area2

	ldy #0
	jsr phg_helper
	jsr fill_with_tile2

	; Done, update row and column
	; and what is left to be done
	inc fill_r
	inc fill_c
	dec todo
	 
	; Get old value of repetitions back and
	; return
savrep
	lda #0
	sta fill_rep
	rts
.)

pop_table_lo
	.byt <pop_hole_data, <pop_grid_data, <pop_cosa_data, <pop_window_data
pop_table_hi
	.byt >pop_hole_data, >pop_grid_data, >pop_cosa_data, >pop_window_data
pop_align
	.byt 1,1,$ff,0
pop_align2
	.byt 1,1,0,1

pop_hole_data
 .byt 15+$20, 6+$20, 6+$20, 16+$20
 .byt 14+$20, 0+$20, 0+$20, 11+$20
 
pop_grid_data
 .byt 30+$20, 31+$20, 31+$20, 32+$20
 .byt 33+$20, 34+$20, 34+$20, 35+$20

pop_cosa_data
 .byt 38+$20, 38+$20, 38+$20, 38+$20
 .byt 38+$20, 38+$20, 38+$20, 38+$20

pop_window_data
 .byt 0, 28+$20, 29+$20, 0
 .byt 0, 28+$20, 29+$20, 0


 


;;;;;;;;;;;;;;;;;;;;;;;;;;
; Puts a squared object in
; the tile map. The object
; must use tiles x,x+1 in
; both rows, so the base
; tile is passed in reg X.
; Column and row to use 
; (upper-left corner) is
; specified in fill_r and 
; fill_c
;;;;;;;;;;;;;;;;;;;;;;;;;;;
put_squared_object
.(
	lda #0
	sta fill_tilei
	sta fill_tilee

    lda #2
    sta fill_rep

	stx fill_tile1
	inx
	stx fill_tile2
    dex
	jsr fill_with_tile2
	inc fill_r
	jsr fill_with_tile2
	dec fill_r
    rts
.)


place_switches
.(
	ldx #15
	lda #0
loop
	sta sw_pos_r,x
	dex
	bpl loop
	
	sta sw_num

	; Put the switches
	lda #0
	sta tmp1
	lda #17-1
	clc
	adc #>_start_rows
	sta tmp1+1
	; External loop
	ldx #7
loopr
	ldy #$ff
loopc
	; Check for free space
	jsr check_space
	bcc skipthis
	stx savxb+1
	sty savyb+1
	
	; Set a switch here
	inx
	txa
	asl
	ldx sw_num
	cpx #16
	bcc doalways
	sta sava+1
	jsr waggle
	cmp #200 
	bcc skip2
	and #%1111
	tax
sava
	lda #0
	dec sw_num
doalways
	sta sw_pos_r,x
	dey
	tya
	sta sw_pos_c,x
	inc sw_num
skip2	
savxb
	ldx #0
savyb
	ldy #0
skipthis
	dey
	dey
	dey
	bne loopc	; Column 0 is always space
	
	; Change row
	dec tmp1+1
	dec tmp1+1
	
	dex
	bne loopr	; 9 rows to check 
checkme	
	; Select where to place them. Only 4
	lda #3
	sta count

	
	; TODO: Remove this check
	lda sw_num
	cmp #4
	bcs isok
	lda #0
stop beq stop

isok
	jsr waggle
	and #%1111
loop_places
	cmp sw_num
	bcc found
	lsr
	jmp loop_places
found	
	tax
	lda sw_pos_r,x
	beq isok
	ldy count
	sta fill_r
	sta switch_rows,y
	lda sw_pos_c,x
	sta fill_c
	sta switch_cols,y
	lda #0
	sta sw_pos_r,x
	sta switch_state,y
	ldx #BASE_SWITCH
	jsr put_squared_object
	dec count
	bpl isok
	
	rts
.)	

count .byt 0

check_space
.(
	lda tmp1
	sta tmp
	lda tmp1+1
	sta tmp+1
	sty savy+1

	dey
	lda (tmp),y
	cmp #13+$20
	bne end
	iny
	lda (tmp),y
	cmp #13+$20
	bne end
	iny
	lda (tmp),y
	cmp #13+$20
	bne end
	
	inc tmp+1
	
	lda (tmp),y
	cmp #13+$20
	bne end
	dey
	lda (tmp),y
	cmp #13+$20
	bne end
	dey
	lda (tmp),y
	cmp #13+$20
	bne end

	sec
	bcs end2
end
	clc
end2	
savy
	ldy #0
	rts
.)

sw_pos_r .dsb 16
sw_pos_c .dsb 16
sw_num	.byt 00	

__generator_ends
#print (__generator_ends-__generator_start)

#define lab_row lastcol
#define lab_col col
#define npaths lastwing
#define deadend haswings

#define LAB_COL_START 40
#define LAB_COL_END (255-20)
generate_labyrinth
.(
	; Some initializations
	lda #>_start_rows
	sta tmp+1
	lda #0
	sta tmp
	sta flag

	; Empty the play area
	ldx #20
loop
	lda #BARRIER_START+1
	ldy #LAB_COL_END
loop2
	sta (tmp),y
	dey
	cpy #LAB_COL_START
	bne loop2
	lda #BARRIER_START
	sta (tmp),y
	inc tmp+1
	dex
	bne loop

	; Choose the number of paths to take
	lda seed_r1+1
	lsr
	lsr
	and #%11
	clc
	adc #2
	sta npaths
new_path
	; Add a new path 
	; Check if this is going to be a dead end
	jsr waggle
	lda seed_r2
	cmp #$60
	bcc nodeadend
	;lda #1
	.byt $2c
nodeadend	
	lda #0
	sta deadend
	
	; Create the path
new_path2	
	; Set starting column
	lda #LAB_COL_START
	sta lab_col
	
	; Decrement number of paths made
	dec npaths
	
	; Choose starting row for this path
	jsr waggle
	lda seed_r1
	lsr
	lsr
	and #%1111
	clc
	adc #1	; Between 1 and 16
	sta lab_row

loop_path
	; Choose where to put the dead end if any
	lda deadend
	beq nodeadend2

	lda lab_col
	cmp deadend
	bcs stopthis
	
nodeadend2	
	; Blank this square
	jsr blank_position

	; Choose next square to blank
	jsr waggle
	lda seed_r1
	cmp #$a0
	bcc advance
	lsr
	lsr
	lsr
	bcc up
	; Go down, if possible
	lda lab_row
	cmp #19-4
	beq advance;up
down	
	inc lab_row
	bne loop_path	; always jumps
up
	; Go up if possible
	lda lab_row
	cmp #1
	beq advance;down
	dec lab_row
	bne loop_path	; always jumps
advance
	inc lab_col
	lda lab_col
	cmp #LAB_COL_END
	bcc loop_path
	inc flag

stopthis	
	; Path finished, another one?
	jsr waggle
	jsr waggle

	lda npaths
	bpl new_path

	; If no path had an exit, make another one
	lda flag
	bne done 
	inc npaths
	jmp new_path

done	
	rts
.)

blank_position
.(
	lda lab_row
	sta fill_r
	
	; META Adapt this, so it goes backwards every other path
	;lda lab_col

	lda npaths
	lsr
	bcs odd
	lda #$ff
	sec
	sbc lab_col
	sbc #LAB_COL_END
	clc
	adc #LAB_COL_START-1
	jmp do
odd	
	lda lab_col
do	
	sta fill_c	
	ldx #3
	stx fill_rep
	lda #$20
	sta fill_tilei
	sta fill_tilee
	sta fill_tile
	jmp fill_area_ex
.)