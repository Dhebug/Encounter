;Waterline.s - Rising and falling water level(2 step) overlapping harbour wall
;This needs to link in with the Inlay so we don't consume too much ram remembering the
;harbour wall we overlap.
;If done properly it would allow the waterline to almost reach the Top of the harbour wall
;in a heavy storm. We'd also need to include some wave effects?
;As a storm hits, the waterline colour changes to white(foam) and will rise and fall more
;rapidly.

;Plotting the waterline -
;The screen is scanned from the highest row the waterline can reach.
;If the waterline is not reached then the background harbour wall is restored otherwise
;the waterline graphic is displayed for the remaining rows(up to 29).
ProcWaterline
	lda WaterlineFrac
	clc
	adc #64
	sta WaterlineFrac
.(
	bcc skip4
	
	; Control height
	jsr ControlWaterlineHeight

skip4	; Plot waterline
	lda #<ScreenInlay+40*90
	sta source
	lda #>ScreenInlay+40*90
	sta source+1
	
	lda #<$B540
	sta screen
	lda #>$B540
	sta screen+1
	
	ldx #00

loop1	cpx wln_WaterlineHeight
	bcs skip1
	
	;Restore 2 rows of Harbour Wall
	ldy #79
loop2	lda (source),y
	sta (screen),y
	dey
	bpl loop2
	
	lda #80
	jsr ssc_AddSource
	lda #80
	jsr ssc_AddScreen
	
	inx
	inx
	cpx #27
	bcc loop1

	rts

skip1	;Plot Waterline
.)
	lda #<wln_WaterlineGraphic
	sta source
	lda #>wln_WaterlineGraphic
	sta source+1
.(	
loop1	ldy #79
loop2	lda (source),y
	sta (screen),y
	dey
	bpl loop2
	
	lda #80
	jsr ssc_AddSource
	lda #80
	jsr ssc_AddScreen
	
	inx
	inx
	cpx #27
	bcc loop1
.)
	rts


wln_WaterlineGraphic	;40x29(1160)
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64
 .byt 4,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
 .byt 127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127,127
wln_WaterlineHeight
 .byt 22
WaterlineFrac	.byt 0

;We could use a frac 2's compliment to achieve same sine without the extra tables.
ControlWaterlineHeight
	;Combine both surface and swell 2's compliment fracs
	lda #<wln_SwellTable
	sta source
	lda #>wln_SwellTable
	sta source+1
	ldy wln_SwellIndex
	ldx wln_SurfaceIndex
	
	;Surface Two's can be fixed
	lda wln_SurfaceTwos,x
	clc
	;But Swell Two's must be dynamic
	adc (source),y
	;Then add to current waterline height
	clc
	adc wln_WaterlineHeight
	;Check we don't exceed limits
	cmp #29
.(
	bcc skip1
	lda #29
skip1	sta wln_WaterlineHeight
.)
	;Cycle swell
	lda wln_SwellIndex
	clc
	adc #01
	and #15
	sta wln_SwellIndex
	;Cycle Surface
	lda wln_SurfaceIndex
	clc
	adc #01
	and #7
	sta wln_SurfaceIndex
	rts

;0-7
wln_SurfaceIndex	.byt 0
;7 long - smooth undulation
wln_SurfaceTwos
 .byt 254,255,0,1,2,1,0,255

;0-15
wln_SwellIndex	.byt 0
;15 long - Currently just one (no swell)
wln_SwellTable
 .byt 255,253,255,0,255,0,1,3,1,0,1,0,0,0,0,0

