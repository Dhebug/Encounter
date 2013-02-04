        *= $100

; 22050 baud tape loading routine
; (~12600 bps)
; F.Frances 1999-2012

#define shifter $2F
#define ptr     $33
#define crc		$83

#define IRB	$0300
#define T2C	$0308
#define T2L	$0308
#define PCR	$030C
#define IFR	$030D
#define IER	$030E

#define LOW  <
#define HIGH >


//#define LOADING_EFFECT

		; Switch to hires and clear
		; bottom three lines

		jsr $EC33
#ifndef LOADING_EFFECT
		lda #16
		sta $bf68
		sta $bf68+40
		sta $bf68+80
#else
		ldx #40*3
		lda #0
loop
		sta $bf68,x
		dex 
		bpl loop
#endif
		jsr $E76A       ; init VIA (disable T1 interrupt) and set flag I
        lda #LOW(irq)   ; install IRQ handler
		sta $0245
        lda #HIGH(irq)
		sta $0246
        lda #$90
        sta IER         ; allow interrupt on CB1 active edge detection
        jsr $E59B       ; display 'loading <name>'
next_page
		jsr $E6C9	; load MSB of page address
		beq end_load
        sta ptr+1
        jsr $E6C9	; load LSB of page address
        sta ptr
        jsr $E6C9	; load CRC8
        sta crc
        jsr $E6C9	; load starting offset in page
        tay
        pha
        jsr load_page
        pla
        tay
        lda $02B1	; initialize CRC computation (normally 0)
compute_crc		; 154 cycles per byte => 40ms per page
        pha
		lda (ptr),y
		sta shifter
		pla
		ldx #8
divide_loop
		asl shifter
		rol 
		bcc *+4
		eor #$D5	; x^8+x^7+x^6+x^4+x^2+1 polynomial
		dex
		bne divide_loop	; 16 cycles per loop
		iny
		bne compute_crc
		eor crc		; compare with pre-computed crc
		beq next_page	; abort if wrong crc
end_load
		pha		; either a wrong crc or the 0 end-of-file marker
		jsr $E654	; display ERROR FOUND message if error detected
		lda #$22	; restore standard IRQ handler
		sta $0245
		lda #$EE
		sta $0246
		jsr $E93D	; restore VIA settings and clear flag I
		pla
		bne return	; don't autoexec if error found
        jmp $E8D6       ; handle auto-exec
        
load_page
        bit IRB         ; clear CB1 flag
		lda #$10
wait    bit IFR         ; wait next positive edge
		beq wait
        ldx #0          ; switch to negative edge detection
		stx PCR		
        bit IRB         ; clear CB1 flag
        dex
        stx T2L		; init T2L
        stx shifter	; shifter will roll without storing bytes until a 0 comes out        
		stx T2C+1	; restart T2 (26 to 33 µs after the edge)
		cli			; allow interrupts
waitme
        bne waitme           ; unconditional, wait for an interrupt (CB1 active edge)

irq			; irq handler modifies registers
        lda PCR         ; reverse active edge detection
		eor #$10
		sta PCR
        bit IRB         ; clear CB1 flag
        ldx T2C         ; load timer : 26 to 28 µs have passed since the active edge
        stx T2L+1       ; and restart a countdown (30 to 32 µs after the edge)
		and #$10
		bne high_level
low_level
		lda shifter
		cpx #110
		bcs short_low_level
long_low_level
		cpx #68		; C=0 if very long level
		bne shift_bits	; unconditional
short_low_level
		cpx #154	; C=1 if very short level
		bne rol_bits	; unconditional
high_level
		lda shifter
		cpx #99-3
		bcs short_high_level
long_high_level
		cpx #55		; C=0 if very long level
shift_bits
		rol 		; shift 00 if length=10
		asl 		;    or 10 if length=8
		bcc byte_complete
		bcs end_irq
short_high_level
		cpx #141	; C=1 if very short level
rol_bits
		rol 		; shift 01 if length=6
		rol 		;    or 11 if length=4
		bcs end_irq
byte_complete
		sta (ptr),y

#ifdef LOADING_EFFECT
		lda #%00000001
		eor $bf68+40
		sta $bf68+40
#endif

		iny
		beq end_page
		lda #$FE	; prepare shifter so that a 0 comes out after 4 interrupts
end_irq
		sta shifter
		rti		; flag I is reset on exit
end_page		
		; here flag I remains set on exit
		; end of page : switch back to positive edge detection
		lda #$10
		sta PCR
		pla		; pull flag register
		pla		; pull interrupt address to exit loadpage routine
		pla
return
		rts



