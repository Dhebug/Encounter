;Test autodetect joystick fire routine
#define	VIA_PORTB		$0300
#define	VIA_PORTAH	$0301
#define	VIA_DDRB		$0302
#define	VIA_DDRA		$0303
#define	VIA1_DDRA 	$0303
#define	VIA_T1CL		$0304
#define	VIA_T1CH            $0305
#define	VIA_T1LL            $0306
#define	VIA_T1LH            $0307
#define	VIA_T2LL            $0308
#define	VIA_T2CH            $0309
#define	VIA_PCR             $030C
#define	VIA_IFR		$030D
#define	VIA_IER		$030E
#define	VIA_PORTA           $030F

#define	VIA2_PORTB	$0320	;Telestrat Only
#define	VIA2_PORTAHS        $0321
#define	VIA2_DDRB           $0322
#define	VIA2_DDRA           $0323
#define	VIA2_T1CL           $0324
#define	VIA2_T1CH           $0325
#define	VIA2_T1LL           $0326
#define	VIA2_T1LH           $0327
#define	VIA2_T2LL           $0328
#define	VIA2_T2CH           $0329
#define	VIA2_SR             $032a
#define	VIA2_ACR            $032b
#define	VIA2_PCR            $032c
#define	VIA2_IFR            $032d
#define	VIA2_IER            $032e
#define	VIA2_PORTA          $032f

;#define	CHECKSUM_V10	
;#define	CHECKSUM_V11	


 .zero
*=$00
screen		.dsb 2
MachineROMsChecksum	.dsb 1

 .text
*=$500

Driver	jsr FetchROMChecksum
.(
loop1	nop
	jmp loop1
.)
.(
loop1
	jsr AutodetectJoystickByFire
	bcc loop1
.)
	;X holds Joystick type or Keyboard(0)
	lda JoyTypeText0,x
	sta $BB80
	lda JoyTypeText1,x
	sta $BB81
	lda JoyTypeText2,x
	sta $BB82
.(
loop2	nop
	jmp loop2
.)
	
	
JoyTypeText0
 .byt "KTIA
JoyTypeText1
 .byt "EEJL"
JoyTypeText2
 .byt "YLKT"



;Returns Controller Index (0-3) in X and Carry set if Fire was pressed
AutodetectJoystickByFire
	ldx #03

	;Turn off IJK interface (Set PB4 to Output/Zero)
	lda #%10100111
         	sta VIA_DDRB
         	
         	;Detect Altai Fire(Either joystick)
         	lda #%11000000
       	sta VIA_DDRA
       	sta VIA_PORTA
       	lda VIA_PORTA
       	eor #%10111111
.(
       	beq skip1
       	lda #17
       	sta $BB80
loop2	nop
       	jmp loop2
skip1	and #%00100000
.)
       	bne AltaiFirePressed
       	
       	dex
       	
       	;Turn on IJK
	lda #%10110111
         	sta VIA_DDRB
         	lda #%00000000
         	sta VIA_PORTB
         	
         	;Detect IJK Left Joystick fire
         	lda #%01111111
         	sta VIA_PORTA
         	lda VIA_PORTA
         	and #%00011111
         	eor #%00011111
         	and #1	;?
         	bne IJKFirePressed

         	;Detect IJK Right Joystick fire
         	lda #%10111111
         	sta VIA_PORTA
         	lda VIA_PORTA
         	and #%00011111
         	eor #%00011111
         	and #1	;?
         	bne IJKFirePressed
         	
         	dex
         	
	;Detect Telestrat
	lda VIA2_DDRA 
	cmp #%00010111 
	bne AvoidTelestratJoysticks
	cmp VIA1_DDRA 
	bne AvoidTelestratJoysticks
	
	;Could be second VIA in Atmos so additionally get
	;Checksum that was calculated at game boot
	lda MachineROMsChecksum
;	cmp #CHECKSUM_V10
	beq AvoidTelestratJoysticks
;	cmp #CHECKSUM_V11
	beq AvoidTelestratJoysticks
	
	;Detect Telestrat Joysticks
	lda #%11000000
          sta VIA2_PORTB
          lda VIA2_PORTB
          and #%00000100
          bne TelestratFirePressed

AvoidTelestratJoysticks
          dex

;	;Detect Keyboard Fire
;	lda KeyRegister
;	and #%00100000
;	bne KeyboardFire
	
	;No Fire
	clc
	rts
	
AltaiFirePressed
IJKFirePressed
TelestratFirePressed
KeyboardFire
	sec
	rts

FetchROMChecksum
	lda #<$C000
	sta screen
	lda #>$C000
	sta screen+1
	ldx #64
	ldy #00
	clc
	tya
.(
loop1	adc (screen),y
	iny
	bne loop1
	inc screen+1
	dex
	bne loop1
.)
	sta MachineROMsChecksum
	rts
