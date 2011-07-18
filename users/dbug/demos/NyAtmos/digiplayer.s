
	.zero

#define VIA_1     $30f
#define VIA_2     $30c

#define VIA_TIMER_DELAY 250          // 4Khz
#define VBL_DECOUNT 80               // 80*50 => 4000 échantillons par seconde /2 => 2000 octets / seconde 

; 20 kb = 10 seconds
; 30 kb = 30 seconds

IRQ_SAVE_A                  .dsb 1
IRQ_SAVE_X                  .dsb 1
IRQ_SAVE_Y                  .dsb 1
                              
IRQ_SAVE_A2                 .dsb 1
IRQ_SAVE_X2                 .dsb 1
IRQ_SAVE_Y2                 .dsb 1

digiplayer_sample_offset    .dsb 1
_vbl_counter				.dsb 1

	
digiplayer_start_sample
digiplayer_start_sample_low		.dsb 1
digiplayer_start_sample_high	.dsb 1


digiplayer_end_sample
digiplayer_end_sample_low		.dsb 1
digiplayer_end_sample_high		.dsb 1

digiplayer_frame_counter	.dsb 1

digiplayer_nextsample		.dsb 1

	.text

_DigiPlayer_InstallIrq
.(
	//jmp _InterruptInstall
	sei

	lda #0
	sta _vbl_counter
	
	// Prepare replay
	jsr _MakeSound

	lda #<_WelcomeSample
	sta digiplayer_start_sample_low
	lda #>_WelcomeSample
	sta digiplayer_start_sample_high

	lda #<_WelcomeSampleEnd
	sta digiplayer_end_sample_low
	lda #>_WelcomeSampleEnd
	sta digiplayer_end_sample_high

	// Number of frames to play
	lda #(_WelcomeSampleEnd-_WelcomeSample)/40
	sta digiplayer_frame_counter

	// Reset the IRQ counter to match the sample position
	lda #0
	sta digiplayer_sample_offset


	// Set the VIA parameters
	lda #<VIA_TIMER_DELAY
	sta $306
	lda #>VIA_TIMER_DELAY
	sta $307

	lda #0
	sta digiplayer_sample_offset

	// Install interrupt
	lda #<_InterruptCode_Low
	sta $245
	lda #>_InterruptCode_Low
	sta $246
	cli	

	rts
.)


;
; Come back only when there is at least one 50th of a second between two calls
;
_WaitSync
.(
  ldx #2	; 100/8=12.5hz, /4=25hz
sync  
.(
loop
  cpx _vbl_counter
  bcs loop
.)  
  ; Reset the counter after the test
  lda #0
  sei
  sta _vbl_counter
  cli
  rts
.)



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
	sty	VIA_1

	lda	VIA_2
	ora	#$EE		; $EE	238	11101110
	sta	VIA_2
	lda #$CC		; $CC	204	11001100
	sta	VIA_2

	stx	VIA_1
	lda	#$EC		; $EC	236	11101100
	sta	VIA_2
	lda #$CC		; $CC	204	11001100
	sta	VIA_2
	rts




Counter .dsb 1


	.dsb 256-(*&255)


//
// Interrupt code that replay a sample using volume
//

_InterruptCode_Low
	;jmp _InterruptCode_Low
.(
	bit $304

	sta IRQ_SAVE_A	; 3
	sty IRQ_SAVE_Y	; 3

	//
	// Get sample low part
	//
	ldy digiplayer_sample_offset
	lda (digiplayer_start_sample),y
	sta digiplayer_nextsample
	and #$0F

	sta	VIA_1
	lda	#$EC		; $EC	236	11101100
	sta	VIA_2
	lda #$CC		; $CC	204	11001100
	sta	VIA_2
	
	ldy IRQ_SAVE_Y	; 3
	lda IRQ_SAVE_A	; 3

	inc $246	; Switch to the second interrupt handler 
	rti
.)

	.dsb 256-(*&255)

_InterruptCode_High
.(
	bit $304	// VIA_T1CL ; Turn off interrupt early.  (More on that below
	
	sta IRQ_SAVE_A2
	sty IRQ_SAVE_Y2

	;
	; Get sample high part 
	;	
	lda digiplayer_nextsample
	lsr
	lsr
	lsr
	lsr
	
	sta	VIA_1
	lda	#$EC		; $EC	236	11101100
	sta	VIA_2
	lda #$CC		; $CC	204	11001100
	sta	VIA_2

	; Vbl
	ldy digiplayer_sample_offset
	iny
	sty digiplayer_sample_offset
	cpy #VBL_DECOUNT/2
	bne skip_vbl
	lda #0
	sta	digiplayer_sample_offset
	inc _vbl_counter

	; Called 50 timers per second (or every 80 interrupts)
.(
	.(
	clc
	lda digiplayer_start_sample+0
	adc #40
	sta digiplayer_start_sample+0
	bcc	skip
	inc digiplayer_start_sample+1
skip
	.)

	dec digiplayer_frame_counter
	bne skip_reset_sample

	lda #(_WelcomeSampleEnd-_WelcomeSample)/40
	sta digiplayer_frame_counter

	lda #<_WelcomeSample
	sta digiplayer_start_sample+0
	lda #>_WelcomeSample
	sta digiplayer_start_sample+1
skip_reset_sample
.)
	
skip_vbl

	lda IRQ_SAVE_A2
	ldy IRQ_SAVE_Y2

	dec $246	; Switch to the first interrupt handler 
	rti
.)





