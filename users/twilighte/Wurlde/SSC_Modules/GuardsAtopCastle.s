;GuardsAtopCastle.s
;Animate and move guards behind Battlement and turrets

GuardManage
	lda GuardDelayFrac
	clc
	adc #64
	sta GuardDelayFrac
.(
	bcc skip1
	ldx #03
loop1	jsr GuardMove
	jsr GuardPlot
	dex
	bpl loop1
skip1	rts
.)
GuardMove
	lda GuardDir,x
.(
	bne skip2
	dec GuardX,x
	lda GuardX,x
	cmp #11
	bcs skip1
	inc GuardDir,x
skip1	rts
skip2	inc GuardX,x
	lda GuardX,x
	cmp #218
	bcc skip1
.)
	dec GuardDir,x
	rts
	
	
GuardPlot
	ldy GuardX,x
	lda GuardXLoc,y
	clc
	adc #<$AE10
	sta screen
	lda #>$AE10
	adc #00
	sta screen+1
	lda GuardXLoc,y
	adc #<BattlementMaskRow0
	sta bgmask
	lda #>BattlementMaskRow0
	sta bgmask+1

	lda GuardBitpos,y
	tay
	lda GuardDir,x
.(
	bne skip1
	lda GuardFrameLeftAddressLo,y
	sta source
	lda GuardFrameLeftAddressHi,y
	sta source+1
	jmp skip2
skip1	lda GuardFrameRightAddressLo,y
	sta source
	lda GuardFrameRightAddressHi,y
	sta source+1
skip2	stx GuardTempX
	ldx #4
loop2	ldy #02
loop1	lda (source),y
	cmp #64
	bcc skip3
	and (bgmask),y
skip3	sta (screen),y
	dey
	bpl loop1
	lda #3
	jsr ssc_AddSource
	lda #40
	jsr ssc_AddBGMask
	jsr ssc_nl_screen
	jsr ssc_nl_screen
	dex
	bne loop2
.)
	ldx GuardTempX
	rts	
	
GuardX
 .byt 12,216,80,140
GuardDir
 .byt 1,0,1,0
 
GuardDelayFrac	.byt 0
GuardTempX	.byt 0

GuardBitpos
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
GuardXLoc
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
GuardFrameLeftAddressLo
 .byt <GuardFrameLeft05
 .byt <GuardFrameLeft04
 .byt <GuardFrameLeft03
 .byt <GuardFrameLeft02
 .byt <GuardFrameLeft01
 .byt <GuardFrameLeft00
GuardFrameLeftAddressHi
 .byt >GuardFrameLeft05
 .byt >GuardFrameLeft04
 .byt >GuardFrameLeft03
 .byt >GuardFrameLeft02
 .byt >GuardFrameLeft01
 .byt >GuardFrameLeft00
GuardFrameRightAddressLo
 .byt <GuardFrameRight00
 .byt <GuardFrameRight01
 .byt <GuardFrameRight02
 .byt <GuardFrameRight03
 .byt <GuardFrameRight04
 .byt <GuardFrameRight05
GuardFrameRightAddressHi
 .byt >GuardFrameRight00
 .byt >GuardFrameRight01
 .byt >GuardFrameRight02
 .byt >GuardFrameRight03
 .byt >GuardFrameRight04
 .byt >GuardFrameRight05

;01 of 06 frames for each bitpos and also oscillate spear up/down
GuardFrameRight00          
 .byt 4,%01010000,%01000000
 .byt 4,%01010000,%01000000
 .byt 4,%01011000,%01000000
 .byt 4,%01110000,%01000000
GuardFrameRight01          
 .byt 4,%01000000,%01000000
 .byt 4,%01001000,%01000000
 .byt 4,%01001100,%01000000
 .byt 4,%01001100,%01000000
GuardFrameRight02          
 .byt 4,%01000100,%01000000
 .byt 4,%01000100,%01000000
 .byt 4,%01000110,%01000000
 .byt 4,%01001100,%01000000
GuardFrameRight03          
 .byt 4,%01000000,%01000000
 .byt 4,%01000010,%01000000
 .byt 4,%01000011,%01000000
 .byt 4,%01000011,%01000000
GuardFrameRight04          
 .byt 4,%01000001,%01000000
 .byt 4,%01000001,%01000000
 .byt 4,%01000001,%01100000
 .byt 4,%01000011,%01000000
GuardFrameRight05          
 .byt 4,%01000000,%01000000
 .byt 4,%01000000,%01100000
 .byt 4,%01000000,%01110000
 .byt 4,%01000000,%01110000
GuardFrameLeft00           
 .byt 4,%01000000,%01000010
 .byt 4,%01000000,%01000010
 .byt 4,%01000000,%01000110
 .byt 4,%01000000,%01000011
GuardFrameLeft01           
 .byt 4,%01000000,%01000000
 .byt 4,%01000000,%01000100
 .byt 4,%01000000,%01001100
 .byt 4,%01000000,%01001100
GuardFrameLeft02           
 .byt 4,%01000000,%01001000
 .byt 4,%01000000,%01001000
 .byt 4,%01000000,%01011000
 .byt 4,%01000000,%01001100
GuardFrameLeft03           
 .byt 4,%01000000,%01000000
 .byt 4,%01000000,%01010000
 .byt 4,%01000000,%01110000
 .byt 4,%01000000,%01110000
GuardFrameLeft04           
 .byt 4,%01000000,%01100000
 .byt 4,%01000000,%01100000
 .byt 4,%01000001,%01100000
 .byt 4,%01000000,%01110000
GuardFrameLeft05           
 .byt 4,%01000000,%01000000
 .byt 4,%01000001,%01000000
 .byt 4,%01000011,%01000000
 .byt 4,%01000011,%01000000

;GuardFrameRight00          
; .byt 1,%01010000,%01000000 
; .byt 3,%01010000,%01000000 
; .byt 6,%01011000,%01000000 
; .byt 6,%01110000,%01000000 
;GuardFrameRight01           
; .byt 1,%01000000,%01000000 
; .byt 1,%01001000,%01000000 
; .byt 3,%01001100,%01000000 
; .byt 6,%01001100,%01000000 
;GuardFrameRight02           
; .byt 1,%01000100,%01000000 
; .byt 3,%01000100,%01000000 
; .byt 6,%01000110,%01000000 
; .byt 6,%01001100,%01000000 
;GuardFrameRight03           
; .byt 1,%01000000,%01000000 
; .byt 1,%01000010,%01000000 
; .byt 6,%01000011,%01000000 
; .byt 6,%01000011,%01000000 
;GuardFrameRight04           
; .byt 1,%01000001,%01000000 
; .byt 3,%01000001,%01000000 
; .byt 6,%01000001,%01100000 
; .byt 6,%01000011,%01000000 
;GuardFrameRight05           
; .byt 1,%01000000,%01000000 
; .byt 1,%01000000,%01100000 
; .byt 6,%01000000,%01110000 
; .byt 6,%01000000,%01110000 
;GuardFrameLeft00            
; .byt 1,%01000000,%01000010 
; .byt 3,%01000000,%01000010 
; .byt 6,%01000000,%01000110 
; .byt 6,%01000000,%01000011 
;GuardFrameLeft01            
; .byt 1,%01000000,%01000000 
; .byt 1,%01000000,%01000100 
; .byt 3,%01000000,%01001100 
; .byt 6,%01000000,%01001100 
;GuardFrameLeft02            
; .byt 1,%01000000,%01001000 
; .byt 3,%01000000,%01001000 
; .byt 6,%01000000,%01011000 
; .byt 6,%01000000,%01001100 
;GuardFrameLeft03            
; .byt 1,%01000000,%01000000 
; .byt 1,%01000000,%01010000 
; .byt 6,%01000000,%01110000 
; .byt 6,%01000000,%01110000 
;GuardFrameLeft04            
; .byt 1,%01000000,%01100000 
; .byt 3,%01000000,%01100000 
; .byt 6,%01000001,%01100000 
; .byt 6,%01000000,%01110000 
;GuardFrameLeft05            
; .byt 1,%01000000,%01000000 
; .byt 1,%01000001,%01000000 
; .byt 6,%01000011,%01000000 
; .byt 6,%01000011,%01000000 
 

;Based on 40x4
BattlementMaskRow0
 .byt $40,$40,$40,$40,$4F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$40,$40
 .byt $7F,$7F,$7F,$7F,$7F,$7E
 .byt $40,$40,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7C,$40,$40,$40,$40
BattlementMaskRow1
 .byt $40,$40,$40,$40,$4F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$40,$40
 .byt $7F,$7F,$7F,$7F,$7F,$7E
 .byt $40,$40,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7C,$40,$40,$40,$40
BattlementMaskRow2
 .byt $40,$40,$40,$40,$4F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7E,$40,$40
 .byt $7F,$7F,$7F,$7F,$7F,$7E
 .byt $40,$40,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7F,$7C,$40,$40,$40,$40
BattlementMaskRow3
 .byt $40,$40,$40,$40,$41,$71,$71,$71,$71,$71,$71,$71,$71,$71,$70,$40,$40
 .byt $71,$71,$71,$71,$71,$70
 .byt $40,$40,$71,$71,$71,$71,$71,$71,$71,$71,$71,$71,$70,$40,$40,$40,$40
