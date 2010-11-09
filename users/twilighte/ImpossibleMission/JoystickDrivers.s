;JoystickDrivers.s

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
       	ora InputRegister
       	sta InputRegister
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
	ora InputRegister
       	sta InputRegister
	rts

CheatCode4
 .byt "THE CHEAT CODE IS "
JoystickTemp	.byt 0
GenericBitManip
 .byt 0,2,1,3,32,34,33,0,8,10,9,0,40,42,41,0
 .byt 16,18,17,0,48,50,49,0,0,0,0,0,0,0,0,0

;1)Turn off IJK and detect PASE/ALTAI Left joystick fire 
;2)Turn off IJK and detect PASE/ALTAI Right joystick fire 
;3)Turn on IJK and detect Left joystick fire 
;4)Turn on IJK and detect Right joystick fire 
;5)Detect Telestrat Left Joystick fire on second VIA 
;6)Detect Telestrat Right Joystick fire on second VIA 
;7)Read Key type 1 Fire
;8)Read Key type 2 Fire

WaitOnControllerFire	;To detect Controller Type
	;Switch off potential IJK
	
	;Check PASE Left fire
