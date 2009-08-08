;Stepping Stones - For SSCM-OM2S4.S

;As Lucien steps from right or left, a short stone path rises from the bog.
;Stepping on each stone triggers new stones to rise and some existing ones to fall.
;Lucien must navigate the stones by walking adjacent stones, standing jump to further
;stones and running jumps to farthest stones. As the path gradually reveals itself
;objects rise from the surface that can be collected.
;Objects include..
;Old Clay Pipe - Only if Pergas Pipe subgame is active
;Old Briar - Available at any time but only once
;Grotes - Available at any time

;012345678901234567890123456789012345678
;A standing jump will reach 8 bytes
; -       -
;Tiles are 2x? and span 18 tiles wide and begin a little way in from each side
; __--__--__--__--__--__--__--__--__--
;The hero may perform a standing jump across 4 tiles.
;  |        |
; __--__--__--__--__--__--__--__--__--

;The pattern differs depending on which side the hero approaches the mire from.

;Approach from right and 3 stones far right will rise
;                                      |
;                               --__--

;Stepping on furthest will raise another but the distance will be too far to traverse.
;                                    |
;             --                --__--

;Stepping on next will fall previous but raise two more
;                                  |
;    --                       __--__--

;Infact what we could do is just allow the hero to traverse the whole width in either direction
;but only when the hero performs a standing jump to an odd stone does the pattern change.

;B0-3 Platform Index(0-15) that triggers this event
;B4-6 Stage through the maze that this is appropriate to
;B7   1
;
;B0-3 Next Platform to toggle
;B4   -
;B5   -
;B6   Raise Stage(1) (Stages are raised when the same platform indexes are repeated in a sequence)
;     (Raising the stage will take effect for the next set, not the current)
;B7   0
;012345678901234567890123456789012345678
;   0  1  2  3  4  5  6  7  8  9  A  
;   ---___---___---___---___---___---
;   | SJUMP  |

	
ProcessPlinths
.(
	;Is hero airbourne?
;	ldx HeroAction
	
;	?lda HeroAnimationProperty,x

;	and #%01000000

;	beq skip1	;Hero is airbourne
	
	;Hero grounded, so calculate position of foot	
	lda HeroX
	clc
	adc #2
	tax
	lda Foot2PlinthIndex,x
	bmi skip1	;Hero is too far left or right of plinth range
	;Don't process plinths if heroes Xpos has not changed since last time
	cmp PreviousFoot2PlinthIndex
	beq skip1
	sta PreviousFoot2PlinthIndex
	sta temp01
	
;kli1	nop
;	jmp kli1

	ldx #10
	lda #00
loop3	sta PlinthDone,x
	dex
	bpl loop3

	;Locate Plinth pattern for hero's position and current stage
	ldy #255
loop1	iny
	lda PlinthPatterns,y
	
	; Loop back if not header (Hero Plinth)
	bpl loop1
	
	; Check Plinth
	and #15
	cmp temp01
	bne loop1
	
	; Check stage
	lda PlinthPatterns,y
	lsr
	lsr
	lsr
	lsr
	and #7
	cmp CurrentStage
	bne loop1

loop2	;Found correct plinth and stage for hero
	iny
	lda PlinthPatterns,y
	
	; Jump out if no more plinths to change
	bmi skip4
	
	asl
	bpl skip3
	; Raise stage
	inc CurrentStage
skip3	lsr
	and #15
	tax
	lda PlinthDone,x
	bne loop2
	lda PlinthStatii,x
	eor #128
	sta PlinthStatii,x
	inc PlinthDone,x
	jmp loop2

skip1	;Hero is airbourne - don't change plinths
	rts

skip4	;We now know which plinths need to be present and which do not
.)
	;B0-5 -
	;B6   Current Plinth Level
	;B7   Required Plinth Level
	
	; For now just plot/delete plinths, worry about anim later
	ldx #10
.(
loop1	lda PlinthScreenLo,x
	sta screen
	lda PlinthScreenHi,x
	sta screen+1
	
	lda PlinthStatii,x
	bmi RaisePlinth
DropPlinth
	; Delete first row
	ldy #01
	lda #64
	sta (screen),y
	dey
	sta (screen),y
	
	; Remove inverse of next two rows
	ldy #40
	jsr PlinthRemoveInverse
	iny
	jsr PlinthRemoveInverse
	ldy #80
	jsr PlinthRemoveInverse
	iny
	jsr PlinthRemoveInverse

	;Mark Floor Table(Hurt)
;	?
	
	jmp skip1
RaisePlinth
	; Plot First Row
	ldy #00
	lda #%01011111
	sta (screen),y
	iny
	lda #%01111110
	sta (screen),y
	
	; Inverse next two rows
	ldy #40
	jsr PlinthAddInverse
	iny
	jsr PlinthAddInverse
	ldy #80
	jsr PlinthAddInverse
	iny
	jsr PlinthAddInverse
	
	;Mark Floor Table(Ground)
;	ldy PlinthIndex2XPOS,x
;	lda #
;	sta 

skip1	dex
	bpl loop1
.)
	rts

PlinthRemoveInverse
	lda (screen),y
	and #127
	sta (screen),y
	rts
PlinthAddInverse
	lda (screen),y
	ora #64
	sta (screen),y
	rts

#include "ssDefines.s"

PreviousFoot2PlinthIndex	.byt 128
CurrentStage	.byt 0
PlinthPatterns
;First set simple stepping left across playfield
 .byt HeroOnPlinth10+Stage0
 .byt TogglePlinth9,TogglePlinth8
 .byt HeroOnPlinth9+Stage0
 .byt TogglePlinth8,TogglePlinth10
 .byt HeroOnPlinth8+Stage0
 .byt TogglePlinth7,TogglePlinth9
 .byt HeroOnPlinth7+Stage0
 .byt TogglePlinth6,TogglePlinth8
 .byt HeroOnPlinth6+Stage0
 .byt TogglePlinth5,TogglePlinth7
 .byt HeroOnPlinth5+Stage0
 .byt TogglePlinth4,TogglePlinth6
 .byt HeroOnPlinth4+Stage0
 .byt TogglePlinth3,TogglePlinth5
 .byt HeroOnPlinth3+Stage0
 .byt TogglePlinth2,TogglePlinth4
 .byt HeroOnPlinth2+Stage0
 .byt TogglePlinth1,TogglePlinth3
 .byt HeroOnPlinth1+Stage0
 .byt TogglePlinth0,TogglePlinth2
 
PlinthStatii
 .dsb 10,0
 
;0123456789012345678901234567890123456789
;   0  1  2  3  4  5  6  7  8  9  A  
;   ---___---___---___---___---___---
Foot2PlinthIndex
 .byt 128,128,128
 .byt 0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9,10,10,10
 .byt 128,128,128,128
PlinthDone
 .dsb 10,0
PlinthScreenLo
 .byt <$B92B
 .byt <$B92B+3*1
 .byt <$B92B+3*2
 .byt <$B92B+3*3
 .byt <$B92B+3*4
 .byt <$B92B+3*5
 .byt <$B92B+3*6
 .byt <$B92B+3*7
 .byt <$B92B+3*8
 .byt <$B92B+3*9
 .byt <$B92B+3*10
PlinthScreenHi
 .byt >$B92B
 .byt >$B92B+3*1
 .byt >$B92B+3*2
 .byt >$B92B+3*3
 .byt >$B92B+3*4
 .byt >$B92B+3*5
 .byt >$B92B+3*6
 .byt >$B92B+3*7
 .byt >$B92B+3*8
 .byt >$B92B+3*9
 .byt >$B92B+3*10

Use a bitwise method as in 2 bytes to represent each xpos (based on stages still)
;Header..
;B0-7 Stage
;Data..
;+0
;B7 Plinth 0
;B6 Plinth 1
;B5 Plinth 2
;B4 Plinth 3
;B3 Plinth 4
;B2 Plinth 5
;B1 Plinth 6
;B0 Plinth 7
;+1
;B7 Plinth 8
;B6 Plinth 9
;B5 Plinth 10
;Each row represents(bitwise) the complete set of Plinths for each HeroX(Grounded)
;      01234567  89AB 
PlinthSetNormal
 .byt %11100000,%00000000	;0
 .byt %11100000,%00000000	;1
 .byt %11100000,%00000000	;2
 .byt %11100000,%00000000	;3
 .byt %01110000,%00000000     ;4
 .byt %01110000,%00000000     ;5
 .byt %01110000,%00000000     ;6
 .byt %00111000,%00000000     ;7
 .byt %00111000,%00000000     ;8
 .byt %00111000,%00000000     ;9
 .byt %00011100,%00000000     ;10
 .byt %00011100,%00000000     ;11
 .byt %00011100,%00000000     ;12
 .byt %00001110,%00000000     ;13
 .byt %00001110,%00000000     ;14
 .byt %00001110,%00000000     ;15
 .byt %00000111,%00000000     ;16
 .byt %00000111,%00000000     ;17
 .byt %00000111,%00000000     ;18
 .byt %00000011,%10000000     ;19
 .byt %00000011,%10000000     ;20
 .byt %00000011,%10000000     ;21
 .byt %00000001,%11000000     ;22
 .byt %00000001,%11000000     ;23
 .byt %00000001,%11000000     ;24
 .byt %00000000,%11100000     ;25
 .byt %00000000,%11100000     ;26
 .byt %00000000,%11100000     ;27
 .byt %00000000,%01110000     ;28
 .byt %00000000,%01110000     ;29
 .byt %00000000,%01110000     ;30
 .byt %00000000,%01110000     ;31
 .byt %00000000,%01110000     ;32
 .byt %00000000,%01110000     ;33
 .byt %00000000,%01110000     ;34
 .byt %00000000,%01110000     ;35
 .byt %00000000,%01110000     ;36
 .byt %00000000,%01110000     ;37
 .byt %00000000,%01110000     ;38
 .byt %00000000,%01110000     ;39
PlinthSetPerga 
;0123456789012345678901234567890123456789
;  ---___---___---___---___---___---___
