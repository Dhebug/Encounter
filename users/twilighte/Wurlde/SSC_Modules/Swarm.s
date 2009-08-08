;Swarm.s
;Generate swarm of flies
;Black pixel mask over background following circular sequences

;  1 2 3
; 0      4
; 11     5
; 10     6
;  9 8 7
;
;At a random index in loop the fly(Up to 16) can switch tables to follow different trajectory.

;            2 3 4
;           1     5
;           0
;  1 2 3     6s
; 0     4s    5
;       0     4
;        1 2 3
;I think this requires 12*12*2 bytes for tables or 288 bytes

;Each table consists of 12 bytes, each byte defining a step in both x and y, plus or minus current position..
;B0-3 X Step and Direction
;B4-7 Y Step and Direction

;Their are clockwise and anticlockwise tables.
;At any position (0-11) the table and/or index may be changed.
;at every new position a check is made if the fly is at the screen boundaries
;(Ceiling,floor, left(6), right(239)).
;If at the boundaries then a different table is automatically chosen with 0 index and will
;only advance the fly if the random table selected takes the fly away from the boundary.
;This means the fly may appear to hover at times, which should be fine.

ProcSwarm

	ldx #15
fly_loop	;Delete fly
	jsr Fly_Delete
	;Cycle trajectory table
	jsr CyclicateTable
	;Move fly
	jsr NavigateFly
	;calculate screen location (can use xloc in y) and record it
	tya
	pha
	ldy fly_y,x
	clc
	adc game_sylocl,y	;SYLocl,y
	sta screen
	sta old_slocl,x
	lda game_syloch,y	;SYLoch,y
	adc #00
	sta screen+1
	sta old_sloch,x
	;record bitmap in bgbuffer for this location
	pla
	sbc #00
	clc
	adc game_bgbylocl,y
	sta fly_bgb+1
	lda game_bgbyloch,y
	adc #00
	sta fly_bgb+2
fly_bgb	lda $dead
	sta old_bg,x
	;Check that screen loc is a bitmap
	ldy #00
	lda (screen),y
	bmi fly_skip1
	cmp #64
	bcc fly_skip1
	;mask screen with fly's bitpos
	ldy fly_x,x
	lda flymask_xbit,y
	ldy #00
	and (screen),y
	sta (screen),y
fly_skip1	;proceed to next fly
	dex
	bpl fly_loop
	rts

Fly_Delete
	ldy fly_y,x
	lda game_sylocl,y	;SYLocl,y
	sta screen
	lda game_syloch,y	;SYLoch,y
	sta screen+1
	ldy fly_x,x
	lda fly_xloc,y
	tay
	lda old_bg,x
	sta (screen),y
	rts

CyclicateTable
	inc Fly_TrajectoryIndex,x
	lda Fly_TrajectoryIndex,x
	cmp #12
.(
	bcc fly_skip3
	;After full cycle look at change
	jsr fly_skip2
	lda #00
	sta Fly_TrajectoryIndex,x
fly_skip3	rts
.)

NavigateFly
	ldy Fly_TrajectoryIndex,x
traject	lda $dead,y
	pha
	lsr
	lsr
	lsr
	lsr
	tay
	lda fly_y,x
	clc
	adc TwosCompliment,y
	sta test_flyy
	pla
	and #15
	tay
	lda fly_x,x
	clc
	adc TwosCompliment,y
	sta test_flyx
	;Now check new position for fly
	cmp #7
	bcc fly_skip2
	cmp #238
	bcs fly_skip2
	;Calculate xloc from flyx
	tay
	lda fly_xloc,y
	tay
	;Now check flyy against ceiling height
	lda test_flyy
	cmp ct_CeilingLevel,y
	bcc fly_skip2
	cmp ct_FloorLevel,y
	bcs fly_skip2
	;store new position
	lda test_flyy
	sta fly_y,x
	lda test_flyx
	sta fly_x,x
	rts
fly_skip2	;Change direction
	lda fly_CurrentDirection,x
	eor #1
	sta fly_CurrentDirection,x
	tay
	;Reset index
	lda #00
	sta Fly_TrajectoryIndex,x
	;Select random table
	lda #11
	jsr game_GetRNDRange
	clc
	adc Fly_DirectionMultiplier,y
	tay
	lda FlyTrajectoryTablelo,y
	sta traject+1
	lda FlyTrajectoryTablehi,y
	sta traject+2

	ldy fly_x,x
	lda fly_xloc,y
	tay
	rts

fly_x
 .dsb 16,100
fly_y
 .dsb 16,30
fly_CurrentDirection
 .dsb 16,0
Fly_TrajectoryIndex
 .dsb 16,0
old_slocl
 .dsb 16,<$BFE0
old_sloch
 .dsb 16,>$BFE0
old_bg
 .dsb 16,255

test_flyx		.byt 0
test_flyy		.byt 0
Fly_DirectionMultiplier
 .byt 0,12
FlyTrajectoryTablelo
 .byt <frcTable0
 .byt <frcTable1
 .byt <frcTable2
 .byt <frcTable3
 .byt <frcTable4
 .byt <frcTable5
 .byt <frcTable6
 .byt <frcTable7
 .byt <frcTable8
 .byt <frcTable9
 .byt <frcTable10
 .byt <frcTable11
 .byt <fraTable0
 .byt <fraTable1
 .byt <fraTable2
 .byt <fraTable3
 .byt <fraTable4
 .byt <fraTable5
 .byt <fraTable6
 .byt <fraTable7
 .byt <fraTable8
 .byt <fraTable9
 .byt <fraTable10
 .byt <fraTable11
FlyTrajectoryTablehi
 .byt >frcTable0
 .byt >frcTable1
 .byt >frcTable2
 .byt >frcTable3
 .byt >frcTable4
 .byt >frcTable5
 .byt >frcTable6
 .byt >frcTable7
 .byt >frcTable8
 .byt >frcTable9
 .byt >frcTable10
 .byt >frcTable11
 .byt >fraTable0
 .byt >fraTable1
 .byt >fraTable2
 .byt >fraTable3
 .byt >fraTable4
 .byt >fraTable5
 .byt >fraTable6
 .byt >fraTable7
 .byt >fraTable8
 .byt >fraTable9
 .byt >fraTable10
 .byt >fraTable11
TwosCompliment
;     0   1   2   3   4   5   6   7   8 9 A B C D E F
 .byt 248,249,250,251,252,253,254,255,0,1,2,3,4,5,6,7
;     -8  -7  -6  -5  -4  -3  -2  -1  0 1 2 3 4 5 6 7
flymask_xbit
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
 .byt %01011111
 .byt %01101111
 .byt %01110111
 .byt %01111011
 .byt %01111101
 .byt %01111110
fly_xloc
 .dsb 6,0
 .dsb 6,1
 .dsb 6,2
 .dsb 6,3
 .dsb 6,4
 .dsb 6,5
 .dsb 6,6
 .dsb 6,7
 .dsb 6,8
 .dsb 6,9
 .dsb 6,10
 .dsb 6,11
 .dsb 6,12
 .dsb 6,13
 .dsb 6,14
 .dsb 6,15
 .dsb 6,16
 .dsb 6,17
 .dsb 6,18
 .dsb 6,19
 .dsb 6,20
 .dsb 6,21
 .dsb 6,22
 .dsb 6,23
 .dsb 6,24
 .dsb 6,25
 .dsb 6,26
 .dsb 6,27
 .dsb 6,28
 .dsb 6,29
 .dsb 6,30
 .dsb 6,31
 .dsb 6,32
 .dsb 6,33
 .dsb 6,34
 .dsb 6,35
 .dsb 6,36
 .dsb 6,37
 .dsb 6,38
 .dsb 6,39

;Full rotation clockwise tables
;   1 2 3
; 0       4
; 11      5
; 10      6
;   9 8 7
frcTable0
 .byt $A7
;   0 1 2
; 11      3
; 10      4
; 9       5
;   8 7 6
frcTable1
 .byt $A8
;   110 1
; 10      2
; 9       3
; 8       4
;   7 6 5
frcTable2
 .byt $A8
;   10110
; 9       1
; 8       2
; 7       3
;   6 5 4
frcTable3
 .byt $A9
;   9 1011
; 8       0
; 7       1
; 6       2
;   5 4 3
frcTable4
 .byt $89
;   8 9 10
; 7       11
; 6       0
; 5       1
;   4 3 2
frcTable5
 .byt $89
;   7 8 9
; 6       10
; 5       11
; 4       0
;   3 2 1
frcTable6
 .byt $69
;   6 7 8
; 5       9
; 4       10
; 3       11
;   2 1 0
frcTable7
 .byt $68
;   5 6 7
; 4       8
; 3       9
; 2       10
;   1 0 11
frcTable8
 .byt $68
;   4 5 6
; 3       7
; 2       8
; 1       9
;   0 1110
frcTable9
 .byt $67
;   3 4 5
; 2       6
; 1       7
; 0       8
;   11109
frcTable10
 .byt $87
;   2 3 4
; 1       5
; 0       6
; 11      7
;   109 8
frcTable11
 .byt $87
 .byt $A7
 .byt $A8
 .byt $A8
 .byt $A9
 .byt $89
 .byt $89
 .byt $69
 .byt $68
 .byt $68
 .byt $67
 .byt $87


 .byt 3
 .byt 2
 .byt 1
 .byt 0

;Full rotation anticlockwise tables
;   11109
; 0       8
; 1       7
; 2       6
;   3 4 5
fraTable0
 .byt $89
;   109 8
; 11      7
; 0       6
; 1       5
;   2 3 4
fraTable1
 .byt $89
;   9 8 7
; 10      6
; 11      5
; 0       4
;   1 2 3
fraTable2
 .byt $A9
;   8 7 6
; 9       5
; 10      4
; 11      3
;   0 1 2
fraTable3
 .byt $A8
;   7 6 5
; 8       4
; 9       3
; 10      2
;   110 1
fraTable4
 .byt $A8
;   6 5 4
; 7       3
; 8       2
; 9       1
;   10110
fraTable5
 .byt $A7
;   5 4 3
; 6       2
; 7       1
; 8       0
;   9 1011
fraTable6
 .byt $87
;   4 3 2
; 5       1
; 6       0
; 7       11
;   8 9 10
fraTable7
 .byt $87
;   3 2 1
; 4       0
; 5       11
; 6       10
;   7 8 9
fraTable8
 .byt $67
;   2 1 0
; 3       11
; 4       10
; 5       9
;   6 7 8
fraTable9
 .byt $68
;   1 0 11
; 2       10
; 3       9
; 4       8
;   5 6 7
fraTable10
 .byt $68
;   0 1110
; 1       9
; 2       8
; 3       7
;   4 5 6
fraTable11
 .byt $69
 .byt $89
 .byt $89
 .byt $A9
 .byt $A8
 .byt $A8
 .byt $A7
 .byt $87
 .byt $87
 .byt $67
 .byt $68
 .byt $68

;SYLocl
; .byt <$a758
; .byt <$a758+80*1
; .byt <$a758+80*2
; .byt <$a758+80*3
; .byt <$a758+80*4
; .byt <$a758+80*5
; .byt <$a758+80*6
; .byt <$a758+80*7
; .byt <$a758+80*8
; .byt <$a758+80*9
; .byt <$a758+80*10
; .byt <$a758+80*11
; .byt <$a758+80*12
; .byt <$a758+80*13
; .byt <$a758+80*14
; .byt <$a758+80*15
; .byt <$a758+80*16
; .byt <$a758+80*17
; .byt <$a758+80*18
; .byt <$a758+80*19
; .byt <$a758+80*20
; .byt <$a758+80*21
; .byt <$a758+80*22
; .byt <$a758+80*23
; .byt <$a758+80*24
; .byt <$a758+80*25
; .byt <$a758+80*26
; .byt <$a758+80*27
; .byt <$a758+80*28
; .byt <$a758+80*29
; .byt <$a758+80*30
; .byt <$a758+80*31
; .byt <$a758+80*32
; .byt <$a758+80*33
; .byt <$a758+80*34
; .byt <$a758+80*35
; .byt <$a758+80*36
; .byt <$a758+80*37
; .byt <$a758+80*38
; .byt <$a758+80*39
; .byt <$a758+80*40
; .byt <$a758+80*41
; .byt <$a758+80*42
; .byt <$a758+80*43
; .byt <$a758+80*44
; .byt <$a758+80*45
; .byt <$a758+80*46
; .byt <$a758+80*47
; .byt <$a758+80*48
; .byt <$a758+80*49
; .byt <$a758+80*50
; .byt <$a758+80*51
; .byt <$a758+80*52
; .byt <$a758+80*53
; .byt <$a758+80*54
; .byt <$a758+80*55
; .byt <$a758+80*56
; .byt <$a758+80*57
; .byt <$a758+80*58
; .byt <$a758+80*59
;SYLoch
; .byt >$a758
; .byt >$a758+80*1
; .byt >$a758+80*2
; .byt >$a758+80*3
; .byt >$a758+80*4
; .byt >$a758+80*5
; .byt >$a758+80*6
; .byt >$a758+80*7
; .byt >$a758+80*8
; .byt >$a758+80*9
; .byt >$a758+80*10
; .byt >$a758+80*11
; .byt >$a758+80*12
; .byt >$a758+80*13
; .byt >$a758+80*14
; .byt >$a758+80*15
; .byt >$a758+80*16
; .byt >$a758+80*17
; .byt >$a758+80*18
; .byt >$a758+80*19
; .byt >$a758+80*20
; .byt >$a758+80*21
; .byt >$a758+80*22
; .byt >$a758+80*23
; .byt >$a758+80*24
; .byt >$a758+80*25
; .byt >$a758+80*26
; .byt >$a758+80*27
; .byt >$a758+80*28
; .byt >$a758+80*29
; .byt >$a758+80*30
; .byt >$a758+80*31
; .byt >$a758+80*32
; .byt >$a758+80*33
; .byt >$a758+80*34
; .byt >$a758+80*35
; .byt >$a758+80*36
; .byt >$a758+80*37
; .byt >$a758+80*38
; .byt >$a758+80*39
; .byt >$a758+80*40
; .byt >$a758+80*41
; .byt >$a758+80*42
; .byt >$a758+80*43
; .byt >$a758+80*44
; .byt >$a758+80*45
; .byt >$a758+80*46
; .byt >$a758+80*47
; .byt >$a758+80*48
; .byt >$a758+80*49
; .byt >$a758+80*50
; .byt >$a758+80*51
; .byt >$a758+80*52
; .byt >$a758+80*53
; .byt >$a758+80*54
; .byt >$a758+80*55
; .byt >$a758+80*56
; .byt >$a758+80*57
; .byt >$a758+80*58
; .byt >$a758+80*59
