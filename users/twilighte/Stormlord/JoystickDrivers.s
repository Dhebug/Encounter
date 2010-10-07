;JoystickDrivers.s
CheatCode5
 .byt "OOH THE WASTED BYTES"


;--FUD-RL
ReadPASE	lda #%11000000
       	sta VIA_DDRA
       	lda #%10000000
       	sta VIA_PORTA
       	lda VIA_PORTA
       	eor #%10111111
       	sta JoystickTemp
       	lda #%01000000
       	sta VIA_PORTA
       	lda VIA_PORTA
       	eor #%01111111
       	ora JoystickTemp
       	ora KeyRegister
       	sta KeyRegister
RestoreDDRA
       	lda #%11111111
       	sta VIA_DDRA
       	rts
       
;---UDFLR
ReadIJK	lda #%10110111
         	sta VIA_DDRB
         	lda #%00000000
         	sta VIA_PORTB
         	lda #%11000000
         	sta VIA_DDRA
         	
         	lda #%01111111
         	sta VIA_PORTA
         	lda VIA_PORTA
         	and #%00011111
         	eor #%00011111
         	sta JoystickTemp
         	lda #%10111111
         	sta VIA_PORTA
         	lda VIA_PORTA
         	and #%00011111
         	eor #%00011111
         	ora JoystickTemp
         	jsr ManipulateBits
         	jmp RestoreDDRA

;---UDFLR(Same as IJK) >> 
ReadTelestrat
	lda #%01000000
	sta VIA2_PORTB
	lda VIA2_PORTB
	and #%00011111
	eor #%00011111
	sta JoystickTemp
	lda #%10000000
	sta VIA2_PORTB
	lda VIA2_PORTB
	and #%00011111
	eor #%00011111
	ora JoystickTemp
ManipulateBits
	tax
         	lda GenericBitManip,x
	ora KeyRegister
       	sta KeyRegister
	rts

CheatCode4
 .byt "THE CHEAT CODE IS "
JoystickTemp	.byt 0
GenericBitManip
 .byt 0,2,1,3,32,34,33,0,8,10,9,0,40,42,41,0
 .byt 16,18,17,0,48,50,49,0,0,0,0,0,0,0,0,0
