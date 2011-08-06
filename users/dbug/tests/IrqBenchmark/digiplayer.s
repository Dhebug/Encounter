
	.zero

/*	
Registers
	Reading/writing registers of the chip allows to control the powerful
	features. A register is read or written when the chip is selected and
	the low four address bits indicate the desired register:

	Address	Reg	                Description
			       (Write)       |	    (Read)	
	----------------------------------------------------------------
	$300 0000	ORB/IRB	Output Register B    | Input Register B
	$301 0001	ORA/IRA	Output Register A    | Input Register A
	$302 0010	DDRB	       Data Direction Register B
	$303 0011	DDRA	       Data Direction Register A
	$304 0100	T1L-L/T1C-L	   T1 low-order Latches | T1 low-order Counter
	$305 0101	T1C-H	       T1 high-order Counter
	$306 0110	T1L-L	       T1 low-order Latches
	$307 0111	T1L-H	       T1 high-order Latches
	$308 1000	T2L-L/T2C-L	   T2 low-order Latches | T2 low-order Counter
	$309 1001	T2C-H	       T2 high-order Counter
	$30a 1010	SR	           Shift Register
	$30b 1011	ACR	           Auxiliary Control Register
	$30c 1100	PCR	           Peripheral Control Register
	$30d 1101	IFR	           Interrupt Flag Register
	$30e 1110	IER	           Interrupt Enable Register
	$30f 1111	ORA/IRA	       Same as reg 1 except no handshake		
	
As two select lines of the PSG (BC1 and BDIR) are connected to the CA2 and CB2 lines of the VIA, you have to ensure the PCR (Peripheral Control Register) of the 6522 is correctly set in order to communicate with the PSG. 
As explained before, data to/from the PSG flows through a secondary bus connected to port A of the VIA. Selecting the PSG means asking it to read a register number (selecting one of its register), or reading/writing the previously selected register. 
Here are the four combinations: 
   
BDIR	BC1	
0		0		PSG not selected
0		1		Read PSG register
1		0		Write PSG register
1		1		Index register of PSG selected

Last but not least, note that register 14 (0Eh) of the PSG is an IO port (other flavors of the PSG, 8910 and 8913, have 0 or 2 IO ports). 
On the Oric, this IO port is used to select a column in the keyboard matrix, see the Keyboard chapter.	

From Twilighte's post on the forum: (http://forum.defence-force.org/viewtopic.php?t=30)

The AY-3-8912 is linked to the system by the way of one data/register port and 2 control lines. 
 The control lines are known as CA2 and CB2 since they are held within the VIA 6522 and may be set/reset in Memory location $030C. 
 The Data/Register Port is also used by the Printer Port (Which may also be attached to a joystick interface) and appears at location $030F. 

 The control line Register (Also known as the PCR) actually controls the behaviour of CA1,CA2,CB1 and CB2, but for the most part, we can get away with 3 values directly poked into this location. 
 The three values are... 
 $DD == $030F is inactive 
 $FD == $030F holds data for a preset Register 
 $FF == $030F holds a Register number

 So to write the value of 15 into register 8 (Volume of channel A) the following code could be used... 
 
	LDA #8 'Set the register to 8 
	STA $030F 
	LDA #$FF 
	STA $030C 
	LDA #$DD 
	STA $030C 
	
	LDA #15 'Set the Value for this register 
	STA $030F 
	LDA #$FD 
	STA $030C 
	LDA #$DD 'Reset the state of the control lines 
	STA $030C 
	
Write to location 0314 : 
   
bit 7: Eprom select (active low) 
bit 6-5: drive select (0 to 3) 
bit 4: side select 
bit 3: double density enable (0: double density, 1: single density) 
bit 2: along with bit 3, selects the data separator clock divisor            (1: double density, 0: single-density) 
bit 1: ROMDIS (active low). When 0, internal Basic rom is disabled. 
bit 0: enable FDC INTRQ to appear on read location $0314 and to drive cpu IRQ	

	lda $314
	and #%10011111
	ora DriveBitPair,x
	sta $314


Loading/storing irq:

- Zero page
	sta zp		; 3
	...
	lda zp		; 3

- Local patch
	sta bla+1	; 4
	...
  bla	
	lda #00		; 2
	

*/	

#define VIA_T1C_L	$304
#define VIA_T1L_L	$306
#define VIA_T1L_H	$307

#define VIA_T2C_L	$308
#define VIA_T2C_H	$309


#define VIA_PCR     $30c
#define VIA_ORA     $30f

#define VIA_TIMER_DELAY 250          // 4Khz
#define VBL_DECOUNT 80               // 80*50 => 4000 échantillons par seconde /2 => 2000 octets / seconde 

;  4000 hz=80*50
;  6400 hz=128*50
; 12800 hz=256*50 -> 3.2 fois


; 20 kb = 10 seconds
; 30 kb = 30 seconds
	
digiplayer_nextsample		.dsb 1

	.text

_OverlayAvailable			.byt 0


_Sei
  sei
  rts
  
_Cli
  cli
  rts

;
; Enable Overlay RAM, and try to write in it to see if a Microdisc is detected (because writing in ROM, is basicaly very hard !)
;
_DetectOverlay
.(
  sei
  jmp end_overlay	; Force skip the detection
  ldy $314
  lda #%11111101
  sta $314

  ldx $FFFF			; Save original value
  lda #1
  sta $FFFF
  cmp $FFFF
  bne end_overlay
  lda #2
  sta $FFFF
  cmp $FFFF
  bne end_overlay
  stx $FFFF			; Restore original value
  lda #$FF
  sta _OverlayAvailable
end_overlay	
  ;sty $314
  cli
  rts
.)

	
_DigiPlayer_InstallIrq
.(
	;jmp _DigiPlayer_InstallIrq
	sei
	
	// Prepare replay
	jsr _MakeSound

	// Set the VIA parameters
	lda #<VIA_TIMER_DELAY
	sta VIA_T1L_L
	lda #>VIA_TIMER_DELAY
	sta VIA_T1L_H
	
	// Install interrupt
	.(
	lda _OverlayAvailable
	beq use_rom_irq
use_fast_irq
	lda #<_InterruptCode_Low
	sta $fffe
	lda #>_InterruptCode_Low
	sta $ffff
	
	lda #$ff
	sta IrqIncAddr+1
	sta IrqDecAddr+1

	lda #$ff
	sta IrqIncAddr+2
	sta IrqDecAddr+2
		
	jmp end
		
use_rom_irq
	lda #<_InterruptCode_Low
	sta $245
	lda #>_InterruptCode_Low
	sta $246
end
	.)
		
	cli	

	rts
.)





_ProfilerTimer	.dsb 2

_ProfilerReset
.(
  lda #$ff
  sta VIA_T2C_L
  sta VIA_T2C_H  
  rts
.)

_ProfilerRead
.(
  lda VIA_T2C_L
  ldx VIA_T2C_H
  sta _ProfilerTimer+0
  stx _ProfilerTimer+1
  rts
.)
  
_ProfilerTest_20000_cycles  
Wait20000Cycles  
  jsr Wait5000Cycles	; 5000
  jsr Wait5000Cycles	; 5000
  jsr Wait5000Cycles	; 5000
  jsr Wait4000Cycles    ; 4000
  jsr Wait900Cycles  	; 900
  jsr Wait80Cycles  ; 80
  nop  				; 2
  nop  				; 2
  nop  				; 2
  nop  				; 2
  rts  					; 6
  ;                  	 +6 for jsr

Wait5000Cycles  
  jsr Wait1000Cycles	; 1000
Wait4000Cycles  
  jsr Wait1000Cycles	; 1000
  jsr Wait1000Cycles	; 1000
  jsr Wait1000Cycles	; 1000
  jsr Wait900Cycles  	; 900
  jsr Wait80Cycles  ; 80
  nop  				; 2
  nop  				; 2
  nop  				; 2
  nop  				; 2
  rts  					; 6
  ;                  	 +6 for jsr
  
    
Wait1000Cycles  
  jsr Wait100Cycles	; 100
Wait900Cycles  
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait100Cycles	; 100
  jsr Wait80Cycles  ; 80
  nop  				; 2
  nop  				; 2
  nop  				; 2
  nop  				; 2
  rts  				; 6
  ;                  +6 for jsr
  
Wait100Cycles  
  jsr Wait20Cycles	; 20
Wait80Cycles  
  jsr Wait20Cycles	; 20
Wait60Cycles  
  jsr Wait20Cycles	; 20
Wait40Cycles  
  jsr Wait20Cycles	; 20
  nop  				; 2
  nop  				; 2
  nop  				; 2
  nop  				; 2
  rts  				; 6
  ;                  +6 for jsr

Wait20Cycles
  nop  				; 2
  nop  				; 2
  nop  				; 2
  nop  				; 2
  rts  				; 6
  ;                  +6 for jsr
  
  

_MakeSound
	// Canal settings
	ldy #7
	ldx #%11111111
	jsr _PsgSetRegister

	// Volume
	ldy #10
	ldx #0
	jsr _PsgSetRegister
	rts


// y=control register
// x=data register
_PsgSetRegister
	sty	VIA_ORA

	lda	VIA_PCR
	ora	#$EE		; $EE	238	11101110
	sta	VIA_PCR
	lda #$CC		; $CC	204	11001100
	sta	VIA_PCR

	stx	VIA_ORA
	lda	#$EC		; $EC	236	11101100
	sta	VIA_PCR
	lda #$CC		; $CC	204	11001100
	sta	VIA_PCR
	rts




Counter .dsb 1


	.dsb 256-(*&255)


//
// Interrupt code that replay a sample using volume
//
// Interrupts article: http://www.6502.org/tutorials/interrupts.html
// To copy to zero page: http://forum.defence-force.org/viewtopic.php?t=525
// 7 cycles to call interrupt + 6 cycles for rti = 13 cycles total
_InterruptCode_Low	
	;jmp _InterruptCode_Low
IrqIncAddr	
	inc $246	; Switch to the second interrupt handler 
	bit VIA_T1C_L	; Clear IRQ event 

	sta save_a+1	; 5
    
auto_sample_read	
	lda _WelcomeSample			; 4
	beq end_of_sample			; 2 (+1)
	sta digiplayer_nextsample	; 3
	and #$0F					; 2

	sta	VIA_ORA
	lda	#$EC		; $EC 11101100 or $FD 11111101
	sta	VIA_PCR
	lda #$CC		; $CC 11001100 or $DD 11011101
	sta	VIA_PCR
	
	inc auto_sample_read+1		; 6
	beq end_of_page				; 2 (+1)

exit
	; Early exit
save_a	
	lda #123	; 2
	rti
	
end_of_page	
	inc auto_sample_read+2		; 6
	bne exit					; 2+1
	
end_of_sample	
	lda #<_WelcomeSample
	sta auto_sample_read+1
	lda #>_WelcomeSample
	sta auto_sample_read+2
	bne exit
_InterruptCode_Low_End
	


	.dsb 256-(*&255)

_InterruptCode_High
IrqDecAddr
	dec $246	; Switch to the first interrupt handler 
	bit VIA_T1C_L	; Clear IRQ event 
	
	sta save_a2+1	; 4

	;
	; Get sample high part 
	;	
	lda digiplayer_nextsample	; 3     (immediate=2)
	lsr							; 2x4=8
	lsr
	lsr
	lsr
	
	sta	VIA_ORA
	lda	#$EC		; $EC	236	11101100
	sta	VIA_PCR
	lda #$CC		; $CC	204	11001100
	sta	VIA_PCR

save_a2	
	lda #123	; 2
	rti
InterruptCode_High_End


	.dsb 256-(*&255)
; Here follow the sample file in memory
; Not alligning the sample start adds +2 to the profiler counter...
