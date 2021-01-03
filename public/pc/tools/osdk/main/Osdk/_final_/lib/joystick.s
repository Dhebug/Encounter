;
; Information about the various interfaces:
; https://wiki.defence-force.org/doku.php?id=oric:hardware:ijk_drivers
; Note: the VIA_xxxx are defined in header.s
;
; This file is based on the work of multiple individuals:
; - Euphoric
; - Twilighte
; - ISS
; - Kenneth
;

_OsdkJoystickType   .byt 0    ; Default to "do nothing"
_OsdkJoystick_0		.byt 0    ; Contains the data for the left joystick port (UDFLR)
_OsdkJoystick_1		.byt 0    ; Contains the data for the right joystick port (UDFLR)

_joystick_type_select
.(
	ldy _OsdkJoystickType
	cpy #6
	bcs invalid
	.(
	; We don't want an IRQ to happen while we are doing that
	php
	sei
	lda keyboard_list_low,y
	sta patch_joystick+1
	lda keyboard_list_high,y
	sta patch_joystick+2
	plp
	.)
invalid
	rts

keyboard_list_low
	.byt <_joystick_read_nothing
	.byt <_joystick_read_ijk
	.byt <_joystick_read_pase
	.byt <_joystick_read_telestrat
	.byt <_joystick_read_opel
	.byt <_joystick_read_dktronics

keyboard_list_high
	.byt >_joystick_read_nothing
	.byt >_joystick_read_ijk
	.byt >_joystick_read_pase
	.byt >_joystick_read_telestrat
	.byt >_joystick_read_opel
	.byt >_joystick_read_dktronics
.)

_joystick_read
	php
	sei

    lda #0
	sta _OsdkJoystick_0
	sta _OsdkJoystick_1

patch_joystick
	jsr _joystick_read_nothing

	plp
	rts


_joystick_read_nothing
.(
    // Not implemented
	rts
.)


;
; An unusual model that connects to the expansion bus and adds two registers ($310 and $320) 
; that can be read to return the status of the two joystick ports.
; 1 = UP
; 2 = DOWN
; 4 = FIRE
; 8 = LEFT
; 16 = RIGHT
_joystick_read_dktronics
.(
    lda #0
	sta _OsdkJoystick_0
	sta _OsdkJoystick_1
    lda $310                ; RLFDU -> UDFLR
    sta tmp+0
    lda $320                ; RLFDU -> UDFLR
    sta tmp+1


    ldx #5
loop_swap    
    lsr tmp+0
	rol _OsdkJoystick_0
    lsr tmp+1
	rol _OsdkJoystick_1
	dex
	bne loop_swap
	rts	
.)


_joystick_read_opel
.(
	; Save VIA Status
    LDA VIA_PORTB
    PHA
    LDA VIA_PORTAH
    PHA 
    LDA VIA_DDRB
    PHA 
    LDA VIA_DDRA
    PHA 

    LDA #$AF
    STA VIA_DDRB
    LDA #$FF
    STA VIA_DDRA
    LDA #$00
    STA VIA_PORTAH
    LDA #$10
    AND VIA_PORTB
    BNE end_opel

    .(

		LDA #$BF
        STA VIA_PORTB
        LDA #$7F
        STA VIA_PORTAH
        LDX #5
loop_rotate 
		LSR 
        AND VIA_PORTB
        ORA #$E0
        ROR VIA_PORTAH
        DEX 
        BNE loop_rotate      ; FULDR

		and #31
		tax
		lda OpelToIjk,x

		sta _OsdkJoystick_0
    .)


end_opel
	; Restore VIA Status
    PLA 
    STA VIA_DDRA
    PLA 
    STA VIA_DDRB
    PLA 
    STA VIA_PORTAH
    PLA 
    STA VIA_PORTB
	rts
.)

; ___FULDR
; ___UDFLR

OpelToIjk
	.byt %11111
	.byt %11110
	.byt %10111
	.byt %10110
	.byt %11101
	.byt %11100
	.byt %10101
	.byt %10100
	.byt %01111
	.byt %01110
	.byt %00111
	.byt %00110
	.byt %01101
	.byt %01100
	.byt %00101
	.byt %00100
	.byt %11011
	.byt %11010
	.byt %10011
	.byt %10010
	.byt %11001
	.byt %11000
	.byt %10001
	.byt %10000
	.byt %01011
	.byt %01010
	.byt %00011
	.byt %00010
	.byt %01001
	.byt %01000
	.byt %00001
	.byt %00000

; 
; Like the IJK interface, the PASE is connected on the printer port.
; This is one of the most supported interfaces, despite the fact it corrupts the sound.
; Variants from other companies exists, such as the Altai and Mageco interfaces
;
_joystick_read_pase
	; Configure DDRA
	lda #%11000000
	sta VIA_DDRA

	lda #%10000000
	sta VIA_PORTA
	lda VIA_PORTA         ; __FUD_RL to ___UDFLR
	and #63
	tax
	lda PaseToIjk,x
	sta _OsdkJoystick_0


	lda #%01000000
	sta VIA_PORTA
	lda VIA_PORTA
	and #63
	tax
	lda PaseToIjk,x
	sta _OsdkJoystick_1

	; Restore DDRA 
	lda #%11111111
	sta VIA_DDRA
	rts
  
; __FUD_RL 
; ___UDFLR

PaseToIjk
	.byt %111111
	.byt %111101
	.byt %111110
	.byt %111100
	.byt %011111
	.byt %011101
	.byt %011110
	.byt %011100
	.byt %110111
	.byt %110101
	.byt %110110
	.byt %110100
	.byt %010111
	.byt %010101
	.byt %010110
	.byt %010100
	.byt %101111
	.byt %101101
	.byt %101110
	.byt %101100
	.byt %001111
	.byt %001101
	.byt %001110
	.byt %001100
	.byt %100111
	.byt %100101
	.byt %100110
	.byt %100100
	.byt %000111
	.byt %000101
	.byt %000110
	.byt %000100
	.byt %111011
	.byt %111001
	.byt %111010
	.byt %111000
	.byt %011011
	.byt %011001
	.byt %011010
	.byt %011000
	.byt %110011
	.byt %110001
	.byt %110010
	.byt %110000
	.byt %010011
	.byt %010001
	.byt %010010
	.byt %010000
	.byt %101011
	.byt %101001
	.byt %101010
	.byt %101000
	.byt %001011
	.byt %001001
	.byt %001010
	.byt %001000
	.byt %100011
	.byt %100001
	.byt %100010
	.byt %100000
	.byt %000011
	.byt %000001
	.byt %000010
	.byt %000000


;
; The IJK joystick connects to the parallel port and uses the strobe line in a clever way 
; so that it could be prevented from corrupting sound.
; When the Strobe bit was set to Output(In DDRB) and low(PB4) then it enabled the interface.
;
; When the Strobe bit was set to Output(In DDRB) and low(PB4) then it enabled the interface.
;
; - B7 Select Right Joystick(Sockets were clearly identified)
; - B6 Select Left Joystick(Unlike Altai setting 11 will disable joys)
; - B5 Low whenever IJK joystick attached so could detect IJK Interface
; - B4 Up (Inverted)
; - B3 Down (Inverted)
; - B2 Fire (Inverted)
; - B1 Left (Inverted)
; - B0 Right (Inverted)
;
; Note that the order is identical to what the Telestrat returns
;
_joystick_read_ijk
.(
	; Save VIA Port A state
	php
	sei
	lda VIA_DDRA
	pha
	lda VIA_PORTAH
	pha

	; Ensure printer strobe is set to output
	lda VIA_DDRB
	ora #%00010000
	sta VIA_DDRB

	; Set strobe low
	lda VIA_PORTB
	and #%11101111
	sta VIA_PORTB

	; Set top two bits of Port A to output and rest as input
	lda #%11000000
	sta VIA_DDRA

	lda #%01000000        ; select left joystick
	sta VIA_PORTA         ; read back left joystick state              
	lda VIA_PORTA         ; UDFLR     
	and #%00011111        ; mask out unused bits              
	eor #%00011111        ; invert bits              
	sta _OsdkJoystick_0   ; store to variable

	lda #%10000000        ; select right joystick
	sta VIA_PORTA         ; read back right joystick state                            
	lda VIA_PORTA         ; UDFLR     
	and #%00011111        ; mask out unused bits              
	eor #%00011111        ; invert bits              
	sta _OsdkJoystick_1   ; store to variable
	
	lda VIA_PORTB         ; set strobe high
	ora #%00010000
	sta VIA_PORTB

	; Restore VIA Port A state
	pla
	sta VIA_PORTA
	pla
	sta VIA_DDRA
	plp
	rts   
.)


;
; The Telestrat (unlike all its predeccesors) had two joystick Ports positioned on either side of the machine. 
; Both were powered and both supported a second fire button. The Joystick (and second fire) was supported by Pulsoids. 
; Both joysticks were connected to Port B of the second VIA of the Telestrat whilst the second fire was connected to 
; Port A of the Second VIA (Location $032F)
;
; - B7 Select Right Joystick
; - B6 Select Left Joystick
; - B5 -
; - B4 Up (Inverted)
; - B3 Down (Inverted)
; - B2 Fire (Inverted)
; - B1 Left (Inverted)
; - B0 Right (Inverted)
;
; Note that the order is identical to what the IJK joystick interface returns
;
_joystick_read_telestrat
.(
	lda #%01000000         ; Select Left Joystick port
	sta VIA2_PORTB
	lda VIA2_PORTB         ; UDFLR     
	and #%00011111
	eor #%00011111
	sta _OsdkJoystick_0    ; store to variable

	lda #%10000000         ; Select Right Joystick port
	sta VIA2_PORTB
	lda VIA2_PORTB         ; UDFLR     
	and #%00011111
	eor #%00011111
	sta _OsdkJoystick_1    ; store to variable
	rts
.)


