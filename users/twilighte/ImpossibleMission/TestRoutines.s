;TestRoutines.s

TestCopyRomChars
	ldx #00
.(
loop1	lda $FC78,x
	sta $9900,x
	dex
	bne loop1
.)
	rts
	
TestDisplayByte	;Display byte in A in hires text window as hex
	pha
	lsr
	lsr
	lsr
	lsr
	jsr CalcHexDigit
	sta $BFB8
	pla
	jsr CalcHexDigit
	sta $BFB9
	rts


CalcHexDigit
	and #15
	cmp #10
.(
	bcc skip1
	adc #6
skip1	adc #48
.)
	rts
RowIndex		.byt 0
ColumnIndex	.byt 0
CollisionMapYLOCL
 .byt <CollisionMap
 .byt <CollisionMap+40*1
 .byt <CollisionMap+40*2
 .byt <CollisionMap+40*3
 .byt <CollisionMap+40*4
 .byt <CollisionMap+40*5
 .byt <CollisionMap+40*6
 .byt <CollisionMap+40*7
 .byt <CollisionMap+40*8
 .byt <CollisionMap+40*9
 .byt <CollisionMap+40*10
 .byt <CollisionMap+40*11
 .byt <CollisionMap+40*12
 .byt <CollisionMap+40*13
 .byt <CollisionMap+40*14
 .byt <CollisionMap+40*15
 .byt <CollisionMap+40*16
 .byt <CollisionMap+40*17
 .byt <CollisionMap+40*18
 .byt <CollisionMap+40*19
 .byt <CollisionMap+40*20
 .byt <CollisionMap+40*21
 .byt <CollisionMap+40*22
 .byt <CollisionMap+40*23
 .byt <CollisionMap+40*24
 .byt <CollisionMap+40*25
CollisionMapYLOCH
 .byt >CollisionMap
 .byt >CollisionMap+40*1
 .byt >CollisionMap+40*2
 .byt >CollisionMap+40*3
 .byt >CollisionMap+40*4
 .byt >CollisionMap+40*5
 .byt >CollisionMap+40*6
 .byt >CollisionMap+40*7
 .byt >CollisionMap+40*8
 .byt >CollisionMap+40*9
 .byt >CollisionMap+40*10
 .byt >CollisionMap+40*11
 .byt >CollisionMap+40*12
 .byt >CollisionMap+40*13
 .byt >CollisionMap+40*14
 .byt >CollisionMap+40*15
 .byt >CollisionMap+40*16
 .byt >CollisionMap+40*17
 .byt >CollisionMap+40*18
 .byt >CollisionMap+40*19
 .byt >CollisionMap+40*20
 .byt >CollisionMap+40*21
 .byt >CollisionMap+40*22
 .byt >CollisionMap+40*23
 .byt >CollisionMap+40*24
 .byt >CollisionMap+40*25

TestOverlayCollisionMapOnScreen
	lda #00
	sta RowIndex
.(
loop2	lda #00
	sta ColumnIndex
	
loop1	;Fetch Collision Byte
	ldy RowIndex
	lda CollisionMapYLOCL,y
	sta source
	lda CollisionMapYLOCH,y
	sta source+1
	ldy ColumnIndex
	lda (source),y
	
	;Convert to char to display
	and #31
	beq skip1
	tay
	lda TestCharGfxAddressLo,y
	sta source
	lda TestCharGfxAddressHi,y
	sta source+1
skip2


	;Fetch screen location
	lda RowIndex
	asl
	sta Temp01
	asl
	adc Temp01
	tay
	lda ColumnIndex
	jsr RecalcScreen
	
	;Store Char
	ldy #00
	lda (source),y
	
	sta (screen),y
	ldy #1
	lda (source),y
	ldy #40
	sta (screen),y
	ldy #2
	lda (source),y
	ldy #80
	sta (screen),y
	ldy #3
	lda (source),y
	ldy #120
	sta (screen),y
	ldy #4
	lda (source),y
	ldy #160
	sta (screen),y
	ldy #5
	lda (source),y
	ldy #200
	sta (screen),y

skip1	inc ColumnIndex
	lda ColumnIndex
	cmp #40
	bcc loop1
	
	inc RowIndex
	lda RowIndex
	cmp #25
	bcs skip3
	jmp loop2
skip3
.)
	rts
	
	
	
TestCharBackground
 .byt %01000000
 .byt %01000000
 .byt %01000000
 .byt %01000000
 .byt %01000000
 .byt %01000000
TestCharGfxAddressLo
 .byt <TestCharBackground
 .byt <Character87
 .byt <Character69
 .byt <Character80
 .byt <Character67
 .byt <TestCharBackground
 .byt <Character70
 .byt <Character70
 .byt <Character70
 .byt <Character70
 .byt <Character70
 .byt <Character70
 .byt <Character70
 .byt <Character70
 .byt <Character70
 .byt <Character70
 .byt <Character70
 .byt <Character70
 .byt <Character76
 .byt <Character76
 .byt <Character76
 .byt <Character76
 .byt <Character76
 .byt <Character76
 .byt <Character76
 .byt <Character76
 .byt <TestCharBackground
 .byt <TestCharBackground
 .byt <TestCharBackground
 .byt <TestCharBackground
TestCharGfxAddressHi
 .byt >TestCharBackground
 .byt >Character87		;$01 W
 .byt >Character69            ;$02 E
 .byt >Character80            ;$03 P 
 .byt >Character67            ;$04 C 
 .byt >TestCharBackground     ;$05    
 .byt >Character70            ;$08 F 
 .byt >Character70            ;$09    
 .byt >Character70            ;$0A    
 .byt >Character70            ;$0B    
 .byt >Character70            ;$0C    
 .byt >Character70            ;$0D    
 .byt >Character70            ;$0E    
 .byt >Character70            ;$0F    
 .byt >Character70            ;$10    
 .byt >Character70            ;$11    
 .byt >Character70            ;$12    
 .byt >Character70            ;$13    
 .byt >Character76            ;$14 L 
 .byt >Character76            ;$15    
 .byt >Character76            ;$16    
 .byt >Character76            ;$17    
 .byt >Character76            ;$18    
 .byt >Character76            ;$19    
 .byt >Character76            ;$1A    
 .byt >Character76            ;$1B    
 .byt >TestCharBackground
 .byt >TestCharBackground
 .byt >TestCharBackground
 .byt >TestCharBackground
